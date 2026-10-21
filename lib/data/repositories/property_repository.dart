import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/property_enums.dart';
import '../models/building_model.dart';
import '../models/property_listing_model.dart';
import '../models/property_unit_model.dart';

/// Filter criteria for querying property listings.
class PropertySearchFilter {
  final PropertyIntent? intent;
  final String? division;
  final String? district;
  final String? upazilaThana;
  final String? area;
  final double? minPrice;
  final double? maxPrice;
  final int? minBedrooms;
  final int? minBathrooms;
  final double? minAreaSqFt;
  final double? maxAreaSqFt;
  final List<String>? requiredAmenities;

  const PropertySearchFilter({
    this.intent,
    this.division,
    this.district,
    this.upazilaThana,
    this.area,
    this.minPrice,
    this.maxPrice,
    this.minBedrooms,
    this.minBathrooms,
    this.minAreaSqFt,
    this.maxAreaSqFt,
    this.requiredAmenities,
  });
}

/// Property, Building, and Unit Repository.
class PropertyRepository extends ChangeNotifier {
  // Pure database collections (Zero dummy data seeded in production!)
  final List<BuildingModel> _buildings = [];
  final List<PropertyUnitModel> _units = [];
  final List<PropertyListingModel> _listings = [];
  final Set<String> _favoriteListingIds = {};

  final bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<PropertyListingModel> get publishedListings => _listings
      .where((item) => item.status == ListingStatus.published)
      .toList();

  List<BuildingModel> get buildings => List.unmodifiable(_buildings);
  List<PropertyUnitModel> get units => List.unmodifiable(_units);
  Set<String> get favoriteListingIds => Set.unmodifiable(_favoriteListingIds);

  // ---------------------------------------------------------------------------
  // BUILDING MANAGEMENT
  // ---------------------------------------------------------------------------

