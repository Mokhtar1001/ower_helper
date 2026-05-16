import 'package:flutter/material.dart';

class ClientRequestPage extends StatefulWidget {
  const ClientRequestPage({super.key});

  @override
  State<ClientRequestPage> createState() => _ClientRequestPageState();
}

class _ClientRequestPageState extends State<ClientRequestPage> {
  List<Map<String, dynamic>> requests = [
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchBar(),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
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

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: const IconThemeData(color: Color.fromARGB(255, 11, 53, 87)),
      centerTitle: true,
      title: const Text(
        'Client Requests',
        style: TextStyle(
            color: Color.fromARGB(255, 11, 53, 87),
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search requests...',
        prefixIcon: const Icon(Icons.search,
            color: Color.fromARGB(255, 11, 53, 87)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
      ),
      onChanged: (value) {
        setState(() {
          // Simple filter example
          requests = requests
              .where((r) => r['serviceType']
                  .toLowerCase()
                  .contains(value.toLowerCase()))
              .toList();
        });
      },
    );
  }

  Widget _buildRequestCard(Map<String, dynamic> req) {
    Color statusColor = _getStatusColor(req['status']);
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(req['serviceType'],
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 11, 53, 87))),
            const SizedBox(height: 4),
            Text(req['description']),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('Budget: ${req['budget']}'),
                const SizedBox(width: 16),
                Text('Timeline: ${req['timeline']}'),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: statusColor)),
                  child: Text(
                    req['status'],
                    style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                IconButton(
                  onPressed: () => _showRequestDetails(req),
                  icon: const Icon(Icons.visibility, size: 20),
                ),
                IconButton(
                  onPressed: () => _contactClient(req),
                  icon: const Icon(Icons.email, size: 20, color: Colors.blue),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'In Progress':
        return Colors.blue;
      case 'Completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
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
                Text('Client: ${req['clientName']}'),
                Text('Budget: ${req['budget']}'),
                Text('Timeline: ${req['timeline']}'),
                Text('Status: ${req['status']}'),
                const SizedBox(height: 10),
                Text('Description:', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(req['description']),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'))
            ],
          );
        });
  }

  void _contactClient(Map<String, dynamic> req) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Contacting ${req['clientName']} via email'),
      ),
    );
  }

  void _showAddRequestDialog() {
    final nameController = TextEditingController();
    final serviceController = TextEditingController();
    final descController = TextEditingController();
    final budgetController = TextEditingController();
    final timelineController = TextEditingController();

    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text('Add New Request'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Client Name')),
                  TextField(controller: serviceController, decoration: const InputDecoration(labelText: 'Service Type')),
                  TextField(controller: descController, decoration: const InputDecoration(labelText: 'Description')),
                  TextField(controller: budgetController, decoration: const InputDecoration(labelText: 'Budget')),
                  TextField(controller: timelineController, decoration: const InputDecoration(labelText: 'Timeline')),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      requests.add({
                        'id': requests.length + 1,
                        'clientName': nameController.text,
                        'serviceType': serviceController.text,
                        'description': descController.text,
                        'budget': budgetController.text,
                        'timeline': timelineController.text,
                        'status': 'Pending',
                      });
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Add')),
            ],
          );
        });
  }
}
