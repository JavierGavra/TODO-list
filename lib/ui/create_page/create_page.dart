import 'package:flutter/material.dart';
import 'package:todo_list/common/color_app.dart';
import 'package:todo_list/model/task_model.dart';
import 'package:todo_list/service/database_helper.dart';
import 'package:todo_list/ui/home/home.dart';
import 'package:todo_list/ui/widget/snackbar.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  String? _levelValue;
  final List<DropdownMenuItem<String>> _levelItems = const [
    DropdownMenuItem<String>(
      value: 'important',
      child: Text("Important", style: TextStyle(color: Colors.red)),
    ),
    DropdownMenuItem<String>(
      value: 'normal',
      child: Text("Normal", style: TextStyle(color: Colors.blue)),
    ),
    DropdownMenuItem<String>(
      value: 'not too important',
      child: Text("Not too Important",
          style: TextStyle(color: Colors.greenAccent)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Task")),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              _label('Title'),
              const SizedBox(height: 5),
              TextFormField(
                controller: _titleController,
                style: TextStyle(
                  fontSize: 14,
                  color: ColorApp.secondary.withOpacity(0.9),
                ),
                decoration: InputDecoration(
                  hintText: "Title of Task",
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: ColorApp.secondary.withOpacity(0.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Level
              _label('Level :'),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: ColorApp.secondary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButtonFormField(
                    value: _levelValue,
                    items: _levelItems,
                    isExpanded: true,
                    borderRadius: BorderRadius.circular(10),
                    dropdownColor: ColorApp.secondary,
                    hint: Text(
                      "Level of Task",
                      style: TextStyle(
                        fontSize: 14,
                        color: ColorApp.accent1.withOpacity(0.5),
                      ),
                    ),
                    onChanged: (value) => setState(() {
                      _levelValue = value;
                    }),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select some level';
                      }
                      return null;
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              TaskModel task =
                  TaskModel(title: _titleController.text, level: _levelValue!);
              await DatabaseHelper.instance.create(tableTask, task);
              showSnackBar(
                context,
                content: Row(
                  children: const [
                    Icon(Icons.check, color: Colors.white, size: 18),
                    SizedBox(width: 15),
                    Text("Task has been added"),
                  ],
                ),
                color: Color(0xff0DA837),
              );
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const HomePage()),
                  (route) => false);
            } else {
              showSnackBar(
                context,
                content: Row(
                  children: const [
                    Icon(Icons.error, color: Colors.white, size: 18),
                    SizedBox(width: 15),
                    Text("Something wrong!"),
                  ],
                ),
                color: Colors.red,
                duration: const Duration(seconds: 1),
              );
            }
          },
          child: const Text("Confirm Task!"),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        color: ColorApp.secondary,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
