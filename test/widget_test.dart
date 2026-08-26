import 'package:flutter_test/flutter_test.dart';
import 'package:movie_hub/main.dart';

void main() {
  testWidgets('MovieHub app loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('MovieHub'), findsOneWidget);
    expect(find.text('Discover your next favorite movie'), findsOneWidget);
  }
  );
}