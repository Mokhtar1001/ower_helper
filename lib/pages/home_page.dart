import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'service_list_page.dart';
import 'service_detail_page.dart';
import 'profile_page.dart';
import 'Request_Page.dart';
import 'login_page.dart';
import 'client_request_page.dart';

class HomePage extends StatefulWidget {
  final String role; // Added role parameter
  const HomePage({super.key, required this.role});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const primaryColor = Color.fromARGB(255, 11, 53, 87);

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

  List<Map<String, dynamic>> filteredServices = [];

  @override
  void initState() {
    super.initState();
    filteredServices = demoServices;
  }

  void _filterServices(String query) {
    setState(() {
      filteredServices = demoServices
          .where((service) =>
              service['name'].toLowerCase().contains(query.toLowerCase()) ||
              service['description'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Role Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: widget.role == 'Provider' 
                    ? Colors.green.withOpacity(0.1)
                    : Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    widget.role == 'Provider' ? Icons.business : Icons.person,
                    size: 16,
                    color: widget.role == 'Provider' ? Colors.green : Colors.blue,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Logged in as ${widget.role}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: widget.role == 'Provider' ? Colors.green : Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Search Bar
            TextField(
              onChanged: _filterServices,
              decoration: InputDecoration(
                hintText: "Search services...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Featured Services",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: filteredServices.isEmpty
                  ? const Center(child: Text("No services found"))
                  : ListView.builder(
                      itemCount: filteredServices.length,
                      itemBuilder: (context, index) {
                        return _buildServiceCard(filteredServices[index], context);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- APPBAR ----------------
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: const IconThemeData(color: primaryColor),
      centerTitle: true,
      title: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.school, color: primaryColor),
          SizedBox(width: 8),
          Text(
            "Uni Helper",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          )
        ],
      ),
    );
  }

  // ---------------- DRAWER ----------------
  Widget _buildDrawer(BuildContext context) {
    // TODO: Fetch user details from AuthService/DatabaseService
    final String email = 'user@example.com';
    
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: primaryColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  "Uni Helper",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  email,
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.role,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Conditional menu items based on role
          if (widget.role == 'Provider') ...[
            _buildSectionTitle("Provider Menu"),
            _buildDrawerItem(Icons.list, "My Services", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ServiceListPage()),
              );
            }),
            _buildDrawerItem(Icons.request_page, "Service Requests", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => RequestPage()),
              );
            }),
          ],
          
          if (widget.role == 'Client') ...[
            _buildSectionTitle("Client Menu"),
            _buildDrawerItem(Icons.shopping_bag, "My Requests", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ClientRequestPage()),
              );
            }),
          ],
          
          _buildSectionTitle("Profile"),
          _buildDrawerItem(Icons.person, "My Profile", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            );
          }),
          
          const Divider(),
          
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                await AuthService().signOut();
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginFormLayout()),
                    (route) => false,
                  );
                }
              },
              child: const Text("Logout"),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
            color: primaryColor, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: primaryColor),
      title: Text(title),
      onTap: onTap,
    );
  }

  // ---------------- SERVICE CARD ----------------
  Widget _buildServiceCard(Map<String, dynamic> service, BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              service['name'],
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor),
            ),
            const SizedBox(height: 6),
            Text(service['description']),
            const SizedBox(height: 6),
            Row(
              children: [
                Text(service['price'],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green)),
                const Spacer(),
                Text(service['deliveryTime'])
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 249, 250, 251)),
                    child: const Text("Service Details"),
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
                const SizedBox(width: 10),
                
                // Only show "Request Now" for Clients
                if (widget.role == 'Client')
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primaryColor,
                        side: const BorderSide(color: primaryColor),
                      ),
                      child: const Text("Request Now"),
                      onPressed: () {
                        _showRequestDialog(context, service['name']);
                      },
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // ---------------- REQUEST DIALOG ----------------
  void _showRequestDialog(BuildContext context, String serviceName) {
    final descriptionController = TextEditingController();
    final timeController = TextEditingController();
    final budgetController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(
            "Request $serviceName",
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: primaryColor),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    hintText: "Describe your request...",
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: timeController,
                  decoration: const InputDecoration(
                      labelText: "Delivery Time", hintText: "ex: 3 days"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: budgetController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: "Budget", hintText: "ex: 200 EGP"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        "✅ Request Sent\nService: $serviceName\nTime: ${timeController.text}\nBudget: ${budgetController.text}"),
                  ),
                );
              },
              child: const Text("Send"),
            ),
          ],
        );
      },
    );
  }
}