import "dart:convert";
import "dart:core";
import "package:collection/collection.dart";
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plantpilot_mobile_app/tools.dart';
import 'package:plantpilot_mobile_app/http.dart';
import "package:plantpilot_mobile_app/data_from_models.dart";
import "package:realm/realm.dart";
import "models/account.dart";
import "models/message.dart";
import "models/plant_pilot.dart";
import "models/pot.dart";
import "models/preset.dart";
import "models/topic.dart";

Tools appTools = Tools();
Http httpRequest = Http();
Account account = getAccount();
List<Topic> topics = getTopics();
List<Message> messages = getMessages(topics);
List<PlantPilot> plantPilot = getPlantPilot();
List<Pot> pots = [];
List<Preset> presets = [];
final pageItems = appTools.getMenuItems();

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
  Future<bool> _onLoginClick() async {
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
                      setState(() {
                        login = loginController.text;
                        password = passwordController.text;
                      });
                      /*
                      if (login == "" || password == "") {
                        return showDialog(context: context, builder: (BuildContext context) => AlertDialog(
                          title: Center(child: Text("Erreur")),
                          content: Text("Un des champs requis n'a pas été renseigné"),
                          actions: [TextButton(onPressed: () {
                            Navigator.pop(context);
                          }, child: Text("Ok"))
                          ],
                        )) ;
                      } else {*/
                      if (await _onLoginClick()) {
                        loginAttempt = "";
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()));
                      } else {
                        loginAttempt =
                        "Le login et/ou le mot de passe n'est pas valide.";
                      }
                      //}
                    },
                    child: const Text("Se connecter")),
              ),
              SizedBox(
                child: TextButton(
                    style: TextButton.styleFrom(backgroundColor: Colors.blue[50]),
                    onPressed: () {},
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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<HttpReturn> devicesReq =
  httpRequest.request(method: "get", url: "devices");
  late Future<HttpReturn> presetsReq =
  httpRequest.request(method: "get", url: "preset");
  List<Pot> potsFromJson = [];
  List<Widget> plantPilotWidgets = [];
  List<Widget> potsWidgets = [];
  List<Widget> menuTileWidgets = [];

  @override
  void initState() {
    super.initState();
    pots = [];
    presets = [];
    for (final item in plantPilot) {
      plantPilotWidgets.add(Card(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          child: ListTile(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            tileColor:
            item.status == "active" ? Colors.green[300] : Colors.grey[300],
            leading: Icon(
                item.status == "active" ? Icons.check_circle : Icons.close),
            title: Text("Nom PlantPilot: ${item.name}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )),
            subtitle: Text(
                "Dernier message : ${DateFormat('dd-MM-yyy HH:mm:ss').format(item.lastMessage)}",
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
    devicesReq.then((value) {
      var data = jsonDecode(value.data);
      for (final item in data) {
        pots.add(Pot(
            id: ObjectId.fromHexString(item["_id"]["\$oid"]),
            name: item["name"],
            status: item["status"],
            waterLevel: item["water_level"],
            batteryLevel: item["battery_level"],
            plantPilotId: plantPilot.first.id,
            humidity: item["humidity"],
            lastWatering:
            DateTime.parse(item["last_watering"]["\$date"].toString())));
      }
      for (final item in pots) {
        potsWidgets.add(Card(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            child: ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                tileColor: item.status == "connected"
                    ? Colors.blue[100]
                    : Colors.red[100],
                leading: Icon(item.status == "connected"
                    ? Icons.check_circle
                    : Icons.close),
                title: Text(
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    "Nom pot: ${item.name}"),
                subtitle: Text(
                    style: const TextStyle(
                        fontSize: 12, fontStyle: FontStyle.italic),
                    "Niveau d'eau : ${item.waterLevel}\nNiveau de batterie : ${item.batteryLevel}\nDernière action : ${item.lastWatering ?? "inconnue"}"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ItemDetailPage(item: item)));
                })));
      }
    });
    presetsReq.then((value) {
      var data = jsonDecode(value.data);
      for (final item in data) {
        presets.add(Preset(
            id: ObjectId.fromHexString(item["_id"]["\$oid"]),
            name: item["name"],
            createdBy: item["created_by"],
            createdAt: DateTime.parse(item["created_at"]["\$date"].toString()),
            waterQuantity: item["water_quantity"],
            timeInterval: item["time_interval"]));
      }
      if (presets.isEmpty) {
        for (var i = 0; i < pots.length; i++) {
          pots[i].preset = null;
        }
      }
    });
    for (final item in pageItems) {
      var key = item.keys.first;
      var icon = item.values.first["icon"];
      Widget page = item.values.first["page"] as Widget;
      menuTileWidgets.add(Card(
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
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<HttpReturn>(
        future: devicesReq,
        builder: (context, snapshot) {
          Widget scaffold;
          if (snapshot.hasData) {
            scaffold = Scaffold(
                appBar: AppBar(
                    title: const Text('PlantPilot'),
                    centerTitle: true,
                    backgroundColor: Colors.blue),
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
                        menuTileWidgets,
                  ),
                ),
                body: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const Center(
                              child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.arrow_downward),
                                    Text("Mes PlantPilot"),
                                    Icon(Icons.arrow_downward)
                                  ]))
                        ] +
                            plantPilotWidgets +
                            [Divider(color: Colors.grey[400])] +
                            <Widget>[
                              const Center(
                                  child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.arrow_downward),
                                        Text("Mes pots de fleurs"),
                                        Icon(Icons.arrow_downward)
                                      ]))
                            ] +
                            [
                              for (final item in potsWidgets)
                                Row(
                                  children: [
                                    Expanded(
                                        flex: 2, child: Container(child: item))
                                  ],
                                )
                            ])));
          } else {
            scaffold = Scaffold(
                appBar: AppBar(
                    title: const Text('PlantPilot'),
                    centerTitle: true,
                    backgroundColor: Colors.blue),
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
                        menuTileWidgets,
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
                          plantPilotWidgets +
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
                          [const CircularProgressIndicator()]),
                ));
          }
          return scaffold;
        });
  }
}

