import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import 'service_list_page.dart';
import 'service_detail_page.dart';
import 'profile_page.dart';
import 'Request_Page.dart';
import 'login_page.dart';
import 'client_request_page.dart';

class HomePage extends StatefulWidget {
  final String role;
  const HomePage({super.key, required this.role});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _currentIndex = 0;
  String _selectedCategory = 'All';

  final List<Map<String, dynamic>> demoServices = const [
    {
      'id': 1,
      'name': 'Backend Development',
      'description':
          'Complete backend solutions with Node.js, Python, and database management',
      'rating': 4.8,
      'price': '\$50/hour',
      'category': 'Programming',
      'deliveryTime': '2-3 weeks',
    },
    {
      'id': 2,
      'name': 'Frontend Development',
      'description':
          'Responsive web applications using React, Flutter and modern UI frameworks',
      'rating': 4.9,
      'price': '\$45/hour',
      'category': 'Design & Development',
      'deliveryTime': '1-2 weeks',
    },
    {
      'id': 3,
      'name': 'UI/UX Design',
      'description':
          'Professional UI/UX designs for web and mobile applications',
      'rating': 4.7,
      'price': '\$40/hour',
      'category': 'Design',
      'deliveryTime': '1 week',
    },
  ];

  final List<Map<String, dynamic>> categories = [
    {'name': 'All', 'icon': Icons.apps_rounded},
    {'name': 'Programming', 'icon': Icons.code_rounded},
    {'name': 'Design', 'icon': Icons.palette_rounded},
    {'name': 'Writing', 'icon': Icons.edit_note_rounded},
    {'name': 'Marketing', 'icon': Icons.campaign_rounded},
  ];

  List<Map<String, dynamic>> filteredServices = [];
  String _searchQuery = '';

  late AnimationController _listAnimController;

  @override
  void initState() {
    super.initState();
    filteredServices = demoServices;
    _listAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _listAnimController.dispose();
    super.dispose();
  }

