import 'package:flutter/material.dart';
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
                      Navigator.pop(context); //empéche le retour à cette vue
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
    {"Dashboard": {
      "icon": Icon(Icons.home),
      "page": HomePage()
      }
    },
    {"Presets": {
      "icon": Icon(Icons.precision_manufacturing),
      "page": PresetsPage()
    }
    },
    {"Forum": {
      "icon": Icon(Icons.forum),
      "page": ForumPage()
     }
     },
    {"Mon compte": {
      "icon": Icon(Icons.person),
      "page": AccountPage()
    }}
  ];

  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<MyAppState>();
    List<Widget> plantPilot = [];
    List<Widget> pots = [];
    List<Widget> menuTile = [];
    for (final item in data.plantPilot) {
      plantPilot.add(
          Center(child:
            Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              child:
              ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                tileColor: item["status"]! == "active" ? Colors.green[300] : Colors.grey[300],
                leading: Icon(item["status"]! == "active" ? Icons.check_circle : Icons.close),
                title: Text("PlantPilot ID : ${item["id"]!}",
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                  )
                ),
                subtitle: Text("Dernier message : ${item["last_message"]!}",
                    style: const TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic
                    )),
                onTap: () {
              Navigator.push(context,
              MaterialPageRoute(builder: (context) => ItemPage(item: item)));
              },
              )
          )
          )
      );
    }
    for (final item in data.pots) {
      pots.add(
          ListTile(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            tileColor: item["status"]! == "active" ? Colors.blue[100] : Colors.red[100],
            leading: Icon(item["status"]! == "active" ? Icons.check_circle : Icons.close),
            title: Text(style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold
            ), "Identifiant pot : ${item["id"]!}"),
            subtitle: Text(style: const TextStyle(
              fontSize: 12,
                fontStyle: FontStyle.italic
            ), "Niveau d'eau : ${item['water_level']}\nNiveau de batterie : ${item["battery_level"]}\nID PlantPilot : ${item["plantpilot_id"]}\nDernière action : ${item["last_usage"]!}"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ItemPage(item: item)));
            }
          )
      );
    }
    for (final item in pageItems) {
      var key = item.keys.first;
      var icon = item.values.first["icon"];
      Widget page = item.values.first["page"] as Widget;
      menuTile.add(ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        tileColor: Colors.grey[300],
        leading: icon,
        title: Text(key, textAlign: TextAlign.right),
        onTap: () {
          if (page.runtimeType.toString() == toString()) {
            Navigator.pop(context); //détruit la page actuel si elle est appelé
          }
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => page));
        },
      )
      );
    }
    return MaterialApp(
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true
      ),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('PlantPilot'),
            centerTitle: true,
            backgroundColor: Colors.blue,
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
                ] + menuTile,
              ),
            ),
          body: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[const Center(child: Row(children: [Icon(Icons.arrow_downward), Text("Mes PlantPilot"), Icon(Icons.arrow_downward)]))] +
                      plantPilot + [Divider(color: Colors.grey[400])] +
                      <Widget>[const Center(child: Row(children: [Icon(Icons.arrow_downward), Text("Mes pots de fleurs"), Icon(Icons.arrow_downward)]))] +
                    [
                      for (final item in pots)
                        Row(
                          children: [
                              Expanded(flex:2, child: Container(child: item))
                          ],
                        )
                    ]
              ),
            )
          )
    );
  }
}

class ItemPage extends StatelessWidget {
  Map<String, Object> item;
  ItemPage({super.key, required this.item});
  static const pageItems = [
    {"Dashboard": {
      "icon": Icon(Icons.home),
      "page": HomePage()
    }
    },
    {"Presets": {
      "icon": Icon(Icons.precision_manufacturing),
      "page": PresetsPage()
    }
    },
    {"Forum": {
      "icon": Icon(Icons.forum),
      "page": ForumPage()
    }
    },
    {"Mon compte": {
      "icon": Icon(Icons.person),
      "page": AccountPage()
    }}
  ];

