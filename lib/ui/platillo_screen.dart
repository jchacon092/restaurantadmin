import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:usuariosprueba/model/platillo.dart';
//nuevo para imagenes
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:date_format/date_format.dart';

File image;
String filename;

class PlatilloScreen extends StatefulWidget {
  final Platillo platillo;
  PlatilloScreen(this.platillo);
  @override
  _PlatilloScreenState createState() => _PlatilloScreenState();
}

final platilloReference = FirebaseDatabase.instance.reference().child('platillo');

class _PlatilloScreenState extends State<PlatilloScreen> {

  List<Platillo> items;
  TextEditingController _nameController;
  TextEditingController _precioController;
  TextEditingController _descriptionController;


  //nuevo imagen
  String platilloImage;

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
    _nameController = new TextEditingController(text: widget.platillo.nombreplatillo);
    //var preciost = double.parse(widget.platillo.precioplatillo.toString());
    //_precioController = new TextEditingController(text: widget.platillo.precioplatillo.toString());
    _precioController = new TextEditingController(text: widget.platillo.precioplatillo);
    _descriptionController = new TextEditingController(text: widget.platillo.descripcionplatillo);

    platilloImage = widget.platillo.PlatilloImage;
    print(platilloImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Platillos'),
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
                        child: platilloImage == '' ? Text('Edit') : Image.network(platilloImage+'?alt=media'),
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
                      icon: Icon(Icons.fastfood), labelText: 'Nombre del platillo'),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),


                Divider(),
                TextField(
                  controller: _precioController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  style:
                  TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
                  decoration: InputDecoration(
                      icon: Icon(Icons.monetization_on), labelText: 'Precio Quetzales'),
                ),
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
                      if (widget.platillo.id != null) {
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

                        platilloReference.child(widget.platillo.id).set({
                          'nombreplatillo': _nameController.text,
                          'precioplatillo' : _precioController.text,
                          'descripcionplatillo': _descriptionController.text,
                          'PlatilloImage': '$fullPathImage'
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

                        platilloReference.push().set({
                          'nombreplatillo': _nameController.text,
                          'precioplatillo' : _precioController.text,
                          'descripcionplatillo': _descriptionController.text,
                          'PlatilloImage': '$fullPathImage'//nuevo imagen
                        }).then((_) {
                          Navigator.pop(context);
                        });
                      }
                    },
                    child: (widget.platillo.id != null)
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