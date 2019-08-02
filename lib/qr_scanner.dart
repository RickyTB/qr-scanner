import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

const String _PLUGIN_VIEW_NAME = 'QrScannerView';

typedef void QrResultCallback(String result);

class QrScanner extends StatefulWidget {
  final QrResultCallback onSuccessfulScan;

  const QrScanner({Key key, @required this.onSuccessfulScan}) : super(key: key);

  @override
  QrScannerState createState() => QrScannerState._();
}

class QrScannerState extends State<QrScanner> {
  _LifecycleEventHandler _lifecycleHandler;
  MethodChannel _channel;

  QrScannerState._();

  @override
  void initState() {
    super.initState();
    _lifecycleHandler = _LifecycleEventHandler(
      onResume: _handleResume,
      onPause: _handlePause,
    );
    WidgetsBinding.instance.addObserver(_lifecycleHandler);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_lifecycleHandler);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_channel != null) resumePreview();
  }

  Future<void> _handleResume() async {
    _channel.invokeMethod('startCamera');
  }

  Future<void> _handlePause() async {
    _channel.invokeMethod('stopCamera');
  }

  Future<void> resumePreview() async {
    _channel.invokeMethod('resumePreview');
  }

  void _onPlatformViewCreated(int id) {
    _channel = new MethodChannel('${_PLUGIN_VIEW_NAME}_$id');
    _channel.setMethodCallHandler(_methodHandler);
    _handleResume();
  }

  Future _methodHandler(MethodCall call) async {
    switch (call.method) {
      case "onSuccessfulScan":
        widget.onSuccessfulScan(call.arguments);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: _PLUGIN_VIEW_NAME,
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: _PLUGIN_VIEW_NAME,
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    }
    return Text(
        '$defaultTargetPlatform is not yet supported by the qr_scanner plugin');
  }
}

class _LifecycleEventHandler extends WidgetsBindingObserver {
  final AsyncCallback onResume;
  final AsyncCallback onPause;

  _LifecycleEventHandler({this.onResume, this.onPause});

  @override
  Future<Null> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.suspending:
      case AppLifecycleState.paused:
        await onPause();
        break;
      case AppLifecycleState.resumed:
        await onResume();
        break;
    }
  }
}
