import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_text_styles.dart';
import '../../../app/route_names.dart';
import '../../../core/constants/property_enums.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../data/models/location_models.dart';
import '../../../data/repositories/location_repository.dart';
import '../../../data/repositories/property_repository.dart';

class SearchWizardScreen extends StatefulWidget {
  const SearchWizardScreen({super.key});

  @override
  State<SearchWizardScreen> createState() => _SearchWizardScreenState();
}

class _SearchWizardScreenState extends State<SearchWizardScreen> {
  int _currentStep = 0; // 0: Intent, 1: Location, 2: Budget, 3: Specs & Amenities

  // Step 1: Intent
  PropertyIntent? _selectedIntent = PropertyIntent.flatRent;

  // Step 2: Location
  LocationDivision? _selectedDivision;
  LocationDistrict? _selectedDistrict;
  LocationUpazilaThana? _selectedUpazila;
  String? _selectedAreaName;
  final TextEditingController _customAreaController = TextEditingController();

  // Step 3: Budget
  final TextEditingController _minBudgetController = TextEditingController();
  final TextEditingController _maxBudgetController = TextEditingController();

  // Step 4: Specs
  int? _selectedBedrooms;
  int? _selectedBathrooms;
  final Set<String> _selectedAmenities = {};

  final List<String> _amenities = [
    'লিফট (Lift)',
    'জেনারেটর (Generator)',
    'গ্যাস লাইন (Gas)',
    'গাড়ি পার্কিং (Car Parking)',
    'সিসিটিভি ও সিকিউরিটি',
    'বারান্দা (Balcony)',
  ];

  int _computeLiveMatches(PropertyRepository repo) {
    final filter = PropertySearchFilter(
      intent: _selectedIntent,
      division: _selectedDivision?.nameBn,
      district: _selectedDistrict?.nameBn,
      upazilaThana: _selectedUpazila?.nameBn,
      area: _selectedAreaName ??
          (_customAreaController.text.trim().isNotEmpty
              ? _customAreaController.text.trim()
              : null),
      minPrice: double.tryParse(_minBudgetController.text.trim()),
      maxPrice: double.tryParse(_maxBudgetController.text.trim()),
      minBedrooms: _selectedBedrooms,
      minBathrooms: _selectedBathrooms,
      requiredAmenities: _selectedAmenities.isNotEmpty ? _selectedAmenities.toList() : null,
    );
    return repo.searchListings(filter).length;
  }

  void _finishSearch() {
    final area = _selectedAreaName ??
        (_customAreaController.text.trim().isNotEmpty
            ? _customAreaController.text.trim()
            : null);

    // If custom area was entered, optionally propose it to location repo
    if (area != null && _selectedDivision != null && _selectedDistrict != null && _selectedUpazila != null) {
      context.read<LocationRepository>().proposeNewArea(
        typedAreaName: area,
        division: _selectedDivision!.nameBn,
        district: _selectedDistrict!.nameBn,
        upazilaThana: _selectedUpazila!.nameBn,
        submittedByUserId: 'anonymous_searcher',
      );
    }

    final queryParams = <String, String>{};
    if (_selectedIntent != null) queryParams['intent'] = _selectedIntent!.name;
    if (_selectedDivision != null) queryParams['division'] = _selectedDivision!.nameBn;
    if (_selectedDistrict != null) queryParams['district'] = _selectedDistrict!.nameBn;
    if (_selectedUpazila != null) queryParams['upazila'] = _selectedUpazila!.nameBn;
    if (area != null) queryParams['area'] = area;
    if (_minBudgetController.text.isNotEmpty) queryParams['minPrice'] = _minBudgetController.text;
    if (_maxBudgetController.text.isNotEmpty) queryParams['maxPrice'] = _maxBudgetController.text;
    if (_selectedBedrooms != null) queryParams['bedrooms'] = _selectedBedrooms.toString();

    final uri = Uri(path: RouteNames.searchResults, queryParameters: queryParams);
    context.push(uri.toString());
  }

