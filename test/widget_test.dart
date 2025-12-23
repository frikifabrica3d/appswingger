import 'package:flutter_test/flutter_test.dart';
import 'package:appswingger/app.dart';

void main() {
  testWidgets('AppSwingger smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AppSwingger());

    // Verify that the app builds without crashing.
    // Since we are in MainLayout, we can look for something specific if we want,
    // but for now just ensuring it pumps is enough for a smoke test.
    expect(find.byType(AppSwingger), findsOneWidget);
  });
}
