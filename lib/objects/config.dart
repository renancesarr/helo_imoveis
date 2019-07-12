import 'package:cloud_firestore/cloud_firestore.dart';
class Config{
  List<String> categorias;
  Map<dynamic,dynamic> estados;
  List<String> listEstados;
  Map<dynamic,dynamic> cidades;
  List<dynamic> bairros;

  Config(this.categorias, List<String> lestados, List<String> lcidades, List<String> lbairros){
    this.cidades = new Map();
    this.estados = new Map();
    for(String cidade in lcidades){
      this.cidades.addAll({'nome':cidade,'bairros':lbairros});
    }
    print(this.cidades);
    for(String estado in lestados){
      this.estados.addAll({'nome':estado,'cidades':this.cidades});
    }
  }

  Config.fromMap(json){
    this.categorias = new List();
    this.cidades = new Map();
    for(String categoria in json['categorias']){
      this.categorias.add(categoria);
    }
    this.estados = json['estados'];
    /* for(Map estado in json['estados']){
      this.estados = estado;
    } */
    this.estados.forEach((k,v) =>
      this.cidades.addAll(v)
    );

    this.cidades.forEach((k,v) => 
      this.bairros = v.toList()
    );
  }

  List<String> getCategorias(){
    return this.categorias;
  }


  Map<String,dynamic> addNewBairro(String estado, String cidade, String novoBairro){
    bool tNewBairro = false;
    this.bairros.forEach((f){
      if(f == novoBairro){
        tNewBairro = true;
      }
    });
    if(tNewBairro == false){
      this.bairros.add(novoBairro);
      if(this.cidades.containsKey(cidade)==true){
        this.cidades.update(cidade, (update) => update=this.bairros);
      }else{
        this.cidades.putIfAbsent(cidade, () => this.bairros);
      }
      if(this.estados.containsKey(estado)==true){
        this.estados.update(estado, (update) => update=this.cidades);
      }else{
        this.estados.putIfAbsent(estado, ()=>this.cidades);
      }
    }
    return toJson();
  }

  Map<String,dynamic>addNewCidade(String estado, String cidade, List<String> newBairros){
    if(this.cidades.containsKey(cidade)==true){
      this.cidades.update(cidade, (update) => update = newBairros);
    }else{
      this.cidades.clear();
      this.cidades.putIfAbsent(cidade, ()=> bairros);
    }
    if(this.estados.containsKey(estado) == true){
      this.estados.update(estado, (update)=>update=this.cidades);
    }else{
      this.estados.putIfAbsent(estado, ()=>this.cidades);
    }
    return toJson();
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> json = {
      "categorias" : this.categorias,
      'estados': this.estados
    };
    return json;
  }

  void salvarConfig(){
    Map<String, dynamic> json = {
      'categorias' : this.categorias,
      'estados': this.estados
    };
    Firestore.instance.collection('config').document().setData(json);
  }

  void updateData (Map json) async {
    Firestore.instance.collection("config").document("-LjJPZoEkq-sdDWahI5T").updateData(json);
  }

}