  Future<BuildingModel> createBuilding({
    required String ownerUserId,
    String? buildingName,
    required String division,
    required String district,
    required String upazilaThana,
    required String area,
    required String addressText,
    double? latitude,
    double? longitude,
    required int totalFloors,
    String buildingType = 'Residential',
    List<String> commonAmenities = const [],
    List<String> photoUrls = const [],
    String? videoUrl,
  }) async {
    final building = BuildingModel(
      id: const Uuid().v4(),
      ownerUserId: ownerUserId,
      buildingName: buildingName,
      division: division,
      district: district,
      upazilaThana: upazilaThana,
      area: area,
      addressText: addressText,
      latitude: latitude,
      longitude: longitude,
      totalFloors: totalFloors,
      buildingType: buildingType,
      commonAmenities: commonAmenities,
      photoUrls: photoUrls,
      videoUrl: videoUrl,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _buildings.add(building);
    notifyListeners();
    return building;
  }

  BuildingModel? getBuildingById(String id) {
    try {
      return _buildings.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }

  List<BuildingModel> getBuildingsForOwner(String ownerUserId) {
    return _buildings.where((b) => b.ownerUserId == ownerUserId).toList();
  }

  // ---------------------------------------------------------------------------
  // UNIT MANAGEMENT (Independent multi-unit model)
  // ---------------------------------------------------------------------------

  Future<PropertyUnitModel> createUnit({
    String? buildingId,
    String? unitNumber,
    int? floorNumber,
    required PropertyIntent propertyIntent,
    int bedrooms = 1,
    int bathrooms = 1,
    int balconies = 0,
    required double areaSqFt,
    required double rentOrSalePrice,
    double? advanceDepositAmount,
    double? serviceCharge,
    List<String> unitAmenities = const [],
    List<String> photoUrls = const [],
    String? videoUrl,
    required DateTime availableFromDate,
    required String createdByUserId,
  }) async {
    final unit = PropertyUnitModel(
      id: const Uuid().v4(),
      buildingId: buildingId,
      unitNumber: unitNumber,
      floorNumber: floorNumber,
      propertyIntent: propertyIntent,
      bedrooms: bedrooms,
      bathrooms: bathrooms,
      balconies: balconies,
      areaSqFt: areaSqFt,
      rentOrSalePrice: rentOrSalePrice,
      advanceDepositAmount: advanceDepositAmount,
      serviceCharge: serviceCharge,
      unitAmenities: unitAmenities,
      photoUrls: photoUrls,
      videoUrl: videoUrl,
      availableFromDate: availableFromDate,
      createdByUserId: createdByUserId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _units.add(unit);
    notifyListeners();
    return unit;
  }

  List<PropertyUnitModel> getUnitsForBuilding(String buildingId) {
    return _units.where((u) => u.buildingId == buildingId).toList();
  }

  Future<void> updateUnitStatus({
    required String unitId,
    required UnitAvailabilityStatus newStatus,
  }) async {
    final index = _units.indexWhere((u) => u.id == unitId);
    if (index != -1) {
      _units[index] = _units[index].copyWith(
        availabilityStatus: newStatus,
        updatedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  // ---------------------------------------------------------------------------
  // LISTING MANAGEMENT
  // ---------------------------------------------------------------------------

  Future<PropertyListingModel> createListing(PropertyListingModel listing) async {
    _listings.add(listing);
    notifyListeners();
    return listing;
  }

  Future<void> updateListingStatus({
    required String listingId,
    required ListingStatus status,
    String? rejectionReason,
  }) async {
    final index = _listings.indexWhere((l) => l.id == listingId);
    if (index != -1) {
      _listings[index] = _listings[index].copyWith(
        status: status,
        rejectionReason: rejectionReason,
        publishedAt: status == ListingStatus.published ? DateTime.now() : _listings[index].publishedAt,
        updatedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  List<PropertyListingModel> getListingsForOwner(String ownerUserId) {
    return _listings.where((l) => l.ownerUserId == ownerUserId).toList();
  }

  PropertyListingModel? getListingById(String id) {
    try {
      return _listings.firstWhere((l) => l.id == id);
    } catch (_) {
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // SEARCH & FILTERING (Real-time Backend Matching)
  // ---------------------------------------------------------------------------

  List<PropertyListingModel> searchListings(PropertySearchFilter filter) {
    return publishedListings.where((listing) {
      if (filter.intent != null && listing.propertyIntent != filter.intent) {
        return false;
      }
      if (filter.division != null &&
          filter.division!.isNotEmpty &&
          listing.division != filter.division) {
        return false;
      }
      if (filter.district != null &&
          filter.district!.isNotEmpty &&
          listing.district != filter.district) {
        return false;
      }
      if (filter.upazilaThana != null &&
          filter.upazilaThana!.isNotEmpty &&
          listing.upazilaThana != filter.upazilaThana) {
        return false;
      }
      if (filter.area != null &&
          filter.area!.isNotEmpty &&
          !listing.area.toLowerCase().contains(filter.area!.toLowerCase())) {
        return false;
      }
      if (filter.minPrice != null && listing.price < filter.minPrice!) {
        return false;
      }
      if (filter.maxPrice != null && listing.price > filter.maxPrice!) {
        return false;
      }
      if (filter.minBedrooms != null && listing.bedrooms < filter.minBedrooms!) {
        return false;
      }
      if (filter.minBathrooms != null && listing.bathrooms < filter.minBathrooms!) {
        return false;
      }
      if (filter.minAreaSqFt != null && listing.areaSqFt < filter.minAreaSqFt!) {
        return false;
      }
      if (filter.maxAreaSqFt != null && listing.areaSqFt > filter.maxAreaSqFt!) {
        return false;
      }
      if (filter.requiredAmenities != null && filter.requiredAmenities!.isNotEmpty) {
        for (final amenity in filter.requiredAmenities!) {
          if (!listing.amenities.contains(amenity)) {
            return false;
          }
        }
      }
      return true;
    }).toList();
  }

  // ---------------------------------------------------------------------------
  // FAVORITES
  // ---------------------------------------------------------------------------

  void toggleFavorite(String listingId) {
    if (_favoriteListingIds.contains(listingId)) {
      _favoriteListingIds.remove(listingId);
    } else {
      _favoriteListingIds.add(listingId);
    }
    notifyListeners();
  }

  bool isFavorite(String listingId) => _favoriteListingIds.contains(listingId);

  List<PropertyListingModel> get favoriteListings {
    return publishedListings
        .where((l) => _favoriteListingIds.contains(l.id))
        .toList();
  }
}

