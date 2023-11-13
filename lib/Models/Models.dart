import 'package:flutter/material.dart';

class model_usuario {
  static const table = 'usuario';
  static const columnUsuarioId = 'usuarioId';
  static const columnUsuario = 'usuario';
  static const columnEmail = 'email';
  static const columnSenha = 'senha';

  int? usuarioId;
  late String usuario;
  late String email;
  late String senha;

  model_usuario({this.usuarioId, required this.email, required this.senha});

  Map<String, dynamic> usuarioToMap(List<Map<String, Object?>> list) {
    var map = <String, dynamic>{
      columnUsuario: usuario,
      columnEmail: email,
      columnSenha: senha
    };
    if (usuarioId != null) {
      map[columnUsuarioId] = usuarioId;
    }
    return map;
  }

  model_usuario.fromMap(Map<String, dynamic> map) {
    usuarioId = map[columnUsuarioId];
    usuario = map[columnUsuario];
    email = map[columnEmail];
    senha = map[columnSenha];
  }
}

class model_carteira {
  static const table = 'carteira';
  static const columnCarteiraId = 'carteiraId';
  static const columnUsuarioId = 'usuarioId';
  static const columnTotal = 'total';
  static const columnItens = 'itens';
  static List<model_Item> Itens = [];
}

class model_Item {
  static const table = 'item';
  static const columnMes = 'mes';
  static const columnData = 'data';
  static const columnValor = 'valor';
  static const columnParcela = 'parcela';
  static const columnDescricao = 'descricao';
  static const columnSubTotal = 'subtotal';
  static const columnItemId = 'itemId';
  static const columnCarteiraId = 'carteiraId';
  static const columnUsuarioId = 'usuarioId';
  static const columnOrigem = 'origem';

  late String mes;
  late String data;
  late double valor;
  late String parcela;
  late String descricao;
  late double subtotal;
  late String itemId;
  late String carteiraId;
  late String usuarioId;
  late String origem;

  Map<String, dynamic> itemToMap(List<Map<String, Object?>> list) {
    var map = <String, dynamic>{
      columnMes: mes,
      columnData: data,
      columnValor: valor,
      columnParcela: parcela,
      columnDescricao: descricao,
      columnSubTotal: subtotal,
      columnItemId: itemId,
      columnCarteiraId: carteiraId,
      columnUsuarioId: usuarioId,
      columnOrigem: origem
    };
    if (itemId != null) {
      map[columnItemId] = itemId;
    }
    return map;
  }

  model_Item.fromMap(Map<String, dynamic> map) {
    mes = map[columnMes];
    data = map[columnData];
    valor = map[columnValor];
    parcela = map[columnParcela];
    descricao = map[columnDescricao];
    subtotal = map[columnSubTotal];
    itemId = map[columnItemId];
    carteiraId = map[columnCarteiraId];
    usuarioId = map[columnUsuarioId];
    origem = map[columnOrigem];
  }
}

class FinancialData {
  static const table = 'item';
  static const columnMes = 'mes';
  static const columnData = 'data';
  static const columnValor = 'valor';
  static const columnParcela = 'parcela';
  static const columnDescricao = 'descricao';
  static const columnSubTotal = 'subtotal';
  static const columnItemId = 'itemId';
  static const columnCarteiraId = 'carteiraId';
  static const columnUsuarioId = 'usuarioId';
  static const columnOrigem = 'origem';

  late String mes;
  late String data;
  late double valor;
  late int parcela;
  late String descricao;
  late double subtotal;
  late int itemId;
  late int carteiraId;
  late int usuarioId;
  late String origem;

  Map<String, dynamic> itemToMap(List<Map<String, Object?>> list) {
    var map = <String, dynamic>{
      columnMes: mes,
      columnData: data,
      columnValor: valor,
      columnParcela: parcela,
      columnDescricao: descricao,
      columnSubTotal: subtotal,
      columnItemId: itemId,
      columnCarteiraId: carteiraId,
      columnUsuarioId: usuarioId,
      columnOrigem: origem
    };
    if (itemId != null) {
      map[columnItemId] = itemId;
    }
    return map;
  }

  FinancialData.fromMap(Map<String, dynamic> map) {
    mes = map[columnMes];
    data = map[columnData];
    valor = double.parse(map[columnValor]);
    parcela = map[columnParcela];
    descricao = map[columnDescricao];
    subtotal = double.parse(map[columnSubTotal]);
    itemId = map[columnItemId];
    carteiraId = map[columnCarteiraId];
    usuarioId = map[columnUsuarioId];
    origem = map[columnOrigem];
  }

  FinancialData(this.descricao, this.valor, this.mes, this.data, this.parcela,
      this.subtotal, this.carteiraId, this.usuarioId, this.origem);
}
