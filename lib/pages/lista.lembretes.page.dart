import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lancamentost12/models/Lembrete.dart';
import 'package:lancamentost12/pages/lembrete.page.dart';
import 'package:lancamentost12/pages/lembrete.view.dart';
import '../constants.dart';
import '../functions/server.dart';

class ListaLembretesPage extends StatefulWidget {
  @override
  _ListaLembretesPageState createState() => _ListaLembretesPageState();
}

class _ListaLembretesPageState extends State<ListaLembretesPage> {
  var _formKey = GlobalKey<FormState>();
  Future<List> _future;
  String _pesquisa = "";

  @override
  initState() {
    super.initState();
    _future = _loadData();
  }

  Future<List<Lembrete>> _loadData() async {
    var result = await get(URL_LEMBRETE);

    if ((result.statusCode == 200)) {
      var _lista = new List<Lembrete>();

      Iterable dados = jsonDecode(result.body);
      for (var item in dados) {
        _lista.add(Lembrete.fromJson(item));
      }
      return _lista;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Listagem de lembretes"), actions: []),
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
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      //Navigator.of(context).pushNamed('/lembrete');
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => LembretePage(
                              novoCadastro: true, lembreteid: null)));
                    },
                    label: Text("Adicionar novo Lembrete",
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
                                                  Container(
                                                    alignment: Alignment.center,
                                                    child: Wrap(
                                                      spacing: 12,
                                                      children: <Widget>[
                                                        Icon(
                                                            Icons.announcement),
                                                      ],
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
                                                                .data.day
                                                                .toString()
                                                                .padLeft(
                                                                    2, '0') +
                                                            "/" +
                                                            snapshot
                                                                .data[position]
                                                                .data
                                                                .month
                                                                .toString()
                                                                .padLeft(
                                                                    2, '0') +
                                                            "/" +
                                                            snapshot
                                                                .data[position]
                                                                .data
                                                                .year
                                                                .toString() +
                                                            " - " +
                                                            snapshot
                                                                .data[position]
                                                                .data
                                                                .hour
                                                                .toString()
                                                                .padLeft(
                                                                    2, '0') +
                                                            ":" +
                                                            snapshot
                                                                .data[position]
                                                                .data
                                                                .minute
                                                                .toString()
                                                                .padLeft(
                                                                    2, '0'),
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
                                            builder: (context) =>
                                                LembreteViewPage(
                                                    lembrete: snapshot
                                                        .data[position]),
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
