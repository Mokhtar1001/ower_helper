import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/service.dart';
import '../theme/app_theme.dart';

class AddService extends StatefulWidget {
  const AddService({super.key});

  @override
  State<AddService> createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _featureController = TextEditingController();

  List<String> features = [];

  void _addFeature() {
    final feature = _featureController.text.trim();
    if (feature.isNotEmpty) {
      setState(() {
        features.add(feature);
        _featureController.clear();
      });
    }
  }

  void _saveService() {
    if (_formKey.currentState!.validate()) {
      final newService = Service(
        title: _titleController.text,
        description: _descController.text,
        price: double.tryParse(_priceController.text),
        duration: _durationController.text,
        features: features,
        isDone: false,
      );

      Navigator.pop(context, newService);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    _featureController.dispose();
    super.dispose();
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
                      'Add New Service',
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
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Title
                          buildThemedField(
                            controller: _titleController,
                            label: 'Service Title',
                            prefixIcon: Icons.title_rounded,
                            validator: (value) => value == null || value.isEmpty
                                ? 'Enter a title'
                                : null,
                          ),
                          const SizedBox(height: 16),

                          // Description
                          buildThemedField(
                            controller: _descController,
                            label: 'Description (Optional)',
                            prefixIcon: Icons.description_outlined,
                            maxLines: 3,
                          ),
                          const SizedBox(height: 16),

                          // Price
                          buildThemedField(
                            controller: _priceController,
                            label: 'Price',
                            prefixIcon: Icons.attach_money_rounded,
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 16),

                          // Duration
                          buildThemedField(
                            controller: _durationController,
                            label: 'Delivery Time',
                            prefixIcon: Icons.schedule_rounded,
                          ),
                          const SizedBox(height: 16),

                          // Features
                          Row(
                            children: [
                              Expanded(
                                child: buildThemedField(
                                  controller: _featureController,
                                  label: 'Add Feature',
                                  prefixIcon: Icons.add_box_outlined,
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: _addFeature,
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

                          // Show features list
                          if (features.isNotEmpty)
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: features
                                  .asMap()
                                  .entries
                                  .map((entry) => Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                        decoration: BoxDecoration(
                                          color:
                                              AppColors.success.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color: AppColors.success
                                                .withOpacity(0.3),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                                Icons.check_circle_rounded,
                                                color: AppColors.success,
                                                size: 16),
                                            const SizedBox(width: 6),
                                            Text(
                                              entry.value,
                                              style: GoogleFonts.inter(
                                                color: AppColors.success,
                                                fontSize: 13,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  features
                                                      .removeAt(entry.key);
                                                });
                                              },
                                              child: const Icon(
                                                  Icons.close_rounded,
                                                  color: AppColors.textMuted,
                                                  size: 16),
                                            ),
                                          ],
                                        ),
                                      ))
                                  .toList(),
                            ),
                          const SizedBox(height: 28),

                          // Save Button
                          GradientButton(
                            text: 'Add Service',
                            icon: Icons.add_circle_outline_rounded,
                            onPressed: _saveService,
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
