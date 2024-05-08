import 'package:flutter/material.dart';
import 'package:store_management_system/utils/db_utils.dart';

class Notif {
  int id;
  final String messageId;
  final String guid;
  final int code;
  final int activityId;
  final String palletNo;
  bool isRead;
  final DateTime createdOn;

  Notif({
    this.id = 0,
    required this.messageId,
    required this.guid,
    required this.code,
    required this.activityId,
    required this.palletNo,
    this.isRead = false,
    required this.createdOn,
  });
}

class NotifNotifier extends ChangeNotifier {
  List<Notif> _notifs = List.empty(growable: true);

  List<Notif> get notifs => _notifs;

  void initialize() async {
    _notifs = await DB.instance.getNotifs();
    notifyListeners();
  }

  void add(Notif notif) async {
    _notifs.insert(0, notif);
    await DB.instance.insertNotif(notif);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}
