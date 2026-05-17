import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/service.dart';
import '../theme/app_theme.dart';
import 'add_service_page.dart';
import 'edit_service_page.dart';

class ServiceListPage extends StatefulWidget {
  const ServiceListPage({super.key});

  @override
  State<ServiceListPage> createState() => _ServiceListPageState();
}

class _ServiceListPageState extends State<ServiceListPage>
    with SingleTickerProviderStateMixin {
  List<Service> services = [];
  List<Service> filteredServices = [];
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    filteredServices = services;
    _searchController.addListener(_filterServices);
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _filterServices() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredServices = services.where((service) {
        return service.title.toLowerCase().contains(query) ||
            service.description!.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> _navigateToAddService() async {
    final newService = await Navigator.push<Service>(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const AddService(),
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 1.0),
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

    if (newService != null) {
      setState(() {
        services.add(newService);
        _filterServices();
      });
      _animController.reset();
      _animController.forward();
    }
  }

  void _deleteService(int index) {
    final realIndex = services.indexOf(filteredServices[index]);
    setState(() {
      services.removeAt(realIndex);
      _filterServices();
    });
  }

  void _editService(int index, Service updated) {
    final realIndex = services.indexOf(filteredServices[index]);
    setState(() {
      services[realIndex] = updated;
      _filterServices();
    });
  }

  void _navigateToEdit(int index, Service service) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditServicePage(
          serviceToEdit: service,
          onEdit: (updatedService) {
            _editService(index, updatedService);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Text(
                  'My Services',
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                // Add button
                GestureDetector(
                  onTap: _navigateToAddService,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.add_rounded,
                        color: Colors.white, size: 22),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.surfaceBorder),
              ),
              child: TextField(
                controller: _searchController,
                style: GoogleFonts.inter(
                    color: AppColors.textPrimary, fontSize: 15),
                decoration: InputDecoration(
                  hintText: 'Search services...',
                  hintStyle:
                      GoogleFonts.inter(color: AppColors.textMuted, fontSize: 15),
                  prefixIcon: const Icon(Icons.search_rounded,
                      color: AppColors.textMuted),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: filteredServices.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.inventory_2_outlined,
                              size: 56, color: AppColors.textMuted),
                          const SizedBox(height: 12),
                          Text(
                            services.isEmpty
                                ? 'No services yet.\nTap + to add one!'
                                : 'No services found.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: AppColors.textSecondary,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredServices.length,
                      itemBuilder: (context, index) {
                        final service = filteredServices[index];
                        final delay = index * 0.15;
                        return FadeTransition(
                          opacity: CurvedAnimation(
                            parent: _animController,
                            curve: Interval(
                              delay.clamp(0.0, 0.7),
                              (delay + 0.5).clamp(0.3, 1.0),
                              curve: Curves.easeOut,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: GlassCard(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.primary.withOpacity(0.15),
                                          AppColors.secondary
                                              .withOpacity(0.08),
                                        ],
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                        Icons.miscellaneous_services_rounded,
                                        color: AppColors.primary,
                                        size: 22),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          service.title,
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          service.description ??
                                              'No description',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.inter(
                                            fontSize: 13,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit_rounded,
                                        color: AppColors.primary, size: 20),
                                    onPressed: () =>
                                        _navigateToEdit(index, service),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline_rounded,
                                        color: AppColors.error, size: 20),
                                    onPressed: () =>
                                        _deleteService(index),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
