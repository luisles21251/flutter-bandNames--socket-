import 'package:band_names/services/socket_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final socketServices = Provider.of<SocketServices>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text('ServerStatus: ${socketServices.serverStatus}')],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          socketServices.socket.emit('nuevo-mensaje', {
            'nombre': 'Flutter',
            'mensaje': 'hola desde flutter'});
        },
        child: Icon(Icons.message),
      ),
    );
  }
}
