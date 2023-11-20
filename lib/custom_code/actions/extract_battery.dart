// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<String> extractBattery(String? receivedBatStr) async {
  // Assuming the received message String format is "BatteryX" where X is the battery percentage

  // Check if the message is not null
  if (receivedBatStr == null) {
    //print("Error: Received message is null");
    return "";
  }

  // Check if the message contains the substring "Step"
  if (!receivedBatStr.contains("Battery")) {
    //print("Error: Message format does not contain 'Step'");
    return "";
  }

  try {
    // Extract the numeric part of the message
    String battery = receivedBatStr.replaceAll(RegExp(r'[^0-9]'), '');
    return battery;
  } catch (e) {
    // Handle any parsing errors or invalid message formats
    //print("Error extracting battery charge: $e");
    return "";
  }
}
