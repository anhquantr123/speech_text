import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_text/constants/style_default.dart';
import 'package:speech_text/model/history_data.dart';

Card viewHistoryTranslation(SharedPreferences sharedPreferences) {
  var test = sharedPreferences.get("_historyData_");
  var data = json.decode(test.toString());

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
        if (data != null)
          SizedBox(
            height: 350,
            child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      _removeItemHistory(data, index, sharedPreferences);
                    },
                    background: deleteBgItem(),
                    child: Column(
                      children: [
                        const Divider(
                          height: 2,
                          color: Colors.white,
                        ),
                        if (data.length > 1)
                          Container(
                            color: (index % 2 == 0)
                                ? const Color(0xFFD2DEEF)
                                : const Color(0xFFEAEFF7),
                            child: Row(
                              children: [
                                itemHistory(
                                    data[data.length - 1 - index]["input"]
                                        .toString(),
                                    16.0,
                                    8),
                                const VerticalDivider(
                                  thickness: 1,
                                  width: 2,
                                ),
                                itemHistory(
                                    data[data.length - 1 - index]["result"]
                                        .toString(),
                                    16.0,
                                    6)
                              ],
                            ),
                          ),
                      ],
                    ),
                  );
                }),
          )
      ],
    ),
  );
}

void _removeItemHistory(data, index, _sharedPreferences) async {
  // ignore: avoid_print
  try {
    data.removeAt(data.length - 1 - index);
    var _listHistory = [];
    // var _temp = json.decode(data.toString());
    for (var i = 0; i < data.length; i++) {
      // ignore: unnecessary_new
      _listHistory.add(json
          // ignore: unnecessary_new
          .encode(new History(
              data[i]['input'].toString(), data[i]['result'].toString()))
          .toString());
    }
    await _sharedPreferences.setString(
        "_historyData_", _listHistory.toString());
    // ignore: avoid_print
    print(data.toString());
    // ignore: empty_catches
  } catch (e) {}
}

Widget deleteBgItem() {
  return Container(
    alignment: Alignment.centerRight,
    padding: const EdgeInsets.only(right: 20),
    color: Colors.red,
    child: const Icon(
      Icons.delete_rounded,
      color: Colors.white,
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
            style: const TextStyle(
                fontSize: textSizeBody2,
                color: Colors.white,
                fontWeight: fontWeight),
          ),
        ),
      ));
}

Expanded itemHistory(String text, double fontSize, double padd) {
  return Expanded(
    flex: 5,
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: padd, horizontal: 5),
      child: Text(text,
          style: TextStyle(
            fontSize: fontSize,
            color: Colors.black,
          )),
    ),
  );
}
