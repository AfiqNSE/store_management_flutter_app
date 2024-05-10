import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:store_management_system/models/notif.dart';

class DB {
  static final instance = DB();

  Database? _database;

  Future<void> initialize() async {
    // Open the database and store the reference.
    _database = await openDatabase(
      // Set the path to the database.
      join(await getDatabasesPath(), 'sma.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        return db.execute(
          """
          CREATE TABLE notif(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            messageId TEXT NOT NULL,
            guid TEXT NOT NULL,
            code INTEGER NOT NULL,
            activityId INTEGER NOT NULL, 
            palletNo TEXT NOT NULL,
            isRead INTEGER NOT NULL,
            createdOn INTEGER NOT NULL
          )
          """,
        );
      },
      version: 1,
    );

    // Delete expired notifs
    DateTime expired = DateTime.now().subtract(const Duration(days: 90));
    await _database!.delete(
      "notif",
      where: "createdOn <= ?",
      whereArgs: [expired.millisecondsSinceEpoch],
    );
  }

  insertNotif(Notif notif) async {
    if (_database == null) await initialize();

    await _database!.insert('notif', {
      "guid": notif.guid,
      "messageId": notif.messageId,
      "code": notif.code,
      "activityId": notif.activityId,
      "palletNo": notif.palletNo,
      "isRead": notif.isRead ? 1 : 0,
      "createdOn": notif.createdOn.millisecondsSinceEpoch,
    });
  }

  Future<List<Notif>> getNotifs() async {
    if (_database == null) await initialize();

    List<Map<String, dynamic>> maps = await _database!.query(
      "notif",
      orderBy: "createdOn DESC",
    );

    return List.generate(
      maps.length,
      (index) => Notif(
        id: maps[index]["id"],
        messageId: maps[index]["messageId"],
        guid: maps[index]["guid"],
        code: maps[index]["code"],
        activityId: maps[index]["activityId"],
        palletNo: maps[index]["palletNo"],
        isRead: maps[index]["isRead"] == 1 ? true : false,
        createdOn: DateTime.fromMillisecondsSinceEpoch(
          maps[index]["createdOn"],
        ),
      ),
    );
  }

  Future<bool> hasUnreadNotif() async {
    if (_database == null) await initialize();

    List<Map<String, dynamic>> maps = await _database!.query(
      "notif",
      where: "isRead = ?",
      whereArgs: [0],
    );

    return maps.isNotEmpty;
  }

  updateNotif({
    required int id,
    required String messageId,
    required bool isRead,
  }) async {
    if (_database == null) await initialize();

    await _database!.update(
      "notif",
      {
        "isRead": isRead ? 1 : 0,
      },
      where: "id = ? OR messageId = ?",
      whereArgs: [id, messageId],
    );
  }

  deleteNotif({required int id, required String messageId}) async {
    if (_database == null) await initialize();

    await _database!.delete(
      "notif",
      where: "id = ? OR messageId = ?",
      whereArgs: [id, messageId],
    );
  }
}
