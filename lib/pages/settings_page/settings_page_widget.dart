import '/backend/schema/structs/index.dart';
import '/components/strength_indicator_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'settings_page_model.dart';
export 'settings_page_model.dart';

class SettingsPageWidget extends StatefulWidget {
  const SettingsPageWidget({
    Key? key,
    bool? isBTEnabled,
  })  : this.isBTEnabled = isBTEnabled ?? true,
        super(key: key);

  final bool isBTEnabled;

  @override
  _SettingsPageWidgetState createState() => _SettingsPageWidgetState();
}

class _SettingsPageWidgetState extends State<SettingsPageWidget> {
  late SettingsPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SettingsPageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      setDarkModeSetting(context, ThemeMode.dark);
      setState(() {
        _model.isBluetoothEnabled = _model.isBluetoothEnabled;
      });
      if (_model.isBluetoothEnabled!) {
        setState(() {
          _model.isFetchingConnectedDevices = true;
          _model.isFetchingDevices = true;
        });
        _model.fetchedConnectedDevices = await actions.getConnectedDevices();
        setState(() {
          _model.isFetchingConnectedDevices = false;
          _model.connectedDevices =
              _model.fetchedConnectedDevices!.toList().cast<BTDeviceStruct>();
        });
        _model.fetchedDevices = await actions.findDevices();
        setState(() {
          _model.isFetchingDevices = false;
          _model.foundDevices =
              _model.fetchedDevices!.toList().cast<BTDeviceStruct>();
        });
      }
    });
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
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, _) => [
            SliverAppBar(
              pinned: false,
              floating: false,
              backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
              automaticallyImplyLeading: false,
              title: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        'assets/images/E-Trivium_Logo_Orange.png',
                        width: 32.0,
                        height: 32.0,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                      child: Text(
                        'E-Trivium',
                        style:
                            FlutterFlowTheme.of(context).displayMedium.override(
                                  fontFamily: 'Outfit',
                                  fontSize: 28.0,
                                ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [],
              centerTitle: false,
              elevation: 2.0,
            )
          ],
          body: Builder(
            builder: (context) {
              return SafeArea(
                top: false,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 20.0, 0.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    20.0, 0.0, 0.0, 0.0),
                                child: Text(
                                  'Enable Bluetooth',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Readex Pro',
                                        fontSize: 18.0,
                                      ),
                                ),
                              ),
                              FlutterFlowIconButton(
                                borderColor: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                borderWidth: 1.0,
                                buttonSize: 30.0,
                                fillColor: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                icon: FaIcon(
                                  FontAwesomeIcons.questionCircle,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 12.0,
                                ),
                                onPressed: () async {
                                  await showDialog(
                                    context: context,
                                    builder: (alertDialogContext) {
                                      return AlertDialog(
                                        content: Text(
                                            'This enabling/disabling bluetooth button only works on Android at this time.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                alertDialogContext),
                                            child: Text('Ok'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                              Expanded(
                                child: Align(
                                  alignment: AlignmentDirectional(1.00, 0.00),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 20.0, 0.0),
                                    child: Switch.adaptive(
                                      value: _model.switchValue ??=
                                          widget.isBTEnabled,
                                      onChanged: (newValue) async {
                                        setState(() =>
                                            _model.switchValue = newValue!);
                                        if (newValue!) {
                                          _model.isTurningOn =
                                              await actions.turnOnBluetooth();
                                          await Future.delayed(const Duration(
                                              milliseconds: 1000));
                                          setState(() {
                                            _model.isBluetoothEnabled = true;
                                          });
                                          if (_model.isBluetoothEnabled!) {
                                            setState(() {
                                              _model.isFetchingConnectedDevices =
                                                  true;
                                              _model.isFetchingDevices = true;
                                            });
                                            _model.fetchedConnectedDevicesBTBttn =
                                                await actions
                                                    .getConnectedDevices();
                                            setState(() {
                                              _model.isFetchingConnectedDevices =
                                                  false;
                                              _model.connectedDevices = _model
                                                  .fetchedConnectedDevicesBTBttn!
                                                  .toList()
                                                  .cast<BTDeviceStruct>();
                                            });
                                            _model.fetchedDevicesBTBttn =
                                                await actions.findDevices();
                                            setState(() {
                                              _model.isFetchingDevices = false;
                                              _model.foundDevices = _model
                                                  .fetchedDevicesBTBttn!
                                                  .toList()
                                                  .cast<BTDeviceStruct>();
                                            });
                                          }

                                          setState(() {});
                                        } else {
                                          _model.isTurningOff =
                                              await actions.turnOffBluetooth();
                                          setState(() {
                                            _model.isBluetoothEnabled = false;
                                          });

                                          setState(() {});
                                        }
                                      },
                                      activeColor:
                                          FlutterFlowTheme.of(context).primary,
                                      activeTrackColor:
                                          FlutterFlowTheme.of(context).accent1,
                                      inactiveTrackColor:
                                          FlutterFlowTheme.of(context)
                                              .alternate,
                                      inactiveThumbColor:
                                          FlutterFlowTheme.of(context)
                                              .secondaryText,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 2.0,
                          indent: 20.0,
                          endIndent: 20.0,
                          color: FlutterFlowTheme.of(context).accent4,
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              20.0, 20.0, 20.0, 0.0),
                          child: Stack(
                            children: [
                              if (_model.isBluetoothEnabled ?? true)
                                Stack(
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  'Connected Devices',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        fontSize: 18.0,
                                                      ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          8.0, 0.0, 0.0, 0.0),
                                                  child: Icon(
                                                    Icons
                                                        .bluetooth_connected_sharp,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    size: 20.0,
                                                  ),
                                                ),
                                                if (_model
                                                        .isFetchingConnectedDevices ??
                                                    true)
                                                  Expanded(
                                                    child: Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              1.00, 0.00),
                                                      child: Text(
                                                        'Finding...',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Readex Pro',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
                                                                ),
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Builder(
                                          builder: (context) {
                                            final displayConnectedDevices =
                                                _model.connectedDevices
                                                    .toList();
                                            return ListView.builder(
                                              padding: EdgeInsets.zero,
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              itemCount: displayConnectedDevices
                                                  .length,
                                              itemBuilder: (context,
                                                  displayConnectedDevicesIndex) {
                                                final displayConnectedDevicesItem =
                                                    displayConnectedDevices[
                                                        displayConnectedDevicesIndex];
                                                return Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(20.0, 10.0,
                                                          20.0, 0.0),
                                                  child: InkWell(
                                                    splashColor:
                                                        Colors.transparent,
                                                    focusColor:
                                                        Colors.transparent,
                                                    hoverColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    onTap: () async {
                                                      context.pushNamed(
                                                        'HomePage',
                                                        queryParameters: {
                                                          'deviceName':
                                                              serializeParam(
                                                            displayConnectedDevicesItem
                                                                .name,
                                                            ParamType.String,
                                                          ),
                                                          'deviceId':
                                                              serializeParam(
                                                            displayConnectedDevicesItem
                                                                .id,
                                                            ParamType.String,
                                                          ),
                                                          'deviceRssi':
                                                              serializeParam(
                                                            displayConnectedDevicesItem
                                                                .rssi,
                                                            ParamType.int,
                                                          ),
                                                          'hasWriteCharacteristic':
                                                              serializeParam(
                                                            _model.hasWrite,
                                                            ParamType.bool,
                                                          ),
                                                        }.withoutNulls,
                                                        extra: <String,
                                                            dynamic>{
                                                          kTransitionInfoKey:
                                                              TransitionInfo(
                                                            hasTransition: true,
                                                            transitionType:
                                                                PageTransitionType
                                                                    .leftToRight,
                                                          ),
                                                        },
                                                      );
                                                    },
                                                    child: Container(
                                                      width: 100.0,
                                                      height: 70.0,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0x324B39EF),
                                                        shape:
                                                            BoxShape.rectangle,
                                                        border: Border.all(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    10.0,
                                                                    0.0,
                                                                    0.0,
                                                                    0.0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Expanded(
                                                                  child: Align(
                                                                    alignment:
                                                                        AlignmentDirectional(
                                                                            -1.00,
                                                                            0.00),
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          20.0,
                                                                          10.0,
                                                                          0.0,
                                                                          0.0),
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        children: [
                                                                          Text(
                                                                            displayConnectedDevicesItem.name,
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  fontFamily: 'Readex Pro',
                                                                                  fontSize: 16.0,
                                                                                ),
                                                                          ),
                                                                          Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                10.0,
                                                                                0.0,
                                                                                0.0,
                                                                                0.0),
                                                                            child:
                                                                                StrengthIndicatorWidget(
                                                                              key: Key('Keyll0_${displayConnectedDevicesIndex}_of_${displayConnectedDevices.length}'),
                                                                              rssi: displayConnectedDevicesItem.rssi,
                                                                              color: valueOrDefault<Color>(
                                                                                () {
                                                                                  if (displayConnectedDevicesItem.rssi >= -67) {
                                                                                    return FlutterFlowTheme.of(context).success;
                                                                                  } else if (displayConnectedDevicesItem.rssi >= -90) {
                                                                                    return FlutterFlowTheme.of(context).warning;
                                                                                  } else {
                                                                                    return FlutterFlowTheme.of(context).error;
                                                                                  }
                                                                                }(),
                                                                                FlutterFlowTheme.of(context).success,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Align(
                                                                    alignment:
                                                                        AlignmentDirectional(
                                                                            -1.00,
                                                                            0.00),
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          20.0,
                                                                          0.0,
                                                                          0.0,
                                                                          10.0),
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        children: [
                                                                          Text(
                                                                            displayConnectedDevicesItem.id,
                                                                            style: FlutterFlowTheme.of(context).labelSmall.override(
                                                                                  fontFamily: 'Readex Pro',
                                                                                  fontSize: 14.0,
                                                                                ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              20.0, 20.0, 20.0, 0.0),
                          child: Stack(
                            children: [
                              if (_model.isBluetoothEnabled ?? true)
                                Stack(
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  'Devices',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        fontSize: 18.0,
                                                      ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          8.0, 0.0, 0.0, 0.0),
                                                  child: Icon(
                                                    Icons.bluetooth_audio_sharp,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    size: 20.0,
                                                  ),
                                                ),
                                                if (_model.isFetchingDevices ??
                                                    true)
                                                  Expanded(
                                                    child: Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              1.00, 0.00),
                                                      child: Text(
                                                        'Scanning...',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Readex Pro',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
                                                                ),
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            Builder(
                                              builder: (context) {
                                                final displayFoundDevices =
                                                    _model.foundDevices
                                                        .toList();
                                                return ListView.builder(
                                                  padding: EdgeInsets.zero,
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  itemCount: displayFoundDevices
                                                      .length,
                                                  itemBuilder: (context,
                                                      displayFoundDevicesIndex) {
                                                    final displayFoundDevicesItem =
                                                        displayFoundDevices[
                                                            displayFoundDevicesIndex];
                                                    return Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  20.0,
                                                                  10.0,
                                                                  20.0,
                                                                  0.0),
                                                      child: InkWell(
                                                        splashColor:
                                                            Colors.transparent,
                                                        focusColor:
                                                            Colors.transparent,
                                                        hoverColor:
                                                            Colors.transparent,
                                                        highlightColor:
                                                            Colors.transparent,
                                                        onTap: () async {
                                                          _model.hasWrite =
                                                              await actions
                                                                  .connectDevice(
                                                            displayFoundDevicesItem,
                                                          );
                                                          setState(() {
                                                            _model.addToConnectedDevices(
                                                                displayFoundDevicesItem);
                                                          });

                                                          context.pushNamed(
                                                            'HomePage',
                                                            queryParameters: {
                                                              'deviceName':
                                                                  serializeParam(
                                                                displayFoundDevicesItem
                                                                    .name,
                                                                ParamType
                                                                    .String,
                                                              ),
                                                              'deviceId':
                                                                  serializeParam(
                                                                displayFoundDevicesItem
                                                                    .id,
                                                                ParamType
                                                                    .String,
                                                              ),
                                                              'hasWriteCharacteristic':
                                                                  serializeParam(
                                                                _model.hasWrite,
                                                                ParamType.bool,
                                                              ),
                                                              'deviceRssi':
                                                                  serializeParam(
                                                                displayFoundDevicesItem
                                                                    .rssi,
                                                                ParamType.int,
                                                              ),
                                                            }.withoutNulls,
                                                            extra: <String,
                                                                dynamic>{
                                                              kTransitionInfoKey:
                                                                  TransitionInfo(
                                                                hasTransition:
                                                                    true,
                                                                transitionType:
                                                                    PageTransitionType
                                                                        .leftToRight,
                                                              ),
                                                            },
                                                          );

                                                          setState(() {});
                                                        },
                                                        child: Container(
                                                          width: 100.0,
                                                          height: 70.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Color(
                                                                0x324B39EF),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primary,
                                                            ),
                                                          ),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Align(
                                                                      alignment: AlignmentDirectional(
                                                                          -1.00,
                                                                          0.00),
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            20.0,
                                                                            10.0,
                                                                            0.0,
                                                                            0.0),
                                                                        child:
                                                                            Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          children: [
                                                                            Text(
                                                                              displayFoundDevicesItem.name,
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Readex Pro',
                                                                                    fontSize: 16.0,
                                                                                  ),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                                                                              child: StrengthIndicatorWidget(
                                                                                key: Key('Keyjpe_${displayFoundDevicesIndex}_of_${displayFoundDevices.length}'),
                                                                                rssi: displayFoundDevicesItem.rssi,
                                                                                color: valueOrDefault<Color>(
                                                                                  () {
                                                                                    if (displayFoundDevicesItem.rssi >= -67) {
                                                                                      return FlutterFlowTheme.of(context).success;
                                                                                    } else if (displayFoundDevicesItem.rssi >= -90) {
                                                                                      return FlutterFlowTheme.of(context).warning;
                                                                                    } else {
                                                                                      return FlutterFlowTheme.of(context).error;
                                                                                    }
                                                                                  }(),
                                                                                  FlutterFlowTheme.of(context).success,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Align(
                                                                      alignment: AlignmentDirectional(
                                                                          -1.00,
                                                                          0.00),
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            20.0,
                                                                            0.0,
                                                                            0.0,
                                                                            10.0),
                                                                        child:
                                                                            Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          children: [
                                                                            Text(
                                                                              displayFoundDevicesItem.id,
                                                                              style: FlutterFlowTheme.of(context).labelSmall.override(
                                                                                    fontFamily: 'Readex Pro',
                                                                                    fontSize: 14.0,
                                                                                  ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Icon(
                                                                Icons
                                                                    .arrow_forward_ios_rounded,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                size: 24.0,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
