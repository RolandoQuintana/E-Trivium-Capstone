import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'battery_charge_indicator_model.dart';
export 'battery_charge_indicator_model.dart';

class BatteryChargeIndicatorWidget extends StatefulWidget {
  const BatteryChargeIndicatorWidget({
    Key? key,
    required this.charge,
    required this.color,
  }) : super(key: key);

  final int? charge;
  final Color? color;

  @override
  _BatteryChargeIndicatorWidgetState createState() =>
      _BatteryChargeIndicatorWidgetState();
}

class _BatteryChargeIndicatorWidgetState
    extends State<BatteryChargeIndicatorWidget> {
  late BatteryChargeIndicatorModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BatteryChargeIndicatorModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Container(
      decoration: BoxDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 2.0, 0.0, 0.0),
            child: Container(
              width: 10.0,
              height: 5.0,
              decoration: BoxDecoration(
                color: valueOrDefault<Color>(
                  widget.charge! > 75
                      ? widget.color
                      : FlutterFlowTheme.of(context).accent4,
                  FlutterFlowTheme.of(context).accent4,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 2.0, 0.0, 0.0),
            child: Container(
              width: 20.0,
              height: 5.0,
              decoration: BoxDecoration(
                color: valueOrDefault<Color>(
                  widget.charge! > 50
                      ? widget.color
                      : FlutterFlowTheme.of(context).accent4,
                  FlutterFlowTheme.of(context).accent4,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 2.0, 0.0, 0.0),
            child: Container(
              width: 20.0,
              height: 5.0,
              decoration: BoxDecoration(
                color: valueOrDefault<Color>(
                  widget.charge! > 25
                      ? widget.color
                      : FlutterFlowTheme.of(context).accent4,
                  FlutterFlowTheme.of(context).accent4,
                ),
                borderRadius: BorderRadius.circular(10.0),
                shape: BoxShape.rectangle,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 2.0, 0.0, 0.0),
            child: Container(
              width: 20.0,
              height: 5.0,
              decoration: BoxDecoration(
                color: valueOrDefault<Color>(
                  widget.charge! > 0
                      ? widget.color
                      : FlutterFlowTheme.of(context).accent4,
                  FlutterFlowTheme.of(context).accent4,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
