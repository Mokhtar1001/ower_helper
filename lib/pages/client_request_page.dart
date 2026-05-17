import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class ClientRequestPage extends StatefulWidget {
  const ClientRequestPage({super.key});

  @override
  State<ClientRequestPage> createState() => _ClientRequestPageState();
}

class _ClientRequestPageState extends State<ClientRequestPage> {
  List<Map<String, dynamic>> allRequests = [
    {
      'id': 1,
      'clientName': 'Ahmed Mohamed',
      'serviceType': 'Backend Development',
      'description': 'Need a REST API for my e-commerce app',
      'status': 'Pending',
      'budget': '\$500',
      'timeline': '2 weeks',
      'date': '2024-01-15',
      'urgency': 'High',
      'contactEmail': 'ahmed.mohamed@email.com',
    },
    {
      'id': 2,
      'clientName': 'Sarah Ali',
      'serviceType': 'Frontend Development',
      'description': 'Responsive React dashboard with charts',
      'status': 'In Progress',
      'budget': '\$400',
      'timeline': '3 weeks',
      'date': '2024-01-10',
      'urgency': 'Medium',
      'contactEmail': 'sarah.ali@email.com',
    },
  ];

  late List<Map<String, dynamic>> requests;

  @override
  void initState() {
    super.initState();
    requests = List.from(allRequests);
  }

  void _filterRequests(String value) {
    setState(() {
      requests = allRequests
          .where((r) => r['serviceType']
              .toLowerCase()
              .contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Requests',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildSearchBar(),
            const SizedBox(height: 16),
            Expanded(
              child: requests.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.inbox_rounded,
                              size: 48, color: AppColors.textMuted),
                          const SizedBox(height: 12),
                          Text(
                            'No requests found',
                            style: GoogleFonts.inter(
                              color: AppColors.textSecondary,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: requests.length,
                      itemBuilder: (context, index) {
                        final req = requests[index];
                        return _buildRequestCard(req);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: TextField(
        style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 15),
        decoration: InputDecoration(
          hintText: 'Search requests...',
          hintStyle: GoogleFonts.inter(color: AppColors.textMuted, fontSize: 15),
          prefixIcon:
              const Icon(Icons.search_rounded, color: AppColors.textMuted),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onChanged: _filterRequests,
      ),
    );
  }

  Widget _buildRequestCard(Map<String, dynamic> req) {
    Color statusColor = _getStatusColor(req['status']);
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: GlassCard(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _getServiceIcon(req['serviceType']),
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    req['serviceType'],
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border:
                        Border.all(color: statusColor.withOpacity(0.4)),
                  ),
                  child: Text(
                    req['status'],
                    style: GoogleFonts.inter(
                      color: statusColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              req['description'],
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildInfoChip(
                    Icons.attach_money_rounded, req['budget'], AppColors.secondary),
                const SizedBox(width: 10),
                _buildInfoChip(
                    Icons.schedule_rounded, req['timeline'], AppColors.primary),
                const Spacer(),
                GestureDetector(
                  onTap: () => _showRequestDetails(req),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.surfaceBorder),
                    ),
                    child: const Icon(Icons.visibility_rounded,
                        size: 18, color: AppColors.textSecondary),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _contactClient(req),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.email_rounded,
                        size: 18, color: AppColors.primary),
                  ),
                ),
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return AppColors.warning;
      case 'In Progress':
        return AppColors.info;
      case 'Completed':
        return AppColors.success;
      default:
        return AppColors.textMuted;
    }
  }

  IconData _getServiceIcon(String type) {
    final lower = type.toLowerCase();
    if (lower.contains('backend')) return Icons.storage_rounded;
    if (lower.contains('frontend')) return Icons.web_rounded;
    if (lower.contains('design')) return Icons.palette_rounded;
    return Icons.code_rounded;
  }

  void _showRequestDetails(Map<String, dynamic> req) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(req['serviceType']),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _detailRow('Client', req['clientName']),
              _detailRow('Budget', req['budget']),
              _detailRow('Timeline', req['timeline']),
              _detailRow('Status', req['status']),
              const SizedBox(height: 12),
              Text(
                'Description:',
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary),
              ),
              const SizedBox(height: 4),
              Text(
                req['description'],
                style: GoogleFonts.inter(color: AppColors.textSecondary),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w600, color: AppColors.textSecondary),
          ),
          Text(
            value,
            style: GoogleFonts.inter(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  void _contactClient(Map<String, dynamic> req) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Contacting ${req['clientName']} via email'),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}
