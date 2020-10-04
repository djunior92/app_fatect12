import 'package:flutter/material.dart';
import 'package:lancamentost12/constants.dart';
import 'package:lancamentost12/functions/server.dart';
import 'package:lancamentost12/models/Conta.dart';
import 'package:lancamentost12/pages/conta.page.dart';
import 'package:lancamentost12/pages/widgets/CardInformation.dart';
import 'package:lancamentost12/pages/widgets/ShowWait.dart';

class ContaViewPage extends StatefulWidget {
  final Conta conta;

  ContaViewPage({Key key, @required this.conta}) : super(key: key);

  @override
  _ContaViewPageState createState() => _ContaViewPageState();
}

var _scaffoldKey = GlobalKey<ScaffoldState>();

Future<bool> _delData(String contaid) async {
  var result = await delete(URL_CONTA, contaid);

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

Future<bool> _concluir(String contaid) async {
  var result = await put(URL_CONCLUIR_CONTA, contaid, {});

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

class _ContaViewPageState extends State<ContaViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Conta - detalhe'),
      ),
      body: SingleChildScrollView(
        child: Container(
          //margin: EdgeInsets.fromLTRB(left, top, right, bottom),
          margin: EdgeInsets.all(16),
          child: Form(
            child: Column(
              children: [
                Visibility(
                    visible: widget.conta.concluido,
                    child: Text(
                        "* Não é possível alterar/excluir registros já concluídos",
                        style: TextStyle(color: Colors.black, fontSize: 14.0))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Visibility(
                      visible: !widget.conta.concluido,
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
                                        builder: (context) => ContaPage(
                                            novoCadastro: false,
                                            tipo: widget.conta.tipo,
                                            contaid: widget.conta.id)));
                              },
                              label: Text("Alterar",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16.0))),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !widget.conta.concluido,
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
                                bool result = await _delData(widget.conta.id);
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
                Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Container(
                    child: Padding(
                        padding:
                            const EdgeInsets.only(top: 10, bottom: 10, left: 5),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            widget.conta.tipo == "P"
                                ? "Conta - Pagar"
                                : "Conta - Receber",
                            textAlign: TextAlign.left,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: widget.conta.tipo == "P"
                                    ? Colors.red
                                    : Colors.green),
                          ),
                        )),
                  ),
                ),
                CardInformation(
                    cabecalho: 'Data de vencimento',
                    corpo:
                        widget.conta.vencimento.day.toString().padLeft(2, '0') +
                            "/" +
                            widget.conta.vencimento.month
                                .toString()
                                .padLeft(2, '0') +
                            "/" +
                            widget.conta.vencimento.year.toString(),
                    maxLnCorpo: 2),
                CardInformation(
                    cabecalho: 'Título',
                    corpo: widget.conta.titulo,
                    maxLnCorpo: 12),
                Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: ListTile(
                      title: Text(
                        'Valor da Conta',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 14),
                      ),
                      subtitle: Text(
                        widget.conta.valor.toString(),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Visibility(
                  visible: !widget.conta.concluido,
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
                            bool result = await _concluir(widget.conta.id);
                            Navigator.of(context, rootNavigator: true)
                                .pop(true); //fecha dialog wait

                            if (result) {
                              //Navigator.of(context).pop();
                              Navigator.pop(context); //fecha tela Retirada
                              Navigator.pop(
                                  context, true); //fecha tela de Promocao
                            }
                          },
                          label: Text("Concluir Conta",
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
