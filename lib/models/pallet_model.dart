class Pallet {
  int palletID;
  String palletNo;
  int status;
  DateTime createdOn;
  String createdByUserName;
  String modifiedOn;
  String modifiedByUserName;
  List<int> createdByUserGuid;
  List<int> modifiedByUserGuid;

  Pallet({
    required this.palletID,
    required this.palletNo,
    required this.status,
    required this.createdOn,
    required this.createdByUserName,
    required this.modifiedOn,
    required this.modifiedByUserName,
    required this.createdByUserGuid,
    required this.modifiedByUserGuid,
  });

  factory Pallet.fromJson(Map<String, dynamic> json) => Pallet(
        palletID: json["PalletID"],
        palletNo: json["PalletNo"],
        status: json["Status"],
        createdOn: DateTime.parse(json["createdOn"]),
        createdByUserName: json["CreatedByUserName"],
        modifiedOn: json["ModifiedOn"],
        modifiedByUserName: json["ModifiedByUserName"],
        createdByUserGuid:
            List<int>.from(json["createdByUserGuid"].map((x) => x)),
        modifiedByUserGuid:
            List<int>.from(json["CreatedByUserGuid"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "PalletID": palletID,
        "PalletNo": palletNo,
        "Status": status,
        "CreatedOn": createdOn.toIso8601String(),
        "CreatedByUserName": createdByUserName,
        "ModifiedOn": modifiedOn,
        "ModifiedByUserName": modifiedByUserName,
        "CreatedByUserGuid":
            List<dynamic>.from(createdByUserGuid.map((x) => x)),
        "ModifiedByUserGuid":
            List<dynamic>.from(modifiedByUserGuid.map((x) => x)),
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
