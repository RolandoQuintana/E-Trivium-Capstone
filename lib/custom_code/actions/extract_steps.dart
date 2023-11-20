// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<String> extractSteps(String? receivedStepsStr) async {
  // Assuming the received message String format is "StepX" where X is the step count

  // Check if the message is not null
  if (receivedStepsStr == null) {
    //print("Error: Received message is null");
    return "null";
  }

  // Check if the message contains the substring "Step"
  if (!receivedStepsStr.contains("Step")) {
    //print("Error: Message format does not contain 'Step'");
    return "";
  }

  try {
    // Extract the numeric part of the message
    String steps = receivedStepsStr.replaceAll(RegExp(r'[^0-9]'), '');
    return steps;
  } catch (e) {
    // Handle any parsing errors or invalid message formats
    //print("Error extracting steps: $e");
    return "error";
  }
}
