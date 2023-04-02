library tasker.global;

import 'dart:io';
import 'package:path_provider/path_provider.dart';

final Storage storage = Storage();

List<Bord> bordNamen = <Bord>[];

//function that adds bord to bordNamen
void addBord(String bordnaam) {
  storage.writeBorden();

  Bord bord = Bord(bordnaam);
  if (!bordNamen.contains(bord)) {
    bordNamen.add(bord);
  }
}

//addTaskToBord
void addTaskToBord(String taskNaam, String bordNaam, [int state = 0]) {
  Bord bord = bordNamen.firstWhere((bord) => bord.bordNaam == bordNaam);
  bord.addTask(taskNaam, state);
  storage.writeBorden();
}

//function that removes bord from bordNamen
bool removeBord(String bordNaam) {
  return bordNamen.remove(Bord(bordNaam));
}

//function that returns bordNamen
List<String> getBordNamen() {
  storage._localFile;
  storage._localPath;
  Future<List<Bord>> bordnamen = storage.readBoardsFromFile();

  List<String> bordNamenString = <String>[];

  bordnamen.then((list) {
    // Add the elements to the appropriate lists
    list.forEach((element) {
      if (!bordNamen.contains(element)) {
        bordNamen.add(element);
      }
    });
  });

  for (Bord bord in bordNamen) {
    if (!bordNamenString.contains(bord.bordNaam)) {
      bordNamenString.add(bord.bordNaam);
    }
  }

  return bordNamenString;
}

//get bord
Bord getBord(String bordNaam) {
  for (Bord bord in bordNamen) {
    if (bord.bordNaam == bordNaam) {
      return bord;
    }
  }
  return Bord("error");
}

//class Bord that has a list of tasks
class Bord {
  List<Task> tasks = [];
  String bordNaam;

// constructor for bord, needs bordNaam
  Bord(this.bordNaam);

  //function that adds task to bord
  void addTask(String task, [int state = 0, String imageUrl = ""]) {
    tasks.add(Task(task, state, imageUrl));
  }

  //add board with imageUrl
  void addTaskWithImageUrl(String task, String imageUrl, [int state = 0]) {
    tasks.add(Task.withImageUrl(task, imageUrl, state));
  }

  //function that removes task from bord
  void removeTask(Task task) {
    tasks.remove(task);
  }

  //function that returns tasks
  List<Task> getTasks() {
    return tasks;
  }

  List<Task> getTasksWithState(int state) {
    List<Task> tasksWithState = <Task>[];
    for (Task task in tasks) {
      if (task.state == state) {
        tasksWithState.add(task);
      }
    }
    return tasksWithState;
  }
}

class Task {
  String taskNaam;
  int state;
  String imageUrl;

  //constructor met default waarde state = 0 (busy)
  Task(this.taskNaam, [this.state = 0, this.imageUrl = ""]);

  //constructor met imageUrl
  Task.withImageUrl(this.taskNaam, this.imageUrl, [this.state = 0]);

  //function that changes state to 1
  void changeStateBusy() {
    state = 1;
  }

  //function that changes state to 2 (complete)
  void changeStateDone() {
    state = 2;
  }

  //function changes taskNaam
  void changeTaskNaam(String taskNaam) {
    this.taskNaam = taskNaam;
  }

  //function to set image url
  void setImageUrl(String url) {
    this.imageUrl = url;
  }
}

//wegschrijven naar een file

//get path
class Storage {
  Future<String> get _localPath async {
    //print("_getLocalPath()");
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

//get file
  Future<File> get _localFile async {
    //print("_getLocalFile()");
    final path = await _localPath;
    if (!File('$path/borden.txt').existsSync()) {
      File('$path/borden.txt').createSync();
    }
    return File('$path/borden.txt');
  }

//write to file
  void writeBorden() async {
    final file = await _localFile;
    StringBuffer buffer = StringBuffer();

    for(Bord bord in bordNamen){
      buffer.writeln("Boardname:::${bord.bordNaam}");
      for(Task task in bord.getTasks()){
        buffer.writeln('task: ${task.state},,, ${task.taskNaam},,, ${task.imageUrl}');
      }
    }

    // Write the file
    await file.writeAsString(buffer.toString());
  }

//read from file
  Future<List<Bord>> readBoardsFromFile() async {
    final file = await _localFile;

    String data = await file.readAsString();

    List<String> lines = data.split('\n');
    List<Bord> boards = [];
    Bord? currentBoard;

    for (int i = 0; i < lines.length; i++) {
      String line = lines[i];
      if (line.isNotEmpty) {
        if (line.startsWith('Boardname:::')) {
          // This is a board name
          currentBoard = Bord(line.split(":::")[1]);
          boards.add(currentBoard);
        } else if (line.startsWith('task:')) {
          if (currentBoard != null) {
            List<String> parts = line.split(",,,");
            int state = int.parse(parts[0].substring(6).trim());
            String taskName = parts[1].trim();
            String imageUrl = parts[2].trim();
            currentBoard.addTask(taskName, state, imageUrl);
          }
        }
      }
    }
    return boards;
  }
}
