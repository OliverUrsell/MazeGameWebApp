import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

    String rawData = snapshot.data! as String;
    if (kDebugMode) {
      print("Received message: $rawData");
    }

    if(rawData.startsWith("MAZE ")) {rawMazeJSON = rawData.replaceFirst("MAZE ", ""); return;}
    if(rawData.startsWith("Positions ")) {rawPositionsJson = rawData.replaceFirst("Positions ", ""); return;}
  }

  @override
  Widget build(BuildContext context) {

    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black45,
      body: StreamBuilder(
        stream: MazeSocket().getStream(),
        builder: (context, snapshot) {
          handleStreamSnapshot(snapshot);

          if(rawMazeJSON == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Waiting for the VR player to start the game",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.azeretMono(
                    textStyle: const TextStyle(
                      fontSize: 48,
                    ),
                  ),
                ),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.fromLTRB(0, 16.0, 0, 0),
            child: Align(
              alignment: Alignment.center,
              child: Maze(
                rawJSON: rawMazeJSON!,
                mazeCode: widget.code,
                rawPositionsJSON: rawPositionsJson,
                height: screenSize.height*0.8,
                width: screenSize.width*0.8,
              ),
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
