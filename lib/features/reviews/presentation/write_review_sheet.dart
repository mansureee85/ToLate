import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_text_styles.dart';
import '../../../core/errors/error_mapper.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/review_repository.dart';
import 'widgets/star_rating_selector.dart';

class WriteReviewSheet extends StatefulWidget {
  final String? buildingId;
  final String? unitId;
  final String? landlordUserId;

  const WriteReviewSheet({
    super.key,
    this.buildingId,
    this.unitId,
    this.landlordUserId,
  });

  static Future<void> show(
    BuildContext context, {
    String? buildingId,
    String? unitId,
    String? landlordUserId,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => WriteReviewSheet(
        buildingId: buildingId,
        unitId: unitId,
        landlordUserId: landlordUserId,
      ),
    );
  }

  @override
  State<WriteReviewSheet> createState() => _WriteReviewSheetState();
}

class _WriteReviewSheetState extends State<WriteReviewSheet> {
  double _landlordRating = 5.0;
  double _propertyRating = 4.0;
  double _neighborhoodRating = 4.5;
  int _tenancyMonths = 12;
  String? _moveOutReason = 'চাকরি বা পড়ার কারণে স্থানান্তর';
  bool _wouldRentAgain = true;

  final TextEditingController _reviewTextController = TextEditingController();
  final List<String> _photos = [];
  bool _isSubmitting = false;
  String? _errorMessage;

  final List<String> _moveOutOptions = [
    'চাকরি বা পড়ার কারণে স্থানান্তর',
    'ভাড়া বৃদ্ধির কারণে',
    'মালিকের সাথে সমস্যা',
    'ফ্ল্যাটের রক্ষণাবেক্ষণ সমস্যা',
    'এলাকার পরিবেশগত কারণে',
    'পারিবারিক বা ব্যক্তিগত কারণ',
    'অন্যান্য',
  ];

  Future<void> _handleSubmit() async {
    final text = _reviewTextController.text.trim();
    if (text.length < 10) {
      setState(() => _errorMessage = 'অনুগ্রহ করে কমপক্ষে ১০ অক্ষরের বিবরণ লিখুন।');
      return;
    }

    final auth = context.read<AuthRepository>();
    if (!auth.isAuthenticated) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final user = auth.currentUser!;
      await context.read<ReviewRepository>().submitReview(
            authorUserId: user.id,
            authorDisplayName: user.displayName ?? 'ভাড়াটিয়া',
            buildingId: widget.buildingId,
            unitId: widget.unitId,
            landlordUserId: widget.landlordUserId,
            landlordRating: _landlordRating,
            propertyRating: _propertyRating,
            neighborhoodRating: _neighborhoodRating,
            writtenReview: text,
            photoUrls: _photos,
            tenancyDurationMonths: _tenancyMonths,
            moveOutReason: _moveOutReason,
            wouldRentAgain: _wouldRentAgain,
          );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('আপনার রিভিউটি সফলভাবে জমা হয়েছে!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      setState(() => _errorMessage = ErrorMapper.mapToMessage(e));
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _reviewTextController.dispose();
    super.dispose();
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
        maxHeight: MediaQuery.of(context).size.height * 0.9,
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
              Text('ভাড়াটিয়া হিসেবে রিভিউ লিখুন', style: AppTextStyles.headingSmall),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: ListView(
              children: [
                // 1. Star ratings
                StarRatingSelector(
                  label: '১. বাড়ির মালিকের আচরণ ও সহযোগিতা',
                  rating: _landlordRating,
                  onRatingChanged: (val) => setState(() => _landlordRating = val),
                ),
                const SizedBox(height: 12),
                StarRatingSelector(
                  label: '২. ফ্ল্যাটের সার্বিক অবস্থা ও সেবা (পানি, গ্যাস, ইত্যাদি)',
                  rating: _propertyRating,
                  onRatingChanged: (val) => setState(() => _propertyRating = val),
                ),
                const SizedBox(height: 12),
                StarRatingSelector(
                  label: '৩. এলাকার নিরাপত্তা ও যাতায়াত পরিবেশ',
                  rating: _neighborhoodRating,
                  onRatingChanged: (val) => setState(() => _neighborhoodRating = val),
                ),
                const SizedBox(height: 16),

                // 2. Tenancy Duration
                Row(
                  children: [
                    const Text('কতদিন ভাড়া ছিলেন:', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(width: 12),
                    DropdownButton<int>(
                      value: _tenancyMonths,
                      items: [3, 6, 12, 24, 36].map((m) {
                        return DropdownMenuItem(value: m, child: Text('$m মাস'));
                      }).toList(),
                      onChanged: (val) => setState(() => _tenancyMonths = val ?? 12),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // 3. Move out reason
                DropdownButtonFormField<String>(
                  value: _moveOutReason,
                  decoration: const InputDecoration(labelText: 'বাসা ছাড়ার কারণ (ঐচ্ছিক)'),
                  items: _moveOutOptions
                      .map((opt) => DropdownMenuItem(value: opt, child: Text(opt, style: const TextStyle(fontSize: 13))))
                      .toList(),
                  onChanged: (val) => setState(() => _moveOutReason = val),
                ),
                const SizedBox(height: 16),

                // 4. Written review text
                AppTextField(
                  controller: _reviewTextController,
                  label: 'আপনার ব্যক্তিগত অভিজ্ঞতা লিখুন',
                  hint: 'অন্যান্য ভাড়াটিয়াদের উপকারে আসে এমন সত্য ও নিরপেক্ষ মতামত দিন...',
                  maxLines: 4,
                  onVoicePressed: () {
                    setState(() {
                      _reviewTextController.text += ' মালিক অত্যন্ত সজ্জন ব্যক্তি ছিলেন এবং সময়মতো সব সমাধান করে দিতেন।';
                    });
                  },
                ),
                const SizedBox(height: 14),

                // 5. Photos only (Disallow video rule)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('প্রমাণস্বরূপ ছবি যুক্ত করুন (ছবি কেবল, ভিডিও অনুমোদিত নয়)',
                        style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
                    TextButton.icon(
                      icon: const Icon(Icons.add_photo_alternate_outlined, size: 16),
                      label: const Text('ছবি দিন'),
                      onPressed: () {
                        setState(() {
                          _photos.add('https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=600');
                        });
                      },
                    ),
                  ],
                ),
                if (_photos.isNotEmpty)
                  SizedBox(
                    height: 60,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: _photos.map((p) => Container(
                        width: 60,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          image: DecorationImage(image: NetworkImage(p), fit: BoxFit.cover),
                        ),
                      )).toList(),
                    ),
                  ),

                const SizedBox(height: 14),
                // 6. Would rent again?
                SwitchListTile(
                  title: const Text('আপনি কি পুনরায় এই বাসা ভাড়া নিতে আগ্রহী থাকবেন?',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  value: _wouldRentAgain,
                  activeColor: AppColors.primary,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (val) => setState(() => _wouldRentAgain = val),
                ),

                if (_errorMessage != null) ...[
                  const SizedBox(height: 8),
                  Text(_errorMessage!, style: const TextStyle(color: AppColors.error, fontSize: 13)),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: 'রিভিউ সাবমিট করুন',
              isLoading: _isSubmitting,
              onPressed: _handleSubmit,
            ),
          ),
        ],
      ),
    );
  }
}
