import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:lancamentost12/models/Conta.dart';
import 'package:lancamentost12/pages/widgets/CardInformation.dart';

class ContaViewPage extends StatefulWidget {
  final Conta conta;

  ContaViewPage({Key key, @required this.conta}) : super(key: key);

  @override
  _ContaViewPageState createState() => _ContaViewPageState();
}

class _ContaViewPageState extends State<ContaViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conta'),
      ),
      body: SingleChildScrollView(
        child: Container(
          //margin: EdgeInsets.fromLTRB(left, top, right, bottom),
          margin: EdgeInsets.all(16),
          child: Form(
            child: Column(
              children: [
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
                          alignment: Alignment.topLeft,
                          child: Text(
                            widget.conta.titulo.toUpperCase(),
                            textAlign: TextAlign.left,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        )),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: ListTile(
                      title: Text(
                        'Valor do Produto',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 14),
                      ),
                      subtitle: Text(
                        "aaa",
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
                CardInformation(
                    cabecalho: 'Informações do produto',
                    corpo: "bbbb",
                    maxLnCorpo: 12),
                CardInformation(
                    cabecalho: 'Estoque disponível',
                    corpo: "ccccc",
                    maxLnCorpo: 1),
                SizedBox(
                  height: 20,
                ),
                ButtonTheme(
                  minWidth: 300,
                  buttonColor: Theme.of(context).primaryColor,
                  textTheme: ButtonTextTheme.primary,
                  child: RaisedButton(
                    child: Text("Comprar"),
                    onPressed: () async {
                      /*Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) =>
                              ConfirmaPedidoPage(anuncio: widget.anuncio)));*/
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
