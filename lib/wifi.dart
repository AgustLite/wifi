import 'dart:async';

import 'package:flutter/services.dart';

enum WifiState { error, success, already }

class Wifi {
  static const MethodChannel _channel = const MethodChannel('plugins.ly.com/wifi');

  static Future<String> get ssid async {
    return await _channel.invokeMethod('ssid');
  }

  static Future<int> get level async {
    return await _channel.invokeMethod('level');
  }

  static Future<String> get ip async {
    return await _channel.invokeMethod('ip');
  }

  static Future<List<WifiResult>> list(String key) async {
    final Map<String, dynamic> params = {
      'key': key,
    };
    var results = await _channel.invokeMethod('list', params);
    List<WifiResult> resultList = [];
    for (int i = 0; i < results.length; i++) {
      resultList.add(WifiResult(results[i]['ssid'], results[i]['level']));
    }
    print("Data -> " + results.toString());
    return resultList;
  }

  static Future<String> getListESP() async {
    String result = await _channel.invokeMethod("getListESP");
    if(result != null) {
        if(result.isEmpty) {
          return "Error";
        }
    }
    return result;
  }

  static Future<WifiState> connection(String ssid, String password) async {
    final Map<String, dynamic> params = {
      'ssid': ssid,
      'password': password,
    };
    int state = await _channel.invokeMethod('connection', params);
    switch (state) {
      case 0:
        return WifiState.error;
      case 1:
        return WifiState.success;
      case 2:
        return WifiState.already;
      default:
        return WifiState.error;
    }
  }

  static Future<WifiState> connectToOpenWifi(String ssid) async {
    final Map<String, dynamic> params = {
      'ssid':ssid
    };
    int state = await _channel.invokeMethod('openConnection', params);
    switch (state) {
      case 0:
        return WifiState.error;
      case 1:
        return WifiState.success;
      case 2:
        return WifiState.already;
      default:
        return WifiState.error;
    }
  }

  static Future<String> getGateway() async {
    String gateway = await _channel.invokeMethod("getGateway");
    if(gateway.isEmpty) {
      return "Error";
    }
    return gateway;
  }

  static Future<String> getListWifi() async {
    String result = await _channel.invokeMethod("getListWifi");
    if(result != null) {
        if(result.isEmpty) {
          return "Error";
        }
    }
    return result;
  }

  static Future<WifiState> forgetNetwork(String ssid) async {
    int state = await _channel.invokeMethod("forgetNetwork", {'ssid':ssid});
    switch (state) {
      case 0:
        return WifiState.error;
      case 1:
        return WifiState.success;
      case 2:
        return WifiState.already;
      default:
        return WifiState.error;
    }
  }

  static Future<WifiState> connectToNetwork(String ssid, String pass) async {
    var params = {
      'ssid':ssid.trim(),
      'pass':pass.trim(),
    };
    int state = await _channel.invokeMethod("connectToNetwork", params);
    switch (state) {
      case 0:
        return WifiState.error;
      case 1:
        return WifiState.success;
      case 2:
        return WifiState.already;
      default:
        return WifiState.error;
    }
  }
}

class WifiResult {
  String ssid;
  int level;

  WifiResult(this.ssid, this.level);
}
