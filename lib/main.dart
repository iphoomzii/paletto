import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

//button object
class ButtonObject {
  late int pos;
  int state = 0;

  //click and unclick
  void onClick(State) {
    if (state == 0) {
      //show highlight
      state = 1;
    } else {
      //unshow highlight
      state = 0;
    }
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paletto',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MyHomePage(title: 'Paletto'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  final _isHours = true;

  void dispose() {
    super.dispose();
    _stopWatchTimer.dispose();
  }

  List<List> goal = [
    [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
    [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 1],
    [3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 1, 2],
    [4, 5, 6, 7, 8, 9, 10, 11, 12, 1, 2, 3],
    [5, 6, 7, 8, 9, 10, 11, 12, 1, 2, 3, 4],
    [6, 7, 8, 9, 10, 11, 12, 1, 2, 3, 4, 5],
    [7, 8, 9, 10, 11, 12, 1, 2, 3, 4, 5, 6],
    [8, 9, 10, 11, 12, 1, 2, 3, 4, 5, 6, 7],
    [9, 10, 11, 12, 1, 2, 3, 4, 5, 6, 7, 8],
    [10, 11, 12, 1, 2, 3, 4, 5, 6, 7, 8, 9],
    [11, 12, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
    [12, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11],
  ];
  List<dynamic> data = [
    [Color.fromARGB(255, 255, 0, 0), 1],
    [Color.fromARGB(255, 255, 74, 0), 2],
    [Color.fromARGB(255, 255, 170, 0), 3],
    [Color.fromARGB(255, 255, 211, 0), 4],
    [Color.fromARGB(255, 191, 191, 48), 5],
    [Color.fromARGB(255, 159, 238, 0), 6],
    [Color.fromARGB(255, 0, 204, 0), 7],
    [Color.fromARGB(255, 0, 153, 153), 8],
    [Color.fromARGB(255, 18, 64, 171), 9],
    [Color.fromARGB(255, 57, 20, 175), 10],
    [Color.fromARGB(255, 113, 9, 170), 11],
    [Color.fromARGB(255, 205, 0, 116), 12],
  ];

  bool check(data) {
    //collect current position
    bool check = true;
    List<int> pos = [];
    for (int i = 0; i < 12; i++) {
      pos.add(data[i][1]);
    }
    print(pos);
    //check that current condition is member of goal
    //if(pos == goal[i]); check=true; break
    int start = pos[0];
    List currentGoal = goal[start-1];
    for(int i=0; i<12; i++){
      if(pos[i] != currentGoal[i]){
        check = false;
        break;
      }
    }
    print(check);

    return check;
  }

  @override
  void initState() {
    super.initState();
    data.shuffle();
  }

  void swapLeft(int pos, List data) {
    var temp = data[pos];
    if (pos - 2 < 0) {
      data[pos] = data[pos - 2 + 12];
      data[pos - 2 + 12] = temp;
    } else {
      data[pos] = data[pos - 2];
      data[pos - 2] = temp;
    }
  }

  void swapRight(int pos, List data) {
    var temp = data[pos];
    if (pos + 3 < 12) {
      data[pos] = data[pos + 3];
      data[pos + 3] = temp;
    } else {
      data[pos] = data[pos + 3 - 12];
      data[pos + 3 - 12] = temp;
    }
  }

  void moving(pos) {
    int right_pos = pos + 3;
    int left_pos = pos - 2;
    if (right_pos > 11) {
      right_pos = right_pos - 12;
    }
    if (left_pos < 0) {
      left_pos = left_pos + 12;
    }

    List<int> normal = [0, 1, 2, 3, 4, 11];

    if (normal.contains(pos)) {
      showDialog(
          context: context,
          builder: (BuildContext context) => Container(
                width: 160,
                child: AlertDialog(
                  title: Center(
                      child: const Text(
                    "เลือกตัวที่จะสลับ",
                  )),
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              setState(() {
                                swapLeft(pos, data);
                                if (check(data)) {
                                  print("Well Done!");
                                  _stopWatchTimer.onExecute
                                      .add(StopWatchExecute.stop);
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                              title: Center(
                                                child: const Text(
                                                    'คุณทำสำเร็จ !',
                                                    style: TextStyle(
                                                        fontSize: 40)),
                                              ),
                                              content: Row(
                                                children: [
                                                  Text('คุณใช้เวลา'),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.all(20.0),
                                                    child: StreamBuilder<int>(
                                                        stream: _stopWatchTimer
                                                            .rawTime,
                                                        initialData:
                                                            _stopWatchTimer
                                                                .rawTime.value,
                                                        builder: (context,
                                                            snapshot) {
                                                          final value =
                                                              snapshot.data;
                                                          final displayTime =
                                                              StopWatchTimer
                                                                  .getDisplayTime(
                                                                      value!,
                                                                      hours:
                                                                          _isHours);
                                                          return Text(
                                                            displayTime,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          );
                                                        }),
                                                  )
                                                ],
                                              )));
                                } else {
                                  print("try again !");
                                }
                              });
                            },
                            child: Text(
                              data[left_pos][1].toString(),
                              style: TextStyle(
                                  fontSize: 8, color: Colors.orange[50]),
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              primary: data[left_pos][0],
                            )),
                      ),
                      Container(
                        height: 40,
                        width: 40,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              setState(() {
                                swapRight(pos, data);
                                if (check(data)) {
                                  print("Well Done!");
                                  _stopWatchTimer.onExecute
                                      .add(StopWatchExecute.stop);
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                              title: Center(
                                                child: const Text(
                                                    'คุณทำสำเร็จ !',
                                                    style: TextStyle(
                                                        fontSize: 40)),
                                              ),
                                              content: Row(
                                                children: [
                                                  Text('คุณใช้เวลา'),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.all(20.0),
                                                    child: StreamBuilder<int>(
                                                        stream: _stopWatchTimer
                                                            .rawTime,
                                                        initialData:
                                                            _stopWatchTimer
                                                                .rawTime.value,
                                                        builder: (context,
                                                            snapshot) {
                                                          final value =
                                                              snapshot.data;
                                                          final displayTime =
                                                              StopWatchTimer
                                                                  .getDisplayTime(
                                                                      value!,
                                                                      hours:
                                                                          _isHours);
                                                          return Text(
                                                            displayTime,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          );
                                                        }),
                                                  )
                                                ],
                                              )));
                                } else {
                                  print("try again !");
                                }
                              });
                            },
                            child: Text(
                              data[right_pos][1].toString(),
                              style: TextStyle(
                                  fontSize: 8, color: Colors.orange[50]),
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              primary: data[right_pos][0],
                            )),
                      ),
                    ],
                  ),
                ),
              ));
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) => Container(
                width: 160,
                child: AlertDialog(
                  title: Center(
                      child: const Text(
                    "เลือกตัวที่จะสลับ",
                  )),
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              setState(() {
                                swapRight(pos, data);
                                if (check(data)) {
                                  print("Well Done!");
                                  _stopWatchTimer.onExecute
                                      .add(StopWatchExecute.stop);
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                              title: Center(
                                                child: const Text(
                                                    'คุณทำสำเร็จ !',
                                                    style: TextStyle(
                                                        fontSize: 40)),
                                              ),
                                              content: Row(
                                                children: [
                                                  Text('คุณใช้เวลา'),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.all(20.0),
                                                    child: StreamBuilder<int>(
                                                        stream: _stopWatchTimer
                                                            .rawTime,
                                                        initialData:
                                                            _stopWatchTimer
                                                                .rawTime.value,
                                                        builder: (context,
                                                            snapshot) {
                                                          final value =
                                                              snapshot.data;
                                                          final displayTime =
                                                              StopWatchTimer
                                                                  .getDisplayTime(
                                                                      value!,
                                                                      hours:
                                                                          _isHours);
                                                          return Text(
                                                            displayTime,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          );
                                                        }),
                                                  )
                                                ],
                                              )));
                                } else {
                                  print("try again !");
                                }
                              });
                            },
                            child: Text(
                              data[right_pos][1].toString(),
                              style: TextStyle(
                                  fontSize: 8, color: Colors.orange[50]),
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              primary: data[right_pos][0],
                            )),
                      ),
                      Container(
                        height: 40,
                        width: 40,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              setState(() {
                                swapLeft(pos, data);
                                if (check(data)) {
                                  print("Well Done!");
                                  _stopWatchTimer.onExecute
                                      .add(StopWatchExecute.stop);
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                              title: Center(
                                                child: const Text(
                                                    'คุณทำสำเร็จ !',
                                                    style: TextStyle(
                                                        fontSize: 40)),
                                              ),
                                              content: Row(
                                                children: [
                                                  Text('คุณใช้เวลา'),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.all(20.0),
                                                    child: StreamBuilder<int>(
                                                        stream: _stopWatchTimer
                                                            .rawTime,
                                                        initialData:
                                                            _stopWatchTimer
                                                                .rawTime.value,
                                                        builder: (context,
                                                            snapshot) {
                                                          final value =
                                                              snapshot.data;
                                                          final displayTime =
                                                              StopWatchTimer
                                                                  .getDisplayTime(
                                                                      value!,
                                                                      hours:
                                                                          _isHours);
                                                          return Text(
                                                            displayTime,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          );
                                                        }),
                                                  )
                                                ],
                                              )));
                                } else {
                                  print("try again !");
                                }
                              });
                            },
                            child: Text(
                              data[left_pos][1].toString(),
                              style: TextStyle(
                                  fontSize: 8, color: Colors.orange[50]),
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              primary: data[left_pos][0],
                            )),
                      ),
                    ],
                  ),
                ),
              ));
    }
  }

  @override
  //แสดงผลข้อมูล
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
          "Paletto",
          style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
        )),
      ),
      // ignore: avoid_unnecessary_containers
      body: Container(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          // ignore: prefer_const_constructors
          children: [
            // ignore: prefer_const_constructors
            Text(
              "กรุณาจัดเรียงสี",
              style: const TextStyle(fontSize: 35),
            ),
            // ignore: avoid_unnecessary_containers
            //row1
            Container(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //plate
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            _stopWatchTimer.onExecute
                                .add(StopWatchExecute.start);
                            moving(0);
                          },
                          child: Text(
                            data[0][1].toString(),
                            style: TextStyle(
                                fontSize: 15, color: Colors.orange[50]),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            primary: data[0][0],
                          )),
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            _stopWatchTimer.onExecute
                                .add(StopWatchExecute.start);
                            moving(1);
                          },
                          child: Text(
                            data[1][1].toString(),
                            style: TextStyle(
                                fontSize: 15, color: Colors.orange[50]),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            primary: data[1][0],
                          )),
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            _stopWatchTimer.onExecute
                                .add(StopWatchExecute.start);
                            moving(2);
                          },
                          child: Text(
                            data[2][1].toString(),
                            style: TextStyle(
                                fontSize: 15, color: Colors.orange[50]),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            primary: data[2][0],
                          )),
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            _stopWatchTimer.onExecute
                                .add(StopWatchExecute.start);
                            moving(3);
                          },
                          child: Text(
                            data[3][1].toString(),
                            style: TextStyle(
                                fontSize: 15, color: Colors.orange[50]),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            primary: data[3][0],
                          )),
                    ),
                  ],
                ),
              ),
            ),
            //row2
            Container(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //plate
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            _stopWatchTimer.onExecute
                                .add(StopWatchExecute.start);
                            moving(11);
                          },
                          child: Text(
                            data[11][1].toString(),
                            style: TextStyle(
                                fontSize: 15, color: Colors.orange[50]),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            primary: data[11][0],
                          )),
                    ),
                    Container(
                      height: 50,
                      width: 50,
                    ),
                    Container(
                      height: 50,
                      width: 50,
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            _stopWatchTimer.onExecute
                                .add(StopWatchExecute.start);
                            moving(4);
                          },
                          child: Text(
                            data[4][1].toString(),
                            style: TextStyle(
                                fontSize: 15, color: Colors.orange[50]),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            primary: data[4][0],
                          )),
                    ),
                  ],
                ),
              ),
            ),

            //row3
            Container(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //plate
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            _stopWatchTimer.onExecute
                                .add(StopWatchExecute.start);
                            moving(10);
                          },
                          child: Text(
                            data[10][1].toString(),
                            style: TextStyle(
                                fontSize: 15, color: Colors.orange[50]),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            primary: data[10][0],
                          )),
                    ),
                    Container(
                      height: 50,
                      width: 50,
                    ),
                    Container(
                      height: 50,
                      width: 50,
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            _stopWatchTimer.onExecute
                                .add(StopWatchExecute.start);
                            moving(5);
                          },
                          child: Text(
                            data[5][1].toString(),
                            style: TextStyle(
                                fontSize: 15, color: Colors.orange[50]),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            primary: data[5][0],
                          )),
                    ),
                  ],
                ),
              ),
            ),

            //row4
            Container(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //plate
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            _stopWatchTimer.onExecute
                                .add(StopWatchExecute.start);
                            moving(9);
                          },
                          child: Text(
                            data[9][1].toString(),
                            style: TextStyle(
                                fontSize: 15, color: Colors.orange[50]),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            primary: data[9][0],
                          )),
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            _stopWatchTimer.onExecute
                                .add(StopWatchExecute.start);
                            moving(8);
                          },
                          child: Text(
                            data[8][1].toString(),
                            style: TextStyle(
                                fontSize: 15, color: Colors.orange[50]),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            primary: data[8][0],
                          )),
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            _stopWatchTimer.onExecute
                                .add(StopWatchExecute.start);
                            moving(7);
                          },
                          child: Text(
                            data[7][1].toString(),
                            style: TextStyle(
                                fontSize: 15, color: Colors.orange[50]),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            primary: data[7][0],
                          )),
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            _stopWatchTimer.onExecute
                                .add(StopWatchExecute.start);
                            moving(6);
                          },
                          child: Text(
                            data[6][1].toString(),
                            style: TextStyle(
                                fontSize: 15, color: Colors.orange[50]),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            primary: data[6][0],
                          )),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              child: StreamBuilder<int>(
                  stream: _stopWatchTimer.rawTime,
                  initialData: _stopWatchTimer.rawTime.value,
                  builder: (context, snapshot) {
                    final value = snapshot.data;
                    final displayTime =
                        StopWatchTimer.getDisplayTime(value!, hours: _isHours);
                    return Text(
                      displayTime,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }),
            )
          ],
        ),
      ),

      //footer
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Stack(
        fit: StackFit.expand,
        children: [
          //restart button
          Positioned(
            left: 20,
            bottom: 13,
            child: Container(
              height: 40.0,
              width: 40.0,
              child: FittedBox(
                child: FloatingActionButton(
                  elevation: 4.0,
                  onPressed: () {
                    setState(() {
                      data.shuffle();
                      _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
                    });
                  },
                  child: const Icon(
                    Icons.replay_rounded,
                    size: 40,
                  ),
                ),
              ),
            ),
          ),
          //tutorial button
          Positioned(
            right: 20,
            bottom: 13,
            child: Container(
              height: 40.0,
              width: 40.0,
              child: FittedBox(
                child: FloatingActionButton(
                  elevation: 4.0,
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                            title: Center(
                                child: const Text(
                              'วิธีการเล่น :',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 48),
                            )),
                            content: Container(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text('เป้าหมายเกม : '),
                                  Text(' '),
                                  Text(
                                      'เรียงลำดับเลข 1-12 โดยเรียงแบบตามเข็มนาฬิกา'),
                                  Text(' '),
                                  Text(' '),
                                  Text(' '),
                                  Text('การเล่นเกม :'),
                                  Text(' '),
                                  Text(
                                      'เลือกตำแหน่งเลขที่ต้องการสัลบ โดยเลือกสลับได้ 2 แบบ'),
                                  Text(
                                      '1) สลับตำแหน่งกับลำดับที่สาม ตามเข็มนาฬิกา'),
                                  Text(
                                      '2) สลับตำแหน่งกับลำดับที่สอง ทวนเข็มนาฬิกา'),
                                ],
                              ),
                            )));
                  },
                  child: const Icon(
                    Icons.info_outline,
                    size: 40,
                  ),
                ),
              ),
            ),
          ),
          // ignore: prefer_const_constructors
          Positioned(
              left: 65,
              bottom: 23,
              child: const Text(
                "เริ่มเกมใหม่",
                style: TextStyle(fontSize: 18),
              )),
          Positioned(
              right: 65,
              bottom: 23,
              child: const Text(
                "วิธีเล่น",
                style: TextStyle(fontSize: 18),
              )),
          /*
          Positioned(
              bottom: 0,
              child: const Text(
                "Made by justPhoom",
                style: TextStyle(fontSize: 8),
              )),
              */
          // Add more floating buttons if you want
          // There is no limit
        ],
      ),
    );
  }
}
