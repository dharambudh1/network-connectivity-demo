import 'dart:async';
import 'dart:developer';

import 'package:connectivity_demo/connectivity_singleton/data_connection_checker.dart';
import 'package:connectivity_demo/multi_stream_builder.dart';
import 'package:connectivity_demo/navigation_singleton/navigator_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/subjects.dart';

class ConnectivityManager {
  static final ConnectivityManager _singleton = ConnectivityManager._internal();
  late final StreamSubscription<ConnectivityResult> subscription;
  final Connectivity _connectivity = Connectivity();

  factory ConnectivityManager() {
    return _singleton;
  }

  ConnectivityManager._internal();

  final connectivityStream = BehaviorSubject<ConnectivityResult>();

  Function(ConnectivityResult) get connectivityFunction {
    return connectivityStream.sink.add;
  }

  final hasInternetStream = BehaviorSubject<bool>();

  Function(bool) get hasInternetFunction {
    return hasInternetStream.sink.add;
  }

  Future<ConnectivityResult> initConnectivity() async {
    ConnectivityResult result;
    connectivityFunction(ConnectivityResult.none);
    hasInternetFunction(false);

    try {
      result = await _connectivity.checkConnectivity();
      log("initConnectivity() : $result");
    } on PlatformException catch (e) {
      log("Could not able check connectivity status due to : $e");
      return Future.value(ConnectivityResult.none);
    }
    await _updateConnectionStatus(
      result: result,
      isFromInit: true,
    );
    return Future.value(result);
  }

  StreamSubscription<ConnectivityResult> onConnectivityChangedListener() {
    subscription = _connectivity.onConnectivityChanged.listen(
      (ConnectivityResult result) async {
        log("onConnectivityChangedListener() : $result");
        await _updateConnectionStatus(
          result: result,
          isFromInit: false,
        );
      },
    );
    return subscription;
  }

  void disposeListener() {
    subscription.cancel();
    connectivityStream.close();
    return;
  }

  Future<void> _updateConnectionStatus({
    required ConnectivityResult result,
    required bool isFromInit,
  }) async {
    connectivityFunction(result);

    bool value = await hasNetwork();
    log('hasNetwork() : $value');
    hasInternetFunction(value);

    if (isFromInit == false) {
      _onConnectionChangeSnackBar(result: result, hasNetwork: value);
    }
    return Future.value();
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
      _onConnectionChangeSnackBar({
    required ConnectivityResult result,
    required bool hasNetwork,
  }) {
    String message = "";
    switch (result) {
      case ConnectivityResult.bluetooth:
        message = "Device is connected to bluetooth network";
        break;
      case ConnectivityResult.wifi:
        message = "Device is connected to Wi-Fi network";
        break;
      case ConnectivityResult.ethernet:
        message = "Device is connected to ethernet network";
        break;
      case ConnectivityResult.mobile:
        message = "Device connected to mobile network";
        break;
      case ConnectivityResult.none:
        message = "Device is not connected to any network";
        break;
    }

    if (result != ConnectivityResult.none && hasNetwork) {
      return ScaffoldMessenger.of(
              NavigatorService().navigatorKey.currentContext!)
          .showSnackBar(
        SnackBar(
          content: Text(
            "🌐 Connected!\n$message",
          ),
        ),
      );
    } else if (result != ConnectivityResult.none && !hasNetwork) {
      return ScaffoldMessenger.of(
              NavigatorService().navigatorKey.currentContext!)
          .showSnackBar(
        SnackBar(
          content: Text(
            "⚠️ Connected, no internet!\n$message",
          ),
        ),
      );
    } else {
      return ScaffoldMessenger.of(
              NavigatorService().navigatorKey.currentContext!)
          .showSnackBar(
        SnackBar(
          content: Text(
            "🚫 Oops, Connectivity issue!\n$message",
          ),
        ),
      );
    }
  }

  MultiStreamBuilder connectivityBuilder({
    required Widget child,
    required Function onConnectionLostCallBack,
    required Function(String) onConnectionEstablishedCallBack,
  }) {
    return MultiStreamBuilder(
      streams: [
        connectivityStream.stream,
        hasInternetStream.stream,
      ],
      builder: (BuildContext context) {
        if (connectivityStream.value != ConnectivityResult.none &&
            hasInternetStream.value == true) {
          onConnectionEstablishedCallBack(connectivityStream.value.name);
        } else {
          onConnectionLostCallBack();
        }
        return child;
      },
    );
  }

  Future<bool> hasNetwork() async {
    bool isDeviceConnected = await DataConnectionChecker().hasConnection;
    return Future.value(isDeviceConnected);
  }
}
