// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<String?> convertPatternColorToString(
  String? inputPattern,
  String? inputColor,
) async {
  if (inputPattern == null || inputColor == null) {
    return null;
  }
  // Return string of selected pattern and color
  String returnString = inputPattern + inputColor;
  return returnString;

  // For example:
  // String inputPattern = "Solid";
  // String inputColor = "ff0000ff";  //i.e., hex for blue
  // String returnString = convertPatternColorToString(inputPattern, inputColor);
  // print(returnString); // Outputs: Solid#ff0000ff
}
