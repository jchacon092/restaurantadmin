import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Categoria{
  String _id;
  String _nombrecategoria;
  String _descripcioncategoria;
  String _CategoriaImage;

  Categoria(this._id,this._nombrecategoria,this._descripcioncategoria, this._CategoriaImage);

  Categoria.map(dynamic obj){
    this._nombrecategoria = obj['nombrecategoria'];
    this._descripcioncategoria = obj['descripcioncategoria'];
    this._CategoriaImage = obj['CategoriaImage'];
    }

    String get id => _id;
    String get nombrecategoria => _nombrecategoria;
    String get descripcioncategoria => _descripcioncategoria;
    String get CategoriaImage => _CategoriaImage;

  Categoria.fromSnapshot(DataSnapshot snapshot){
    _id = snapshot.key;
    _nombrecategoria = snapshot.value['nombrecategoria'];
    _descripcioncategoria = snapshot.value['descripcioncategoria'];
    _CategoriaImage = snapshot.value['CategoriaImage'];
  }
}