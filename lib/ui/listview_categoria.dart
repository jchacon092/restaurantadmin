import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'package:usuariosprueba/ui/categoria_screen.dart';
import 'package:usuariosprueba/ui/categoria_information.dart';
import 'package:usuariosprueba/model/categoria.dart';

class ListViewCategoria extends StatefulWidget {
  @override
  _ListViewCategoriaState createState() => _ListViewCategoriaState();
}

final categoriaReference = FirebaseDatabase.instance.reference().child('categoria');

class _ListViewCategoriaState extends State<ListViewCategoria> {


  List<Categoria> items;
  StreamSubscription<Event> _onCategoriaAddedSubscription;
  StreamSubscription<Event> _onCategoriaChangedSubscription;

    void _onCategoriaAdded(Event event) {
      setState(() {
        items.add(new Categoria.fromSnapshot(event.snapshot));
      });
    }

        void _onCategoriaUpdate(Event event) {
      var oldCategoriaValue =
      items.singleWhere((categoria) => categoria.id == event.snapshot.key);
      setState(() {
        items[items.indexOf(oldCategoriaValue)] =
        new Categoria.fromSnapshot(event.snapshot);
      });
    }

    
    void _navigateToCategoriaInformation(BuildContext context,
        Categoria categoria) async {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CategoriaScreen(categoria)),
      );
    }

    void _navigateToCategoria(BuildContext context, Categoria categoria) async {
      await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CategoriaInformation(categoria)),
      );
    }

            void _deleteCategoria(BuildContext context, Categoria categoria,
        int position) async {
      await categoriaReference.child(categoria.id).remove().then((_) {
        setState(() {
          items.removeAt(position);
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
                    _deleteCategoria(context, items[position], position,),
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
    items = new List();
    _onCategoriaAddedSubscription =
        categoriaReference.onChildAdded.listen(_onCategoriaAdded);
    _onCategoriaChangedSubscription =
        categoriaReference.onChildChanged.listen(_onCategoriaUpdate);
  }

  void _createNewCategoria(BuildContext context) async {
      await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                CategoriaScreen(Categoria(null, '', '', ''))),
      );
    }

  @override
  void dispose() {
    super.dispose();
    _onCategoriaAddedSubscription.cancel();
    _onCategoriaChangedSubscription.cancel();
  }

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: Text('Listado de categorias'),
            centerTitle: true,
            backgroundColor: Colors.deepOrange,
          ),
          body: Center(
            child: ListView.builder(
                itemCount: items.length,
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
                                child: '${items[position].CategoriaImage}' == ''
                                    ? Text('No image')
                                    : Image.network(
                                  '${items[position].CategoriaImage}' +
                                      '?alt=media',
                                  fit: BoxFit.fill,
                                  height: 57.0,
                                  width: 57.0,
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                    title: Text(
                                      '${items[position].nombrecategoria}',
                                      style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontSize: 21.0,
                                      ),
                                    ),
                                    subtitle: Text(
                                      '${items[position].descripcioncategoria}',
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 21.0,
                                      ),
                                    ),
                                    onTap: () =>
                                        _navigateToCategoriaInformation(
                                            context, items[position])),
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
                                      _navigateToCategoria(
                                          context, items[position])),
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
              'Agregar Categoria',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            backgroundColor: Colors.deepOrange,
            onPressed: () => _createNewCategoria(context),
          ),
        ),
      );
    }

    //nuevo para que pregunte antes de eliminar un registro



}