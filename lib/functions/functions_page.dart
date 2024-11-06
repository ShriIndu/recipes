import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

//**************Post function***********************//
class ApiProvider with ChangeNotifier {
  String _baseUrl = "http://159.89.95.7:5001";

  String get baseUrl => _baseUrl;


  Future<Map<String, dynamic>> makeHttpRequest(String url, String requestBody,
      BuildContext context, {Map<String, String>? headers}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final authToken1 = prefs.getString('authToken56');
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}${url}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $authToken1',
        },
        body: requestBody,
      );
      print('${baseUrl}${url}');
      print(response.body);
      print(response.statusCode);
      var jsonResponse = json.decode(response.body);
      if (response.statusCode == 200) {
        var successMessage = 'Success';
        if (jsonResponse.containsKey("status") && jsonResponse["status"] == 1) {
          if (jsonResponse.containsKey("message")) {
            successMessage = jsonResponse["message"];
          };
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$successMessage'),
              duration: Duration(seconds: 5),
            ),
          );
          return jsonResponse;
        } else {
          var errorMessage = 'Unknown Error';
          if (jsonResponse.containsKey("error")) {
            errorMessage = jsonResponse["error"];
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$errorMessage'),
              duration: Duration(seconds: 5),
            ),
          );
          return jsonResponse;
        }
      } else {
        var errorMessage = 'Unknown Error';
        if (jsonResponse.containsKey("status") && jsonResponse["status"] == 0) {
          if (jsonResponse.containsKey("message")) {
            errorMessage = jsonResponse["message"];
          };
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$errorMessage'),
              duration: Duration(seconds: 5),
            ),
          );
          return jsonResponse;
        }
      }
    } catch (e) {
      print('Error: $e');
      return {};
    }
    return {};
  }
}

Map<String,Color> getCommonColors() {
  return {
    'color1': Color(0xFFECEFF1),
    'color2': Color(0xFFDFA8E4),
    'color3': Color(0xFF9C27B0),
    'color4': Color(0xFFAA00FF),
    'color5': Color(0xFF4A148C),
    'color6': Colors.black,
    'color7': Colors.white,
  };
}

Widget buildLeadingImage(String? imageUrl) {
  if (imageUrl != null && imageUrl.isNotEmpty) {
    return SizedBox(
      width: 50,
      height: 50,
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
      ),
    );
  } else {
    return SizedBox(
      width: 50,
      height: 50,
      child: Image.asset(
        'assets/recipes.png',
        fit: BoxFit.cover,
      ),
    );
  }
}

//*******************************Delete function*********************//
final ApiProvider apiProvider = ApiProvider();
Future<void> performCartOperation(BuildContext context,String endpoint, dynamic body) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final authToken1 = prefs.getString('authToken56');

  final response = await http.delete(
    Uri.parse('${apiProvider.baseUrl}/csapi/$endpoint'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $authToken1',
    },
    body: jsonEncode(body),
  );

  if (authToken1 != null && response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    if (jsonData.containsKey('data')) {
    final success = jsonData['data']['success'];
    final message = jsonData['message'];
    if (success != null && message != null) {
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: Duration(seconds: 10),
        ),
      );
    } else {
      print('Failed operation: $message');
    }
    } else {
      print('Missing success or message in response data');
    }
    } else {
      print('No data field found in response');
    }
  } else {
    print('Failed operation');
  }
}

//******************Get function************************************//
Future<Map<String, dynamic>> fetchData(String endpoints) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final authToken = prefs.getString('authToken56');

  if (authToken != null) {
    print("Authorization: $authToken");
    final Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $authToken',
    };

    final response = await http.get(Uri.parse('${apiProvider.baseUrl}/csapi/$endpoints'), headers: headers);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(' ${response.reasonPhrase}');
    }
  } else {
    throw Exception('Auth token not found');
  }
}

//***************************put function***************************//
Future<void> putApi(String endpoints, Map<String, dynamic> payload) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final authToken = prefs.getString('authToken56');

  String jsonPayload = jsonEncode(payload);

  var response = await http.put(
    Uri.parse('${apiProvider.baseUrl}/csapi/$endpoints'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $authToken',
    },
    body: jsonPayload,
  );

  if (authToken != null && response.statusCode == 200) {
    print('Request successful');
  } else {
    print('Failed request. Status code: ${response.statusCode}');
  }
}

/********************************home page recipes*************************/
Future<List<Homedisplayrecipes>> homeDisplayRecipes<Homedisplayrecipes>(
    String endpoint,
    Homedisplayrecipes Function(Map<String, dynamic>) fromJson,
    {int page = 1}
    ) async {
  try {
    final data = await fetchData('$endpoint?page=$page');
    final itemsData = data['data']['data'];
    List<Homedisplayrecipes> tempList = [];
    for (var itemData in itemsData) {
      Homedisplayrecipes item = fromJson(itemData);
      tempList.add(item);
    }
    return tempList;
  } catch (e) {
    throw Exception('Failed to load recipes: $e');
  }
}