class ItemDetailPage extends StatefulWidget {
  final dynamic item;

  const ItemDetailPage({super.key, required this.item});

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  static Preset? _selectedPreset;
  double _sliderQuantityValue = 50;

  @override
  void initState() {
    super.initState();
    if (widget.item is Pot && widget.item.preset != null) {
      _selectedPreset =
          presets.firstWhere((element) => widget.item.preset == element.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> menuTileWidgets = [];
    List<Widget> diplayedItemWidgets = [];
    List<DropdownMenuEntry<Preset>> presetsEntries = [];
    for (final item in pageItems) {
      var key = item.keys.first;
      var icon = item.values.first["icon"];
      Widget page = item.values.first["page"] as Widget;
      menuTileWidgets.add(Card(
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
    if (widget.item is PlantPilot) {
      diplayedItemWidgets.add(const Center(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.arrow_downward),
            Text("Détails de mon PlantPilot"),
            Icon(Icons.arrow_downward)
          ])));
      diplayedItemWidgets.add(ListTile(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          tileColor: widget.item.status == "active"
              ? Colors.green[300]
              : Colors.grey[300],
          leading: Icon(widget.item.status == "active"
              ? Icons.check_circle
              : Icons.close),
          title: Text("Nom PlantPilot: ${widget.item.name}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              )),
          subtitle: Text(
              "ID: ${widget.item.id}\nStatut : ${widget.item.status == "active" ? "Actif" : "Inactif"}\nDernier message : ${DateFormat('dd-MM-yyy HH:mm:ss').format(widget.item.lastMessage)}",
              style:
              const TextStyle(fontSize: 12, fontStyle: FontStyle.italic))));
      diplayedItemWidgets.add(Divider(color: Colors.grey[400]));
      diplayedItemWidgets.add(const Center(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.arrow_downward),
            Text("Détails des pots associés"),
            Icon(Icons.arrow_downward)
          ])));
      for (final element in pots) {
        if (widget.item.id == element.plantPilotId) {
          diplayedItemWidgets.add(Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  tileColor: element.status == "connected"
                      ? Colors.blue[100]
                      : Colors.red[100],
                  leading: Icon(element.status == "connected"
                      ? Icons.check_circle
                      : Icons.close),
                  title: Text(
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                      "Nom pot : ${element.name}"),
                  subtitle: Text(
                      style: const TextStyle(
                          fontSize: 12, fontStyle: FontStyle.italic),
                      "ID: ${element.id}\nStatut: ${element.status}\nPreset : ${presets.firstWhereOrNull((item) => element.preset == item.id)?.name ?? "aucun"}\nNiveau d'eau : ${element.waterLevel}\nNiveau de batterie : ${element.batteryLevel}\nHumidité : ${element.humidity}\nID PlantPilot : ${element.plantPilotId}\nDernière action : ${element.lastWatering ?? "inconnue"}"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ItemDetailPage(item: element)))
                        .then((_) => setState(() {}));
                  })));
        }
      }
    } else if (widget.item is Pot) {
      for (final item in presets) {
        presetsEntries
            .add(DropdownMenuEntry<Preset>(value: item, label: item.name));
      }
      diplayedItemWidgets.add(const Center(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.arrow_downward),
            Text("Détails de mon pot de fleur"),
            Icon(Icons.arrow_downward)
          ])));
      diplayedItemWidgets.add(Card(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              tileColor: widget.item.status == "connected"
                  ? Colors.blue[100]
                  : Colors.red[100],
              leading: Icon(widget.item.status == "connected"
                  ? Icons.check_circle
                  : Icons.close),
              title: Text(
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                  "Nom pot : ${widget.item.name}"),
              subtitle: Text(
                  style: const TextStyle(
                      fontSize: 12, fontStyle: FontStyle.italic),
                  "ID: ${widget.item.id}\nStatut: ${widget.item.status}\nPreset : ${presets.firstWhereOrNull((element) => widget.item.preset == element.id)?.name ?? "aucun"}\nNiveau d'eau : ${widget.item.waterLevel}\nNiveau de batterie : ${widget.item.batteryLevel}\nHumidité : ${widget.item.humidity}\nID PlantPilot : ${widget.item.plantPilotId}\nDernière action : ${widget.item.lastWatering ?? "inconnue"}"))));
      diplayedItemWidgets.add(Divider(color: Colors.grey[300]));
      diplayedItemWidgets.add(Column(children: [
        const Text("Choisissez un preset à associer au pot"),
        const SizedBox(height: 5),
        DropdownMenu<Preset>(
            width: 200,
            dropdownMenuEntries: presetsEntries,
            leadingIcon: const Icon(Icons.precision_manufacturing),
            initialSelection: widget.item.preset == null
                ? null
                : presets
                .firstWhere((element) => widget.item.preset == element.id),
            onSelected: (Preset? preset) {
              setState(() {
                _selectedPreset = preset;
              });
            }),
        const SizedBox(height: 5),
        TextButton(
            style: TextButton.styleFrom(backgroundColor: Colors.blue[50]),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    _sliderQuantityValue = 50;
                    return StatefulBuilder(
                      builder: (BuildContext context,
                          void Function(void Function()) setState) {
                        return SizedBox(
                            height: 500,
                            child: Center(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      const Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.arrow_downward),
                                            Text("Détails de l'arrosage manuel"),
                                            Icon(Icons.arrow_downward)
                                          ]),
                                      const Padding(padding: EdgeInsets.all(10)),
                                      Divider(color: Colors.grey[400]),
                                      const Padding(padding: EdgeInsets.all(10)),
                                      Text(
                                          "Quantité d'eau (en ml): ${_sliderQuantityValue.round()}"),
                                      SizedBox(
                                        width: 350,
                                        child: Slider(
                                          value: _sliderQuantityValue,
                                          min: 50,
                                          max: 500,
                                          divisions: 9,
                                          label: _sliderQuantityValue
                                              .round()
                                              .toString(),
                                          onChanged: (double value) {
                                            setState(() {
                                              _sliderQuantityValue = value;
                                            });
                                          },
                                        ),
                                      ),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                            backgroundColor: Colors.blue[50]),
                                        onPressed: () async {
                                          var res = await httpRequest.request(
                                              method: "post",
                                              url:
                                              "devices/${pots.first.id.toString()}/water/${_sliderQuantityValue.toInt()}");
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                            "Envoyer l'instruction d'arrosage"),
                                      )
                                    ])));
                      },
                    );
                  });
            },
            child: const Text("Arrosage manuel"))
      ]));
    }
    return Scaffold(
        appBar: AppBar(
            title: const Text('PlantPilot'),
            centerTitle: true,
            backgroundColor: Colors.blue,
            actions:
            appTools.platform == "android" ? [] : const [BackButton()]),
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
                menuTileWidgets,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: diplayedItemWidgets),
        ),
        floatingActionButton: widget.item is Pot
            ? FloatingActionButton(
          onPressed: () async => {
            if (_selectedPreset != null)
              {
                pots[pots.indexOf(pots
                    .firstWhere((element) => widget.item == element))]
                    .preset = _selectedPreset?.id,
                await httpRequest
                    .request(
                    method: "post",
                    url:
                    "devices/${pots[pots.indexOf(pots.firstWhere((element) => widget.item == element))].id.toString()}/preset/${pots[pots.indexOf(pots.firstWhere((element) => widget.item == element))].preset.toString()}",
                    body: jsonEncode({
                      "device_id": pots[pots.indexOf(pots.firstWhere(
                              (element) => widget.item == element))]
                          .id
                          .toString(),
                      "preset_id": pots[pots.indexOf(pots.firstWhere(
                              (element) => widget.item == element))]
                          .preset
                          .toString()
                    }))
                    .then((value) => {print(value.data)})
              },
            Navigator.pop(context, true)
          },
          tooltip: 'Sauvegarder le preset associé',
          child: const Icon(Icons.save),
        )
            : null);
  }
}

