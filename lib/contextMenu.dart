library tasker.contextMenu;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'global.dart';

//context menu for a task to delete or edit
void showContextMenu(BuildContext context, Task task, Bord bord) async {
  final result = await showMenu(
    context: context,
    position: RelativeRect.fromLTRB(100, 100, 100, 100),
    items: [
      PopupMenuItem(
        child: const Text('Delete'),
        value: 1,
      ),
      PopupMenuItem(
        child: const Text('Edit'),
        value: 2,
      ),
    ],
    elevation: 8.0,
  );
  if (result == 1) {
    print('delete');
    //open popup to verify deletion
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Delete this task?'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            //delete task
            onPressed: () {
              bord.tasks.remove(task);
              storage.writeBorden();
              // return to task page
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  } else if (result == 2) {
    print('edit');
    //open popup to edit task
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Edit task'),
        content: TextField(
          controller: TextEditingController(text: task.taskNaam),
          onChanged: (value) {
            task.taskNaam = value;
          },
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            //save changes
            onPressed: () {
              // return to task page
              Navigator.pop(context);
              storage.writeBorden();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

void showContextMenuBord(BuildContext context, Bord bord) async {
  final result = await showMenu(
    context: context,
    position: RelativeRect.fromLTRB(100, 100, 100, 100),
    items: [
      PopupMenuItem(
        child: const Text('Delete'),
        value: 1,
      ),
      PopupMenuItem(
        child: const Text('Edit'),
        value: 2,
      ),
    ],
    elevation: 8.0,
  );
  if (result == 1) {
    print('delete');
    //open popup to verify deletion
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Delete this bord?'),
        content: const Text('Are you sure you want to delete this bord?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            //delete bord
            onPressed: () {
              List<Bord> temp = [];
              for (Bord b in bordNamen) {
                if (b.bordNaam != bord.bordNaam) {
                  temp.add(b);
                }
              }
              bordNamen = temp;
              storage.writeBorden();
              // return to task page
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  } else if (result == 2) {
    print('edit');
    //open popup to edit bord
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Edit bord'),
        content: TextField(
          controller: TextEditingController(text: bord.bordNaam),
          onChanged: (value) {
            bord.bordNaam = value;
          },
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              storage.writeBorden();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
