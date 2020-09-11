import 'dart:async';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
void main(){
  runApp(
    myApp()
  );
}

class myApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TIME',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
  TabController _tabController;
  int hour =0;
  int min =0;
  int sec =0;
  bool started = true;
  bool stopped = true;
  int timefortimer = 0;
  String timetodisplay = '';
  bool checktimer = true;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  void Start(){
    setState(() {
      started = false;
      stopped = false;
    });
    timefortimer = (hour*60*60) + (min *60) + (sec);
    Timer.periodic( Duration(seconds: 1) , (Timer t) {
      setState(() {
        if(timefortimer < 1 || checktimer == false){t.cancel();

        timetodisplay = '';
        started = true;
        stopped = true;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));

        }else if(timefortimer < 60) {
          timetodisplay = timefortimer.toString().padLeft(2,'0');
          timefortimer -= 1;
        }else if(timefortimer < 3600){
          int m = timefortimer ~/ 60;
          int s = timefortimer - (60*m);
          timetodisplay = m.toString().padLeft(2,'0') + ':' + s.toString().padLeft(2,'0');
          timefortimer -=1;
        }else{
          int h = timefortimer ~/ 3600;
          int t = timefortimer - (3600*h);
          int m = t ~/ 60;
          int s = t - (60*m);
          timetodisplay = h.toString().padLeft(2,'0') + ":" + m.toString().padLeft(2,'0') + ":" + s.toString().padLeft(2,'0');
          timefortimer-=1;
        }
        });
    });
  }

  void Stop(){
    setState(() {
      started =true;
      stopped = true;
      checktimer = false;
    });

  }

  Widget timer(){
    return Container(

      child: Column(
        children: [
          Expanded(child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(padding: EdgeInsets.only(bottom: 10.0),
                  child: Text('HH',style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18.0
                  ),
                  ),

                  ),
                  NumberPicker.integer(initialValue: hour, minValue: 0, maxValue: 23, onChanged:(val){
                    setState(() {
                      hour = val;
                    });
                  }),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(padding: EdgeInsets.only(bottom: 10.0),
                    child: Text('MM',style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18.0
                    ),),
                  ),
                  NumberPicker.integer(initialValue: min, minValue: 0, maxValue: 59, onChanged:(val){
                    setState(() {
                      min = val;
                    });
                  }),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(padding: EdgeInsets.only(bottom: 10.0),
                    child: Text('SS',style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18.0
                    ),),
                  ),
                  NumberPicker.integer(initialValue: sec, minValue: 0, maxValue: 59, onChanged:(val){
                    setState(() {
                      sec = val;
                    });
                  }),
                ],
              )
            ],
          ) ,
          flex: 6,
          ),
          Expanded(flex: 1,
              child: Text(
                timetodisplay ,style: TextStyle(
                fontSize: 35.0,
                fontWeight: FontWeight.w600
              ),
              ),
          ),
          Expanded(child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RaisedButton(onPressed: started ? Start : null,
                color: Colors.green,
              child: Text('START',style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
              ),
                padding: EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: 10.0
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              RaisedButton(onPressed: stopped ? null : Stop,
                color: Colors.red,
                child: Text('STOP',style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                ),
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 10.0
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ],
          ),
          flex: 3,
          ),
        ],
      ),
    );
  }

  bool startispressed = true;
  bool stopispressed = true;
  bool resetispressed = true;
  String stopwatchtimetodisplay = '00:00:00';
  Stopwatch swatch = Stopwatch();
  final duration = const Duration(seconds: 1);
  
  void Starttimer(){
    Timer(duration, Keeprunning);
  }

  void Keeprunning(){
    if(swatch.isRunning){
      Starttimer();
    }
    setState(() {
      stopwatchtimetodisplay= swatch.elapsed.inHours.toString().padLeft(2,'0') + ":" + (swatch.elapsed.inMinutes%60).toString().padLeft(2,'0') + ':' + (swatch.elapsed.inSeconds%60).toString().padLeft(2,'0');
    });

  }

  void Startstopwatch(){
    setState(() {
      stopispressed = false;
      startispressed = false;
    });
    swatch.start();
    Starttimer();

  }

  void Stopstopwatch(){
    setState(() {
      stopispressed = true;
      resetispressed =false;
    });
    swatch.stop();
  }

  void Resetstopwatch(){
    setState(() {
      startispressed = true;
      resetispressed = true;
    });
    swatch.reset();
    stopwatchtimetodisplay = '00:00:00';
  }

  Widget stopwatch(){
    return Container(
      child: Column(

        children: [
          Expanded(child: Container(
            alignment: Alignment.center,
            child: Text(stopwatchtimetodisplay,style: TextStyle(
              fontSize: 50.0,
              fontWeight: FontWeight.w700,

            ),),
          ) ,
            flex: 6,),
          Expanded(child: Container(
            child: Column(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly ,
                  children: [
                    RaisedButton(onPressed: stopispressed ? null : Stopstopwatch,
                      padding: EdgeInsets.symmetric(
                        horizontal: 40.0,
                        vertical: 15.0
                      ),
                      child: Text('STOP',style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),),
                      color: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),

                    ),
                    RaisedButton(onPressed: resetispressed ? null : Resetstopwatch,
                      padding: EdgeInsets.symmetric(
                          horizontal: 40.0,
                          vertical: 15.0
                      ),
                      child: Text('RESET',style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),),
                      color: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),

                    ),
                  ],
                ),
                RaisedButton(onPressed: startispressed ? Startstopwatch : null,
                  padding: EdgeInsets.symmetric(
                      horizontal: 80.0,
                      vertical: 20.0
                  ),
                  child: Text('START',style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),),
                  color: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35.0),
                  ),

                ),
              ],
            ),
          ),
            flex: 4,),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('STOP WATCH'),
        leading: Icon(Icons.timer,color: Colors.white,size: 40.0,),
        bottom: TabBar(
            tabs: [
              Text('TIMER'),
              Text('STOP WATCH'),
            ] ,
          labelPadding: EdgeInsets.only(bottom: 10.0),
          labelStyle: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelColor: Colors.white30,
          controller: _tabController,
        ),
      ),
    body: TabBarView(children: [
        timer(),
      stopwatch(),
    ],
      controller: _tabController,
    ),
    );
  }
}
