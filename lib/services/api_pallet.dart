import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:store_management_system/services/api_services.dart';

class ApiPallet {
  String path = "${ApiServices.base}/pallet";

  Future<List> all() async {
    Response res = await ApiServices.call(Method.get, Uri.parse("$path/all"));

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

  Future<Map<String, dynamic>> getById(int id) async {
    Response res = await ApiServices.call(
      Method.get,
      Uri.parse("$path/id/$id"),
    );

    if (res.statusCode != HttpStatus.ok) {
      return {"err": 1};
    }

    return json.decode(res.body);
  }

  Future<Map<String, dynamic>> getByActivityNo(String activityNo) async {
    Response res = await ApiServices.call(
      Method.get,
      Uri.parse("$path/activityNo/$activityNo"),
    );

    if (res.statusCode != HttpStatus.ok) {
      return {"err": 1};
    }
    return json.decode(res.body);
  }

  Future<List<dynamic>> search(int page, int fetch, String value) async {
    if (value.isEmpty) {
      return List.empty();
    }

    Response res = await ApiServices.call(
        Method.get, Uri.parse("$path/search?q=$value&page=$page&fetch=$fetch"));

    if (res.statusCode != HttpStatus.ok) {
      return List.empty();
    }

    var v = jsonDecode(res.body);
    if (v != null) {
      return v;
    } else {
      return List.empty();
    }
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

  Future<bool> move(int palletActivityId) async {
    Response res = await ApiServices.call(
      Method.patch,
      Uri.parse("$path/move"),
      body: jsonEncode({"palletActivityId": palletActivityId}),
    );

    if (res.statusCode != HttpStatus.ok) {
      return false;
    }

    return true;
  }

  Future<bool> assign(
      assignToUserGuid, String lorryNo, int palletActivityId) async {
    Response res = await ApiServices.call(
      Method.patch,
      Uri.parse("$path/assign"),
      body: jsonEncode(
        {
          "assignToUserGuid": assignToUserGuid,
          "lorryNo": lorryNo,
          "palletActivityid": palletActivityId,
        },
      ),
    );

    if (res.statusCode != HttpStatus.ok) {
      return false;
    }

    return true;
  }

  Future<bool> confirm(palletActivityId) async {
    Response res = await ApiServices.call(
      Method.patch,
      Uri.parse("$path/confirm"),
      body: jsonEncode({
        'palletActivityId': palletActivityId,
      }),
    );

    if (res.statusCode != HttpStatus.ok) {
      return false;
    }

    return true;
  }

  Future<bool> load(int palletActivityId) async {
    Response res = await ApiServices.call(
      Method.patch,
      Uri.parse("$path/load"),
      body: jsonEncode({
        'palletActivityId': palletActivityId,
      }),
    );

    if (res.statusCode != HttpStatus.ok) {
      return false;
    }
    return true;
  }

  Future<bool> close(int palletActivityId) async {
    Response res = await ApiServices.call(
      Method.patch,
      Uri.parse("$path/close"),
      body: jsonEncode({
        'palletActivityId': palletActivityId,
      }),
    );
    if (res.statusCode != HttpStatus.ok) {
      return false;
    }
    return true;
  }

  Future<List> fetchAssignedJob() async {
    Response res = await ApiServices.call(
      Method.get,
      Uri.parse("$path/assigned"),
    );

    if (res.statusCode != HttpStatus.ok) {
      return List.empty();
    }

    var body = json.decode(res.body);
    if (body == null) {
      return List.empty();
    }

    return body;
  }

  Future<List> fetchConfirmedJob() async {
    Response res = await ApiServices.call(
      Method.get,
      Uri.parse("$path/confirmed"),
    );

    if (res.statusCode != HttpStatus.ok) {
      return List.empty();
    }

    var body = json.decode(res.body);
    if (body == null) {
      return List.empty();
    }

    return body;
  }

  Future<dynamic> fetchLoadingJob() async {
    Response res =
        await ApiServices.call(Method.get, Uri.parse("$path/loading"));
    if (res.statusCode != HttpStatus.ok) {
      return List.empty();
    }
    return json.decode(res.body);
  }

  Future<dynamic> fetchLoadedJob() async {
    Response res =
        await ApiServices.call(Method.get, Uri.parse("$path/loaded"));
    if (res.statusCode != HttpStatus.ok) {
      return List.empty();
    }

    var body = json.decode(res.body);
    if (body == null) {
      return List.empty();
    }

    return body;
  }

  Future<int> addItem(
    int customerId,
    String customerName,
    int qty,
    int palletActivityId,
  ) async {
    Response res = await ApiServices.call(
      Method.post,
      Uri.parse("$path/item/add"),
      body: jsonEncode({
        'customerId': customerId,
        'customerName': customerName,
        'qty': qty,
        'palletActivityId': palletActivityId,
      }),
    );

    if (res.statusCode != HttpStatus.ok) {
      return 0;
    }

    return jsonDecode(res.body);
  }

  Future<bool> updateItem(
    int customerId,
    String customerName,
    int qty,
    int palletActivityId,
    int palletActivityDetailId,
  ) async {
    Response res = await ApiServices.call(
      Method.patch,
      Uri.parse('$path/item/update/$palletActivityDetailId'),
      body: jsonEncode({
        'customerId': customerId,
        'customerName': customerName,
        'qty': qty,
        'palletActivityId': palletActivityId,
      }),
    );

    if (res.statusCode != HttpStatus.ok) {
      return false;
    }

    return true;
  }

  Future<bool> deleteItem(
    int palletActivityDetailId,
    int palletActivityId,
  ) async {
    Response res = await ApiServices.call(
      Method.delete,
      Uri.parse('$path/item/delete/$palletActivityDetailId'),
      body: jsonEncode({
        'palletActivityId': palletActivityId,
      }),
    );

    if (res.statusCode != HttpStatus.ok) {
      return false;
    }

    return true;
  }

  Future<dynamic> getSignatureImage(String signaturePath) async {
    Response res = await ApiServices.call(
      Method.get,
      Uri.parse('$path/signature/path/$signaturePath'),
    );
    if (res.statusCode != HttpStatus.ok) {
      return null;
    }
    return res.bodyBytes;
  }
}
