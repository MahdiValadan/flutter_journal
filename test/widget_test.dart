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
    'posts': ['test-post-1-id', 'test-post-2-id', 'test-post-3-id'],
  };
  testWidgets('Testing JournalContent', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Directionality(
        textDirection: TextDirection.ltr,
        child: JournalContent(post: post),
      ),
    ));
    expect(find.text(post['Location']), findsOneWidget);
    expect(find.text(post['Title']), findsOneWidget);
    expect(find.text(post['Content']), findsOneWidget);
  });
  testWidgets('Testing ProfileInfo', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Directionality(
        textDirection: TextDirection.ltr,
        child: ProfileInfo(info: user, userEmail: 'test@test.com', isCurrentUser: true,),
      ),
    ));
    expect(find.text('Posts'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('Followers'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('Following'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
  });
  testWidgets('Testing ProfileName', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Directionality(
          textDirection: TextDirection.ltr,
          child: ProfileName(name: 'test name'),
        ),
      ),
    );
    expect(find.text('test name'), findsOneWidget);
  });
}
