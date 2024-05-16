import 'package:flutter/material.dart';
import 'package:flutter_journal/widgets/journal_content.dart';
import 'package:flutter_journal/widgets/profile_info.dart';
import 'package:flutter_journal/widgets/profile_name.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const Map<String, dynamic> post = {
    'Content': 'test content',
    'Email': 'test@test.com',
    'Image': 'test url',
    'Title': 'test title',
    'Location': 'test location'
  };
  const Map<String, dynamic> user = {
    'followers': ['test1@test.com', 'test2@test.com'],
    'following': ['test3@test.com'],
    'name': 'test name',
    'post': 'test post id',
  };
  testWidgets('testing JournalContent', (WidgetTester tester) async {

    await tester.pumpWidget(const MaterialApp(
      home: Directionality(
        textDirection: TextDirection.ltr,
        child: JournalContent(post: post),
      ),
    ));
    expect(find.text(post['Location']), findsOneWidget);
    expect(find.text(post['Title']), findsOneWidget);
    expect(find.text(post['Content']), findsOneWidget);

    // Tap the '+' icon and trigger a frame.
    // await tester.tap(find.byIcon(Icons.add));
    // await tester.pump();
  });
  testWidgets('test ProfileInfo', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Directionality(
          textDirection: TextDirection.ltr,
          child: ProfileInfo(info: user, userEmail: 'test@test.com', isCurrentUser: true)),
    ));
    // expect(find.text(text), matcher)
  });
  testWidgets('ProfileName', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Directionality(
          textDirection: TextDirection.ltr, // or TextDirection.rtl
          child: ProfileName(name: 'test name'),
        ),
      ),
    );
    expect(find.text('test name'), findsOneWidget);
  });
}
