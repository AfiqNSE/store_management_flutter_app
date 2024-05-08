import 'package:flutter/material.dart';
import 'package:store_management_system/services/api_services.dart';

class SummaryNotifier extends ChangeNotifier {
  int _pallets = 0;
  int _inBound = 0;
  int _outBound = 0;

  int get pallets => _pallets;
  int get inBound => _inBound;
  int get outBound => _outBound;

  void set(Map<dynamic, dynamic> map) {
    _pallets = map["pallets"];
    _inBound = map["inBound"];
    _outBound = map["outBound"];
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  Future<void> update() async {
    var res = await ApiServices.pallet.summary();

    if (res.containsKey("err")) {
      return;
    }

    set(res);
  }
}
