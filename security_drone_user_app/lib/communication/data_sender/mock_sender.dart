import 'package:security_drone_user_app/config.dart';
import 'dart:io';

Future<bool> sendWaypoints(String toSend) async {

  if (debugTestingProd == 0) {
    print(toSend);
  }
  else if (debugTestingProd == 1) {
    // for tests
    final file = new File(testsOutputFile);
    await file.writeAsString(toSend, mode: FileMode.append);
  }

  return Future.delayed(Duration(seconds: 3), () => true);
}