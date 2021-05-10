import 'package:flutter/material.dart';

class ImageBanner extends StatelessWidget {
  String _path;

  ImageBanner(this._path);

  @override
  Widget build(BuildContext context) {
    return  Row(
        mainAxisAlignment: MainAxisAlignment.start,
      children: [Container(
      constraints: BoxConstraints.expand(
        height: 100.0,
        width: 100.0
      ),
      decoration: BoxDecoration(
        color: Colors.grey
      ),
      child: Image.asset(
        _path,
        fit: BoxFit.contain,
      ),
    )]
    );
  }
}