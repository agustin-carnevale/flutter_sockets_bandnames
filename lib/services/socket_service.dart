import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket => this._socket;
  Function get emit => this._socket.emit;
  Function get listen => this._socket.on;
  Function get stopListening => this._socket.off;

  SocketService() {
    this._initConfig();
  }

  void _initConfig() {
    this._socket = IO.io('https://bandnames-my-socket-server.herokuapp.com', {
      'transports': ['websocket'],
      'autoConnect': true,
    });

    this._socket.on('connect', (_) {
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });
    this._socket.on('disconnect', (_) { 
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
    this._socket.on('message', (payload) { 
      print('new message: $payload');
    });
  }
}
