import 'package:flutter_test/flutter_test.dart';
import 'package:tempo_workout_timer/app/tempo_app.dart';

void main() {
  testWidgets('home presents Tempo and the workout library', (tester) async {
    await tester.pumpWidget(const TempoApp());

    expect(find.text('Tempo'), findsOneWidget);
    expect(find.text('Entrenamientos'), findsOneWidget);
  });
}
