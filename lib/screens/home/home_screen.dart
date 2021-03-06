// ignore_for_file: unused_local_variable, avoid_print

import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_text/model/history_data.dart';
import 'package:speech_text/screens/home/widget/button_play_sound.dart';
import 'package:speech_text/screens/home/widget/history_translation.dart';
import 'package:speech_text/screens/home/widget/input_text_custom.dart';
import 'package:speech_text/screens/home/widget/select_language_translation.dart';
import 'package:speech_text/screens/home/widget/view_translate_result.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translator/translator.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  // ignore: unused_field
  late bool _speechEnabled = false;
  late String _resultText = '';
  late TextEditingController _editingController;
  // ignore: prefer_final_fields
  late bool _finishInputText = true,
      _showButtonPlaySound = false,
      _showHistory = false;
  late final FlutterTts flutterTts;
  late String _reesultTranslateText = "";
  late SharedPreferences _sharedPreferences;
  // ignore: prefer_final_fields
  late List _listHistory = [];

  @override
  void initState() {
    super.initState();
    _initSpeech();
    //_initSharedPreferences();
    _inputTextFocus = FocusNode();
    _editingController = TextEditingController();
    flutterTts = FlutterTts();
  }

  _initSharedPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    //await _sharedPreferences.remove("_historyData_");
    try {
      var _getData = _sharedPreferences.getString("_historyData_").toString();
      if (_getData.isNotEmpty) {
        setState(() {
          _showHistory = true;
        });
        return 1;
      }
    } catch (e) {
      print(e);
    }
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
        localeId: _isSelectVietnamese == true ? "vi-VN" : "ja-JP");
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
        _editingController.text = result.recognizedWords.toString();
        if (_resultText.isNotEmpty) {
          _showButtonPlaySound = true;
        }
      });
      if (result.recognizedWords.toString().isNotEmpty) {
        translatorResult();
      }
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
    setState(() {
      _showButtonPlaySound = false;
      _editingController.text = "";
    });
    if (_speechToText.isNotListening) {
      _editingController.text = "";
      _startListening();
    } else {
      _stopListening();
    }
  }

  void _onTapFinishInputText() {
    if (_editingController.text.isEmpty) {
      showSnackBar("B???n ch??a nh???p d??? li???u");
    } else {
      setState(() {
        _showButtonPlaySound = true;
        _resultText = _editingController.text.toString().trim();
      });
      translatorResult();
      _inputTextFocus.unfocus();
      _saveDataHistoryTranslate();
    }
    // save data
    _saveDataHistoryTranslate();
  }

  Future _saveDataHistoryTranslate() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    var _history = History(_resultText, _reesultTranslateText);
    var _getData = _sharedPreferences.getString("_historyData_").toString();

    // ignore: unnecessary_null_comparison
    if (_getData != "null") {
      if (_getData.isNotEmpty) {
        _listHistory = [];
        var _temp = json.decode(_getData.toString());
        for (var i = 0; i < _temp.length; i++) {
          // ignore: unnecessary_new
          _listHistory.add(json
              // ignore: unnecessary_new
              .encode(new History(
                  _temp[i]['input'].toString(), _temp[i]['result'].toString()))
              .toString());
        }
        _listHistory.add(json.encode(_history).toString());
        // print(json.encode(_history).toString());
        await _sharedPreferences.setString(
            "_historyData_", _listHistory.toString());
        setState(() {
          _showHistory = true;
        });
      }
    } else {
      print("hello " + json.encode(_history).toString());
      _listHistory.add(json.encode(_history).toString());
      await _sharedPreferences.setString(
          "_historyData_", _listHistory.toString());
      setState(() {
        _showHistory = true;
      });
    }
  }

  Future translatorResult() async {
    final translator = GoogleTranslator();
    try {
      if (_isSelectVietnamese == true) {
        var translation = await translator.translate(
            _editingController.text.toString().trim(),
            from: "vi",
            to: "ja");
        setState(() {
          _reesultTranslateText = translation.toString();
        });
      } else {
        var translation = await translator.translate(
            _editingController.text.toString().trim(),
            from: "ja",
            to: "vi");
        setState(() {
          _reesultTranslateText = translation.toString();
        });
      }
    } catch (e) {
      _stopListening();
    }

    _saveDataHistoryTranslate();
  }

  // play sound
  // ignore: unused_element
  void _playTextSoundInput() async {
    try {
      if (_isSelectVietnamese) {
        await flutterTts.setLanguage("vi-vn");
        await flutterTts.setPitch(1);
        await flutterTts.speak(_resultText);
      } else {
        await flutterTts.setLanguage("ja-jp");
        await flutterTts.setPitch(1);
        await flutterTts.speak(_resultText);
      }
    } catch (e) {
      showSnackBar("L???i kh??ng mong mu???n");
    }
  }

  // ignore: unused_element
  void _playTextSoundTranslate() async {
    try {
      if (_isSelectVietnamese == false) {
        await flutterTts.setLanguage("vi-vn");
        await flutterTts.setPitch(1);
        await flutterTts.speak(_reesultTranslateText);
      } else {
        await flutterTts.setLanguage("ja-jp");
        await flutterTts.setPitch(1);
        await flutterTts.speak(_reesultTranslateText);
      }
    } catch (e) {
      showSnackBar("L???i kh??ng mong mu???n");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
              buttonPlaySound("", _showButtonPlaySound, _playTextSoundInput),
            inputTextCustom(
                size,
                _isSelectVietnamese,
                _editingController,
                _inputTextFocus,
                _onTapClose,
                _onTapMic,
                _finishInputText,
                _onTapFinishInputText,
                _speechToText),
            const SizedBox(
              height: 30,
            ),
            if (_inputTextFocus.hasFocus == false &&
                _editingController.text.isNotEmpty)
              Divider(
                height: 2,
                thickness: 5,
                color: Colors.black.withOpacity(0.2),
              ),
            if (_inputTextFocus.hasFocus == false &&
                _editingController.text.isNotEmpty)
              viewTranslateResult(_isSelectVietnamese, size,
                  _reesultTranslateText, _playTextSoundTranslate),
            Divider(
              height: 2,
              thickness: 5,
              color: Colors.black.withOpacity(0.2),
            ),
            FutureBuilder(
                future: _initSharedPreferences(),
                builder: (context, snap) {
                  if (snap.hasData) {
                    return viewHistoryTranslation(_sharedPreferences);
                  }
                  return const SizedBox(
                    height: 50,
                  );
                }),
            //if (_showHistory) viewHistoryTranslation(_sharedPreferences)
          ],
        ),
      ),
    );
  }
}
