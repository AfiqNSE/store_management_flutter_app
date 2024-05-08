import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:store_management_system/services/api_services.dart';

class ApiOther {
  Future<List> zones() async {
    Response response;

    try {
      response = await get(Uri.parse("${ApiServices.base}/zones"));
    } catch (e) {
      debugPrint("[Get Zones] ${e.toString()}");
      return List.empty();
    }

    if (response.statusCode != HttpStatus.ok) {
      debugPrint(response.body);
      return List.empty();
    }

    return jsonDecode(response.body);
  }

  Future<List> customers() async {
    Response response;

    try {
      response = await get(Uri.parse("${ApiServices.base}/customers"));
    } catch (e) {
      debugPrint("[Get Customers] ${e.toString()}");
      return List.empty();
    }

    if (response.statusCode != HttpStatus.ok) {
      debugPrint(response.body);
      return List.empty();
    }

    return jsonDecode(response.body);
  }
}
