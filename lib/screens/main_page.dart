import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'camera.dart';
import 'qr.dart';
import 'package:flutter_application_1/screens/room_selection_page.dart';
import 'package:flutter_application_1/screens/reservation_list_page.dart';
import 'package:flutter_application_1/main.dart'; // globalStudentId 포함
import 'package:flutter_application_1/models/reservation.dart';
import 'firebase_options.dart';

class MainPage extends StatefulWidget {
  MainPage();

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Reservation? latestReservation;
  bool darkMode = false;
  bool notifications = true;

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
    _loadLatestReservation();
  }

  Future<void> _initializeFirebase() async {
    await Firebase.initializeApp(
      name: 'cam',
      options: DefaultFirebaseOptions.app1,
    );
    await Firebase.initializeApp(
      name: 'qr',
      options: DefaultFirebaseOptions.app2,
    );
  }

  void _loadLatestReservation() {
    setState(() {
      latestReservation = allReservations.isNotEmpty ? allReservations.last : null;
    });
  }

  void cancelLatestReservation() {
    if (latestReservation != null) {
      removeReservation(latestReservation!);
      setState(() {
        latestReservation = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('예약이 취소되었습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String displayText = (latestReservation != null)
        ? "${latestReservation!.date} | ${latestReservation!.room} | ${latestReservation!.time} 예약중"
        : "예약 정보가 없습니다";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF9C2C38),
        title: Text(
          '메인 페이지',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xFF9C2C38),
                ),
                child: Text(
                  '메뉴',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              ListTile(
                title: Text('설정',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              SwitchListTile(
                title: Text('다크 모드'),
                value: darkMode,
                onChanged: (value) {
                  setState(() {
                    darkMode = value;
                  });
                },
              ),
              SwitchListTile(
                title: Text('알림 받기'),
                value: notifications,
                onChanged: (value) {
                  setState(() {
                    notifications = value;
                  });
                },
              ),
              ListTile(
                title: Text('앱 버전'),
                subtitle: Text('v1.0.0'),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.list),
                title: Text('예약 목록'),
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReservationListPage()),
                  );
                  _loadLatestReservation();
                },
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              displayText,
              style: TextStyle(fontSize: 18, color: Color(0xFF9C2C38)),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),

            if (latestReservation != null) ...[
              ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CameraPage()),
                  );
                  if (result == true) {
                    cancelLatestReservation();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  minimumSize: Size(double.infinity, 40),
                ),
                child: Text(
                  '반납(자리 촬영)',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: cancelLatestReservation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[100],
                  minimumSize: Size(double.infinity, 40),
                ),
                child: Text(
                  '예약 취소',
                  style: TextStyle(fontSize: 16, color: Colors.red[800]),
                ),
              ),
            ],
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (latestReservation == null)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RoomSelectionPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF9C2C38),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text(
                      '강의실 예약',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QRPage(studentId: globalStudentId),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF9C2C38),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text(
                    'QR 코드',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
