import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/reservation_page.dart'; // 경로 확인

class SeatMapPage extends StatefulWidget {
  final String room;
  final String time;
  final DateTime selectedDate;
  final List<int> reservedSeats;

  const SeatMapPage({
    Key? key,
    required this.room,
    required this.time,
    required this.selectedDate,
    required this.reservedSeats,
  }) : super(key: key);

  @override
  State<SeatMapPage> createState() => _SeatMapPageState();
}

class _SeatMapPageState extends State<SeatMapPage> {
  int? selectedSeat;

  @override
  Widget build(BuildContext context) {
    final seats = List.generate(64, (i) => i + 1);
    List<List<int>> groups = List.generate(
      4,
      (i) => seats.sublist(i * 16, (i + 1) * 16),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.room} 좌석 선택'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 16),
          Text(
            '${widget.selectedDate.year}년 ${widget.selectedDate.month}월 ${widget.selectedDate.day}일 ${widget.time} 예약',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 8),
          Expanded(
            child: Center(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: constraints.maxWidth + 50,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(4, (groupIdx) {
                                final group = groups[groupIdx];
                                Widget groupWidget = Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: List.generate(8, (colIdx) {
                                        int seatNum = group[colIdx];
                                        return seatBox(seatNum);
                                      }),
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: List.generate(8, (colIdx) {
                                        int seatNum = group[colIdx + 8];
                                        return seatBox(seatNum);
                                      }),
                                    ),
                                  ],
                                );
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  child: groupWidget,
                                );
                              }),
                            ),
                          ),
                          // 문 아이콘
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Image.asset(
                              'assets/door.png',
                              width: 50,
                              height: 50,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Image.asset(
                              'assets/door.png',
                              width: 50,
                              height: 50,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget seatBox(int seatNum) {
    final isReserved = widget.reservedSeats.contains(seatNum);
    final isSelected = selectedSeat == seatNum;

    return GestureDetector(
      onTap: isReserved
          ? null
          : () {
              setState(() {
                selectedSeat = seatNum;
              });
              // 예약페이지로 이동(좌석/강의실/시간/날짜 전달)
              Future.delayed(const Duration(milliseconds: 300), () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReservationPage(
                      room: widget.room,
                      time: widget.time,
                      selectedDate: widget.selectedDate,
                      seatNum: seatNum,
                      isDetailView: false,
                    ),
                  ),
                );
              });
            },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: isReserved
              ? Colors.red
              : isSelected
                  ? Colors.blue
                  : Colors.grey[400],
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 2),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          '$seatNum',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
