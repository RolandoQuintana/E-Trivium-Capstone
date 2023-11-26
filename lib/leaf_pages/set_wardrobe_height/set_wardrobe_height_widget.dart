import '/custom/display_received_data/display_received_data_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/backend/schema/structs/index.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'set_wardrobe_height_model.dart';
export 'set_wardrobe_height_model.dart';

class SetWardrobeHeightWidget extends StatefulWidget {
  const SetWardrobeHeightWidget({
    Key? key,
    required this.device,
  }) : super(key: key);

  final dynamic device;

  @override
  _SetWardrobeHeightWidgetState createState() =>
      _SetWardrobeHeightWidgetState();
}

class _SetWardrobeHeightWidgetState extends State<SetWardrobeHeightWidget> {
  late SetWardrobeHeightModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SetWardrobeHeightModel());

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
                    'Adjust Height',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Open Sans',
                          fontSize: 25.0,
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
            width: 486.0,
            height: 887.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  FlutterFlowTheme.of(context).secondaryBackground,
                  FlutterFlowTheme.of(context).accent1
                ],
                stops: [0.4, 1.0],
                begin: AlignmentDirectional(0.0, -1.0),
                end: AlignmentDirectional(0, 1.0),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  valueOrDefault<String>(
                    _model.adjustReturn,
                    'none',
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium,
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Current Height: ',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Readex Pro',
                              fontSize: 25.0,
                            ),
                      ),
                      Text(
                        FFAppState().wardrobeHeight,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Readex Pro',
                              fontSize: 25.0,
                            ),
                      ),
                      FFButtonWidget(
                        onPressed: () async {
                          await actions.sendData(
                            BTDeviceStruct.fromMap(widget.device!),
                            'adjustHeight',
                          );
                          _model.adjustReturn = await actions.receiveData(
                            BTDeviceStruct.fromMap(widget.device!),
                          );
                          _model.adjustStatus = await actions.getAdjustStatus(
                            _model.adjustReturn,
                          );
                          if (_model.adjustStatus != 'notStatus') {
                            if (_model.adjustStatus == 'true' ? false : false) {
                              setState(() {
                                _model.adjusting = true;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Adjust In Progress',
                                    style: TextStyle(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                    ),
                                  ),
                                  duration: Duration(milliseconds: 4000),
                                  backgroundColor:
                                      FlutterFlowTheme.of(context).secondary,
                                ),
                              );
                            } else {
                              setState(() {
                                _model.adjusting = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Adjust Not Possible Yet',
                                    style: TextStyle(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                    ),
                                  ),
                                  duration: Duration(milliseconds: 4000),
                                  backgroundColor:
                                      FlutterFlowTheme.of(context).secondary,
                                ),
                              );
                            }
                          }

                          setState(() {});
                        },
                        text: 'Adjust',
                        options: FFButtonOptions(
                          height: 40.0,
                          padding: EdgeInsetsDirectional.fromSTEB(
                              24.0, 0.0, 24.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color: FlutterFlowTheme.of(context).error,
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Readex Pro',
                                    color: Colors.white,
                                  ),
                          elevation: 3.0,
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  valueOrDefault<String>(
                    _model.adjustStatus,
                    'none',
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium,
                ),
                SliderTheme(
                  data: SliderThemeData(
                    showValueIndicator: ShowValueIndicator.always,
                  ),
                  child: Slider(
                    activeColor: FlutterFlowTheme.of(context).primary,
                    inactiveColor: FlutterFlowTheme.of(context).alternate,
                    min: 0.0,
                    max: 255.0,
                    value: _model.sliderValue ??= 1.0,
                    label: _model.sliderValue.toString(),
                    onChanged: _model.adjusting == true
                        ? null
                        : (newValue) async {
                            newValue =
                                double.parse(newValue.toStringAsFixed(0));
                            setState(() => _model.sliderValue = newValue);
                            await actions.sendData(
                              BTDeviceStruct.fromMap(widget.device!),
                              'slide${_model.sliderValue?.toString()}',
                            );
                          },
                  ),
                ),
                if (_model.adjusting)
                  FFButtonWidget(
                    onPressed: () async {
                      await actions.sendData(
                        BTDeviceStruct.fromMap(widget.device!),
                        'confirmHeight',
                      );
                      _model.confirmReturn = await actions.receiveData(
                        BTDeviceStruct.fromMap(widget.device!),
                      );
                      if (_model.confirmReturn != 'false') {
                        setState(() {
                          FFAppState().wardrobeHeight = _model.confirmReturn!;
                        });
                        setState(() {
                          _model.adjusting = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Adjust Finished',
                              style: TextStyle(
                                color: FlutterFlowTheme.of(context).primaryText,
                              ),
                            ),
                            duration: Duration(milliseconds: 4000),
                            backgroundColor:
                                FlutterFlowTheme.of(context).secondary,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Adjust Not Confirmed',
                              style: TextStyle(
                                color: FlutterFlowTheme.of(context).primaryText,
                              ),
                            ),
                            duration: Duration(milliseconds: 4000),
                            backgroundColor:
                                FlutterFlowTheme.of(context).secondary,
                          ),
                        );
                      }

                      setState(() {});
                    },
                    text: 'Confirm',
                    options: FFButtonOptions(
                      height: 40.0,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: FlutterFlowTheme.of(context).error,
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: 'Readex Pro',
                                color: Colors.white,
                              ),
                      elevation: 3.0,
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                Expanded(
                  child: wrapWithModel(
                    model: _model.displayReceivedDataModel,
                    updateCallback: () => setState(() {}),
                    child: DisplayReceivedDataWidget(
                      device: widget.device != null && widget.device != ''
                          ? BTDeviceStruct.fromMap(widget.device)
                          : null,
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
