

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:helo_imoveis/objects/imovel.dart';
import 'package:multi_image_picker/multi_image_picker.dart';


class ImovelPage extends StatefulWidget{

  Imovel imovel;

  ImovelPage({this.imovel});
  _ImovelPageState createState() => _ImovelPageState();

}

class _ImovelPageState extends State<ImovelPage>{
  List<Asset> listImages = List<Asset>();
  String _error  = "R";

  @override
  void initState(){
    super.initState();

    if(widget.imovel == null){
      widget.imovel = new Imovel();
    }
  }
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: widget.imovel.logadouro == null ? Text("Novo Imovel") : Text("Editar Imovel"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          loadAssets();
        },
        child: Icon(Icons.photo_camera),
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
            Text(_error),
          ],
        ),
    );
  }

  Widget _imagemCard(BuildContext context, int index){
    print(index);print(listImages.length+1);
    if(index == listImages.length){
      return Container(
        height: 200,
        width: 200,
        child:Card(
          child:IconButton(
            onPressed: (){
              loadAssets();
            },
            iconSize: 100,
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
            width: 200,
            height: 200,
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
            selectCircleStrokeColor: "#ffffff",
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
}