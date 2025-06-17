import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'seat.dart'; // seat.dart의 실제 경로를 확인해 주세요

class RoomSelectionPage extends StatefulWidget {
  const RoomSelectionPage({Key? key}) : super(key: key);

  @override
  State<RoomSelectionPage> createState() => _RoomSelectionPageState();
}

class _RoomSelectionPageState extends State<RoomSelectionPage> {
  final List<String> rooms = List.generate(10, (i) => 'D42${i + 1}');
  final List<String> times = [
    '09:00', '10:00', '11:00', '12:00',
    '13:00', '14:00', '15:00', '16:00',
    '17:00', '18:00'
  ];

  DateTime _selectedDate = DateTime.now();

  // 실제 앱에서는 서버/DB에서 받아올 데이터!
  final Map<String, List<int>> dummyReserved = {};

  // 내 예약 정보: key='room-time-YYYYMMDD', value=좌석번호
  Map<String, int> myReservation = {};

  // 오늘 날짜와 비교해서 지난 시간대는 제외
  List<String> getAvailableTimes() {
    final now = DateTime.now();
    return times.where((timeStr) {
      final slotHour = int.parse(timeStr.split(':')[0]);
      final timeSlot = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, slotHour);
      if (_selectedDate.year == now.year &&
          _selectedDate.month == now.month &&
          _selectedDate.day == now.day) {
        // "해당 슬롯의 끝시간(예: 13:00 + 1시간 = 14:00)"이 현재시각 이후여야 활성화
        final slotEnd = timeSlot.add(Duration(hours: 1));
        return now.isBefore(slotEnd);
      }
      return true; // 오늘이 아니면 모두 활성화
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final availableTimes = getAvailableTimes();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '강의실 선택',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF9C2C38),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '선택된 날짜: ${DateFormat('yyyy년 MM월 dd일 (E)', 'ko_KR').format(_selectedDate)}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 6)),
                      helpText: '예약 날짜 선택',
                      cancelText: '취소',
                      confirmText: '선택',
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: Color(0xFF9C2C38),
                              onPrimary: Colors.white,
                              onSurface: Colors.black,
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFF9C2C38),
                              ),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null && picked != _selectedDate) {
                      setState(() {
                        _selectedDate = picked;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9C2C38),
                  ),
                  child: const Text(
                    '날짜 선택',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          // 내 예약 내역 상단 표시
          if (myReservation.isNotEmpty)
            Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: myReservation.entries
                    .map((e) => Text(
                          '예약됨: ${e.key.replaceAll("-", " ")} | 좌석 ${e.value}',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ))
                    .toList(),
              ),
            ),

          Expanded(
            child: ListView.builder(
              itemCount: rooms.length,
              itemBuilder: (context, roomIndex) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            rooms[roomIndex],
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: availableTimes.map((time) {
                                String key =
                                    '${rooms[roomIndex]}-$time-${DateFormat('yyyyMMdd').format(_selectedDate)}';
                                bool isMyReserved = myReservation.containsKey(key);
                                List<int> reservedSeats = dummyReserved[key] ?? [];

                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: ElevatedButton(
                                    onPressed: isMyReserved
                                        ? null
                                        : () async {
                                            final seatNum = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => SeatMapPage(
                                                  room: rooms[roomIndex],
                                                  time: time,
                                                  selectedDate: _selectedDate,
                                                  reservedSeats: reservedSeats,
                                                ),
                                              ),
                                            );
                                            if (seatNum != null) {
                                              setState(() {
                                                myReservation[key] = seatNum;
                                                dummyReserved[key] =
                                                    List<int>.from(reservedSeats)
                                                      ..add(seatNum);
                                              });
                                            }
                                          },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isMyReserved
                                          ? Colors.grey
                                          : const Color(0xFF9C2C38),
                                    ),
                                    child: Text(
                                      time,
                                      style: TextStyle(
                                        color: isMyReserved
                                            ? Colors.grey[300]
                                            : Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
