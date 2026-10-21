import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_text_styles.dart';
import '../../../app/route_names.dart';
import '../../../core/constants/property_enums.dart';
import '../../../core/errors/error_mapper.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../data/models/location_models.dart';
import '../../../data/models/property_listing_model.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/location_repository.dart';
import '../../../data/repositories/property_repository.dart';

/// Full interactive question-based listing wizard.
class PropertyWizardStartScreen extends StatefulWidget {
  const PropertyWizardStartScreen({super.key});

  @override
  State<PropertyWizardStartScreen> createState() => _PropertyWizardStartScreenState();
}

class _PropertyWizardStartScreenState extends State<PropertyWizardStartScreen> {
  int _step = 0; // 0: Category, 1: Owner/Agent, 2: Location, 3: Specs/Price, 4: Media, 5: Preview

  // Step 0: Category
  PropertyIntent _intent = PropertyIntent.flatRent;
  final TextEditingController _customCategoryController = TextEditingController();

  // Step 1: Role Declaration
  bool _isOwner = true; // true = Owner, false = Authorized Agent
  final TextEditingController _agentAgencyController = TextEditingController();

  // Step 2: Location
  LocationDivision? _division;
  LocationDistrict? _district;
  LocationUpazilaThana? _upazila;
  String? _areaName;
  final TextEditingController _customAreaController = TextEditingController();
  final TextEditingController _addressDetailController = TextEditingController();

  // Step 3: Specs & Price
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _advanceController = TextEditingController();
  final TextEditingController _serviceChargeController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  int _bedrooms = 2;
  int _bathrooms = 2;
  int _balconies = 1;
  int _floorNumber = 3;
  int _totalBuildingFloors = 6;
  bool _isNegotiable = false;
  final Set<String> _amenities = {'লিফট', 'জেনারেটর', 'গ্যাস লাইন'};

  // Step 4: Media (Photos & Walkthrough Video)
  final List<String> _photoUrls = [];
  String? _videoUrl;