  @override
  Widget build(BuildContext context) {
    List<Widget> menuTile = [];
    for (final item in pageItems) {
      var key = item.keys.first;
      var icon = item.values.first["icon"];
      Widget page = item.values.first["page"] as Widget;
      menuTile.add(ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        tileColor: Colors.grey[300],
        leading: icon,
        title: Text(key, textAlign: TextAlign.right),
        onTap: () {
          if (page.runtimeType.toString() == toString()) {
            Navigator.pop(context);
          }
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => page));
        },
      )
      );
    }
    return MaterialApp(
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
            useMaterial3: true
        ),
        home: Scaffold(
            appBar: AppBar(
              title: const Text('PlantPilot'),
              centerTitle: true,
              backgroundColor: Colors.blue,
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
                ] + menuTile,
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    if (item["type"] == "base")
                      ListTile(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                        tileColor: item["status"]! == "active" ? Colors.green[300] : Colors.grey[300],
                        leading: Icon(item["status"]! == "active" ? Icons.check_circle : Icons.close),
                        title: Text("PlantPilot ID : ${item["id"]!}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            )
                        ),
                        subtitle: Text("Dernier message : ${item["last_message"]!}",
                            style: const TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.italic
                            )),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => ItemPage(item: item)));
                        },
                      )
                    else if (item["type"] == "pot")
                      ListTile(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        tileColor: item["status"]! == "active" ? Colors.blue[100] : Colors.red[100],
                        leading: Icon(item["status"]! == "active" ? Icons.check_circle : Icons.close),
                        title: Text(style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        ), "Identifiant pot : ${item["id"]!}"),
                        subtitle: Text(style: const TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic
                        ), "Niveau d'eau : ${item['water_level']}\nNiveau de batterie : ${item["battery_level"]}\nID PlantPilot : ${item["plantpilot_id"]}\nDernière action : ${item["last_usage"]!}"),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => ItemPage(item: item)));
                        }
                    )
                  ],
              ),
            )
        )
    );
  }
}

class PresetsPage extends StatelessWidget {
  const PresetsPage({super.key});
  static const pageItems = [
    {"Dashboard": {
      "icon": Icon(Icons.home),
      "page": HomePage()
    }
    },
    {"Presets": {
      "icon": Icon(Icons.precision_manufacturing),
      "page": PresetsPage()
    }
    },
    {"Forum": {
      "icon": Icon(Icons.forum),
      "page": ForumPage()
    }
    },
    {"Mon compte": {
      "icon": Icon(Icons.person),
      "page": AccountPage()
    }}
  ];

  @override
  Widget build(BuildContext context) {
    List<Widget> menuTile = [];
    for (final item in pageItems) {
      var key = item.keys.first;
      var icon = item.values.first["icon"];
      Widget page = item.values.first["page"] as Widget;
      menuTile.add(ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        tileColor: Colors.grey[300],
        leading: icon,
        title: Text(key, textAlign: TextAlign.right),
        onTap: () {
          if (page.runtimeType.toString() == toString()) {
            Navigator.pop(context);
          }
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => page));
        },
      )
      );
    }
    return MaterialApp(
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
            useMaterial3: true
        ),
        home: Scaffold(
            appBar: AppBar(
              title: const Text('PlantPilot'),
              centerTitle: true,
              backgroundColor: Colors.blue,
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
                ] + menuTile,
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Center(child: Row(children: [Icon(Icons.arrow_downward), Text("Mes Presets"), Icon(Icons.arrow_downward)])),
                  for (final item in data.presets)
                    ListTile(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        tileColor: Colors.grey[300],
                        title: Text(style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        ), "Nom : ${item["preset_name"]!}"),
                        subtitle: Text(style: const TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic
                          ),
                            "Crée par : ${item['created_by']}\nCrée le : ${item["created_at"]}\n"),
                        onTap: () {
                          /*Navigator.push(context,
                              MaterialPageRoute(builder: (context) => ItemPage(item: item)));*/
                        }
                    )
                ]
              ),
            ),
            floatingActionButton: FloatingActionButton(
                    onPressed: () => {},
              tooltip: 'Créer un nouveau preset',
              child: const Icon(Icons.add),
    )
        )
    );
  }
}


