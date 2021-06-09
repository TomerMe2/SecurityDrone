import 'dart:convert';
import 'dart:io';
import 'package:security_drone_user_app/config.dart';
import 'package:security_drone_user_app/communication/mock_sender.dart' if (isMockingServer) 'package:security_drone_user_app/communication/general_api.dart';
import 'package:security_drone_user_app/data/models/thief_entry.dart';
import 'package:date_format/date_format.dart';

class ThiefAPI {
  GeneralAPI generalAPI = GeneralAPI();

  Future<List<ThiefEntry>> getThieves(DateTime from, DateTime until, int idxFrom, int idxUntil, String token) async {
    if (isMockingServer){
      sleep(Duration(seconds: 3));
      return ThiefEntry.dummyFetchAll();
    }
    else {
      String request = " pictures_of_thieves";
      String body = jsonDecode(
          {'date_from': formatDate(from, [dd, '_', mm, '_', yy]),
            'date_until': formatDate(until, [dd, '_', mm, '_', yy]),
            'index_from': idxFrom,
            'index_untill': idxUntil
          }.toString()
      );

      Iterable l = json.decode(await generalAPI.post(request, body, token));
      List<ThiefEntry> lst = List<ThiefEntry>.from(l.map((e) => ThiefEntry.fromJson(e)));
      return lst;
    }
  }


}