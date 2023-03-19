import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String page = "";

  //注册MethodChannel并指定名称one
  final MethodChannel _oneMethodChannel = const MethodChannel("one");
  //注册MethodChannel并指定名称two
  final MethodChannel _twoMethodChannel = const MethodChannel("two");

  final BasicMessageChannel _basicMessageChannel = const BasicMessageChannel("basicMessageChannel",
      StandardMessageCodec());
  
  final EventChannel _eventChannel = EventChannel("eventChannel");

  @override
  void initState() {
    super.initState();

    //监听OC调用Flutter传递来的参数
    _oneMethodChannel.setMethodCallHandler((call) {
      setState(() {
        page = call.method;
      });
      return Future(() => {});
    });

    _twoMethodChannel.setMethodCallHandler((call) {
      setState(() {
        page = call.method;
      });
      return Future(() => {});
    });

    _basicMessageChannel.setMessageHandler((message) {
      print("收到iOS发送的消息 - $message");
      return Future(() => {});
    });

    _eventChannel.receiveBroadcastStream().listen((event) {
      print("消息内容: $event, Flutter收到消息数据类型: ${event.runtimeType}");
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: selectPage(page),
    );
  }

  Widget? selectPage(String page) {
    //此处可以根据不同的page创建不同的页面
    if (page == "one_title") {
      return Scaffold(
        appBar: AppBar(
            title: Text(page)
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                print("one_title被点击");
                if (page == "one_title") {
                  _oneMethodChannel.invokeMapMethod("back");
                }else {
                  _twoMethodChannel.invokeMapMethod("back");
                }
              },
              child: Text(page),
            ),
            TextField(
              onChanged: (str) {
                _basicMessageChannel.send(str);
              },
            )
          ],
        ),
      );
    }else {
      return Scaffold(
        appBar: AppBar(
            title: Text(page)
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                print("two_title被点击");
                if (page == "one_title") {
                  _oneMethodChannel.invokeMapMethod("back");
                }else {
                  _twoMethodChannel.invokeMapMethod("back");
                }
              },
              child: Text(page),
            )
          ],
        ),
      );
    }

  }
}



