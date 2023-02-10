import 'package:flutter/material.dart';

class ArrowControls extends StatelessWidget {

  final double height;

  final void Function()? north;
  final void Function()? east;
  final void Function()? south;
  final void Function()? west;

  const ArrowControls({Key? key, this.north, this.east, this.south, this.west, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_upward),
            onPressed: north,
            iconSize: height/3,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: west,
                iconSize: height/3,
              ),
              SizedBox(width: height/3,),
              IconButton(
                icon: const Icon(Icons.arrow_forward_sharp),
                onPressed: east,
                iconSize: height/3,
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.arrow_downward),
            onPressed: south,
            iconSize: height/3,
          ),
        ],
      ),
    );
  }
}
