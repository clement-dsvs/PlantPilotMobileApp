import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
import 'dart:io' as io show Platform;
import 'package:provider/provider.dart';


/// Point d'entré de l'application
void main() {
  var platform = io.Platform.operatingSystem; //Get l'os hôte
  print(platform);
  runApp(const MyApp());
}

/// Widget root, définie le titre de l'application,
/// le template de style et appel le Widget LoginPage
/// Stateless car son etat ne change pas en cours d'éxecution
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(  // a modifier
        create: (context) => MyAppState(),
        child: MaterialApp(
          title: 'PlantPilot App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
            useMaterial3: true
          ),
          home: const LoginPage(title: 'PlantPilot Login'),
        )
    );
  }
}

class MyAppState extends ChangeNotifier {

}

/// Widget LoginPage, Stateful car son état est susceptible de
/// changer au cours de l'éxecution
class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required String title});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

/// State associé au Widget LoginPage
class _LoginPageState extends State<LoginPage> {
  String login = "";
  String password = "";
  final loginController = TextEditingController();
  final passwordController = TextEditingController();

  /// Méthode qui va assigner aux propriétés les valeurs des TextField
  void _onLoginClick(login, password) {
    setState(() {
      this.login = login;
      this.password = password;
    });
    print("${this.login} ${this.password}");
  }

  /// Clean les TextField
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    loginController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
                height: 200,
                width: 200,
                child: Image(image: AssetImage("assets/LogoE-PlantCare.PNG"))
            ),
            SizedBox(
              height: 50,
              width: 300,
              child: TextField(
                controller: loginController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Login ou adresse mail',
                ),
              ),
            ),
            Padding(padding: EdgeInsets.all(5)),
            SizedBox(
              height: 50,
              width: 300,
              child: TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Mot de passe',
                ),
              ),
            ),
            Padding(padding: EdgeInsets.all(10)),
            SizedBox(
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue[50]
                ),
                  onPressed: () {
                    _onLoginClick(loginController.text, passwordController.text);
                  },
                  child: const Text("Se connecter")),
            ),
            SizedBox(
              child: TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.blue[50]
                  ),
                  onPressed: () {
                    throw UnimplementedError("A dev");
                  },
                  child: const Text("Mot de passe oublié")),
            ),
            SizedBox(
              child: TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.blue[50]
                  ),
                  onPressed: () {
                    throw UnimplementedError("A dev");
                  },
                  child: const Text("Créer un compte")),
            ),
          ],
        ),
      )
    );
  }
}

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return TextButton(
        style: TextButton.styleFrom(
            backgroundColor: Colors.blue[50]
        ),
        onPressed: () {},
        child: const Text("Créer un compte")
    );
  }
  
}
