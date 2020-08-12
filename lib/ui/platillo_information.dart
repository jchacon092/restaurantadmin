import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:usuariosprueba/model/platillo.dart';


class PlatilloInformation extends StatefulWidget {
  final Platillo platillo;
  PlatilloInformation(this.platillo);
  @override
  _PlatilloInformationState createState() => _PlatilloInformationState();
}

final platilloReference = FirebaseDatabase.instance.reference().child('platillo');

class _PlatilloInformationState extends State<PlatilloInformation> {

  List<Platillo> items;

  String PlatilloImage; //nuevo

  @override
  void initState() {
    super.initState();
    PlatilloImage = widget.platillo.PlatilloImage; //nuevo
    print(PlatilloImage); //nuevo
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informacion de platillos'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Container(
        height: 800.0,
        padding: const EdgeInsets.all(20.0),
        child: Card(
          child: Center(
            child: Column(
              children: <Widget>[
                new Text("Nombre : ${widget.platillo.nombreplatillo}",
                  style: TextStyle(fontSize: 18.0),),
                Padding(padding: EdgeInsets.only(top: 8.0),),
                Divider(),
                Divider(),
                new Text("Precio : Q. ${widget.platillo.precioplatillo}",
                  style: TextStyle(fontSize: 18.0),),
                Padding(padding: EdgeInsets.only(top: 8.0),),
                Divider(),
                new Text("Descripcion : ${widget.platillo.descripcionplatillo}",
                  style: TextStyle(fontSize: 18.0),),
                Padding(padding: EdgeInsets.only(top: 8.0),),
                Divider(),
                Container(
                  height: 300.0,
                  width: 300.0,
                  child: Center(
                    child: PlatilloImage == ''
                        ? Text('No Image')
                        : Image.network(PlatilloImage +
                        '?alt=media'), //nuevo para traer la imagen de firestore
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
