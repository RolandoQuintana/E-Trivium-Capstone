import '/backend/schema/structs/index.dart';
import '/components/display_received_data_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/instant_timer.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'health_leaf_settings_model.dart';
export 'health_leaf_settings_model.dart';

class HealthLeafSettingsWidget extends StatefulWidget {
  const HealthLeafSettingsWidget({
    Key? key,
    this.clothing,
    required this.deviceName,
    required this.deviceId,
    required this.deviceRssi,
  }) : super(key: key);

  final String? clothing;
  final String? deviceName;
  final String? deviceId;
  final int? deviceRssi;

  @override
  _HealthLeafSettingsWidgetState createState() =>
      _HealthLeafSettingsWidgetState();
}

class _HealthLeafSettingsWidgetState extends State<HealthLeafSettingsWidget> {
  late HealthLeafSettingsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HealthLeafSettingsModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      setDarkModeSetting(context, ThemeMode.dark);
      setState(() {
        _model.isPostureBad = false;
      });
      _model.postureTimer = InstantTimer.periodic(
        duration: Duration(milliseconds: 2000),
        callback: (timer) async {
          _model.gotSomeData = await actions.receiveData(
            BTDeviceStruct(
              name: widget.deviceName,
              id: widget.deviceId,
              rssi: widget.deviceRssi,
            ),
          );
          _model.postureBool = await actions.badPostureChecker(
            _model.gotSomeData!,
          );
          setState(() {
            _model.isPostureBad = _model.postureBool!;
          });
          if (_model.isPostureBad && _model.enablePostureTileValue!) {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'FIX YOUR BAD POSTURE!!',
                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                        fontFamily: 'Readex Pro',
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 20.0,
                      ),
                ),
                duration: Duration(milliseconds: 10000),
                backgroundColor: FlutterFlowTheme.of(context).error,
              ),
            );
            setState(() {
              _model.isPostureBad = false;
            });
          }
        },
        startImmediately: true,
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isiOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          systemStatusBarContrastEnforced: true,
        ),
      );
    }

    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.black,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            automaticallyImplyLeading: true,
            title: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 10.0, 10.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Health Leaf',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Open Sans',
                          fontSize: 25.0,
                        ),
                  ),
                  Text(
                    widget.clothing!,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Readex Pro',
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                  ),
                ],
              ),
            ),
            actions: [],
            centerTitle: true,
            elevation: 4.0,
          ),
        ),
        body: SafeArea(
          top: true,
          child: Container(
            width: 478.0,
            height: 776.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  FlutterFlowTheme.of(context).secondaryBackground,
                  FlutterFlowTheme.of(context).primary
                ],
                stops: [0.4, 1.0],
                begin: AlignmentDirectional(0.0, -1.0),
                end: AlignmentDirectional(0, 1.0),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              20.0, 10.0, 20.0, 10.0),
                          child: FFButtonWidget(
                            onPressed: () async {
                              setState(() {
                                _model.currentButton = 0;
                              });
                              await _model.pageViewController?.animateToPage(
                                0,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.ease,
                              );
                            },
                            text: 'Posture',
                            options: FFButtonOptions(
                              height: 40.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  24.0, 0.0, 24.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: _model.currentButton == 0
                                  ? FlutterFlowTheme.of(context).primaryText
                                  : Color(0x00000000),
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    fontFamily: 'Readex Pro',
                                    color: _model.currentButton == 0
                                        ? Colors.black
                                        : FlutterFlowTheme.of(context)
                                            .primaryText,
                                  ),
                              elevation: 3.0,
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).primaryText,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            showLoadingIndicator: false,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              20.0, 10.0, 20.0, 10.0),
                          child: FFButtonWidget(
                            onPressed: () async {
                              setState(() {
                                _model.currentButton = 1;
                              });
                              await _model.pageViewController?.animateToPage(
                                1,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.ease,
                              );
                            },
                            text: 'Pedometer',
                            options: FFButtonOptions(
                              height: 40.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  24.0, 0.0, 24.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: _model.currentButton == 1
                                  ? FlutterFlowTheme.of(context).primaryText
                                  : Color(0x00000000),
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    fontFamily: 'Readex Pro',
                                    color: _model.currentButton == 1
                                        ? Colors.black
                                        : FlutterFlowTheme.of(context)
                                            .primaryText,
                                    fontSize:
                                        _model.currentButton == 1 ? 24.0 : 16.0,
                                  ),
                              elevation: 3.0,
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).primaryText,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            showLoadingIndicator: false,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional(0.00, 1.00),
                    child: Container(
                      width: double.infinity,
                      height: 725.0,
                      child: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 40.0),
                            child: PageView(
                              controller: _model.pageViewController ??=
                                  PageController(initialPage: 0),
                              scrollDirection: Axis.horizontal,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      30.0, 30.0, 30.0, 30.0),
                                  child: Container(
                                    width: 100.0,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 4.0,
                                          color: Color(0x33000000),
                                          offset: Offset(0.0, 10.0),
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(20.0),
                                      border: Border.all(
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  10.0, 20.0, 10.0, 0.0),
                                          child: SwitchListTile.adaptive(
                                            value: _model
                                                    .enablePostureTileValue ??=
                                                false,
                                            onChanged: (newValue) async {
                                              setState(() => _model
                                                      .enablePostureTileValue =
                                                  newValue!);
                                            },
                                            title: Text(
                                              'Enable Health',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .titleLarge,
                                            ),
                                            tileColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondaryBackground,
                                            activeColor:
                                                FlutterFlowTheme.of(context)
                                                    .primary,
                                            activeTrackColor:
                                                FlutterFlowTheme.of(context)
                                                    .accent1,
                                            dense: false,
                                            controlAffinity:
                                                ListTileControlAffinity
                                                    .trailing,
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              AlignmentDirectional(0.00, 0.00),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 20.0, 0.0, 0.0),
                                            child: FFButtonWidget(
                                              onPressed: () async {
                                                if (_model
                                                    .enablePostureTileValue!) {
                                                  await actions.sendData(
                                                    BTDeviceStruct(
                                                      name: widget.deviceName,
                                                      id: widget.deviceId,
                                                      rssi: widget.deviceRssi,
                                                    ),
                                                    'BBBB',
                                                  );
                                                } else {
                                                  await actions.sendData(
                                                    BTDeviceStruct(
                                                      name: widget.deviceName,
                                                      id: widget.deviceId,
                                                      rssi: widget.deviceRssi,
                                                    ),
                                                    'YYYY',
                                                  );
                                                }

                                                ScaffoldMessenger.of(context)
                                                    .clearSnackBars();
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'Enable posture data sent to device',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyLarge
                                                              .override(
                                                                fontFamily:
                                                                    'Readex Pro',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                              ),
                                                    ),
                                                    duration: Duration(
                                                        milliseconds: 2000),
                                                    backgroundColor:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .success,
                                                  ),
                                                );
                                              },
                                              text: 'Confirm',
                                              options: FFButtonOptions(
                                                height: 40.0,
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        24.0, 0.0, 24.0, 0.0),
                                                iconPadding:
                                                    EdgeInsetsDirectional
                                                        .fromSTEB(
                                                            0.0, 0.0, 0.0, 0.0),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                textStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .override(
                                                          fontFamily:
                                                              'Readex Pro',
                                                          color: Colors.white,
                                                        ),
                                                elevation: 3.0,
                                                borderSide: BorderSide(
                                                  color: Colors.transparent,
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Align(
                                            alignment: AlignmentDirectional(
                                                0.00, -1.00),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 80.0, 0.0, 0.0),
                                              child: wrapWithModel(
                                                model: _model
                                                    .displayReceivedDataModel1,
                                                updateCallback: () =>
                                                    setState(() {}),
                                                child:
                                                    DisplayReceivedDataWidget(
                                                  device: BTDeviceStruct(
                                                    name: widget.deviceName,
                                                    id: widget.deviceId,
                                                    rssi: widget.deviceRssi,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      30.0, 30.0, 30.0, 30.0),
                                  child: Container(
                                    width: 100.0,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 4.0,
                                          color: Color(0x33000000),
                                          offset: Offset(0.0, 10.0),
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(20.0),
                                      border: Border.all(
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 30.0, 0.0, 0.0),
                                          child: Text(
                                            'Steps:',
                                            style: FlutterFlowTheme.of(context)
                                                .titleLarge
                                                .override(
                                                  fontFamily: 'Outfit',
                                                  fontSize: 30.0,
                                                ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 50.0, 0.0, 0.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              setState(() {
                                                _model.displaySteps = '0';
                                              });
                                              _model.gotStepsTimer =
                                                  InstantTimer.periodic(
                                                duration: Duration(
                                                    milliseconds: 1000),
                                                callback: (timer) async {
                                                  _model.gotDataStr =
                                                      await actions.receiveData(
                                                    BTDeviceStruct(
                                                      name: widget.deviceName,
                                                      id: widget.deviceId,
                                                      rssi: widget.deviceRssi,
                                                    ),
                                                  );
                                                  _model.stepsStr =
                                                      await actions
                                                          .extractSteps(
                                                    _model.gotDataStr,
                                                  );
                                                  setState(() {
                                                    _model.displaySteps =
                                                        _model.stepsStr!;
                                                  });
                                                },
                                                startImmediately: true,
                                              );

                                              setState(() {});
                                            },
                                            child: Text(
                                              _model.displaySteps,
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyLarge
                                                      .override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        fontSize: 20.0,
                                                      ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              AlignmentDirectional(0.00, 0.00),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 60.0, 0.0, 0.0),
                                            child: FFButtonWidget(
                                              onPressed: () async {
                                                await actions.sendData(
                                                  BTDeviceStruct(
                                                    name: widget.deviceName,
                                                    id: widget.deviceId,
                                                    rssi: widget.deviceRssi,
                                                  ),
                                                  'ResetSteps',
                                                );
                                                ScaffoldMessenger.of(context)
                                                    .clearSnackBars();
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'Reset step counter sent to device',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyLarge
                                                              .override(
                                                                fontFamily:
                                                                    'Readex Pro',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                              ),
                                                    ),
                                                    duration: Duration(
                                                        milliseconds: 2000),
                                                    backgroundColor:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .success,
                                                  ),
                                                );
                                                setState(() {
                                                  _model.displaySteps = '0';
                                                });
                                              },
                                              text: 'Reset Steps',
                                              options: FFButtonOptions(
                                                height: 40.0,
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        24.0, 0.0, 24.0, 0.0),
                                                iconPadding:
                                                    EdgeInsetsDirectional
                                                        .fromSTEB(
                                                            0.0, 0.0, 0.0, 0.0),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                textStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .override(
                                                          fontFamily:
                                                              'Readex Pro',
                                                          color: Colors.white,
                                                        ),
                                                elevation: 3.0,
                                                borderSide: BorderSide(
                                                  color: Colors.transparent,
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Align(
                                            alignment: AlignmentDirectional(
                                                0.00, -1.00),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 80.0, 0.0, 0.0),
                                              child: wrapWithModel(
                                                model: _model
                                                    .displayReceivedDataModel2,
                                                updateCallback: () =>
                                                    setState(() {}),
                                                child:
                                                    DisplayReceivedDataWidget(
                                                  device: BTDeviceStruct(
                                                    name: widget.deviceName,
                                                    id: widget.deviceId,
                                                    rssi: widget.deviceRssi,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(0.00, 1.00),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 0.0, 16.0),
                              child: smooth_page_indicator.SmoothPageIndicator(
                                controller: _model.pageViewController ??=
                                    PageController(initialPage: 0),
                                count: 2,
                                axisDirection: Axis.horizontal,
                                onDotClicked: (i) async {
                                  await _model.pageViewController!
                                      .animateToPage(
                                    i,
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.ease,
                                  );
                                },
                                effect:
                                    smooth_page_indicator.ExpandingDotsEffect(
                                  expansionFactor: 3.0,
                                  spacing: 8.0,
                                  radius: 16.0,
                                  dotWidth: 16.0,
                                  dotHeight: 8.0,
                                  dotColor: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  activeDotColor:
                                      FlutterFlowTheme.of(context).primaryText,
                                  paintStyle: PaintingStyle.fill,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
