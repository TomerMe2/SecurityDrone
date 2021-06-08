import 'package:http/http.dart' as http;

class GeneralAPI {

  String _address = 'http://127.0.0.1:5002/';

  Future<String> post(String request, String body, String token) async {
    try {
      http.Response response = await http.post(Uri.parse(_address+request), body: body, headers: {
        'x-access-tokens': token
      });
      if (response.statusCode == 200) {
        return response.body;
      }
      else {
        return '';
      }
    }
    catch(e) {
      return '';
    }
  }


  Future<String> get(String request, String token) async {
    try {
      http.Response response = await http.get(Uri.parse(_address+request), headers: {
        'x-access-tokens': token
      });
      if (response.statusCode == 200) {
        return response.body;
      }
      else {
        return '';
      }
    }
    catch(e) {
      return '';
    }
  }




}