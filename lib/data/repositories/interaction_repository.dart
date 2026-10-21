import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../../core/errors/app_error.dart';
import '../models/interaction_models.dart';
import '../models/report_model.dart';

/// Repository for Inquiries, Viewing Requests, Chat Messages, and Abuse Reports.
class InteractionRepository extends ChangeNotifier {
  final List<InquiryModel> _inquiries = [];
  final List<ViewingRequestModel> _viewingRequests = [];
  final List<ConversationModel> _conversations = [];
  final List<MessageModel> _messages = [];
  final List<ReportModel> _reports = [];

  List<InquiryModel> get inquiries => List.unmodifiable(_inquiries);
  List<ViewingRequestModel> get viewingRequests => List.unmodifiable(_viewingRequests);
  List<ConversationModel> get conversations => List.unmodifiable(_conversations);
  List<ReportModel> get reports => List.unmodifiable(_reports);

  // ---------------------------------------------------------------------------
  // INQUIRIES
  // ---------------------------------------------------------------------------

  Future<InquiryModel> sendInquiry({
    required String listingId,
    required String listingTitle,
    required String senderUserId,
    required String senderName,
    required String recipientOwnerUserId,
    required String messageText,
    String preferredContactMethod = 'inApp',
  }) async {
    if (messageText.trim().isEmpty) {
      throw const ValidationError('অনুসন্ধান বার্তা লিখুন।');
    }

    final inquiry = InquiryModel(
      id: const Uuid().v4(),
      listingId: listingId,
      listingTitle: listingTitle,
      senderUserId: senderUserId,
      senderName: senderName,
      recipientOwnerUserId: recipientOwnerUserId,
      messageText: messageText.trim(),
      preferredContactMethod: preferredContactMethod,
      createdAt: DateTime.now(),
    );

    _inquiries.add(inquiry);
    notifyListeners();
    return inquiry;
  }

  List<InquiryModel> getInquiriesForUser(String userId) {
    return _inquiries
        .where((i) => i.senderUserId == userId || i.recipientOwnerUserId == userId)
        .toList();
  }

  // ---------------------------------------------------------------------------
  // VIEWING REQUESTS
  // ---------------------------------------------------------------------------

  Future<ViewingRequestModel> requestViewing({
    required String listingId,
    required String listingTitle,
    required String tenantUserId,
    required String tenantName,
    required String ownerUserId,
    required DateTime proposedDateTime,
    String? tenantNote,
  }) async {
    final request = ViewingRequestModel(
      id: const Uuid().v4(),
      listingId: listingId,
      listingTitle: listingTitle,
      tenantUserId: tenantUserId,
      tenantName: tenantName,
      ownerUserId: ownerUserId,
      proposedDateTime: proposedDateTime,
      status: ViewingRequestStatus.requested,
      tenantNote: tenantNote,
      createdAt: DateTime.now(),
    );

    _viewingRequests.add(request);
    notifyListeners();
    return request;
  }

  Future<void> updateViewingStatus({
    required String requestId,
    required ViewingRequestStatus newStatus,
    String? responseNote,
  }) async {
    final index = _viewingRequests.indexWhere((r) => r.id == requestId);
    if (index != -1) {
      final old = _viewingRequests[index];
      _viewingRequests[index] = ViewingRequestModel(
        id: old.id,
        listingId: old.listingId,
        listingTitle: old.listingTitle,
        tenantUserId: old.tenantUserId,
        tenantName: old.tenantName,
        ownerUserId: old.ownerUserId,
        proposedDateTime: old.proposedDateTime,
        alternativeDateTime: old.alternativeDateTime,
        status: newStatus,
        tenantNote: old.tenantNote,
        ownerResponseNote: responseNote ?? old.ownerResponseNote,
        createdAt: old.createdAt,
      );
      notifyListeners();
    }
  }

  List<ViewingRequestModel> getViewingRequestsForUser(String userId) {
    return _viewingRequests
        .where((v) => v.tenantUserId == userId || v.ownerUserId == userId)
        .toList();
  }

  // ---------------------------------------------------------------------------
  // CHAT MESSAGES
  // ---------------------------------------------------------------------------

  List<MessageModel> getMessagesForConversation(String conversationId) {
    return _messages.where((m) => m.conversationId == conversationId).toList();
  }

  Future<MessageModel> sendMessage({
    required String conversationId,
    required String senderUserId,
    required String senderName,
    required String content,
  }) async {
    final msg = MessageModel(
      id: const Uuid().v4(),
      conversationId: conversationId,
      senderUserId: senderUserId,
      senderName: senderName,
      content: content.trim(),
      sentAt: DateTime.now(),
    );

    _messages.add(msg);

    final convIndex = _conversations.indexWhere((c) => c.id == conversationId);
    if (convIndex != -1) {
      final c = _conversations[convIndex];
      _conversations[convIndex] = ConversationModel(
        id: c.id,
        listingId: c.listingId,
        listingTitle: c.listingTitle,
        participantUserIds: c.participantUserIds,
        lastMessageText: content.trim(),
        lastMessageTime: DateTime.now(),
      );
    }

    notifyListeners();
    return msg;
  }

  // ---------------------------------------------------------------------------
  // ABUSE & FRAUD REPORTS
  // ---------------------------------------------------------------------------

  Future<ReportModel> submitReport({
    required String reporterUserId,
    required String targetType,
    required String targetId,
    required ReportCategory category,
    required String description,
  }) async {
    if (description.trim().isEmpty) {
      throw const ValidationError('অভিযোগের বিবরণ দিন।');
    }

    final report = ReportModel(
      id: const Uuid().v4(),
      reporterUserId: reporterUserId,
      targetType: targetType,
      targetId: targetId,
      category: category,
      description: description.trim(),
      status: ReportStatus.pending,
      createdAt: DateTime.now(),
    );

    _reports.add(report);
    notifyListeners();
    return report;
  }
}

