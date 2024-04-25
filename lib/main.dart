import "dart:core";
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plantpilot_mobile_app/tools.dart';
import 'package:plantpilot_mobile_app/http.dart';
import "package:plantpilot_mobile_app/data.dart";
import "package:plantpilot_mobile_app/data_from_models.dart";
import "package:realm/realm.dart";
import "models/account.dart";
import "models/message.dart";
import "models/plant_pilot.dart";
import "models/pot.dart";
import "models/preset.dart";
import "models/topic.dart";

Account account = getAccount();
List<Topic> topics = getTopics();
List<Message> messages = getMessages(topics);
PlantPilot plantPilot = getPlantPilot();
List<Pot> pots = getPots(plantPilot);
List<Preset> presets = getPresets();
var data = LocalData();
var appTools = Tools();
var httpRequest = Http();

/// Point d'entré de l'application
void main() {
  runApp(const MyApp());
}

/// Widget root, définie le titre de l'application,
/// le template de style et appel le Widget LoginPage
/// Stateless car son etat ne change pas en cours d'éxecution
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => MyAppState(),
        child: MaterialApp(
          title: 'PlantPilot App',
          theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
              useMaterial3: true),
          home: const LoginPage(),
        ));
  }
}

class MyAppState extends ChangeNotifier {}

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
  Future<bool> _onLoginClick(login, password) async {
    setState(() {
      this.login = login;
      this.password = password;
    });
    //var response = await httpRequest.login(this.login, this.password);
    //var json = (jsonDecode(response) as List).cast<Map<String, dynamic>>();
    return true; // return true temporaire, devra faire un call API pour vérifier le login
    /*if (json["allowed"]) {
      return true;
    } else {
      return false;
    }*/
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
                  child: Image(image: AssetImage("assets/LogoE-PlantCare.PNG"))),
              SizedBox(
                height: 50,
                width: 300,
                child: TextField(
                  controller: loginController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Login ou adresse mail',
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.all(5)),
              SizedBox(
                height: 50,
                width: 300,
                child: TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Mot de passe',
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.all(5)),
              SizedBox(
                  child: Text(loginAttempt,
                      style: const TextStyle(color: Colors.red))),
              const Padding(padding: EdgeInsets.all(5)),
              SizedBox(
                child: TextButton(
                    style: TextButton.styleFrom(backgroundColor: Colors.blue[50]),
                    onPressed: () async {
                      if (await _onLoginClick(
                          loginController.text, passwordController.text)) {
                        loginAttempt = "";
                        Navigator.pop(context); //empéche le retour à cette vue
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                const HomePage())); // à modifier par pushReplacement pour empecher le retour à la page de login
                      } else {
                        loginAttempt =
                        "Le login et/ou le mot de passe n'est pas valide.";
                      }
                    },
                    child: const Text("Se connecter")),
              ),
              SizedBox(
                child: TextButton(
                    style: TextButton.styleFrom(backgroundColor: Colors.blue[50]),
                    onPressed: () {
                      throw UnimplementedError("A dev");
                    },
                    child: const Text("Mot de passe oublié")),
              ),
              SizedBox(
                child: TextButton(
                    style: TextButton.styleFrom(backgroundColor: Colors.blue[50]),
                    onPressed: () {
                      throw UnimplementedError("A dev");
                    },
                    child: const Text("Créer un compte")),
              ),
            ],
          ),
        ));
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const pageItems = [
    {
      "Dashboard": {"icon": Icon(Icons.home), "page": HomePage()}
    },
    {
      "Presets": {
        "icon": Icon(Icons.precision_manufacturing),
        "page": PresetsPage()
      }
    },
    {
      "Forum": {"icon": Icon(Icons.forum), "page": ForumPage()}
    },
    {
      "Mon compte": {"icon": Icon(Icons.person), "page": AccountPage()}
    }
  ];

  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<MyAppState>();
    List<Widget> plantPilot = [];
    List<Widget> pots = [];
    List<Widget> menuTile = [];
    for (final item in data.plantPilot) {
      plantPilot.add(Card(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          child: ListTile(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            tileColor: item["status"]! == "active"
                ? Colors.green[300]
                : Colors.grey[300],
            leading: Icon(
                item["status"]! == "active" ? Icons.check_circle : Icons.close),
            title: Text("PlantPilot ID : ${item["id"]!}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )),
            subtitle: Text("Dernier message : ${item["last_message"]!}",
                style:
                const TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ItemDetailPage(item: item)));
            },
          )));
    }
    for (final item in data.pots) {
      pots.add(Card(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              tileColor: item["status"]! == "active"
                  ? Colors.blue[100]
                  : Colors.red[100],
              leading: Icon(item["status"]! == "active"
                  ? Icons.check_circle
                  : Icons.close),
              title: Text(
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                  "Identifiant pot : ${item["id"]!}"),
              subtitle: Text(
                  style: const TextStyle(
                      fontSize: 12, fontStyle: FontStyle.italic),
                  "Niveau d'eau : ${item['water_level']}\nNiveau de batterie : ${item["battery_level"]}\nID PlantPilot : ${item["plantpilot_id"]}\nDernière action : ${item["last_usage"]!}"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ItemDetailPage(item: item)));
              })));
    }
    for (final item in pageItems) {
      var key = item.keys.first;
      var icon = item.values.first["icon"];
      Widget page = item.values.first["page"] as Widget;
      menuTile.add(Card(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          child: ListTile(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            tileColor: Colors.grey[300],
            leading: icon,
            title: Text(key, textAlign: TextAlign.right),
            onTap: () {
              if (page.runtimeType.toString() == toString()) {
                Navigator.pop(context);
              }
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => page));
            },
          )));
    }
    return Scaffold(
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
            ] +
                menuTile,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Center(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_downward),
                          Text("Mes PlantPilot"),
                          Icon(Icons.arrow_downward)
                        ]))
              ] +
                  plantPilot +
                  [Divider(color: Colors.grey[400])] +
                  <Widget>[
                    const Center(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.arrow_downward),
                              Text("Mes pots de fleurs"),
                              Icon(Icons.arrow_downward)
                            ]))
                  ] +
                  [
                    for (final item in pots)
                      Row(
                        children: [
                          Expanded(flex: 2, child: Container(child: item))
                        ],
                      )
                  ]),
        ));
  }
}

