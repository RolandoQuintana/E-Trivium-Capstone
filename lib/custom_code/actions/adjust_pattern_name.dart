// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<String> adjustPatternName(String patternDropDownName) async {
  // Gets pattern name from pattern drop down selector, then converts the name into "Pattern#"
  // in order to send command message to the Arduino

  if (patternDropDownName == "Solid") {
    // Pattern 1
    return "Pattern1";
  } else if (patternDropDownName == "Flash") {
    // Pattern 2
    return "Pattern2";
  } else if (patternDropDownName == "Breathe") {
    // Pattern 3
    return "Pattern3";
  } else if (patternDropDownName == "Rain") {
    // Pattern 4
    return "Pattern4";
  } else if (patternDropDownName == "Posture") {
    // Pattern 5
    return "Pattern5";
  } else if (patternDropDownName == "Random") {
    // Pattern 6
    return "Pattern6";
  } else {
    return "";
  }
}
