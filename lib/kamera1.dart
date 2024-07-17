import 'dart:async';
import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Import untuk DateFormat

class YoloVideo extends StatefulWidget {
  const YoloVideo({Key? key}) : super(key: key);

  @override
  State<YoloVideo> createState() => _YoloVideoState();
}

class _YoloVideoState extends State<YoloVideo> {
  late CameraController controller;
  late FlutterVision vision;
  late List<Map<String, dynamic>> yoloResults;
  CameraImage? cameraImage;
  bool isLoaded = false;
  bool isDetecting = false;
  String selectedGender = 'Male';
  late List<CameraDescription> cameras;
  late CameraDescription selectedCamera;
  late String currentDateTime;

  @override
  void initState() {
    super.initState();
    currentDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    init();
    startDateTimeUpdater(); // Mulai memperbarui tanggal dan waktu
  }

  void startDateTimeUpdater() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        currentDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      });
    });
  }

  init() async {
    cameras = await availableCameras();
    selectedCamera = cameras.first;
    vision = FlutterVision();
    controller = CameraController(selectedCamera, ResolutionPreset.high);
    await controller.initialize();
    await loadYoloModel();
    setState(() {
      isLoaded = true;
      isDetecting = false;
      yoloResults = [];
    });
  }

  @override
  void dispose() {
    controller.dispose();
    vision.closeYoloModel();
    super.dispose();
  }

  Future<void> loadYoloModel() async {
    await vision.loadYoloModel(
      labels: 'assets/labels.txt',
      modelPath: 'assets/best_float32.tflite',
      modelVersion: "yolov8",
      numThreads: 1,
      useGpu: true,
    );
    setState(() {
      isLoaded = true;
    });
  }

  Future<void> yoloOnFrame(CameraImage cameraImage) async {
    print('yoloOnFrame called'); // Debugging
    final result = await vision.yoloOnFrame(
      bytesList: cameraImage.planes.map((plane) => plane.bytes).toList(),
      imageHeight: cameraImage.height,
      imageWidth: cameraImage.width,
      iouThreshold: 0.3,
      confThreshold: 0.3,
      classThreshold: 0.3,
    );
    print('yoloOnFrame result: $result');
    if (result.isNotEmpty) {
      setState(() {
        yoloResults = result;
      });
      for (final item in yoloResults) {
        final tag = item['tag'];
        final confidence = item['box'][4] * 100;
        print('Detected: $tag with confidence $confidence');
        await sendDataToAPI(tag, selectedGender);
      }
    }
  }

  Future<void> startDetection() async {
    setState(() {
      isDetecting = true;
    });
    if (controller.value.isStreamingImages) {
      return;
    }
    await controller.startImageStream((image) async {
      if (isDetecting) {
        cameraImage = image;
        await yoloOnFrame(image);
      }
    });
  }

  Future<void> stopDetection() async {
    setState(() {
      isDetecting = false;
      yoloResults.clear();
    });
  }

  Future<void> sendDataToAPI(String className, String gender) async {
    const url = 'http://192.168.182.251:5000/getmobile';
    try {
      final DateTime now = DateTime.now(); // Ambil tanggal dan waktu saat ini
      final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now); // Format tanggal sesuai kebutuhan

      final body = jsonEncode(<String, dynamic>{
        'class_name': className,
        'gender': gender,
        'detection_date': formattedDate, // Tambahkan detection_date ke data yang dikirim
      });
      print('Request Body: $body'); // Debugging
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: body,
      );

      print('Response status: ${response.statusCode}'); // Debugging
      print('Response body: ${response.body}'); // Debugging

      if (response.statusCode == 200) {
        print('Data berhasil terkirim');
      } else {
        print('Gagal mengirim data: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Exception occurred: $e');
    }
  }

  List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
    if (yoloResults.isEmpty) return [];
    double factorX = screen.width / (cameraImage?.height ?? 1);
    double factorY = screen.height / (cameraImage?.width ?? 1);

    Color colorPick = const Color.fromARGB(255, 50, 233, 30);

    return yoloResults.map((result) {
      double objectX = result["box"][0] * factorX;
      double objectY = result["box"][1] * factorY;
      double objectWidth = (result["box"][2] - result["box"][0]) * factorX;
      double objectHeight = (result["box"][3] - result["box"][1]) * factorY;

      return Positioned(
        left: objectX,
        top: objectY,
        width: objectWidth,
        height: objectHeight,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(color: Colors.pink, width: 2.0),
          ),
          child: Text(
            "${result['tag']} ${(result['box'][4] * 100).toStringAsFixed(2)}",
            style: TextStyle(
              background: Paint()..color = colorPick,
              color: const Color.fromARGB(255, 115, 0, 255),
              fontSize: 18.0,
            ),
          ),
        ),
      );
    }).toList();
  }

  void toggleCamera() async {
    final CameraDescription newCamera = (selectedCamera == cameras.first) ? cameras.last : cameras.first;
    setState(() {
      selectedCamera = newCamera;
      isLoaded = false;
    });
    await controller.dispose();
    controller = CameraController(selectedCamera, ResolutionPreset.high);
    await controller.initialize();
    setState(() {
      isLoaded = true;
    });
    if (isDetecting) {
      startDetection();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    if (!isLoaded) {
      return Scaffold(
        body: Center(
          child: Text("Model not loaded, waiting for it"),
        ),
      );
    }
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: CameraPreview(
              controller,
            ),
          ),
          ...displayBoxesAroundRecognizedObjects(size),
          Positioned(
            top: 20, // Ubah posisi sesuai kebutuhan
            left: 20,
            child: Text(
              currentDateTime, // Tampilkan tanggal dan waktu saat ini
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            bottom: 150,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Text('Pilih Jenis Kelamin:'),
                DropdownButton<String>(
                  value: selectedGender,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedGender = newValue!;
                    });
                  },
                  items: <String>[
                    'Male',
                    'Female',
                    'Other',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 75,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        width: 5, color: Colors.white, style: BorderStyle.solid),
                  ),
                  child: isDetecting
                      ? IconButton(
                          onPressed: () async {
                            await stopDetection();
                          },
                          icon: const Icon(
                            Icons.stop,
                            color: Colors.red,
                          ),
                          iconSize: 50,
                        )
                      : IconButton(
                          onPressed: () async {
                            await startDetection();
                          },
                          icon: const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                          ),
                          iconSize: 50,
                        ),
                ),
                SizedBox(width: 20),
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        width: 5, color: Colors.white, style: BorderStyle.solid),
                  ),
                  child: IconButton(
                    onPressed: () async {
                      toggleCamera();
                    },
                    icon: const Icon(
                      Icons.switch_camera,
                      color: Colors.white,
                    ),
                    iconSize: 50,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