class ItemDetailPage extends StatefulWidget {
  final Map<String, Object> item;

  const ItemDetailPage({super.key, required this.item});

  static const pageItems = [
    {
      "Dashboard": {"icon": Icon(Icons.home), "page": HomePage()}
    },
    {
      "Presets": {
        "icon": Icon(Icons.precision_manufacturing),
        "page": PresetsPage()
      }
    },
    {
      "Forum": {"icon": Icon(Icons.forum), "page": ForumPage()}
    },
    {
      "Mon compte": {"icon": Icon(Icons.person), "page": AccountPage()}
    }
  ];

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  @override
  Widget build(BuildContext context) {
    List<Widget> menuTile = [];
    List<Widget> diplayedItem = [];
    List<DropdownMenuEntry> presets = [];
    for (final item in ItemDetailPage.pageItems) {
      var key = item.keys.first;
      var icon = item.values.first["icon"];
      Widget page = item.values.first["page"] as Widget;
      menuTile.add(Card(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          child: ListTile(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            tileColor: Colors.grey[300],
            leading: icon,
            title: Text(key, textAlign: TextAlign.right),
            onTap: () {
              if (page.runtimeType.toString() == toString()) {
                Navigator.pop(context);
              }
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => page));
            },
          )));
    }
    if (widget.item["type"] == "base") {
      diplayedItem.add(const Center(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.arrow_downward),
            Text("Détails de mon PlantPilot"),
            Icon(Icons.arrow_downward)
          ])));
      diplayedItem.add(ListTile(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          tileColor: widget.item["status"]! == "active"
              ? Colors.green[300]
              : Colors.grey[300],
          leading: Icon(widget.item["status"]! == "active"
              ? Icons.check_circle
              : Icons.close),
          title: Text("PlantPilot ID : ${widget.item["id"]!}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              )),
          subtitle: Text(
              "Statut : ${widget.item["status"] == "active" ? "Actif" : "Inactif"}\nDernier message : ${widget.item["last_message"]!}",
              style:
              const TextStyle(fontSize: 12, fontStyle: FontStyle.italic))));
      diplayedItem.add(Divider(color: Colors.grey[400]));
      diplayedItem.add(const Center(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.arrow_downward),
            Text("Détails des pots associés"),
            Icon(Icons.arrow_downward)
          ])));
      for (final element in data.pots) {
        if (widget.item["id"] == element["plantpilot_id"]) {
          diplayedItem.add(Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  tileColor: element["status"]! == "active"
                      ? Colors.blue[100]
                      : Colors.red[100],
                  leading: Icon(element["status"]! == "active"
                      ? Icons.check_circle
                      : Icons.close),
                  title: Text(
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                      "Identifiant pot : ${element["id"]!}"),
                  subtitle: Text(
                      style: const TextStyle(
                          fontSize: 12, fontStyle: FontStyle.italic),
                      "Niveau d'eau : ${element['water_level']}\nNiveau de batterie : ${element["battery_level"]}\nID PlantPilot : ${element["plantpilot_id"]}\nDernière action : ${element["last_usage"]}"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ItemDetailPage(item: element)));
                  })));
        }
      }
    } else if (widget.item["type"] == "pot") {
      diplayedItem.add(const Center(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.arrow_downward),
            Text("Détails de mon pot de fleur"),
            Icon(Icons.arrow_downward)
          ])));
      diplayedItem.add(Card(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              tileColor: widget.item["status"]! == "active"
                  ? Colors.blue[100]
                  : Colors.red[100],
              leading: Icon(widget.item["status"]! == "active"
                  ? Icons.check_circle
                  : Icons.close),
              title: Text(
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                  "Identifiant pot : ${widget.item["id"]!}"),
              subtitle: Text(
                  style: const TextStyle(
                      fontSize: 12, fontStyle: FontStyle.italic),
                  "Niveau d'eau : ${widget.item['water_level']}\nNiveau de batterie : ${widget.item["battery_level"]}\nID PlantPilot : ${widget.item["plantpilot_id"]}\nDernière action : ${widget.item["last_usage"]!}"),
              onTap: () {})));
      diplayedItem.add(Divider(color: Colors.grey[300]));
      diplayedItem.add(Column(children: [
        const Text("Choisissez un preset à associer au pot"),
        DropdownMenu(
          dropdownMenuEntries: presets,
        ),
        TextButton(
            style: TextButton.styleFrom(backgroundColor: Colors.blue[50]),
            onPressed: () {
              throw UnimplementedError("A dev");
            },
            child: const Text("Arrosage manuel"))
      ]));
    }
    for (final item in data.presets) {
      presets.add(
          DropdownMenuEntry(value: item, label: item["preset_name"] as String));
    }
    return Scaffold(
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
            ] +
                menuTile,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: diplayedItem),
        ),
        floatingActionButton: widget.item["type"] == "pot"
            ? FloatingActionButton(
          onPressed: () => {},
          tooltip: 'Sauvegarder le preset associé',
          child: const Icon(Icons.save),
        )
            : null);
  }
}

