import 'package:flutter/material.dart';
import 'package:security_drone_user_app/presentation/text_section.dart';

class InfoPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return InfoPageState();
  }
}

class InfoPageState extends State<InfoPage>{
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextSection("Project vision:", "Provide security using a drone and AI.\n"
              + "Provide more time for our user to react to intrusions.\n"
              + "More specifically, give the user enough information about an intrusion to react quickly,\n"
              + "and the ability to track the thief and have liable documentation of the crime.",
            height: 150.0,
          ),
          TextSection("Developer Team:", "Daniel Katz\nTomer Laor\nShahar Cohen Hadad"),
        ],
      ),
      constraints: BoxConstraints(
        maxHeight: 100.0,
        maxWidth: 100.0
      ),
    );
  }

}