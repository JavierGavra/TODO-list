import 'package:flutter/material.dart';
import 'package:todo_list/common/color_app.dart';
import 'package:todo_list/model/task_model.dart';
import 'package:todo_list/service/database_helper.dart';
import 'package:todo_list/ui/widget/snackbar.dart';

class TabComplete extends StatefulWidget {
  const TabComplete({super.key});

  @override
  State<TabComplete> createState() => TabCompleteState();
}

class TabCompleteState extends State<TabComplete> {
  List<TaskModel> _taskList = [];
  bool _isLoding = true;

  void _bacaDatabase() async {
    _taskList = await DatabaseHelper.instance.readAll(tableTaskComplete);
    setState(() {
      _isLoding = false;
    });
  }

  void _deleteAllTask() async {
    for (int i = 0; i < _taskList.length; i++) {
      await DatabaseHelper.instance.delete(tableTaskComplete, _taskList[i].id);
    }
    setState(() => _taskList.removeRange(0, _taskList.length));
  }

  _showClearAllDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: const Text("Are you sure, want to delete all?"),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: const Text("Delete", style: TextStyle(color: Colors.red)),
          onPressed: () {
            _deleteAllTask();
            Navigator.of(context).pop();
            showSnackBar(
              context,
              content: Row(
                children: const [
                  Icon(Icons.check, color: Colors.white, size: 18),
                  SizedBox(width: 15),
                  Text("All Task has been deleted"),
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

  _showDeleteByIdDialog(BuildContext context, int index) {
    AlertDialog alert = AlertDialog(
      content: const Text("Are you sure, want to delete this complete task?"),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: const Text("Delete", style: TextStyle(color: Colors.red)),
          onPressed: () async {
            await DatabaseHelper.instance
                .delete(tableTaskComplete, _taskList[index].id);
            setState(() {
              _taskList.removeAt(index);
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
              ? const Center(child: Text("No tasks have been completed yet"))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 7),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: _clearAllButton(),
                      ),
                      const SizedBox(height: 10),
                      ListView.separated(
                        itemCount: _taskList.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 6),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 5),
                        itemBuilder: (context, index) {
                          return Container(
                            height: 80,
                            padding: const EdgeInsets.only(left: 12, right: 4),
                            decoration: BoxDecoration(
                              color: ColorApp.secondary,
                              borderRadius: BorderRadius.circular(38),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.verified,
                                    color: ColorApp.taskLevelColor(
                                        _taskList[index].level)),
                                const SizedBox(width: 15),
                                SizedBox(
                                  width: 250,
                                  child: Text(
                                    _taskList[index].title,
                                    style: textTheme.headline4,
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                    onPressed: () =>
                                        _showDeleteByIdDialog(context, index),
                                    icon: const Icon(Icons.cancel))
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _clearAllButton() {
    return InkWell(
      borderRadius: BorderRadius.circular(38),
      onTap: () => _showClearAllDialog(context),
      child: Ink(
        height: 40,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(38),
        ),
        child: const Center(
          child: Text(
            "Clear All",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
