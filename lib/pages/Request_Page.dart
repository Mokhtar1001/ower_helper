import 'package:flutter/material.dart';

class ServiceRequest {
  final String fullName;
  final String email;
  final String phone;
  final String serviceType;
  final String description;
  String status; // mutable now

  ServiceRequest({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.serviceType,
    required this.description,
    required this.status,
  });
}

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  static const primaryColor = Color.fromARGB(255, 11, 53, 87);

  final List<ServiceRequest> demoRequests = [
    ServiceRequest(
      fullName: "Ahmed Hassan",
      email: "ahmed@example.com",
      phone: "01012345678",
      serviceType: "Web Development",
      description:
          "I need a modern responsive website with admin panel and API integration.",
      status: "Pending",
    ),
    ServiceRequest(
      fullName: "Mona Ibrahim",
      email: "mona@example.com",
      phone: "01198765432",
      serviceType: "Mobile App",
      description:
          "Cross-platform mobile app for booking services with payment gateway.",
      status: "In Progress",
    ),
    ServiceRequest(
      fullName: "Omar Ali",
      email: "omar@example.com",
      phone: "01244455667",
      serviceType: "UI / UX Design",
      description: "Full UI/UX design for ecommerce platform with 25 screens.",
      status: "Completed",
    ),
  ];

  Color getStatusColor(String status) {
    switch (status) {
      case "Pending":
        return Colors.orange;
      case "In Progress":
        return Colors.blue;
      case "Completed":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void changeStatus(ServiceRequest request) {
    setState(() {
      if (request.status == "Pending") {
        request.status = "In Progress";
      } else if (request.status == "In Progress") {
        request.status = "Completed";
      } else {
        request.status = "Pending";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Service Requests",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: primaryColor,
      ),
      backgroundColor: Colors.grey[100],
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: demoRequests.length,
        itemBuilder: (context, index) {
          final request = demoRequests[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person, color: primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        request.fullName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => changeStatus(request),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            color: getStatusColor(
                              request.status,
                            ).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            request.status,
                            style: TextStyle(
                              color: getStatusColor(request.status),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.phone, size: 16),
                      const SizedBox(width: 4),
                      Text(request.phone),
                      const SizedBox(width: 16),
                      const Icon(Icons.email, size: 16),
                      const SizedBox(width: 4),
                      Text(request.email),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.build, size: 16),
                      const SizedBox(width: 4),
                      Text(request.serviceType),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    request.description,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
