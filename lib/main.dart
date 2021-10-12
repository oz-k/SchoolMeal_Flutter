import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:school_meal_flutter/floating_haksik_launch_button.dart';
import 'package:school_meal_flutter/menu_list.dart';
import 'package:school_meal_flutter/title_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
	const MyApp({Key? key}) : super(key: key);

	// This widget is the root of your application.
	@override
	Widget build(BuildContext context) {
		//우측상단 debug badge 숨기기
		SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);

		return const MaterialApp(
			debugShowCheckedModeBanner: false, 
			title: '학식', 
			home: Main()
		);
	}
}

class Main extends StatefulWidget {
    const Main({ Key? key }) : super(key: key);
    
    @override
    _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
    final Duration day = const Duration(days: 1);
    DateTime dateNow = DateTime.now();
    int sliderIndex = 0;

    setDate(DateTime date) => setState(() {
        if(date.weekday > 5) { //주말일 경우 다음주 월요일로
            date = date.add(day*(7-date.weekday+1));
        }
        dateNow = date;
    });
    
    _MainState() {
        // 조/중/석식 배식 종료시간
        List<List<int>> servingEndTimes = const [[9, 0], [13, 30], [18, 10]];
    
        int hour = dateNow.hour;
        int minute = dateNow.minute;

        for(var i=0; i<servingEndTimes.length; i++) {
            final servingEndTime = servingEndTimes[i];

            if(hour >= servingEndTime[0]) {
                if(hour == servingEndTime[0]) {
                    if(minute >= servingEndTime[1]) {
                        sliderIndex = i+1;
                    }
                } else {
                    sliderIndex = i+1;
                }
            }
        }

        if(sliderIndex == 3) {
            sliderIndex = 0;
            dateNow = dateNow.add(day);
        }
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    TitleBar(dateNow: dateNow, setDate: setDate),
                    MenuList(dateNow: dateNow, setDate: setDate, sliderIndex: sliderIndex,)
                ],
            ),
            floatingActionButton: FloatingHakSikLaunchButton(),
        );
    }
}