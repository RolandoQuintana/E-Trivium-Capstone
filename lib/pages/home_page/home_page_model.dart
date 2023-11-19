import '/backend/schema/structs/index.dart';
import '/components/battery_charge_indicator_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/instant_timer.dart';
import '/custom_code/actions/index.dart' as actions;
import 'home_page_widget.dart' show HomePageWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomePageModel extends FlutterFlowModel<HomePageWidget> {
  ///  Local state fields for this page.

  int? batteryCharge;

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  InstantTimer? gotDataTimer;
  // Stores action output result for [Custom Action - receiveData] action in HomePage widget.
  String? gotDataStr;
  // Stores action output result for [Custom Action - extractBattery] action in HomePage widget.
  String? batteryStr;
  // Stores action output result for [Custom Action - convertStringToInt] action in HomePage widget.
  int? batteryInt;
  // Model for BatteryChargeIndicator component.
  late BatteryChargeIndicatorModel batteryChargeIndicatorModel;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {
    batteryChargeIndicatorModel =
        createModel(context, () => BatteryChargeIndicatorModel());
  }

  void dispose() {
    unfocusNode.dispose();
    gotDataTimer?.cancel();
    batteryChargeIndicatorModel.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
