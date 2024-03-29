import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:maze_game_web_app/maze_position_indicator.dart';

import 'arrow_controls.dart';
import 'sliver_grid_delegate_with_fixed_cross_axis_count_and_fixed_height.dart';
import 'maze_socket.dart';

enum PlayerType{
  monsterController,
  mazeGuide
}

class Maze extends StatefulWidget {

  final String rawJSON;
  final double height;
  final double width;
  final String? rawPositionsJSON;
  final String mazeCode;
  final double monsterSmellDistance;

  const Maze({
    Key? key,
    required this.mazeCode,
    required this.rawJSON,
    required this.height,
    required this.width,
    this.rawPositionsJSON,
    this.monsterSmellDistance=5,
  }) : super(key: key);

  @override
  State<Maze> createState() => _MazeState();

  static String getImageNameForExits(bool north, east, south, west) {

    int numWalls = north?1:0;
    numWalls += east?1:0;
    numWalls += south?1:0;
    numWalls += west?1:0;

    switch (numWalls)
    {
      case 0:
        return "NoWall.png";
      case 1:
        return "1Wall.png";
      case 2:
        if((north & south) || (east & west)){
          return "2WallsColumn.png";
        }
        return "2WallsCorner.png";
      case 3:
        return "3Walls.png";
      case 4:
        return "4Walls.png";
      default:
        throw Exception("There shouldn't be less than 0 or more than 4 walls");
    }
  }

  static int getQuarterTurnsForExits(bool north, east, south, west)
  {
    if (
    (!north & !east & !south & !west) || // No Edges
        (north & east & south & west) || // All Edges
        (north & east & !south & west) || // South Exit Only
        (!north & east & !south & west) || // North and South Exit
        (north & east & !south & !west) || // South and West Exit
        (!north & east & !south & !west) // East Wall Only
    )
    {
      return 0;
    }

    if(
    (north & east & south & !west) || // West Exit Only
        (north & !east & south & !west) || // East and West Exit
        (!north & east & south & !west) || // North and West Exit
        (!north & !east & south & !west) // South Wall Only
    )
    {

      return 1;
    }

    if(
    (!north & east & south & west) || // North Exit Only
        (!north & !east & south & west) || // North and East Exit
        (!north & !east & !south & west) // West Wall Only
    )
    {
      return 2;
    }

    if(
    (north & !east & south & west) || // East Exit Only
        (north & !east & !south & west) || // East and South Exit
        (north & !east & !south & !west) // North Wall Only
    )
    {
      return 3;
    }

    throw Exception("No rotation was returned for a set of exit booleans N, S, E, W: $north, $south, $east, $west");

  }

}

class Tuple<T, U>{
  final T x;
  final U y;

  Tuple(this.x, this.y);
}

class _MazeState extends State<Maze> {

  late List<List<MazeNode>> nodes;
  late int mazeWidth;
  late int mazeDepth;
  late Tuple<double, double> goalPosition;
  late PlayerType _playerType;
  late bool showMonster, showPlayer, showGoal;
  late double mazeNodesTotalHeight = _playerType==PlayerType.monsterController?widget.height*0.8:widget.height;
  late double positionIndicatorRadii;
  late double nodeSize;

  set playerType(PlayerType pt){
    _playerType = pt;
    if(_playerType == PlayerType.mazeGuide){
      showMonster = false;
      showPlayer = true;
      showGoal = true;
    }else{
      showMonster = true;
      showPlayer = false;
      showGoal = false;
    }
  }

  PlayerType get playerType{
    return _playerType;
  }

  Tuple<double, double> convertMazePositionToLeftBottomPosition(Tuple<double,double> playerPosition){
    return Tuple(
        (playerPosition.x+0.5)*nodeSize-positionIndicatorRadii,
        (playerPosition.y+0.5)*nodeSize-positionIndicatorRadii
    );
  }

  Tuple<double, double> getPlayerMazePosition(String rawPositionsJSON){
    // Json we are decoding should look something like this:
    // {"player_x":0, "player_y":0, "monster_x":0, "monster_y":0}
    Map<String, dynamic> data = jsonDecode(rawPositionsJSON);
    // Add .0 to convert to double if necessary, avoids a bug in testing where the values are integers
    double x = data["player_x"] + .0;
    double y = data["player_y"] + .0;
    return Tuple(x, y);
  }

  Tuple<double, double> getMonsterMazePosition(String rawPositionsJSON){
    // Json we are decoding should look something like this:
    // {"player_x":0, "player_y":0, "monster_x":0, "monster_y":0}
    Map<String, dynamic> data = jsonDecode(rawPositionsJSON);

    // Add .0 to convert to double if necessary, avoids a bug in testing where the values are integers
    double x = data["monster_x"] + .0;
    double y = data["monster_y"] + .0;
    return Tuple(x, y);
  }

