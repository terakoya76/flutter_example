import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  DateTime _dt = DateTime.now();

  XFile? _image;
  final imagePicker = ImagePicker();

  // カメラから画像を取得するメソッド
  Future getImageFromCamera() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = XFile(pickedFile.path);
      }
    });
  }

  // ギャラリーから画像を取得するメソッド
  Future getImageFromGarally() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = XFile(pickedFile.path);
      }
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: const [
          Icon(Icons.create),
          Text("初めてのタイトル"),
        ]),
      ),
      body: Column(children: [
        const Text("Hello"),
        Text(
          "$_counter",
          style: const TextStyle(fontSize: 20, color: Colors.red)
        ),
        TextButton(
          onPressed: _incrementCounter,
          child: const Text("Increment"),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Icon(
              Icons.favorite,
              color: Colors.pink,
              size: 24.0,
            ),
            Icon(
              Icons.audiotrack,
              color: Colors.green,
              size: 30.0,
            ),
            Icon(
              Icons.beach_access,
              color: Colors.blue,
              size: 36.0,
            ),
          ]
        ),
        IconButton(
          icon: const Icon(FontAwesomeIcons.gift, color: Colors.teal),
          onPressed: () async {
            String url = Uri.encodeFull("https://pub.dev/");
            if (await canLaunch(url)) {
              await launch(url);
            }
          }
        ),
        getNowLoading(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("$_dt"),
            IconButton(
              icon: const Icon(
                FontAwesomeIcons.calendarDays,
                color: Colors.black, size: 30.0,
              ),
              onPressed: () {
                DatePicker.showDatePicker(context,
                  showTitleActions: true,
                  minTime: DateTime(1900, 1, 1),
                  maxTime: DateTime(2049, 12, 31),
                  onConfirm: (date) {
                    setState(() {
                        _dt = date;
                    });
                  },
                  currentTime: _dt, locale: LocaleType.jp
                );
              },
            )
          ],
        ),
        Center(
            // 取得した画像を表示(ない場合はメッセージ)
            child: _image == null
                ? Text(
                    '写真を選択してください',
                    style: Theme.of(context).textTheme.headline4,
                  )
                : Image.file(File(_image!.path))),
      ]),
      floatingActionButton:
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        // カメラから取得するボタン
        FloatingActionButton(
            onPressed: getImageFromCamera,
            child: const Icon(Icons.photo_camera)),
        // ギャラリーから取得するボタン
        FloatingActionButton(
            onPressed: getImageFromGarally,
            child: const Icon(Icons.photo_album))
      ]),
      drawer: const Drawer(child: Center(child: Text("Drawer"))),
      endDrawer: const Drawer(child: Center(child: Text("EndDrawer"))),
    );
  }
}

Widget getNowLoading() {
  return Column(children: [
    Center(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        child: const SizedBox(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(
            strokeWidth: 10.0,
          )
        )
      )
    ),
  ]);
}
