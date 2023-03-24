
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class TestModeMazeSocket{
  Stream stream;
  void Function(String) receiveFunction;

  TestModeMazeSocket({
    required this.stream,
    required this.receiveFunction,
  });

}

class MazeSocket {

  // There should only ever be one maze connection, so we can use a monomer pattern
  static MazeSocket? _instance;
  final String _uri = "ws://localhost:25567";
  TestModeMazeSocket? _testMode;

  factory MazeSocket(){
    if(_instance == null){
      MazeSocket socket = MazeSocket._();
      _instance = socket;
    }
    return _instance!;
  }

  late WebSocketChannel _channel;

  MazeSocket._() {
    _channel = WebSocketChannel.connect(
      Uri.parse(_uri),
    );
  }

  @visibleForTesting
  void activateTestMode(TestModeMazeSocket testMode){
    _testMode = testMode;
  }

  void sendMessage(String message){
    if (kDebugMode) {
      print("Sending message $message");
    }

    if(_testMode != null){
      _testMode!.receiveFunction(message);
      return;
    }

    _channel.sink.add("$message\n");
  }

  Stream getStream(){
    if(_testMode != null){
      return _testMode!.stream;
    }

    return _channel.stream;
  }

  void close(){
    _channel.sink.close();
  }

}
