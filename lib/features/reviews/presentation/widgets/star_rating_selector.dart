import 'package:flutter/material.dart';
import '../../../../app/app_colors.dart';

/// Interactive star rating component (1 to 5 stars).
class StarRatingSelector extends StatelessWidget {
  final double rating;
  final ValueChanged<double> onRatingChanged;
  final String label;

  const StarRatingSelector({
    super.key,
    required this.rating,
    required this.onRatingChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            Text('${rating.toStringAsFixed(1)} / ৫.০',
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: List.generate(5, (index) {
            final starValue = index + 1.0;
            return IconButton(
              iconSize: 28,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: Icon(
                rating >= starValue ? Icons.star_rounded : Icons.star_border_rounded,
                color: Colors.amber,
              ),
              onPressed: () => onRatingChanged(starValue),
            );
          }),
        ),
      ],
    );
  }
}
