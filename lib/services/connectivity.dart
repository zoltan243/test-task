import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'dart:io';

// using the connectivity_plus package this class is used to check for network connection

class InternetConnectivity
{
  InternetConnectivity._constructor();
  static final InternetConnectivity instance = InternetConnectivity._constructor();

  final _connectivity = Connectivity();
  final _streamController = StreamController.broadcast();

  Stream get stream => _streamController.stream;

  void initialise() async
  {
    _connectivity.onConnectivityChanged.listen((result) async
    {
      bool isOnline = false;
      try {
        final addresses = await InternetAddress.lookup('example.com');
        isOnline = addresses.isNotEmpty && addresses[0].rawAddress.isNotEmpty;
      } catch (e) {
        isOnline = false;
      }
      _streamController.add(isOnline);
    });
  }

  void closeStream() => _streamController.close();

  Future<bool> isCurrentlyConnected() async
  {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch(e) {
      return false;
    }
  }
}
