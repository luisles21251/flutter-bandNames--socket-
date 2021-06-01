

import 'package:band_names/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id : '1', name: 'Moderato', votes: 8 ),
    Band(id : '1', name: 'Canto del loco', votes: 5),
    Band(id : '1', name: 'Mago de Oz', votes: 4 ),
    Band(id : '1', name: 'Pandx', votes: 7 ),
    Band(id : '1', name: 'Molotov', votes: 8 ),
    Band(id : '1', name: 'El cuarteto de Nos', votes: 9 ),
    Band(id : '1', name: 'aterciopelados', votes: 6 ),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Band Names', style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount:bands.length ,
        itemBuilder: ( context, i) {
        return _bandTile(bands[i]);
        }, ),
      floatingActionButton: FloatingActionButton(
        onPressed: addnewBand,
        child: Icon(Icons.add),
      ),
    );
  }
  Widget _bandTile(Band band){
    return Dismissible(
      key: Key(band.id!),
      direction:DismissDirection.startToEnd,
      onDismissed: (direction ){
        print('direction $direction');
        print('id; ${band.id}');
      },
      background: Container(
        child: Text('Delete Band'),
        color: Colors.red,

      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(band.name!.substring(0,2)),
        ),
        title: Text(band.name.toString()),
        trailing: Text('${band.votes}', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),),
      ),
    );
  }


  addnewBand(){
    final textController = TextEditingController();

    showDialog(context:context ,
        builder:(_){
      return  AlertDialog(
        title: Text("New Band Name:"),
        content: TextField(
          controller: textController,
        ),
        actions: [
          MaterialButton(
              child:Text('Add') ,
              elevation: 5,
              textColor: Colors.blue,
              onPressed:()=> addBandToList(textController.text),)
        ],
      );
        });
  }

addBandToList (String name){
    print(name);
    if( name.length >1){
    this.bands.add(Band(id: DateTime.now().toString() , name: name, votes: 0, ));
    setState(() {

    });
    } Navigator.pop(context);

}


}
