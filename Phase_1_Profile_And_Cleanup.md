# Antigravity Instructions: Phase 1 - OTP Cleanup & Profile Media

**Context:** 
You are working on the "ToLate" Flutter project. The codebase is already initialized with Firebase Auth, Firestore, and a basic UI shell. Your task is to implement the first set of critical features according to the Master Spec.

**MANDATORY RULES:**
1. Inspect existing files before modifying. Do not break working code.
2. Keep files small and modular. Use `*_web.dart`, `*_android.dart`, `*_ios.dart` for platform-specific logic (like Camera/Gallery pickers).
3. NO DUMMY DATA. Use real Firebase results and honest empty states.
4. Do not claim a feature is done unless it compiles and works.

## Task 1: Remove Hardcoded Test OTP
- Locate `lib/features/auth/presentation/otp_verification_screen.dart` (or similar).
- Remove any hardcoded test OTP (e.g., "123456") or fake bypass logic.
- Ensure the screen strictly relies on real Firebase Phone Auth (`FirebaseAuth.instance.verifyPhoneNumber`).

## Task 2: Profile Picture & Cover Photo (Screen 30 & 31)
Implement the ability for a user to upload both a Profile Picture and a Cover Photo.

### 2.1. Dependencies
- Add `image_picker` and `firebase_storage` to `pubspec.yaml` if not already present.

### 2.2. Platform Adapters (Crucial)
Create platform-specific media pickers using interfaces:
- `lib/core/media/media_picker.dart` (Interface)
- `lib/platform/web/web_media_picker.dart` (Use file input / browser camera)
- `lib/platform/android/android_media_picker.dart` (Use Android intent)
- `lib/platform/ios/ios_media_picker.dart` (Use iOS photo picker)
*Requirement:* Must support both Camera and Gallery options.

### 2.3. UI Implementation (Edit Profile Screen)
- Create or update `lib/features/profile/presentation/edit_profile_screen.dart`.
- Add UI for Profile Picture and Cover Photo.
- Include options to: Select from Camera, Select from Gallery, Preview, Remove, and Save.
- Show a default avatar/cover if none exists.

### 2.4. Upload Logic
- Implement the upload process using `firebase_storage`.
- Store files in paths: `users/{userId}/profile.jpg` and `users/{userId}/cover.jpg`.
- After successful upload, get the download URL and update the user's document in Firestore (`users` collection) with `profilePhotoUrl` and `coverPhotoUrl`.
- **Crucial:** Only update Firestore after the upload is successful. Handle loading, success, and error states.
- (Optional but recommended): Strip EXIF data from images before upload if possible.

## Task 3: Firestore Security Rules Check
- Ensure Firestore rules allow authenticated users to update only their own `profilePhotoUrl` and `coverPhotoUrl` fields.

## Deliverables
- New/modified files listed.
- Confirmation that `image_picker` and `firebase_storage` are working.
- Confirmation that OTP test bypass is removed.