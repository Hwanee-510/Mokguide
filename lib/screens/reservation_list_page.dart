import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart'; // main.dart에서 allReservations 접근
import 'package:flutter_application_1/models/reservation.dart'; // Reservation 모델 임포트
import 'package:flutter_application_1/screens/reservation_page.dart'; // 예약 상세 페이지로 이동
import 'package:intl/intl.dart'; // DateTime.parse를 위해 추가

// 정렬 순서를 위한 Enum
enum SortOrder { ascending, descending }

class ReservationListPage extends StatefulWidget {
  const ReservationListPage({Key? key}) : super(key: key); // Key 추가
  @override
  _ReservationListPageState createState() => _ReservationListPageState();
}

class _ReservationListPageState extends State<ReservationListPage> {
  // 현재 필터링 및 정렬된 예약 리스트
  List<Reservation> _filteredReservations = [];

  // 정렬 기준과 순서 상태 변수
  String _sortBy = 'date'; // 기본 정렬: 날짜
  SortOrder _sortOrder = SortOrder.descending; // 기본 순서: 내림차순

  @override
  void initState() {
    super.initState();
    _applyFiltersAndSort(); // 초기화 시 필터링 및 정렬 적용
  }

  // 필터링 및 정렬을 적용하는 함수
  void _applyFiltersAndSort() {
    List<Reservation> tempList = List.from(allReservations); // 원본 리스트 복사

    // 예약 횟수 계산 (가장 많이 예약한 강의실 정렬을 위해)
    Map<String, int> roomReservationCounts = {};
    for (var reservation in allReservations) {
      roomReservationCounts[reservation.room] =
          (roomReservationCounts[reservation.room] ?? 0) + 1;
    }

    // 정렬 로직
    tempList.sort((a, b) {
      int comparison = 0;
      if (_sortBy == 'date') {
        // 날짜 정렬
        // 'yyyy.MM.dd (E)' 형식에서 날짜만 추출하여 DateTime으로 파싱
        DateTime dateA = DateFormat('yyyy.MM.dd (E)', 'ko_KR').parse(a.date);
        DateTime dateB = DateFormat('yyyy.MM.dd (E)', 'ko_KR').parse(b.date);
        comparison = dateA.compareTo(dateB);
      } else if (_sortBy == 'room') {
        // 강의실 이름 정렬 (알파벳 순)
        comparison = a.room.compareTo(b.room);
      } else if (_sortBy == 'count') {
        // 예약 횟수 정렬 (가장 많이 예약한 강의실)
        int countA = roomReservationCounts[a.room] ?? 0;
        int countB = roomReservationCounts[b.room] ?? 0;
        comparison = countA.compareTo(countB);
      }

      // 정렬 순서 적용
      return _sortOrder == SortOrder.ascending ? comparison : -comparison;
    });

    setState(() {
      _filteredReservations = tempList;
    });
  }

  // 개별 예약 삭제 함수
  void _deleteReservation(Reservation reservation) {
    setState(() {
      removeReservation(reservation); // main.dart의 removeReservation 함수 호출
      _applyFiltersAndSort(); // 삭제 후 리스트 갱신
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('예약이 삭제되었습니다.')), // const 추가
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text( // const 추가
          '예약 목록',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF9C2C38), // const 추가
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort, color: Colors.white), // const 추가
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
                _applyFiltersAndSort(); // 정렬 기준 변경 시 갱신
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>( // const 추가
                value: 'date_desc',
                child: Text('날짜별 내림차순'),
              ),
              const PopupMenuItem<String>( // const 추가
                value: 'date_asc',
                child: Text('날짜별 오름차순'),
              ),
              const PopupMenuItem<String>( // const 추가
                value: 'room_desc',
                child: Text('강의실명 내림차순'),
              ),
              const PopupMenuItem<String>( // const 추가
                value: 'room_asc',
                child: Text('강의실명 오름차순'),
              ),
              const PopupMenuItem<String>( // const 추가
                value: 'count_desc',
                child: Text('예약 횟수 내림차순'),
              ),
              const PopupMenuItem<String>( // const 추가
                value: 'count_asc',
                child: Text('예약 횟수 오름차순'),
              ),
            ],
          ),
        ],
      ),
      body: _filteredReservations.isEmpty
          ? const Center( // const 추가
              child: Text(
                '예약 내역이 없습니다.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: _filteredReservations.length,
              itemBuilder: (context, index) {
                final reservation = _filteredReservations[index];
                // 저장된 String 형태의 날짜를 DateTime으로 변환
                final parsedDate = DateFormat('yyyy.MM.dd (E)', 'ko_KR').parse(reservation.date);

                return Card(
                  key: ValueKey(reservation.room + reservation.time + reservation.date + reservation.name), // Unique Key 추가
                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // const 추가
                  elevation: 2,
                  child: ListTile(
                    title: Text(
                        '${reservation.date} | ${reservation.room} | ${reservation.time}'),
                    subtitle: Text(
                        '${reservation.name} (${reservation.studentId}, ${reservation.major})'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red), // const 추가
                      onPressed: () => _deleteReservation(reservation),
                    ),
                    onTap: () {
                      // 예약 상세 페이지로 이동, 모든 예약 정보를 넘겨줍니다.
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
                            selectedDate: parsedDate, // ⭐ 저장된 날짜를 DateTime으로 변환하여 전달
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