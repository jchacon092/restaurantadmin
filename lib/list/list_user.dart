import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:usuariosprueba/details/details_user.dart';
import 'package:usuariosprueba/list/usuario.dart';
import 'package:usuariosprueba/menu/menu_lateral.dart';
import '../global.dart';

class ListUser extends StatefulWidget{
  @override
  ListUserState createState(){
    return ListUserState();
  }
}

class ListUserState  extends State<ListUser>{
  final _db = Firestore.instance;
  String name;
  List<Usuario> listUser;
  final GlobalKey<RefreshIndicatorState> _refreshKey =  GlobalKey<RefreshIndicatorState>();
  @override
  void initState(){
    super.initState();
    _isSearching = false;
    listUser = List<Usuario>();
    _users = SizedBox();
    readData();
  }
  Widget appBarTitle = Text(
    "Search user",
    style: TextStyle(color: Colors.white),
  );
  Icon icon = Icon(
    Icons.search,
    color: Colors.white,
  );
  bool _isSearching;
  Widget _users;
  final TextEditingController _controller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle,
        actions: <Widget>[
          IconButton(
              icon: icon,
              onPressed:(){
                setState(() {
                  if(this.icon.icon == Icons.search){
                    this.icon = Icon(
                      Icons.close,
                      color: Colors.white,
                    );
                    this.appBarTitle = TextField(
                      controller: _controller,
                      style: new TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search, color: Colors.white),
                          hintText: "Search...",
                          hintStyle: TextStyle(color: Colors.white)
                      ),
                      onChanged: searchOperation,
                    );
                    _handleSearchStart();
                  }else{
                    searchOperation(null);
                    _handleSearchEnd();
                  }
                });
              }
          ),
        ],
      ),
      drawer: MenuLatela(
        
      ),
        body: RefreshIndicator(
          key: _refreshKey,
          onRefresh: readData,
          child:  ListView(
            children: <Widget>[
              _users
            ],
          ),
        ),

    );
  }
  Container buildItem(Usuario doc){
    return new Container(
      height: 120.0,
      margin: const EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 5.0,
      ),
        child: new Stack(
          children: <Widget>[
            card(doc),
            thumbnail(doc)
          ],
        )
    );
  }
  Future<void> readData()async{
    Stream<QuerySnapshot> qs = _db.collection('Usuarios').snapshots();
    qs.listen((QuerySnapshot onData)=>{
      listUser.clear(),
      onData.documents.map((doc)=>{
        listUser.add(Usuario(
            doc.data['Apellido'],
            doc.data['Emoji'],
            doc.data['Nombre'],
           // doc.data['Rol'],
            doc.data['Image'],
            doc.documentID
        )),
        }).toList(),
      userList(null),
    });
  }

  GestureDetector card(Usuario doc){
    return new GestureDetector(
      onTap: () =>{
        Global.doc = doc,
        Navigator.of(context).push(new PageRouteBuilder(
          pageBuilder: (_, __, ___) => new DetailsUsuarios(),
        ))
      },
      child: new Container(
        height: 124.0,
        margin: new EdgeInsets.only(left: 46.0),
        decoration: new BoxDecoration(
          color: new Color(0xFFD84315),
          borderRadius: new BorderRadius.circular(8.0),
          boxShadow: <BoxShadow>[
            new BoxShadow(
              color: Colors.black38,
              blurRadius: 5.0,
              offset: new Offset(0.0, 5.0),
            ),
          ]
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 60.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                      '${doc.Nombre}',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox( width: 10.0),
                  Text(
                    '${doc.Apellido}',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),


                ],
              ),
              Text(
                '${doc.Emoji}',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Container thumbnail(Usuario doc){
    return Container(
      alignment: FractionalOffset.centerLeft,
      child: new Container(
        height: 90.0,
        width: 90.0,
        decoration: new BoxDecoration(
          color: Colors.pink,
          shape: BoxShape.rectangle,
          borderRadius: new BorderRadius.circular(50.0),
          image: DecorationImage(
            image: NetworkImage(doc.Image),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            new BoxShadow(
              //SOMBRA
              color: Color(0xffA4A4A4),
              offset: Offset(1.0, 5.0),
              blurRadius: 3.0,
            ),
          ],
        ),
      ),
    );
  }
  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }
  void _handleSearchEnd(){
    setState(() {
      this.icon = Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = Text(
        "Search user",
        style: new TextStyle(color: Colors.white),
      );
      _isSearching = false;
      _controller.clear();

    });
  }
  void searchOperation(String searchText){
    if(_isSearching){
      userList(searchText);
    }
  }
  void userList(String searchText){
    setState(() {
      if(listUser != null){
        if(searchText == null || searchText == ""){
          _users = Column(
              children: listUser.map((user) => buildItem(user)).toList()
          );

        }else{
          var usuario = listUser.where((item)=> item.Nombre.startsWith(searchText)).toList();
          if(0 < usuario.length){
            _users =  Column(
                children: usuario.map((user) => buildItem(user)).toList()
            );
          }else{
            _users = SizedBox();
          }
        }
      }else{
        _users = SizedBox();
      }
    });

  }
}