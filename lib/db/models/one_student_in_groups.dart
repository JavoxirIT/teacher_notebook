class OneStudentInGroups {
  OneStudentInGroups({
    required this.groupName,
    required this.groupId,
    required this.price,
  });

  late String groupName;
  late int groupId;
  late int price;
  OneStudentInGroups.fromMap(Map<String, dynamic> map) {
    groupName = map['name'];
    groupId = map['group_id'];
    price = map['price'];
  }

  @override
  toString() {
    return "OneStudentInGroups(groupName: $groupName, groupId: $groupId, price: $price)";
  }
}
