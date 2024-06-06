import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late CameraController cameraController;
  bool _cameraInitialized = false;
  bool _streamImages = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    cameraController =
        CameraController(firstCamera, ResolutionPreset.ultraHigh);
    await cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _cameraInitialized = true;
      });
    });
  }

  Future<void> _toggleStream() async {
    if (cameraController.value.isStreamingImages) {
      cameraController.stopImageStream();
    } else {
      if (!cameraController.value.isStreamingImages) {
        cameraController.startImageStream((image) {
          // Process the image here
          // Right now we are doing nothing just to show the example
        });
      }
    }
    setState(() {
      _streamImages = !_streamImages;
    });
  }

  Future<void> _disposeCamera() async {
    cameraController.dispose();
    setState(() {
      _cameraInitialized = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () =>
                      _cameraInitialized ? _disposeCamera() : initCamera(),
                  child: Text(
                      _cameraInitialized ? "Dispose Camera" : "Init Camera")),
              _cameraInitialized
                  ? ElevatedButton(
                      onPressed: () => _toggleStream(),
                      child:
                          Text(_streamImages ? "Stop stream" : "Start stream"))
                  : const CircularProgressIndicator(),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}
