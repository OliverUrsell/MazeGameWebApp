import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_glow/flutter_glow.dart';
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

  void connectWithCode(){
    if(codeStart != 4) {
      return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Game(code: controller.text);
    }));
  }

  TextEditingController controller = TextEditingController(
    text: "----",
  );

  InputBorder textBorder = const OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.black,
      width: 1.0,
    ),
  );

  InputBorder focusedTextBorder = const OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.black,
      width: 3.0,
    ),
  );

  TextStyle redGameNameStyle = GoogleFonts.limelight(
    textStyle: const TextStyle(
        color: Color.fromRGBO(230, 194, 50, 1),
    ),
  );

  TextStyle goldGameNameStyle = GoogleFonts.limelight(
    textStyle: const TextStyle(
        color: Color.fromRGBO(118, 4, 10, 1),
    ),
  );

  int codeStart = 0;

  @override
  Widget build(BuildContext context) {
    // The position the code ends and the hyphens start
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: codeStart==4 ? Colors.black : const Color.fromRGBO(50, 73, 80, 1.0),
      // backgroundColor: const Color.fromRGBO(13, 16, 74, 1.0),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: screenSize.width,
                padding: EdgeInsets.fromLTRB(0, 1/10*screenSize.height, 0, 0),
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: GlowText(
                      "The Falcon's Nest Hotel",
                      style: codeStart==4 ? goldGameNameStyle : redGameNameStyle,
                      offset: const Offset(0, 0.5),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 1/10*screenSize.height, 0, 0),
                child: const Text(
                  "Enter Code:",
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 32
                  ),
                ),
              ),
              Container(
                width: 48*4 + 20*2,
                padding: const EdgeInsets.symmetric(vertical: 30.0),
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
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: textBorder,
                    focusedBorder: focusedTextBorder,
                    helperText: "Get this from the VR player",
                    helperStyle: GoogleFonts.azeretMono(
                      textStyle: const TextStyle(
                        wordSpacing: -5,
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  autocorrect: false,
                  onChanged: (text) {
                    // text in this case is just the number that has been
                    // entered (e.g. "1", "12", "1234")
                    // The value of this parameter never contains any _ characters
                    controller.text = text;
                    for(int i=0; i < 4 - text.length; i++){
                      controller.text += "-";
                    }
                    controller.selection = TextSelection.fromPosition(TextPosition(offset: text.length));
                    setState(() {
                      codeStart = text.length;
                    });
                  },
                  onTap: () {
                    controller.selection = TextSelection.fromPosition(TextPosition(offset: codeStart));
                  },
                  onSubmitted: (text) => connectWithCode(),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 1/10*screenSize.height, 0, 0),
                child: TextButton(
                  onPressed: connectWithCode,
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: codeStart==4? const BorderSide(color: Colors.red):const BorderSide(color: Colors.black)
                        )
                    )
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Connect",
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 32
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
