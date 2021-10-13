import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_text/constants/style_default.dart';
import 'package:speech_to_text/speech_to_text.dart';

Padding inputTextCustom(
    Size size,
    bool _isSelectVietnamese,
    TextEditingController _editingController,
    FocusNode _inputTextFocus,
    Function()? _onTapClose,
    Function()? _onTapMic,
    bool _finishInputText,
    Function()? _onTapFinishInputText,
    SpeechToText _speechToText) {
  return Padding(
    padding: const EdgeInsets.only(left: 10, top: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: size.width * 0.74,
          child: _isSelectVietnamese
              ? TextField(
                  controller: _editingController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  autofocus: false,
                  focusNode: _inputTextFocus,
                  style: const TextStyle(fontSize: inputTextSize),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Nhấn để nhập văn bản ",
                  ),
                )
              : TextField(
                  controller: _editingController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  autofocus: false,
                  focusNode: _inputTextFocus,
                  style: const TextStyle(fontSize: inputTextSize),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "タップしてテキストを入力",
                  ),
                ),
        ),
        SizedBox(
          child: Row(
            children: [
              _inputTextFocus.hasFocus == true
                  ? InkWell(
                      onTap: _onTapClose,
                      child: const Icon(
                        Icons.close_rounded,
                        size: 28,
                      ))
                  : InkWell(
                      onTap: _onTapMic,
                      child: AvatarGlow(
                        glowColor: Colors.red,
                        endRadius: 30,
                        duration: const Duration(milliseconds: 1000),
                        repeat: true,
                        //showTwoGlows: true,
                        animate: _speechToText.isListening,
                        repeatPauseDuration: const Duration(milliseconds: 1),
                        child: Icon(
                            _speechToText.isNotListening
                                ? Icons.mic
                                : Icons.mic,
                            color: _speechToText.isNotListening
                                ? Colors.black
                                : Colors.red),
                      )),
              const SizedBox(
                width: 20,
              ),
              if (_inputTextFocus.hasFocus == true)
                Visibility(
                  visible: _finishInputText,
                  child: InkWell(
                      onTap: _onTapFinishInputText,
                      child: const Icon(Icons.send)),
                )
            ],
          ),
        )
      ],
    ),
  );
}