  // Step 5: Description with voice input
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _photoUrls.add('https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800');
  }

  void _generateDefaultTitleAndDescription() {
    final area = _areaName ?? _customAreaController.text.trim();
    final thana = _upazila?.nameBn ?? '';
    final intentName = _intent.displayNameBn;

    _titleController.text = '$area, $thana - $_bedrooms বেডরুমে মনোরম $intentName';
    _descriptionController.text =
        'লোকেশন: $area, $thana। $_bedrooms বেডরুম, $_bathrooms বাথরুম ও $_balconies টি বারান্দা সহ সম্পূর্ণ টাইলসকৃত ফ্ল্যাট ভাড়া দেওয়া হবে। মোট আয়তন ${_sizeController.text.isNotEmpty ? _sizeController.text : "১২০০"} স্কয়ার ফিট, ভবনের $_floorNumber তলায় অবস্থিত। সুযোগ-সুবিধা: ${_amenities.join(", ")}।';
  }

  Future<void> _submitListing() async {
    final authRepo = context.read<AuthRepository>();
    if (!authRepo.isAuthenticated) {
      context.push(RouteNames.loginPhone);
      return;
    }

    if (_priceController.text.trim().isEmpty) {
      setState(() => _errorMessage = 'ভাড়া বা মূল্যের পরিমাণ দিন।');
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final propertyRepo = context.read<PropertyRepository>();
      final locationRepo = context.read<LocationRepository>();
      final user = authRepo.currentUser!;

      final effectiveArea = _areaName ??
          (_customAreaController.text.trim().isNotEmpty
              ? _customAreaController.text.trim()
              : 'সংশ্লিষ্ট এলাকা');

      // If user typed a new area, register as ProposedArea
      if (_areaName == null && _customAreaController.text.trim().isNotEmpty) {
        await locationRepo.proposeNewArea(
          typedAreaName: effectiveArea,
          division: _division?.nameBn ?? 'ঢাকা',
          district: _district?.nameBn ?? 'ঢাকা',
          upazilaThana: _upazila?.nameBn ?? 'মিরপুর',
          submittedByUserId: user.id,
        );
      }

      // 1. Create Building profile
      final building = await propertyRepo.createBuilding(
        ownerUserId: user.id,
        buildingName: 'রেসিডেন্সিয়াল ভবন',
        division: _division?.nameBn ?? 'ঢাকা',
        district: _district?.nameBn ?? 'ঢাকা',
        upazilaThana: _upazila?.nameBn ?? 'মিরপুর',
        area: effectiveArea,
        addressText: _addressDetailController.text.trim(),
        totalFloors: _totalBuildingFloors,
        commonAmenities: _amenities.toList(),
        photoUrls: _photoUrls,
      );

      // 2. Create Unit
      final unit = await propertyRepo.createUnit(
        buildingId: building.id,
        unitNumber: 'ফ্ল্যাট $_floorNumber/A',
        floorNumber: _floorNumber,
        propertyIntent: _intent,
        bedrooms: _bedrooms,
        bathrooms: _bathrooms,
        balconies: _balconies,
        areaSqFt: double.tryParse(_sizeController.text.trim()) ?? 1000.0,
        rentOrSalePrice: double.tryParse(_priceController.text.trim()) ?? 0.0,
        advanceDepositAmount: double.tryParse(_advanceController.text.trim()),
        serviceCharge: double.tryParse(_serviceChargeController.text.trim()),
        unitAmenities: _amenities.toList(),
        photoUrls: _photoUrls,
        videoUrl: _videoUrl,
        availableFromDate: DateTime.now().add(const Duration(days: 7)),
        createdByUserId: user.id,
      );

      // 3. Create Listing record
      final listing = PropertyListingModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        buildingId: building.id,
        unitId: unit.id,
        ownerUserId: user.id,
        propertyIntent: _intent,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        division: building.division,
        district: building.district,
        upazilaThana: building.upazilaThana,
        area: building.area,
        addressText: building.addressText,
        price: double.tryParse(_priceController.text.trim()) ?? 0.0,
        advanceDeposit: double.tryParse(_advanceController.text.trim()),
        serviceCharge: double.tryParse(_serviceChargeController.text.trim()),
        isPriceNegotiable: _isNegotiable,
        bedrooms: _bedrooms,
        bathrooms: _bathrooms,
        balconies: _balconies,
        areaSqFt: double.tryParse(_sizeController.text.trim()) ?? 1000.0,
        floorNumber: _floorNumber,
        totalBuildingFloors: _totalBuildingFloors,
        amenities: _amenities.toList(),
        photoUrls: _photoUrls,
        videoUrl: _videoUrl,
        status: ListingStatus.published, // Published in database
        verificationBadges: const [VerificationBadgeType.phoneVerified],
        lastConfirmedAt: DateTime.now(),
        publishedAt: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await propertyRepo.createListing(listing);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('আপনার বিজ্ঞাপনটি সফলভাবে প্রকাশিত হয়েছে!'),
            backgroundColor: AppColors.success,
          ),
        );
        context.go(RouteNames.home);
      }
    } catch (e) {
      setState(() => _errorMessage = ErrorMapper.mapToMessage(e));
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _customCategoryController.dispose();
    _agentAgencyController.dispose();
    _customAreaController.dispose();
    _addressDetailController.dispose();
    _priceController.dispose();
    _advanceController.dispose();
    _serviceChargeController.dispose();
    _sizeController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locationRepo = context.watch<LocationRepository>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('বিজ্ঞাপন পোস্ট উইজার্ড (Post Property)'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (_step + 1) / 6,
              backgroundColor: AppColors.border,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('ধাপ ${_step + 1} / ৬', style: AppTextStyles.bodySmall),
                  Text(_getStepTitle(), style: AppTextStyles.headingSmall.copyWith(fontSize: 14)),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: _buildCurrentStep(locationRepo),
              ),
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                child: Text(_errorMessage!, style: const TextStyle(color: AppColors.error, fontSize: 13)),
              ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: [
                  if (_step > 0) ...[
                    Expanded(
                      child: AppButton(
                        label: 'পূর্ববর্তী',
                        isOutlined: true,
                        onPressed: () => setState(() => _step--),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    flex: 2,
                    child: AppButton(
                      label: _step == 5 ? 'বিজ্ঞাপন প্রকাশ করুন' : 'পরবর্তী ধাপ',
                      isLoading: _isSubmitting,
                      onPressed: () {
                        if (_step < 5) {
                          if (_step == 4) {
                            _generateDefaultTitleAndDescription();
                          }
                          setState(() => _step++);
                        } else {
                          _submitListing();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStepTitle() {
    switch (_step) {
      case 0:
        return 'বিজ্ঞাপনের ধরন';
      case 1:
        return 'মালিকানা তথ্য';
      case 2:
        return 'লোকেশন ও ঠিকানা';
      case 3:
        return 'ভাড়া ও সুযোগ-সুবিধা';
      case 4:
        return 'ছবি ও ভিডিও';
      case 5:
        return 'বিজ্ঞাপনের বিবরণ ও প্রিভিউ';
      default:
        return '';
    }
  }

  Widget _buildCurrentStep(LocationRepository locRepo) {
    switch (_step) {
      case 0:
        return _step0Category();
      case 1:
        return _step1Ownership();
      case 2:
        return _step2Location(locRepo);
      case 3:
        return _step3SpecsAndPrice();
      case 4:
        return _step4Media();
      case 5:
        return _step5Preview();
      default:
        return const SizedBox.shrink();
    }
  }

  // STEP 0: Category
  Widget _step0Category() {
    final intents = [
      PropertyIntent.flatRent,
      PropertyIntent.houseRent,
      PropertyIntent.roomRent,
      PropertyIntent.sublet,
      PropertyIntent.flatSale,
      PropertyIntent.houseSale,
      PropertyIntent.landSale,
      PropertyIntent.officeRent,
      PropertyIntent.shopRent,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('আপনি কী বিজ্ঞাপন দিতে চান?', style: AppTextStyles.headingMedium),
        const SizedBox(height: 8),
        Text('সঠিক ক্যাটাগরি বেছে নিন:', style: AppTextStyles.bodyMedium),
        const SizedBox(height: 16),
        ...intents.map((intent) {
          final isSel = _intent == intent;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: isSel ? AppColors.primary : AppColors.border),
              ),
              tileColor: isSel ? AppColors.primaryLight.withOpacity(0.3) : AppColors.surface,
              title: Text(intent.displayNameBn, style: TextStyle(fontWeight: isSel ? FontWeight.bold : FontWeight.normal)),
              trailing: isSel ? const Icon(Icons.check_circle, color: AppColors.primary) : null,
              onTap: () => setState(() => _intent = intent),
            ),
          );
        }),
      ],
    );
  }

  // STEP 1: Ownership
  Widget _step1Ownership() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('আপনি কি প্রপার্টির প্রকৃত মালিক না এজেন্ট?', style: AppTextStyles.headingMedium),
        const SizedBox(height: 16),
        RadioListTile<bool>(
          title: const Text('আমি প্রপার্টির প্রকৃত মালিক (Owner / Landlord)'),
          subtitle: const Text('আমি আমার নিজস্ব প্রপার্টি ভাড়া বা বিক্রি করছি।'),
          value: true,
          groupValue: _isOwner,
          activeColor: AppColors.primary,
          onChanged: (val) => setState(() => _isOwner = val ?? true),
        ),
        RadioListTile<bool>(
          title: const Text('আমি অনুমোদিত প্রতিনিধি / এজেন্ট (Authorized Agent)'),
          subtitle: const Text('মালিকের লিখিত বা মৌখিক সম্মতিতে আমি বিজ্ঞাপন দিচ্ছি।'),
          value: false,
          groupValue: _isOwner,
          activeColor: AppColors.primary,
          onChanged: (val) => setState(() => _isOwner = val ?? false),
        ),
        if (!_isOwner) ...[
          const SizedBox(height: 16),
          AppTextField(
            controller: _agentAgencyController,
            label: 'এজেন্সি বা প্রতিষ্ঠানের নাম (ঐচ্ছিক)',
            hint: 'যেমন: ধানমন্ডি প্রপার্টি কেয়ার',
          ),
        ],
      ],
    );
  }

  // STEP 2: Location
  Widget _step2Location(LocationRepository locRepo) {
    final districts = _division != null ? locRepo.getDistrictsForDivision(_division!.id) : <LocationDistrict>[];
    final upazilas = _district != null ? locRepo.getUpazilasForDistrict(_district!.id) : <LocationUpazilaThana>[];
    final areas = _upazila != null ? locRepo.getAreasForUpazila(_upazila!.id) : <CanonicalArea>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('প্রপার্টির সঠিক লোকেশন নির্ধারণ করুন', style: AppTextStyles.headingMedium),
        const SizedBox(height: 16),
        DropdownButtonFormField<LocationDivision>(
          value: _division,
          decoration: const InputDecoration(labelText: 'বিভাগ'),
          items: locRepo.divisions.map((d) => DropdownMenuItem(value: d, child: Text(d.nameBn))).toList(),
          onChanged: (d) => setState(() {
            _division = d;
            _district = null;
            _upazila = null;
            _areaName = null;
          }),
        ),
        const SizedBox(height: 12),
        if (_division != null)
          DropdownButtonFormField<LocationDistrict>(
            value: _district,
            decoration: const InputDecoration(labelText: 'জেলা'),
            items: districts.map((d) => DropdownMenuItem(value: d, child: Text(d.nameBn))).toList(),
            onChanged: (d) => setState(() {
              _district = d;
              _upazila = null;
              _areaName = null;
            }),
          ),
        const SizedBox(height: 12),
        if (_district != null)
          DropdownButtonFormField<LocationUpazilaThana>(
            value: _upazila,
            decoration: const InputDecoration(labelText: 'থানা / উপজেলা'),
            items: upazilas.map((u) => DropdownMenuItem(value: u, child: Text(u.nameBn))).toList(),
            onChanged: (u) => setState(() {
              _upazila = u;
              _areaName = null;
            }),
          ),
        const SizedBox(height: 12),
        if (_upazila != null) ...[
          if (areas.isNotEmpty) ...[
            DropdownButtonFormField<String>(
              value: _areaName,
              decoration: const InputDecoration(labelText: 'এরিয়া / এলাকা'),
              items: areas.map((a) => DropdownMenuItem(value: a.nameBn, child: Text(a.nameBn))).toList(),
              onChanged: (a) => setState(() => _areaName = a),
            ),
            const SizedBox(height: 12),
          ],
          AppTextField(
            controller: _customAreaController,
            label: 'রাস্তা / সেক্টর / নির্দিষ্ট এলাকার নাম',
            hint: 'যেমন: রোড ১০/এ, সেক্টর ৪',
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _addressDetailController,
            label: 'বিস্তারিত ঠিকানা (বাড়ি/প্লট নম্বর)',
            hint: 'বাড়ি # ১২, হোল্ডিং # ৩',
            helperText: 'গোপনীয়তার স্বার্থে সঠিক ফ্ল্যাট ও বাড়ি নম্বর সর্বসাধারণের কাছে গোপন রাখা হবে।',
          ),
        ],
      ],
    );
  }

  // STEP 3: Specs & Price
  Widget _step3SpecsAndPrice() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ভাড়া ও প্রপার্টির সাইজ', style: AppTextStyles.headingMedium),
        const SizedBox(height: 16),
        AppTextField(
          controller: _priceController,
          label: 'মাসিক ভাড়া (টাকা)',
          hint: 'যেমন: ২০০০০',
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: AppTextField(
                controller: _advanceController,
                label: 'অগ্রিম / জামানত (টাকা)',
                hint: 'যেমন: ৪০০০০',
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppTextField(
                controller: _serviceChargeController,
                label: 'সার্ভিস চার্জ (টাকা)',
                hint: 'যেমন: ৩০০০',
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Checkbox(
              value: _isNegotiable,
              activeColor: AppColors.primary,
              onChanged: (val) => setState(() => _isNegotiable = val ?? false),
            ),
            const Text('ভাড়া আলোচনা সাপেক্ষ (Negotiable)'),
          ],
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _sizeController,
          label: 'মোট আয়তন (স্কয়ার ফিট)',
          hint: 'যেমন: ১২৫০',
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('বেডরুম:', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    if (_bedrooms > 1) setState(() => _bedrooms--);
                  },
                ),
                Text('$_bedrooms টি', style: const TextStyle(fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => setState(() => _bedrooms++),
                ),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('বাথরুম:', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    if (_bathrooms > 1) setState(() => _bathrooms--);
                  },
                ),
                Text('$_bathrooms টি', style: const TextStyle(fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => setState(() => _bathrooms++),
                ),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('ফ্ল্যাটটি কোন তলায়:', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    if (_floorNumber > 1) setState(() => _floorNumber--);
                  },
                ),
                Text('$_floorNumber তলা', style: const TextStyle(fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => setState(() => _floorNumber++),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // STEP 4: Media
  Widget _step4Media() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ছবি ও ভিডিও যুক্ত করুন', style: AppTextStyles.headingMedium),
        const SizedBox(height: 8),
        Text('ফ্ল্যাটের আসল ছবি ও ১-২ মিনিটের ওয়াকথ্রু ভিডিও দিন।', style: AppTextStyles.bodyMedium),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ..._photoUrls.map((url) => Container(
                    width: 140,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
                    ),
                  )),
              InkWell(
                onTap: () {
                  setState(() {
                    _photoUrls.add('https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800');
                  });
                },
                child: Container(
                  width: 120,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add_a_photo_outlined, color: AppColors.primary),
                        SizedBox(height: 4),
                        Text('ছবি যোগ করুন', style: TextStyle(fontSize: 11)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: AppColors.border),
          ),
          leading: const Icon(Icons.videocam_outlined, color: AppColors.primary),
          title: Text(_videoUrl != null ? 'ভিডিও যুক্ত করা হয়েছে' : 'প্রপার্টি ভিডিও যুক্ত করুন (ঐচ্ছিক)'),
          subtitle: const Text('সর্বোচ্চ ২ মিনিট, MP4 বা MOV ফরম্যাট'),
          trailing: _videoUrl != null
              ? IconButton(
                  icon: const Icon(Icons.delete_outline, color: AppColors.error),
                  onPressed: () => setState(() => _videoUrl = null),
                )
              : OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _videoUrl = 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4';
                    });
                  },
                  child: const Text('ভিডিও দিন'),
                ),
        ),
      ],
    );
  }

  // STEP 5: Preview & Generated Ad
  Widget _step5Preview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('বিজ্ঞাপনের প্রিভিউ ও শিরোনাম', style: AppTextStyles.headingMedium),
        const SizedBox(height: 8),
        Text('প্রদত্ত তথ্যের ভিত্তিতে স্বয়ংক্রিয়ভাবে তৈরি হয়েছে:', style: AppTextStyles.bodyMedium),
        const SizedBox(height: 16),
        AppTextField(
          controller: _titleController,
          label: 'বিজ্ঞাপনের শিরোনাম (Title)',
          maxLines: 2,
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _descriptionController,
          label: 'বিস্তারিত বিবরণ (Description)',
          maxLines: 5,
          onVoicePressed: () {
            // Voice-to-Text assistance demonstration
            setState(() {
              _descriptionController.text += ' সার্বক্ষণিক পানির ব্যবস্থা এবং নিরাপত্তা প্রহরী রয়েছে।';
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('ভয়েস রেকর্ডার থেকে টেক্সট যুক্ত করা হয়েছে!')),
            );
          },
        ),
      ],
    );
  }
}
