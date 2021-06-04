import 'dart:developer';

import 'package:band_names/models/band.dart';
import 'package:band_names/services/socket_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [];

  @override
  void initState() {
    final socketServices = Provider.of<SocketServices>(context, listen: false);

    socketServices.socket.on('active-bands', _handleActiveBands);
    super.initState();
  }

  _handleActiveBands(dynamic payload) {
    this.bands = (payload as List).map((band) => Band.fromMap(band)).toList();
    setState(() {});
  }

  @override
  void dispose() {
    final socketServices = Provider.of<SocketServices>(context, listen: false);
    socketServices.socket.off('active-bands');

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketServices = Provider.of<SocketServices>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Band Names',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Container(
              child: (socketServices.serverStatus == ServerStatus.OnLine)
                  ? Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                    )
                  : Icon(
                      Icons.offline_share_outlined,
                      color: Colors.red,
                    ))
        ],
      ),
      body: Column(
        children: [
          _showGrap(),
          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (context, i) {
                return _bandTile(bands[i]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addnewBand,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _bandTile(Band band) {
    final socketServices = Provider.of<SocketServices>(context, listen: false);
    return Dismissible(
      key: Key(band.id!),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) => socketServices.socket.emit('delete-band', {'id': band.id}),
      background: Container(
        child: Text('Delete Band'),
        color: Colors.red,
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(band.name!.substring(0, 2)),
        ),
        title: Text(band.name.toString()),
        trailing: Text(
          '${band.votes}',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
        ),
        onTap: () {
          socketServices.socket.emit('vote-band', {'id': band.id});
          // print(band.id);
          // enviar voto
        },
      ),
    );
  }

  addnewBand() {
    final textController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("New Band Name:"),
        content: TextField(
          controller: textController,
        ),
        actions: [
          MaterialButton(
            child: Text('Add'),
            elevation: 5,
            textColor: Colors.blue,
            onPressed: () => addBandToList(textController.text),
          )
        ],
      ),
    );
  }

  addBandToList(String name) {
    if (name.length > 1) {
      final socketServices = Provider.of<SocketServices>(context, listen: false);
      socketServices.socket.emit('add-band', {'name': name});
    }

    Navigator.pop(context);
  }

  _showGrap() {
    Map<String, double> dataMap = Map();

    for (var i = 0; i < bands.length; i++) {
      dataMap.putIfAbsent(bands[i].name.toString(), () => bands[i].votes!.toDouble());
    }

    //{'Queen': 0.0, 'maroon5': 3.0, 'Codpaly': 5.0}
    if (dataMap.keys.length == 0) return CircularProgressIndicator();

    return PieChart(dataMap: dataMap);
  }
}
