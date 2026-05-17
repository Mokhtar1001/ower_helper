import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/database_service.dart';
import '../theme/app_theme.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      // TODO: Get actual user ID from AuthService
      final String mockUid = "mock_user_123";

      final dbService = DatabaseService();
      final doc = await dbService.getUserProfile(mockUid);

      if (doc != null) {
        if (mounted) {
          setState(() {
            userData = doc;
            _usernameController.text =
                userData?['username'] ?? userData?['name'] ?? '';
            _phoneController.text = userData?['phone'] ?? '';
          });
        }
      }
    } catch (e) {
      _showError('Error loading profile: $e');
    }
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        // TODO: Get actual user ID from AuthService
        final String mockUid = "mock_user_123";

        final dbService = DatabaseService();
        await dbService.updateUserProfile(mockUid, {
          'username': _usernameController.text.trim(),
          'phone': _phoneController.text.trim(),
        });

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: AppColors.success,
          ),
        );

        Navigator.pop(context);
      } catch (e) {
        _showError('Error updating profile: $e');
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  Future<void> _changePassword() async {
    if (_passwordFormKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        // TODO: Implement HTTP request to Node.js backend for password change
        await Future.delayed(const Duration(seconds: 1)); // Simulate network call

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password changed successfully! (Mocked)'),
            backgroundColor: AppColors.success,
          ),
        );

        // Clear password fields
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
      } catch (e) {
        _showError('Error changing password: $e');
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: AppColors.textPrimary),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    Text(
                      'Edit Profile',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Information Section
                      Text(
                        'Profile Information',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),

                      GlassCard(
                        padding: const EdgeInsets.all(24),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // Username Field
                              buildThemedField(
                                controller: _usernameController,
                                label: 'Username',
                                prefixIcon: Icons.person_outline_rounded,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Username is required';
                                  }
                                  if (value.length < 3) {
                                    return 'Username must be at least 3 characters';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              // Phone Field
                              buildThemedField(
                                controller: _phoneController,
                                label: 'Phone Number',
                                prefixIcon: Icons.phone_outlined,
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Phone number is required';
                                  }
                                  if (value.length < 10) {
                                    return 'Enter a valid phone number';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              // Email Field (Read-only)
                              TextFormField(
                                initialValue:
                                    userData?['email'] ?? 'user@example.com',
                                enabled: false,
                                style: GoogleFonts.inter(
                                    color: AppColors.textMuted, fontSize: 15),
                                decoration: InputDecoration(
                                  labelText: 'Email (Cannot be changed)',
                                  prefixIcon: const Icon(Icons.email_outlined),
                                  fillColor: AppColors.surfaceLight,
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Update Profile Button
                              GradientButton(
                                text: 'Save Changes',
                                icon: Icons.save_rounded,
                                isLoading: _isLoading,
                                onPressed:
                                    _isLoading ? null : _updateProfile,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Change Password Section
                      Container(
                        height: 1,
                        color: AppColors.surfaceBorder,
                      ),
                      const SizedBox(height: 24),

                      Text(
                        'Change Password',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),

                      GlassCard(
                        padding: const EdgeInsets.all(24),
                        child: Form(
                          key: _passwordFormKey,
                          child: Column(
                            children: [
                              // Current Password
                              buildThemedField(
                                controller: _currentPasswordController,
                                label: 'Current Password',
                                prefixIcon: Icons.lock_outline_rounded,
                                obscureText: _obscureCurrentPassword,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureCurrentPassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: AppColors.textSecondary,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureCurrentPassword =
                                          !_obscureCurrentPassword;
                                    });
                                  },
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Current password is required';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              // New Password
                              buildThemedField(
                                controller: _newPasswordController,
                                label: 'New Password',
                                prefixIcon: Icons.lock_rounded,
                                obscureText: _obscureNewPassword,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureNewPassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: AppColors.textSecondary,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureNewPassword =
                                          !_obscureNewPassword;
                                    });
                                  },
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'New password is required';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              // Confirm New Password
                              buildThemedField(
                                controller: _confirmPasswordController,
                                label: 'Confirm New Password',
                                prefixIcon: Icons.lock_clock_rounded,
                                obscureText: _obscureConfirmPassword,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirmPassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: AppColors.textSecondary,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureConfirmPassword =
                                          !_obscureConfirmPassword;
                                    });
                                  },
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please confirm your password';
                                  }
                                  if (value !=
                                      _newPasswordController.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 24),

                              // Change Password Button
                              GradientButton(
                                text: 'Change Password',
                                icon: Icons.key_rounded,
                                isLoading: _isLoading,
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.warning,
                                    Color(0xFFE8940A),
                                  ],
                                ),
                                onPressed:
                                    _isLoading ? null : _changePassword,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}