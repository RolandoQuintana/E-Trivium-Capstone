// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';

Future<String> convertBoolToString(bool inputBool) async {
  String boolString = inputBool.toString();
  String trueStr = "AAAAAAAAAAAAA";
  String falseStr = "ZZZZZZZZZZZZZ";

  if (boolString == "true") {
    return trueStr;
  } else {
    return falseStr;
  }

  // For example:
  // bool inputBool = true;
  // String boolString = convertBoolToString(inputBool);
  // print(boolString); //Outputs: true
}
