import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight.dart';

class Maze extends StatefulWidget {

  final String rawJSON;
  final double height;

  const Maze({Key? key, required this.rawJSON, this.height=1000}) : super(key: key);

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
        // return OneExitBP;
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

class _MazeState extends State<Maze> {

  late List<List<MazeNode>> nodes;
  late final int mazeWidth;
  late final int mazeDepth;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> data = jsonDecode(widget.rawJSON);

    print(widget.rawJSON);

    mazeWidth = data["width"];
    mazeDepth = data["depth"];

    List<List<MazeNode?>> initialNodes = List.generate(mazeDepth, (p) => List.filled(mazeWidth, null));

    for (var nodeMap in data["nodes"]!) {
      print(nodeMap["x"]);
      print(nodeMap["y"]);
      print("");
      initialNodes[nodeMap["x"]][nodeMap["y"]] = MazeNode(
          widget.height/mazeDepth, widget.height/mazeDepth,
          nodeMap["x"] as int, nodeMap["y"] as int, nodeMap["north"], nodeMap["east"], nodeMap["south"], nodeMap["west"]
      );
    }

    print(initialNodes.map((e) => e.map((e) => e!.X)));

    // nodes = initialNodes.map((List<MazeNode?> row) => row.cast<MazeNode>()).toList();
    nodes = initialNodes.map((List<MazeNode?> row) => row.cast<MazeNode>()).toList();
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> nodeWidgets = List.empty(growable: true);

    for (var row in nodes.reversed) {
      for (var m in row) {
        nodeWidgets.add(m.toWidget(context));
      }
    }

    return SizedBox(
      width: widget.height/mazeDepth*mazeWidth,
      height: widget.height,
      child: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
          crossAxisCount: mazeWidth,
          height: widget.height/mazeDepth,
          width: widget.height/mazeDepth,
        ),
        children: nodeWidgets,
      ),
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
