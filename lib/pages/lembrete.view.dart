import 'package:flutter/material.dart';
import 'package:lancamentost12/constants.dart';
import 'package:lancamentost12/functions/server.dart';
import 'package:lancamentost12/models/Lembrete.dart';
import 'package:lancamentost12/pages/lembrete.page.dart';
import 'package:lancamentost12/pages/widgets/CardInformation.dart';
import 'package:lancamentost12/pages/widgets/ShowWait.dart';

class LembreteViewPage extends StatefulWidget {
  final Lembrete lembrete;

  LembreteViewPage({Key key, @required this.lembrete}) : super(key: key);

  @override
  _LembreteViewPageState createState() => _LembreteViewPageState();
}

var _scaffoldKey = GlobalKey<ScaffoldState>();

Future<bool> _delData(String lembreteid) async {
  var result = await delete(URL_LEMBRETE, lembreteid);

  if (result == null) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Erro: " + "Não foi possível conectar ao servidor."),
      backgroundColor: Colors.red,
    ));
    return false;
  } else if (result.statusCode == 200) {
    return true;
  } else if (result.statusCode == 500) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(result.body.replaceAll('ValidationError', 'Motivo')),
      backgroundColor: Colors.red,
    ));
    return false;
  }
}

Future<bool> _concluir(String lembreteid) async {
  var result = await put(URL_CONCLUIR_LEMBRETE, lembreteid, {});

  if (result == null) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Erro: " + "Não foi possível conectar ao servidor."),
      backgroundColor: Colors.red,
    ));
    return false;
  } else if (result.statusCode == 200) {
    return true;
  } else if (result.statusCode == 500) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(result.body.replaceAll('ValidationError', 'Motivo')),
      backgroundColor: Colors.red,
    ));
    return false;
  }
}

class _LembreteViewPageState extends State<LembreteViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Lembrete - detalhe'),
      ),
      body: SingleChildScrollView(
        child: Container(
          //margin: EdgeInsets.fromLTRB(left, top, right, bottom),
          margin: EdgeInsets.all(16),
          child: Form(
            child: Column(
              children: [
                Visibility(
                    visible: widget.lembrete.concluido,
                    child: Text(
                        "* Não é possível alterar/excluir registros já concluídos",
                        style: TextStyle(color: Colors.black, fontSize: 14.0))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Visibility(
                      visible: !widget.lembrete.concluido,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(),
                          child: RaisedButton.icon(
                              elevation: 4.0,
                              icon: Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                              color: Theme.of(context).primaryColor,
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => LembretePage(
                                            novoCadastro: false,
                                            lembreteid: widget.lembrete.id)));
                              },
                              label: Text("Alterar",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16.0))),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !widget.lembrete.concluido,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(),
                          child: RaisedButton.icon(
                              elevation: 4.0,
                              icon: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                              color: Colors.red,
                              onPressed: () async {
                                showWait(context); //abre dialog wait
                                bool result =
                                    await _delData(widget.lembrete.id);
                                Navigator.of(context, rootNavigator: true)
                                    .pop(true); //fecha dialog wait

                                if (result) {
                                  //Navigator.of(context).pop();
                                  Navigator.pop(context); //fecha tela Retirada
                                  Navigator.pop(
                                      context, true); //fecha tela de Promocao
                                }
                              },
                              label: Text("Excluir",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16.0))),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                CardInformation(
                    cabecalho: 'Data/Hora do lembrete',
                    corpo: widget.lembrete.data.day.toString().padLeft(2, '0') +
                        "/" +
                        widget.lembrete.data.month.toString().padLeft(2, '0') +
                        "/" +
                        widget.lembrete.data.year.toString() +
                        " - " +
                        widget.lembrete.data.hour.toString().padLeft(2, '0') +
                        ":" +
                        widget.lembrete.data.minute.toString().padLeft(2, '0'),
                    maxLnCorpo: 2),
                CardInformation(
                    cabecalho: 'Título',
                    corpo: widget.lembrete.titulo,
                    maxLnCorpo: 3),
                CardInformation(
                    cabecalho: 'Descrição',
                    corpo: widget.lembrete.descricao,
                    maxLnCorpo: 10),
                Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Text(
                            widget.lembrete.concluido ? "Concluído" : "Aberto",
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Visibility(
                  visible: !widget.lembrete.concluido,
                  child: ButtonTheme(
                      minWidth: 300,
                      height: 40,
                      textTheme: ButtonTextTheme.primary,
                      child: RaisedButton.icon(
                          elevation: 4.0,
                          icon: Icon(
                            Icons.check,
                            color: Theme.of(context).primaryColor,
                          ),
                          color: Color(0xffcccccc),
                          onPressed: () async {
                            showWait(context); //abre dialog wait
                            bool result = await _concluir(widget.lembrete.id);
                            Navigator.of(context, rootNavigator: true)
                                .pop(true); //fecha dialog wait

                            if (result) {
                              //Navigator.of(context).pop();
                              Navigator.pop(context); //fecha tela Retirada
                              Navigator.pop(
                                  context, true); //fecha tela de Promocao
                            }
                          },
                          label: Text("Concluir lembrete",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 16.0)))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
