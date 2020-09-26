import 'package:flutter/material.dart';
import 'package:lancamentost12/pages/login.page.dart';
import 'package:lancamentost12/pages/menu.page.dart';
import 'package:lancamentost12/pages/usuario.page.dart';

void main() => runApp(App());
/*void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(App());
  });
}*/

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var routes = {
      '/': (context) => LoginPage(),
      '/menu': (context) => MenuPage(),
      '/usuario': (context) => UsuarioPage(
            novoCadastro: null,
          ),
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
