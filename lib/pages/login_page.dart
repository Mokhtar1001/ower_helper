import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../theme/app_theme.dart';
import 'choose_role_page.dart';
import 'home_page.dart';

class LoginFormLayout extends StatefulWidget {
  const LoginFormLayout({super.key});

  @override
  State<LoginFormLayout> createState() => _LoginFormLayoutState();
}

class _LoginFormLayoutState extends State<LoginFormLayout>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _rememberMe = false;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _checkRememberMe();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _checkRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('saved_email');
    final savedPassword = prefs.getString('saved_password');
    final rememberMe = prefs.getBool('remember_me') ?? false;

    if (rememberMe && savedEmail != null && savedPassword != null) {
      setState(() {
        _emailController.text = savedEmail;
        _passwordController.text = savedPassword;
        _rememberMe = true;
      });
    }
  }

  Future<void> _saveCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setString('saved_email', _emailController.text.trim());
      await prefs.setString('saved_password', _passwordController.text.trim());
      await prefs.setBool('remember_me', true);
    } else {
      await prefs.remove('saved_email');
      await prefs.remove('saved_password');
      await prefs.setBool('remember_me', false);
    }
  }

  Future<void> _submitLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        // Login with Node.js backend via AuthService
        final authService = AuthService();
        final user = await authService.login(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        if (user == null) {
          throw Exception("Login failed");
        }

        // Save credentials if Remember Me is checked
        await _saveCredentials();

        // Get user role from DatabaseService
        final dbService = DatabaseService();
        final userDoc = await dbService.getUserProfile(user['uid']);

        if (userDoc != null) {
          String role = userDoc['role'] ?? 'Student';
          
          if (!mounted) return;
          
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => HomePage(role: role),
              transitionsBuilder: (_, animation, __, child) {
                return FadeTransition(opacity: animation, child: child);
              },
              transitionDuration: const Duration(milliseconds: 400),
            ),
          );
        } else {
          if (!mounted) return;
          _showError("User data not found. Please contact support.");
        }
      } catch (e) {
        _showError("An error occurred. Please try again.");
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  Future<void> _forgotPassword() async {
    final emailController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enter your email to receive a password reset link.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          GradientButton(
            text: 'Send',
            width: 100,
            height: 44,
            onPressed: () {
              final email = emailController.text.trim();
              if (email.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter your email')),
                );
                return;
              }

              // TODO: Implement HTTP request to Node.js backend for password reset
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Password reset feature coming soon!'),
                    backgroundColor: AppColors.warning,
                  ),
                );
              }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        // Logo Row
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.school_rounded,
                                size: 24,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Uni Helper',
                              style: GoogleFonts.inter(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 50),

                        // Main Card
                        GlassCard(
                          padding: const EdgeInsets.all(28),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Welcome text
                              ShaderMask(
                                shaderCallback: (bounds) =>
                                    AppColors.accentGradient
                                        .createShader(bounds),
                                child: Text(
                                  'Welcome Back',
                                  style: GoogleFonts.inter(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Sign in to continue',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Icon
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
                                child: const Icon(
                                  Icons.handyman_rounded,
                                  size: 40,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 28),

                              // Email Field
                              buildThemedField(
                                controller: _emailController,
                                label: 'Email',
                                hint: 'Enter your email',
                                prefixIcon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Email is required";
                                  }
                                  if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w]{2,4}$')
                                      .hasMatch(value)) {
                                    return "Enter a valid email";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 18),

                              // Password Field
                              buildThemedField(
                                controller: _passwordController,
                                label: 'Password',
                                hint: 'Enter your password',
                                prefixIcon: Icons.lock_outline,
                                obscureText: _obscurePassword,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: AppColors.textSecondary,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Password is required";
                                  }
                                  if (value.length < 6) {
                                    return "Password must be at least 6 characters";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),

                              // Remember Me & Forgot Password
                              Row(
                                children: [
                                  SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: Checkbox(
                                      value: _rememberMe,
                                      onChanged: (value) {
                                        setState(() {
                                          _rememberMe = value ?? false;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Remember Me',
                                    style: GoogleFonts.inter(
                                      color: AppColors.textSecondary,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const Spacer(),
                                  TextButton(
                                    onPressed: _forgotPassword,
                                    child: Text(
                                      'Forgot Password?',
                                      style: GoogleFonts.inter(
                                        color: AppColors.secondary,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),

                              // Login Button
                              GradientButton(
                                text: 'LOGIN',
                                isLoading: _isLoading,
                                onPressed: _isLoading ? null : _submitLogin,
                                icon: Icons.login_rounded,
                              ),
                              const SizedBox(height: 24),

                              // Divider
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 1,
                                      color: AppColors.surfaceBorder,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Text(
                                      'OR',
                                      style: GoogleFonts.inter(
                                        color: AppColors.textMuted,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 1,
                                      color: AppColors.surfaceBorder,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),

                              // Sign Up Link
                              TextButton(
                                onPressed: _isLoading
                                    ? null
                                    : () {
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (_, __, ___) =>
                                                const ChooseRolePage(),
                                            transitionsBuilder:
                                                (_, animation, __, child) {
                                              return SlideTransition(
                                                position: Tween<Offset>(
                                                  begin:
                                                      const Offset(1.0, 0.0),
                                                  end: Offset.zero,
                                                ).animate(CurvedAnimation(
                                                  parent: animation,
                                                  curve: Curves.easeOutCubic,
                                                )),
                                                child: child,
                                              );
                                            },
                                            transitionDuration:
                                                const Duration(
                                                    milliseconds: 350),
                                          ),
                                        );
                                      },
                                child: RichText(
                                  text: TextSpan(
                                    text: "Don't have an account? ",
                                    style: GoogleFonts.inter(
                                      color: AppColors.textSecondary,
                                      fontSize: 14,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Create one',
                                        style: GoogleFonts.inter(
                                          color: AppColors.primary,
                                          fontSize: 14,
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
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}