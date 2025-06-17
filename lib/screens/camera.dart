import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CameraPage extends StatefulWidget {
  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  File? _imageFile;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
      await _uploadImage();
    } else {
      // 사진을 안 찍고 나갔을 때도 반납 처리 (원하면 false로 pop)
      Navigator.pop(context, true);
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile != null) {
      setState(() => _isUploading = true);
      bool success = false;
      try {
        final now = DateTime.now();
        final fileName = 'photo_${now.year}${now.month}${now.day}_${now.hour}${now.minute}${now.second}.png';
        final ref = FirebaseStorage.instance.ref().child('photos/$fileName');
        await ref.putFile(_imageFile!);
        success = true;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('업로드 완료! 반납이 처리됩니다.')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('업로드 실패! 그래도 반납이 처리됩니다.')),
        );
      } finally {
        setState(() => _isUploading = false);
        // 업로드 성공/실패 상관없이 무조건 반납 처리
        Navigator.pop(context, true);
      }
    } else {
      // 파일 없음 - 그래도 반납 처리
      Navigator.pop(context, true);
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, _pickImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('자리 촬영')),
      body: Center(
        child: _isUploading
            ? CircularProgressIndicator()
            : (_imageFile == null)
                ? Text('사진을 촬영 중입니다...')
                : Image.file(_imageFile!),
      ),
    );
  }
}
