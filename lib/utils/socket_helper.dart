import 'package:denis_kebap/utils/preference_manager.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

class SocketHelper {
  SocketHelper._();

  static IO.Socket? _socket;

  ///
  IO.Socket get socket {
    return _socket!;
  }

  static IO.Socket getInstance() {
    _socket ??= IO.io(
        'https://apiv2.denis-kebap.at',
       // 'wss://108.181.164.22:6441',
        OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect() // disable auto-connection
            .build());

    if (!_socket!.connected) {
      _socket?.connect();
      debugPrint("isConnected = ${_socket?.connected}");


      _socket?.on('onConnection', (data) {
        debugPrint("onConnectionCalled = ${data}");
        _socket?.emit('join',{'userId':PreferenceManager.user?.id});
      }

      );


    }
    debugPrint("SocketConnected = ${_socket?.connected}");
    return _socket!;
  }
}
