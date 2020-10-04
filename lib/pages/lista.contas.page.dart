import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lancamentost12/models/Conta.dart';
import 'package:lancamentost12/pages/conta.view.dart';
import '../constants.dart';
import '../constants.dart';
import '../functions/server.dart';

class ListaContasPage extends StatefulWidget {
  @override
  _ListaContasPageState createState() => _ListaContasPageState();
}

class _ListaContasPageState extends State<ListaContasPage> {
  var _formKey = GlobalKey<FormState>();
  Future<List> _future;
  String _pesquisa = "";

  @override
  initState() {
    super.initState();
    _future = _loadData();
  }

  Future<List<Conta>> _loadData() async {
    var result = await get(URL_CONTA);

    if ((result.statusCode == 200)) {
      var _lista = new List<Conta>();

      Iterable dados = jsonDecode(result.body);
      for (var item in dados) {
        _lista.add(Conta.fromJson(item));
      }
      return _lista;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Listagem de contas"), actions: []),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: RaisedButton.icon(
                    elevation: 4.0,
                    icon: Icon(Icons.add, color: Colors.white),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacementNamed('/tipoconta'); //deixando
                    },
                    label: Text("Adicionar nova Conta",
                        style: TextStyle(color: Colors.white, fontSize: 16.0))),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 10.0, bottom: 5, left: 10, right: 10),
                child: FutureBuilder<List>(
                    future: _future,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.active:
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width,
                              child:
                                  Center(child: CircularProgressIndicator()));
                        case ConnectionState.done:
                          if (snapshot.data == null ||
                              snapshot.data.length == 0 ||
                              snapshot.hasError) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Text(
                                      'Nenhuma informação encontrada.',
                                      style: TextStyle(fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _future = _loadData();
                                      });
                                    },
                                    child: Icon(Icons.refresh)),
                              ],
                            );
                          } else {
                            return Column(
                              children: <Widget>[
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (_, int position) {
                                      final item = snapshot.data[position];

                                      return GestureDetector(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            Card(
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    flex: 1,
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      //color: snapshot.data[position].qtdeDisponivel == 0 ? Colors.red : Colors.green,
                                                      color: snapshot
                                                                  .data[
                                                                      position]
                                                                  .tipo ==
                                                              "P"
                                                          ? Colors.red
                                                          : Colors.green,
                                                      child: Text(
                                                        snapshot.data[position]
                                                            .tipo,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 12,
                                                    child: ListTile(
                                                      title: Text(
                                                        snapshot.data[position]
                                                            .titulo,
                                                        textAlign:
                                                            TextAlign.left,
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      subtitle: Text(
                                                        snapshot.data[position]
                                                                .vencimento.day
                                                                .toString()
                                                                .padLeft(
                                                                    2, '0') +
                                                            "/" +
                                                            snapshot
                                                                .data[position]
                                                                .vencimento
                                                                .month
                                                                .toString()
                                                                .padLeft(
                                                                    2, '0') +
                                                            "/" +
                                                            snapshot
                                                                .data[position]
                                                                .vencimento
                                                                .year
                                                                .toString() +
                                                            ' - R\u0024 ' +
                                                            snapshot
                                                                .data[position]
                                                                .valor
                                                                .toString(),
                                                        textAlign:
                                                            TextAlign.left,
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      trailing: Wrap(
                                                        spacing: 12,
                                                        children: <Widget>[
                                                          Icon(Icons
                                                              .arrow_forward),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) => ContaViewPage(
                                                conta: snapshot.data[position]),
                                          ));
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          }
                      }
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