class PresetsPage extends StatefulWidget {
  const PresetsPage({super.key});

  static const pageItems = [
    {
      "Dashboard": {"icon": Icon(Icons.home), "page": HomePage()}
    },
    {
      "Presets": {
        "icon": Icon(Icons.precision_manufacturing),
        "page": PresetsPage()
      }
    },
    {
      "Forum": {"icon": Icon(Icons.forum), "page": ForumPage()}
    },
    {
      "Mon compte": {"icon": Icon(Icons.person), "page": AccountPage()}
    }
  ];

  @override
  State<PresetsPage> createState() => _PresetsPageState();
}

class _PresetsPageState extends State<PresetsPage> {
  @override
  Widget build(BuildContext context) {
    List<Widget> menuTile = [];
    for (final item in PresetsPage.pageItems) {
      var key = item.keys.first;
      var icon = item.values.first["icon"];
      Widget page = item.values.first["page"] as Widget;
      menuTile.add(Card(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          child: ListTile(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            tileColor: Colors.grey[300],
            leading: icon,
            title: Text(key, textAlign: TextAlign.right),
            onTap: () {
              if (page.runtimeType.toString() == toString()) {
                Navigator.pop(context);
              }
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => page));
            },
          )));
    }
    return Scaffold(
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
            ] +
                menuTile,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_downward),
                      Text("Mes Presets"),
                      Icon(Icons.arrow_downward)
                    ]),
                for (final item in data.presets)
                  Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      child: ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          tileColor: Colors.grey[300],
                          title: Text(
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              "Nom : ${item["preset_name"]!}"),
                          subtitle: Text(
                              style: const TextStyle(
                                  fontSize: 12, fontStyle: FontStyle.italic),
                              "Crée par : ${item['created_by']}\nCrée le : ${item["created_at"]}\n"),
                          onTap: () {
                            /*Navigator.push(context,
                              MaterialPageRoute(builder: (context) => ItemDetailPage(item: item)));*/
                          })
                  )
              ]),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const CreatePreset())).then((_) => setState(() {
                  print("refresh");
                }))
          },
          tooltip: 'Créer un nouveau preset',
          child: const Icon(Icons.add),
        ));
  }
}

