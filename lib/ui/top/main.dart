import 'dart:math';

import 'package:calendar/util/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../model.dart';
import '../../repo/model/model.dart';
import '../view/calendar_carousel_view.dart';
import '../settings/main.dart';
import 'model.dart';

const _kTitleTextSize = 18.0;
const _kCalendarTitleHeight = 30.0;

class CalendarPage extends StatefulWidget {
  @override
  CalendarPageState createState() => CalendarPageState();
}

class CalendarPageState extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) => Provider<CalendarModel>(
        builder: (_) => CalendarModel(
            Provider.of<AppModel>(context).databaseRepository,
            Provider.of<AppModel>(context).preferenceRepository),
        dispose: (_, model) => model.dispose(),
        child: Builder(
          builder: (context) => _build(context),
        ),
      );

  Widget _build(BuildContext context) => Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.transparent,
        //   title: Text(Provider.of<AppModel>(context).packageInfo.appName),
        // ),
        body: SafeArea(
          child: _buildBody(context),
        ),
        bottomNavigationBar: StreamBuilder<int>(
          initialData:
              Provider.of<AppModel>(context).preferenceRepository.lastPalette,
          stream: Provider.of<CalendarModel>(context).navigation,
          builder: (context, snapshot) => BottomNavigationBar(
            backgroundColor: Provider.of<AppModel>(context)
                .preferenceRepository
                .colorBackground,
            currentIndex: snapshot.data,
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/icon.svg',
                  color: snapshot.data == 0
                      ? Theme.of(context).accentColor
                      : Theme.of(context).disabledColor,
                ),
                title: Text('icons'),
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/palette.svg',
                  color: snapshot.data == 1
                      ? Theme.of(context).accentColor
                      : Theme.of(context).disabledColor,
                ),
                title: Text('colors'),
              ),
            ],
            onTap: (position) {
              Provider.of<CalendarModel>(context)
                  .post(UpdateNavigationEvent(position));
            },
          ),
        ),
      );

  Widget _buildBody(BuildContext context) => Container(
        color:
            Provider.of<AppModel>(context).preferenceRepository.colorBackground,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Expanded(
                    child: _buildCalendar(context),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: StreamBuilder<int>(
                      initialData: Provider.of<AppModel>(context)
                          .preferenceRepository
                          .lastPalette,
                      stream: Provider.of<CalendarModel>(context).palette,
                      builder: (context, snapshot) =>
                          _buildPalette(snapshot.data),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.topRight,
                child: _buildSetting(context),
              )
            ],
          ),
        ),
      );

  Widget _buildSetting(BuildContext context) => SizedBox(
        height: _kCalendarTitleHeight,
        child: IconButton(
          padding: EdgeInsets.all(0),
          icon: Icon(Icons.settings),
          onPressed: () {
            Navigator.of(context).push<dynamic>(
              PageTransition<dynamic>(
                type: PageTransitionType.downToUp,
                //child: PreferencePage(),
                child: TestPage(),
              ),
            );
            setState(() {});
          },
        ),
      );

  Widget _buildCalendar(BuildContext context) =>
      StreamBuilder<Map<DateTime, DayInfo>>(
        stream: Provider.of<CalendarModel>(context).calendar,
        builder: (context, snapshot) => CalendarCarouselView<DayInfo>(
          date: Provider.of<AppModel>(context).preferenceRepository.lastDate,
          dayHeaderWidgetBuilder: _buildDayHeader,
          weekDayBuilder: _buildWeekDay,
          dayBuilder: _buildDay,
          onPageShow: (context, startDateTime, endDateTime) {
            Provider.of<CalendarModel>(context)
                .post(LoadCalendarEvent(startDateTime, endDateTime));
          },
          data: snapshot.data,
        ),
      );

  Widget _buildDayHeader(BuildContext context, DateTime date) =>
      CalendarHeaderView(date);

  Widget _buildWeekDay(BuildContext context, int weekday) =>
      WeekdayView(weekday);

  Widget _buildDay(
          BuildContext context, bool isInside, DateTime date, DayInfo data) =>
      DayView(isInside, date, data);

  Widget _buildPalette(int mode) =>
      mode == 0 ? IconPalleteView() : ColorPalleteView();
}

class CalendarHeaderView extends StatelessWidget {
  CalendarHeaderView(this.date);
  final DateTime date;

  @override
  Widget build(BuildContext context) => Container(
        height: _kCalendarTitleHeight,
        child: Center(
          child: Text(
            DateFormat.yMMM().format(date),
            style: TextStyle(fontSize: _kTitleTextSize),
          ),
        ),
      );
}

class WeekdayView extends StatelessWidget {
  WeekdayView(this.weekday);
  final int weekday;

  @override
  Widget build(BuildContext context) {
    final date = DateTime.now();
    return Center(
      child: Text(
        DateFormat.E()
            .format(date.add(Duration(days: -date.weekday + weekday))),
        style: TextStyle(
            color: Provider.of<AppModel>(context)
                .preferenceRepository
                .colorWeekDay(weekday)),
      ),
    );
  }
}

