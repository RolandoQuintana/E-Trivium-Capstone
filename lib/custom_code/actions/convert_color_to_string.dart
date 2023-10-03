// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';
import 'dart:math' as math;

Future<String?> convertColorToString(Color? inputColor) async {
  if (inputColor == null) {
    return null;
  }
  // Convert Color type to a String
  String colorString = inputColor.value.toRadixString(16).padLeft(8, '0');
  return colorString;

  // For example:
  // Color myColor = Colors.blue;
  // String colorString = convertColorToString(myColor);
  // print(colorString); // Outputs: ff0000ff
}
