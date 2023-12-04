import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/custom/battery_charge_indicator/battery_charge_indicator_widget.dart';
import '/custom/strength_indicator/strength_indicator_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/instant_timer.dart';
import '/custom_code/actions/index.dart' as actions;
import 'home_page_widget.dart' show HomePageWidget;
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomePageModel extends FlutterFlowModel<HomePageWidget> {
  ///  Local state fields for this page.

  int? batteryCharge;

  int? currentRssi;

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  InstantTimer? updateTimer;
  // Stores action output result for [Custom Action - getRssi] action in HomePage widget.
  int? gotRssi;
  // Stores action output result for [Custom Action - receiveData] action in HomePage widget.
  String? gotDataStr;
  // Stores action output result for [Custom Action - extractBattery] action in HomePage widget.
  String? batteryStr;
  // Stores action output result for [Custom Action - convertStringToInt] action in HomePage widget.
  int? batteryInt;
  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
  // Model for StrengthIndicator component.
  late StrengthIndicatorModel strengthIndicatorModel1;
  // Model for BatteryChargeIndicator component.
  late BatteryChargeIndicatorModel batteryChargeIndicatorModel1;
  // Model for StrengthIndicator component.
  late StrengthIndicatorModel strengthIndicatorModel2;
  // Model for BatteryChargeIndicator component.
  late BatteryChargeIndicatorModel batteryChargeIndicatorModel2;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {
    strengthIndicatorModel1 =
        createModel(context, () => StrengthIndicatorModel());
    batteryChargeIndicatorModel1 =
        createModel(context, () => BatteryChargeIndicatorModel());
    strengthIndicatorModel2 =
        createModel(context, () => StrengthIndicatorModel());
    batteryChargeIndicatorModel2 =
        createModel(context, () => BatteryChargeIndicatorModel());
  }

  void dispose() {
    unfocusNode.dispose();
    updateTimer?.cancel();
    strengthIndicatorModel1.dispose();
    batteryChargeIndicatorModel1.dispose();
    strengthIndicatorModel2.dispose();
    batteryChargeIndicatorModel2.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
