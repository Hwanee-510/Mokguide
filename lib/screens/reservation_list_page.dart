import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/models/reservation.dart';
import 'package:flutter_application_1/screens/reservation_page.dart';
import 'package:intl/intl.dart';

// 정렬 순서를 위한 Enum
enum SortOrder { ascending, descending }

class ReservationListPage extends StatefulWidget {
  const ReservationListPage({Key? key}) : super(key: key);
  @override
  _ReservationListPageState createState() => _ReservationListPageState();
}

class _ReservationListPageState extends State<ReservationListPage> {
  List<Reservation> _filteredReservations = [];
  String _sortBy = 'date';
  SortOrder _sortOrder = SortOrder.descending;

  @override
  void initState() {
    super.initState();
    _applyFiltersAndSort();
  }

  void _applyFiltersAndSort() {
    List<Reservation> tempList = List.from(allReservations);

    Map<String, int> roomReservationCounts = {};
    for (var reservation in allReservations) {
      roomReservationCounts[reservation.room] =
          (roomReservationCounts[reservation.room] ?? 0) + 1;
    }

    tempList.sort((a, b) {
      int comparison = 0;
      if (_sortBy == 'date') {
        DateTime dateA = DateFormat('yyyy.MM.dd (E)', 'ko_KR').parse(a.date);
        DateTime dateB = DateFormat('yyyy.MM.dd (E)', 'ko_KR').parse(b.date);
        comparison = dateA.compareTo(dateB);
      } else if (_sortBy == 'room') {
        comparison = a.room.compareTo(b.room);
      } else if (_sortBy == 'count') {
        int countA = roomReservationCounts[a.room] ?? 0;
        int countB = roomReservationCounts[b.room] ?? 0;
        comparison = countA.compareTo(countB);
      }
      return _sortOrder == SortOrder.ascending ? comparison : -comparison;
    });

    setState(() {
      _filteredReservations = tempList;
    });
  }

  void _deleteReservation(Reservation reservation) {
    setState(() {
      removeReservation(reservation);
      _applyFiltersAndSort();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('예약이 삭제되었습니다.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '예약 목록',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF9C2C38),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort, color: Colors.white),
            onSelected: (String result) {
              setState(() {
                if (result.contains('date')) {
                  _sortBy = 'date';
                } else if (result.contains('room')) {
                  _sortBy = 'room';
                } else if (result.contains('count')) {
                  _sortBy = 'count';
                }

                if (result.contains('asc')) {
                  _sortOrder = SortOrder.ascending;
                } else if (result.contains('desc')) {
                  _sortOrder = SortOrder.descending;
                }
                _applyFiltersAndSort();
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'date_desc',
                child: Text('날짜별 내림차순'),
              ),
              const PopupMenuItem<String>(
                value: 'date_asc',
                child: Text('날짜별 오름차순'),
              ),
              const PopupMenuItem<String>(
                value: 'room_desc',
                child: Text('강의실명 내림차순'),
              ),
              const PopupMenuItem<String>(
                value: 'room_asc',
                child: Text('강의실명 오름차순'),
              ),
              const PopupMenuItem<String>(
                value: 'count_desc',
                child: Text('예약 횟수 내림차순'),
              ),
              const PopupMenuItem<String>(
                value: 'count_asc',
                child: Text('예약 횟수 오름차순'),
              ),
            ],
          ),
        ],
      ),
      body: _filteredReservations.isEmpty
          ? const Center(
              child: Text(
                '예약 내역이 없습니다.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: _filteredReservations.length,
              itemBuilder: (context, index) {
                final reservation = _filteredReservations[index];
                final parsedDate = DateFormat('yyyy.MM.dd (E)', 'ko_KR').parse(reservation.date);

                return Card(
                  key: ValueKey(reservation.room + reservation.time + reservation.date + reservation.name),
                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  elevation: 2,
                  child: ListTile(
                    title: Text(
                        '${reservation.date} | ${reservation.room} | ${reservation.time} | 좌석 ${reservation.seatNum}'), // 좌석 번호 표시!
                    subtitle: Text(
                        '${reservation.name} (${reservation.studentId}, ${reservation.major})'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteReservation(reservation),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReservationPage(
                            room: reservation.room,
                            time: reservation.time,
                            name: reservation.name,
                            studentId: reservation.studentId,
                            major: reservation.major,
                            date: reservation.date,
                            seatNum: reservation.seatNum, // seatNum도 전달
                            selectedDate: parsedDate,
                            isDetailView: true,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
