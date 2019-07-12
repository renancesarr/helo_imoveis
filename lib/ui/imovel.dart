

import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:helo_imoveis/objects/imovel.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helo_imoveis/objects/config.dart';


class ImovelPage extends StatefulWidget{

  Imovel imovel;

  ImovelPage({this.imovel});
  _ImovelPageState createState() => _ImovelPageState();

}

class _ImovelPageState extends State<ImovelPage>{
  List<Asset> listImages = List<Asset>();
  String _error  = "";
  bool alugar = true;
  List<String> listCategoria;
  Config configuracao;
  String _categoria = "Selecione Tipo";
  String _alugar ="Selecione Negocio";
  IconData _iconAlugar = Icons.add;
  IconData _IconCategoria = Icons.add;

  Future<Map<String, dynamic >> _configuracao() async{
    DocumentSnapshot snapshot = await Firestore.instance.collection("config").document("-LjJPZoEkq-sdDWahI5T").get();
    Map<String, dynamic> json = snapshot.data;
    configuracao = new Config.fromMap(json);
    return json;
  }

  @override
  void initState(){
    super.initState();

    if(widget.imovel == null){
      widget.imovel = new Imovel();
    }else{
      _categoria = widget.imovel.tipoImovel;
    }
  }
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[200],
        title: widget.imovel.logadouro == null ? Text("Novo Imovel") : Text("Editar Imovel"),
        centerTitle: true,
        
      ),
      floatingActionButton: FloatingActionButton(

        onPressed: (){
          loadAssets();
        },
        child:Icon(Icons.backup), //Text("SALVAR"), ,
        backgroundColor: Colors.pinkAccent,
      ),
      body: Column(
           children: <Widget>[
             Container(
                height: 200,
                padding: EdgeInsets.all(10.0),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.all(10.0),
                  itemCount: listImages.length+1,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: (context, index){
                    return _imagemCard(context, index);
                  },
                ),
             ),
             Container(
               padding: EdgeInsets.all(20),
               child: Center(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: <Widget>[
                      Card(
                        child:Row(
                          children: <Widget>[
                            FlatButton(
                              child: Text(_alugar, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold)),
                              textColor: Colors.black,
                              disabledColor: Colors.grey,
                              disabledTextColor: Colors.black,
                              splashColor: Colors.pinkAccent,
                              onPressed: () {
                                 _showAlugar(context);
                              }
                            ),
                            //Icon(_iconAlugar),
                          ],
                        ), 
                      ),
                      Card(
                        child:Row(
                          children: <Widget>[
                            FlatButton(
                              child: Text(_categoria, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold)),
                              textColor: Colors.black,
                              disabledColor: Colors.grey,
                              disabledTextColor: Colors.black,
                              splashColor: Colors.pinkAccent,
                              onPressed: () {
                                _showCategorias(context);
                              }
                            ),
                            //Icon(_IconCategoria),
                          ],
                        ), 
                      ),
                    ],
                  ),
                ),
              ),
             
            Text(_error),
          ],
        ),
    );
  }

  Widget _imagemCard(BuildContext context, int index){
    print(index);print(listImages.length+1);
    if(index == listImages.length){
      return Container(
        height: 100,
        width: 100,
        child:Card(
          child:IconButton(
            onPressed: (){
              loadAssets();
            },
            iconSize: 70,
            icon: Icon(Icons.add_a_photo),
          ) ,
        )
      );
    }else{
      Asset asset = listImages[index];
      return GestureDetector(
        child: Card(
          child: AssetThumb(
            asset: asset,
            width: 100,
            height: 100,
          )
        ),
      );
    }
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
          maxImages: 10,
          enableCamera: true,
          selectedAssets: listImages,
          cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
          materialOptions: MaterialOptions(
            actionBarColor: "#ce3b6b",
            actionBarTitle: "Imagens",
            allViewTitle: "Todas as Fotos",
            selectCircleStrokeColor: "#000000",
          ));
    } on PlatformException catch (e) {
      error = e.message;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    setState(() {
      listImages = resultList;
      _error = error;
    });
  }


  void _showCategorias(BuildContext context){
    showModalBottomSheet(
        context: context,
        builder: (context){
          return BottomSheet(
            onClosing: (){},
            builder: (context){
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text("Casa",
                          style: TextStyle(color: Colors.red, fontSize: 18.0),
                        ),
                        onPressed: (){
                          widget.imovel.setCategoria("casa");
                          setState(() {
                            _categoria = "Casa";
                            _IconCategoria = Icons.edit;
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text("Apartamento",
                          style: TextStyle(color: Colors.red, fontSize: 18.0),
                        ),
                        onPressed: (){
                          widget.imovel.setCategoria("apartamento");
                          setState(() {
                            _categoria = "Apartamento";
                            _IconCategoria = Icons.edit;
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text("Fazenda",
                          style: TextStyle(color: Colors.red, fontSize: 18.0),
                        ),
                        onPressed: (){
                          widget.imovel.setCategoria("fazenda");
                          setState(() {
                             _categoria = "Fazenda";
                             _IconCategoria = Icons.edit;
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
    );
  }
  void _showAlugar(BuildContext context){
    showModalBottomSheet(
        context: context,
        builder: (context){
          return BottomSheet(
            onClosing: (){},
            builder: (context){
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text("Alugar",
                          style: TextStyle(color: Colors.red, fontSize: 18.0),
                        ),
                        onPressed: (){
                          widget.imovel.setAlugar("alugar");
                          setState(() {
                            _alugar = "Alugar";
                            _iconAlugar = Icons.edit;
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text("Vender",
                          style: TextStyle(color: Colors.red, fontSize: 18.0),
                        ),
                        onPressed: (){
                          widget.imovel.setAlugar("vender");
                          setState(() {
                            _alugar = "Vender";
                            _iconAlugar = Icons.edit;
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text("Alugar e Comprar",
                          style: TextStyle(color: Colors.red, fontSize: 18.0),
                        ),
                        onPressed: (){
                          widget.imovel.setAlugar("alugar e vender");
                          setState(() {
                             _alugar = "alugar e vender";
                             _iconAlugar= Icons.edit;
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
    );
  }
}