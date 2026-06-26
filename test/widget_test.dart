import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:copiaos_mobile/app.dart';

void main() {
  testWidgets('App renders login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: CopiaOSApp()));
    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('App has correct title', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: CopiaOSApp()));
    await tester.pump();

    final MaterialApp app = tester.widget(find.byType(MaterialApp));
    expect(app.title, 'CopiaOS');
  });

  testWidgets('App uses correct theme', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: CopiaOSApp()));
    await tester.pump();

    final MaterialApp app = tester.widget(find.byType(MaterialApp));
    expect(app.theme, isNotNull);
    expect(app.debugShowCheckedModeBanner, false);
  });
}
