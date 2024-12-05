import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class CameraApp extends StatefulWidget {
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  late final RTCVideoRenderer _localRenderer;
  MediaStream? _localStream;
  bool isFrontCamera = true; // 前面カメラがデフォルト

  @override
  void initState() {
    super.initState();
    _localRenderer = RTCVideoRenderer();
    _localRenderer.initialize();
    _startCamera();
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _localStream?.dispose();
    super.dispose();
  }


Future<void> _startCamera() async {
  // 現在のストリームを停止
  await _localStream?.dispose();

  // カメラ設定
  final Map<String, dynamic> constraints = {
    'audio': false, // 音声は取得しない
    'video': {
      'facingMode': isFrontCamera ? 'user' : 'environment', // 前面または背面カメラ
      'width': 1920, // 解像度（幅）
      'height': 1080, // 解像度（高さ）
      'frameRate': 30, // フレームレート
    },
  };

  try {
    // 新しいストリームを取得
    MediaStream stream = await navigator.mediaDevices.getUserMedia(constraints);
    setState(() {
      _localStream = stream;
      _localRenderer.srcObject = stream;
    });
  } catch (e) {
    print('カメラ映像の取得に失敗しました: $e');
  }
}

void _toggleCamera() {
  setState(() {
    isFrontCamera = !isFrontCamera; // カメラの向きを切り替える
  });
  _startCamera(); // 新しい設定でカメラを再起動
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('カメラ映像取得'),
      ),
      body: Column(
        children: [
          Expanded(
            child: RTCVideoView(
              _localRenderer,
              objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
            ),
          ),
          ElevatedButton(
            onPressed: _toggleCamera,
            child: const Text('カメラ切り替え'),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CameraApp(),
    debugShowCheckedModeBanner: false,
  ));
}





















