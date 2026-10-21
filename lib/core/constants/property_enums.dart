/// Supported property transaction intents across Bangladesh.
enum PropertyIntent {
  houseRent,
  roomRent,
  sublet,
  flatRent,
  flatSale,
  houseSale,
  landSale,
  commercialLandSale,
  agriculturalLandSale,
  officeRent,
  officeSale,
  shopRent,
  shopSale,
  other;

  String get displayNameEn {
    switch (this) {
      case PropertyIntent.houseRent:
        return 'House Rent';
      case PropertyIntent.roomRent:
        return 'Room Rent';
      case PropertyIntent.sublet:
        return 'Sublet';
      case PropertyIntent.flatRent:
        return 'Flat Rent';
      case PropertyIntent.flatSale:
        return 'Flat Buy/Sell';
      case PropertyIntent.houseSale:
        return 'House Buy/Sell';
      case PropertyIntent.landSale:
        return 'Residential Land';
      case PropertyIntent.commercialLandSale:
        return 'Commercial Land';
      case PropertyIntent.agriculturalLandSale:
        return 'Agricultural Land';
      case PropertyIntent.officeRent:
        return 'Office Rent';
      case PropertyIntent.officeSale:
        return 'Office Buy/Sell';
      case PropertyIntent.shopRent:
        return 'Shop/Commercial Rent';
      case PropertyIntent.shopSale:
        return 'Shop/Commercial Sale';
      case PropertyIntent.other:
        return 'Other';
    }
  }

  String get displayNameBn {
    switch (this) {
      case PropertyIntent.houseRent:
        return 'বাসা ভাড়া';
      case PropertyIntent.roomRent:
        return 'রুম ভাড়া';
      case PropertyIntent.sublet:
        return 'সাবলেট';
      case PropertyIntent.flatRent:
        return 'ফ্ল্যাট ভাড়া';
      case PropertyIntent.flatSale:
        return 'ফ্ল্যাট কেনা/বেচা';
      case PropertyIntent.houseSale:
        return 'বাড়ি কেনা/বেচা';
      case PropertyIntent.landSale:
        return 'আবাসিক জমি';
      case PropertyIntent.commercialLandSale:
        return 'বাণিজ্যিক জমি';
      case PropertyIntent.agriculturalLandSale:
        return 'কৃষি জমি';
      case PropertyIntent.officeRent:
        return 'অফিস ভাড়া';
      case PropertyIntent.officeSale:
        return 'অফিস কেনা/বেচা';
      case PropertyIntent.shopRent:
        return 'দোকান ভাড়া';
      case PropertyIntent.shopSale:
        return 'দোকান কেনা/বেচা';
      case PropertyIntent.other:
        return 'অন্যান্য';
    }
  }

  bool get isRental {
    return this == PropertyIntent.houseRent ||
        this == PropertyIntent.roomRent ||
        this == PropertyIntent.sublet ||
        this == PropertyIntent.flatRent ||
        this == PropertyIntent.officeRent ||
        this == PropertyIntent.shopRent;
  }
}

/// User Roles in the marketplace.
enum UserRole {
  tenant,
  buyer,
  owner,
  landlord,
  seller,
  agent;

  String get labelEn {
    switch (this) {
      case UserRole.tenant:
        return 'Tenant / Renter';
      case UserRole.buyer:
        return 'Buyer';
      case UserRole.owner:
      case UserRole.landlord:
        return 'Landlord / Property Owner';
      case UserRole.seller:
        return 'Property Seller';
      case UserRole.agent:
        return 'Authorized Agent';
    }
  }

  String get labelBn {
    switch (this) {
      case UserRole.tenant:
        return 'ভাড়াটিয়া';
      case UserRole.buyer:
        return 'ক্রেতা';
      case UserRole.owner:
      case UserRole.landlord:
        return 'বাড়ির মালিক / ল্যান্ডলর্ড';
      case UserRole.seller:
        return 'বিক্রেতা';
      case UserRole.agent:
        return 'অনুমোদিত এজেন্ট';
    }
  }
}

/// Protected administrative roles.
enum AdminRole {
  superAdmin,
  listingModerator,
  verificationOfficer,
  contentModerator,
  customerSupport,
  financeAdmin,
  readOnlyAnalyst;

  String get title {
    switch (this) {
      case AdminRole.superAdmin:
        return 'Super Admin';
      case AdminRole.listingModerator:
        return 'Listing Moderator';
      case AdminRole.verificationOfficer:
        return 'Verification Officer';
      case AdminRole.contentModerator:
        return 'Content Moderator';
      case AdminRole.customerSupport:
        return 'Customer Support';
      case AdminRole.financeAdmin:
        return 'Finance Admin';
      case AdminRole.readOnlyAnalyst:
        return 'Read-only Analyst';
    }
  }
}

/// Scoped verification badge types.
enum VerificationBadgeType {
  phoneVerified,
  ownerIdentityChecked,
  agentAuthorizedChecked,
  photosChecked,
  videoChecked,
  locationChecked,
  propertyInspected,
  titleDocumentsReviewed;

