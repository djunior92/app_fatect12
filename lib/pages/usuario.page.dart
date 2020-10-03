import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lancamentost12/constants.dart';
import 'package:lancamentost12/functions/server.dart';
import 'package:lancamentost12/functions/useful.dart';
import 'package:lancamentost12/models/Usuario.dart';
import 'package:lancamentost12/pages/widgets/ShowWait.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Usuario usuario = new Usuario();

class UsuarioPage extends StatefulWidget {
  final bool novoCadastro;

  UsuarioPage({Key key, @required this.novoCadastro}) : super(key: key);

  @override
  _UsuarioPageState createState() => _UsuarioPageState();
}

var _formKey = GlobalKey<FormState>();
var _scaffoldKey = GlobalKey<ScaffoldState>();

String idUsuario = "";

final _emailController = TextEditingController();
final _senhaController = TextEditingController();
final _nomeController = TextEditingController();

void _limparCampos() {
  _emailController.text = "";
  _senhaController.text = "";
  _nomeController.text = "";
}

void _setModel() {
  usuario.nome = _nomeController.text;
  usuario.email = _emailController.text;
  usuario.senha = _senhaController.text;
}

void _setControllers() {
  _nomeController.text = usuario.nome;
  _emailController.text = usuario.email;
  _senhaController.text = usuario.senha;
}

Future<bool> _create() async {
  _setModel();
  var result = await post(URL_USER_ADD, usuario.toJson());

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

Future<bool> _editar() async {
  var preferences = await SharedPreferences.getInstance();
  final String userid = preferences.getString('userid');
  _setModel();

  var result = await put(URL_USUARIO, userid, usuario.toJson());

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

class _UsuarioPageState extends State<UsuarioPage> {
  @override
  initState() {
    super.initState();
    if (widget
        .novoCadastro) //se estiver alterando os dados, então carrega as informações do usuário
      _limparCampos();
    else
      _loadData();
  }

  Future<void> _loadData() async {
    //recuperar o token
    var preferences = await SharedPreferences.getInstance();
    final String userid = preferences.getString('userid');
    var result = await get(URL_USUARIO + '/' + userid);

    if (result.statusCode == 200) {
      Map<String, dynamic> dados =
          Map<String, dynamic>.from(jsonDecode(result.body));
      usuario = Usuario.fromJson(dados);
      setState(() {
        idUsuario = usuario.id;
        _setControllers();
      });
    } else if (result.statusCode == 401) {
      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Usuário'),
      ),
      body: SingleChildScrollView(
        child: Container(
          //margin: EdgeInsets.fromLTRB(left, top, right, bottom),
          margin: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 50),
                  child: TextFormField(
                    autovalidate: false,
                    //initialValue: nome,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Nome do Usuário',
                      labelText: 'Nome',
                    ),
                    //initialValue: idUsuario,
                    controller: _nomeController,
                    //onSaved: (value) => usuario.nome = value,
                    validator: (value) =>
                        value.isEmpty ? 'Campo Obrigatório' : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: TextFormField(
                    autovalidate: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'E-mail  do Usuário',
                      labelText: 'E-mail',
                    ),
                    //initialValue: usuario.email,
                    //onSaved: (value) => usuario.email = value,
                    controller: _emailController,
                    validator: (value) =>
                        value.isEmpty ? 'Campo Obrigatório' : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: TextFormField(
                    autovalidate: false,
                    obscureText: true,
                    //initialValue: senha,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Senha  do Usuário',
                      labelText: 'Senha',
                    ),
                    //initialValue: usuario.senha,
                    //onSaved: (value) => usuario.senha = value,
                    controller: _senhaController,
                    //validator: (value) => value.isEmpty ? 'Campo Obrigatório' : null,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                ButtonTheme(
                  minWidth: 300,
                  buttonColor: Theme.of(context).primaryColor,
                  textTheme: ButtonTextTheme.primary,
                  child: RaisedButton(
                    child: Text("Salvar"),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();

                        showWait(context); //abre dialog wait
                        bool result =
                            await (widget.novoCadastro ? _create() : _editar());
                        Navigator.of(context, rootNavigator: true)
                            .pop(true); //fecha dialog wait

                        if (result) Navigator.of(context).pop();
                      }
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
