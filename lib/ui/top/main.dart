import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../model.dart';
import '../../repo/model/model.dart';
import '../view/calendar_carousel_view.dart';
import '../settings/main.dart';
import 'model.dart';

class _WeekDay {
  const _WeekDay(this.name, this.color);
  final String name;
  final Color color;
}

class CalendarPage extends StatelessWidget {
  static const _kWeekDay = {
    DateTime.sunday: _WeekDay('sun', Colors.red),
    DateTime.monday: _WeekDay('mon', Colors.black),
    DateTime.tuesday: _WeekDay('tue', Colors.black),
    DateTime.wednesday: _WeekDay('wed', Colors.black),
    DateTime.thursday: _WeekDay('thu', Colors.black),
    DateTime.friday: _WeekDay('fri', Colors.black),
    DateTime.saturday: _WeekDay('sat', Colors.blue),
  };
  static const _kMonth = {
    DateTime.january: 'Jun',
    DateTime.february: 'Feb',
    DateTime.march: 'Mar',
    DateTime.april: 'Apl',
    DateTime.may: 'May',
    DateTime.june: 'Jun',
    DateTime.july: 'Jul',
    DateTime.august: 'Aug',
    DateTime.september: 'Sep',
    DateTime.october: 'Oct',
    DateTime.november: 'Nov',
    DateTime.december: 'Dec',
  };

  @override
  Widget build(BuildContext context) => Provider<CalendarModel>(
        builder: (_) =>
            CalendarModel(Provider.of<AppModel>(context).databaseRepository),
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
          initialData: 0,
          stream: Provider.of<CalendarModel>(context).navigation,
          builder: (context, snapshot) => BottomNavigationBar(
            currentIndex: snapshot.data,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.ac_unit),
                title: Text('icons'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.accessibility),
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

  Widget _buildBody(BuildContext context) => Padding(
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
                    initialData: 0,
                    stream: Provider.of<CalendarModel>(context).palette,
                    builder: (context, snapshot) =>
                        _buildPalette(snapshot.data),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.topRight,
              child: SizedBox(
                height: 30,
                child: IconButton(
                  padding: EdgeInsets.all(0),
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    Navigator.of(context).push<dynamic>(
                      PageTransition<dynamic>(
                        type: PageTransitionType.downToUp,
                        child: SettingsPage(),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      );

  Widget _buildCalendar(BuildContext context) =>
      StreamBuilder<Map<DateTime, DayInfo>>(
        stream: Provider.of<CalendarModel>(context).calendar,
        builder: (context, snapshot) => CalendarCarouselView<DayInfo>(
          date: DateTime.now(),
          dayHeaderWidgetBuilder: _buildDayHeader,
          weekDayBuilder: _buildWeekDay,
          dayBuilder: _buildDay,
          onPageShow: _onPageShow,
          data: snapshot.data,
        ),
      );

  void _onPageShow(
      BuildContext context, DateTime startDateTime, DateTime endDateTime) {
    Provider.of<CalendarModel>(context)
        .post(LoadCalendarEvent(startDateTime, endDateTime));
  }

  Widget _buildDayHeader(BuildContext context, DateTime date) => Container(
        height: 30,
        child: Center(
          child: Text(
            '${_kMonth[date.month]} ${date.year}',
            style: TextStyle(fontSize: 18),
          ),
        ),
      );

  Widget _buildWeekDay(BuildContext context, int weekday) => Center(
        child: Text(
          _kWeekDay[weekday].name,
          style: TextStyle(color: _kWeekDay[weekday].color),
        ),
      );

  Widget _buildDay(
      BuildContext context, bool isInside, DateTime date, DayInfo data) {
    final color = isInside ? _kWeekDay[date.weekday].color : Colors.grey;
    final now = DateTime.now();
    final isToday = now.difference(date).inDays == 0 && now.day == date.day;
    final info = data;
    final isHover = info != null ? info.isHover : false;
    final borderColor = isHover ? Colors.red : Colors.grey;
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
              child: Container(width: 20, height: 10, color: Colors.red),
            ),
          ));
        }
        final dayContent = List<Widget>.generate(
            min(4, info == null ? 0 : info.icons.length),
            (i) => SvgPicture.asset(info.icons[i]));
        return Container(
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
        );
      },
      onWillAccept: (paletteData) {
        print('on will accept ${date.toString()}');
        var info = (data ?? DayInfo())..isHover = true;
        Provider.of<CalendarModel>(context)
            .post(UpdateCalendarEvent(date, info));
        return true;
      },
      onAccept: (paletteData) {
        print('on accept ${date.toString()}');
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
        print('on leave ${date.toString()}');
        var info = (data ?? DayInfo())..isHover = false;
        Provider.of<CalendarModel>(context)
            .post(UpdateCalendarEvent(date, info));
      },
    );
  }

  Widget _buildPalette(int mode) =>
      mode == 0 ? IconPalleteView() : ColorPalleteView();
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

// class DayInfo {
//   var willAccept = false;
//   var color = Colors.transparent;
//   var icons = List<String>();
// }

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