class CreatePreset extends StatefulWidget {
  const CreatePreset({super.key});

  static const pageItems = [
    {
      "Dashboard": {"icon": Icon(Icons.home), "page": HomePage()}
    },
    {
      "Presets": {
        "icon": Icon(Icons.precision_manufacturing),
        "page": PresetsPage()
      }
    },
    {
      "Forum": {"icon": Icon(Icons.forum), "page": ForumPage()}
    },
    {
      "Mon compte": {"icon": Icon(Icons.person), "page": AccountPage()}
    }
  ];

  @override
  State<CreatePreset> createState() => _CreatePresetState();
}

class _CreatePresetState extends State<CreatePreset> {
  String presetName = "";

  //String password = "";
  final presetNameController = TextEditingController();

  //final passwordController = TextEditingController();
  double _sliderQuantityValue = 10;
  double _sliderIntervalValue = 1;

  @override
  Widget build(BuildContext context) {
    List<Widget> menuTile = [];
    for (final item in CreatePreset.pageItems) {
      var key = item.keys.first;
      var icon = item.values.first["icon"];
      Widget page = item.values.first["page"] as Widget;
      menuTile.add(Card(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          child: ListTile(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            tileColor: Colors.grey[300],
            leading: icon,
            title: Text(key, textAlign: TextAlign.right),
            onTap: () {
              if (page.runtimeType.toString() == toString()) {
                Navigator.pop(context);
              }
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => page));
            },
          )));
    }
    return Scaffold(
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
          ] +
              menuTile,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.arrow_downward),
              Text("Créer mon preset"),
              Icon(Icons.arrow_downward)
            ]),
            const Padding(padding: EdgeInsets.all(20)),
            const Text("Nom du preset"),
            const Padding(padding: EdgeInsets.all(5)),
            SizedBox(
              height: 50,
              width: 300,
              child: TextField(
                controller: presetNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Nom du preset",
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.all(20)),
            Text("Quantité d'eau (en ml): ${_sliderQuantityValue.round()}"),
            SizedBox(
              width: 350,
              child: Slider(
                value: _sliderQuantityValue,
                min: 10,
                max: 100,
                divisions: 9,
                label: _sliderQuantityValue.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _sliderQuantityValue = value;
                  });
                },
              ),
            ),
            const Padding(padding: EdgeInsets.all(20)),
            Text(
                "Interval d'arrosage (en heure): ${_sliderIntervalValue.round()}"),
            SizedBox(
                width: 350,
                child: Slider(
                  value: _sliderIntervalValue,
                  min: 1,
                  max: 72,
                  divisions: 71,
                  label: _sliderIntervalValue.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      _sliderIntervalValue = value;
                    });
                  },
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => {
          data.presets.add(
          {
            "id": "789",
            "preset_name": presetNameController.text,
            "created_by": data.account["username"] as String,
            "created_at": DateTime.now(),
            "parameters": {
              "water_quantity": _sliderQuantityValue,
              "interval": _sliderIntervalValue
            }
          }
          ),
          Navigator.pop(context, true)
    },
      tooltip: 'Sauvegarder le preset',
      child: const Icon(Icons.save),
    ));
  }
}

