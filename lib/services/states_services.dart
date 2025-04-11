// lib/services/states_services.dart

import 'dart:convert';
import 'package:covid19_trackerapp/Model/world_states.dart';
import 'package:covid19_trackerapp/services/utilities/App_url.dart';
import 'package:http/http.dart' as http;

class StateServices {
  Future<WorldStates> fetchWorldStatesRecords() async {
    final response = await http.get(Uri.parse(AppUrl.worldStatesApi));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return WorldStates.fromJson(data);
    } else {
      throw Exception('Error fetching data');
    }
  }
}
