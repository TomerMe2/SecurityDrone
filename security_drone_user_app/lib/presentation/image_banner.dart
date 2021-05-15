import 'package:flutter/material.dart';

class ImageBanner extends StatelessWidget {
  final String _path;
  final double height;
  final double width;
  ImageBanner(this._path, {this.width = 100.0, this.height=100.0});

  @override
  Widget build(BuildContext context) {
    return  Row(
        mainAxisAlignment: MainAxisAlignment.start,
      children: [Container(
      constraints: BoxConstraints.expand(
        height: this.height,
        width: this.width
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