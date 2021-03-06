import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:speech_text/screens/home/home_screen.dart';
import 'package:speech_text/screens/splashScreen/splash_screen.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translator/translator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final SpeechToText _speechToText = SpeechToText();
  late bool _speechEnabled = false;
  late String _lastWords = '';
  late String _resultText = '';
  late bool _tiengViet = true;
  late String _reesultTranslateText = "";

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    // ja_JP
    await _speechToText.listen(
        onResult: _onSpeechResult,
        localeId: _tiengViet == true ? "vi_VN" : "ja_JP");
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    try {
      setState(() {
        _lastWords = result.recognizedWords;
        _resultText = result.recognizedWords.toString();
      });
      if (_resultText.isNotEmpty) {
        translatorResult();
      }
    } catch (e) {
      // ignore: avoid_print
      print("Loi ");
    }
  }

  void translatorResult() async {
    try {
      final translator = GoogleTranslator();
      if (_tiengViet == true) {
        var translation =
            await translator.translate(_resultText, from: "vi", to: 'ja');
        setState(() {
          _reesultTranslateText = translation.toString();
        });
      } else {
        var translation =
            await translator.translate(_resultText, from: "ja", to: 'vi');
        setState(() {
          _reesultTranslateText = translation.toString();
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: _tiengViet == true
                                ? MaterialStateProperty.all<Color>(Colors.green)
                                : MaterialStateProperty.all<Color>(
                                    Colors.black.withOpacity(0.5))),
                        onPressed: () {
                          setState(() {
                            _tiengViet = true;
                          });
                        },
                        child: Text("Ti???ng Vi???t"),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: _tiengViet == false
                                ? MaterialStateProperty.all<Color>(Colors.green)
                                : MaterialStateProperty.all<Color>(
                                    Colors.black.withOpacity(0.5))),
                        onPressed: () {
                          setState(() {
                            _tiengViet = false;
                          });
                        },
                        child: Text("Ti???ng nh???t"),
                      )
                    ],
                  ),
                ),
                Container(
                    padding: EdgeInsets.all(16),
                    child: _tiengViet == true
                        ? const Text(
                            '??ang nh???n d???ng ti???ng vi???t',
                            style: TextStyle(fontSize: 20.0),
                          )
                        : const Text(
                            '??ang nh???n d???ng ti???ng nh???t',
                            style: TextStyle(fontSize: 20.0),
                          )),
                SizedBox(
                    height: 30,
                    child: Text(_resultText,
                        style: const TextStyle(fontSize: 20))),
                SizedBox(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      // If listening is active show the recognized words
                      _speechToText.isListening
                          ? '$_lastWords'
                          : _speechEnabled
                              ? 'Tap the microphone to start listening...'
                              : 'Speech not available',
                    ),
                  ),
                ),
                const Text("Auto Translating....",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const Text(
                  "???ng d???ng h??? tr??? d???ch t??? ti???ng vi???t sang ti???ng nh???t v?? ng?????c l???i",
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(_reesultTranslateText,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            // If not yet listening for speech start, otherwise stop
            _speechToText.isNotListening ? _startListening : _stopListening,
        tooltip: 'Listen',
        child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
      ),
    );
  }
}
