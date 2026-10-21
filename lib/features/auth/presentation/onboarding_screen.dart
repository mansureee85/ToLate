import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_text_styles.dart';
import '../../../app/route_names.dart';
import '../../../core/widgets/app_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'icon': Icons.travel_explore_rounded,
      'titleBn': 'সহজ প্রশ্নোত্তরে বাসা ও প্রপার্টি খুঁজুন',
      'titleEn': 'Smart Question-Based Property Discovery',
      'descBn': 'বিভাগ, জেলা, থানা এবং এরিয়া সিলেক্ট করে আপনার বাজেটের মধ্যে পছন্দের ফ্ল্যাট, রুম কিংবা সাবলেট খুঁজে নিন।',
      'descEn': 'Filter properties across Bangladesh by location, floor, size, and real verified details.',
    },
    {
      'icon': Icons.video_camera_back_rounded,
      'titleBn': 'আসল ছবি ও ভিডিও ওয়াকথ্রু',
      'titleEn': 'Authentic Photos & Video Walkthroughs',
      'descBn': 'প্রপার্টি ভিজিটের আগেই দেখে নিন ফ্ল্যাট ও ভবনের ভেতরের আসল অবস্থা।',
      'descEn': 'Inspect real property visuals and building facilities before scheduling a viewing.',
    },
    {
      'icon': Icons.verified_user_rounded,
      'titleBn': 'স্বচ্ছ রিভিউ ও নিরাপত্তা',
      'titleEn': 'Transparent Tenant Reviews & Safety',
      'descBn': 'সরাসরি সাবেক ভাড়াটিয়াদের অভিজ্ঞতা জানুন। কোনো ভুয়া রেটিং বা তথ্য ছাড়া নিরাপদ সিদ্ধান্ত নিন।',
      'descEn': 'Read genuine tenant ratings on landlord behavior, flat condition, and neighborhood environment.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () => context.go(RouteNames.home),
            child: const Text('এড়িয়ে যান (Skip)'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            page['icon'] as IconData,
                            size: 72,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 36),
                        Text(
                          page['titleBn'] as String,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.headingLarge,
                        ),
                        const SizedBox(height: 14),
                        Text(
                          page['descBn'] as String,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Dots indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? AppColors.primary
                        : AppColors.borderDark,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
              child: SizedBox(
                width: double.infinity,
                child: AppButton(
                  label: _currentPage == _pages.length - 1
                      ? 'শুরু করুন (Get Started)'
                      : 'পরবর্তী (Next)',
                  onPressed: () {
                    if (_currentPage < _pages.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      context.go(RouteNames.loginPhone);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
