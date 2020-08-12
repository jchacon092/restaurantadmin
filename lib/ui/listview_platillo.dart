import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'package:usuariosprueba/ui/platillo_screen.dart';
import 'package:usuariosprueba/ui/platillo_information.dart';
import 'package:usuariosprueba/model/platillo.dart';

class ListViewPlatillo extends StatefulWidget {
  @override
  _ListViePlatilloState createState() => _ListViePlatilloState();
}

final platilloReference = FirebaseDatabase.instance.reference().child('platillo');

class _ListViePlatilloState extends State<ListViewPlatillo> {


  List<Platillo> items1;
  StreamSubscription<Event> _onPlatilloAddedSubscription;
  StreamSubscription<Event> _onPlatilloChangedSubscription;

  void _onPlatilloAdded(Event event) {
    setState(() {
      items1.add(new Platillo.fromSnapshot(event.snapshot));
    });
  }

  void _onPlatilloUpdate(Event event) {
    var oldPlatilloValue =
    items1.singleWhere((platillo) => platillo.id == event.snapshot.key);
    setState(() {
      items1[items1.indexOf(oldPlatilloValue)] =
      new Platillo.fromSnapshot(event.snapshot);
    });
  }


  void _navigateToPlatilloInformation(BuildContext context,
      Platillo platillo) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PlatilloScreen(platillo)),
    );
  }

  void _navigateToPlatillo(BuildContext context, Platillo platillo) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PlatilloInformation(platillo)),
    );
  }

  void _deletePlatillo(BuildContext context, Platillo platillo,
      int position) async {
    await platilloReference.child(platillo.id).remove().then((_) {
      setState(() {
        items1.removeAt(position);
        Navigator.of(context).pop();
      });
    });
  }

  void _showDialog(context, position) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text('Are you sure you want to delete this item?'),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.purple,
              ),
              onPressed: () =>
                  _deletePlatillo(context, items1[position], position,),
            ),
            new FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }




  @override
  void initState() {
    super.initState();
    items1 = new List();
    _onPlatilloAddedSubscription =
        platilloReference.onChildAdded.listen(_onPlatilloAdded);
    _onPlatilloChangedSubscription =
        platilloReference.onChildChanged.listen(_onPlatilloUpdate);
  }

  void _createNewPlatillo(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              PlatilloScreen(Platillo(null, '', '', '', ''))),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _onPlatilloAddedSubscription.cancel();
    _onPlatilloChangedSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Listado de platillos'),
          centerTitle: true,
          backgroundColor: Colors.deepOrange,
        ),
        body: Center(
          child: ListView.builder(
              itemCount: items1.length,
              padding: EdgeInsets.only(top: 3.0),
              itemBuilder: (context, position) {
                return Column(
                  children: <Widget>[
                    Divider(
                      height: 1.0,
                    ),
                    Container(
                      padding: new EdgeInsets.all(3.0),
                      child: Card(
                        child: Row(
                          children: <Widget>[
                            //nuevo imagen
                            new Container(
                              padding: new EdgeInsets.all(5.0),
                              child: '${items1[position].PlatilloImage}' == ''
                                  ? Text('No image')
                                  : Image.network(
                                '${items1[position].PlatilloImage}' +
                                    '?alt=media',
                                fit: BoxFit.fill,
                                height: 57.0,
                                width: 57.0,
                              ),
                            ),
                            Expanded(
                              child: ListTile(
                                  title: Text(
                                    '${items1[position].nombreplatillo}',
                                    style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontSize: 21.0,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${items1[position].descripcionplatillo}',
                                    style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontSize: 21.0,
                                    ),
                                  ),
                                  onTap: () =>
                                      _navigateToPlatilloInformation(
                                          context, items1[position])),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () => _showDialog(context, position),
                            ),

                            //onPressed: () => _deleteProduct(context, items[position],position)),
                            IconButton(
                                icon: Icon(
                                  Icons.remove_red_eye,
                                  color: Colors.blueAccent,
                                ),
                                onPressed: () =>
                                    _navigateToPlatillo(
                                        context, items1[position])),
                          ],
                        ),
                        color: Colors.white,
                      ),
                    ),
                  ],
                );
              }),
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: Text(
            'Agregar Platillos',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          backgroundColor: Colors.deepOrange,
          onPressed: () => _createNewPlatillo(context),
        ),
      ),
    );
  }

//nuevo para que pregunte antes de eliminar un registro



}