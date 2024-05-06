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

  Future<int> open(
    String palletNo,
    String palletLocation,
    String palletType,
    String destination,
  ) async {
    Response res = await ApiServices.call(
      Method.post,
      Uri.parse("$path/open"),
      body: jsonEncode({
        "palletNo": palletNo,
        "openPalletLocation": palletLocation,
        "palletType": palletType,
        "destination": destination,
      }),
    );

    if (res.statusCode != HttpStatus.created) {
      Map data = json.decode(res.body);
      if (data["code"] == "pallet.full") return 1;
      return 2;
    }

    return 0;
  }
}
