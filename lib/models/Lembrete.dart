import 'package:intl/intl.dart';

class Lembrete {
  String id;
  String titulo;
  String descricao;
  DateTime data;
  String observacaoConclusao;
  bool concluido;

  Lembrete({
    this.id = "",
    this.titulo = "",
    this.descricao = "",
    this.observacaoConclusao = "",
    this.concluido = false,
  });

  Lembrete.fromJson(Map<String, dynamic> json) {
    this.id = json['_id'];
    this.titulo = json['titulo'];
    this.descricao = json['descricao'];
    this.data = new DateFormat("yyyy-MM-ddThh:mm:ss.SSSZ").parse(json['data']);
    this.observacaoConclusao = json['observacao_conclusao'];
    this.concluido = json['concluido'];
  }

//addDt.isUtc; // false
//addDt.toUtc(); // 2020–04–02 13:33:29.971Z
  Map<String, dynamic> toJson() => {
        "titulo": titulo ?? "null",
        "descricao": descricao ?? "null",
        "data": data.toString() ?? "null",
        "observacao_conclusao": observacaoConclusao ?? "null",
        "concluido": concluido ?? "null",
      };
}
