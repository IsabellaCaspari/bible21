import 'dart:convert';
import 'dart:ui';

import 'package:die_bibel21/page/welcome.dart';
import 'package:die_bibel21/widgets/customdrawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'data/const.dart';
import 'data/sharedpreferences.dart';
import 'model/bibleplan.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BIBEL 21',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: _isFirstAppStart(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return WelcomePage();
          } else if (snapshot.hasData) {
            return MyHomePage(title: snapshot.data);
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Future<String> _isFirstAppStart() async {
    return await SharedPref().read("bibleplan");
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  List<Passage> _selectedBibleDay;
  BiblePlan _plan;
  AnimationController _animationController;
  CalendarController _calendarController;
  Map<DateTime, List<Passage>> _passagesMap;
  Map<DateTime, List> _mapBibleDays;
  Future myFuture;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    myFuture = fetchData();
    _animationController.forward();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _savePlan();
  }

  Future<BiblePlan> fetchData() async {
    try {
      var bibleplan = BiblePlan.fromJson(await SharedPref().read(widget.title));
      if (bibleplan != null) {
        return bibleplan;
      } else {
        return fetchDataFromFile();
      }
    } catch (Excepetion) {
      print("THROW ERRROR " + Excepetion.toString());
      return fetchDataFromFile();
    }
  }

  Future<BiblePlan> fetchDataFromFile() async {
    var path = "assets/bibleplan1.json";

    if (widget.title == Constants.BIBLE_PLAN_1) {
      path = "assets/bibleplan1.json";
    } else if (widget.title == Constants.BIBLE_PLAN_2) {
      path = "assets/bibleplan2.json";
    } else if (widget.title == Constants.BIBLE_PLAN_3) {
      path = "assets/bibleplan3.json";
    }

    String data = await DefaultAssetBundle.of(context).loadString(path);
    var parsedJson = json.decode(data);
    return BiblePlan.fromJson(parsedJson);
  }

  _savePlan() async {
    await SharedPref().save(widget.title, _plan);
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    setState(() {
      _selectedBibleDay = getBibleDay(day);
    });
  }

  List<Passage> getBibleDay(DateTime day) {
    var dateString = DateFormat('yyyy-MM-dd').format(day);
    var list = _plan?.passages
        ?.where((passage) =>
            passage?.date.toString().substring(0, 10) == dateString)
        ?.toList();
    return list;
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    setState(() {
      _selectedBibleDay = new List();
    });
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: CustomDrawer(title: widget.title, plan: _plan,),
      ),
      body: FutureBuilder(
        future: myFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    _buildTableCalendar(snapshot.data),
                    const SizedBox(height: 8.0),
                    Expanded(child: _buildEventList())
                  ],
                )
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildTableCalendar(BiblePlan biblePlan) {
    _plan = biblePlan;
    _passagesMap = _createMap();
    _mapBibleDays = _createMapBibleDays();

    return TableCalendar(
      locale: 'de_DE',
      calendarController: _calendarController,
      events: _mapBibleDays,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        weekendStyle: TextStyle().copyWith(color: Colors.blue[800]),
        selectedColor: Colors.greenAccent,
        todayColor: Colors.blue,
        markersColor: Colors.grey,
        outsideDaysVisible: false,
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: Colors.blue[600]),
      ),
      availableCalendarFormats: const {
        CalendarFormat.month: 'Monat',
        CalendarFormat.week: 'Woche'
      },
      headerStyle: HeaderStyle(
        formatButtonTextStyle:
            TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.greenAccent,
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
      builders: CalendarBuilders(
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];
          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }

          return children;
        },
      ),
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _isSthToRead(date) ? Colors.blue[400] : Color(0x00000000),
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          _getUnreadPassages(date),
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildEventList() {
    if (_selectedBibleDay == null) {
      return Container();
    }
    return ListView.builder(
      itemCount: _selectedBibleDay?.length,
      itemBuilder: (BuildContext context, int index) {
        Passage passage = _selectedBibleDay.elementAt(index);
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Column(children: [
            CheckboxListTile(
                secondary: IconButton(
                  onPressed: () => _openBrowserIntent(passage.chapter),
                  icon: Icon(Icons.article_outlined, color: _getColor()),
                ),
                title: Text(passage.chapter),
                value: passage.read,
                onChanged: (bool value) {
                  setState(() {
                    passage.read = value;
                    _setValue(passage.date, passage.chapter, value);
                  });
                }),
          ]),
        );
      },
    );
  }

  _getColor() {
    if (widget.title == Constants.BIBLE_PLAN_3) {
      return Colors.grey;
    } else {
      return Colors.blue;
    }
  }

  _openBrowserIntent(String chapter) async {
    if (widget.title != Constants.BIBLE_PLAN_3) {
      var translation = "NLB";
      try {
        translation = await _getTranslation() ?? "NLB";
      } catch (exception) {
        print("no translation set");
      }

      final url = Uri.encodeFull(
          "https://bibelserver.com/" + translation + "/" + chapter);
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  Future<String> _getTranslation() async {
    return await SharedPref().read("translation");
  }

  bool _isSthToRead(DateTime dateTime) {
    var bibleDay = _passagesMap[dateTime];
    return bibleDay != null &&
        bibleDay.where((passage) => passage.read == false).length != 0;
  }

  String _getUnreadPassages(DateTime dateTime) {
    var bibleDay = _passagesMap[dateTime];
    var count = 0;
    count = bibleDay.where((passage) => passage.read == false).length;

    if (count == 1) {
      return "";
    }
    return count.toString();
  }

  _createMapBibleDays() {
    if (_mapBibleDays == null) {
      Map<DateTime, List> mapBibleDays = new Map<DateTime, List>();
      _plan.passages.map((e) => e.date).toList().forEach((date) {
        mapBibleDays[date] = _getChapters(date);
      });
      return mapBibleDays;
    } else {
      return _mapBibleDays;
    }
  }

  List<String> _getChapters(DateTime date) {
    return _passagesMap[date].map((passages) => passages.chapter).toList();
  }

  _setValue(DateTime dateTime, String chapter, bool value) {
    _passagesMap[dateTime]
        ?.firstWhere((element) => element.chapter == chapter,
            orElse: () => null)
        ?.read = value;
  }

  _createMap() {
    if (_passagesMap == null) {
      Map<DateTime, List<Passage>> mapBibleDays =
          new Map<DateTime, List<Passage>>();
      _plan.passages.map((passage) => passage.date).toList().forEach((date) {
        mapBibleDays[date] = getBibleDay(date);
      });
      return mapBibleDays;
    } else {
      return _passagesMap;
    }
  }
}
