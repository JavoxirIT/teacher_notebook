import 'package:TeamLead/db/constants/student_create_group_constant.dart';
import 'package:TeamLead/db/init_db.dart';
import 'package:TeamLead/db/models/group_db_models.dart';
import 'package:sqflite/sqflite.dart';

class NewGroupRepository extends InitDB {
  static final NewGroupRepository db = NewGroupRepository();

  final List<GroupDB> groupList = [];

  // READ
  Future<List<GroupDB>> getGroup() async {
    groupList.clear();
    Database? db = await database;
    final List<Map<String, dynamic>> groupMapList = await db!.query(groupTable);
    for (var element in groupMapList) {
      groupList.add(GroupDB.fromMap(element));
    }
    return groupList;
  }

  // INSERT
  Future<Object> insertGroup(GroupDB group) async {
    if (group.id == null) {
      Database? db = await database;
      group.id = await db!.insert(groupTable, group.toMap());
      return group;
    } else {
      Database? db = await database;
      return await db!.update(
        groupTable,
        group.toMap(),
        where: '$groupId = ?',
        whereArgs: [group.id],
      );
    }
  }

// UPDATE
  // Future<int> updateStudent(StudentGroupDB group) async {
  //   Database? db = await database;
  //   return await db!.update(
  //     groupTable,
  //     group.toMap(),
  //     where: '$groupId = ?',
  //     whereArgs: [group.id],
  //   );
  // }

// DELETE
  Future<int> deleteGroup(id) async {
    Database? db = await database;
    return await db!.delete(
      groupTable,
      where: '$groupId = ?',
      whereArgs: [id],
    );
  }
}
