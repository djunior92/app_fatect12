import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lancamentost12/pages/usuario.page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuPage extends StatelessWidget {
  void _portraitModeOnly() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  Future<void> _logout(BuildContext context) async {
    var preferences = await SharedPreferences.getInstance();
    preferences.setString('token', '');
    preferences.setString('ip', '');
    preferences.setString('userid', '');
    Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    _portraitModeOnly();

    return Scaffold(
      appBar: AppBar(
        title: Text('Bem vindo!', style: TextStyle(color: Colors.white)),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          IconButton(
            color: Colors.white,
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              _logout(context);
            },
          )
        ],
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
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => UsuarioPage(
                                          novoCadastro: false,
                                        )));
                              },
                              child: Container(
                                width: 110,
                                height: 120,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                  fit: BoxFit.fitWidth,
                                  image:
                                      AssetImage('assets/images/profile.png'),
                                )),
                              ),
                            ),
                            Text('Usuário')
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
                                Navigator.of(context)
                                    .pushNamed('/lstlembretes');
                              },
                              child: Container(
                                width: 100,
                                height: 120,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                  fit: BoxFit.fitWidth,
                                  image:
                                      AssetImage('assets/images/lembrete.png'),
                                )),
                              ),
                            ),
                            Text('Lembrete')
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed('/lstcontas');
                              },
                              child: Container(
                                width: 100,
                                height: 120,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                  fit: BoxFit.fitWidth,
                                  image: AssetImage('assets/images/pagar.png'),
                                )),
                              ),
                            ),
                            Text('Conta (Pagar)')
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
