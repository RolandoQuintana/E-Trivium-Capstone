import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/schema/structs/index.dart';

String? convertColorToString(Color? inputColor) {
  // Check if input is null
  if (inputColor == null) {
    return null;
  }
  // Convert the Color type to a String
  String hexColor = inputColor.value.toRadixString(16).padLeft(8, '0');
  // Return the hexadecimal string
  return hexColor;

  // For example:
  // Color myColor = Colors.blue;
  // String colorString = convertColorToString(myColor);
  // print(colorString); // Output: ff0000ff
}

String? convertBoolToString(bool? inputBool) {
  // Check if input is null
  if (inputBool == null) {
    return null;
  }
  // Returns a string true/false depending on an input bool
  return inputBool.toString();
}

String? convertPatternColorToString(
  String? inputPattern,
  String? inputColor,
) {
  // Check if inputs are null
  if (inputPattern == null || inputColor == null) {
    return null;
  }
  // Returns string of selected pattern and selected color
  String returnString = inputPattern + "#" + inputColor;
  // For example:
  // String selectedPattern = "Solid";
  // Color selectedColor = Colors.blue;
  // String lightLeaf = convertPatternColorToString(selectedPattern, selectedColor);
  // print(lightLeaf); // Output: Solid#ff0000ff
  return returnString;
}
