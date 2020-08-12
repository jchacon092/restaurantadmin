import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:usuariosprueba/model/categoria.dart';
//nuevo para imagenes
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:date_format/date_format.dart';

File image;
String filename;

class CategoriaScreen extends StatefulWidget {
  final Categoria categoria;
  CategoriaScreen(this.categoria);
  @override
  _CategoriaScreenState createState() => _CategoriaScreenState();
}

final categoriaReference = FirebaseDatabase.instance.reference().child('categoria');

class _CategoriaScreenState extends State<CategoriaScreen> {

  List<Categoria> items;

  TextEditingController _nameController;
  TextEditingController _descriptionController;


  //nuevo imagen
  String categoriaImage;

  pickerCam() async {
    File img = await ImagePicker.pickImage(source: ImageSource.camera);
    // File img = await ImagePicker.pickImage(source: ImageSource.camera);
    if (img != null) {
      image = img;
      setState(() {});
    }
  }

  pickerGallery() async {
    File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    // File img = await ImagePicker.pickImage(source: ImageSource.camera);
    if (img != null) {
      image = img;
      setState(() {});
    }
  }

  Widget divider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Container(
        width: 0.8,
        color: Colors.black,
      ),
    );
  }
  //fin nuevo imagen

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController = new TextEditingController(text: widget.categoria.nombrecategoria);
    _descriptionController = new TextEditingController(text: widget.categoria.descripcioncategoria);

    categoriaImage = widget.categoria.CategoriaImage;
    print(categoriaImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Categoria'),
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(

        //height: 570.0,
        padding: const EdgeInsets.all(20.0),
        child: Card(
          child: Center(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    new Container(
                      height: 100.0,
                      width: 100.0,
                      decoration: new BoxDecoration(
                          border: new Border.all(color: Colors.blueAccent)),
                      padding: new EdgeInsets.all(5.0),
                      child: image == null ? Text('Add') : Image.file(image),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 2.2),
                      child: new Container(
                        height: 100.0,
                        width: 100.0,
                        decoration: new BoxDecoration(
                            border: new Border.all(color: Colors.blueAccent)),
                        padding: new EdgeInsets.all(5.0),
                        child: categoriaImage == '' ? Text('Edit') : Image.network(categoriaImage+'?alt=media'),
                      ),
                    ),
                    Divider(),
                    //nuevo para llamar imagen de la galeria o capturarla con la camara
                    new IconButton(
                        icon: new Icon(Icons.camera_alt), onPressed: pickerCam),
                    Divider(),
                    new IconButton(
                        icon: new Icon(Icons.image), onPressed: pickerGallery),
                  ],
                ),
                TextField(
                  controller: _nameController,
                  style:
                  TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
                  decoration: InputDecoration(
                      icon: Icon(Icons.person), labelText: 'Categoria'),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),
                Divider(),

                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),
                Divider(),
                TextField(
                  controller: _descriptionController,
                  style:
                  TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
                  decoration: InputDecoration(
                      icon: Icon(Icons.list), labelText: 'Descripcion'),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),
                Divider(),
                FlatButton(
                    onPressed: () {
                      //nuevo imagen
                      if (widget.categoria.id != null) {
                        var now = formatDate(
                            new DateTime.now(), [yyyy, '-', mm, '-', dd]);
                        var fullImageName =
                            '${_nameController.text}-$now' + '.jpg';
                        var fullImageName2 =
                            '${_nameController.text}-$now' + '.jpg';

                        final StorageReference ref =
                        FirebaseStorage.instance.ref().child(fullImageName);
                        final StorageUploadTask task = ref.putFile(image);

                        var part1 =
                            'https://console.firebase.google.com/project/usuariosprueba-d49fd/storage/usuariosprueba-d49fd.appspot.com/files';//esto cambia segun su firestore

                        var fullPathImage = part1 + fullImageName2;

                        categoriaReference.child(widget.categoria.id).set({
                          'nombrecategoria': _nameController.text,
                          'descripcion': _descriptionController.text,

                          'CategoriaImage': '$fullPathImage'
                        }).then((_) {
                          Navigator.pop(context);
                        });
                      } else {
                        //nuevo imagen
                        var now = formatDate(
                            new DateTime.now(), [yyyy, '-', mm, '-', dd]);
                        var fullImageName =
                            '${_nameController.text}-$now' + '.jpg';
                        var fullImageName2 =
                            '${_nameController.text}-$now' + '.jpg';

                        final StorageReference ref =
                        FirebaseStorage.instance.ref().child(fullImageName);
                        final StorageUploadTask task = ref.putFile(image);

                        var part1 =
                            'https://firebasestorage.googleapis.com/v0/b/usuariosprueba-d49fd.appspot.com/o/'; //esto cambia segun su firestore

                        var fullPathImage = part1 + fullImageName2;

                        categoriaReference.push().set({
                          'nombrecategoria': _nameController.text,
                          'descripcioncategoria': _descriptionController.text,
                          'CategoriaImage': '$fullPathImage'//nuevo imagen
                        }).then((_) {
                          Navigator.pop(context);
                        });
                      }
                    },
                    child: (widget.categoria.id != null)
                        ? Text('Actualizar')
                        : Text('Agregar')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}