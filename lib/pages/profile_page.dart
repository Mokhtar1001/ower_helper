import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../theme/app_theme.dart';
import 'package:ower_project/pages/profile_provider_page.dart';
import 'login_page.dart';

// Main Profile Page - Routes to correct profile based on role
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoading = true;
  String? userRole;

  @override
  void initState() {
    super.initState();
    _checkUserRole();
  }

  Future<void> _checkUserRole() async {
    try {
      // TODO: Get actual user ID from AuthService
      final String mockUid = "mock_user_123";
      
      final dbService = DatabaseService();
      final doc = await dbService.getUserProfile(mockUid);
      
      if (doc != null) {
        if (mounted) {
          setState(() {
            userRole = doc['role'];
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() => isLoading = false);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SafeArea(
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    // Route to correct profile page based on role
    if (userRole == 'Provider') {
      return const ProviderProfilePage();
    } else {
      return const ClientProfilePage();
    }
  }
}

// CLIENT PROFILE PAGE
class ClientProfilePage extends StatefulWidget {
  const ClientProfilePage({super.key});

  @override
  State<ClientProfilePage> createState() => _ClientProfilePageState();
}

class _ClientProfilePageState extends State<ClientProfilePage> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

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
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() => isLoading = false);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SafeArea(
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    final String displayName =
        userData?['username'] ?? userData?['name'] ?? 'User';
    final String email = userData?['email'] ?? 'No email';
    final String phone = userData?['phone'] ?? 'No phone';
    final String initial =
        displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U';

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),

            // Profile Header with Gradient Avatar
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.accentGradient,
                    ),
                    child: CircleAvatar(
                      radius: 48,
                      backgroundColor: AppColors.surface,
                      child: Text(
                        initial,
                        style: GoogleFonts.inter(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    displayName,
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Client',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Contact Info Card
            GlassCard(
              padding: const EdgeInsets.all(4),
              child: Column(
                children: [
                  _buildInfoTile(Icons.email_rounded, 'Email', email),
                  Divider(
                    color: AppColors.surfaceBorder.withOpacity(0.5),
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                  ),
                  _buildInfoTile(Icons.phone_rounded, 'Phone', phone),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Account Settings
            Text(
              'Account Settings',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            _buildOptionItem(
              icon: Icons.shopping_bag_rounded,
              title: 'My Requests',
              color: AppColors.primary,
              onTap: () => _showComingSoon('My Requests'),
            ),
            _buildOptionItem(
              icon: Icons.notifications_rounded,
              title: 'Notifications',
              color: AppColors.warning,
              onTap: () => _showComingSoon('Notifications'),
            ),
            _buildOptionItem(
              icon: Icons.settings_rounded,
              title: 'Settings',
              color: AppColors.secondary,
              onTap: () => _showComingSoon('Settings'),
            ),
            _buildOptionItem(
              icon: Icons.help_outline_rounded,
              title: 'Help & Support',
              color: AppColors.info,
              onTap: () => _showComingSoon('Help'),
            ),
            _buildOptionItem(
              icon: Icons.privacy_tip_outlined,
              title: 'Terms & Privacy',
              color: AppColors.textMuted,
              onTap: () => _showComingSoon('Terms'),
            ),

            const SizedBox(height: 28),

            // Logout Button
            GestureDetector(
              onTap: () => _confirmLogout(),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.error.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.logout_rounded,
                        color: AppColors.error, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Logout',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          color: AppColors.textMuted,
          fontSize: 12,
        ),
      ),
      subtitle: Text(
        value,
        style: GoogleFonts.inter(
          color: AppColors.textPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildOptionItem({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surface.withOpacity(0.5),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.surfaceBorder.withOpacity(0.5)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right_rounded,
                    color: AppColors.textMuted, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature — Coming Soon'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _confirmLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          GradientButton(
            text: 'Logout',
            width: 100,
            height: 42,
            gradient: const LinearGradient(
              colors: [AppColors.error, Color(0xFFCC3344)],
            ),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await AuthService().signOut();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginFormLayout()),
          (route) => false,
        );
      }
    }
  }
}