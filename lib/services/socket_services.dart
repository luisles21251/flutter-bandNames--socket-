import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:flutter/widgets.dart';

enum ServerStatus {
  OnLine,
  OffLine,
  Connecting,
}

class SocketServices with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;

 late  IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;
IO.Socket get socket => this._socket;


 SocketServices() {
   this._initConfig();
  }

  void _initConfig() {



    // Dart client
   this._socket = IO.io('http://192.168.20.21:3010/', {
      'transports': ['websocket'],
      'autoConnect': true,
    });

   this._socket.on('connect', (_) {
      this._serverStatus = ServerStatus.OnLine;
      notifyListeners();
    });

    this._socket.on('disconnect', (_) {
      this._serverStatus = ServerStatus.OffLine;
      notifyListeners();
    });
  }
}
