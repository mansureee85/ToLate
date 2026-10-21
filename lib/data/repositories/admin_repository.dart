import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/property_enums.dart';
import '../../core/errors/app_error.dart';
import '../models/audit_log_model.dart';
import '../models/user_model.dart';
import 'property_repository.dart';

/// Repository for Admin Management, Moderation, and Security Audit Logs.
class AdminRepository extends ChangeNotifier {
  final PropertyRepository _propertyRepository;
  final List<AuditLogModel> _auditLogs = [];
  final List<UserModel> _managedUsers = [];

  AdminRepository(this._propertyRepository);

  List<AuditLogModel> get auditLogs => List.unmodifiable(_auditLogs);
  List<UserModel> get managedUsers => List.unmodifiable(_managedUsers);

  /// Ensure caller has appropriate administrative privileges.
  void _assertAdmin(UserModel? admin, {List<AdminRole>? allowedRoles}) {
    if (admin == null || admin.adminRole == null) {
      throw const PermissionDeniedError('এডমিন অধিকার ব্যতীত এই কাজ সম্পন্ন করা যাবে না।');
    }
    if (allowedRoles != null && !allowedRoles.contains(admin.adminRole)) {
      throw const PermissionDeniedError('আপনার ভূমিকার জন্য এই কাজের অনুমতি নেই।');
    }
  }

  /// Logs sensitive admin actions for auditability.
  Future<void> logAction({
    required UserModel admin,
    required String action,
    required String targetType,
    required String targetId,
    required String reason,
    Map<String, dynamic>? metadata,
  }) async {
    _assertAdmin(admin);

    final log = AuditLogModel(
      id: const Uuid().v4(),
      actorUserId: admin.id,
      actorRole: admin.adminRole!.name,
      action: action,
      targetType: targetType,
      targetId: targetId,
      reason: reason,
      metadata: metadata,
      timestamp: DateTime.now(),
    );

    _auditLogs.insert(0, log);
    notifyListeners();
  }

  /// Listing Moderation: Approve listing.
  Future<void> approveListing({
    required UserModel admin,
    required String listingId,
    required String reason,
  }) async {
    _assertAdmin(admin);
    await _propertyRepository.updateListingStatus(
      listingId: listingId,
      status: ListingStatus.published,
    );
    await logAction(
      admin: admin,
      action: 'APPROVE_LISTING',
      targetType: 'listing',
      targetId: listingId,
      reason: reason,
    );
  }

  /// Listing Moderation: Reject listing.
  Future<void> rejectListing({
    required UserModel admin,
    required String listingId,
    required String rejectionReason,
  }) async {
    _assertAdmin(admin);
    await _propertyRepository.updateListingStatus(
      listingId: listingId,
      status: ListingStatus.rejected,
      rejectionReason: rejectionReason,
    );
    await logAction(
      admin: admin,
      action: 'REJECT_LISTING',
      targetType: 'listing',
      targetId: listingId,
      reason: rejectionReason,
    );
  }

  /// Listing Moderation: Assign verification badge.
  Future<void> assignVerificationBadge({
    required UserModel admin,
    required String listingId,
    required VerificationBadgeType badge,
    required String evidenceNote,
  }) async {
    _assertAdmin(admin, allowedRoles: [
      AdminRole.superAdmin,
      AdminRole.verificationOfficer,
    ]);

    final listing = _propertyRepository.getListingById(listingId);
    if (listing != null) {
      final badges = List<VerificationBadgeType>.from(listing.verificationBadges);
      if (!badges.contains(badge)) {
        badges.add(badge);
        final updated = listing.copyWith(verificationBadges: badges);
        await _propertyRepository.createListing(updated);
      }
    }

    await logAction(
      admin: admin,
      action: 'ASSIGN_BADGE_${badge.name}',
      targetType: 'listing',
      targetId: listingId,
      reason: evidenceNote,
    );
  }
}

