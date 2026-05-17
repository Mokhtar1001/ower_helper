import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/service.dart';
import '../theme/app_theme.dart';

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
    descController =
        TextEditingController(text: widget.serviceToEdit.description);
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
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
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
                      'Edit Service',
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
                  child: GlassCard(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Title
                          buildThemedField(
                            controller: titleController,
                            label: 'Service Title',
                            prefixIcon: Icons.title_rounded,
                            validator: (v) => v == null || v.isEmpty
                                ? 'Enter a title'
                                : null,
                          ),
                          const SizedBox(height: 16),

                          // Description
                          buildThemedField(
                            controller: descController,
                            label: 'Service Description',
                            prefixIcon: Icons.description_outlined,
                            maxLines: 3,
                          ),
                          const SizedBox(height: 16),

                          // Price
                          buildThemedField(
                            controller: priceController,
                            label: 'Price',
                            prefixIcon: Icons.attach_money_rounded,
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 16),

                          // Duration
                          buildThemedField(
                            controller: durationController,
                            label: 'Delivery Time',
                            prefixIcon: Icons.schedule_rounded,
                          ),
                          const SizedBox(height: 16),

                          // Features
                          Row(
                            children: [
                              Expanded(
                                child: buildThemedField(
                                  controller: featureController,
                                  label: 'Add Feature',
                                  prefixIcon: Icons.add_box_outlined,
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: addFeature,
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    gradient: AppColors.primaryGradient,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Icon(Icons.add_rounded,
                                      color: Colors.white, size: 22),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Show Features
                          if (features.isNotEmpty)
                            Column(
                              children: features
                                  .asMap()
                                  .entries
                                  .map(
                                    (entry) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8),
                                      child: Container(
                                        padding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 10),
                                        decoration: BoxDecoration(
                                          color: AppColors.success
                                              .withOpacity(0.08),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color: AppColors.success
                                                .withOpacity(0.2),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                                Icons
                                                    .check_circle_rounded,
                                                color: AppColors.success,
                                                size: 18),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                entry.value,
                                                style: GoogleFonts.inter(
                                                  color: AppColors
                                                      .textPrimary,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () =>
                                                  removeFeature(
                                                      entry.key),
                                              child: const Icon(
                                                  Icons
                                                      .delete_outline_rounded,
                                                  color: AppColors.error,
                                                  size: 18),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          const SizedBox(height: 24),

                          GradientButton(
                            text: 'Save Changes',
                            icon: Icons.save_rounded,
                            onPressed: saveChanges,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
