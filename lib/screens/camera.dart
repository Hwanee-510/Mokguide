import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'firebase_options.dart';

List<CameraDescription>? cameras;

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _controller;
  late Future<void> _initializeControllerFuture;
  File? _imageFile;
  bool _isUploading = false;
  String? _uploadedUrl;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  void _initializeCamera() async {
    // 카메라 목록을 받아옵니다
    cameras = await availableCameras();
    _controller = CameraController(cameras![0], ResolutionPreset.high);
    _initializeControllerFuture = _controller!.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final dir = await getTemporaryDirectory();
      final now = DateTime.now();
      final formatted = '${now.year}${now.month}${now.day}_${now.hour}${now.minute}${now.second}';
      final filePath = join(dir.path, 'photo_$formatted.png');
      final xFile = await _controller!.takePicture();
      await xFile.saveTo(filePath);
      
      setState(() {
        _imageFile = File(filePath);
      });

      // 사진 촬영 후, 업로드 기능을 호출합니다.
      _uploadImage();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile != null) {
      setState(() => _isUploading = true);
      try {
        final now = DateTime.now();
        final fileName = 'photo_${now.year}${now.month}${now.day}_${now.hour}${now.minute}${now.second}.png';
        final ref = FirebaseStorage.instance.ref().child('photos/$fileName');
        await ref.putFile(_imageFile!);
        
        final url = await ref.getDownloadURL();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('업로드 완료!')),
        );

        setState(() {
          _uploadedUrl = url; // 업로드된 URL 저장
          _imageFile = null; // 사진은 초기화
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('업로드 실패: $e')),
        );
      } finally {
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: Text('자리 촬영')),
      body: Center(
        child: _imageFile == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CameraPreview(_controller!),
                  ElevatedButton(
                    onPressed: _takePicture,
                    child: Text('사진 촬영'),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.file(_imageFile!),
                  SizedBox(height: 16),
                  if (_isUploading) CircularProgressIndicator(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _takePicture, // 재촬영
                        child: Text('재촬영'),
                      ),
                      SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: _isUploading ? null : _uploadImage,
                        child: Text('업로드'),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