class PresetsPage extends StatefulWidget {
  const PresetsPage({super.key});

  @override
  State<PresetsPage> createState() => _PresetsPageState();
}

class _PresetsPageState extends State<PresetsPage> {
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
            actions:
            appTools.platform == "android" ? [] : const [BackButton()]),
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
                if (presets.isNotEmpty)
                  for (final item in presets)
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
                                "Nom : ${item.name}"),
                            subtitle: Text(
                                style: const TextStyle(
                                    fontSize: 12, fontStyle: FontStyle.italic),
                                "Crée par : ${item.createdBy}\nCrée le : ${item.createdAt}\n"),
                            onTap: () {
                              /*Navigator.push(context,
                                MaterialPageRoute(builder: (context) => ItemDetailPage(item: item)));*/
                            }))
              ]),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CreatePreset()))
                .then((_) => setState(() {}))
          },
          tooltip: 'Créer un nouveau preset',
          child: const Icon(Icons.add),
        ));
  }
}

class CreatePreset extends StatefulWidget {
  const CreatePreset({super.key});

  @override
  State<CreatePreset> createState() => _CreatePresetState();
}

class _CreatePresetState extends State<CreatePreset> {
  String presetName = "";
  final presetNameController = TextEditingController();
  double _sliderQuantityValue = 50;
  double _sliderIntervalValue = 5;

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
            actions:
            appTools.platform == "android" ? [] : const [BackButton()]),
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
                  min: 50,
                  max: 500,
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
                  "Interval d'arrosage (en secondes): ${_sliderIntervalValue.round()}"),
              SizedBox(
                  width: 350,
                  child: Slider(
                    value: _sliderIntervalValue,
                    min: 5,
                    max: 300,
                    divisions: 59,
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
          onPressed: () async => {
            presets.add(Preset(
                id: ObjectId(),
                name: presetNameController.text,
                createdBy: account.username,
                createdAt: DateTime.now(),
                waterQuantity: _sliderQuantityValue.toInt(),
                timeInterval: _sliderIntervalValue.toInt())),
            print(presets.last.id.toString()),
            await httpRequest.request(
                method: "post", url: "preset/", body: presets.last.toJson()),
            Navigator.pop(context, true)
          },
          tooltip: 'Sauvegarder le preset',
          child: const Icon(Icons.save),
        ));
  }
}

