import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'firebase_options.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: QRPage(),
    );
  }
}

class QRPage extends StatefulWidget {
  @override
  State<QRPage> createState() => _QRPageState();
}

class _QRPageState extends State<QRPage> {
  String? studentId;
  Map<String, dynamic>? studentData;
  String qrData = "";
  Timer? qrTimer;

  final _idController = TextEditingController();
  bool qrVisible = false;
  bool isRotating = false; // 새로고침 애니메이션용

  @override
  void dispose() {
    qrTimer?.cancel();
    _idController.dispose();
    super.dispose();
  }

  Future<void> fetchDataAndShowQR() async {
    final id = _idController.text.trim();
    if (id.isEmpty) return;

    final doc = await FirebaseFirestore.instance.collection('students').doc(id).get();
    if (!doc.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("해당 학번이 존재하지 않습니다.")),
      );
      setState(() {
        qrVisible = false;
      });
      return;
    }
    studentId = id;
    studentData = doc.data();
    updateQR();
    startAutoRefresh();
    setState(() {
      qrVisible = true;
    });
  }

  void updateQR() {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 60;
    qrData = "${studentData!['학번']}_$now";
    setState(() {});
  }

  void startAutoRefresh() {
    qrTimer?.cancel();
    qrTimer = Timer.periodic(Duration(minutes: 1), (_) => updateQR());
  }

  void manualRefresh() {
    // 새로고침 애니메이션 효과
    setState(() => isRotating = true);
    Future.delayed(Duration(milliseconds: 700), () {
      setState(() => isRotating = false);
    });
    updateQR();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("QR 코드가 새로고침되었습니다.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("QR코드 생성기")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!qrVisible) ...[
                  TextField(
                    controller: _idController,
                    decoration: InputDecoration(
                    labelText: '학번 입력',
                    border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number, // 숫자패드로 변경!
                    ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: fetchDataAndShowQR,
                    child: Text("QR코드 생성"),
                  ),
                ] else ...[
                  // 새로고침(회전 아이콘+텍스트)
                  GestureDetector(
                    onTap: manualRefresh,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedRotation(
                          turns: isRotating ? 1 : 0,
                          duration: Duration(milliseconds: 700),
                          child: Icon(Icons.refresh, size: 32),
                        ),
                        SizedBox(width: 8),
                        Text(
                          "새로고침",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  QrImageView(
                    data: qrData,
                    size: 220,
                  ),
                  SizedBox(height: 12),
                  Text(
                    "1분마다 자동으로 새로고침됩니다.",
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
