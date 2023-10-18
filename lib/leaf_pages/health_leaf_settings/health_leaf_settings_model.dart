import '/backend/schema/structs/index.dart';
import '/components/display_received_data_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/custom_code/actions/index.dart' as actions;
import 'health_leaf_settings_widget.dart' show HealthLeafSettingsWidget;
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HealthLeafSettingsModel
    extends FlutterFlowModel<HealthLeafSettingsWidget> {
  ///  Local state fields for this page.

  int? currentButton = 0;

  String? postureEnabledSetting;

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
  // State field(s) for EnablePostureTile widget.
  bool? enablePostureTileValue;
  // State field(s) for PostureEnabledDropDown widget.
  String? postureEnabledDropDownValue;
  FormFieldController<String>? postureEnabledDropDownValueController;
  DateTime? datePicked;
  // Model for DisplayReceivedData component.
  late DisplayReceivedDataModel displayReceivedDataModel1;
  // State field(s) for EnablePedometerTile widget.
  bool? enablePedometerTileValue;
  // Stores action output result for [Custom Action - convertBoolToString] action in EnablePedometerTile widget.
  String? enablePedometerString;
  // Model for DisplayReceivedData component.
  late DisplayReceivedDataModel displayReceivedDataModel2;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {
    displayReceivedDataModel1 =
        createModel(context, () => DisplayReceivedDataModel());
    displayReceivedDataModel2 =
        createModel(context, () => DisplayReceivedDataModel());
  }

  void dispose() {
    unfocusNode.dispose();
    displayReceivedDataModel1.dispose();
    displayReceivedDataModel2.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
