import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_journal/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Test app functionality', (WidgetTester tester) async {
    // Fully Load the app
    app.main();
    await tester.pumpAndSettle();

    // TEST THE LOGIN PAGE
    // Find the email input field and enter text
    final emailInputFinder = find.byKey(const ValueKey('emailInput'));
    expect(emailInputFinder, findsOneWidget);
    await tester.enterText(emailInputFinder, 't@t.com');
   // Find the password input field and enter text
    final passwordInputFinder = find.byKey(const ValueKey('passwordInput'));
    expect(passwordInputFinder, findsOneWidget);
    await tester.enterText(passwordInputFinder, 'qwerty');
   // Find the submit button and tap on it
    final submitBtnFinder = find.byKey(const ValueKey('submitBtn'));
    expect(submitBtnFinder, findsOneWidget);
    await tester.tap(submitBtnFinder);
    await tester.pumpAndSettle();
    // Verify transition from login to the home page
    final homeJournalListFinder = find.byKey(const ValueKey('homeJournalList'));
    expect(homeJournalListFinder, findsOneWidget);

    // TEST THE EXPLORE PAGE
    final exploreBtnFinder = find.byKey(const ValueKey('exploreBtn'));
    expect(exploreBtnFinder, findsOneWidget);
    await tester.tap(exploreBtnFinder);
    await tester.pumpAndSettle();
    // Verify
    final exploreJournalListFinder = find.byKey(const ValueKey('exploreJournalList'));
    expect(exploreJournalListFinder, findsOneWidget);
    
    // TEST A JOURNAL PREVIEW ITEM
    final journalPreviewFinder = find.byKey(const ValueKey('journalPreview-0'));
    expect(journalPreviewFinder, findsOneWidget);
    await tester.tap(journalPreviewFinder);
    await tester.pumpAndSettle();
    // Verify
    final journalContentFinder = find.byKey(const ValueKey('journalContent'));
    expect(journalContentFinder, findsOneWidget);
    final journalImageFinder = find.byKey(const ValueKey('journalImage'));
    expect(journalImageFinder, findsOneWidget);
    // Go back to the explore page
    final backBtnFinder = find.byTooltip('Back');
    expect(backBtnFinder, findsOneWidget);
    await tester.tap(backBtnFinder);
    await tester.pumpAndSettle();

    // TEST THE PROFILE PAGE
    final profileBtnFinder = find.byKey(const ValueKey('profileBtn'));
    expect(profileBtnFinder, findsOneWidget);
    await tester.tap(profileBtnFinder);
    await tester.pumpAndSettle();
    // Verify
    final profileInfo = find.byKey(const ValueKey('profileInfo'));
    expect(profileInfo, findsOneWidget);
    
    // TEST FOLLOWING
    final followingBtnFinder = find.byKey(const ValueKey('profileInfoItem-2'));
    expect(followingBtnFinder, findsOneWidget);
    await tester.tap(followingBtnFinder);
    await tester.pumpAndSettle();
    // Verify
    final followingListFinder = find.byKey(const ValueKey('followList'));
    expect(followingListFinder, findsOneWidget);
    // Go back to the profile page
    expect(backBtnFinder, findsOneWidget);
    await tester.tap(backBtnFinder);
    await tester.pumpAndSettle();

  });
}