import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_text_styles.dart';
import '../../../core/constants/property_enums.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../data/repositories/property_repository.dart';

/// Modal bottom sheet for detailed feed and search filtering.
class FeedFiltersSheet extends StatefulWidget {
  final PropertySearchFilter initialFilter;
  final ValueChanged<PropertySearchFilter> onApply;

  const FeedFiltersSheet({
    super.key,
    required this.initialFilter,
    required this.onApply,
  });

  @override
  State<FeedFiltersSheet> createState() => _FeedFiltersSheetState();
}

class _FeedFiltersSheetState extends State<FeedFiltersSheet> {
  late PropertyIntent? _intent;
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();
  int? _minBedrooms;
  int? _minBathrooms;
  final Set<String> _selectedAmenities = {};

  final List<String> _amenitiesList = [
    'লিফট (Lift)',
    'জেনারেটর (Generator)',
    'গ্যাস সংযোগ (Gas)',
    'গাড়ি পার্কিং (Car Parking)',
    'সিসিটিভি / গার্ড (Security)',
    'ব্যালকনি / বারান্দা (Balcony)',
    'ছাদ ব্যবহারের সুবিধা (Rooftop Access)',
  ];

  @override
  void initState() {
    super.initState();
    _intent = widget.initialFilter.intent;
    if (widget.initialFilter.minPrice != null) {
      _minPriceController.text = widget.initialFilter.minPrice!.toInt().toString();
    }
    if (widget.initialFilter.maxPrice != null) {
      _maxPriceController.text = widget.initialFilter.maxPrice!.toInt().toString();
    }
    _minBedrooms = widget.initialFilter.minBedrooms;
    _minBathrooms = widget.initialFilter.minBathrooms;
    if (widget.initialFilter.requiredAmenities != null) {
      _selectedAmenities.addAll(widget.initialFilter.requiredAmenities!);
    }
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  void _handleApply() {
    final filter = PropertySearchFilter(
      intent: _intent,
      minPrice: double.tryParse(_minPriceController.text.trim()),
      maxPrice: double.tryParse(_maxPriceController.text.trim()),
      minBedrooms: _minBedrooms,
      minBathrooms: _minBathrooms,
      requiredAmenities: _selectedAmenities.isNotEmpty ? _selectedAmenities.toList() : null,
    );
    widget.onApply(filter);
    Navigator.of(context).pop();
  }

  void _handleReset() {
    setState(() {
      _intent = null;
      _minPriceController.clear();
      _maxPriceController.clear();
      _minBedrooms = null;
      _minBathrooms = null;
      _selectedAmenities.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('ফিল্টারসমূহ (Filters)', style: AppTextStyles.headingSmall),
              TextButton(
                onPressed: _handleReset,
                child: const Text('রিসেট করুন (Reset)'),
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: ListView(
              children: [
                // Price Range
                Text('ভাড়া / বাজেট (টাকা)', style: AppTextStyles.headingSmall),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: _minPriceController,
                        hint: 'নূন্যতম (Min)',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppTextField(
                        controller: _maxPriceController,
                        hint: 'সর্বোচ্চ (Max)',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Bedrooms
                Text('বেডরুমের সংখ্যা', style: AppTextStyles.headingSmall),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [1, 2, 3, 4, 5].map((count) {
                    final isSel = _minBedrooms == count;
                    return ChoiceChip(
                      label: Text('$count+'),
                      selected: isSel,
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: isSel ? Colors.white : AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                      onSelected: (sel) {
                        setState(() => _minBedrooms = sel ? count : null);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),

                // Bathrooms
                Text('বাথরুমের সংখ্যা', style: AppTextStyles.headingSmall),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [1, 2, 3, 4].map((count) {
                    final isSel = _minBathrooms == count;
                    return ChoiceChip(
                      label: Text('$count+'),
                      selected: isSel,
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: isSel ? Colors.white : AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                      onSelected: (sel) {
                        setState(() => _minBathrooms = sel ? count : null);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),

                // Amenities
                Text('সুযোগ-সুবিধাসমূহ (Amenities)', style: AppTextStyles.headingSmall),
                const SizedBox(height: 8),
                ..._amenitiesList.map((amenity) {
                  final isChecked = _selectedAmenities.contains(amenity);
                  return CheckboxListTile(
                    title: Text(amenity, style: AppTextStyles.bodyMedium),
                    value: isChecked,
                    activeColor: AppColors.primary,
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) {
                      setState(() {
                        if (val == true) {
                          _selectedAmenities.add(amenity);
                        } else {
                          _selectedAmenities.remove(amenity);
                        }
                      });
                    },
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: 'ফিল্টার প্রয়োগ করুন (Apply Filters)',
              onPressed: _handleApply,
            ),
          ),
        ],
      ),
    );
  }
}

