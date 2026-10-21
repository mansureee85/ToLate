import 'package:flutter_test/flutter_test.dart';
import 'package:tolate/core/constants/property_enums.dart';
import 'package:tolate/core/errors/app_error.dart';
import 'package:tolate/core/media/media_asset.dart';
import 'package:tolate/core/media/media_validation.dart';
import 'package:tolate/core/validation/money_validator.dart';
import 'package:tolate/core/validation/phone_validator.dart';
import 'package:tolate/data/models/user_model.dart';
import 'package:tolate/data/repositories/admin_repository.dart';
import 'package:tolate/data/repositories/property_repository.dart';

void main() {
  group('Bangladesh Phone Validation & Normalization', () {
    test('Validates authentic Bangladesh phone numbers correctly', () {
      expect(PhoneValidator.isValidBdPhone('01712345678'), isTrue);
      expect(PhoneValidator.isValidBdPhone('+8801812345678'), isTrue);
      expect(PhoneValidator.isValidBdPhone('8801912345678'), isTrue);
      expect(PhoneValidator.isValidBdPhone('1312345678'), isTrue);
    });

    test('Rejects invalid phone numbers', () {
      expect(PhoneValidator.isValidBdPhone('01212345678'), isFalse); // invalid operator 012
      expect(PhoneValidator.isValidBdPhone('12345'), isFalse);
      expect(PhoneValidator.isValidBdPhone('abcdefghijk'), isFalse);
      expect(PhoneValidator.isValidBdPhone(''), isFalse);
    });

    test('Normalizes numbers to E.164 +880 format', () {
      expect(PhoneValidator.normalizeBdPhone('01712345678'), '+8801712345678');
      expect(PhoneValidator.normalizeBdPhone('01812-345678'), '+8801812345678');
    });
  });

  group('BDT Currency & Money Formatter', () {
    test('Formats BDT currency with correct South Asian grouping', () {
      expect(MoneyValidator.formatBdt(25000), '৳ 25,000');
      expect(MoneyValidator.formatBdt(150000), '৳ 1,50,000');
      expect(MoneyValidator.formatBdt(15000000), '৳ 1,50,00,000');
    });

    test('Converts English numerals to Bangla numerals', () {
      expect(MoneyValidator.toBanglaDigits('25000'), '২৫০০০');
      expect(MoneyValidator.toBanglaDigits('01712'), '০১৭১২');
    });
  });

  group('Media Upload Rules & Review Video Rejection Policy', () {
    test('Property listings allow photos and video within limits', () {
      expect(
        () => MediaValidation.validatePropertyMedia(
          type: MediaType.image,
          fileName: 'flat_living_room.jpg',
          fileSizeBytes: 1024 * 1024 * 2, // 2MB
        ),
        returnsNormally,
      );

      expect(
        () => MediaValidation.validatePropertyMedia(
          type: MediaType.video,
          fileName: 'walkthrough.mp4',
          fileSizeBytes: 1024 * 1024 * 20, // 20MB
          durationSeconds: 60,
        ),
        returnsNormally,
      );
    });

    test('Tenant Reviews STRICTLY reject video uploads', () {
      expect(
        () => MediaValidation.validateReviewMedia(
          type: MediaType.video,
          fileName: 'review_video.mp4',
          fileSizeBytes: 1024 * 1024,
        ),
        throwsA(isA<MediaUploadError>()),
      );

      // Photos in review are permitted
      expect(
        () => MediaValidation.validateReviewMedia(
          type: MediaType.image,
          fileName: 'room_condition.jpg',
          fileSizeBytes: 1024 * 500,
        ),
        returnsNormally,
      );
    });
  });

  group('Building & Property Unit Independence', () {
    test('Modifying status of one unit does not affect sibling units in same building', () async {
      final repo = PropertyRepository();

      final building = await repo.createBuilding(
        ownerUserId: 'owner_1',
        buildingName: 'Rose Valley Complex',
        division: 'ঢাকা',
        district: 'ঢাকা',
        upazilaThana: 'মিরপুর',
        area: 'মিরপুর ২',
        addressText: 'রোড ৪, বাড়ি ১২',
        totalFloors: 6,
      );

      // Unit 1: Flat 2A
      final unit1 = await repo.createUnit(
        buildingId: building.id,
        unitNumber: '2A',
        floorNumber: 2,
        propertyIntent: PropertyIntent.flatRent,
        areaSqFt: 1200,
        rentOrSalePrice: 22000,
        availableFromDate: DateTime.now(),
        createdByUserId: 'owner_1',
      );

      // Unit 2: Flat 3B
      final unit2 = await repo.createUnit(
        buildingId: building.id,
        unitNumber: '3B',
        floorNumber: 3,
        propertyIntent: PropertyIntent.flatRent,
        areaSqFt: 1400,
        rentOrSalePrice: 26000,
        availableFromDate: DateTime.now(),
        createdByUserId: 'owner_1',
      );

      // Initially both are available
      expect(unit1.availabilityStatus, UnitAvailabilityStatus.available);
      expect(unit2.availabilityStatus, UnitAvailabilityStatus.available);

      // Rent out Unit 1
      await repo.updateUnitStatus(
        unitId: unit1.id,
        newStatus: UnitAvailabilityStatus.rented,
      );

      // Verify Unit 1 is rented, but Unit 2 remains available
      final units = repo.getUnitsForBuilding(building.id);
      final updatedUnit1 = units.firstWhere((u) => u.id == unit1.id);
      final updatedUnit2 = units.firstWhere((u) => u.id == unit2.id);

      expect(updatedUnit1.availabilityStatus, UnitAvailabilityStatus.rented);
      expect(updatedUnit2.availabilityStatus, UnitAvailabilityStatus.available);
    });
  });

  group('Security & Zero Dummy Data Policy', () {
    test('Published listings collection is empty on clean start (no mock data seeded)', () {
      final repo = PropertyRepository();
      expect(repo.publishedListings, isEmpty);
    });

    test('Non-admin users cannot perform administrative actions', () async {
      final propertyRepo = PropertyRepository();
      final adminRepo = AdminRepository(propertyRepo);

      final normalUser = UserModel(
        id: 'user_regular_1',
        displayName: 'কামাল হোসেন',
        phoneNumber: '+8801712345678',
        isPhoneVerified: true,
        roles: const [UserRole.tenant],
        adminRole: null, // Not admin
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(
        () => adminRepo.approveListing(
          admin: normalUser,
          listingId: 'listing_1',
          reason: 'Test approve',
        ),
        throwsA(isA<PermissionDeniedError>()),
      );
    });
  });
}
