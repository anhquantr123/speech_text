import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_text/constants/style_default.dart';

Card viewHistoryTranslation(SharedPreferences sharedPreferences) {
  var test = sharedPreferences.get("_historyData_");
  var data = json.decode(test.toString());

  // print(test.toString());
  // var data = [
  //   {"input": "anhquan", "result": "yeutrang"}
  // ];

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
            historyHeadingTitleCustom("VI/JP", colorTitle),
            const VerticalDivider(
              thickness: 1,
              width: 2,
            ),
            historyHeadingTitleCustom("Translation", colorTitle),
          ],
        ),
        if (data != null || data.length > 0)
          SizedBox(
            height: 370,
            child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      const Divider(
                        height: 2,
                        color: Colors.white,
                      ),
                      Row(
                        children: [
                          itemHistory(data[index]["input"].toString(),
                              colorTitle, 16.0, 7.5),
                          const VerticalDivider(
                            thickness: 1,
                            width: 2,
                          ),
                          itemHistory(data[index]["result"].toString(),
                              colorTitle, 16.0, 5)
                        ],
                      ),
                    ],
                  );
                }),
          )
      ],
    ),
  );
}

Expanded historyHeadingTitleCustom(String text, Color color) {
  return Expanded(
      flex: 5,
      child: Container(
        color: color,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          child: Text(
            text,
            style:
                const TextStyle(fontSize: textSizeBody2, color: Colors.white),
          ),
        ),
      ));
}

Expanded itemHistory(String text, Color color, double fontSize, double padd) {
  return Expanded(
      flex: 5,
      child: Container(
        color: color,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: padd, horizontal: 10),
          child: Text(
            text,
            style: TextStyle(fontSize: fontSize, color: Colors.white),
          ),
        ),
      ));
}
