import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:usuariosprueba/details/details_user.dart';
import 'package:usuariosprueba/global.dart';
import 'package:usuariosprueba/menu/menu_lateral.dart';
import 'dart:async';
import '../login.dart';
import '../main.dart';
import 'card_foto.dart';


void main()=> runApp(AddUsuario());

class AddUsuario extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Registrar',
      theme: ThemeData(
          primarySwatch: Colors.deepOrange
      ),
      home: HomePage(title: 'Registrar'),
      routes: <String, WidgetBuilder>{
        '/UsuariosApp' : (BuildContext context) =>UsuariosApp(),
        '/Login' : (BuildContext context) =>Login(),
        '/AddUsuario' : (BuildContext context) =>AddUsuario(),
        '/DetailsUsuarios' : (BuildContext context) =>DetailsUsuarios(),
      },
    );
  }
}
class HomePage extends StatelessWidget{
  final String title;
  HomePage({Key key, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(title: Text(title),
          actions: <Widget>[
            InkWell(
              child: Icon(Icons.arrow_back_ios),
              onTap: (){
                Navigator.of(context).pushReplacementNamed('/UsuariosApp');
              },
            ),
            SizedBox(width: 10),
          ],
        ),
        body: UsuarioForm(),
        drawer: MenuLatela()
    );
  }
}
class UsuarioForm extends StatefulWidget{
  @override
  UsuarioFormState createState() {
    // TODO: implement createState
    return UsuarioFormState();
  }
}
class UsuarioFormState extends State<UsuarioForm>{

