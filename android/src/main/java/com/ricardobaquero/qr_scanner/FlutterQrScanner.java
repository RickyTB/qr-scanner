package com.ricardobaquero.qr_scanner;

import android.content.Context;
import android.support.annotation.NonNull;
import android.util.Log;
import android.view.View;

import com.google.zxing.Result;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;
import me.dm7.barcodescanner.zxing.ZXingScannerView;

public class FlutterQrScanner implements PlatformView, MethodChannel.MethodCallHandler, ZXingScannerView.ResultHandler {
    private final ZXingScannerView mScannerView;
    private final MethodChannel methodChannel;

    FlutterQrScanner(Context context, BinaryMessenger messenger, int id) {
        mScannerView = new ZXingScannerView(context);
        methodChannel = new MethodChannel(messenger, "QrScannerView_" + id);
        methodChannel.setMethodCallHandler(this);

        /*new android.os.Handler().postDelayed(
                new Runnable() {
                    public void run() {
                        methodChannel.invokeMethod("onSuccessfulScan", "Holix");
                    }
                },
                5000);*/
    }

    @Override
    public View getView() {
        Log.d("FlutterQrScanner", "Ola devolviendo escaner");
        return mScannerView;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall methodCall, @NonNull MethodChannel.Result result) {
        switch (methodCall.method) {
            case "startCamera":
                mScannerView.setResultHandler(this); // Register ourselves as a handler for scan results.
                mScannerView.startCamera();
                break;
            case "stopCamera":
                mScannerView.stopCamera();
                break;
            case "resumePreview":
                mScannerView.resumeCameraPreview(this);
                break;
            default:
                result.notImplemented();
        }
    }

    /*private void setText(MethodCall methodCall, MethodChannel.Result result) {
        String text = (String) methodCall.arguments;
        textView.setText(text);
        result.success(null);
    }*/

    @Override
    public void handleResult(Result rawResult) {
        methodChannel.invokeMethod("onSuccessfulScan", rawResult.getText());
        // If you would like to resume scanning, call this method below:
        mScannerView.resumeCameraPreview(this);
    }

    @Override
    public void dispose() {

    }
}
