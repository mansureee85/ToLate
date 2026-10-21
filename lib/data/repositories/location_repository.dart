import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../../core/errors/app_error.dart';
import '../data_sources/bangladesh_locations_data.dart';
import '../models/location_models.dart';

/// Bangladesh Administrative Location Hierarchy Repository.
/// Supports 8 Divisions, 64 Districts, Thanas/Upazilas, and Unions/Wards.
class LocationRepository extends ChangeNotifier {
  // Authoritative Bangladesh Divisions (8 Divisions)
  final List<LocationDivision> _divisions = List.from(kBangladeshDivisions);

  // Authoritative Districts (All 64 Districts across Bangladesh)
  final List<LocationDistrict> _districts = List.from(kBangladeshDistricts);

  // Authoritative Upazilas / Thanas across all 64 Districts
  final List<LocationUpazilaThana> _upazilas = List.from(kBangladeshUpazilas);

  // Unions & Wards
  final List<LocationUnionWard> _unionWards = List.from(kBangladeshUnionWards);

  // Canonical Localities / Areas
  final List<CanonicalArea> _canonicalAreas = List.from(kBangladeshCanonicalAreas);

  // User-submitted Proposed Areas awaiting Admin Review
  final List<ProposedArea> _proposedAreas = [];

  List<LocationDivision> get divisions => List.unmodifiable(_divisions);
  List<LocationDistrict> get districts => List.unmodifiable(_districts);
  List<LocationUpazilaThana> get upazilas => List.unmodifiable(_upazilas);
  List<LocationUnionWard> get unionWards => List.unmodifiable(_unionWards);
  List<ProposedArea> get proposedAreas => List.unmodifiable(_proposedAreas);

  /// Districts filtered by division
  List<LocationDistrict> getDistrictsForDivision(String divisionId) {
    return _districts.where((d) => d.divisionId == divisionId).toList();
  }

  /// Upazilas / Thanas filtered by district
  List<LocationUpazilaThana> getUpazilasForDistrict(String districtId) {
    return _upazilas.where((u) => u.districtId == districtId).toList();
  }

  /// Unions and Wards for an Upazila / Thana.
  /// If specific ones are defined, returns them; otherwise provides standard wards & unions.
  List<LocationUnionWard> getUnionsAndWardsForUpazila(String upazilaId) {
    final existing = _unionWards.where((u) => u.upazilaThanaId == upazilaId).toList();
    if (existing.isNotEmpty) {
      return existing;
    }

    // Default wards / unions generated dynamically so every Upazila / Thana has choices
    return [
      LocationUnionWard(id: '${upazilaId}_w01', upazilaThanaId: upazilaId, nameEn: 'Ward No 01', nameBn: 'ওয়ার্ড নং ০১', type: LocalityType.ward),
      LocationUnionWard(id: '${upazilaId}_w02', upazilaThanaId: upazilaId, nameEn: 'Ward No 02', nameBn: 'ওয়ার্ড নং ০২', type: LocalityType.ward),
      LocationUnionWard(id: '${upazilaId}_w03', upazilaThanaId: upazilaId, nameEn: 'Ward No 03', nameBn: 'ওয়ার্ড নং ০৩', type: LocalityType.ward),
      LocationUnionWard(id: '${upazilaId}_w04', upazilaThanaId: upazilaId, nameEn: 'Ward No 04', nameBn: 'ওয়ার্ড নং ০৪', type: LocalityType.ward),
      LocationUnionWard(id: '${upazilaId}_w05', upazilaThanaId: upazilaId, nameEn: 'Ward No 05', nameBn: 'ওয়ার্ড নং ০৫', type: LocalityType.ward),
      LocationUnionWard(id: '${upazilaId}_w06', upazilaThanaId: upazilaId, nameEn: 'Ward No 06', nameBn: 'ওয়ার্ড নং ০৬', type: LocalityType.ward),
      LocationUnionWard(id: '${upazilaId}_w07', upazilaThanaId: upazilaId, nameEn: 'Ward No 07', nameBn: 'ওয়ার্ড নং ০৭', type: LocalityType.ward),
      LocationUnionWard(id: '${upazilaId}_w08', upazilaThanaId: upazilaId, nameEn: 'Ward No 08', nameBn: 'ওয়ার্ড নং ০৮', type: LocalityType.ward),
      LocationUnionWard(id: '${upazilaId}_w09', upazilaThanaId: upazilaId, nameEn: 'Ward No 09', nameBn: 'ওয়ার্ড নং ০৯', type: LocalityType.ward),
      LocationUnionWard(id: '${upazilaId}_w10', upazilaThanaId: upazilaId, nameEn: 'Ward No 10', nameBn: 'ওয়ার্ড নং ১০', type: LocalityType.ward),
      LocationUnionWard(id: '${upazilaId}_u01', upazilaThanaId: upazilaId, nameEn: 'Union Sadar', nameBn: 'সদর ইউনিয়ন', type: LocalityType.union),
    ];
  }

  /// Canonical areas / localities for an Upazila
  List<CanonicalArea> getAreasForUpazila(String upazilaId) {
    return _canonicalAreas.where((a) => a.upazilaThanaId == upazilaId).toList();
  }

  LocationDivision? getDivisionById(String id) {
    try {
      return _divisions.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }

  LocationDistrict? getDistrictById(String id) {
    try {
      return _districts.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }

  LocationUpazilaThana? getUpazilaById(String id) {
    try {
      return _upazilas.firstWhere((u) => u.id == id);
    } catch (_) {
      return null;
    }
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
