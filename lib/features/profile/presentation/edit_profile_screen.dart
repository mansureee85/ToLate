import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/app_colors.dart';
import '../../../core/errors/error_mapper.dart';
import '../../../core/media/media_picker.dart';
import '../../../core/services/profile_media_service.dart';
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

  // Remote URLs from user profile
  String? _currentProfilePhotoUrl;
  String? _currentCoverPhotoUrl;

  // Pending picked images in memory before upload
  Uint8List? _pendingProfileBytes;
  String? _pendingProfileMimeType;
  bool _profileRemoved = false;

  Uint8List? _pendingCoverBytes;
  String? _pendingCoverMimeType;
  bool _coverRemoved = false;

  bool _showPhone = false;
  bool _isSaving = false;
  String? _errorMessage;

  final MediaPicker _mediaPicker = getPlatformMediaPicker();

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthRepository>().currentUser;
    _nameController = TextEditingController(text: user?.displayName ?? '');
    _bioController = TextEditingController(text: user?.bio ?? '');
    _currentProfilePhotoUrl = user?.profilePhotoUrl;
    _currentCoverPhotoUrl = user?.coverPhotoUrl;
    _showPhone = user?.privacySettings.showPhoneNumber ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  bool get _hasProfilePhoto {
    if (_profileRemoved) return false;
    return _pendingProfileBytes != null || (_currentProfilePhotoUrl != null && _currentProfilePhotoUrl!.isNotEmpty);
  }

  bool get _hasCoverPhoto {
    if (_coverRemoved) return false;
    return _pendingCoverBytes != null || (_currentCoverPhotoUrl != null && _currentCoverPhotoUrl!.isNotEmpty);
  }

  ImageProvider? get _profileImageProvider {
    if (_profileRemoved) return null;
    if (_pendingProfileBytes != null) {
      return MemoryImage(_pendingProfileBytes!);
    }
    if (_currentProfilePhotoUrl != null && _currentProfilePhotoUrl!.isNotEmpty) {
      return NetworkImage(_currentProfilePhotoUrl!);
    }
    return null;
  }

  ImageProvider? get _coverImageProvider {
    if (_coverRemoved) return null;
    if (_pendingCoverBytes != null) {
      return MemoryImage(_pendingCoverBytes!);
    }
    if (_currentCoverPhotoUrl != null && _currentCoverPhotoUrl!.isNotEmpty) {
      return NetworkImage(_currentCoverPhotoUrl!);
    }
    return null;
  }

  // --- Profile Photo Actions ---

  Future<void> _pickProfilePhoto(MediaSourceType source) async {
    try {
      final picked = await _mediaPicker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (picked != null) {
        setState(() {
          _pendingProfileBytes = picked.bytes;
          _pendingProfileMimeType = picked.mimeType;
          _profileRemoved = false;
          _errorMessage = null;
        });
      }
    } catch (e) {
      setState(() => _errorMessage = ErrorMapper.mapToMessage(e));
    }
  }

  void _showProfilePhotoOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Wrap(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('প্রোফাইল ছবি নির্বাচন করুন', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppColors.primary),
                title: const Text('ক্যামেরা দিয়ে ছবি তুলুন (Camera)'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickProfilePhoto(MediaSourceType.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: AppColors.primary),
                title: const Text('গ্যালারি থেকে ছবি বেছে নিন (Gallery)'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickProfilePhoto(MediaSourceType.gallery);
                },
              ),
              if (_hasProfilePhoto) ...[
                ListTile(
                  leading: const Icon(Icons.visibility, color: AppColors.textSecondary),
                  title: const Text('ছবিটি বড় করে দেখুন (Preview)'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _showImagePreviewDialog(
                      title: 'প্রোফাইল ছবি প্রিভিউ',
                      imageProvider: _profileImageProvider!,
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: AppColors.error),
                  title: const Text('ছবি সরিয়ে ফেলুন (Remove)', style: TextStyle(color: AppColors.error)),
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() {
                      _pendingProfileBytes = null;
                      _profileRemoved = true;
                    });
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  // --- Cover Photo Actions ---

  Future<void> _pickCoverPhoto(MediaSourceType source) async {
    try {
      final picked = await _mediaPicker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (picked != null) {
        setState(() {
          _pendingCoverBytes = picked.bytes;
          _pendingCoverMimeType = picked.mimeType;
          _coverRemoved = false;
          _errorMessage = null;
        });
      }
    } catch (e) {
      setState(() => _errorMessage = ErrorMapper.mapToMessage(e));
    }
  }

  void _showCoverPhotoOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Wrap(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('কভার ছবি নির্বাচন করুন', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppColors.primary),
                title: const Text('ক্যামেরা দিয়ে ছবি তুলুন (Camera)'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickCoverPhoto(MediaSourceType.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: AppColors.primary),
                title: const Text('গ্যালারি থেকে ছবি বেছে নিন (Gallery)'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickCoverPhoto(MediaSourceType.gallery);
                },
              ),
              if (_hasCoverPhoto) ...[
                ListTile(
                  leading: const Icon(Icons.visibility, color: AppColors.textSecondary),
                  title: const Text('কভার ছবিটি বড় করে দেখুন (Preview)'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _showImagePreviewDialog(
                      title: 'কভার ছবি প্রিভিউ',
                      imageProvider: _coverImageProvider!,
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: AppColors.error),
                  title: const Text('কভার ছবি সরিয়ে ফেলুন (Remove)', style: TextStyle(color: AppColors.error)),
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() {
                      _pendingCoverBytes = null;
                      _coverRemoved = true;
                    });
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  void _showImagePreviewDialog({
    required String title,
    required ImageProvider imageProvider,
  }) {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: const BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
                child: Image(
                  image: imageProvider,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- Save / Upload Logic ---

  Future<void> _handleSave() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _errorMessage = 'আপনার নাম লিখুন।');
      return;
    }

    final authRepo = context.read<AuthRepository>();
    final user = authRepo.currentUser;
    if (user == null) {
      setState(() => _errorMessage = 'লগইন করা ব্যবহারকারী পাওয়া যায়নি।');
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      String? finalProfilePhotoUrl = _currentProfilePhotoUrl;
      String? finalCoverPhotoUrl = _currentCoverPhotoUrl;
      bool profileChanged = false;
      bool coverChanged = false;

      // 1. Handle Profile Picture Upload or Removal
      if (_pendingProfileBytes != null) {
        finalProfilePhotoUrl = await ProfileMediaService.uploadProfilePhoto(
          userId: user.id,
          bytes: _pendingProfileBytes!,
          mimeType: _pendingProfileMimeType ?? 'image/jpeg',
        );
        profileChanged = true;
      } else if (_profileRemoved) {
        await ProfileMediaService.deleteProfilePhoto(user.id);
        finalProfilePhotoUrl = null;
        profileChanged = true;
      }

      // 2. Handle Cover Photo Upload or Removal
      if (_pendingCoverBytes != null) {
        finalCoverPhotoUrl = await ProfileMediaService.uploadCoverPhoto(
          userId: user.id,
          bytes: _pendingCoverBytes!,
          mimeType: _pendingCoverMimeType ?? 'image/jpeg',
        );
        coverChanged = true;
      } else if (_coverRemoved) {
        await ProfileMediaService.deleteCoverPhoto(user.id);
        finalCoverPhotoUrl = null;
        coverChanged = true;
      }

      // 3. Update Firestore User Document (Only after storage uploads succeed!)
      await ProfileMediaService.updateFirestoreUserPhotos(
        userId: user.id,
        profilePhotoUrl: finalProfilePhotoUrl,
        coverPhotoUrl: finalCoverPhotoUrl,
        updateProfile: profileChanged,
        updateCover: coverChanged,
      );

      // 4. Update Auth Repository Session in memory
      await authRepo.updateProfile(
        displayName: name,
        bio: _bioController.text.trim(),
        profilePhotoUrl: finalProfilePhotoUrl,
        coverPhotoUrl: finalCoverPhotoUrl,
        privacySettings: UserPrivacySettings(showPhoneNumber: _showPhone),
      );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('প্রোফাইল এবং ছবি সফলভাবে সংরক্ষিত হয়েছে!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      setState(() => _errorMessage = ErrorMapper.mapToMessage(e));
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('প্রোফাইল এডিট')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover Photo Area with Overlay Avatar
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomLeft,
              children: [
                // Cover Banner
                InkWell(
                  onTap: _showCoverPhotoOptions,
                  child: Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight.withOpacity(0.3),
                      image: _coverImageProvider != null
                          ? DecorationImage(
                              image: _coverImageProvider!,
                              fit: BoxFit.cover,
                            )
                          : null,
                      gradient: _coverImageProvider == null
                          ? const LinearGradient(
                              colors: [Color(0xFF0D5C3A), Color(0xFF1E824C)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                    ),
                    child: Stack(
                      children: [
                        if (!_hasCoverPhoto)
                          const Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.add_photo_alternate_outlined, color: Colors.white70, size: 36),
                                SizedBox(height: 6),
                                Text(
                                  'কভার ছবি যোগ করুন (Tap to add Cover Photo)',
                                  style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        Positioned(
                          right: 12,
                          bottom: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.camera_alt, color: Colors.white, size: 16),
                                SizedBox(width: 6),
                                Text(
                                  'কভার পরিবর্তন',
                                  style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Profile Avatar positioned on bottom-left
                Positioned(
                  bottom: -40,
                  left: 20,
                  child: GestureDetector(
                    onTap: _showProfilePhotoOptions,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            radius: 44,
                            backgroundColor: AppColors.primary,
                            backgroundImage: _profileImageProvider,
                            child: !_hasProfilePhoto
                                ? const Icon(Icons.person, size: 48, color: Colors.white)
                                : null,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 54),

            // Profile info and fields
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      OutlinedButton.icon(
                        icon: const Icon(Icons.person, size: 18),
                        label: const Text('প্রোফাইল ছবি অপশন'),
                        onPressed: _showProfilePhotoOptions,
                      ),
                      const SizedBox(width: 10),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.image, size: 18),
                        label: const Text('কভার ছবি অপশন'),
                        onPressed: _showCoverPhotoOptions,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  AppTextField(
                    controller: _nameController,
                    label: 'পূর্ণ নাম (Full Name)',
                    hint: 'আপনার পূর্ণ নাম লিখুন',
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _bioController,
                    label: 'সংক্ষিপ্ত বায়ো (Bio)',
                    hint: 'যেমন: ফ্ল্যাট মালিক, মিরপুর ডিওএইচএস',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('বিজ্ঞাপনে মোবাইল নম্বর উন্মুক্ত রাখুন'),
                    subtitle: const Text('বন্ধ রাখলে কেবল ইন-অ্যাপ বার্তার মাধ্যমে যোগাযোগ করা যাবে।'),
                    value: _showPhone,
                    activeColor: AppColors.primary,
                    onChanged: (val) => setState(() => _showPhone = val),
                  ),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.error),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: AppColors.error, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(_errorMessage!, style: const TextStyle(color: AppColors.error, fontSize: 13)),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      label: 'সংরক্ষণ করুন (Save Profile)',
                      isLoading: _isSaving,
                      onPressed: _handleSave,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
