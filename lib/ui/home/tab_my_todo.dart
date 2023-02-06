import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/common/color_app.dart';
import 'package:todo_list/model/task_model.dart';
import 'package:todo_list/service/database_helper.dart';
import 'package:todo_list/ui/edit_page/edit_page.dart';
import 'package:todo_list/ui/widget/snackbar.dart';

class TabMyTodo extends StatefulWidget {
  const TabMyTodo({super.key});

  @override
  State<TabMyTodo> createState() => _TabMyTodoState();
}

class _TabMyTodoState extends State<TabMyTodo> {
  List<bool> _isComplete = [];
  List<TaskModel> _taskList = [];
  bool _isLoding = true;

  void _bacaDatabase() async {
    _taskList = await DatabaseHelper.instance.readAll(tableTask);
    _isComplete = List.filled(_taskList.length, false, growable: true);
    setState(() {
      _isLoding = false;
    });
  }

  void _completeTask(int index) async {
    await DatabaseHelper.instance.create(tableTaskComplete, _taskList[index]);
    await DatabaseHelper.instance.delete(tableTask, _taskList[index].id);
    setState(() {
      _taskList.removeAt(index);
      _isComplete.removeAt(index);
    });
    await AudioPlayer().play(AssetSource('task_done.wav'));
    showSnackBar(
      context,
      content: Row(
        children: const [
          Icon(Icons.thumb_up, color: Colors.white, size: 18),
          SizedBox(width: 15),
          Text("Task Complete ;)"),
        ],
      ),
    );
  }

  showDeleteDialog(BuildContext context, int index) {
    AlertDialog alert = AlertDialog(
      content: const Text("Are you sure, want to delete this task?"),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: const Text("Delete", style: TextStyle(color: Colors.red)),
          onPressed: () async {
            await DatabaseHelper.instance
                .delete(tableTask, _taskList[index].id);
            setState(() {
              _taskList.removeAt(index);
              _isComplete.removeAt(index);
            });
            Navigator.of(context).pop();
            showSnackBar(
              context,
              content: Row(
                children: const [
                  Icon(Icons.check, color: Colors.white, size: 18),
                  SizedBox(width: 15),
                  Text("Task has been deleted"),
                ],
              ),
            );
          },
        ),
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bacaDatabase();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: _isLoding
          ? const Center(child: CircularProgressIndicator())
          : _taskList.isEmpty
              ? const Center(child: Text("You don't have any task"))
              : ListView.separated(
                  itemCount: _taskList.length,
                  padding: const EdgeInsets.only(
                      top: 5, bottom: 75, left: 5, right: 5),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 5),
                  itemBuilder: (context, index) {
                    return Container(
                      height: 80,
                      padding: const EdgeInsets.only(left: 15),
                      decoration: BoxDecoration(
                        color: ColorApp.secondary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 12,
                            width: 12,
                            decoration: BoxDecoration(
                              color: ColorApp.taskLevelColor(
                                  _taskList[index].level),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Checkbox(
                            value: _isComplete[index],
                            onChanged: (value) async {
                              setState(() {
                                _isComplete[index] = value!;
                              });
                              _completeTask(index);
                            },
                            checkColor: ColorApp.secondary,
                            fillColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) => ColorApp.accent1,
                            ),
                          ),
                          const SizedBox(width: 2),
                          SizedBox(
                            width: 250,
                            child: Text(
                              _taskList[index].title,
                              style: textTheme.headline4,
                            ),
                          ),
                          const Spacer(),
                          PopupMenuButton<String>(
                            tooltip: "More Option",
                            offset: const Offset(-36, 0),
                            color: ColorApp.accent1,
                            itemBuilder: (context) => [
                              _popupMenuItem('edit', "Edit", Icons.edit),
                              _popupMenuItem('delete', "Delete", Icons.delete)
                            ],
                            onSelected: (value) {
                              switch (value) {
                                case 'edit':
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => EditPage(
                                              id: _taskList[index].id!)));
                                  break;
                                case 'delete':
                                  showDeleteDialog(context, index);
                                  break;
                                default:
                                  print("nothing happen");
                              }
                            },
                          )
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  PopupMenuEntry<String> _popupMenuItem(var value, String text, IconData icon) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: ColorApp.secondary),
          const SizedBox(width: 7),
          Text(text, style: const TextStyle(color: ColorApp.secondary))
        ],
      ),
    );
  }
}
