import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'signup_page.dart';

class ChooseRolePage extends StatefulWidget {
  const ChooseRolePage({super.key});

  @override
  State<ChooseRolePage> createState() => _ChooseRolePageState();
}

class _ChooseRolePageState extends State<ChooseRolePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Back button
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: AppColors.textPrimary),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const Spacer(),

                // Title
                FadeTransition(
                  opacity: CurvedAnimation(
                    parent: _controller,
                    curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
                  ),
                  child: Column(
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) =>
                            AppColors.accentGradient.createShader(bounds),
                        child: Text(
                          'Who are you?',
                          style: GoogleFonts.inter(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Select your role to continue',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),

                // Provider Card
                _buildAnimatedRoleCard(
                  role: 'Provider',
                  icon: Icons.business_center_rounded,
                  description: 'I provide services to clients',
                  gradientColors: [AppColors.secondary, const Color(0xFF00A888)],
                  animInterval: const Interval(0.2, 0.7, curve: Curves.easeOutCubic),
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) =>
                            const SignUpFormLayout(role: "Provider"),
                        transitionsBuilder: (_, animation, __, child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1.0, 0.0),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutCubic,
                            )),
                            child: child,
                          );
                        },
                        transitionDuration: const Duration(milliseconds: 350),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // Client Card
                _buildAnimatedRoleCard(
                  role: 'Client',
                  icon: Icons.person_rounded,
                  description: "I'm looking for services",
                  gradientColors: [AppColors.primary, AppColors.primaryDark],
                  animInterval: const Interval(0.35, 0.85, curve: Curves.easeOutCubic),
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) =>
                            const SignUpFormLayout(role: "Client"),
                        transitionsBuilder: (_, animation, __, child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1.0, 0.0),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutCubic,
                            )),
                            child: child,
                          );
                        },
                        transitionDuration: const Duration(milliseconds: 350),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),

                // Back to Login
                FadeTransition(
                  opacity: CurvedAnimation(
                    parent: _controller,
                    curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
                  ),
                  child: TextButton(
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
                ),

                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedRoleCard({
    required String role,
    required IconData icon,
    required String description,
    required List<Color> gradientColors,
    required Interval animInterval,
    required VoidCallback onTap,
  }) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: _controller, curve: animInterval),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: _controller, curve: animInterval)),
        child: _RoleCard(
          role: role,
          icon: icon,
          description: description,
          gradientColors: gradientColors,
          onTap: onTap,
        ),
      ),
    );
  }
}

class _RoleCard extends StatefulWidget {
  final String role;
  final IconData icon;
  final String description;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  const _RoleCard({
    required this.role,
    required this.icon,
    required this.description,
    required this.gradientColors,
    required this.onTap,
  });

  @override
  State<_RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<_RoleCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _tapController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _tapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _tapController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _tapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnim,
      builder: (context, child) {
        return Transform.scale(scale: _scaleAnim.value, child: child);
      },
      child: GestureDetector(
        onTapDown: (_) => _tapController.forward(),
        onTapUp: (_) {
          _tapController.reverse();
          widget.onTap();
        },
        onTapCancel: () => _tapController.reverse(),
        child: GlassCard(
          padding: const EdgeInsets.all(24),
          borderColor: widget.gradientColors[0].withOpacity(0.3),
          child: Row(
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      widget.gradientColors[0].withOpacity(0.2),
                      widget.gradientColors[1].withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  widget.icon,
                  size: 32,
                  color: widget.gradientColors[0],
                ),
              ),
              const SizedBox(width: 16),
              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.role,
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: widget.gradientColors[0],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.description,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: widget.gradientColors[0],
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}