import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _inputTextFocus = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _inputTextFocus.dispose();
  }

  void chooseLanguage(String key) {
    if (key == "vietnamese") {
      setState(() {
        _isSelectVietnamese = true;
      });
    } else {
      setState(() {
        _isSelectVietnamese = false;
      });
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
          children: [
            selectLanguageTranslation(),
            Divider(
              height: 2,
              color: Colors.black.withOpacity(0.5),
            ),
            inputTextCustom(size)
          ],
        ),
      ),
    );
  }

  Padding selectLanguageTranslation() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
              flex: 1,
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: _isSelectVietnamese == true
                          ? MaterialStateProperty.all<Color>(Colors.green)
                          : MaterialStateProperty.all<Color>(
                              Colors.black.withOpacity(0.5))),
                  onPressed: () {
                    chooseLanguage("vietnamese");
                  },
                  child: const Text("Vietnamese"))),
          Flexible(
              flex: 1,
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: _isSelectVietnamese == false
                          ? MaterialStateProperty.all<Color>(Colors.green)
                          : MaterialStateProperty.all<Color>(
                              Colors.black.withOpacity(0.5))),
                  onPressed: () {
                    chooseLanguage("japanese");
                  },
                  child: const Text("Japanese")))
        ],
      ),
    );
  }

  Padding inputTextCustom(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: size.width * 0.75,
            child: _isSelectVietnamese
                ? TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    autofocus: false,
                    focusNode: _inputTextFocus,
                    style: const TextStyle(fontSize: 20),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Nhấn để nhập văn bản ",
                    ),
                  )
                : TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    autofocus: false,
                    focusNode: _inputTextFocus,
                    style: const TextStyle(fontSize: 20),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "タップしてテキストを入力",
                    ),
                  ),
          ),
          _inputTextFocus.hasFocus == true
              ? IconButton(
                  onPressed: () {
                    _inputTextFocus.unfocus();
                  },
                  icon: const Icon(
                    Icons.close_rounded,
                    size: 28,
                  ))
              : IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.mic,
                    size: 28,
                  )),
        ],
      ),
    );
  }
}
