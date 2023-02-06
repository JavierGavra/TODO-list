import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/parser.dart';
import 'package:todo_list/ui/create_page/create_page.dart';
import 'package:todo_list/ui/home/tab_complete.dart';
import 'package:todo_list/ui/home/tab_my_todo.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  TabController? _tabController;
  int _tabIndex = 0;
  final List<Widget> _tab = const [Tab(text: "My Todo"), Tab(text: "Complete")];
  final List<Widget> _pages = const [TabMyTodo(), TabComplete()];

  void _findTabIndex() {
    _tabController!.addListener(() {
      setState(() {
        _tabIndex = _tabController!.index;
      });
    });
  }

  _aboutDialog() {
    Widget levelsInfo(String text, Color color) {
      return Row(
        children: [
          Container(
            height: 12,
            width: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 7),
          Text(text, style: TextStyle(color: color))
        ],
      );
    }

    showAboutDialog(
      context: context,
      applicationIcon: const FlutterLogo(),
      children: [
        levelsInfo('Important', Colors.red),
        levelsInfo('Normal', Colors.blue),
        levelsInfo('Not Too Important', Colors.greenAccent)
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _findTabIndex();
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SvgPicture.asset('assets/app_logo.svg',
                height: 34, width: 34, fit: BoxFit.cover),
            const SizedBox(width: 12),
            Text("TODO List", style: textTheme.headline1),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorWeight: 3,
          tabs: _tab,
        ),
        actions: [
          IconButton(
            onPressed: _aboutDialog,
            icon: const Icon(Icons.info),
          )
        ],
      ),
      body: TabBarView(controller: _tabController, children: _pages),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _tabIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const CreatePage())),
              icon: const Icon(Icons.add),
              label: const Text("Add Task"),
            )
          : null,
    );
  }
}
