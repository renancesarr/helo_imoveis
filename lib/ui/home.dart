import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:helo_imoveis/objects/imovel.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String _search;
  List<Imovel> listImoveis = new List();

  Future<List<Imovel>> _getListImoveis() async {
    List<Imovel> imoveis = new List();
    QuerySnapshot snapshot =  await Firestore.instance.collection("imoveis").getDocuments();
    for(DocumentSnapshot document in snapshot.documents){
      Imovel newImovel = new Imovel.fromMap(document.data);
      imoveis.add(newImovel);
    }
    listImoveis = imoveis;
    return imoveis;
  }

  @override
  void initState(){
    super.initState();
    
  }
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Imoveis"),
        backgroundColor: Colors.pinkAccent,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        child: Icon(Icons.add),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                  labelText: "Pesquisar Logadouro!",
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder()
              ),
              style: TextStyle(color: Colors.black, fontSize: 18.0),
              textAlign: TextAlign.center,
              onSubmitted: (text){
                setState(() {
                  _search = text;
                });
              },
            ),
          ),
          Expanded(child: FutureBuilder(
              future: _getListImoveis(),
              builder: (context, snapshot ){
                switch(snapshot.connectionState){
                  case ConnectionState.none:          
                  case ConnectionState.waiting:
                    return Center(
                      child: Container(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      print(snapshot.data);
                      return ListView.builder(
                        padding: EdgeInsets.all(10.0),
                        itemCount: listImoveis.length,
                          itemBuilder: (context, index){
                            return _imovelCard(context, index);
                          },
                      );
                    }
                    break;
                  default:
                }
              },
            ),
          ),
        ],
      ),
    );
  }
  Widget _imovelCard(BuildContext context, int index){
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: listImoveis[index].imagens !=null ?
                      FileImage(File(listImoveis[index].imagens.first)) :
                      AssetImage("images/person.png")
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          listImoveis[index].logadouro ?? "",
                          style: TextStyle(fontSize: 22.0, 
                          fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          ", ",
                          style: TextStyle(fontSize: 22.0, 
                          fontWeight: FontWeight.bold),
                        ),
                        Text(
                          listImoveis[index].numero == null ? listImoveis[index].complemento : 
                          listImoveis[index].numero == "" ? listImoveis[index].complemento : listImoveis[index].numero,
                          style: TextStyle(fontSize: 22.0, 
                          fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          listImoveis[index].bairro ?? "",
                          style: TextStyle(fontSize: 18.0,),
                        ),
                        Text(
                          " - ",
                          style: TextStyle(fontSize: 18.0, ),
                        ),
                        Text(
                          listImoveis[index].cep ?? "",
                          style: TextStyle(fontSize: 18.0,),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          listImoveis[index].cidade ?? "",
                          style: TextStyle(fontSize: 18.0,),
                        ),
                        Text(
                          " - ",
                          style: TextStyle(fontSize: 18.0, ),
                        ),
                        Text(
                          listImoveis[index].estado ?? "",
                          style: TextStyle(fontSize: 18.0,),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}