import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/main_page.dart';
// main.dart에 전역 변수 선언됨
import 'package:flutter_application_1/main.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController idController = TextEditingController();
  final TextEditingController pwController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF9C2C38),
        title: Text(
          '로그인',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.home, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            Text(
              '강의실 예약 어플 목원대',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF9C2C38)),
            ),
            SizedBox(height: 32),
            TextField(
              controller: idController,
              decoration: InputDecoration(
                labelText: 'ID',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: pwController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'PW',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // 로그인 성공 시 학번을 전역 변수에 저장
                globalStudentId = idController.text.trim();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MainPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF9C2C38),
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(
                '로그인',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
