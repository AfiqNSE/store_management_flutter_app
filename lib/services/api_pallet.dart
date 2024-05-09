import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:store_management_system/models/pallet_model.dart';
import 'package:store_management_system/services/api_services.dart';

class ApiPallet {
  String path = "${ApiServices.base}/pallet";

  Future<dynamic> all() async {
    Response res = await ApiServices.call(
      Method.get,
      Uri.parse("$path/all"),
    );

    if (res.statusCode != HttpStatus.ok) {
      return List.empty();
    }

    return json.decode(res.body);
  }

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

  Future<Map<String, dynamic>> getByNo(String no) async {
    Response res = await ApiServices.call(Method.get, Uri.parse("$path/$no"));

    if (res.statusCode != HttpStatus.ok) {
      return {"err": 1};
    }

    return json.decode(res.body);
  }

  Future<int> movePallet(int palletActivityId) async {
    Response res = await ApiServices.call(
      Method.post,
      Uri.parse("$path/move"),
      body: jsonEncode({"palletActivityId": palletActivityId}),
    );

    if (res.statusCode != HttpStatus.created) {
      return 1;
    }
    return 0;
  }

  Future<dynamic> assignJob() async {
    Response res =
        await ApiServices.call(Method.get, Uri.parse("$path/assigned"));

    if (res.statusCode != HttpStatus.ok) {
      return List.empty();
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
