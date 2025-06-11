import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart'; // main.dart의 전역 함수와 변수 사용
import 'package:flutter_application_1/screens/main_page.dart';
import 'package:flutter_application_1/models/reservation.dart'; // Reservation 모델 임포트
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ReservationPage extends StatefulWidget {
  final String room;
  final String time;
  final DateTime selectedDate; // 새로 추가된 선택된 날짜 필드
  // 예약 상세 보기 시 사용할 선택적 매개변수들
  final String? name;
  final String? studentId;
  final String? major;
  final String? date; // 기존의 date 필드는 string 형태였으나, selectedDate가 DateTime으로 추가됨.
                      // 상세 보기 시에는 date를 사용하여 표시할 수 있도록 유지.
  final bool isDetailView;

  ReservationPage({
    Key? key, // Key 추가
    required this.room,
    required this.time,
    required this.selectedDate, // 생성자에 추가
    this.name,
    this.studentId,
    this.major,
    this.date,
    this.isDetailView = false,
  }) : super(key: key); // Key 전달

  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController studentIdController = TextEditingController();
  final TextEditingController majorController = TextEditingController();
  // late String currentDate; // 이제 selectedDate를 사용하므로 이 변수는 필요 없음

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ko_KR', null); // DateFormat을 위해 초기화

    // 상세 보기 모드일 경우 기존 데이터로 채움
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

    // 선택된 날짜를 사용하여 Reservation 객체 생성
    final newReservation = Reservation(
      date: DateFormat('yyyy.MM.dd (E)', 'ko_KR').format(widget.selectedDate), // 선택된 날짜 사용
      room: widget.room,
      time: widget.time,
      name: nameController.text,
      studentId: studentIdController.text,
      major: majorController.text,
    );

    addReservation(newReservation); // main.dart의 addReservation 함수 호출

    showToast("예약이 완료되었습니다.");

    // 필드 초기화
    nameController.clear();
    studentIdController.clear();
    majorController.clear();

    // MainPage로 이동 (이전 페이지 스택 제거)
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => MainPage(), // const 추가
      ),
      (Route<dynamic> route) => false, // 모든 이전 라우트 제거
    );
  }

  @override
  Widget build(BuildContext context) {
    // 상세 보기 모드일 때는 widget.date를, 새 예약 모드일 때는 widget.selectedDate를 사용
    String displayDate = widget.isDetailView
        ? widget.date!
        : DateFormat('yyyy.MM.dd (E)', 'ko_KR').format(widget.selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isDetailView ? '예약 상세' : '예약',
          style: const TextStyle(color: Colors.white), // const 추가
        ),
        backgroundColor: const Color(0xFF9C2C38), // const 추가
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              '$displayDate | ${widget.room} / ${widget.time} ${widget.isDetailView ? '(예약 상세)' : '예약'}',
              style: const TextStyle(fontSize: 22, color: Color(0xFF9C2C38)), // const 추가
            ),
            const SizedBox(height: 16), // const 추가
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: '이름',
                border: const OutlineInputBorder(), // const 추가
                filled: true,
                fillColor: Colors.grey[200],
              ),
              readOnly: widget.isDetailView,
            ),
            const SizedBox(height: 16), // const 추가
            TextField(
              controller: studentIdController,
              decoration: InputDecoration(
                labelText: '학번',
                border: const OutlineInputBorder(), // const 추가
                filled: true,
                fillColor: Colors.grey[200],
              ),
              readOnly: widget.isDetailView,
            ),
            const SizedBox(height: 16), // const 추가
            TextField(
              controller: majorController,
              decoration: InputDecoration(
                labelText: '학과',
                border: const OutlineInputBorder(), // const 추가
                filled: true,
                fillColor: Colors.grey[200],
              ),
              readOnly: widget.isDetailView,
            ),
            const SizedBox(height: 24), // const 추가
            const Text( // const 추가
              '예약 안내문: 예약 후 5분 이내 미입실 시 자동취소됩니다.',
              style: TextStyle(fontSize: 14, color: Colors.red),
            ),
            const SizedBox(height: 24), // const 추가
            if (!widget.isDetailView)
              ElevatedButton(
                onPressed: handleReservation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9C2C38), // const 추가
                  minimumSize: const Size(double.infinity, 50), // const 추가
                ),
                child: const Text( // const 추가
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