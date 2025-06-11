import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/main_page.dart';

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
          '로그인 페이지',
          style: TextStyle(color: Colors.white), // 텍스트 색상 추가
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.home, color: Colors.white), // 아이콘 색상 추가
            onPressed: () {
              // 홈 버튼 클릭 시 동작
              print("홈버튼 클릭");
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 화면 가운데 정렬
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
                // TODO: 실제 로그인 로직 구현 필요
                // 현재는 단순히 MainPage로 이동
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainPage(
                      // 로그인 시 초기 예약 정보를 넘겨줄 필요가 없으므로 제거
                      // date: '2024.04.07 (월)',
                      // room: 'D421',
                      // time: '09:00',
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF9C2C38),
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(
                '로그인',
                style: TextStyle(fontSize: 18, color: Colors.white), // 텍스트 색상 변경
              ),
            ),
          ],
        ),
      ),
    );
  }
}