import 'package:flutter/material.dart';
import '../../../../app/app_colors.dart';
import '../../../../core/constants/property_enums.dart';

/// Horizontal scrollable chips for filtering property intents.
class CategoryChipsBar extends StatelessWidget {
  final PropertyIntent? selectedIntent;
  final ValueChanged<PropertyIntent?> onIntentSelected;

  const CategoryChipsBar({
    super.key,
    required this.selectedIntent,
    required this.onIntentSelected,
  });

  @override
  Widget build(BuildContext context) {
    final intents = [
      null, // All
      PropertyIntent.flatRent,
      PropertyIntent.houseRent,
      PropertyIntent.roomRent,
      PropertyIntent.sublet,
      PropertyIntent.flatSale,
      PropertyIntent.landSale,
      PropertyIntent.officeRent,
      PropertyIntent.shopRent,
    ];

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: intents.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final intent = intents[index];
          final isSelected = selectedIntent == intent;
          final label = intent == null ? 'সকল বিজ্ঞাপন' : intent.displayNameBn;

          return FilterChip(
            selected: isSelected,
            label: Text(label),
            labelStyle: TextStyle(
              fontSize: 12.5,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? AppColors.textOnPrimary : AppColors.textPrimary,
            ),
            backgroundColor: AppColors.surface,
            selectedColor: AppColors.primary,
            checkmarkColor: AppColors.textOnPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.border,
              ),
            ),
            onSelected: (_) => onIntentSelected(isSelected ? null : intent),
          );
        },
      ),
    );
  }
}
