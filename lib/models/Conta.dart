import 'dart:ffi';

import 'package:intl/intl.dart';

class Conta {
  String id;
  String tipo;
  String titulo;
  DateTime vencimento;
  double valor;
  bool concluido;

  Conta({
    this.id = "",
    this.tipo = "",
    this.titulo = "",
    this.concluido = false,
  });

  Conta.fromJson(Map<String, dynamic> json) {
    this.id = json['_id'];
    this.tipo = json['tipo'];
    this.titulo = json['titulo'];
    this.vencimento =
        new DateFormat("yyyy-MM-ddThh:mm:ss.SSSZ").parse(json['vencimento']);
    this.valor = json['valor'].toDouble();
    this.concluido = json['concluido'];
  }

  Map<String, dynamic> toJson() => {
        "tipo": tipo ?? "null",
        "titulo": titulo ?? "null",
        "vencimento": vencimento.toString() ?? "null",
        "valor": valor.toString() ?? "null",
        "concluido": concluido ?? "null",
      };
}
