import 'package:flutter/material.dart';
import 'package:security_drone_user_app/presentation/pages/mission_page.dart';
import 'package:security_drone_user_app/presentation/pages/view_thief_page.dart';
import 'package:security_drone_user_app/presentation/pages/dashboard_page.dart';
import 'package:security_drone_user_app/presentation/pages/info_page.dart';
import '../../style.dart';


class CentralPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CentralPageState();
  }
}

class CentralPageState extends State<CentralPage> with SingleTickerProviderStateMixin {
  final List<Widget> _pages = [
    InfoPage(),
    DashboardPage(),
    ThiefPage(),
    MissionPage()
  ];
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new TabController(vsync: this, length: this._pages.length);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Security Drone", style: AppBarTextStyle),
        actions: [
          Image.asset('assets/images/icon.jpg')
        ],
        bottom: TabBar(
          controller: this._controller,
          tabs: <Widget>[
            Tab(
              icon: Icon(Icons.info),
            ),
            Tab(
              icon: Icon(Icons.dashboard),
            ),
            Tab(
              icon: Icon(Icons.photo_library)
            ),
            Tab(
              icon: Icon(Icons.settings),
            )
          ],
        ),
      ),
      body: TabBarView(
        controller: this._controller,
        children: this._pages,
      ),

    );
  }
}