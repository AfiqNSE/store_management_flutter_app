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
  String assignPalletDateTime;
  String assignToUserGuid;
  String assignByUserName;
  String loadPalletDateTime;
  String loadByUserName;
  String status;
  String palletLocation;
  String items;
  String signature;

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
    required this.openPalletLocation,
    required this.assignPalletDateTime,
    required this.assignToUserGuid,
    required this.assignByUserName,
    required this.loadPalletDateTime,
    required this.loadByUserName,
    required this.status,
    required this.palletLocation,
    required this.items,
    required this.signature,
  });

  factory Pallet.fromJson(Map<String, dynamic> map) => Pallet(
        palletActivityId: map["palletActivityId"],
        palletID: map["palletId"],
        palletNo: map["palletNo"],
        lorryNo: map["lorryNo"],
        palletType: map["palletType"],
        destination: map["destination"],
        openPalletDateTime: map["openPalletDateTime"],
        openByUserName: map["openByUserName"],
        movePalletDateTime: map["movePalletDateTime"],
        openPalletLocation: map["moveByUserName"],
        assignPalletDateTime: map["assignPalletDateTime"],
        assignToUserGuid: map["assignToUserGuid"],
        assignByUserName: map["assignToUserName"],
        loadPalletDateTime: map["loadPalletDateTime"],
        loadByUserName: map["loadByUserName"],
        status: map["status"],
        palletLocation: map["palletLocation"],
        items: map["items"], // change to list
        signature: map["signature"],
      );

  Map<String, dynamic> toJson() => {
        "palletActivityId": palletActivityId,
        "palletId": palletID,
        "palletNo": palletNo,
        "lorryNo": lorryNo,
        "palletType": palletType,
        "destination": destination,
        "openPalletDateTime": openPalletDateTime,
        "openByUserName": openByUserName,
        "movePalletDateTime": movePalletDateTime,
        "openPalletLocation": openPalletLocation,
        "assignPalletDateTime": assignPalletDateTime,
        "assignToUserGuid": assignToUserGuid,
        "assignByUserName": assignByUserName,
        "loadPalletDateTime": loadPalletDateTime,
        "loadByUserName": loadByUserName,
        "status": status,
        "palletLocation": palletLocation,
        "items": items, // change to list
        "signature": signature
      };
}

// testing
class Item {
  final String name;
  final int quantity;

  Item(
    this.name,
    this.quantity,
  );
}