  void _filterServices(String query) {
    setState(() {
      _searchQuery = query;
      _applyFilters();
    });
  }

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _applyFilters();
    });
  }

  void _applyFilters() {
    filteredServices = demoServices.where((service) {
      final matchesQuery = _searchQuery.isEmpty ||
          service['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          service['description']
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'All' ||
          service['category']
              .toLowerCase()
              .contains(_selectedCategory.toLowerCase());
      return matchesQuery && matchesCategory;
    }).toList();
    _listAnimController.reset();
    _listAnimController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: IndexedStack(
          index: _currentIndex,
          children: [
            _buildHomeTab(),
            widget.role == 'Provider'
                ? const ServiceListPage()
                : const ClientRequestPage(),
            widget.role == 'Provider'
                ? RequestPage()
                : const ClientRequestPage(),
            const ProfilePage(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ─── Bottom Navigation ─────────────────────────────────────────────────
  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.surfaceBorder.withOpacity(0.5), width: 1),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_rounded, 'Home'),
              _buildNavItem(
                1,
                widget.role == 'Provider'
                    ? Icons.list_alt_rounded
                    : Icons.shopping_bag_rounded,
                widget.role == 'Provider' ? 'Services' : 'Requests',
              ),
              _buildNavItem(
                2,
                Icons.request_page_rounded,
                widget.role == 'Provider' ? 'Requests' : 'History',
              ),
              _buildNavItem(3, Icons.person_rounded, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? AppColors.primary : AppColors.textMuted,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? AppColors.primary : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Home Tab ──────────────────────────────────────────────────────────
  Widget _buildHomeTab() {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row: Logo + Role + Logout
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.school_rounded,
                            size: 20, color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Uni Helper',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      // Role Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: widget.role == 'Provider'
                              ? AppColors.secondary.withOpacity(0.12)
                              : AppColors.primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              widget.role == 'Provider'
                                  ? Icons.verified_rounded
                                  : Icons.person_rounded,
                              size: 14,
                              color: widget.role == 'Provider'
                                  ? AppColors.secondary
                                  : AppColors.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.role,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: widget.role == 'Provider'
                                    ? AppColors.secondary
                                    : AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () async {
                          await AuthService().signOut();
                          if (context.mounted) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const LoginFormLayout()),
                              (route) => false,
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.logout_rounded,
                              size: 18, color: AppColors.error),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Greeting
                  Text(
                    _getGreeting(),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Find the perfect service 🚀',
                    style: GoogleFonts.inter(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: AppColors.surfaceBorder, width: 1),
                    ),
                    child: TextField(
                      onChanged: _filterServices,
                      style: GoogleFonts.inter(
                          color: AppColors.textPrimary, fontSize: 15),
                      decoration: InputDecoration(
                        hintText: 'Search services...',
                        hintStyle: GoogleFonts.inter(
                            color: AppColors.textMuted, fontSize: 15),
                        prefixIcon: const Icon(Icons.search_rounded,
                            color: AppColors.textMuted),
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Category Chips
                  SizedBox(
                    height: 42,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        final isActive =
                            _selectedCategory == cat['name'];
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            onTap: () =>
                                _selectCategory(cat['name']),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                gradient: isActive
                                    ? AppColors.primaryGradient
                                    : null,
                                color: isActive
                                    ? null
                                    : AppColors.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: isActive
                                    ? null
                                    : Border.all(
                                        color: AppColors.surfaceBorder),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    cat['icon'],
                                    size: 16,
                                    color: isActive
                                        ? Colors.white
                                        : AppColors.textSecondary,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    cat['name'],
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: isActive
                                          ? Colors.white
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    'Featured Services',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ),

          // Service List
          filteredServices.isEmpty
              ? SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off_rounded,
                            size: 48, color: AppColors.textMuted),
                        const SizedBox(height: 12),
                        Text(
                          'No services found',
                          style: GoogleFonts.inter(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final delay = index * 0.15;
                        return FadeTransition(
                          opacity: CurvedAnimation(
                            parent: _listAnimController,
                            curve: Interval(
                              (delay).clamp(0.0, 0.7),
                              (delay + 0.5).clamp(0.3, 1.0),
                              curve: Curves.easeOut,
                            ),
                          ),
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.2),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                              parent: _listAnimController,
                              curve: Interval(
                                (delay).clamp(0.0, 0.7),
                                (delay + 0.5).clamp(0.3, 1.0),
                                curve: Curves.easeOutCubic,
                              ),
                            )),
                            child: _buildServiceCard(
                                filteredServices[index], context),
                          ),
                        );
                      },
                      childCount: filteredServices.length,
                    ),
                  ),
                ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning ☀️';
    if (hour < 18) return 'Good afternoon 🌤️';
    return 'Good evening 🌙';
  }

  // ─── Service Card ──────────────────────────────────────────────────────
  Widget _buildServiceCard(
      Map<String, dynamic> service, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GlassCard(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withOpacity(0.15),
                        AppColors.secondary.withOpacity(0.08),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getServiceIcon(service['name']),
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service['name'],
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        service['category'],
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                // Rating
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star_rounded,
                          size: 14, color: AppColors.warning),
                      const SizedBox(width: 2),
                      Text(
                        '${service['rating']}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.warning,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              service['description'],
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _buildInfoChip(Icons.attach_money_rounded, service['price'],
                    AppColors.secondary),
                const SizedBox(width: 10),
                _buildInfoChip(Icons.schedule_rounded,
                    service['deliveryTime'], AppColors.primary),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.info_outline_rounded, size: 16),
                    label: const Text('Details'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      side: const BorderSide(color: AppColors.surfaceBorder),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ServicesDetailsPage(serviceData: service),
                        ),
                      );
                    },
                  ),
                ),
                if (widget.role == 'Client') ...[
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
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
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () =>
                              _showRequestDialog(context, service['name']),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.send_rounded,
                                    size: 16, color: Colors.white),
                                const SizedBox(width: 6),
                                Text(
                                  'Request',
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
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
    if (lower.contains('mobile')) return Icons.phone_android_rounded;
    return Icons.code_rounded;
  }

  // ─── Request Dialog ────────────────────────────────────────────────────
  void _showRequestDialog(BuildContext context, String serviceName) {
    final descriptionController = TextEditingController();
    final timeController = TextEditingController();
    final budgetController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            'Request $serviceName',
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildThemedField(
                  controller: descriptionController,
                  label: 'Description',
                  hint: 'Describe your request...',
                  prefixIcon: Icons.description_outlined,
                ),
                const SizedBox(height: 12),
                buildThemedField(
                  controller: timeController,
                  label: 'Delivery Time',
                  hint: 'ex: 3 days',
                  prefixIcon: Icons.schedule_rounded,
                ),
                const SizedBox(height: 12),
                buildThemedField(
                  controller: budgetController,
                  label: 'Budget',
                  hint: 'ex: 200 EGP',
                  prefixIcon: Icons.attach_money_rounded,
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
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
              icon: Icons.send_rounded,
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "✅ Request Sent for $serviceName",
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}