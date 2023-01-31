import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maze_game_web_app/game.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maze game.dart',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {



  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController(
      text: "----",
    );

    const InputBorder textBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black,
        width: 1.0,
      ),
    );

    const InputBorder focusedTextBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black,
        width: 3.0,
      ),
    );

    // The position the code ends and the hyphens start
    int codeStart = 0;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(50, 73, 80, 1.0),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "Enter Code:",
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 32
                ),
              ),
              Container(
                width: 48*4 + 20*2,
                child: TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    // for below version 2 use this
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    // for version 2 and greater you can also use this
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  controller: controller,
                  showCursor: false,
                  style: GoogleFonts.azeretMono(
                    textStyle: const TextStyle(
                        fontFeatures: [
                          FontFeature.tabularFigures()
                        ],
                        fontSize: 48,
                        letterSpacing: 20,
                    ),
                  ),
                  decoration: const InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: textBorder,
                    focusedBorder: focusedTextBorder,
                  ),
                  onChanged: (text) {
                    // text in this case is just the number that has been
                    // entered (e.g. "1", "12", "1234")
                    // The value of this parameter never contains any _ characters
                    controller.text = text;
                    for(int i=0; i < 4 - text.length; i++){
                      controller.text += "-";
                    }
                    controller.selection = TextSelection.fromPosition(TextPosition(offset: text.length));
                    codeStart = text.length;
                  },
                  onTap: () {
                    controller.selection = TextSelection.fromPosition(TextPosition(offset: codeStart));
                  },
                ),
              ),
              TextButton(
                  onPressed: () {

                    if(codeStart != 4) {
                      return;
                    }

                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return Game(code: controller.text);
                    }));
                  },
                  child: const Text(
                      "Connect"
                  )
              )
            ],
          ),
        ],
      ),
    );
  }
}
