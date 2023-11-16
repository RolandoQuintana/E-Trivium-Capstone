import '/backend/schema/structs/index.dart';
import '/components/display_received_data_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/instant_timer.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 's_o_s_leaf_settings_widget.dart' show SOSLeafSettingsWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SOSLeafSettingsModel extends FlutterFlowModel<SOSLeafSettingsWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  InstantTimer? receivedDataTimer;
  // Stores action output result for [Custom Action - receiveData] action in SOSLeafSettings widget.
  String? sosReceiveData;
  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
  // State field(s) for SOSEnabledTile widget.
  bool? sOSEnabledTileValue;
  // Model for DisplayReceivedData component.
  late DisplayReceivedDataModel displayReceivedDataModel;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {
    displayReceivedDataModel =
        createModel(context, () => DisplayReceivedDataModel());
  }

  void dispose() {
    unfocusNode.dispose();
    receivedDataTimer?.cancel();
    displayReceivedDataModel.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
