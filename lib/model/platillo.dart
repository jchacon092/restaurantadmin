import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Platillo{
  String _id;
  String _nombreplatillo;
  String _precioplatillo;
  String _descripcionplatillo;
  String _PlatilloImage;

  Platillo(this._id,this._nombreplatillo,this._precioplatillo, this._descripcionplatillo, this._PlatilloImage);

  Platillo.map(dynamic obj){
    this._nombreplatillo = obj['nombreplatillo'];
    this._precioplatillo = obj['precioplatillo'];
    this._descripcionplatillo = obj['descripcionplatillo'];
    this._PlatilloImage = obj['PlatilloImage'];
  }

  String get id => _id;
  String get nombreplatillo => _nombreplatillo;
  String get precioplatillo => _precioplatillo;
  String get descripcionplatillo  => _descripcionplatillo;
  String get PlatilloImage => _PlatilloImage;

  Platillo.fromSnapshot(DataSnapshot snapshot){
    _id = snapshot.key;
    _nombreplatillo = snapshot.value['nombreplatillo'];
    _precioplatillo = snapshot.value['precioplatillo'];
    _descripcionplatillo = snapshot.value['descripcionplatillo'];
    _PlatilloImage = snapshot.value['PlatilloImage'];
  }
}