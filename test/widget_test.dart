import 'package:flutter_test/flutter_test.dart';
import 'package:tourconnect/app.dart';

void main() {
  testWidgets('App loads test', (WidgetTester tester) async {
    await tester.pumpWidget(const TourConnectApp());

    expect(find.text('TourConnect'), findsOneWidget);
  });
}