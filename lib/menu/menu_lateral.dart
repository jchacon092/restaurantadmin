import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:usuariosprueba/add/add_usuario.dart';
import 'package:usuariosprueba/global.dart';
import 'package:usuariosprueba/ui/listview_categoria.dart';
import 'package:usuariosprueba/ui/listview_platillo.dart';

import 'package:usuariosprueba/main.dart';
import 'package:usuariosprueba/ui/listview_platillo.dart';

class MenuLatela extends StatefulWidget{
  @override
  Menu createState(){
    return Menu();
  }
}
class Menu extends State<MenuLatela>{
  bool valorif = true;
  final _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  @override
  final rolus = '${Global.user.Emoji}';
  Widget build(BuildContext context) {
    return  Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              '${Global.user.Nombre} ${Global.user.Apellido} \n${Global.user.Emoji}',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                shadows: [
                  new BoxShadow(
                    color:  Color(0xffA4A4A4),
                    offset: Offset(1.0, 5.0),
                    blurRadius: 3.0,
                  )
                ],
              ),
            ),
            decoration: BoxDecoration(
                color: Colors.lightBlue,
                shape: BoxShape.rectangle,
                image: DecorationImage(
                  image: NetworkImage(Global.user.Image),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  new BoxShadow(
                    color:  Color(0xffA4A4A4),
                    offset: Offset(1.0, 5.0),
                    blurRadius: 3.0,
                  )
                ]
            ),
          ),
          ListTile(
              leading: new Icon(
                Icons.home,
                color: Color(0xff222222),
              ),
              title: Text('Inicio'),
              onTap:() => Navigator.of(context).push(new PageRouteBuilder(
                pageBuilder: (_,__,___) => new UsuariosApp(),
              ))
          ),
          Visibility(
            visible: valorif,
            child: ListTile(
                leading: new Icon(
                  Icons.person,
                  color: Color(0xff222222),
                ),
                title: Text('Registrar'),
                onTap:() =>
                {
                  Global.doc = null,
                  Navigator.of(context).push(new PageRouteBuilder(
                    pageBuilder: (_,__,___) => new AddUsuario(),
                  ))
                }
            ),
          ),
          ListTile(
              leading: new Icon(
                Icons.fastfood,
                color: Color(0xff222222),
              ),
              title: Text('Categorias'),
              onTap:() =>
              {
                Global.doc = null,
                Navigator.of(context).push(new PageRouteBuilder(
                  pageBuilder: (_,__,___) => new ListViewCategoria(),
                ))
              }
          ),
          ListTile(
              leading: new Icon(
                Icons.restaurant,
                color: Color(0xff222222),
              ),
              title: Text('Platillos'),
              onTap:() =>
              {
                Global.doc = null,
                Navigator.of(context).push(new PageRouteBuilder(
                  pageBuilder: (_,__,___) => new ListViewPlatillo(),
                ))
              }
          ),
          ListTile(
              leading: new Icon(
                Icons.add_shopping_cart,
                color: Color(0xff222222),
              ),
              title: Text('Ordenes'),
              onTap:() =>
              {
                //Global.doc = null,
                //Global.user = null,
                // signOut(),
                //Navigator.of(context).pushReplacementNamed('/Login'),

              }
          ),
          ListTile(
              leading: new Icon(
                Icons.close,
                color: Color(0xff222222),
              ),
              title: Text('Salir'),
              onTap:() =>
              {
                Global.doc = null,
                Global.user = null,
                signOut(),
                Navigator.of(context).pushReplacementNamed('/Login'),

              }
          ),
        ],
      ),
    );
  }
  Future<void> signOut() async{
    return Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut()
    ]);
  }
  bool visibilidad(){
    if (rolus == 'Administrador')
      {
        valorif = true;
      }
    else{
      valorif = false;
    }
  }
}