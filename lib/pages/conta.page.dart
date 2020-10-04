import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lancamentost12/constants.dart';
import 'package:lancamentost12/functions/server.dart';
import 'package:lancamentost12/models/Conta.dart';
import 'package:lancamentost12/pages/widgets/ShowWait.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

Conta conta = new Conta();

class ContaPage extends StatefulWidget {
  final bool novoCadastro;
  final String tipo;
  final String contaid;

  ContaPage(
      {Key key,
      @required this.novoCadastro,
      @required this.tipo,
      @required this.contaid})
      : super(key: key);

  @override
  _ContaPageState createState() => _ContaPageState();
}

class _ContaPageState extends State<ContaPage> {
  var _formKey = GlobalKey<FormState>();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime selectedDate = DateTime.now();
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _valorController = TextEditingController();
  DateTime _currentDate = DateTime.now();

  @override
  initState() {
    super.initState();
    if (widget
        .novoCadastro) //se estiver alterando os dados, então carrega as informações do usuário
      _limparCampos();
    else
      _loadData();
  }

  void _limparCampos() {
    _tituloController.text = "";
    _descricaoController.text = "";
    _valorController.text = "";
    _currentDate = DateTime.now();
  }

  void _setModel() {
    try {
      conta.tipo = widget.tipo;
      conta.titulo = _tituloController.text;
      conta.vencimento = new DateTime.utc(
          selectedDate.year, selectedDate.month, selectedDate.day);
      conta.valor = double.parse(_valorController.text);
    } catch (e) {
      print(e);
      return null;
    }
  }

  void _setControllers() {
    _tituloController.text = conta.titulo;
    _valorController.text = conta.valor.toString();
    _currentDate = new DateTime.utc(
        conta.vencimento.year,
        conta.vencimento.month,
        conta.vencimento.day,
        conta.vencimento.hour,
        conta.vencimento.minute);
    selectedDate = _currentDate;
  }

  Future<bool> _create() async {
    _setModel();
    var result = await post(
        widget.tipo == "P" ? URL_CONTA_PAGAR_ADD : URL_CONTA_RECEBER_ADD,
        conta.toJson());

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
    _setModel();

    var result = await put(URL_CONTA, widget.contaid, conta.toJson());

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

  Future<void> _loadData() async {
    var result = await get(URL_CONTA + '/' + widget.contaid);

    if (result.statusCode == 200) {
      Map<String, dynamic> dados =
          Map<String, dynamic>.from(jsonDecode(result.body));
      conta = Conta.fromJson(dados);
      setState(() {
        _setControllers();
      });
    } else if (result.statusCode == 401) {
      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(1900, 1, 1),
        maxTime: DateTime(2025, 31, 12),

        //currentTime: DateTime.now(),
        currentTime: _currentDate,
        locale: LocaleType.pt);

    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Conta'),
      ),
      body: SingleChildScrollView(
        child: Container(
          //margin: EdgeInsets.fromLTRB(left, top, right, bottom),
          margin: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(bottom: 5, top: 5),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: widget.tipo == "P" ? Colors.red : Colors.green,
                    border: Border.all(),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                        widget.tipo == "P"
                            ? "Conta - Pagar"
                            : "Conta - Receber",
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(children: <Widget>[
                        FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(
                                  color: Theme.of(context).primaryColor)),
                          color: Colors.white,
                          textColor: Theme.of(context).primaryColor,
                          padding: EdgeInsets.all(8.0),
                          onPressed: () {
                            _selectDate(context);
                          },
                          child: Text(
                            "Data de Vencimento".toUpperCase(),
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        Text(
                          //"${selectedDate.toLocal()}".split(' ')[0],
                          "${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}",
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ]),
                    ]),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: TextFormField(
                    autovalidate: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Informe um título para seu conta',
                      labelText: 'Título',
                    ),
                    controller: _tituloController,
                    validator: (value) =>
                        value.isEmpty ? 'Campo Obrigatório' : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: TextFormField(
                    autovalidate: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Valor',
                      labelText: 'Valor da conta',
                    ),
                    controller: _valorController,
                    validator: (value) =>
                        value.isEmpty ? 'Campo Obrigatório' : null,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      BlacklistingTextInputFormatter(new RegExp('[\\-|\\ ]'))
                    ],
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

                        if (result) {
                          Navigator.pop(context);
                          if (!widget.novoCadastro)
                            Navigator.pop(context, true);
                        }
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
