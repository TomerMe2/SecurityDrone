import 'package:flutter/material.dart';
import 'package:security_drone_user_app/presentation/image_banner.dart';
import 'package:security_drone_user_app/presentation/pages/dashboard_page.dart';
import 'package:security_drone_user_app/presentation/pages/patrol_set_page.dart';
import 'package:security_drone_user_app/presentation/pages/view_thief_page.dart';
import 'package:security_drone_user_app/presentation/text_section.dart';
import 'style.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var routes = <String, WidgetBuilder>{
      'Patrol Page': (BuildContext context) => new PatrolSetPage(),
      'Home Page' : (BuildContext context) => new MyHomePage(title: 'Security Drone'),
      'Thief Page' : (BuildContext context) => new ViewThiefPage(),
      'Dashboard Page' : (BuildContext context) => new DashboardPage()
    };

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
      routes: routes,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          ImageBanner('assets/images/icon.jpg')
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextSection("HELLOOOOO", "hellohellohellohellohellohellohellohellohellohello")
        ],
      ),
      floatingActionButton: Column (
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: (){Navigator.of(context).pushNamed('Thief Page');},
            heroTag: 'Thief_page',
            child: Icon(Icons.arrow_right),
          ),
          FloatingActionButton(
            onPressed: (){Navigator.of(context).pushNamed('Dashboard Page');},
            heroTag: 'Dashboard_page',
          ),
          FloatingActionButton(
            onPressed: (){Navigator.of(context).pushNamed('Patrol Page');},
            heroTag: 'Patrol_page',
          )
        ],
      )

    );
  }
}