class ForumPage extends StatelessWidget {
  const ForumPage({super.key});

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
            actions:
            appTools.platform == "android" ? [] : const [BackButton()]),
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
                          Text("Les topics"),
                          Icon(Icons.arrow_downward)
                        ])),
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
                          "Crée par : ${item.createdBy}\nCrée le : ${item.createdAt}\nDernier message par : ${item.lastMessageBy}\nDernier message le : ${DateFormat('dd-MM-yyy HH:mm:ss').format(item.lastMessageAt)}\nNombre de message(s) : ${item.messageCount}"),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MessagesPage(topic: item)));
                      })
              ]),
        ));
  }
}

class MessagesPage extends StatefulWidget {
  final Topic topic;

  const MessagesPage({super.key, required this.topic});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  @override
  Widget build(BuildContext context) {
    List<Widget> menuTile = [];
    List<Message> filteredMessages = [];
    for (final item in pageItems) {
      var key = item.keys.first;
      var icon = item.values.first["icon"];
      Widget page = item.values.first["page"] as Widget;
      menuTile.add(
        Card(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            child: ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
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
            )),
      );
    }
    for (final item in messages) {
      if (item.topicId == widget.topic.id) {
        filteredMessages.add(item);
      }
    }
    return Scaffold(
        appBar: AppBar(
            title: const Text('PlantPilot'),
            centerTitle: true,
            backgroundColor: Colors.blue,
            actions:
            appTools.platform == "android" ? [] : const [BackButton()]),
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
                          Text("Les Messages"),
                          Icon(Icons.arrow_downward)
                        ])),
                for (final item in filteredMessages)
                  ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      tileColor: Colors.grey[200],
                      leading: const Icon(Icons.message),
                      title: Text(
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          "Par : ${item.createdBy}"),
                      subtitle: Text(
                          style: const TextStyle(
                              fontSize: 12, fontStyle: FontStyle.italic),
                          item.message))
              ]),
        ));
  }
}

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

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
            actions:
            appTools.platform == "android" ? [] : const [BackButton()]),
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
