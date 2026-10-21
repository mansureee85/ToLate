import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../../core/errors/app_error.dart';
import '../models/location_models.dart';

/// Bangladesh Administrative Location Hierarchy Repository.
class LocationRepository extends ChangeNotifier {
  // Authoritative Bangladesh Divisions
  final List<LocationDivision> _divisions = [
    const LocationDivision(id: 'div_dhaka', nameEn: 'Dhaka', nameBn: 'ঢাকা'),
    const LocationDivision(id: 'div_chattogram', nameEn: 'Chattogram', nameBn: 'চট্টগ্রাম'),
    const LocationDivision(id: 'div_rajshahi', nameEn: 'Rajshahi', nameBn: 'রাজশাহী'),
    const LocationDivision(id: 'div_khulna', nameEn: 'Khulna', nameBn: 'খুলনা'),
    const LocationDivision(id: 'div_barishal', nameEn: 'Barishal', nameBn: 'বরিশাল'),
    const LocationDivision(id: 'div_sylhet', nameEn: 'Sylhet', nameBn: 'সিলেট'),
    const LocationDivision(id: 'div_rangpur', nameEn: 'Rangpur', nameBn: 'রংপুর'),
    const LocationDivision(id: 'div_mymensingh', nameEn: 'Mymensingh', nameBn: 'ময়মনসিংহ'),
  ];

  // Authoritative Districts (Sample verified set)
  final List<LocationDistrict> _districts = [
    const LocationDistrict(id: 'dist_dhaka', divisionId: 'div_dhaka', nameEn: 'Dhaka', nameBn: 'ঢাকা'),
    const LocationDistrict(id: 'dist_gazipur', divisionId: 'div_dhaka', nameEn: 'Gazipur', nameBn: 'গাজীপুর'),
    const LocationDistrict(id: 'dist_narayanganj', divisionId: 'div_dhaka', nameEn: 'Narayanganj', nameBn: 'নারায়ণগঞ্জ'),
    const LocationDistrict(id: 'dist_chattogram', divisionId: 'div_chattogram', nameEn: 'Chattogram', nameBn: 'চট্টগ্রাম'),
    const LocationDistrict(id: 'dist_coxsbazar', divisionId: 'div_chattogram', nameEn: "Cox's Bazar", nameBn: 'কক্সবাজার'),
    const LocationDistrict(id: 'dist_sylhet', divisionId: 'div_sylhet', nameEn: 'Sylhet', nameBn: 'সিলেট'),
    const LocationDistrict(id: 'dist_rajshahi', divisionId: 'div_rajshahi', nameEn: 'Rajshahi', nameBn: 'রাজশাহী'),
    const LocationDistrict(id: 'dist_khulna', divisionId: 'div_khulna', nameEn: 'Khulna', nameBn: 'খুলনা'),
  ];

  // Authoritative Upazilas / Thanas
  final List<LocationUpazilaThana> _upazilas = [
    // Dhaka Metropolitan & District
    const LocationUpazilaThana(id: 'thana_dhanmondi', districtId: 'dist_dhaka', nameEn: 'Dhanmondi', nameBn: 'ধানমন্ডি'),
    const LocationUpazilaThana(id: 'thana_gulshan', districtId: 'dist_dhaka', nameEn: 'Gulshan', nameBn: 'গুলশান'),
    const LocationUpazilaThana(id: 'thana_banani', districtId: 'dist_dhaka', nameEn: 'Banani', nameBn: 'বনানী'),
    const LocationUpazilaThana(id: 'thana_mirpur', districtId: 'dist_dhaka', nameEn: 'Mirpur', nameBn: 'মিরপুর'),
    const LocationUpazilaThana(id: 'thana_uttara', districtId: 'dist_dhaka', nameEn: 'Uttara', nameBn: 'উত্তরা'),
    const LocationUpazilaThana(id: 'thana_mohammadpur', districtId: 'dist_dhaka', nameEn: 'Mohammadpur', nameBn: 'মোহাম্মদপুর'),
    const LocationUpazilaThana(id: 'thana_badda', districtId: 'dist_dhaka', nameEn: 'Badda', nameBn: 'বাড্ডা'),
    const LocationUpazilaThana(id: 'thana_khilgaon', districtId: 'dist_dhaka', nameEn: 'Khilgaon', nameBn: 'খিলগাঁও'),
    // Chattogram
    const LocationUpazilaThana(id: 'thana_panchlaish', districtId: 'dist_chattogram', nameEn: 'Panchlaish', nameBn: 'পাঁচলাইশ'),
    const LocationUpazilaThana(id: 'thana_kotwali_ctg', districtId: 'dist_chattogram', nameEn: 'Kotwali', nameBn: 'কোতোয়ালী'),
  ];

