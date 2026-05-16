import 'package:flutter/material.dart';
import '../models/service.dart';
import 'add_service_page.dart';
import 'edit_service_page.dart';

class ServiceListPage extends StatefulWidget {
  const ServiceListPage({super.key});

  @override
  State<ServiceListPage> createState() => _ServiceListPageState();
}

class _ServiceListPageState extends State<ServiceListPage> {
  List<Service> services = [];
  List<Service> filteredServices = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredServices = services;
    _searchController.addListener(_filterServices);
  }

  @override
  void dispose() {
    _searchController.dispose();
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
      MaterialPageRoute(builder: (context) => const AddService()),
    );

    if (newService != null) {
      setState(() {
        services.add(newService);
        _filterServices();
      });
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
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 11, 53, 87)),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.school, color: Color.fromARGB(255, 11, 53, 87), size: 28),
            SizedBox(width: 8),
            Text(
              'Uni Helper',
              style: TextStyle(
                color: Color.fromARGB(255, 11, 53, 87),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Color.fromARGB(255, 11, 53, 87)),
            onPressed: _navigateToAddService,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search services...',
                  prefixIcon: const Icon(Icons.search,
                      color: Color.fromARGB(255, 11, 53, 87)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: filteredServices.isEmpty
                  ? const Center(child: Text('No services found.'))
                  : ListView.builder(
                      itemCount: filteredServices.length,
                      itemBuilder: (context, index) {
                        final service = filteredServices[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          elevation: 5,
                          child: ListTile(
                            title: Text(
                              service.title ,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 70, 17, 1)),
                            ),
                            subtitle: Text(
                              service.description ??'no descreption',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () =>
                                      _navigateToEdit(index, service),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteService(index),
                                ),
                              ],
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