class DayView extends StatelessWidget {
  DayView(this.isInside, this.date, this.data);
  final bool isInside;
  final DateTime date;
  final DayInfo data;

  @override
  Widget build(BuildContext context) {
    final preferenceRepository =
        Provider.of<AppModel>(context).preferenceRepository;
    final color = isInside
        ? preferenceRepository.colorWeekDay(date.weekday)
        : preferenceRepository.colorOtherThanThisMonth;
    final now = DateTime.now();
    final isToday = now.difference(date).inDays == 0 && now.day == date.day;
    final info = data;
    final isHover = info != null ? info.isHover : false;
    final borderColor = isHover
        ? Theme.of(context).accentColor
        : preferenceRepository.colorBorder;
    return DragTarget<Palette>(
      builder: (context, candidateData, rejectedData) {
        final dayHeader = List<Widget>();
        dayHeader.add(Text(
          '${date.day}',
          style: TextStyle(color: color),
        ));
        if (isToday) {
          dayHeader.add(Expanded(
            child: Center(
              child: Container(
                  width: 20,
                  height: 10,
                  color: preferenceRepository.colorToday),
            ),
          ));
        }
        final dayContent = List<Widget>.generate(
            min(4, info == null ? 0 : info.icons.length),
            (i) => SvgPicture.asset(info.icons[i]));
        final container = <Widget>[
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: borderColor, width: isHover ? 2 : 0.5),
              color: info == null ? Colors.transparent : Color(info.color),
            ),
            child: Column(
              children: <Widget>[
                Row(
                  children: dayHeader,
                ),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    children: dayContent,
                  ),
                ),
              ],
            ),
          ),
        ];
        if (data != null && data.memo != null && data.memo.isNotEmpty) {
          container.add(Align(
            alignment: Alignment.topRight,
            child: SvgPicture.asset(
              'assets/ribon.svg',
              width: 10,
              height: 10,
            ),
          ));
        }
        return GestureDetector(
          onLongPress: () => openModalBottomSheet(
            context: context,
            child: _buildBottomSheet(context, date, data),
          ),
          child: Stack(
            children: container,
          ),
        );
      },
      onWillAccept: (paletteData) {
        var info = (data ?? DayInfo())..isHover = true;
        Provider.of<CalendarModel>(context)
            .post(UpdateCalendarEvent(date, info));
        return true;
      },
      onAccept: (paletteData) {
        var info = (data ?? DayInfo())..isHover = false;
        if (paletteData is ColorPalette) {
          info.color = paletteData.color.value;
        } else if (paletteData is IconPalette) {
          info.icons.add(paletteData.path);
        }
        Provider.of<CalendarModel>(context)
            .post(UpdateCalendarEvent(date, info));
      },
      onLeave: (paletteData) {
        var info = (data ?? DayInfo())..isHover = false;
        Provider.of<CalendarModel>(context)
            .post(UpdateCalendarEvent(date, info));
      },
    );
  }

  final _formKey = GlobalKey<FormState>();
  Widget _buildBottomSheet(BuildContext context, DateTime date, DayInfo data) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            DateFormat.yMMMd().format(date),
            style: TextStyle(fontSize: _kTitleTextSize),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Text('memo'),
          ),
          Form(
            key: _formKey,
            child: TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(8.0),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              initialValue: data == null ? '' : data.memo,
              onFieldSubmitted: (data) {
                _done(context, false);
              },
              onSaved: (text) async {
                var info = data ?? DayInfo();
                info.memo = text;
                Provider.of<CalendarModel>(context)
                    .post(UpdateCalendarEvent(date, info));
              },
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  child: RaisedButton(
                    child: Text('Cancel'),
                    color: Colors.white,
                    shape: StadiumBorder(
                      side: BorderSide(color: Colors.green),
                    ),
                    onPressed: () => _done(context, true),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  child: RaisedButton(
                    child: Text('ok'),
                    color: Colors.white,
                    shape: StadiumBorder(
                      side: BorderSide(color: Colors.green),
                    ),
                    onPressed: () => _done(context, false),
                  ),
                ),
              ),
            ],
          ),
        ],
      );

  void _done(BuildContext context, bool isCancel) {
    if (!isCancel) {
      _formKey.currentState.save();
    }
    Navigator.of(context).pop();
  }
}

abstract class Palette {
  const Palette();
}

class ColorPalette extends Palette {
  const ColorPalette(this.color);
  final Color color;
}

class IconPalette extends Palette {
  const IconPalette(this.path);
  final String path;
}

const double _kHeight = 80;
const int _kCount = 2;

