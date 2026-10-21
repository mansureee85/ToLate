/// Status of an in-app property viewing appointment.
enum ViewingRequestStatus {
  requested,
  accepted,
  alternativeProposed,
  declined,
  cancelled,
  completed,
  noShow;

  String get labelBn {
    switch (this) {
      case ViewingRequestStatus.requested:
        return 'অনুরোধ পাঠানো হয়েছে';
      case ViewingRequestStatus.accepted:
        return 'মালিক সম্মতি দিয়েছেন';
      case ViewingRequestStatus.alternativeProposed:
        return 'বিকল্প সময় প্রস্তাবিত';
      case ViewingRequestStatus.declined:
        return 'প্রত্যাখ্যাত';
      case ViewingRequestStatus.cancelled:
        return 'বাতিলকৃত';
      case ViewingRequestStatus.completed:
        return 'পরিদর্শন সম্পন্ন';
      case ViewingRequestStatus.noShow:
        return 'উপস্থিত হননি';
    }
  }
}

/// Viewing request booking between tenant and owner.
class ViewingRequestModel {
  final String id;
  final String listingId;
  final String listingTitle;
  final String tenantUserId;
  final String tenantName;
  final String ownerUserId;
  final DateTime proposedDateTime;
  final DateTime? alternativeDateTime;
  final ViewingRequestStatus status;
  final String? tenantNote;
  final String? ownerResponseNote;
  final DateTime createdAt;

  const ViewingRequestModel({
    required this.id,
    required this.listingId,
    required this.listingTitle,
    required this.tenantUserId,
    required this.tenantName,
    required this.ownerUserId,
    required this.proposedDateTime,
    this.alternativeDateTime,
    this.status = ViewingRequestStatus.requested,
    this.tenantNote,
    this.ownerResponseNote,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'listingId': listingId,
        'listingTitle': listingTitle,
        'tenantUserId': tenantUserId,
        'tenantName': tenantName,
        'ownerUserId': ownerUserId,
        'proposedDateTime': proposedDateTime.toIso8601String(),
        'alternativeDateTime': alternativeDateTime?.toIso8601String(),
        'status': status.name,
        'tenantNote': tenantNote,
        'ownerResponseNote': ownerResponseNote,
        'createdAt': createdAt.toIso8601String(),
      };

  factory ViewingRequestModel.fromJson(Map<String, dynamic> json) =>
      ViewingRequestModel(
        id: json['id'] as String,
        listingId: json['listingId'] as String,
        listingTitle: json['listingTitle'] as String,
        tenantUserId: json['tenantUserId'] as String,
        tenantName: json['tenantName'] as String,
        ownerUserId: json['ownerUserId'] as String,
        proposedDateTime: DateTime.parse(json['proposedDateTime'] as String),
        alternativeDateTime: json['alternativeDateTime'] != null
            ? DateTime.parse(json['alternativeDateTime'] as String)
            : null,
        status: ViewingRequestStatus.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => ViewingRequestStatus.requested,
        ),
        tenantNote: json['tenantNote'] as String?,
        ownerResponseNote: json['ownerResponseNote'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

/// Inquiry sent by an interested user about a property listing.
class InquiryModel {
  final String id;
  final String listingId;
  final String listingTitle;
  final String senderUserId;
  final String senderName;
  final String recipientOwnerUserId;
  final String messageText;
  final String preferredContactMethod; // inApp, phone, whatsapp
  final bool isAnswered;
  final DateTime createdAt;

  const InquiryModel({
    required this.id,
    required this.listingId,
    required this.listingTitle,
    required this.senderUserId,
    required this.senderName,
    required this.recipientOwnerUserId,
    required this.messageText,
    this.preferredContactMethod = 'inApp',
    this.isAnswered = false,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'listingId': listingId,
        'listingTitle': listingTitle,
        'senderUserId': senderUserId,
        'senderName': senderName,
        'recipientOwnerUserId': recipientOwnerUserId,
        'messageText': messageText,
        'preferredContactMethod': preferredContactMethod,
        'isAnswered': isAnswered,
        'createdAt': createdAt.toIso8601String(),
      };

  factory InquiryModel.fromJson(Map<String, dynamic> json) => InquiryModel(
        id: json['id'] as String,
        listingId: json['listingId'] as String,
        listingTitle: json['listingTitle'] as String,
        senderUserId: json['senderUserId'] as String,
        senderName: json['senderName'] as String,
        recipientOwnerUserId: json['recipientOwnerUserId'] as String,
        messageText: json['messageText'] as String,
        preferredContactMethod:
            json['preferredContactMethod'] as String? ?? 'inApp',
        isAnswered: json['isAnswered'] as bool? ?? false,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

/// Real-time chat message within a conversation.
class MessageModel {
  final String id;
  final String conversationId;
  final String senderUserId;
  final String senderName;
  final String content;
  final bool isRead;
  final DateTime sentAt;

  const MessageModel({
    required this.id,
    required this.conversationId,
    required this.senderUserId,
    required this.senderName,
    required this.content,
    this.isRead = false,
    required this.sentAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'conversationId': conversationId,
        'senderUserId': senderUserId,
        'senderName': senderName,
        'content': content,
        'isRead': isRead,
        'sentAt': sentAt.toIso8601String(),
      };

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        id: json['id'] as String,
        conversationId: json['conversationId'] as String,
        senderUserId: json['senderUserId'] as String,
        senderName: json['senderName'] as String,
        content: json['content'] as String,
        isRead: json['isRead'] as bool? ?? false,
        sentAt: DateTime.parse(json['sentAt'] as String),
      );
}

/// Conversation channel linked to a listing between two parties.
class ConversationModel {
  final String id;
  final String listingId;
  final String listingTitle;
  final List<String> participantUserIds;
  final String lastMessageText;
  final DateTime lastMessageTime;
  final int unreadCount;

  const ConversationModel({
    required this.id,
    required this.listingId,
    required this.listingTitle,
    required this.participantUserIds,
    required this.lastMessageText,
    required this.lastMessageTime,
    this.unreadCount = 0,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'listingId': listingId,
        'listingTitle': listingTitle,
        'participantUserIds': participantUserIds,
        'lastMessageText': lastMessageText,
        'lastMessageTime': lastMessageTime.toIso8601String(),
        'unreadCount': unreadCount,
      };

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      ConversationModel(
        id: json['id'] as String,
        listingId: json['listingId'] as String,
        listingTitle: json['listingTitle'] as String,
        participantUserIds: (json['participantUserIds'] as List<dynamic>)
            .map((e) => e.toString())
            .toList(),
        lastMessageText: json['lastMessageText'] as String,
        lastMessageTime: DateTime.parse(json['lastMessageTime'] as String),
        unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
      );
}

