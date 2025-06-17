import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/screens/main_page.dart';
import 'package:flutter_application_1/models/reservation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ReservationPage extends StatefulWidget {
  final String room;
  final String time;
  final DateTime selectedDate;
  final int seatNum; // seatNum 필수
  final String? name;
  final String? studentId;
  final String? major;
  final String? date;
  final bool isDetailView;

  ReservationPage({
    Key? key,
    required this.room,
    required this.time,
    required this.selectedDate,
    required this.seatNum, // 필수
    this.name,
    this.studentId,
    this.major,
    this.date,
    this.isDetailView = false,
  }) : super(key: key);

  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController studentIdController = TextEditingController();
  final TextEditingController majorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ko_KR', null);
    if (widget.isDetailView) {
      nameController.text = widget.name ?? '';
      studentIdController.text = widget.studentId ?? '';
      majorController.text = widget.major ?? '';
    }
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void handleReservation() {
    if (nameController.text.isEmpty ||
        studentIdController.text.isEmpty ||
        majorController.text.isEmpty) {
      showToast("모든 항목을 입력해주세요.");
      return;
    }

    final newReservation = Reservation(
      date: DateFormat('yyyy.MM.dd (E)', 'ko_KR').format(widget.selectedDate),
      room: widget.room,
      time: widget.time,
      seatNum: widget.seatNum, // 좌석번호 포함
      name: nameController.text,
      studentId: studentIdController.text,
      major: majorController.text,
    );

    addReservation(newReservation);

    showToast("예약이 완료되었습니다.");

    nameController.clear();
    studentIdController.clear();
    majorController.clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => MainPage(),
      ),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    String displayDate = widget.isDetailView
        ? widget.date!
        : DateFormat('yyyy.MM.dd (E)', 'ko_KR').format(widget.selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isDetailView ? '예약 상세' : '예약',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF9C2C38),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              '$displayDate | ${widget.room} / ${widget.time} / 좌석 ${widget.seatNum}${widget.isDetailView ? ' (예약 상세)' : ' 예약'}',
              style: const TextStyle(fontSize: 22, color: Color(0xFF9C2C38)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: '이름',
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              readOnly: widget.isDetailView,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: studentIdController,
              decoration: InputDecoration(
                labelText: '학번',
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              readOnly: widget.isDetailView,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: majorController,
              decoration: InputDecoration(
                labelText: '학과',
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              readOnly: widget.isDetailView,
            ),
            const SizedBox(height: 24),
            const Text(
              '예약 안내문: 예약 후 5분 이내 미입실 시 자동취소됩니다.',
              style: TextStyle(fontSize: 14, color: Colors.red),
            ),
            const SizedBox(height: 24),
            if (!widget.isDetailView)
              ElevatedButton(
                onPressed: handleReservation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9C2C38),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  '예약 확정',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
