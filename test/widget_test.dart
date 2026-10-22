import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tolate/app/app.dart';
import 'package:tolate/data/repositories/auth_repository.dart';
import 'package:tolate/features/auth/presentation/login_phone_screen.dart';
import 'package:tolate/features/auth/presentation/widgets/auth_divider.dart';
import 'package:tolate/features/auth/presentation/widgets/google_sign_in_button.dart';
import 'package:tolate/features/auth/presentation/widgets/phone_input_field.dart';

void main() {
  testWidgets('ToLateApp smoke and launch test', (WidgetTester tester) async {
    await tester.pumpWidget(const ToLateApp());
    await tester.pump();
    expect(find.byType(ToLateApp), findsOneWidget);
  });

  testWidgets('GoogleSignInButton renders with correct label and handles tap', (WidgetTester tester) async {
    bool tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GoogleSignInButton(
            onPressed: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.text('Google দিয়ে সাইন ইন / সাইন আপ করুন'), findsOneWidget);
    await tester.tap(find.byType(GoogleSignInButton));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('AuthDivider renders correctly with custom text', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AuthDivider(label: 'অথবা মোবাইল নম্বর দিয়ে'),
        ),
      ),
    );

    expect(find.text('অথবা মোবাইল নম্বর দিয়ে'), findsOneWidget);
    expect(find.byType(Divider), findsNWidgets(2));
  });

  testWidgets('LoginPhoneScreen displays both Google sign-in and usual phone option', (WidgetTester tester) async {
    final authRepo = AuthRepository();
    await tester.pumpWidget(
      ChangeNotifierProvider<AuthRepository>.value(
        value: authRepo,
        child: const MaterialApp(
          home: LoginPhoneScreen(),
        ),
      ),
    );

    // Google Sign-In Option
    expect(find.byType(GoogleSignInButton), findsOneWidget);
    expect(find.text('Google দিয়ে সাইন ইন / সাইন আপ করুন'), findsOneWidget);

    // Divider
    expect(find.byType(AuthDivider), findsOneWidget);

    // As Usual Phone Input Option
    expect(find.byType(PhoneInputField), findsOneWidget);
    expect(find.text('ওটিপি পাঠান (Send OTP)'), findsOneWidget);
  });
}
