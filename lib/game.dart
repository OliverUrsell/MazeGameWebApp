import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maze_game_web_app/maze_socket.dart';

import 'maze.dart';

class Game extends StatefulWidget {

  final String code;

  const Game({Key? key, required this.code}) : super(key: key);

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {

  String? rawMazeJSON, rawPositionsJson;

  void handleStreamSnapshot(AsyncSnapshot snapshot){
    if(!snapshot.hasData) return;
    print(snapshot.data! as String);
    String rawData = snapshot.data! as String;

    if(rawData.startsWith("MAZE ")) {rawMazeJSON = rawData.replaceFirst("MAZE ", ""); return;}
    if(rawData.startsWith("Positions ")) {rawPositionsJson = rawData.replaceFirst("Positions ", ""); return;}
  }

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black45,
      body: StreamBuilder(
        stream: MazeSocket().getStream(),
        builder: (context, snapshot) {
          handleStreamSnapshot(snapshot);

          if(rawMazeJSON == null) return Container();

          return Align(
            alignment: Alignment.center,
            child: Maze(
              playerType: PlayerType.mazeGuide,
              rawJSON: rawMazeJSON!,
              rawPositionsJSON: rawPositionsJson,
              height: screenHeight*0.8,
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    MazeSocket().sendMessage("${widget.code} JoinGame");
  }
}
