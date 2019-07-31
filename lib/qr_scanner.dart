import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class QrScanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(viewType: 'QRScannerView');
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(viewType: 'QRScannerView');
    }
    return Text(
        '$defaultTargetPlatform is not yet supported by the text_view plugin');
  }
}
