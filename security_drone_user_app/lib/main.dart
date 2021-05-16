import 'package:flutter/material.dart';
import 'package:security_drone_user_app/presentation/image_banner.dart';
import 'package:security_drone_user_app/presentation/pages/dashboard_page.dart';
import 'package:security_drone_user_app/presentation/pages/patrol_set_page.dart';
import 'package:security_drone_user_app/presentation/pages/view_thief_page.dart';
import 'style.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          textTheme: TextTheme(headline6: AppBarTextStyle)
        ),
        textTheme: TextTheme(
          headline6: TitleTextStyle,
          bodyText2: Body1TextStyle
        ),
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Security Drone'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  Map<String, Widget> routes = <String, Widget>{
    'Patrol Page': PatrolSetPage(),
    'Thief Page' : ViewThiefPage(),
    'Dashboard Page' : DashboardPage()
  };


  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new TabController(vsync: this, length: routes.length);
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
        title: Text(widget.title),
        actions: [
          ImageBanner('assets/images/icon.jpg')
        ],
        bottom: TabBar(
          controller: _controller,
          tabs: <Widget>[
            Tab(
              text: 'Dashboard\npage',
            ),
            Tab(
              text: 'thief\npage',
            ),
            Tab(
              text: 'Patrol\npage',
            )
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
          children: [
            routes['Dashboard Page'],
            routes['Thief Page'],
            routes['Patrol Page']
          ],
      ),

    );
  }
}
