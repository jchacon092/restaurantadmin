import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:usuariosprueba/model/categoria.dart';


class CategoriaInformation extends StatefulWidget {
  final Categoria categoria;
  CategoriaInformation(this.categoria);
  @override
  _CategoriaInformationState createState() => _CategoriaInformationState();
}

final categoriaReference = FirebaseDatabase.instance.reference().child('categoria');

class _CategoriaInformationState extends State<CategoriaInformation> {

  List<Categoria> items;

  String CategoriaImage; //nuevo

  @override
  void initState() {
    super.initState();
    CategoriaImage = widget.categoria.CategoriaImage; //nuevo
    print(CategoriaImage); //nuevo
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informacion de Categorias'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Container(
        height: 800.0,
        padding: const EdgeInsets.all(20.0),
        child: Card(
          child: Center(
            child: Column(
              children: <Widget>[
                new Text("Nombre : ${widget.categoria.nombrecategoria}",
                  style: TextStyle(fontSize: 18.0),),
                Padding(padding: EdgeInsets.only(top: 8.0),),
                Divider(),
                new Text("Descripcion : ${widget.categoria.descripcioncategoria}",
                  style: TextStyle(fontSize: 18.0),),
                Padding(padding: EdgeInsets.only(top: 8.0),),
                Divider(),
                Container(
                  height: 300.0,
                  width: 300.0,
                  child: Center(
                    child: CategoriaImage == ''
                        ? Text('No Image')
                        : Image.network(CategoriaImage +
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
