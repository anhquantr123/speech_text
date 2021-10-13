import 'package:flutter/material.dart';
import 'package:speech_text/constants/style_default.dart';

Card viewHistoryTranslation() {
  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "History",
          style: TextStyle(fontSize: textSizeHeading2),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            historyHeadingTitleCustom("VI/JP"),
            const VerticalDivider(
              thickness: 1,
              width: 2,
            ),
            historyHeadingTitleCustom("Translation"),
          ],
        )
      ],
    ),
  );
}

Expanded historyHeadingTitleCustom(String text) {
  return Expanded(
      flex: 5,
      child: Container(
        color: colorTitle,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Text(
            text,
            style:
                const TextStyle(fontSize: textSizeBody2, color: Colors.white),
          ),
        ),
      ));
}
