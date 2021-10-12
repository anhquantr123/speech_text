import 'package:flutter/material.dart';

Visibility buttonPlaySound(
    String text, bool _showButtonPlaySound, Function()? playTextSound) {
  return Visibility(
    visible: _showButtonPlaySound,
    child: Padding(
      padding: const EdgeInsets.only(left: 10, top: 10),
      child: SizedBox(
          height: 30,
          child: ElevatedButton.icon(
            onPressed: playTextSound,
            icon: const Icon(
              Icons.volume_up_rounded,
              size: 20,
            ),
            label: Text(text, style: const TextStyle(fontSize: 10)),
          )),
    ),
  );
}
