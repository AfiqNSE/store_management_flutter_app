import 'package:flutter/material.dart';
import 'package:store_management_system/services/api_services.dart';

class Pallet {
  int palletActivityId;
  int palletID;
  String palletNo;
  String lorryNo;
  String palletType;
  String destination;
  String? openPalletDateTime;
  String openPalletLocation;
  String? openByUserName;
  String? movePalletDateTime;
  String? moveByUserName;
  String? assignPalletDateTime;
  String assignToUserGuid;
  String assignToUserName;
  String? assignByUserName;
  String? loadPalletDateTime;
  String? loadByUserName;
  String status;
  String palletLocation;
  List<PalletActivityDetail> items;
  Attachment signature;

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
    required this.signature,
  });

  factory Pallet.fromMap(Map<String, dynamic> map) => Pallet(
        palletActivityId: map["palletActivityId"],
        palletID: map["palletId"],
        palletNo: map["palletNo"],
        lorryNo: map["lorryNo"],
        palletType: map["palletType"],
        destination: map["destination"],
        openPalletDateTime: map["openPalletDateTime"] ?? "",
        openByUserName: map["openByUserName"] ?? "",
        movePalletDateTime: map["movePalletDateTime"] ?? "",
        moveByUserName: map["moveByUserName"] ?? "",
        openPalletLocation: map["openPalletLocation"],
        assignPalletDateTime: map["assignPalletDateTime"] ?? "",
        assignToUserGuid: map["assignToUserGuid"],
        assignToUserName: map["assignToUserName"],
        assignByUserName: map["assignToUserName"] ?? "",
        loadPalletDateTime: map["loadPalletDateTime"] ?? "",
        loadByUserName: map["loadByUserName"] ?? "",
        status: map["status"],
        palletLocation: map["palletLocation"],
        items: (map['items'] as List?)
                ?.map((e) => PalletActivityDetail.fromMap(e))
                .toList() ??
            [],
        signature: Attachment.fromMap(map['signature'] as Map<String, dynamic>),
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
        signature: Attachment(
            attachmentUrl: "", attachmentFullPath: "", createdByUserName: ""),
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
        "items":
            items.isNotEmpty ? items.map((item) => item.toMap()).toList() : [],
        "signature": Attachment(
          attachmentUrl: signature.attachmentUrl,
          attachmentFullPath: signature.attachmentFullPath,
          createdByUserName: signature.createdByUserName,
        ),
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
        items.isEmpty &&
        signature.attachmentUrl == "" &&
        signature.attachmentFullPath == "" &&
        signature.createdByUserName == "";
  }
}

// Testing purpose
class ItemTest {
  String customerName;
  int qty;
  ItemTest({
    required this.customerName,
    required this.qty,
  });
}

class PalletActivityDetail {
  int palletActivityDetailId;
  int palletActivityId;
  int customerId;
  String customerName;
  int qty;

  PalletActivityDetail({
    required this.palletActivityDetailId,
    required this.palletActivityId,
    required this.customerId,
    required this.customerName,
    required this.qty,
  });

  factory PalletActivityDetail.fromMap(Map<String, dynamic> map) =>
      PalletActivityDetail(
        palletActivityDetailId: map["palletActivityDetailId"],
        palletActivityId: map["palletActivityId"],
        customerId: map["customerId"],
        customerName: map["customerName"],
        qty: map["qty"],
      );

  factory PalletActivityDetail.empty() => PalletActivityDetail(
        palletActivityDetailId: 0,
        palletActivityId: 0,
        customerId: 0,
        customerName: "",
        qty: 0,
      );

  Map<String, dynamic> toMap() => {
        "palletActivityDetailId": palletActivityDetailId,
        "palletActivityId": palletActivityId,
        "customerId": customerId,
        "customerName": customerName,
        "qty": qty,
      };

  bool isEmpty() =>
      palletActivityDetailId == 0 &&
      palletActivityId == 0 &&
      customerId == 0 &&
      customerName == "" &&
      qty == 0;
}

class Attachment {
  String? attachmentUrl;
  String? attachmentFullPath;
  String? createdByUserName;

  Attachment({
    required this.attachmentUrl,
    required this.attachmentFullPath,
    required this.createdByUserName,
  });

  factory Attachment.fromMap(Map<String, dynamic> map) => Attachment(
        attachmentUrl: map["attachmentUrl"] ?? "",
        attachmentFullPath: map["attachmentFullPath"] ?? "",
        createdByUserName: map["createdByUserName"] ?? "",
      );

  Map<String, dynamic> toMap() => {
        "attachmentUrl": attachmentUrl,
        "attachmentFullPath": attachmentFullPath,
        "createdByUserName": createdByUserName,
      };
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

  jobInitialize() async {
    try {
      List<dynamic> assignRes = await ApiServices.pallet.fetchAssignedJob();
      List<dynamic> confirmRes = await ApiServices.pallet.fetchConfirmedJob();
      List<dynamic> loadingRes = await ApiServices.pallet.fetchLoadingJob();

      final allJobs = [
        if (assignRes.isNotEmpty) ...assignRes,
        if (confirmRes.isNotEmpty) ...confirmRes,
        if (loadingRes.isNotEmpty) ...loadingRes,
      ];

      if (allJobs.isNotEmpty) {
        _pallets = {
          for (var v in allJobs) v["palletActivityId"]: Pallet.fromMap(v)
        };
      } else {
        _pallets = {};
      }

      notifyListeners();
    } catch (e) {
      // print(e);
    }
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