class ForumPage extends StatelessWidget {
  const ForumPage({super.key});

  static const pageItems = [
    {
      "Dashboard": {"icon": Icon(Icons.home), "page": HomePage()}
    },
    {
      "Presets": {
        "icon": Icon(Icons.precision_manufacturing),
        "page": PresetsPage()
      }
    },
    {
      "Forum": {"icon": Icon(Icons.forum), "page": ForumPage()}
    },
    {
      "Mon compte": {"icon": Icon(Icons.person), "page": AccountPage()}
    }
  ];

  @override
  Widget build(BuildContext context) {
    List<Widget> menuTile = [];
    for (final item in pageItems) {
      var key = item.keys.first;
      var icon = item.values.first["icon"];
      Widget page = item.values.first["page"] as Widget;
      menuTile.add(Card(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          child: ListTile(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            tileColor: Colors.grey[300],
            leading: icon,
            title: Text(key, textAlign: TextAlign.right),
            onTap: () {
              if (page.runtimeType.toString() == toString()) {
                Navigator.pop(context);
              }
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => page));
            },
          )));
    }
    return Scaffold(
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
            ] +
                menuTile,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Center(
                    child: Row(children: [
                      Icon(Icons.arrow_downward),
                      Text("Les topics"),
                      Icon(Icons.arrow_downward)
                    ])
                ),
                for (final item in topics)
                  ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      tileColor: Colors.grey[300],
                      leading: const Icon(Icons.topic),
                      title: Text(
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          "Sujet : ${item.name}"),
                      subtitle: Text(
                          style: const TextStyle(
                              fontSize: 12, fontStyle: FontStyle.italic),
                          "Crée par : ${item.createdBy}\nCrée le : ${item.createdAt}\nDernier message par : ${item.lastMessageBy}\nDernier message le : ${item.lastMessageAt}\nNombre de message(s) : ${item.messageCount}"),
                      onTap: () {
                        Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const AccountPage()));
                      })
              ]),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => {},
          tooltip: 'Créer un nouveau preset',
          child: const Icon(Icons.add),
        ));
  }
}

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  static const pageItems = [
    {
      "Dashboard": {"icon": Icon(Icons.home), "page": HomePage()}
    },
    {
      "Presets": {
        "icon": Icon(Icons.precision_manufacturing),
        "page": PresetsPage()
      }
    },
    {
      "Forum": {"icon": Icon(Icons.forum), "page": ForumPage()}
    },
    {
      "Mon compte": {"icon": Icon(Icons.person), "page": AccountPage()}
    }
  ];

  @override
  Widget build(BuildContext context) {
    List<Widget> menuTile = [];
    for (final item in pageItems) {
      var key = item.keys.first;
      var icon = item.values.first["icon"];
      Widget page = item.values.first["page"] as Widget;
      menuTile.add(Card(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          child: ListTile(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            tileColor: Colors.grey[300],
            leading: icon,
            title: Text(key, textAlign: TextAlign.right),
            onTap: () {
              if (page.runtimeType.toString() == toString()) {
                Navigator.pop(context);
              }
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => page));
            },
          )));
    }
    return Scaffold(
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
            ] +
                menuTile,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[Text(runtimeType.toString())],
          ),
        ));
  }
}