import 'package:flutter/material.dart';
import 'package:todo_list/common/app_theme.dart';
import 'package:todo_list/ui/home/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO List',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: AppTheme.getTheme(context),
      home: const HomePage(),
    );
  }
}
