import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'http_page_widget.dart' show HttpPageWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HttpPageModel extends FlutterFlowModel<HttpPageWidget> {
  ///  Local state fields for this page.

  int? currentRssi;

  String? receivedValue = '';

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for WardobeHeight widget.
  FocusNode? wardobeHeightFocusNode;
  TextEditingController? wardobeHeightController;
  String? Function(BuildContext, String?)? wardobeHeightControllerValidator;
  // State field(s) for Battery widget.
  FocusNode? batteryFocusNode;
  TextEditingController? batteryController;
  String? Function(BuildContext, String?)? batteryControllerValidator;
  // State field(s) for sosEn widget.
  FocusNode? sosEnFocusNode;
  TextEditingController? sosEnController;
  String? Function(BuildContext, String?)? sosEnControllerValidator;
  // State field(s) for healthEn widget.
  FocusNode? healthEnFocusNode;
  TextEditingController? healthEnController;
  String? Function(BuildContext, String?)? healthEnControllerValidator;
  // State field(s) for lightEn widget.
  FocusNode? lightEnFocusNode;
  TextEditingController? lightEnController;
  String? Function(BuildContext, String?)? lightEnControllerValidator;
  // Stores action output result for [Backend Call - API (sendDataToWeb)] action in SendButton widget.
  ApiCallResponse? response;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    unfocusNode.dispose();
    wardobeHeightFocusNode?.dispose();
    wardobeHeightController?.dispose();

    batteryFocusNode?.dispose();
    batteryController?.dispose();

    sosEnFocusNode?.dispose();
    sosEnController?.dispose();

    healthEnFocusNode?.dispose();
    healthEnController?.dispose();

    lightEnFocusNode?.dispose();
    lightEnController?.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