  // Canonical Localities / Areas
  final List<CanonicalArea> _canonicalAreas = [
    const CanonicalArea(id: 'area_dhanmondi_27', upazilaThanaId: 'thana_dhanmondi', nameEn: 'Road 27', nameBn: '২৭ নম্বর রোড'),
    const CanonicalArea(id: 'area_dhanmondi_32', upazilaThanaId: 'thana_dhanmondi', nameEn: 'Road 32', nameBn: '৩২ নম্বর রোড'),
    const CanonicalArea(id: 'area_mirpur_1', upazilaThanaId: 'thana_mirpur', nameEn: 'Mirpur 1', nameBn: 'মিরপুর ১'),
    const CanonicalArea(id: 'area_mirpur_2', upazilaThanaId: 'thana_mirpur', nameEn: 'Mirpur 2', nameBn: 'মিরপুর ২'),
    const CanonicalArea(id: 'area_mirpur_10', upazilaThanaId: 'thana_mirpur', nameEn: 'Mirpur 10', nameBn: 'মিরপুর ১০'),
    const CanonicalArea(id: 'area_mirpur_dohs', upazilaThanaId: 'thana_mirpur', nameEn: 'Mirpur DOHS', nameBn: 'মিরপুর ডিওএইচএস'),
    const CanonicalArea(id: 'area_uttara_sec_3', upazilaThanaId: 'thana_uttara', nameEn: 'Sector 3', nameBn: 'সেক্টর ৩'),
    const CanonicalArea(id: 'area_uttara_sec_7', upazilaThanaId: 'thana_uttara', nameEn: 'Sector 7', nameBn: 'সেক্টর ৭'),
  ];

  // User-submitted Proposed Areas awaiting Admin Review
  final List<ProposedArea> _proposedAreas = [];

  List<LocationDivision> get divisions => List.unmodifiable(_divisions);
  List<ProposedArea> get proposedAreas => List.unmodifiable(_proposedAreas);

  List<LocationDistrict> getDistrictsForDivision(String divisionId) {
    return _districts.where((d) => d.divisionId == divisionId).toList();
  }

  List<LocationUpazilaThana> getUpazilasForDistrict(String districtId) {
    return _upazilas.where((u) => u.districtId == districtId).toList();
  }

  List<CanonicalArea> getAreasForUpazila(String upazilaId) {
    return _canonicalAreas.where((a) => a.upazilaThanaId == upazilaId).toList();
  }

  /// Submit a proposed area if locality is not present in canonical dropdowns.
  Future<ProposedArea> proposeNewArea({
    required String typedAreaName,
    required String division,
    required String district,
    required String upazilaThana,
    required String submittedByUserId,
  }) async {
    final cleanName = typedAreaName.trim();
    if (cleanName.isEmpty) {
      throw const ValidationError('এরিয়ার নাম লিখুন।');
    }

    final normalized = cleanName.toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

    final proposal = ProposedArea(
      id: const Uuid().v4(),
      typedName: cleanName,
      normalizedName: normalized,
      division: division,
      district: district,
      upazilaThana: upazilaThana,
      submittedByUserId: submittedByUserId,
      status: ProposedAreaStatus.pending,
      createdAt: DateTime.now(),
    );

    _proposedAreas.add(proposal);
    notifyListeners();
    return proposal;
  }

  /// Admin workflow: Approve a proposed area and convert to canonical.
  Future<void> adminApproveProposedArea({
    required String proposalId,
    required String upazilaThanaId,
    required String approvedNameBn,
    required String approvedNameEn,
  }) async {
    final index = _proposedAreas.indexWhere((p) => p.id == proposalId);
    if (index != -1) {
      final updated = ProposedArea(
        id: _proposedAreas[index].id,
        typedName: _proposedAreas[index].typedName,
        normalizedName: _proposedAreas[index].normalizedName,
        division: _proposedAreas[index].division,
        district: _proposedAreas[index].district,
        upazilaThana: _proposedAreas[index].upazilaThana,
        submittedByUserId: _proposedAreas[index].submittedByUserId,
        status: ProposedAreaStatus.approved,
        createdAt: _proposedAreas[index].createdAt,
      );
      _proposedAreas[index] = updated;

      _canonicalAreas.add(CanonicalArea(
        id: const Uuid().v4(),
        upazilaThanaId: upazilaThanaId,
        nameEn: approvedNameEn,
        nameBn: approvedNameBn,
        aliases: [_proposedAreas[index].typedName],
      ));

      notifyListeners();
    }
  }
}

