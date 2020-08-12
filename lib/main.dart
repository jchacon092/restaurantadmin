import 'package:flutter/material.dart';
import 'package:usuariosprueba/add/add_usuario.dart';
import 'package:usuariosprueba/list/list_user.dart';
import 'package:usuariosprueba/ui/listview_categoria.dart';
import 'details/details_user.dart';
import 'package:usuariosprueba/ui/listview_platillo.dart';
import 'login.dart';
import 'menu/menu_lateral.dart';
/*
void main() => runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Usuarios',
      theme: ThemeData(
      primarySwatch: Colors.lightBlue
    ),
      home: HomePageMain(),
    )
);
*/

class UsuariosApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Usuarios',
      theme: ThemeData(
          primarySwatch: Colors.deepOrange
      ),
      home: HomePageMain(),
      routes: <String, WidgetBuilder>{
        '/UsuariosApp' : (BuildContext context) =>UsuariosApp(),
        '/Login' : (BuildContext context) =>Login(),
        '/AddUsuario' : (BuildContext context) =>AddUsuario(),
        '/DetailsUsuarios' : (BuildContext context) =>DetailsUsuarios(),
       '/ListViewCategoria' : (BuildContext context) => ListViewCategoria(),
        '/ListViePlatillo' : (BuildContext context) => ListViewPlatillo()
        //'/ListPlatilloPage' : (BuildContext context) => ListPlatilloPage()
      },
    );
  }
}
class HomePageMain extends StatefulWidget{
  @override
  _SearchListState createState() => new _SearchListState();

}
class _SearchListState extends State<HomePageMain> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: new ListUser(),
    );
  }

}