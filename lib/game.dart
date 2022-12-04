import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maze_game_web_app/maze_socket.dart';

class Game extends StatefulWidget {

  final String code;

  const Game({Key? key, required this.code}) : super(key: key);

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: StreamBuilder(
          stream: MazeSocket().getStream(),
          builder: (context, snapshot) {
            print(snapshot.hasData ? '${snapshot.data}' : 'no data');
            return Text(snapshot.hasData ? '${snapshot.data}' : 'no data');
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    MazeSocket().sendMessage("${widget.code} JoinGame");
    MazeSocket().sendMessage("Hello From Web App");
  }
}
