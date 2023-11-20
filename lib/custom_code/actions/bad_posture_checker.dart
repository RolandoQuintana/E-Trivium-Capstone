// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<bool> badPostureChecker(String message) async {
  if (message == "BadPosture") {
    return true;
  } else if (message == "PostureOK") {
    return false;
  } else {
    return false;
  }
}
