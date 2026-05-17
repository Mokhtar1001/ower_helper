import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../theme/app_theme.dart';
import 'login_page.dart';
import 'edit_profile_page.dart';

class ProviderProfilePage extends StatefulWidget {
  const ProviderProfilePage({super.key});

  @override
  State<ProviderProfilePage> createState() => _ProviderProfilePageState();
}

class _ProviderProfilePageState extends State<ProviderProfilePage> {
  Map<String, dynamic>? userData;
  int totalServices = 0;
  int completedServices = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProviderData();
  }

  Future<void> _loadProviderData() async {
    try {
      // TODO: Get actual user ID from AuthService
      final String mockUid = "mock_provider_123";

      final dbService = DatabaseService();
      final userDoc = await dbService.getUserProfile(mockUid);

      if (userDoc != null) {
        if (mounted) {
          setState(() {
            userData = userDoc;
            // TODO: Fetch from Node.js backend
            totalServices = 5;
            completedServices = 3;
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() => isLoading = false);
        }
      }
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading profile: $e')),
        );
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

    final String providerName =
        userData?['username'] ?? userData?['name'] ?? 'Provider';
    final String email = userData?['email'] ?? 'No email';
    final String phone = userData?['phone'] ?? 'No phone';
    final String initial =
        providerName.isNotEmpty ? providerName[0].toUpperCase() : 'P';

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Header Row
            Row(
              children: [
                Text(
                  'Provider Profile',
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfilePage(),
                      ),
                    ).then((_) => _loadProviderData());
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.edit_rounded,
                        color: AppColors.primary, size: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Avatar with gradient ring
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
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
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Name
            Text(
              providerName,
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),

            // Badge
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.verified_rounded,
                      color: AppColors.secondary, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    'Service Provider',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Contact Info Card
            GlassCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  _buildInfoRow(Icons.email_rounded, "Email", email),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Divider(
                      color: AppColors.surfaceBorder.withOpacity(0.5),
                      height: 1,
                    ),
                  ),
                  _buildInfoRow(Icons.phone_rounded, "Phone", phone),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Stats Cards
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    "Total Services",
                    totalServices.toString(),
                    Icons.business_center_rounded,
                    AppColors.primary,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _buildStatCard(
                    "Completed",
                    completedServices.toString(),
                    Icons.check_circle_rounded,
                    AppColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Quick Actions
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Quick Actions',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 12),

            _buildActionButton(
              icon: Icons.add_circle_outline_rounded,
              title: "Add New Service",
              color: AppColors.secondary,
              onTap: () => _showComingSoon('Add Service'),
            ),
            const SizedBox(height: 10),
            _buildActionButton(
              icon: Icons.list_alt_rounded,
              title: "View My Services",
              color: AppColors.primary,
              onTap: () => _showComingSoon('My Services'),
            ),
            const SizedBox(height: 10),
            _buildActionButton(
              icon: Icons.request_page_rounded,
              title: "Service Requests",
              color: AppColors.warning,
              onTap: () => _showComingSoon('Requests'),
            ),
            const SizedBox(height: 28),

            // Logout Button
            GestureDetector(
              onTap: _confirmLogout,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                  border:
                      Border.all(color: AppColors.error.withOpacity(0.3)),
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

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                color: AppColors.textMuted,
                fontSize: 12,
              ),
            ),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface.withOpacity(0.5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Icon(Icons.chevron_right_rounded,
                  color: AppColors.textMuted.withOpacity(0.6), size: 20),
            ],
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