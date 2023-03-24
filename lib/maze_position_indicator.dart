import 'package:flutter/material.dart';

class MazePositionIndicator extends StatefulWidget {

  final double left;
  final double bottom;
  final Color color;
  final double radius;

  const MazePositionIndicator({
    Key? key,
    required this.left,
    required this.bottom,
    required this.color,
    required this.radius
  }) : super(key: key);

  @override
  State<MazePositionIndicator> createState() => _MazePositionIndicatorState();
}

class _MazePositionIndicatorState extends State<MazePositionIndicator> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.left,
      bottom: widget.bottom,
      child: CircleAvatar(
        backgroundColor: widget.color,
        radius: widget.radius,
      ),
    );
  }
}
