import 'package:flutter/material.dart';

import 'package:qr_scanner/qr_scanner.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('QR Scanner Example'),
        ),
        body: Center(
          child: SizedBox(
            width: 350,
            height: 350,
            child: QrScanner(),
          ),
        ),
      ),
    );
  }
}
