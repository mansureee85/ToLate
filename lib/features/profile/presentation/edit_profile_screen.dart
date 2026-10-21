import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/app_colors.dart';
import '../../../core/errors/error_mapper.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  String? _profilePhotoUrl;
  String? _coverPhotoUrl;
  bool _showPhone = false;
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthRepository>().currentUser;
    _nameController = TextEditingController(text: user?.displayName ?? '');
    _bioController = TextEditingController(text: user?.bio ?? '');
    _profilePhotoUrl = user?.profilePhotoUrl;
    _coverPhotoUrl = user?.coverPhotoUrl;
    _showPhone = user?.privacySettings.showPhoneNumber ?? false;
  }

  Future<void> _handleSave() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _errorMessage = 'আপনার নাম লিখুন।');
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      await context.read<AuthRepository>().updateProfile(
            displayName: name,
            bio: _bioController.text.trim(),
            profilePhotoUrl: _profilePhotoUrl,
            coverPhotoUrl: _coverPhotoUrl,
            privacySettings: UserPrivacySettings(showPhoneNumber: _showPhone),
          );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('প্রোফাইল সফলভাবে আপডেট করা হয়েছে!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      setState(() => _errorMessage = ErrorMapper.mapToMessage(e));
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('প্রোফাইল এডিট')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile & Cover photos pickers
            Row(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.primary,
                      backgroundImage: _profilePhotoUrl != null
                          ? NetworkImage(_profilePhotoUrl!)
                          : null,
                      child: _profilePhotoUrl == null
                          ? const Icon(Icons.person, size: 40, color: Colors.white)
                          : null,
                    ),
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.white,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.camera_alt, size: 16, color: AppColors.primary),
                        onPressed: () {
                          setState(() {
                            _profilePhotoUrl = 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400';
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.wallpaper, size: 18),
                    label: const Text('কভার ছবি পরিবর্তন'),
                    onPressed: () {
                      setState(() {
                        _coverPhotoUrl = 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800';
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            AppTextField(
              controller: _nameController,
              label: 'পূর্ণ নাম (Full Name)',
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _bioController,
              label: 'সংক্ষিপ্ত বায়ো (Bio)',
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('বিজ্ঞাপনে মোবাইল নম্বর উন্মুক্ত রাখুন'),
              subtitle: const Text('বন্ধ রাখলে কেবল ইন-অ্যাপ বার্তার মাধ্যমে যোগাযোগ করা যাবে।'),
              value: _showPhone,
              activeColor: AppColors.primary,
              onChanged: (val) => setState(() => _showPhone = val),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(_errorMessage!, style: const TextStyle(color: AppColors.error)),
            ],
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                label: 'সংরক্ষণ করুন (Save)',
                isLoading: _isSaving,
                onPressed: _handleSave,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
