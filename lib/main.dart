import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translator/translator.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: ThemeData(backgroundColor: Colors.blueAccent[200]),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SpeechToText speechToText = SpeechToText();
  var isListening = false;
  TextEditingController textController =
      TextEditingController(text: "How are you?");
  List<String> languages = [
    'English',
    'Thai',
    'Hindi',
    'Japanese',
    "Chinese",
    "French",
    "German",
  ];
  List<String> languagescode = [
    'en',
    'th',
    'hi',
    'ja',
    'zh-CN',
    'fr',
    'de',
  ];
  final translator = GoogleTranslator();

  String from = 'en';
  String to = 'th';
  String data = 'สวัสดีคุณเป็นอย่างไรบ้าง';
  String selectedvalue = 'English';
  String selectedvalue2 = 'Thai';
  final formkey = GlobalKey<FormState>();
  // bool isloading = false;

  translate() async {
    await translator
        .translate(textController.text, from: from, to: to)
        .then((value) {
      data = value.text;
      setState(() {});
      // print(value);

      // return value;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    textController.dispose();
  }

  speak(selvalue, text) async {
    await FlutterTts().setLanguage(selvalue);
    await FlutterTts().setPitch(1);
    await FlutterTts().setVolume(1);
    await FlutterTts().setSpeechRate(.4);
    await FlutterTts().speak(text);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    translate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[300],
      appBar: AppBar(
        centerTitle: true,
        title: Text("Translator App"),
        elevation: 0,
        backgroundColor: Colors.purple[800],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("From"),
                        DropdownButton(
                          value: selectedvalue,
                          items: languages.map((lang) {
                            return DropdownMenuItem(
                              child: Text(lang),
                              value: lang,
                              onTap: () {
                                if (lang == languages[0]) {
                                  from = languagescode[0];
                                } else if (lang == languages[1]) {
                                  from = languagescode[1];
                                } else if (lang == languages[2]) {
                                  from = languagescode[2];
                                } else if (lang == languages[3]) {
                                  from = languagescode[3];
                                } else if (lang == languages[4]) {
                                  from = languagescode[4];
                                } else if (lang == languages[5]) {
                                  from = languagescode[5];
                                } else if (lang == languages[6]) {
                                  from = languagescode[6];
                                }
                                setState(() {
                                  // print(lang);
                                  // print(from);
                                });
                              },
                            );
                          }).toList(),
                          onChanged: (value) {
                            selectedvalue = value!;
                          },
                        ),
                      ]),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: textController,
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 18),
                        maxLines: null,
                        minLines: null,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () {
                                if (textController.text.isNotEmpty) {
                                  speak(selectedvalue, textController.text);
                                }
                              },
                              icon: Icon(Icons.volume_up)),
                          GestureDetector(
                            onTapDown: (details) async {
                              if (!isListening) {
                                var available = await speechToText.initialize();
                                if (available) {
                                  setState(() {
                                    textController.text = "";
                                    isListening = true;
                                    speechToText.listen(
                                      onResult: (result) {
                                        setState(() {
                                          textController.text =
                                              result.recognizedWords;
                                        });
                                      },
                                    );
                                  });
                                }
                              }
                            },
                            onTapUp: (details) {
                              setState(() {
                                isListening = false;
                              });
                              speechToText.stop();
                            },
                            child:
                                Icon(isListening ? Icons.mic : Icons.mic_none),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("To"),
                        DropdownButton(
                          value: selectedvalue2,
                          items: languages.map((lang) {
                            return DropdownMenuItem(
                              child: Text(lang),
                              value: lang,
                              onTap: () {
                                if (lang == languages[0]) {
                                  to = languagescode[0];
                                } else if (lang == languages[1]) {
                                  to = languagescode[1];
                                } else if (lang == languages[2]) {
                                  to = languagescode[2];
                                } else if (lang == languages[3]) {
                                  to = languagescode[3];
                                } else if (lang == languages[4]) {
                                  to = languagescode[4];
                                } else if (lang == languages[5]) {
                                  to = languagescode[5];
                                } else if (lang == languages[6]) {
                                  to = languagescode[6];
                                }
                                setState(() {
                                  // print(lang);
                                  // print(from);
                                });
                              },
                            );
                          }).toList(),
                          onChanged: (value) {
                            selectedvalue2 = value!;
                          },
                        ),
                      ]),
                ),
                Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        Center(
                          child: SelectableText(
                            data,
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                onPressed: () {
                                  if (data.isNotEmpty) {
                                    speak(selectedvalue2, data);
                                  }
                                },
                                icon: Icon(Icons.volume_up)),
                          ],
                        )
                      ],
                    )),
                ElevatedButton(
                    onPressed: translate,
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.purple[700])),
                    child: Text("Translate"))
              ]),
        ),
      ),
    );
  }
}
