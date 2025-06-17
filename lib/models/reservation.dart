class Reservation {
  final String date;
  final String room;
  final String time;
  final String name;
  final int seatNum;
  final String studentId;
  final String major;

  Reservation({
    required this.date,
    required this.room,
    required this.time,
    required this.name,
    required this.seatNum,
    required this.studentId,
    required this.major,
  });

  // Map에서 Reservation 객체로 변환
  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      date: json['date'],
      room: json['room'],
      time: json['time'],
      name: json['name'],
      seatNum: json['seatNum'],
      studentId: json['studentId'],
      major: json['major'],
    );
  }

  // Reservation 객체에서 Map으로 변환
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'room': room,
      'time': time,
      'name': name,
      'seatNum': seatNum,           // seatNum 저장
      'studentId': studentId,
      'major': major,
    };
  }
}