  @override
  Widget build(BuildContext context) {

    Map<String, dynamic> data = jsonDecode(widget.rawJSON);

    mazeWidth = data["width"];
    mazeDepth = data["depth"];
    playerType = data["player_type"]=="guide"?PlayerType.mazeGuide : PlayerType.monsterController;

    List<List<MazeNode?>> initialNodes = List.generate(mazeDepth, (p) => List.filled(mazeWidth, null));

    nodeSize = min(mazeNodesTotalHeight/mazeDepth, widget.width / mazeWidth);
    positionIndicatorRadii = nodeSize*0.4;

    for (var nodeMap in data["nodes"]!) {
      initialNodes[nodeMap["x"]][nodeMap["y"]] = MazeNode(
          nodeSize, nodeSize,
          nodeMap["x"] as int, nodeMap["y"] as int, nodeMap["north"], nodeMap["east"], nodeMap["south"], nodeMap["west"]
      );
    }

    nodes = initialNodes.map((List<MazeNode?> row) => row.cast<MazeNode>()).toList();

    // Add .0 to convert to double if necessary, avoids a bug in testing where the values are integers
    goalPosition = Tuple(data["goal_x"] + .0, data["goal_y"] + .0);

    List<Widget> nodeWidgets = List.empty(growable: true);

    for (var row in nodes.reversed) {
      for (var m in row) {
        nodeWidgets.add(m.toWidget(context));
      }
    }

    Tuple<double,double> goalLeftBottomPosition = convertMazePositionToLeftBottomPosition(goalPosition);

    List<Widget> stackChildren = [
      SizedBox(
        width: nodeSize * mazeWidth,
        height: nodeSize * mazeDepth,
        child: GridView(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
            crossAxisCount: mazeWidth,
            height: nodeSize,
            width: nodeSize,
          ),
          children: nodeWidgets,
        ),
      ),
    ];

    if(showGoal) {
      stackChildren.add(
        MazePositionIndicator(
          left: goalLeftBottomPosition.y,
          bottom: goalLeftBottomPosition.x,
          color: Colors.purple,
          radius: positionIndicatorRadii,
        )
      );
    }

    if(widget.rawPositionsJSON != null) {
      if(showPlayer || showMonster) {
        Tuple<double,
            double> playerMazePosition = getPlayerMazePosition(
            widget.rawPositionsJSON!);

        bool monsterCloseEnough = false;

        if(showMonster){
          Tuple<double,
              double> monsterLeftBottomPosition = getMonsterMazePosition(
              widget.rawPositionsJSON!);

          num squaredDistance = pow(playerMazePosition.x - monsterLeftBottomPosition.x, 2) + pow(playerMazePosition.y - monsterLeftBottomPosition.y, 2);
          monsterCloseEnough = squaredDistance <= pow(widget.monsterSmellDistance, 2);
        }

        if(showPlayer || (showMonster && monsterCloseEnough)) {

          Tuple<double, double> playerLeftBottomPosition = convertMazePositionToLeftBottomPosition(playerMazePosition);

          stackChildren.add(
              MazePositionIndicator(
                left: playerLeftBottomPosition.y,
                bottom: playerLeftBottomPosition.x,
                color: Colors.amber,
                radius: positionIndicatorRadii,
              )
          );
        }
      }

      if(showMonster) {
        Tuple<double,
            double> monsterLeftBottomPosition = convertMazePositionToLeftBottomPosition(getMonsterMazePosition(
            widget.rawPositionsJSON!));
        stackChildren.add(
            MazePositionIndicator(
              left: monsterLeftBottomPosition.y,
              bottom: monsterLeftBottomPosition.x,
              color: Colors.red,
              radius: positionIndicatorRadii,
            )
        );
      }

    }

    return _playerType==PlayerType.monsterController ? Column(
      children: [
        Stack(
          children: stackChildren,
        ),
        //TODO: Make a "SendMonsterDirectionChange" function in MazeSocket
        ArrowControls(height: widget.height - mazeNodesTotalHeight,
          north: () => MazeSocket().sendMessage("${widget.mazeCode} MonsterDirection north"),
          east: () => MazeSocket().sendMessage("${widget.mazeCode} MonsterDirection east"),
          south: () => MazeSocket().sendMessage("${widget.mazeCode} MonsterDirection south"),
          west: () => MazeSocket().sendMessage("${widget.mazeCode} MonsterDirection west"),
        ),
      ]
    )
        :
    Column(
        children: [
          Stack(
            children: stackChildren,
          ),
        ]
    );
  }
}

class MazeNode {

  late final double height, width;
  late final int X, Y;
  late final bool north, east, south, west;

  MazeNode(this.height, this.width, this.X, this.Y, this.north, this.east, this.south, this.west);

  Widget toWidget(BuildContext context){
    return RotatedBox(
      quarterTurns: Maze.getQuarterTurnsForExits(north, east, south, west),
      child: Image(
        fit: BoxFit.fill,
        image: AssetImage(
          Maze.getImageNameForExits(north, east, south, west),
        ),
      ),
    );
  }

  MazeNode.fromMap(Map<String,dynamic> map){
    X = map["x"];
    Y = map["y"];
    north = map["north"];
    east = map["east"];
    south = map["south"];
    west = map["west"];
  }

}
