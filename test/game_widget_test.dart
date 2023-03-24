
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maze_game_web_app/arrow_controls.dart';
import 'package:maze_game_web_app/maze_position_indicator.dart';
import 'package:maze_game_web_app/game.dart';

import 'package:maze_game_web_app/main.dart';
import 'package:maze_game_web_app/maze.dart';
import 'package:maze_game_web_app/maze_socket.dart';

Future<Game> startGame(WidgetTester tester, String code) async{
  // Build our app and trigger a frame.
  await tester.pumpWidget(const MyApp());

  // Enter the 3 into the 'TextField' object and trigger a frame.
  await tester.enterText(find.byType(TextField), code);

  // Tap the connect button
  await tester.tap(find.text("Connect"));
  await tester.pumpAndSettle();

  // Verify that the page is now a Game and it has the correct code
  expect(find.byType(Game), findsOneWidget);
  Game g = (find.byType(Game)).evaluate().first.widget as Game;
  expect(g.code, code);

  return g;
}



void main() {
  const String mazeMessageMonster = """MAZE {"depth":12,"goal_x":11,"goal_y":11,"nodes":[{"east":false,"north":true,"south":true,"west":true,"x":0,"y":0},{"east":false,"north":false,"south":true,"west":true,"x":1,"y":0},{"east":false,"north":false,"south":false,"west":true,"x":2,"y":0},{"east":false,"north":false,"south":false,"west":true,"x":3,"y":0},{"east":false,"north":true,"south":false,"west":true,"x":4,"y":0},{"east":true,"north":false,"south":true,"west":true,"x":5,"y":0},{"east":true,"north":false,"south":false,"west":true,"x":6,"y":0},{"east":false,"north":true,"south":false,"west":true,"x":7,"y":0},{"east":false,"north":false,"south":true,"west":true,"x":8,"y":0},{"east":false,"north":false,"south":false,"west":true,"x":9,"y":0},{"east":true,"north":false,"south":false,"west":true,"x":10,"y":0},{"east":true,"north":true,"south":false,"west":true,"x":11,"y":0},{"east":false,"north":true,"south":true,"west":false,"x":0,"y":1},{"east":false,"north":false,"south":true,"west":false,"x":1,"y":1},{"east":false,"north":false,"south":false,"west":false,"x":2,"y":1},{"east":true,"north":false,"south":false,"west":false,"x":3,"y":1},{"east":true,"north":true,"south":false,"west":false,"x":4,"y":1},{"east":false,"north":false,"south":true,"west":true,"x":5,"y":1},{"east":true,"north":false,"south":false,"west":true,"x":6,"y":1},{"east":false,"north":false,"south":false,"west":false,"x":7,"y":1},{"east":false,"north":false,"south":false,"west":false,"x":8,"y":1},{"east":true,"north":false,"south":false,"west":false,"x":9,"y":1},{"east":true,"north":false,"south":false,"west":true,"x":10,"y":1},{"east":true,"north":true,"south":false,"west":true,"x":11,"y":1},{"east":false,"north":false,"south":true,"west":false,"x":0,"y":2},{"east":false,"north":false,"south":false,"west":false,"x":1,"y":2},{"east":false,"north":true,"south":false,"west":false,"x":2,"y":2},{"east":false,"north":false,"south":true,"west":true,"x":3,"y":2},{"east":true,"north":false,"south":false,"west":true,"x":4,"y":2},{"east":false,"north":false,"south":false,"west":false,"x":5,"y":2},{"east":true,"north":true,"south":false,"west":true,"x":6,"y":2},{"east":true,"north":false,"south":true,"west":false,"x":7,"y":2},{"east":false,"north":false,"south":false,"west":false,"x":8,"y":2},{"east":true,"north":false,"south":false,"west":true,"x":9,"y":2},{"east":true,"north":false,"south":false,"west":true,"x":10,"y":2},{"east":true,"north":true,"south":false,"west":true,"x":11,"y":2},{"east":false,"north":false,"south":true,"west":false,"x":0,"y":3},{"east":false,"north":false,"south":false,"west":false,"x":1,"y":3},{"east":false,"north":false,"south":false,"west":false,"x":2,"y":3},{"east":false,"north":false,"south":false,"west":false,"x":3,"y":3},{"east":false,"north":false,"south":false,"west":true,"x":4,"y":3},{"east":true,"north":false,"south":false,"west":false,"x":5,"y":3},{"east":true,"north":false,"south":false,"west":true,"x":6,"y":3},{"east":true,"north":true,"south":false,"west":true,"x":7,"y":3},{"east":true,"north":false,"south":true,"west":false,"x":8,"y":3},{"east":true,"north":false,"south":false,"west":true,"x":9,"y":3},{"east":true,"north":false,"south":false,"west":true,"x":10,"y":3},{"east":true,"north":true,"south":false,"west":true,"x":11,"y":3},{"east":true,"north":false,"south":true,"west":false,"x":0,"y":4},{"east":false,"north":true,"south":false,"west":false,"x":1,"y":4},{"east":true,"north":true,"south":true,"west":false,"x":2,"y":4},{"east":true,"north":true,"south":true,"west":false,"x":3,"y":4},{"east":false,"north":false,"south":true,"west":false,"x":4,"y":4},{"east":true,"north":false,"south":false,"west":true,"x":5,"y":4},{"east":false,"north":false,"south":false,"west":true,"x":6,"y":4},{"east":true,"north":false,"south":false,"west":true,"x":7,"y":4},{"east":false,"north":false,"south":false,"west":true,"x":8,"y":4},{"east":true,"north":false,"south":false,"west":true,"x":9,"y":4},{"east":true,"north":false,"south":false,"west":true,"x":10,"y":4},{"east":true,"north":true,"south":false,"west":true,"x":11,"y":4},{"east":true,"north":false,"south":true,"west":true,"x":0,"y":5},{"east":false,"north":true,"south":false,"west":false,"x":1,"y":5},{"east":true,"north":false,"south":true,"west":true,"x":2,"y":5},{"east":false,"north":false,"south":false,"west":true,"x":3,"y":5},{"east":false,"north":false,"south":false,"west":false,"x":4,"y":5},{"east":true,"north":true,"south":false,"west":true,"x":5,"y":5},{"east":false,"north":false,"south":true,"west":false,"x":6,"y":5},{"east":true,"north":true,"south":false,"west":true,"x":7,"y":5},{"east":false,"north":false,"south":true,"west":false,"x":8,"y":5},{"east":false,"north":false,"south":false,"west":true,"x":9,"y":5},{"east":false,"north":false,"south":false,"west":true,"x":10,"y":5},{"east":false,"north":true,"south":false,"west":true,"x":11,"y":5},{"east":false,"north":false,"south":true,"west":true,"x":0,"y":6},{"east":false,"north":false,"south":false,"west":false,"x":1,"y":6},{"east":true,"north":true,"south":false,"west":true,"x":2,"y":6},{"east":false,"north":true,"south":true,"west":false,"x":3,"y":6},{"east":false,"north":false,"south":true,"west":false,"x":4,"y":6},{"east":true,"north":true,"south":false,"west":true,"x":5,"y":6},{"east":false,"north":false,"south":true,"west":false,"x":6,"y":6},{"east":true,"north":true,"south":false,"west":true,"x":7,"y":6},{"east":true,"north":true,"south":true,"west":false,"x":8,"y":6},{"east":true,"north":true,"south":true,"west":false,"x":9,"y":6},{"east":false,"north":true,"south":true,"west":false,"x":10,"y":6},{"east":true,"north":true,"south":true,"west":false,"x":11,"y":6},{"east":true,"north":true,"south":true,"west":false,"x":0,"y":7},{"east":false,"north":true,"south":true,"west":false,"x":1,"y":7},{"east":false,"north":true,"south":true,"west":true,"x":2,"y":7},{"east":false,"north":true,"south":true,"west":false,"x":3,"y":7},{"east":false,"north":false,"south":true,"west":false,"x":4,"y":7},{"east":false,"north":true,"south":false,"west":true,"x":5,"y":7},{"east":false,"north":false,"south":true,"west":false,"x":6,"y":7},{"east":false,"north":true,"south":false,"west":true,"x":7,"y":7},{"east":false,"north":false,"south":true,"west":true,"x":8,"y":7},{"east":true,"north":true,"south":false,"west":true,"x":9,"y":7},{"east":true,"north":false,"south":true,"west":false,"x":10,"y":7},{"east":true,"north":true,"south":false,"west":true,"x":11,"y":7},{"east":true,"north":false,"south":true,"west":true,"x":0,"y":8},{"east":false,"north":false,"south":false,"west":false,"x":1,"y":8},{"east":false,"north":true,"south":false,"west":false,"x":2,"y":8},{"east":false,"north":true,"south":true,"west":false,"x":3,"y":8},{"east":false,"north":true,"south":true,"west":false,"x":4,"y":8},{"east":false,"north":true,"south":true,"west":false,"x":5,"y":8},{"east":false,"north":true,"south":true,"west":false,"x":6,"y":8},{"east":false,"north":false,"south":true,"west":false,"x":7,"y":8},{"east":true,"north":true,"south":false,"west":false,"x":8,"y":8},{"east":false,"north":false,"south":true,"west":true,"x":9,"y":8},{"east":true,"north":false,"south":false,"west":true,"x":10,"y":8},{"east":false,"north":true,"south":false,"west":true,"x":11,"y":8},{"east":true,"north":false,"south":true,"west":true,"x":0,"y":9},{"east":false,"north":true,"south":false,"west":false,"x":1,"y":9},{"east":true,"north":true,"south":true,"west":false,"x":2,"y":9},{"east":true,"north":false,"south":true,"west":false,"x":3,"y":9},{"east":false,"north":false,"south":false,"west":false,"x":4,"y":9},{"east":false,"north":true,"south":false,"west":false,"x":5,"y":9},{"east":true,"north":true,"south":true,"west":false,"x":6,"y":9},{"east":false,"north":false,"south":true,"west":false,"x":7,"y":9},{"east":false,"north":false,"south":false,"west":true,"x":8,"y":9},{"east":false,"north":false,"south":false,"west":false,"x":9,"y":9},{"east":true,"north":true,"south":false,"west":true,"x":10,"y":9},{"east":false,"north":true,"south":true,"west":false,"x":11,"y":9},{"east":true,"north":false,"south":true,"west":true,"x":0,"y":10},{"east":false,"north":false,"south":false,"west":false,"x":1,"y":10},{"east":true,"north":true,"south":false,"west":true,"x":2,"y":10},{"east":false,"north":false,"south":true,"west":true,"x":3,"y":10},{"east":false,"north":true,"south":false,"west":false,"x":4,"y":10},{"east":false,"north":true,"south":true,"west":false,"x":5,"y":10},{"east":false,"north":false,"south":true,"west":true,"x":6,"y":10},{"east":false,"north":false,"south":false,"west":false,"x":7,"y":10},{"east":true,"north":true,"south":false,"west":false,"x":8,"y":10},{"east":false,"north":false,"south":true,"west":false,"x":9,"y":10},{"east":false,"north":true,"south":false,"west":true,"x":10,"y":10},{"east":false,"north":true,"south":true,"west":false,"x":11,"y":10},{"east":true,"north":false,"south":true,"west":true,"x":0,"y":11},{"east":true,"north":false,"south":false,"west":false,"x":1,"y":11},{"east":true,"north":false,"south":false,"west":true,"x":2,"y":11},{"east":true,"north":true,"south":false,"west":false,"x":3,"y":11},{"east":true,"north":false,"south":true,"west":false,"x":4,"y":11},{"east":true,"north":false,"south":false,"west":false,"x":5,"y":11},{"east":true,"north":false,"south":false,"west":false,"x":6,"y":11},{"east":true,"north":false,"south":false,"west":false,"x":7,"y":11},{"east":true,"north":false,"south":false,"west":true,"x":8,"y":11},{"east":true,"north":false,"south":false,"west":false,"x":9,"y":11},{"east":true,"north":false,"south":false,"west":false,"x":10,"y":11},{"east":true,"north":true,"south":false,"west":false,"x":11,"y":11}],"player_type":"monster","width":12}""";
  const String mazeMessageGuide = """MAZE {"depth":12,"goal_x":11,"goal_y":11,"nodes":[{"east":false,"north":true,"south":true,"west":true,"x":0,"y":0},{"east":false,"north":false,"south":true,"west":true,"x":1,"y":0},{"east":false,"north":false,"south":false,"west":true,"x":2,"y":0},{"east":false,"north":false,"south":false,"west":true,"x":3,"y":0},{"east":false,"north":true,"south":false,"west":true,"x":4,"y":0},{"east":true,"north":false,"south":true,"west":true,"x":5,"y":0},{"east":true,"north":false,"south":false,"west":true,"x":6,"y":0},{"east":false,"north":true,"south":false,"west":true,"x":7,"y":0},{"east":false,"north":false,"south":true,"west":true,"x":8,"y":0},{"east":false,"north":false,"south":false,"west":true,"x":9,"y":0},{"east":true,"north":false,"south":false,"west":true,"x":10,"y":0},{"east":true,"north":true,"south":false,"west":true,"x":11,"y":0},{"east":false,"north":true,"south":true,"west":false,"x":0,"y":1},{"east":false,"north":false,"south":true,"west":false,"x":1,"y":1},{"east":false,"north":false,"south":false,"west":false,"x":2,"y":1},{"east":true,"north":false,"south":false,"west":false,"x":3,"y":1},{"east":true,"north":true,"south":false,"west":false,"x":4,"y":1},{"east":false,"north":false,"south":true,"west":true,"x":5,"y":1},{"east":true,"north":false,"south":false,"west":true,"x":6,"y":1},{"east":false,"north":false,"south":false,"west":false,"x":7,"y":1},{"east":false,"north":false,"south":false,"west":false,"x":8,"y":1},{"east":true,"north":false,"south":false,"west":false,"x":9,"y":1},{"east":true,"north":false,"south":false,"west":true,"x":10,"y":1},{"east":true,"north":true,"south":false,"west":true,"x":11,"y":1},{"east":false,"north":false,"south":true,"west":false,"x":0,"y":2},{"east":false,"north":false,"south":false,"west":false,"x":1,"y":2},{"east":false,"north":true,"south":false,"west":false,"x":2,"y":2},{"east":false,"north":false,"south":true,"west":true,"x":3,"y":2},{"east":true,"north":false,"south":false,"west":true,"x":4,"y":2},{"east":false,"north":false,"south":false,"west":false,"x":5,"y":2},{"east":true,"north":true,"south":false,"west":true,"x":6,"y":2},{"east":true,"north":false,"south":true,"west":false,"x":7,"y":2},{"east":false,"north":false,"south":false,"west":false,"x":8,"y":2},{"east":true,"north":false,"south":false,"west":true,"x":9,"y":2},{"east":true,"north":false,"south":false,"west":true,"x":10,"y":2},{"east":true,"north":true,"south":false,"west":true,"x":11,"y":2},{"east":false,"north":false,"south":true,"west":false,"x":0,"y":3},{"east":false,"north":false,"south":false,"west":false,"x":1,"y":3},{"east":false,"north":false,"south":false,"west":false,"x":2,"y":3},{"east":false,"north":false,"south":false,"west":false,"x":3,"y":3},{"east":false,"north":false,"south":false,"west":true,"x":4,"y":3},{"east":true,"north":false,"south":false,"west":false,"x":5,"y":3},{"east":true,"north":false,"south":false,"west":true,"x":6,"y":3},{"east":true,"north":true,"south":false,"west":true,"x":7,"y":3},{"east":true,"north":false,"south":true,"west":false,"x":8,"y":3},{"east":true,"north":false,"south":false,"west":true,"x":9,"y":3},{"east":true,"north":false,"south":false,"west":true,"x":10,"y":3},{"east":true,"north":true,"south":false,"west":true,"x":11,"y":3},{"east":true,"north":false,"south":true,"west":false,"x":0,"y":4},{"east":false,"north":true,"south":false,"west":false,"x":1,"y":4},{"east":true,"north":true,"south":true,"west":false,"x":2,"y":4},{"east":true,"north":true,"south":true,"west":false,"x":3,"y":4},{"east":false,"north":false,"south":true,"west":false,"x":4,"y":4},{"east":true,"north":false,"south":false,"west":true,"x":5,"y":4},{"east":false,"north":false,"south":false,"west":true,"x":6,"y":4},{"east":true,"north":false,"south":false,"west":true,"x":7,"y":4},{"east":false,"north":false,"south":false,"west":true,"x":8,"y":4},{"east":true,"north":false,"south":false,"west":true,"x":9,"y":4},{"east":true,"north":false,"south":false,"west":true,"x":10,"y":4},{"east":true,"north":true,"south":false,"west":true,"x":11,"y":4},{"east":true,"north":false,"south":true,"west":true,"x":0,"y":5},{"east":false,"north":true,"south":false,"west":false,"x":1,"y":5},{"east":true,"north":false,"south":true,"west":true,"x":2,"y":5},{"east":false,"north":false,"south":false,"west":true,"x":3,"y":5},{"east":false,"north":false,"south":false,"west":false,"x":4,"y":5},{"east":true,"north":true,"south":false,"west":true,"x":5,"y":5},{"east":false,"north":false,"south":true,"west":false,"x":6,"y":5},{"east":true,"north":true,"south":false,"west":true,"x":7,"y":5},{"east":false,"north":false,"south":true,"west":false,"x":8,"y":5},{"east":false,"north":false,"south":false,"west":true,"x":9,"y":5},{"east":false,"north":false,"south":false,"west":true,"x":10,"y":5},{"east":false,"north":true,"south":false,"west":true,"x":11,"y":5},{"east":false,"north":false,"south":true,"west":true,"x":0,"y":6},{"east":false,"north":false,"south":false,"west":false,"x":1,"y":6},{"east":true,"north":true,"south":false,"west":true,"x":2,"y":6},{"east":false,"north":true,"south":true,"west":false,"x":3,"y":6},{"east":false,"north":false,"south":true,"west":false,"x":4,"y":6},{"east":true,"north":true,"south":false,"west":true,"x":5,"y":6},{"east":false,"north":false,"south":true,"west":false,"x":6,"y":6},{"east":true,"north":true,"south":false,"west":true,"x":7,"y":6},{"east":true,"north":true,"south":true,"west":false,"x":8,"y":6},{"east":true,"north":true,"south":true,"west":false,"x":9,"y":6},{"east":false,"north":true,"south":true,"west":false,"x":10,"y":6},{"east":true,"north":true,"south":true,"west":false,"x":11,"y":6},{"east":true,"north":true,"south":true,"west":false,"x":0,"y":7},{"east":false,"north":true,"south":true,"west":false,"x":1,"y":7},{"east":false,"north":true,"south":true,"west":true,"x":2,"y":7},{"east":false,"north":true,"south":true,"west":false,"x":3,"y":7},{"east":false,"north":false,"south":true,"west":false,"x":4,"y":7},{"east":false,"north":true,"south":false,"west":true,"x":5,"y":7},{"east":false,"north":false,"south":true,"west":false,"x":6,"y":7},{"east":false,"north":true,"south":false,"west":true,"x":7,"y":7},{"east":false,"north":false,"south":true,"west":true,"x":8,"y":7},{"east":true,"north":true,"south":false,"west":true,"x":9,"y":7},{"east":true,"north":false,"south":true,"west":false,"x":10,"y":7},{"east":true,"north":true,"south":false,"west":true,"x":11,"y":7},{"east":true,"north":false,"south":true,"west":true,"x":0,"y":8},{"east":false,"north":false,"south":false,"west":false,"x":1,"y":8},{"east":false,"north":true,"south":false,"west":false,"x":2,"y":8},{"east":false,"north":true,"south":true,"west":false,"x":3,"y":8},{"east":false,"north":true,"south":true,"west":false,"x":4,"y":8},{"east":false,"north":true,"south":true,"west":false,"x":5,"y":8},{"east":false,"north":true,"south":true,"west":false,"x":6,"y":8},{"east":false,"north":false,"south":true,"west":false,"x":7,"y":8},{"east":true,"north":true,"south":false,"west":false,"x":8,"y":8},{"east":false,"north":false,"south":true,"west":true,"x":9,"y":8},{"east":true,"north":false,"south":false,"west":true,"x":10,"y":8},{"east":false,"north":true,"south":false,"west":true,"x":11,"y":8},{"east":true,"north":false,"south":true,"west":true,"x":0,"y":9},{"east":false,"north":true,"south":false,"west":false,"x":1,"y":9},{"east":true,"north":true,"south":true,"west":false,"x":2,"y":9},{"east":true,"north":false,"south":true,"west":false,"x":3,"y":9},{"east":false,"north":false,"south":false,"west":false,"x":4,"y":9},{"east":false,"north":true,"south":false,"west":false,"x":5,"y":9},{"east":true,"north":true,"south":true,"west":false,"x":6,"y":9},{"east":false,"north":false,"south":true,"west":false,"x":7,"y":9},{"east":false,"north":false,"south":false,"west":true,"x":8,"y":9},{"east":false,"north":false,"south":false,"west":false,"x":9,"y":9},{"east":true,"north":true,"south":false,"west":true,"x":10,"y":9},{"east":false,"north":true,"south":true,"west":false,"x":11,"y":9},{"east":true,"north":false,"south":true,"west":true,"x":0,"y":10},{"east":false,"north":false,"south":false,"west":false,"x":1,"y":10},{"east":true,"north":true,"south":false,"west":true,"x":2,"y":10},{"east":false,"north":false,"south":true,"west":true,"x":3,"y":10},{"east":false,"north":true,"south":false,"west":false,"x":4,"y":10},{"east":false,"north":true,"south":true,"west":false,"x":5,"y":10},{"east":false,"north":false,"south":true,"west":true,"x":6,"y":10},{"east":false,"north":false,"south":false,"west":false,"x":7,"y":10},{"east":true,"north":true,"south":false,"west":false,"x":8,"y":10},{"east":false,"north":false,"south":true,"west":false,"x":9,"y":10},{"east":false,"north":true,"south":false,"west":true,"x":10,"y":10},{"east":false,"north":true,"south":true,"west":false,"x":11,"y":10},{"east":true,"north":false,"south":true,"west":true,"x":0,"y":11},{"east":true,"north":false,"south":false,"west":false,"x":1,"y":11},{"east":true,"north":false,"south":false,"west":true,"x":2,"y":11},{"east":true,"north":true,"south":false,"west":false,"x":3,"y":11},{"east":true,"north":false,"south":true,"west":false,"x":4,"y":11},{"east":true,"north":false,"south":false,"west":false,"x":5,"y":11},{"east":true,"north":false,"south":false,"west":false,"x":6,"y":11},{"east":true,"north":false,"south":false,"west":false,"x":7,"y":11},{"east":true,"north":false,"south":false,"west":true,"x":8,"y":11},{"east":true,"north":false,"south":false,"west":false,"x":9,"y":11},{"east":true,"north":false,"south":false,"west":false,"x":10,"y":11},{"east":true,"north":true,"south":false,"west":false,"x":11,"y":11}],"player_type":"guide","width":12}""";
  const String positionMessageNearPlayer = """Positions {"player_x":0,"player_y":1,"monster_x":2.998431921005249,"monster_y":2}""";
  const String positionMessageAwayFromPlayer = """Positions {"player_x":0,"player_y":1,"monster_x":7,"monster_y":2}""";
  const String northMovementMessage = "1234 MonsterDirection north";

  testWidgets("Not connected test", (WidgetTester tester) async {
    await startGame(tester, "1234");

    // Verify that the message when not connected is present
    expect(find.text("Waiting for the VR player to start the game"), findsOneWidget);
  });

  testWidgets("Monster maze networking test", (WidgetTester tester) async {
    bool receivedJoin = false;
    bool receivedNorthMovementMessage = false;
    void receive(String message){
      if(message == "1234 JoinGame") receivedJoin = true;
      if(message == northMovementMessage) receivedNorthMovementMessage = true;
    }

    StreamController controller = StreamController();

    MazeSocket().activateTestMode(TestModeMazeSocket(stream: controller.stream, receiveFunction: receive));

    await startGame(tester, "1234");

    // Test the join game message was sent
    expect(receivedJoin, true);

    // Verify that the message when not connected is present
    expect(find.text("Waiting for the VR player to start the game"), findsOneWidget);

    controller.add(mazeMessageMonster);
    await tester.pumpAndSettle();

    // Make sure the maze has been initialised
    expect(find.byType(Maze), findsOneWidget);

    // Make sure the goal hasn't been initialised
    expect(find.byType(MazePositionIndicator), findsNothing);

    // Make sure arrows have been initialised
    expect(find.byType(ArrowControls), findsOneWidget);

    // Make sure we send the up message when we tap the up arrow
    await tester.tap(find.byIcon(Icons.arrow_upward));
    await tester.pump();
    expect(receivedNorthMovementMessage, true);

    // Send monster and player information
    controller.add(positionMessageNearPlayer);
    await tester.pump();

    // Make sure the player has been initialised, with the monster
    expect(find.byType(MazePositionIndicator), findsNWidgets(2));
    MazePositionIndicator player = (find.byType(MazePositionIndicator)).evaluate().first.widget as MazePositionIndicator;
    expect(player.color, Colors.amber);

    // Make sure the monster has been initialised
    MazePositionIndicator monster = (find.byType(MazePositionIndicator)).evaluate().last.widget as MazePositionIndicator;
    expect(monster.color, Colors.red);

    // Send monster and player information
    controller.add(positionMessageAwayFromPlayer);
    await tester.pump();

    // Make sure the player has not been initialised, and only the monster has been initialised
    expect(find.byType(MazePositionIndicator), findsOneWidget);
    monster = (find.byType(MazePositionIndicator)).evaluate().first.widget as MazePositionIndicator;
    expect(monster.color, Colors.red);

  });

  testWidgets("Guide maze networking test", (WidgetTester tester) async {
    bool receivedJoin = false;
    void receive(String message){
      if(message == "1234 JoinGame") receivedJoin = true;
    }

    StreamController controller = StreamController();

    MazeSocket().activateTestMode(TestModeMazeSocket(stream: controller.stream, receiveFunction: receive));

    await startGame(tester, "1234");

    // Test the join game message was sent
    expect(receivedJoin, true);

    // Verify that the message when not connected is present
    expect(find.text("Waiting for the VR player to start the game"), findsOneWidget);

    controller.add(mazeMessageGuide);
    await tester.pumpAndSettle();

    // Make sure the maze has been initialised
    expect(find.byType(Maze), findsOneWidget);

    // Make sure the goal has been initialised
    expect(find.byType(MazePositionIndicator), findsOneWidget);
    MazePositionIndicator goal = (find.byType(MazePositionIndicator)).evaluate().first.widget as MazePositionIndicator;
    expect(goal.color, Colors.purple);

    // Make sure arrows have not been initialised
    expect(find.byType(ArrowControls), findsNothing);

    // Send monster and player information
    controller.add(positionMessageNearPlayer);
    await tester.pumpAndSettle();

    // Make sure other the player position has been initialised
    expect(find.byType(MazePositionIndicator), findsNWidgets(2));

    // Make sure the monster has not been initialised
    goal = (find.byType(MazePositionIndicator)).evaluate().first.widget as MazePositionIndicator;
    expect(goal.color, Colors.purple);

    // Make sure the player has been initialised with the goal
    MazePositionIndicator player = (find.byType(MazePositionIndicator)).evaluate().last.widget as MazePositionIndicator;
    expect(player.color, Colors.amber);
  });
}