  @override
  void dispose() {
    _customAreaController.dispose();
    _minBudgetController.dispose();
    _maxBudgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locationRepo = context.watch<LocationRepository>();
    final propertyRepo = context.watch<PropertyRepository>();
    final matchCount = _computeLiveMatches(propertyRepo);

    return Scaffold(
      appBar: AppBar(
        title: const Text('স্মার্ট সার্চ উইজার্ড (Search Wizard)'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Step Progress Indicator
            LinearProgressIndicator(
              value: (_currentStep + 1) / 4,
              backgroundColor: AppColors.border,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ধাপ ${_currentStep + 1} / ৪',
                    style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'বর্তমান মিল: $matchCount টি প্রপার্টি',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Step Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: _buildCurrentStepView(locationRepo),
              ),
            ),

            // Navigation Controls
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: [
                  if (_currentStep > 0) ...[
                    Expanded(
                      child: AppButton(
                        label: 'পূর্ববর্তী (Back)',
                        isOutlined: true,
                        onPressed: () => setState(() => _currentStep--),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    flex: 2,
                    child: AppButton(
                      label: _currentStep == 3 ? 'সার্চ ফলাফল দেখুন ($matchCount)' : 'পরবর্তী ধাপ (Next)',
                      onPressed: () {
                        if (_currentStep < 3) {
                          setState(() => _currentStep++);
                        } else {
                          _finishSearch();
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

  Widget _buildCurrentStepView(LocationRepository locRepo) {
    switch (_currentStep) {
      case 0:
        return _buildIntentStep();
      case 1:
        return _buildLocationStep(locRepo);
      case 2:
        return _buildBudgetStep();
      case 3:
        return _buildSpecsStep();
      default:
        return const SizedBox.shrink();
    }
  }

  // STEP 1: What are you looking for?
  Widget _buildIntentStep() {
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

    return ListView(
      children: [
        Text('আপনি কী খুঁজতে চাচ্ছেন?', style: AppTextStyles.headingMedium),
        const SizedBox(height: 8),
        Text('আপনার প্রয়োজনীয় প্রপার্টির ধরন নির্বাচন করুন:', style: AppTextStyles.bodyMedium),
        const SizedBox(height: 20),
        ...intents.map((intent) {
          final isSel = _selectedIntent == intent;
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isSel ? AppColors.primary : AppColors.border,
                  width: isSel ? 2 : 1,
                ),
              ),
              tileColor: isSel ? AppColors.primaryLight.withOpacity(0.3) : AppColors.surface,
              leading: Icon(
                intent.isRental ? Icons.key_rounded : Icons.real_estate_agent_rounded,
                color: isSel ? AppColors.primary : AppColors.textSecondary,
              ),
              title: Text(
                intent.displayNameBn,
                style: TextStyle(
                  fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                  color: isSel ? AppColors.primary : AppColors.textPrimary,
                ),
              ),
              subtitle: Text(intent.displayNameEn, style: AppTextStyles.bodySmall),
              trailing: isSel
                  ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
                  : null,
              onTap: () => setState(() => _selectedIntent = intent),
            ),
          );
        }),
      ],
    );
  }

  // STEP 2: Administrative Location Hierarchy
  Widget _buildLocationStep(LocationRepository locRepo) {
    final districts = _selectedDivision != null
        ? locRepo.getDistrictsForDivision(_selectedDivision!.id)
        : <LocationDistrict>[];

    final upazilas = _selectedDistrict != null
        ? locRepo.getUpazilasForDistrict(_selectedDistrict!.id)
        : <LocationUpazilaThana>[];

    final areas = _selectedUpazila != null
        ? locRepo.getAreasForUpazila(_selectedUpazila!.id)
        : <CanonicalArea>[];

    return ListView(
      children: [
        Text('কোথায় বাসা বা প্রপার্টি খুঁজছেন?', style: AppTextStyles.headingMedium),
        const SizedBox(height: 8),
        Text(
          'বাংলাদেশ প্রশাসনিক তথ্য অনুযায়ী বিভাগ, জেলা এবং থানা সিলেক্ট করুন:',
          style: AppTextStyles.bodyMedium,
        ),
        const SizedBox(height: 20),

        // 1. Division
        DropdownButtonFormField<LocationDivision>(
          value: _selectedDivision,
          decoration: const InputDecoration(labelText: 'বিভাগ (Division)'),
          items: locRepo.divisions.map((div) {
            return DropdownMenuItem(
              value: div,
              child: Text('${div.nameBn} (${div.nameEn})'),
            );
          }).toList(),
          onChanged: (div) {
            setState(() {
              _selectedDivision = div;
              _selectedDistrict = null;
              _selectedUpazila = null;
              _selectedAreaName = null;
            });
          },
        ),
        const SizedBox(height: 16),

        // 2. District
        if (_selectedDivision != null) ...[
          DropdownButtonFormField<LocationDistrict>(
            value: _selectedDistrict,
            decoration: const InputDecoration(labelText: 'জেলা (District)'),
            items: districts.map((dist) {
              return DropdownMenuItem(
                value: dist,
                child: Text('${dist.nameBn} (${dist.nameEn})'),
              );
            }).toList(),
            onChanged: (dist) {
              setState(() {
                _selectedDistrict = dist;
                _selectedUpazila = null;
                _selectedAreaName = null;
              });
            },
          ),
          const SizedBox(height: 16),
        ],

        // 3. Upazila / Thana
        if (_selectedDistrict != null) ...[
          DropdownButtonFormField<LocationUpazilaThana>(
            value: _selectedUpazila,
            decoration: const InputDecoration(labelText: 'উপজেলা / থানা (Upazila / Thana)'),
            items: upazilas.map((u) {
              return DropdownMenuItem(
                value: u,
                child: Text('${u.nameBn} (${u.nameEn})'),
              );
            }).toList(),
            onChanged: (u) {
              setState(() {
                _selectedUpazila = u;
                _selectedAreaName = null;
              });
            },
          ),
          const SizedBox(height: 16),
        ],

        // 4. Area / Locality or User Custom Input
        if (_selectedUpazila != null) ...[
          if (areas.isNotEmpty) ...[
            DropdownButtonFormField<String>(
              value: _selectedAreaName,
              decoration: const InputDecoration(labelText: 'এলাকা / লোকালিটি (Area)'),
              items: areas.map((a) {
                return DropdownMenuItem(
                  value: a.nameBn,
                  child: Text('${a.nameBn} (${a.nameEn})'),
                );
              }).toList(),
              onChanged: (a) => setState(() => _selectedAreaName = a),
            ),
            const SizedBox(height: 12),
            const Center(
              child: Text('অথবা', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
            ),
            const SizedBox(height: 8),
          ],
          AppTextField(
            controller: _customAreaController,
            label: 'নির্দিষ্ট রাস্তা, সেক্টর বা এলাকার নাম লিখুন',
            hint: 'যেমন: রোড ১২, সেক্টর ৩, ব্লক ডি',
            helperText: 'তালিকায় না থাকলে এখানে লিখে সার্চ করুন।',
          ),
        ],
      ],
    );
  }

  // STEP 3: Budget
  Widget _buildBudgetStep() {
    return ListView(
      children: [
        Text('আপনার বাজেট কত?', style: AppTextStyles.headingMedium),
        const SizedBox(height: 8),
        Text(
          _selectedIntent?.isRental == true
              ? 'প্রতি মাসের নূন্যতম ও সর্বোচ্চ ভাড়ার পরিমাণ (টাকায়):'
              : 'নূন্যতম ও সর্বোচ্চ মোট ক্রয় মূল্য (টাকায়):',
          style: AppTextStyles.bodyMedium,
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: AppTextField(
                controller: _minBudgetController,
                label: 'নূন্যতম বাজেট (৳)',
                hint: 'যেমন: ৮০০০',
                keyboardType: TextInputType.number,
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: AppTextField(
                controller: _maxBudgetController,
                label: 'সর্বোচ্চ বাজেট (৳)',
                hint: 'যেমন: ২৫০০০',
                keyboardType: TextInputType.number,
                onChanged: (_) => setState(() {}),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text('জনপ্রিয় রেঞ্জ:', style: AppTextStyles.headingSmall),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _budgetPresetChip('৳ ৫,০০০ - ৳ ১০,০০০', 5000, 10000),
            _budgetPresetChip('৳ ১০,০০০ - ৳ ২০,০০০', 10000, 20000),
            _budgetPresetChip('৳ ২০,০০০ - ৳ ৩৫,০০০', 20000, 35000),
            _budgetPresetChip('৳ ৩৫,০০০ - ৳ ৬০,০০০', 35000, 60000),
          ],
        ),
      ],
    );
  }

  Widget _budgetPresetChip(String label, int min, int max) {
    return ActionChip(
      label: Text(label),
      onPressed: () {
        setState(() {
          _minBudgetController.text = min.toString();
          _maxBudgetController.text = max.toString();
        });
      },
    );
  }

  // STEP 4: Dynamic Specs (Bedrooms, Bathrooms, Amenities)
  Widget _buildSpecsStep() {
    return ListView(
      children: [
        Text('প্রপার্টির বিবরণ ও সুযোগ-সুবিধা', style: AppTextStyles.headingMedium),
        const SizedBox(height: 8),
        Text('আপনার প্রয়োজনীয় বেডরুম ও সুবিধা সিলেক্ট করুন:', style: AppTextStyles.bodyMedium),
        const SizedBox(height: 20),

        // Bedrooms
        Text('বেডরুমের সংখ্যা:', style: AppTextStyles.headingSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [1, 2, 3, 4, 5].map((b) {
            final isSel = _selectedBedrooms == b;
            return ChoiceChip(
              label: Text('$b বেড'),
              selected: isSel,
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSel ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
              onSelected: (sel) {
                setState(() => _selectedBedrooms = sel ? b : null);
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 20),

        // Bathrooms
        Text('বাথরুমের সংখ্যা:', style: AppTextStyles.headingSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [1, 2, 3, 4].map((b) {
            final isSel = _selectedBathrooms == b;
            return ChoiceChip(
              label: Text('$b বাথ'),
              selected: isSel,
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSel ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
              onSelected: (sel) {
                setState(() => _selectedBathrooms = sel ? b : null);
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 24),

        // Amenities
        Text('প্রয়োজনীয় সুবিধাসমূহ:', style: AppTextStyles.headingSmall),
        const SizedBox(height: 8),
        ..._amenities.map((amenity) {
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
    );
  }
}

