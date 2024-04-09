import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
//import 'package:plantpilot_mobile_app/tools.dart';
//import 'package:plantpilot_mobile_app/http.dart';
import "package:plantpilot_mobile_app/data.dart";

//var tools = Tools();
//var http = Http();
//var res = http.fetchAlbum();
var data = LocalData();

/// Point d'entré de l'application
void main() {
  //print(platform);
  // runApp(const MaterialApp(
  //   home: MyApp()
  // ));
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
          home: const LoginPage(),
        )
    );
  }
}

class MyAppState extends ChangeNotifier {

}

/// Widget LoginPage, Stateful car son état est susceptible de
/// changer au cours de l'éxecution
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

/// State associé au Widget LoginPage
class _LoginPageState extends State<LoginPage> {
  String login = "";
  String password = "";
  String loginAttempt = "";
  final loginController = TextEditingController();
  final passwordController = TextEditingController();

  /// Méthode qui va assigner aux propriétés les valeurs des TextField
  bool _onLoginClick(login, password) {
    setState(() {
      this.login = login;
      this.password = password;
    });
    print("${this.login} ${this.password}");
    return true;  // return true temporaire, devra faire un call API pour vérifier le login
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
            Padding(padding: EdgeInsets.all(5)),
            SizedBox(
              child: Text(loginAttempt, style: const TextStyle(color: Colors.red))
            ),
            Padding(padding: EdgeInsets.all(5)),
            SizedBox(
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue[50]
                ),
                  onPressed: () {
                    if (_onLoginClick(loginController.text, passwordController.text)) {
                      loginAttempt = "";
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const HomePage())); // à modifier par pushReplacement pour empecher le retour à la page de login
                    } else {
                      loginAttempt = "Le login et/ou le mot de passe n'est pas valide.";
                    }
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
  const HomePage({super.key});
  static const pageItems = [
    "Dashboard",
    "MyPresets",
    "Forum",
    "MyAccount",
  ];

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text('PlantPilot'),
          ),
            drawer: Drawer(
              child: ListView(
                children: <Widget>[
                  const DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Text('Menu'),
                  ),
                  for (final item in pageItems)
                    ListTile(
                      title: Text(item),
                      onTap: () {
                        // Update the state of the app
                        // Then close the drawer
                        Navigator.pop(context);
                      },
                    ),
                ],
              ),
            ),
          body: Column(
            children: [
              Text("merde"),
              Row(
                children: [],
              ),
              Row(
                  children: [])
            ]
          )
        )
    );
  }
}