  final _formKey = GlobalKey<FormState>();
  var email = TextEditingController();
  var password = TextEditingController();
  var nombre = TextEditingController();
  var apellido = TextEditingController();
 List _emoji = ["Administrador", "Operador", "Cliente"];
 List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentEmoji, _image;
  bool _isEnabled = true;
  @override
  void initState(){
  _dropDownMenuItems = getDropDownMenuItems();
 _currentEmoji = _dropDownMenuItems[0].value;
    _image = null;
    _isEnabled = true;

    if(Global.doc != null){
      nombre.text = Global.doc.Nombre;
      apellido.text = Global.doc.Apellido;
      email.text = Global.doc.Email;
     _currentEmoji = Global.doc.Emoji;
      _image = Global.doc.Image;
      password.text = "*******";
      _isEnabled = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0,horizontal: 10.0),
            child:CardFotos(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 10.0),
            child:TextFormField(
              keyboardType: TextInputType.text,
              style: TextStyle(fontSize: 20.0),
              decoration: new InputDecoration(
                labelText: "Enter Nombre",
                fillColor: Colors.white,
                prefixIcon: Icon (Icons.person ),
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  borderSide: new BorderSide(
                  ),
                ),
              ),
              validator: (value){
                if (value.isEmpty){
                  return 'Por favor ingrese el nombre';
                }
              },
              controller: nombre,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 10.0),
            child:TextFormField(
              keyboardType: TextInputType.text,
              style: TextStyle(fontSize: 20.0),
              decoration: new InputDecoration(
                labelText: "Enter Apellido",
                fillColor: Colors.white,
                prefixIcon: Icon (Icons.person ),
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  borderSide: new BorderSide(
                  ),
                ),
              ),
              validator: (value){
                if (value.isEmpty){
                  return 'Por favor ingrese el apellido';
                }
              },
              controller: apellido,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 10.0),
            child:TextFormField(
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(fontSize: 20.0),
              decoration: new InputDecoration(
                labelText: "Enter Email",
                fillColor: Colors.white,
                prefixIcon: Icon (Icons.email ),
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  borderSide: new BorderSide(
                  ),
                ),
              ),
              validator: validateEmail,
              controller: email,
              enabled:  _isEnabled,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 10.0),
            child:TextFormField(
              obscureText: true ,
              style: TextStyle(fontSize: 20.0),
              decoration: new InputDecoration(
                labelText: "Enter passwpord",
                fillColor: Colors.white,
                prefixIcon: Icon (Icons.enhanced_encryption ),
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  borderSide: new BorderSide(
                  ),
                ),
              ),
              validator: validatePassword,
              controller: password,
              enabled:  _isEnabled,
            ),
          ),
         Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 18.0),
            child:DropdownButton(
              value: _currentEmoji,
              items: _dropDownMenuItems,
              onChanged: changedDropDownItem,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0,horizontal: 10.0),
            child: MaterialButton(
              minWidth: 200.0,
              height: 60.0,
              onPressed: (){
                if (_formKey.currentState.validate()){
                 if(Global.doc == null ){
                   registrar(context);
                 }
                 else{
                   actualizar();
                 }
                }
              },
              color: Colors.deepOrange,
              child: setUpButtonChild(),
            ),
          ),
        ],
      ),
    );
  }
  List<DropdownMenuItem<String>> getDropDownMenuItems(){
    List<DropdownMenuItem<String>> items = new List();
    for (String item in _emoji){
      items.add(new DropdownMenuItem(
        value: item,
        child: new Text(
            item,
            style: TextStyle(
              fontSize: 20,
            )
        ),
      ));
    }
    return items;
  }
  void changedDropDownItem(String selectedEmoji){
    setState(() {
      _currentEmoji = selectedEmoji;
    });
  }
  String validateEmail(String value){
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    if (value.isEmpty){
      return 'Por favor ingrese el email';
    }else{
      RegExp regex = new RegExp(pattern);
      if (!regex.hasMatch(value)){
        return 'Enter Valid Email';
      }else{
        return null;
      }
    }
  }
  String validatePassword(String value){
    if(value.isEmpty){
      return 'Por favor ingrese el passwpord';
    }else{
      if(6 > value.length){
        return 'Por favor ingrese un passwpord de 6 caracteres';
      }
    }
  }
  int _state = 0;
  Widget setUpButtonChild(){
    if(_state == 0){
      return new Text(
        "Registrar",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      );
    }else if(_state == 1){
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }else{
      return new Text(
        "Registrar",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      );
    }
  }
  void animateButton(){
    setState(() {
      _state = 1;
    });
    Timer(Duration(seconds: 60),(){
      setState(() {
        _state = 2;
      });
    });
  }
  registrar(BuildContext context) async {
    final _auth = FirebaseAuth.instance;
    final _firebaseStorageRef = FirebaseStorage.instance;
    final db = Firestore.instance;
    var image = CardFoto.galleryFile;
    if(image != null){
      setState(() {
        if (_state == 0) {
          animateButton();
        }
      });
      await _auth.createUserWithEmailAndPassword(
        email: email.text,
        password: password.text,
      ).then((AuthResult user) async {
        final StorageUploadTask task = _firebaseStorageRef.ref().child("Usuarios").child("${email.text}.png").putFile(image);
        if(await task.onComplete != null){
          StorageTaskSnapshot storageTaskSnapshot = await task.onComplete;
          String imgUrl = await storageTaskSnapshot.ref.getDownloadURL();
          DocumentReference ref  =db.collection('Usuarios').document(email.text);
          ref.setData({'Nombre': '${nombre.text}', 'Apellido' : '${apellido.text}',
          'Emoji': '$_currentEmoji', 'Image': '$imgUrl'}).then((onValue) {
            Navigator.of(context).push(new PageRouteBuilder(
                pageBuilder: (_,__,___) => new HomePageMain()
            ));
          });
        }

      }).catchError((e)=>{
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text(e.message))),
      });
    }
  }
  actualizar() async{
     final _firebaseStorageRef = FirebaseStorage.instance;
    final db = Firestore.instance;
    var image = CardFoto.galleryFile;
    DocumentReference ref = db.collection('Usuarios').document(email.text);
      setState(() {
        if (_state == 0) {
          animateButton();
        }
      });
      if(image != null){
        final StorageUploadTask task = _firebaseStorageRef.ref().child("Usuarios").child("${email.text}.png").putFile(image);
        if(await task.onComplete != null){
          StorageTaskSnapshot storageTaskSnapshot = await task.onComplete;
          String imgUrl = await storageTaskSnapshot.ref.getDownloadURL();
          ref.setData({
            'Nombre': '${nombre.text}',
            'Apellido': '${apellido.text}',
            'Emoji': '$_currentEmoji',
            'Image': '$imgUrl'
          }).then((onValue){
            Navigator.of(context).pushReplacementNamed('/UsuariosApp');
          });
        }
      }
      else{
        if(_image != null){
           ref.setData({
            'Nombre': '${nombre.text}',
            'Apellido': '${apellido.text}',
            'Emoji': '$_currentEmoji',
            'Image': '$_image'
          }).then((onValue){
             Navigator.of(context).pushReplacementNamed('/UsuariosApp');
          });
        }
        else{
          Scaffold.of(context).showSnackBar(SnackBar(content: Text('Seleccione una imagen')));
        }
      }
  }
}