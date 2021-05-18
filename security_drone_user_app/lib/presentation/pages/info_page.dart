import 'package:flutter/material.dart';
import 'package:security_drone_user_app/presentation/text_section.dart';

class InfoPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextSection("Project vision:", "Provide security using a drone and AI\n"
              + "More specifically, give the user enough information about an intrusion to react quickly, "
              + "and the ability to track the thief and have liable documentation of the crime.",
            height: 160.0,
          ),
          TextSection("Developer Team:", "Daniel Katz\nTomer Laor\nShahar Cohen Hadad",
            height: 90.0,
          ),
        ],
      ),
      constraints: BoxConstraints(
          maxHeight: 100.0,
          maxWidth: 100.0
      ),
    );
  }
}