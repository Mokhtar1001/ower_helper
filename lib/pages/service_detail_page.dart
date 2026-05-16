import 'package:flutter/material.dart';

class ServicesDetailsPage extends StatelessWidget {
  final Map<String, dynamic> serviceData;

  const ServicesDetailsPage({
    super.key,
    required this.serviceData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(serviceData['name']),
        backgroundColor: const Color.fromARGB(255, 17, 139, 239),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------- Service Header ----------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 11, 53, 87).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(
                    serviceData['name'].toString().toLowerCase().contains('backend')
                        ? Icons.storage
                        : Icons.web,
                    size: 60,
                    color: const Color.fromARGB(255, 11, 53, 87),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    serviceData['name'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 11, 53, 87),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    serviceData['category'],
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  // ---------------- Provider Info ----------------
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 25,
                          backgroundColor: Color.fromARGB(255, 11, 53, 87),
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              serviceData['providerName'] ?? "Ahmed Mohamed",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color.fromARGB(255, 11, 53, 87),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              serviceData['providerContact'] ?? "+20 123 456 789",
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ---------------- Service Info ----------------
            _buildInfoCard(
                title: 'Price',
                value: serviceData['price'] ?? '\$50/hour',
                icon: Icons.attach_money),
            _buildInfoCard(
                title: 'Delivery Time',
                value: serviceData['deliveryTime'] ?? '2-3 weeks',
                icon: Icons.timer),
            _buildInfoCard(
                title: 'Rating',
                value: '${serviceData['rating'] ?? 4.5} ⭐',
                icon: Icons.star),

            const SizedBox(height: 20),

            // ---------------- Description ----------------
            const Text(
              'Description',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 11, 53, 87)),
            ),
            const SizedBox(height: 8),
            Text(
              serviceData['fullDescription'] ??
                  "This is a comprehensive service that meets all your needs. It is delivered by professionals with years of experience, ensuring high quality and reliability.",
              style: TextStyle(fontSize: 16, color: Colors.grey[700], height: 1.5),
            ),

            const SizedBox(height: 20),

            // ---------------- Features ----------------
            if (serviceData['features'] != null || true) ...[
              const Text(
                'Features',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 11, 53, 87)),
              ),
              const SizedBox(height: 8),
              Column(
                children: (serviceData['features'] ??
                        [
                          'High-quality output',
                          'Fast delivery',
                          '24/7 Support',
                          'Customizable solutions'
                        ])
                    .map<Widget>((feature) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green[600], size: 20),
                        const SizedBox(width: 8),
                        Expanded(child: Text(feature.toString())),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
      {required String title, required String value, required IconData icon}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: const Color.fromARGB(255, 11, 53, 87)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text(value, style: const TextStyle(fontSize: 16, color: Colors.black87)),
      ),
    );
  }
}
