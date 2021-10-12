import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_text/constants/style_default.dart';
import 'package:speech_text/screens/home/widget/button_play_sound.dart';
import 'package:speech_text/screens/home/widget/input_text_custom.dart';
import 'package:speech_text/screens/home/widget/select_language_translation.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ignore: unused_field
  late bool _isSelectVietnamese = true;
  late FocusNode _inputTextFocus;
  late final SpeechToText _speechToText = SpeechToText();
  late bool _speechEnabled = false;
  late String _resultText = '';
  late TextEditingController _editingController;
  late bool _finishInputText = true, _showButtonPlaySound = false;
  late FlutterTts flutterTts;

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _inputTextFocus = FocusNode();
    _editingController = TextEditingController(text: "Ban nhap cai gi day ");
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _inputTextFocus.dispose();
  }

  void chooseLanguage1() {
    setState(() {
      _isSelectVietnamese = true;
    });
  }

  void chooseLanguage2() {
    setState(() {
      _isSelectVietnamese = false;
    });
  }

  void showSnackBar(String text) {
    final snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  //
  void _startListening() async {
    // ja_JP
    await _speechToText.listen(
        onResult: _onSpeechResult,
        localeId: _isSelectVietnamese == true ? "vi_VN" : "ja_JP");
    setState(() {});
  }

  // ignore: unused_element
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    try {
      setState(() {
        _resultText = result.recognizedWords.toString();
        _editingController.text = _resultText.toString();
        if (_resultText.isNotEmpty) {
          _showButtonPlaySound = true;
        }
      });
    } catch (e) {
      // ignore: avoid_print
      print("Loi ");
    }
  }

  // ignore: unused_element
  void _onTapClose() {
    if (_editingController.text.isNotEmpty &&
        _inputTextFocus.hasFocus == true) {
      setState(() {
        _showButtonPlaySound = false;
      });
      _editingController.clear();
    } else {
      _inputTextFocus.unfocus();
      setState(() {
        _showButtonPlaySound = false;
      });
    }
  }

  void _onTapMic() {
    if (_speechToText.isNotListening) {
      _startListening();
    } else {
      _stopListening();
    }
  }

  void _onTapFinishInputText() {
    if (_editingController.text.isEmpty) {
      showSnackBar("Bạn chưa nhập dữ liệu");
    } else {
      setState(() {
        _showButtonPlaySound = true;
      });
      _inputTextFocus.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Translation"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            selectLanguageTranslation(
                _isSelectVietnamese, chooseLanguage1, chooseLanguage2),
            Divider(
              height: 2,
              color: Colors.black.withOpacity(0.5),
            ),
            if (_inputTextFocus.hasFocus == false)
              buttonPlaySound("", _showButtonPlaySound),
            inputTextCustom(
                size,
                _isSelectVietnamese,
                _editingController,
                _inputTextFocus,
                _onTapClose,
                _onTapMic,
                _finishInputText,
                _onTapFinishInputText)
          ],
        ),
      ),
    );
  }
}
