import 'package:flutter/material.dart';
import 'package:speech_text/constants/style_default.dart';
import 'package:speech_text/screens/home/widget/button_play_sound.dart';

Card viewTranslateResult(bool _isSelectVietnamese, Size size, String text,
    Function()? playTextSound) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
    child: Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        const Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              "Translation",
              style:
                  TextStyle(fontSize: textSizeHeading1, fontWeight: fontWeight),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _isSelectVietnamese
                ? const Text(
                    "(Vietnamese",
                    style: TextStyle(fontSize: textSizeBody3),
                  )
                : const Text(
                    "(Japanese",
                    style: TextStyle(fontSize: textSizeBody3),
                  ),
            const Text(
              "---->",
              style: TextStyle(fontSize: textSizeBody3),
            ),
            _isSelectVietnamese
                ? const Text(
                    "Japanese)",
                    style: TextStyle(fontSize: textSizeBody3),
                  )
                : const Text(
                    "Vietnamese)",
                    style: TextStyle(fontSize: textSizeBody3),
                  ),
            SizedBox(
              width: size.width / 3,
            ),
          ],
        ),
        const SizedBox(
          height: 2,
        ),
        if (text.toString().isNotEmpty)
          Align(
              alignment: Alignment.topLeft,
              child: buttonPlaySound("", true, playTextSound)),
        const SizedBox(
          height: 15,
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Align(
                alignment: Alignment.topLeft,
                child: Text(text,
                    style: const TextStyle(
                      fontSize: textSizeBody1,
                    )))),
        const SizedBox(
          height: 20,
        )
      ],
    ),
  );
}
