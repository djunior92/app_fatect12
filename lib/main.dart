import 'package:flutter/material.dart';
import 'package:lancamentost12/pages/conta.page.dart';
import 'package:lancamentost12/pages/conta.view.dart';
import 'package:lancamentost12/pages/lembrete.page.dart';
import 'package:lancamentost12/pages/lembrete.view.dart';
import 'package:lancamentost12/pages/lista.contas.page.dart';
import 'package:lancamentost12/pages/lista.lembretes.page.dart';
import 'package:lancamentost12/pages/login.page.dart';
import 'package:lancamentost12/pages/menu.page.dart';
import 'package:lancamentost12/pages/tipo.conta.page.dart';
import 'package:lancamentost12/pages/usuario.page.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var routes = {
      '/': (context) => LoginPage(),
      '/menu': (context) => MenuPage(),
      '/usuario': (context) => UsuarioPage(novoCadastro: null),
      '/conta': (context) =>
          ContaPage(novoCadastro: null, tipo: null, contaid: null),
      '/lembrete': (context) =>
          LembretePage(novoCadastro: null, lembreteid: null),
      '/lstcontas': (context) => ListaContasPage(),
      '/lstlembretes': (context) => ListaLembretesPage(),
      '/lembreteview': (context) => LembreteViewPage(
            lembrete: null,
          ),
      '/contaview': (context) => ContaViewPage(
            conta: null,
          ),
      '/tipoconta': (context) => TipoContaPage(),
    };

    return MaterialApp(
      theme: ThemeData(
          primaryColor: const Color(0xff0daa99),
          secondaryHeaderColor: const Color(0xffF1EBBB)),
      title: 'LancamentosT12',
      debugShowCheckedModeBanner: false,
      routes: routes,
      initialRoute: '/',
    );
  }
}
