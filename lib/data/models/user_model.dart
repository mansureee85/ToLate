import '../../core/constants/property_enums.dart';

/// User privacy preferences for public visibility.
class UserPrivacySettings {
  final bool showPhoneNumber;
  final bool allowInAppMessages;
  final bool allowPhoneCalls;
  final bool allowWhatsApp;

  const UserPrivacySettings({
    this.showPhoneNumber = false,
    this.allowInAppMessages = true,
    this.allowPhoneCalls = false,
    this.allowWhatsApp = false,
  });

  Map<String, dynamic> toJson() => {
        'showPhoneNumber': showPhoneNumber,
        'allowInAppMessages': allowInAppMessages,
        'allowPhoneCalls': allowPhoneCalls,
        'allowWhatsApp': allowWhatsApp,
      };

  factory UserPrivacySettings.fromJson(Map<String, dynamic> json) =>
      UserPrivacySettings(
        showPhoneNumber: json['showPhoneNumber'] as bool? ?? false,
        allowInAppMessages: json['allowInAppMessages'] as bool? ?? true,
        allowPhoneCalls: json['allowPhoneCalls'] as bool? ?? false,
        allowWhatsApp: json['allowWhatsApp'] as bool? ?? false,
      );
}

/// User entity model.
class UserModel {
  final String id;
  final String? displayName;
  final String? email;
  final String? phoneNumber;
  final bool isPhoneVerified;
  final String? authProvider;
  final String? bio;
  final String? profilePhotoUrl;
  final String? coverPhotoUrl;
  final List<UserRole> roles;
  final AdminRole? adminRole;
  final bool isSuspended;
  final String? preferredLanguage;
  final UserPrivacySettings privacySettings;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    this.displayName,
    this.email,
    this.phoneNumber,
    this.isPhoneVerified = false,
    this.authProvider = 'phone',
    this.bio,
    this.profilePhotoUrl,
    this.coverPhotoUrl,
    this.roles = const [UserRole.tenant],
    this.adminRole,
    this.isSuspended = false,
    this.preferredLanguage = 'bn',
    this.privacySettings = const UserPrivacySettings(),
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isAdmin => adminRole != null;

  UserModel copyWith({
    String? displayName,
    String? email,
    String? phoneNumber,
    bool? isPhoneVerified,
    String? authProvider,
    String? bio,
    String? profilePhotoUrl,
    String? coverPhotoUrl,
    List<UserRole>? roles,
    AdminRole? adminRole,
    bool? isSuspended,
    String? preferredLanguage,
    UserPrivacySettings? privacySettings,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      authProvider: authProvider ?? this.authProvider,
      bio: bio ?? this.bio,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      coverPhotoUrl: coverPhotoUrl ?? this.coverPhotoUrl,
      roles: roles ?? this.roles,
      adminRole: adminRole ?? this.adminRole,
      isSuspended: isSuspended ?? this.isSuspended,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      privacySettings: privacySettings ?? this.privacySettings,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'displayName': displayName,
      'email': email,
      'phoneNumber': phoneNumber,
      'isPhoneVerified': isPhoneVerified,
      'authProvider': authProvider,
      'bio': bio,
      'profilePhotoUrl': profilePhotoUrl,
      'coverPhotoUrl': coverPhotoUrl,
      'roles': roles.map((r) => r.name).toList(),
      'adminRole': adminRole?.name,
      'isSuspended': isSuspended,
      'preferredLanguage': preferredLanguage,
      'privacySettings': privacySettings.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      displayName: json['displayName'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      isPhoneVerified: json['isPhoneVerified'] as bool? ?? false,
      authProvider: json['authProvider'] as String? ?? 'phone',
      bio: json['bio'] as String?,
      profilePhotoUrl: json['profilePhotoUrl'] as String?,
      coverPhotoUrl: json['coverPhotoUrl'] as String?,
      roles: (json['roles'] as List<dynamic>?)
              ?.map((e) => UserRole.values.firstWhere(
                    (r) => r.name == e,
                    orElse: () => UserRole.tenant,
                  ))
              .toList() ??
          [UserRole.tenant],
      adminRole: json['adminRole'] != null
          ? AdminRole.values.firstWhere(
              (r) => r.name == json['adminRole'],
              orElse: () => AdminRole.listingModerator,
            )
          : null,
      isSuspended: json['isSuspended'] as bool? ?? false,
      preferredLanguage: json['preferredLanguage'] as String? ?? 'bn',
      privacySettings: json['privacySettings'] != null
          ? UserPrivacySettings.fromJson(
              json['privacySettings'] as Map<String, dynamic>)
          : const UserPrivacySettings(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

