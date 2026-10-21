/// Immutable security and administrative audit log entry.
class AuditLogModel {
  final String id;
  final String actorUserId;
  final String actorRole;
  final String action; // e.g. 'LISTING_APPROVE', 'USER_SUSPEND', 'PROPOSED_AREA_MERGE'
  final String targetType;
  final String targetId;
  final String reason;
  final Map<String, dynamic>? metadata;
  final DateTime timestamp;

  const AuditLogModel({
    required this.id,
    required this.actorUserId,
    required this.actorRole,
    required this.action,
    required this.targetType,
    required this.targetId,
    required this.reason,
    this.metadata,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'actorUserId': actorUserId,
        'actorRole': actorRole,
        'action': action,
        'targetType': targetType,
        'targetId': targetId,
        'reason': reason,
        'metadata': metadata,
        'timestamp': timestamp.toIso8601String(),
      };

  factory AuditLogModel.fromJson(Map<String, dynamic> json) => AuditLogModel(
        id: json['id'] as String,
        actorUserId: json['actorUserId'] as String,
        actorRole: json['actorRole'] as String,
        action: json['action'] as String,
        targetType: json['targetType'] as String,
        targetId: json['targetId'] as String,
        reason: json['reason'] as String,
        metadata: json['metadata'] as Map<String, dynamic>?,
        timestamp: DateTime.parse(json['timestamp'] as String),
      );
}

