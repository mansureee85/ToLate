import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_text_styles.dart';
import '../../../app/route_names.dart';
import '../../../core/constants/property_enums.dart';
import '../../../core/widgets/app_button.dart';
import '../../../data/repositories/auth_repository.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  final Set<UserRole> _selectedRoles = {UserRole.tenant};

  final List<Map<String, dynamic>> _roleOptions = [
    {
      'role': UserRole.tenant,
      'titleBn': 'ভাড়াটিয়া (Tenant / Renter)',
      'descBn': 'আমি বাসা, ফ্ল্যাট, রুম কিংবা সাবলেট ভাড়া নিতে চাই।',
      'icon': Icons.home_rounded,
    },
    {
      'role': UserRole.owner,
      'titleBn': 'বাড়ির মালিক / ল্যান্ডলর্ড (Landlord / Owner)',
      'descBn': 'আমার নিজস্ব ফ্ল্যাট, বাড়ি বা বাণিজ্যিক স্পেস ভাড়া দিতে চাই।',
      'icon': Icons.domain_rounded,
    },
    {
      'role': UserRole.buyer,
      'titleBn': 'প্রপার্টি ক্রেতা (Buyer)',
      'descBn': 'আমি জমি, ফ্ল্যাট বা বাণিজ্যিক প্রপার্টি কিনতে চাই।',
      'icon': Icons.shopping_bag_outlined,
    },
    {
      'role': UserRole.seller,
      'titleBn': 'প্রপার্টি বিক্রেতা (Seller)',
      'descBn': 'আমি আমার জমি বা ফ্ল্যাট বিক্রির জন্য বিজ্ঞাপন দিতে চাই।',
      'icon': Icons.sell_outlined,
    },
    {
      'role': UserRole.agent,
      'titleBn': 'অনুমোদিত এজেন্ট (Authorized Agent)',
      'descBn': 'আমি পেশাদারভাবে মালিকদের পক্ষে প্রপার্টি পরিচালনা করি।',
      'icon': Icons.badge_outlined,
    },
  ];

  Future<void> _handleContinue() async {
    final authRepo = context.read<AuthRepository>();
    await authRepo.updateProfile(roles: _selectedRoles.toList());
    if (mounted) {
      context.go(RouteNames.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 600;

    return Scaffold(
      backgroundColor: isWide ? const Color(0xFFF3F4F6) : Colors.white,
      appBar: AppBar(
        title: const Text('আপনার পরিচয় নির্বাচন করুন'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 540),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(isWide ? 16 : 0),
                border: isWide ? Border.all(color: AppColors.border, width: 1.2) : null,
                boxShadow: isWide
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ]
                    : null,
              ),
              margin: EdgeInsets.all(isWide ? 24.0 : 0.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        Text(
                          'আপনি ToLate কীভাবে ব্যবহার করতে চান?',
                          style: AppTextStyles.headingMedium,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'একাধিক ভূমিকা নির্বাচন করতে পারেন। পরবর্তীতে সেটিংস থেকে পরিবর্তন করা যাবে।',
                          style: AppTextStyles.bodyMedium,
                        ),
                        const SizedBox(height: 20),
                        ..._roleOptions.map((opt) {
                          final role = opt['role'] as UserRole;
                          final isSelected = _selectedRoles.contains(role);

                          return InkWell(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  if (_selectedRoles.length > 1) {
                                    _selectedRoles.remove(role);
                                  }
                                } else {
                                  _selectedRoles.add(role);
                                }
                              });
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primaryLight.withOpacity(0.4)
                                    : AppColors.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected ? AppColors.primary : AppColors.border,
                                  width: isSelected ? 1.8 : 1.0,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.primary
                                          : AppColors.surfaceVariant,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      opt['icon'] as IconData,
                                      color: isSelected
                                          ? Colors.white
                                          : AppColors.textSecondary,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          opt['titleBn'] as String,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: isSelected
                                                ? AppColors.primary
                                                : AppColors.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          opt['descBn'] as String,
                                          style: AppTextStyles.bodySmall.copyWith(
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Checkbox(
                                    value: isSelected,
                                    activeColor: AppColors.primary,
                                    onChanged: (val) {
                                      setState(() {
                                        if (val == true) {
                                          _selectedRoles.add(role);
                                        } else if (_selectedRoles.length > 1) {
                                          _selectedRoles.remove(role);
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        label: 'প্রবেশ করুন (Complete Setup)',
                        onPressed: _handleContinue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

