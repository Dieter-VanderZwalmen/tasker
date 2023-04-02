import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'global.dart' as global;
import 'contextMenu.dart' as contextmenu;
import 'global.dart';
import 'package:just_audio/just_audio.dart';

//global variable
void main() {
  runApp(MyApp(storage: global.Storage()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required global.Storage storage});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasker',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      //home: const MyHomePage(title: 'Wannabe kanbanbord Home Page'),

      //home is root van de applicatie, ik weet niet hoe ik  nog routes maak
      home: const MyHomePage(title: 'Tasker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    print('set state opgeroepen voor Homepage');

    // Or call your function here
  }

  //state gaat nodig zijn wanneer je borden toevoegd aan het hoofdscherm
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        leading: GestureDetector(
          onTap: () async {
            HapticFeedback.vibrate();
            final player = AudioPlayer();
            final music = await player.setUrl(
                "https://www.myinstants.com/media/sounds/jebaitedsoundboard.mp3");
            player.play();
            //warning you got jebaited
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Warning"),
                    content: const Text("You got jebaited"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Ok"),
                      ),
                    ],
                  );
                });
          },
          child: const Icon(Icons.whatshot_sharp),
        ),
      ),
      //body is de body van de pagina
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              flex: 7,
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (var item in global.getBordNamen())
                    Center(
                      child: GestureDetector(
                        onLongPress: (() {
                          //call context menu
                          contextmenu.showContextMenuBord(context, Bord(item));
                          setState(() {});
                        }),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Board(bordNaam: item)),
                          ).then((_) {
                            setState(() {
                              print('set state opgeroepen in de myHomePage');
                            });
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                height: 100,
                                //task title with image
                                color: Colors.grey[300],
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: FloatingActionButton(
                  onPressed: () {
                    HapticFeedback.vibrate();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddBordForm()),
                    ).then((_) {
                      setState(() {
                        print('set state opgeroepen in de myHomePage');
                      });
                    });
                  },
                  child: const Icon(Icons.add),
                  backgroundColor: Color.fromARGB(255, 237, 120, 2),
                  heroTag: null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddBordForm extends StatelessWidget {
  const AddBordForm({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    return DefaultTabController(
      //a form that gets a name
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add a new bord'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'What do you want to call this bord?',
                  labelText: 'Name *',
                ),
              ),
              const SizedBox(height: 24),
              FloatingActionButton(
                onPressed: () {
                  //haptic feedback on press
                  HapticFeedback.vibrate();
                  // if name is empty show error popup
                  if (nameController.text.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: const Text('Please enter a name'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Close'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                    return;
                  }
                  global.addBord(nameController.text);

                  // Navigate to the second screen when tapped.
                  Navigator.pop(
                    context,
                  );
                },
                child: const Icon(Icons.check),
                backgroundColor: Color.fromARGB(255, 29, 193, 29),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddTaskForm extends StatelessWidget {
  const AddTaskForm({super.key, required this.bordNaam});

  final String bordNaam;

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController imageController = TextEditingController();
    return DefaultTabController(
      //a form that gets a name
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add a new task'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'What do you want to call this task?',
                  labelText: 'Name *',
                ),
              ),
              TextFormField(
                controller: imageController,
                decoration: const InputDecoration(
                  hintText: 'Give the link of the image you want.',
                  labelText: 'Image URL',
                ),
              ),
              const SizedBox(height: 24),
              FloatingActionButton(
                onPressed: () {
                  //haptic feedback on press
                  HapticFeedback.vibrate();
                  //check if task is not empty else show error popup
                  if (nameController.text != '') {
                    if (imageController.text != '') {
                      getBord(bordNaam).addTaskWithImageUrl(
                          nameController.text, imageController.text);
                    } else {
                      global.addTaskToBord(nameController.text, bordNaam);
                    }
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Error"),
                          content: const Text("Task name can't be empty"),
                          actions: <Widget>[
                            TextButton(
                              child: const Text("Close"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }

                  // Navigate to the second screen when tapped.
                  Navigator.pop(
                    context,
                  );
                },
                child: const Icon(Icons.check),
                backgroundColor: Color.fromARGB(255, 29, 193, 29),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Board extends StatefulWidget {
  final String bordNaam;

  const Board({Key? key, required this.bordNaam}) : super(key: key);

  @override
  _BoardState createState() => _BoardState();
}

// kanbanbord pagina
class _BoardState extends State<Board> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("bordnaam is: ${widget.bordNaam}"),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.cancel_outlined),
              ),
              Tab(
                //incon that indicates loading
                icon: Icon(Icons.hourglass_empty_outlined),
              ),
              Tab(
                icon: Icon(Icons.check_circle_outline),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            //tab 1 Todo tasks
            Center(
              child: Column(
                children: [
                  Expanded(
                    flex: 7,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        for (var item in global
                            .getBord(widget.bordNaam)
                            .getTasksWithState(0))
                          Center(
                            child: GestureDetector(
                              //single tap to change state
                              onTap: () {
                                print(item.taskNaam + ' is pressed');
                                //popup message to confirm change
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: const Text('Set this task to busy?'),
                                    content: const Text(
                                        'Are you ready to start this task? This will set the task to busy.'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () => Navigator.pop(
                                          context,
                                        ),
                                        child: const Text('No'),
                                      ),
                                      TextButton(
                                        //change state of task to busy
                                        onPressed: () {
                                          item.changeStateBusy();
                                          //refresh page
                                          Navigator.pop(context);
                                          //refresh page
                                          setState(() {});
                                        },
                                        child: const Text('Yes'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              //On long press open the context menu
                              onLongPress: () {
                                contextmenu.showContextMenu(context, item,
                                    global.getBord(widget.bordNaam));
                                //refresh page
                                setState(() {});
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      //task title with image
                                      color: Colors.grey[300],
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            //if imageUrl is empty, show a placeholder
                                            child: item.imageUrl == ''
                                                ? Image.network(
                                                    'https://i.insider.com/602ee9ced3ad27001837f2ac?width=1000&format=jpeg&auto=webp')
                                                : Image.network(item.imageUrl),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              item.taskNaam,
                                              style:
                                                  const TextStyle(fontSize: 20),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: FloatingActionButton(
                        //on press do nothing
                        onPressed: () {
                          HapticFeedback.vibrate();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AddTaskForm(bordNaam: widget.bordNaam)),
                          ).then((_) {
                            setState(() {});
                          });
                        },
                        child: const Icon(Icons.add),
                        backgroundColor: Color.fromARGB(255, 237, 164, 164),
                        heroTag: null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //tab 2 in progress tasks
            Center(
              child: Column(
                children: [
                  Expanded(
                    flex: 7,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        for (var item in global
                            .getBord(widget.bordNaam)
                            .getTasksWithState(1))
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                print(item.taskNaam + ' is pressed');
                                //popup message to confirm change
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: const Text('Set this task to done?'),
                                    content: const Text(
                                        'Are you ready to finish this task? This will set the task to done.'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'No'),
                                        child: const Text('No'),
                                      ),
                                      TextButton(
                                        //change state of task to busy
                                        onPressed: () {
                                          item.changeStateDone();
                                          Navigator.pop(context, 'Yes');
                                          //refresh page
                                          setState(() {});
                                        },
                                        child: const Text('Yes'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              //On long press open the context menu
                              onLongPress: () {
                                contextmenu.showContextMenu(context, item,
                                    global.getBord(widget.bordNaam));
                                //refresh page
                                setState(() {});
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      //task title with image
                                      color: Colors.grey[300],
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            //if imageUrl is empty, show a placeholder
                                            child: item.imageUrl == ''
                                                ? Image.network(
                                                    'https://i.insider.com/602ee9ced3ad27001837f2ac?width=1000&format=jpeg&auto=webp')
                                                : Image.network(item.imageUrl),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              item.taskNaam,
                                              style:
                                                  const TextStyle(fontSize: 20),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //tab 3 done tasks
            Center(
              child: Column(
                children: [
                  Expanded(
                    flex: 7,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        for (var item in global
                            .getBord(widget.bordNaam)
                            .getTasksWithState(2))
                          Center(
                            child: GestureDetector(
                              onTap: null,
                              onLongPress: (() {
                                //call context menu
                                contextmenu.showContextMenu(context, item,
                                    global.getBord(widget.bordNaam));
                                setState(() {});
                              }),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      //task title with image
                                      color: Colors.grey[300],
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            //if imageUrl is empty, show a placeholder
                                            child: item.imageUrl == ''
                                                ? Image.network(
                                                    'https://i.insider.com/602ee9ced3ad27001837f2ac?width=1000&format=jpeg&auto=webp')
                                                : Image.network(item.imageUrl),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              item.taskNaam,
                                              style:
                                                  const TextStyle(fontSize: 20),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
