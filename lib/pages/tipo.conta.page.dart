import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lancamentost12/pages/conta.page.dart';

class TipoContaPage extends StatelessWidget {
  void _portraitModeOnly() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    _portraitModeOnly();

    return Scaffold(
      appBar: AppBar(
        title: Text('Escolha o tipo de conta',
            style: TextStyle(color: Colors.white)),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => ContaPage(
                                            novoCadastro: true,
                                            tipo: "P",
                                            contaid: null)));
                              },
                              child: Container(
                                width: 110,
                                height: 120,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                  fit: BoxFit.fitWidth,
                                  image: AssetImage('assets/images/cpagar.png'),
                                )),
                              ),
                            ),
                            Text('Conta - Pagar')
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => ContaPage(
                                            novoCadastro: true,
                                            tipo: "R",
                                            contaid: null)));
                              },
                              child: Container(
                                width: 100,
                                height: 120,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                  fit: BoxFit.fitWidth,
                                  image:
                                      AssetImage('assets/images/creceber.png'),
                                )),
                              ),
                            ),
                            Text('Conta - Receber')
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