  String get titleEn {
    switch (this) {
      case VerificationBadgeType.phoneVerified:
        return 'Phone Verified';
      case VerificationBadgeType.ownerIdentityChecked:
        return 'Owner ID Verified';
      case VerificationBadgeType.agentAuthorizedChecked:
        return 'Agent Authorized';
      case VerificationBadgeType.photosChecked:
        return 'Photos Checked';
      case VerificationBadgeType.videoChecked:
        return 'Video Checked';
      case VerificationBadgeType.locationChecked:
        return 'Location Verified';
      case VerificationBadgeType.propertyInspected:
        return 'In-Person Inspected';
      case VerificationBadgeType.titleDocumentsReviewed:
        return 'Title Docs Reviewed';
    }
  }

  String get titleBn {
    switch (this) {
      case VerificationBadgeType.phoneVerified:
        return 'ফোন নম্বর যাচাইকৃত';
      case VerificationBadgeType.ownerIdentityChecked:
        return 'মালিকের পরিচয় যাচাইকৃত';
      case VerificationBadgeType.agentAuthorizedChecked:
        return 'এজেন্ট অনুমোদন যাচাইকৃত';
      case VerificationBadgeType.photosChecked:
        return 'ছবি যাচাইকৃত';
      case VerificationBadgeType.videoChecked:
        return 'ভিডিও যাচাইকৃত';
      case VerificationBadgeType.locationChecked:
        return 'লোকেশন যাচাইকৃত';
      case VerificationBadgeType.propertyInspected:
        return 'সরাসরি পরিদর্শনকৃত';
      case VerificationBadgeType.titleDocumentsReviewed:
        return 'দলিলপত্র পর্যালোচিত';
    }
  }
}

/// Status of a property listing.
enum ListingStatus {
  draft,
  pendingReview,
  published,
  changesRequested,
  rejected,
  paused,
  expired,
  rented,
  sold;

  String get labelEn {
    switch (this) {
      case ListingStatus.draft:
        return 'Draft';
      case ListingStatus.pendingReview:
        return 'Pending Review';
      case ListingStatus.published:
        return 'Published';
      case ListingStatus.changesRequested:
        return 'Changes Requested';
      case ListingStatus.rejected:
        return 'Rejected';
      case ListingStatus.paused:
        return 'Paused';
      case ListingStatus.expired:
        return 'Expired';
      case ListingStatus.rented:
        return 'Rented Out';
      case ListingStatus.sold:
        return 'Sold';
    }
  }

  String get labelBn {
    switch (this) {
      case ListingStatus.draft:
        return 'খসড়া';
      case ListingStatus.pendingReview:
        return 'পর্যালোচনার অপেক্ষায়';
      case ListingStatus.published:
        return 'প্রকাশিত';
      case ListingStatus.changesRequested:
        return 'সংশোধন প্রয়োজন';
      case ListingStatus.rejected:
        return 'প্রত্যাখ্যাত';
      case ListingStatus.paused:
        return 'স্থগিত';
      case ListingStatus.expired:
        return 'মেয়াদোত্তীর্ণ';
      case ListingStatus.rented:
        return 'ভাড়া হয়ে গেছে';
      case ListingStatus.sold:
        return 'বিক্রি সম্পন্ন';
    }
  }
}

/// Unit availability status.
enum UnitAvailabilityStatus {
  available,
  booked,
  underRenovation,
  rented,
  sold;

  String get labelEn {
    switch (this) {
      case UnitAvailabilityStatus.available:
        return 'Available';
      case UnitAvailabilityStatus.booked:
        return 'Booked';
      case UnitAvailabilityStatus.underRenovation:
        return 'Under Renovation';
      case UnitAvailabilityStatus.rented:
        return 'Rented';
      case UnitAvailabilityStatus.sold:
        return 'Sold';
    }
  }

  String get labelBn {
    switch (this) {
      case UnitAvailabilityStatus.available:
        return 'খালি আছে';
      case UnitAvailabilityStatus.booked:
        return 'বুকড';
      case UnitAvailabilityStatus.underRenovation:
        return 'মেরামত চলছে';
      case UnitAvailabilityStatus.rented:
        return 'ভাড়া হয়ে গেছে';
      case UnitAvailabilityStatus.sold:
        return 'বিক্রি হয়েছে';
    }
  }
}

/// Land measurement units used across Bangladesh.
enum LandMeasurementUnit {
  shotok, // Decimal
  katha,
  bigha,
  acre,
  sqFt;

  String get labelEn {
    switch (this) {
      case LandMeasurementUnit.shotok:
        return 'Decimal (শতাংশ/শতক)';
      case LandMeasurementUnit.katha:
        return 'Katha (কাঠা)';
      case LandMeasurementUnit.bigha:
        return 'Bigha (বিঘা)';
      case LandMeasurementUnit.acre:
        return 'Acre (একর)';
      case LandMeasurementUnit.sqFt:
        return 'Square Feet (বর্গফুট)';
    }
  }

  String get labelBn {
    switch (this) {
      case LandMeasurementUnit.shotok:
        return 'শতক / শতাংশ';
      case LandMeasurementUnit.katha:
        return 'কাঠা';
      case LandMeasurementUnit.bigha:
        return 'বিঘা';
      case LandMeasurementUnit.acre:
        return 'একর';
      case LandMeasurementUnit.sqFt:
        return 'বর্গফুট';
    }
  }
}

