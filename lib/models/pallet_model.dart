import 'package:flutter/material.dart';
import 'package:store_management_system/services/api_services.dart';

class Pallet {
  int palletActivityId;
  int palletID;
  String palletNo;
  String lorryNo;
  String palletType;
  String destination;
  String openPalletDateTime;
  String openPalletLocation;
  String openByUserName;
  String movePalletDateTime;
  String moveByUserName;
  String assignPalletDateTime;
  String assignToUserGuid;
  String assignToUserName;
  String assignByUserName;
  String loadPalletDateTime;
  String loadByUserName;
  String status;
  String palletLocation;
  List<Item> items;
  // Attachment signature;

  Pallet({
    required this.palletActivityId,
    required this.palletID,
    required this.palletNo,
    required this.lorryNo,
    required this.palletType,
    required this.destination,
    required this.openPalletDateTime,
    required this.openByUserName,
    required this.movePalletDateTime,
    required this.moveByUserName,
    required this.openPalletLocation,
    required this.assignPalletDateTime,
    required this.assignToUserGuid,
    required this.assignToUserName,
    required this.assignByUserName,
    required this.loadPalletDateTime,
    required this.loadByUserName,
    required this.status,
    required this.palletLocation,
    required this.items,
    // required this.signature,
  });

  factory Pallet.fromMap(Map<String, dynamic> map) => Pallet(
        palletActivityId: map["palletActivityId"],
        palletID: map["palletId"],
        palletNo: map["palletNo"],
        lorryNo: map["lorryNo"],
        palletType: map["palletType"],
        destination: map["destination"],
        openPalletDateTime: map["openPalletDateTime"],
        openByUserName: map["openByUserName"],
        movePalletDateTime: map["movePalletDateTime"],
        moveByUserName: map["moveByUserName"],
        openPalletLocation: map["openPalletLocation"],
        assignPalletDateTime: map["assignPalletDateTime"],
        assignToUserGuid: map["assignToUserGuid"],
        assignToUserName: map["assignToUserName"],
        assignByUserName: map["assignToUserName"],
        loadPalletDateTime: map["loadPalletDateTime"],
        loadByUserName: map["loadByUserName"],
        status: map["status"],
        palletLocation: map["palletLocation"],
        items: (map['items'] as List).map((e) => Item.fromMap(e)).toList(),
        // signature: Attachment.fromMap(map['signature'] as Map<String, dynamic>),
      );

  factory Pallet.empty() => Pallet(
        palletActivityId: 0,
        palletID: 0,
        palletNo: "",
        lorryNo: "",
        palletType: "",
        destination: "",
        openPalletDateTime: "",
        openByUserName: "",
        movePalletDateTime: "",
        moveByUserName: "",
        openPalletLocation: "",
        assignPalletDateTime: "",
        assignToUserGuid: "",
        assignToUserName: "",
        assignByUserName: "",
        loadPalletDateTime: "",
        loadByUserName: "",
        status: "",
        palletLocation: "",
        items: List.empty(),
      );

  Map<String, dynamic> toMap() => {
        "palletActivityId": palletActivityId,
        "palletId": palletID,
        "palletNo": palletNo,
        "lorryNo": lorryNo,
        "palletType": palletType,
        "destination": destination,
        "openPalletDateTime": openPalletDateTime,
        "openByUserName": openByUserName,
        "movePalletDateTime": movePalletDateTime,
        "moveByUserName": moveByUserName,
        "openPalletLocation": openPalletLocation,
        "assignPalletDateTime": assignPalletDateTime,
        "assignToUserGuid": assignToUserGuid,
        "assignToUserName": assignToUserName,
        "assignByUserName": assignByUserName,
        "loadPalletDateTime": loadPalletDateTime,
        "loadByUserName": loadByUserName,
        "status": status,
        "palletLocation": palletLocation,
        "items": items.map((item) => item.toMap()).toList(),
        // "signature": signature.toMap(),
      };

  bool isEmpty() {
    return palletActivityId == 0 &&
        palletID == 0 &&
        palletNo == "" &&
        lorryNo == "" &&
        palletType == "" &&
        destination == "" &&
        openPalletDateTime == "" &&
        openByUserName == "" &&
        movePalletDateTime == "" &&
        moveByUserName == "" &&
        openPalletLocation == "" &&
        assignPalletDateTime == "" &&
        assignToUserGuid == "" &&
        assignByUserName == "" &&
        loadPalletDateTime == "" &&
        loadByUserName == "" &&
        status == "" &&
        palletLocation == "" &&
        items.isEmpty;
  }
}

class Item {
  int itemId;
  int customerId;
  String customerName;
  String itemCode;
  int qty;
  int palletActivityId;

  Item({
    required this.itemId,
    required this.customerId,
    required this.customerName,
    required this.itemCode,
    required this.qty,
    required this.palletActivityId,
  });

  factory Item.fromMap(Map<String, dynamic> map) => Item(
        itemId: map["itemId"],
        customerId: map["customerId"],
        customerName: map["customerName"],
        itemCode: map["itemCode"],
        qty: map["qty"],
        palletActivityId: map["palletActivityId"],
      );

  Map<String, dynamic> toMap() => {
        "itemId": itemId,
        "customerId": customerId,
        "customerName": customerName,
        "itemCode": itemCode,
        "qty": qty,
        "palletActivityId": palletActivityId,
      };
}

class Attachment {
  String attachmentUrl;
  String attachmentFullPath;
  String createdByUserName;

  Attachment({
    required this.attachmentUrl,
    required this.attachmentFullPath,
    required this.createdByUserName,
  });

  factory Attachment.fromMap(Map<String, dynamic> map) => Attachment(
        attachmentUrl: map["attachmentUrl"],
        attachmentFullPath: map["attachmentFullPath"],
        createdByUserName: map["createdByUserName"],
      );

  Map<String, dynamic> toMap() => {
        "attachmentUrl": attachmentUrl,
        "attachmentFullPath": attachmentFullPath,
        "createdByUserName": createdByUserName,
      };
}

// testing
class PalletItem {
  final String name;
  final int quantity;

  PalletItem(
    this.name,
    this.quantity,
  );
}

class PalletNotifier extends ChangeNotifier {
  Map<int, Pallet> _pallets = {};

  Map<int, Pallet> get pallets => _pallets;

  initialize() async {
    List<dynamic> res = await ApiServices.pallet.all();

    if (res.isEmpty) {
      _pallets = {};
    } else {
      _pallets = {for (var v in res) v["palletActivityId"]: Pallet.fromMap(v)};
    }

    notifyListeners();
  }

  update(int id) async {
    var res = await ApiServices.pallet.getById(id);

    if (res.containsKey("err")) {
      return;
    }

    _pallets[id] = Pallet.fromMap(res);
    notifyListeners();
  }
}
