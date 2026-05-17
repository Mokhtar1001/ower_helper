import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import 'login_page.dart';
  
class SignUpFormLayout extends StatefulWidget {
  final String role;
  const SignUpFormLayout({super.key, required this.role});

  @override
  State<SignUpFormLayout> createState() => _SignUpFormLayoutState();
}

class _SignUpFormLayoutState extends State<SignUpFormLayout>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  bool _agreeToTerms = false;

  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submitSignUp() async {
    if (!_agreeToTerms) {
      _showError('Please agree to Terms & Privacy Policy');
      return;
    }

    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        // Create user with Node.js backend via AuthService
        final authService = AuthService();
        final response = await authService.signUp(
          _usernameController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text.trim(),
          widget.role,
        );

        if (response == null) {
          throw Exception("Sign up failed");
        }

        if (!mounted) return;

        // Show verification dialog
        _showVerificationDialog();
      } catch (e) {
        _showError("An error occurred. Please try again.");
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  void _showVerificationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Verify Your Email'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.2),
                    AppColors.secondary.withOpacity(0.1),
                  ],
                ),
              ),
              child: const Icon(Icons.email_rounded, size: 48, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            Text(
              'A verification email has been sent to:\n${_emailController.text}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              'Please check your inbox and verify your email before logging in.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
            ),
          ],
        ),
        actions: [
          GradientButton(
            text: 'Go to Login',
            height: 44,
            icon: Icons.login_rounded,
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginFormLayout()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    IconData? prefixIcon,
    Widget? suffixIcon,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int index = 0,
  }) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _animController,
        curve: Interval(0.1 + index * 0.08, 0.6 + index * 0.08, curve: Curves.easeOut),
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _animController,
          curve: Interval(0.1 + index * 0.08, 0.6 + index * 0.08, curve: Curves.easeOutCubic),
        )),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: buildThemedField(
            controller: controller,
            label: label,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            obscureText: obscureText,
            keyboardType: keyboardType,
            validator: validator,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isProvider = widget.role == 'Provider';

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: AppColors.textPrimary),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    Text(
                      'Create Account',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 48), // balance
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Role Badge
                      FadeTransition(
                        opacity: _animController,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isProvider
                                  ? [AppColors.secondary.withOpacity(0.15), AppColors.secondary.withOpacity(0.05)]
                                  : [AppColors.primary.withOpacity(0.15), AppColors.primary.withOpacity(0.05)],
                            ),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: isProvider
                                  ? AppColors.secondary.withOpacity(0.3)
                                  : AppColors.primary.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isProvider ? Icons.business_center_rounded : Icons.person_rounded,
                                color: isProvider ? AppColors.secondary : AppColors.primary,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Registering as ${widget.role}',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isProvider ? AppColors.secondary : AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Form
                      GlassCard(
                        padding: const EdgeInsets.all(24),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              _buildField(
                                controller: _usernameController,
                                label: 'Username',
                                prefixIcon: Icons.person_outline_rounded,
                                index: 0,
                                validator: (value) {
                                  if (value == null || value.isEmpty) return "Username is required";
                                  if (value.length < 3) return "Username must be at least 3 characters";
                                  return null;
                                },
                              ),
                              _buildField(
                                controller: _emailController,
                                label: 'Email',
                                prefixIcon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                index: 1,
                                validator: (value) {
                                  if (value == null || value.isEmpty) return "Email is required";
                                  if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(value)) {
                                    return "Invalid email format";
                                  }
                                  return null;
                                },
                              ),
                              _buildField(
                                controller: _phoneController,
                                label: 'Phone Number',
                                prefixIcon: Icons.phone_outlined,
                                keyboardType: TextInputType.phone,
                                index: 2,
                                validator: (value) {
                                  if (value == null || value.isEmpty) return "Phone number is required";
                                  if (value.length < 10) return "Enter a valid phone number";
                                  return null;
                                },
                              ),
                              _buildField(
                                controller: _passwordController,
                                label: 'Password',
                                prefixIcon: Icons.lock_outline_rounded,
                                obscureText: _obscurePassword,
                                index: 3,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                    color: AppColors.textSecondary,
                                  ),
                                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) return "Password is required";
                                  if (value.length < 6) return "Password must be at least 6 characters";
                                  return null;
                                },
                              ),
                              _buildField(
                                controller: _confirmPasswordController,
                                label: 'Confirm Password',
                                prefixIcon: Icons.lock_outline_rounded,
                                obscureText: _obscureConfirmPassword,
                                index: 4,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                    color: AppColors.textSecondary,
                                  ),
                                  onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) return "Please confirm your password";
                                  if (value != _passwordController.text) return "Passwords do not match";
                                  return null;
                                },
                              ),

                              // Terms Checkbox
                              Row(
                                children: [
                                  SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: Checkbox(
                                      value: _agreeToTerms,
                                      onChanged: (value) {
                                        setState(() => _agreeToTerms = value ?? false);
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'I agree to the Terms & Privacy Policy',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),

                              // Sign Up Button
                              GradientButton(
                                text: 'Sign Up',
                                isLoading: _isLoading,
                                onPressed: _isLoading ? null : _submitSignUp,
                                icon: Icons.person_add_rounded,
                                gradient: isProvider
                                    ? const LinearGradient(
                                        colors: [AppColors.secondary, Color(0xFF00A888)],
                                      )
                                    : null,
                              ),
                              const SizedBox(height: 20),

                              // Already have account
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Already have an account? ',
                                    style: GoogleFonts.inter(
                                      color: AppColors.textSecondary,
                                      fontSize: 14,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Login',
                                        style: GoogleFonts.inter(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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