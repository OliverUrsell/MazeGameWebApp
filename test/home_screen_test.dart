
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maze_game_web_app/game.dart';

import 'package:maze_game_web_app/main.dart';

void main() {
  testWidgets('Home Screen Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the title is present
    expect(find.text("The Falcon's Nest Hotel"), findsOneWidget);

    // Verify that the Enter Code text is present
    expect(find.text("Enter Code:"), findsOneWidget);

    // Verify that the input button is present
    expect(find.byType(TextField), findsOneWidget);

    // Verify that the input button is empty
    expect(find.text("----"), findsOneWidget);

    // Verify that the description is present
    expect(find.text("Get this from the VR player"), findsOneWidget);

    // Verify that the Connect button is present
    expect(find.text("Connect"), findsOneWidget);
  });

  testWidgets('Input field test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Enter the code 1234 into the 'TextField' object and trigger a frame.
    await tester.enterText(find.byType(TextField), "1234");
    await tester.pump();

    // Verify the code has appeared on screen
    expect(find.text("1234"), findsOneWidget);
  });

  testWidgets('Input partial entry test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Enter the 1 into the 'TextField' object and trigger a frame.
    await tester.enterText(find.byType(TextField), "1");
    await tester.pump();

    // Verify the code is correct on screen
    expect(find.text("1---"), findsOneWidget);

    // Enter the 2 into the 'TextField' object and trigger a frame.
    await tester.enterText(find.byType(TextField), "12");
    await tester.pump();

    // Verify the code is correct on screen
    expect(find.text("12--"), findsOneWidget);

    // Enter the 3 into the 'TextField' object and trigger a frame.
    await tester.enterText(find.byType(TextField), "123");
    await tester.pump();

    // Verify the code is correct on screen
    expect(find.text("123-"), findsOneWidget);
  });

  testWidgets('Input field max length test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    tester.testTextInput.enterText("");

    // Enter the code 12345 into the 'TextField' object and trigger a frame.
    // await tester.enterText(find.byType(TextField), "12345");
    await tester.pump();

    // Verify that only the code 1234 has appeared on screen
    expect(find.text("----"), findsOneWidget);
  });

  testWidgets('Connection test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Enter the 3 into the 'TextField' object and trigger a frame.
    await tester.enterText(find.byType(TextField), "1234");
    await tester.pump();

    // Verify the code is correct on screen
    expect(find.text("1234"), findsOneWidget);

    // Tap the connect button
    await tester.tap(find.text("Connect"));
    await tester.pumpAndSettle();

    // Verify that the page is now a Game and it has the correct code
    expect(find.byType(Game), findsOneWidget);
    Game g = (await find.byType(Game)).evaluate().first.widget as Game;
    expect(g.code, "1234");

  });
}
