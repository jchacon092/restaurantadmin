import 'package:flutter/material.dart';

class LoginSummary extends StatelessWidget {
  final bool horizontal;


  LoginSummary ({this.horizontal});

  @override
  Widget build(BuildContext context) {

    
  final imageThumbnail = Container(
    margin: EdgeInsets.symmetric(
        vertical: 16.0
    ),
    alignment: horizontal ? FractionalOffset.centerLeft : FractionalOffset.center,
    child: Container(
      height: 150.0,
      width: 150.0,
      decoration: BoxDecoration(
        color: Colors.pink,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(60.0),
        image: DecorationImage(
          image: AssetImage("assets/logo_italia.jpg"),
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
  final userCardContent = Container(
    margin: EdgeInsets.fromLTRB(horizontal ? 76.0 : 16.0, horizontal ? 16.0 : 42.0, 16.0, 16.0),
    constraints: BoxConstraints.expand(),
    child: Column(
      crossAxisAlignment: horizontal ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: <Widget>[
        Container(height: 70.0),
        Text(
          "Login Prototipo",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
  final usertCard = Container(
    child: userCardContent,
    height: horizontal ? 124.0 : 154.0,
    margin: horizontal
        ? EdgeInsets.only(left: 46.0)
        : EdgeInsets.only(top: 72.0),
    decoration: BoxDecoration(
      color: Color(0xFFD84315),
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(8.0),
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: Color(0xffA4A4A4),
          blurRadius: 5.0,
          offset: Offset(0.0, 5.0),
        ),
      ],
    ),
  );
  return Container(
    margin: const EdgeInsets.symmetric(
      vertical: 16.0,
      horizontal: 24.0,
    ),
    child: Stack(
      children: <Widget>[
        usertCard,
        imageThumbnail
      ],
    ),
  );
  }

}