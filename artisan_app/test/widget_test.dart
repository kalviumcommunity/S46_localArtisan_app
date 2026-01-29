import 'package:flutter_test/flutter_test.dart';
import 'package:artisan_app/main.dart';

void main() {
  testWidgets('Splash screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const LocalArtisanApp());

    // Verify that the splash screen text exists.
    expect(find.text('Local Artisan'), findsOneWidget);
    expect(find.text('Digital Storefront'), findsOneWidget);
  });
}
