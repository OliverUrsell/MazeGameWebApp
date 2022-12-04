
import 'dart:async';
import 'dart:io';

import 'package:web_socket_channel/web_socket_channel.dart';

class MazeSocket {

  // There should only ever be one maze connection, so we can use a monomer pattern
  static MazeSocket? _instance;
  final String _uri = "ws://localhost:25567";

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

  void sendMessage(String message){
    print("Sending message $message");
    _channel.sink.add("$message\n");
  }

  Stream getStream(){
    BytesBuilder();
    return _channel.stream;
  }

  void close(){
    _channel.sink.close();
  }

}
