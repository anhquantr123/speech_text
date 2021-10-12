import 'package:flutter/material.dart';

Padding selectLanguageTranslation(bool _isSelectVietnamese,
    Function()? chooseLanguage1, Function()? chooseLanguage2) {
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
                onPressed: chooseLanguage1,
                child: const Text("Vietnamese"))),
        Flexible(
            flex: 1,
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: _isSelectVietnamese == false
                        ? MaterialStateProperty.all<Color>(Colors.green)
                        : MaterialStateProperty.all<Color>(
                            Colors.black.withOpacity(0.5))),
                onPressed: chooseLanguage2,
                child: const Text("Japanese")))
      ],
    ),
  );
}
