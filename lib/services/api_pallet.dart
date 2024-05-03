import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:store_management_system/services/api_services.dart';

class ApiPallet {
  String path = "${ApiServices.base}/pallet";

  Future<Map> summary() async {
    Response res = await ApiServices.call(
      Method.get,
      Uri.parse("$path/all/summary"),
    );

    if (res.statusCode != HttpStatus.ok) {
      return {"err": 1};
    }

    return json.decode(res.body);
  }
}
