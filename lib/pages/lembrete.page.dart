import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:cpf_cnpj_validator/cnpj_validator.dart';
import 'package:lancamentost12/constants.dart';
import 'package:lancamentost12/functions/server.dart';
import 'package:lancamentost12/models/Lembrete.dart';
import 'package:lancamentost12/pages/widgets/ShowWait.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

Lembrete lembrete = new Lembrete();

class LembretePage extends StatefulWidget {
  final bool novoCadastro;
  final String lembreteid;

  LembretePage(
      {Key key, @required this.novoCadastro, @required this.lembreteid})
      : super(key: key);

  @override
  _LembretePageState createState() => _LembretePageState();
}

class _LembretePageState extends State<LembretePage> {
  var _formKey = GlobalKey<FormState>();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  DateTime _currentDate = DateTime.now();
  TimeOfDay _currentTime = TimeOfDay.now();

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
    _currentDate = DateTime.now();
    _currentTime = TimeOfDay.now();
  }

  void _setModel() {
    try {
      lembrete.titulo = _tituloController.text;
      lembrete.descricao = _descricaoController.text;
      //DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", Locale.ENGLISH);
      //LocalDate date = LocalDate.parse(string, formatter);
      //lembrete.data = new DateFormat("yyyy-MM-ddThh:mm:ss.SSSZ").parse(
      //        "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}T${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}:00.000Z").toUtc();
      //lembrete.data = new DateTime.utc(2020, 10, 10, 23, 58);
      lembrete.data = new DateTime.utc(selectedDate.year, selectedDate.month,
          selectedDate.day, selectedTime.hour, selectedTime.minute);
    } catch (e) {
      print(e);
      return null;
    }
  }

  void _setControllers() {
    _tituloController.text = lembrete.titulo;
    _descricaoController.text = lembrete.descricao;
    _currentDate = new DateTime.utc(lembrete.data.year, lembrete.data.month,
        lembrete.data.day, lembrete.data.hour, lembrete.data.minute);
    _currentTime =
        new TimeOfDay(hour: lembrete.data.hour, minute: lembrete.data.minute);

    setState(() {});
  }

  Future<bool> _create() async {
    //var result = await post(URL_PROFILE + '/' + login, profile.toJson());
    _setModel();
    var result = await post(URL_LEMBRETE, lembrete.toJson());

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

    var result = await put(URL_LEMBRETE, widget.lembreteid, lembrete.toJson());

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
    var result = await get(URL_LEMBRETE + '/' + widget.lembreteid);

    if (result.statusCode == 200) {
      Map<String, dynamic> dados =
          Map<String, dynamic>.from(jsonDecode(result.body));
      lembrete = Lembrete.fromJson(dados);
      setState(() {
        _setControllers();
      });
    } else if (result.statusCode == 401) {
      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked_s = await showTimePicker(
        context: context,
        //initialTime: selectedTime,
        initialTime: _currentTime,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child,
          );
        });
    if (picked_s != null && picked_s != selectedTime)
      setState(() {
        selectedTime = picked_s;
      });
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
        title: Text('Cadastrar Perfil'),
      ),
      body: SingleChildScrollView(
        child: Container(
          //margin: EdgeInsets.fromLTRB(left, top, right, bottom),
          margin: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
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
                            "Data".toUpperCase(),
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        Text(
                          "${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}",
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ]),
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
                            _selectTime(context);
                          },
                          child: Text(
                            "Hora".toUpperCase(),
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        Text(
                          //"${selectedTime}",
                          "${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}",

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

                /*Column(
                  children: <Widget>[
                    RaisedButton(
                        child: Text('Add Date'), onPressed: _pickDateDialog),
                    SizedBox(height: 20),
                    Text(_selectedDate ==
                            null //ternary expression to check if date is null
                        ? 'No date chosen!'
                        : 'Picked Date: ${DateFormat.yMMMd().format(_selectedDate)}'),
                  ],
                ),*/
                Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: TextFormField(
                    autovalidate: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Informe um título para seu lembrete',
                      labelText: 'Título',
                    ),
                    controller: _tituloController,
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
                      hintText: 'Informe a descrição para seu lembrete',
                      labelText: 'Descrição',
                    ),
                    //initialValue: usuario.email,
                    //onSaved: (value) => usuario.email = value,
                    controller: _descricaoController,
                    validator: (value) =>
                        value.isEmpty ? 'Campo Obrigatório' : null,
                  ),
                ),

                /*Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: TextFormField(
                    autovalidate: false,
                    maxLength: 10,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Data de nascimento',
                      labelText: 'Data de nascimento',
                    ),
                    onSaved: (value) => profile.dateBirth = value,
                    //validator: (value) =>
                    //    value.isEmpty ? 'Campo Obrigatório' : null,
                  ),
                ),*/
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

                        if (result)
                          Navigator.of(context)
                              .pushReplacementNamed('/menu'); //deixando como

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
