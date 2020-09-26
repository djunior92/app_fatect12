import 'package:flutter/material.dart';
import 'package:lancamentost12/constants.dart';
import 'package:lancamentost12/pages/usuario.page.dart';
import 'package:lancamentost12/pages/widgets/ShowDialog.dart';
import 'package:lancamentost12/pages/widgets/ShowWait.dart';
import 'package:lancamentost12/pages/widgets/sing_config.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:lancamentost12/constants.dart';
import 'package:lancamentost12/functions/server.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  var _formKey = GlobalKey<FormState>();
  var _formIP = GlobalKey<FormState>();

  var _scaffoldKey = GlobalKey<ScaffoldState>();

  String ip;
  String email;
  String senha;

  Future<bool> _setIP() async {
    var preferences = await SharedPreferences.getInstance();
    preferences.setString('ip', ip);
    return true;
  }

  Future<bool> _login(BuildContext context) async {
    var result = await login(ip, {'email': email, 'senha': senha});
    if (result == null) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Erro: " + "Não foi possível conectar ao servidor."),
        backgroundColor: Colors.red,
      ));
      return false;
    } else if (result.statusCode == 200) {
      var token = jsonDecode(result.body)['token'];
      var teste = jsonDecode(result.body)['usuario']["_id"];
      var preferences = await SharedPreferences.getInstance();
      preferences.setString('ip', ip);
      preferences.setString('userid', teste);
      preferences.setString('token', token);
      return true;
    } else if (result.statusCode == 404) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content:
            Text("Email e/ou senha inválidos. Verifique os dados informados."),
        backgroundColor: Colors.red,
      ));
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      double devicePixelRatio = MediaQuery.of(context).devicePixelRatio - 1;
      if (devicePixelRatio < 1) {
        ConfigGlobal(
            textFontSize: SIZE_TEXT_EDIT * (devicePixelRatio + 1),
            titleFontSize: SIZE_TEXT_TITLE * (devicePixelRatio + 1),
            multiplier: (devicePixelRatio + 1));
      } else {
        ConfigGlobal(
            textFontSize: SIZE_TEXT_EDIT,
            titleFontSize: SIZE_TEXT_TITLE,
            multiplier: 1);
      }
    } catch (e) {
      //print(e);
    }

    return Scaffold(
      key: _scaffoldKey,
      //appBar: AppBar(
      //  title: Text('Login'),
      //),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(16),
              child: Form(
                key: _formIP,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10.0, top: 20),
                        child: Container(
                          height: MediaQuery.of(context).size.height / 3,
                          width: MediaQuery.of(context).size.height / 2,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/icon.png'),
                                  alignment: Alignment.center)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(),
                      child: TextFormField(
                        autovalidate: false,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Informe o seu IP',
                          hintText: 'HOST',
                        ),
                        initialValue: "192.168.0.108",
                        onSaved: (value) => ip = value,
                        validator: (value) =>
                            value.isEmpty ? 'Campo Obrigatório' : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        autovalidate: false,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'E-mail',
                          icon: Icon(Icons.mail_outline),
                          hintText: 'E-mail',
                        ),
                        onSaved: (value) => email = value,
                        validator: (value) =>
                            value.isEmpty ? 'Campo Obrigatório' : null,
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        autovalidate: false,
                        decoration: InputDecoration(
                          hintText: 'Senha',
                          border: OutlineInputBorder(),
                          labelText: 'Senha',
                          icon: Icon(Icons.vpn_key),
                        ),
                        onSaved: (value) => senha = value,
                        validator: (value) =>
                            value.isEmpty ? 'Campo Obrigatório' : null,
                        obscureText: true,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ButtonTheme(
                      minWidth: double.infinity,
                      height: 50,
                      buttonColor: Theme.of(context).primaryColor,
                      textTheme: ButtonTextTheme.primary,
                      child: RaisedButton(
                        child: Text("Entrar", style: TextStyle(fontSize: 16)),
                        onPressed: () async {
                          if (_formKey.currentState.validate() &&
                              _formIP.currentState.validate()) {
                            _formIP.currentState.save();
                            _formKey.currentState.save();
                            //TODO: Salvar dados na API
                            showWait(context); //abre dialog wait
                            bool result = await _login(context);

                            Navigator.of(context, rootNavigator: true)
                                .pop(true); //fecha dialog wait
                            if (result)
                              Navigator.of(context)
                                  .pushReplacementNamed('/menu');
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Column(children: [
                        Text('Ainda não tem conta?',
                            style: TextStyle(fontSize: 16, color: Colors.grey)),
                        SizedBox(
                          height: 5,
                        ),
                        GestureDetector(
                            child: Text('Cadastre-se!',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.blue)),
                            onTap: () async {
                              if (_formIP.currentState.validate()) {
                                _formIP.currentState.save();

                                bool result = false;
                                result = await _setIP();

                                if (result)
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => UsuarioPage(
                                            novoCadastro: true,
                                          )));
                              }
                            }),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
