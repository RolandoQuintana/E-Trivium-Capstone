// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<String> getAdjustStatus(String? incomingString) async {
  // if incomingString starts with 'adjustStatus', return the rest of the string
  if (incomingString != null && incomingString.startsWith('adjustStatus')) {
    return incomingString.substring('adjustStatus'.length);
  } else {
    return 'notStatus';
  }
}
