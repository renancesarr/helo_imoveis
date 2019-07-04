import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:basic_utils/basic_utils.dart';

class Imovel{
  int id;
  String logadouro;
  String bairro;
  String cidade;
  String estado;
  String cep;
  String complemento;
  String numero;
  String tipoImovel;
  int quartos;
  int banheiros;
  int garagem;
  double area;
  double valor;
  double valorCondominio;
  double iptu;
  Map<dynamic, dynamic> caracteristicas;
  Map<dynamic, dynamic> caracteristicasCondominio;
  List<String> imagens;
  bool alugar;//false para venda, true para alugar
  bool ativo;
  bool condominio;

  Imovel();

  Imovel.fromMap(Map json){
    this.id = json['id'];
    this.logadouro = StringUtils.capitalize(json['logadouro']) ;
    this.bairro = StringUtils.capitalize(json['bairro']);
    this.cidade = StringUtils.capitalize(json['cidade']);
    this.estado = StringUtils.capitalize(json['estado']);
    this.cep = json['cep'];
    this.complemento =  json['complemento'].toUpperCase();
    this.numero = json['numero'];
    this.tipoImovel = json['tipoImovel'];
    this.quartos = json['quatos'];
    this.banheiros = json['banheiros'];
    this.garagem = json['garagem'];
    this.area = json['area'];
    this.valor=json['valor'];
    this.valorCondominio=json['valorCondominio'];
    this.iptu=json['iptu'];
    this.caracteristicas=json['caracteristicas'];
    this.caracteristicasCondominio=json['caracteristicasCondominio'];
    this.imagens=json['imagens'];
    this.alugar=json['alugar'];
    this.ativo=json['ativo'];
    this.condominio=json['Condominio'];
  }

  Future<Map<String, dynamic>> toJson() async{
    Map<String, dynamic> json ={
      "logadouro":this.logadouro,
      "bairro":this.bairro,
     " cidade":this.cidade,
      "estado":this.estado,
      "cep":this.cep,
      "complemento":this.complemento,
      "numero":this.numero,
      "tipoImovel":this.tipoImovel,
      "quartos":this.quartos,
      "banheiros":this.banheiros,
      "garagem":this.garagem,
      "area":this.area,
      "valor":this.valor,
      "valorCondominio":this.valorCondominio,
      "iptu":this.iptu,
      "caracteristicas":this.caracteristicas,
      "caracteristicasCondominio":this.caracteristicasCondominio,
      "imagens":this.imagens,
      "alugar":this.alugar,
      "ativo":this.ativo,
      "condominio":this.condominio
    };
    if(id == null){
      QuerySnapshot snapshot =  await Firestore.instance.collection("imoveis").getDocuments();
      json['id']=snapshot.documents.length;
    }
    return json;
  }

}