
class PaymentsDB {
  late int? paysId;
  late int paysSumma;
  late String paysDate;
  late int paysStudentID;
  late String studentName;
  late String studentSurName;

  PaymentsDB(this.paysId, this.paysSumma, this.paysDate, this.paysStudentID);

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map["id"] = paysId;
    map["student_id"] = paysStudentID;
    map["summa"] = paysSumma;
    map["date"] = paysDate;
    return map;
  }

  PaymentsDB.fromMap(Map<String, dynamic> map) {
    paysId = map['id'];
    paysStudentID = map['student_id'];
    paysSumma = map['summa'];
    paysDate = map['date'];
    studentName = map['studentName'];
    studentSurName = map['studentSurName'];
  }
}