abstract class PalleteView extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SizedBox(
        height: _kHeight,
        child: GridView.builder(
          scrollDirection: Axis.horizontal,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _kCount,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
          ),
          itemCount: getCount(),
          itemBuilder: (context, position) {
            return LongPressDraggable<Palette>(
              data: getData(position),
              child: getChild(position, _kHeight / _kCount),
              feedback: getFeedback(position, _kHeight / _kCount),
            );
          },
        ),
      );

  int getCount();
  Palette getData(int position);
  Widget getChild(int position, double size);
  Widget getFeedback(int position, double size);
}

final _kColor = [
  ColorPalette(Color.fromARGB(255, 255, 0, 0)),
  ColorPalette(Color.fromARGB(255, 192, 0, 0)),
  ColorPalette(Color.fromARGB(255, 128, 0, 0)),
  ColorPalette(Color.fromARGB(255, 64, 0, 0)),
  ColorPalette(Color.fromARGB(255, 0, 255, 0)),
  ColorPalette(Color.fromARGB(255, 0, 192, 0)),
  ColorPalette(Color.fromARGB(255, 0, 128, 0)),
  ColorPalette(Color.fromARGB(255, 0, 64, 0)),
  ColorPalette(Color.fromARGB(255, 0, 0, 255)),
  ColorPalette(Color.fromARGB(255, 0, 0, 192)),
  ColorPalette(Color.fromARGB(255, 0, 0, 128)),
  ColorPalette(Color.fromARGB(255, 0, 0, 64)),
  ColorPalette(Color.fromARGB(255, 255, 255, 0)),
  ColorPalette(Color.fromARGB(255, 192, 192, 0)),
  ColorPalette(Color.fromARGB(255, 128, 128, 0)),
  ColorPalette(Color.fromARGB(255, 64, 64, 0)),
  ColorPalette(Color.fromARGB(255, 0, 255, 255)),
  ColorPalette(Color.fromARGB(255, 0, 192, 192)),
  ColorPalette(Color.fromARGB(255, 0, 128, 128)),
  ColorPalette(Color.fromARGB(255, 0, 64, 64)),
  ColorPalette(Color.fromARGB(255, 255, 0, 255)),
  ColorPalette(Color.fromARGB(255, 192, 0, 192)),
  ColorPalette(Color.fromARGB(255, 128, 0, 128)),
  ColorPalette(Color.fromARGB(255, 64, 0, 64)),
  ColorPalette(Color.fromARGB(255, 255, 0, 0)),
  ColorPalette(Color.fromARGB(255, 192, 0, 0)),
  ColorPalette(Color.fromARGB(255, 128, 0, 0)),
  ColorPalette(Color.fromARGB(255, 64, 0, 0)),
  ColorPalette(Color.fromARGB(255, 255, 255, 0)),
  ColorPalette(Color.fromARGB(255, 255, 192, 0)),
  ColorPalette(Color.fromARGB(255, 255, 128, 0)),
  ColorPalette(Color.fromARGB(255, 255, 64, 0)),
  ColorPalette(Color.fromARGB(255, 255, 255, 255)),
  ColorPalette(Color.fromARGB(255, 255, 255, 192)),
  ColorPalette(Color.fromARGB(255, 255, 255, 128)),
  ColorPalette(Color.fromARGB(255, 255, 255, 64)),
];

class ColorPalleteView extends PalleteView {
  @override
  int getCount() => _kColor.length;

  @override
  Palette getData(int position) => _kColor[position];

  @override
  Widget getChild(int position, double size) => Container(
        width: size,
        height: size,
        color: _kColor[position].color,
      );

  @override
  Widget getFeedback(int position, double size) => Container(
        width: size,
        height: size,
        color: _kColor[position].color,
      );
}

// https://freeicons.io/icon-list/office-and-workstation
final _kIcons = [
  IconPalette('assets/home.svg'),
  IconPalette('assets/heart.svg'),
  IconPalette('assets/home.svg'),
  IconPalette('assets/home.svg'),
  IconPalette('assets/home.svg'),
  IconPalette('assets/home.svg'),
  IconPalette('assets/home.svg'),
  IconPalette('assets/home.svg'),
  IconPalette('assets/home.svg'),
  IconPalette('assets/home.svg'),
  IconPalette('assets/home.svg'),
  IconPalette('assets/home.svg'),
  IconPalette('assets/home.svg'),
  IconPalette('assets/home.svg'),
  IconPalette('assets/home.svg'),
  IconPalette('assets/home.svg'),
  IconPalette('assets/home.svg'),
  IconPalette('assets/home.svg'),
  IconPalette('assets/home.svg'),
  IconPalette('assets/home.svg'),
];

class IconPalleteView extends PalleteView {
  @override
  int getCount() => _kIcons.length;

  @override
  Palette getData(int position) => _kIcons[position];

  @override
  Widget getChild(int position, double size) => SvgPicture.asset(
        _kIcons[position].path,
        width: size,
        height: size,
      );

  @override
  Widget getFeedback(int position, double size) => SvgPicture.asset(
        _kIcons[position].path,
        width: size,
        height: size,
      );
}
