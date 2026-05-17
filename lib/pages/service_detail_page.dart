import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class ServicesDetailsPage extends StatelessWidget {
  final Map<String, dynamic> serviceData;

  const ServicesDetailsPage({
    super.key,
    required this.serviceData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
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
                      'Service Details',
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
                      // Hero Header
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary.withOpacity(0.15),
                              AppColors.secondary.withOpacity(0.08),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                _getServiceIcon(serviceData['name']),
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              serviceData['name'],
                              style: GoogleFonts.inter(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                serviceData['category'],
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Provider Info
                            GlassCard(
                              padding: const EdgeInsets.all(14),
                              borderRadius: 14,
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      gradient: AppColors.primaryGradient,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(Icons.person_rounded,
                                        color: Colors.white, size: 20),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          serviceData['providerName'] ??
                                              "Ahmed Mohamed",
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          serviceData['providerContact'] ??
                                              "+20 123 456 789",
                                          style: GoogleFonts.inter(
                                            color: AppColors.textSecondary,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Info Cards Row
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              'Price',
                              serviceData['price'] ?? '\$50/hr',
                              Icons.attach_money_rounded,
                              AppColors.secondary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              'Delivery',
                              serviceData['deliveryTime'] ?? '2-3 weeks',
                              Icons.schedule_rounded,
                              AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              'Rating',
                              '${serviceData['rating'] ?? 4.5} ⭐',
                              Icons.star_rounded,
                              AppColors.warning,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Description
                      Text(
                        'Description',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        serviceData['fullDescription'] ??
                            "This is a comprehensive service that meets all your needs. It is delivered by professionals with years of experience, ensuring high quality and reliability.",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Features
                      Text(
                        'Features',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...((serviceData['features'] ??
                              [
                                'High-quality output',
                                'Fast delivery',
                                '24/7 Support',
                                'Customizable solutions'
                              ]) as List)
                          .map<Widget>((feature) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(Icons.check_rounded,
                                    color: AppColors.success, size: 16),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  feature.toString(),
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),

                      const SizedBox(height: 30),
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

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      borderRadius: 14,
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getServiceIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('backend')) return Icons.storage_rounded;
    if (lower.contains('frontend')) return Icons.web_rounded;
    if (lower.contains('ui') || lower.contains('design')) {
      return Icons.palette_rounded;
    }
    return Icons.code_rounded;
  }
}
