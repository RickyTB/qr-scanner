import 'dart:async';

import 'package:flutter/material.dart';

import 'package:qr_scanner/qr_scanner.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<QrScannerState> _scannerKey = GlobalKey<QrScannerState>();

  String title = "Example";

  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 8), () => setState(() => title = "OwO"));
  }

  void _handleScan(String result) {
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
          child: SizedBox(
            width: 350,
            height: 350,
            child: QrScanner(
              key: _scannerKey,
              onSuccessfulScan: _handleScan,
            ),
          ),
        ),
      ),
    );
  }
}