class ForumPage extends StatelessWidget {
  const ForumPage({super.key});
  static const pageItems = [
    {"Dashboard": {
      "icon": Icon(Icons.home),
      "page": HomePage()
    }
    },
    {"Presets": {
      "icon": Icon(Icons.precision_manufacturing),
      "page": PresetsPage()
    }
    },
    {"Forum": {
      "icon": Icon(Icons.forum),
      "page": ForumPage()
    }
    },
    {"Mon compte": {
      "icon": Icon(Icons.person),
      "page": AccountPage()
    }}
  ];

  @override
  Widget build(BuildContext context) {
    List<Widget> menuTile = [];
    for (final item in pageItems) {
      var key = item.keys.first;
      var icon = item.values.first["icon"];
      Widget page = item.values.first["page"] as Widget;
      menuTile.add(ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        tileColor: Colors.grey[300],
        leading: icon,
        title: Text(key, textAlign: TextAlign.right),
        onTap: () {
          if (page.runtimeType.toString() == toString()) {
            Navigator.pop(context);
          }
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => page));
        },
      )
      );
    }
    return MaterialApp(
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
            useMaterial3: true
        ),
        home: Scaffold(
            appBar: AppBar(
              title: const Text('PlantPilot'),
              centerTitle: true,
              backgroundColor: Colors.blue,
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
                ] + menuTile,
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Center(child: Row(children: [Icon(Icons.arrow_downward), Text("Les topics"), Icon(Icons.arrow_downward)])),
                    for (final item in data.topics)
                      ListTile(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                          tileColor: Colors.grey[300],
                          leading: const Icon(Icons.topic),
                          title: Text(style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                          ), "Sujet : ${item["topic_name"]!}"
                          ),
                          subtitle: Text(style: const TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic
                          ),
                              "Crée par : ${item['created_by']}\nCrée le : ${item["created_at"]}\nDernier message par : ${item["last_message_by"]}\nDernier message le : ${item["last_message_at"]}\nNombre de message(s) : ${item["total_messages"]}"),
                          onTap: () {
                            /*Navigator.push(context,
                              MaterialPageRoute(builder: (context) => ItemPage(item: item)));*/
                          }
                      )
                  ]
              ),
            ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => {},
            tooltip: 'Créer un nouveau preset',
            child: const Icon(Icons.add),
          )
            )
    );
  }
}

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});
  static const pageItems = [
    {"Dashboard": {
      "icon": Icon(Icons.home),
      "page": HomePage()
    }
    },
    {"Presets": {
      "icon": Icon(Icons.precision_manufacturing),
      "page": PresetsPage()
    }
    },
    {"Forum": {
      "icon": Icon(Icons.forum),
      "page": ForumPage()
    }
    },
    {"Mon compte": {
      "icon": Icon(Icons.person),
      "page": AccountPage()
    }}
  ];

  @override
  Widget build(BuildContext context) {
    List<Widget> menuTile = [];
    for (final item in pageItems) {
      var key = item.keys.first;
      var icon = item.values.first["icon"];
      Widget page = item.values.first["page"] as Widget;
      menuTile.add(ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        tileColor: Colors.grey[300],
        leading: icon,
        title: Text(key, textAlign: TextAlign.right),
        onTap: () {
          if (page.runtimeType.toString() == toString()) {
            Navigator.pop(context);
          }
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => page));
        },
      )
      );
    }
    return MaterialApp(
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
            useMaterial3: true
        ),
        home: Scaffold(
            appBar: AppBar(
              title: const Text('PlantPilot'),
              centerTitle: true,
              backgroundColor: Colors.blue,
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
                ] + menuTile,
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(this.runtimeType.toString())
                ],
              ),
            )
        )
    );
  }
}