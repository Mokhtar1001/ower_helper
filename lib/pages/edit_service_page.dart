import 'package:flutter/material.dart';
import '../models/service.dart';

class EditServicePage extends StatefulWidget {
  final Service serviceToEdit;
  final Function(Service) onEdit;

  const EditServicePage({
    super.key,
    required this.serviceToEdit,
    required this.onEdit,
  });

  @override
  State<EditServicePage> createState() => _EditServicePageState();
}

class _EditServicePageState extends State<EditServicePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController titleController;
  late TextEditingController descController;
  late TextEditingController priceController;
  late TextEditingController durationController;
  late TextEditingController featureController;

  List<String> features = [];

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.serviceToEdit.title);
    descController = TextEditingController(text: widget.serviceToEdit.description);
    priceController = TextEditingController(
        text: widget.serviceToEdit.price?.toString() ?? '');
    durationController =
        TextEditingController(text: widget.serviceToEdit.duration);
    features = List.from(widget.serviceToEdit.features ?? []);
    featureController = TextEditingController();
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    priceController.dispose();
    durationController.dispose();
    featureController.dispose();
    super.dispose();
  }

  void addFeature() {
    final f = featureController.text.trim();
    if (f.isNotEmpty) {
      setState(() {
        features.add(f);
        featureController.clear();
      });
    }
  }

  void removeFeature(int index) {
    setState(() {
      features.removeAt(index);
    });
  }

  void saveChanges() {
    if (_formKey.currentState!.validate()) {
      final updatedService = Service(
        title: titleController.text,
        description: descController.text,
        price: double.tryParse(priceController.text),
        duration: durationController.text,
        features: features,
        isDone: widget.serviceToEdit.isDone,
      );

      widget.onEdit(updatedService);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Edit Service'),
        backgroundColor: Colors.blue,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Title
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Service Title',
                    prefixIcon: Icon(Icons.title),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white70,
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter a title' : null,
                ),
                const SizedBox(height: 12),

                // Description
                TextFormField(
                  controller: descController,
                  decoration: const InputDecoration(
                    labelText: 'Service Description',
                    prefixIcon: Icon(Icons.description),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white70,
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 12),

                // Price
                TextFormField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    prefixIcon: Icon(Icons.attach_money),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white70,
                  ),
                ),
                const SizedBox(height: 12),

                // Duration
                TextFormField(
                  controller: durationController,
                  decoration: const InputDecoration(
                    labelText: 'Delivery Time',
                    prefixIcon: Icon(Icons.access_time),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white70,
                  ),
                ),
                const SizedBox(height: 12),

                // Features
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: featureController,
                        decoration: const InputDecoration(
                          labelText: 'Add Feature',
                          prefixIcon: Icon(Icons.add_box),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white70,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.blue),
                      onPressed: addFeature,
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Show Features
                if (features.isNotEmpty)
                  Column(
                    children: features
                        .asMap()
                        .entries
                        .map(
                          (entry) => ListTile(
                            leading: const Icon(Icons.check_circle, color: Colors.green),
                            title: Text(entry.value),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => removeFeature(entry.key),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: saveChanges,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
