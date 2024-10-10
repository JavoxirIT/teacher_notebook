class GroupDB {
  late int? id;
  late String groupName;
  late String groupTimes;
  late int groupDays;
  late int groupPrice;

  GroupDB({
    this.id,
    required this.groupName,
    required this.groupTimes,
    required this.groupDays,
    required this.groupPrice,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['group_id'] = id;
    map['name'] = groupName;
    map['times'] = groupTimes;
    map['days'] = groupDays;
    map['price'] = groupPrice;
    return map;
  }

  GroupDB.fromMap(Map<String, dynamic> map) {
    id = map['group_id'];
    groupName = map['name'];
    groupTimes = map['times'];
    groupDays = map['days'];
    groupPrice = map['price'];
  }
}
