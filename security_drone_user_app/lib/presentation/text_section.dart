import 'package:flutter/material.dart';
import 'package:security_drone_user_app/style.dart';

class TextSection extends StatelessWidget {
  final String _title;
  final String _body;
  static const double _PADDING = 10.0;
  final double height;
  final double bodyHeight;

  TextSection(this._title, this._body,{this.height = 100.0, this.bodyHeight = 100});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(_PADDING, 20.0, _PADDING, 4.0),
          child: Text(_title, style: TitleTextStyle),
          constraints: BoxConstraints(
            maxHeight: this.height,
          ),
        ),
        Divider(
          height: 5.0, thickness: 5.0, indent: 10.0, endIndent: 10, color: Colors.black38,
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(_PADDING, _PADDING, _PADDING, _PADDING),
          child: Text(_body, style: Body1TextStyle),
          constraints: BoxConstraints(
            maxHeight: this.bodyHeight,
          ),
        ),

        ],
    );
  }
}