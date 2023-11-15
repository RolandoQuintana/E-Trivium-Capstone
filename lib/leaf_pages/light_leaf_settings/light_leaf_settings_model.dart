import '/backend/schema/structs/index.dart';
import '/components/display_received_data_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/custom_code/actions/index.dart' as actions;
import 'light_leaf_settings_widget.dart' show LightLeafSettingsWidget;
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterflow_colorpicker/flutterflow_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LightLeafSettingsModel extends FlutterFlowModel<LightLeafSettingsWidget> {
  ///  Local state fields for this page.

  int? currentButton = 0;

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
  Color? colorPicked1;
  // Stores action output result for [Custom Action - convertColorToString] action in Button widget.
  String? colorPicked1String;
  // Model for DisplayReceivedData component.
  late DisplayReceivedDataModel displayReceivedDataModel1;
  // State field(s) for PatternDropDown widget.
  String? patternDropDownValue;
  FormFieldController<String>? patternDropDownValueController;
  Color? colorPicked2;
  // Stores action output result for [Custom Action - convertColorToString] action in Button widget.
  String? colorPicked2String;
  // Stores action output result for [Custom Action - convertPatternColorToString] action in Button widget.
  String? stringPatternColor;
  // Model for DisplayReceivedData component.
  late DisplayReceivedDataModel displayReceivedDataModel2;
  // State field(s) for EnableLightsSwitch widget.
  bool? enableLightsSwitchValue;
  // Model for DisplayReceivedData component.
  late DisplayReceivedDataModel displayReceivedDataModel3;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {
    displayReceivedDataModel1 =
        createModel(context, () => DisplayReceivedDataModel());
    displayReceivedDataModel2 =
        createModel(context, () => DisplayReceivedDataModel());
    displayReceivedDataModel3 =
        createModel(context, () => DisplayReceivedDataModel());
  }

  void dispose() {
    unfocusNode.dispose();
    displayReceivedDataModel1.dispose();
    displayReceivedDataModel2.dispose();
    displayReceivedDataModel3.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
