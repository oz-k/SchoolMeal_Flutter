import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'constant_value.dart';

class TitleBar extends StatelessWidget {
    final DateTime dateNow;
    final Function setDate;
    Duration day = const Duration(days: 1);

    TitleBar({ Key? key, required this.dateNow, required this.setDate }) : super(key: key);
    
    @override
    Widget build(BuildContext context) {
        //요일
        final date = ConstantValue.dates[dateNow.weekday-1][ConstantValue.isIcon ? 0 : 1];

        //요일 표현방식이 아이콘일 경우 아이콘위젯, 아니면 텍스트위젯을 사용
        final dateWidget = ConstantValue.isIcon ? Image.asset(date, width: 20, height: 20) : Text(date, style: ConstantValue.titleTextStyle);

        return Container(
            decoration: const BoxDecoration(color: Colors.cyan),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                    TextButton( //현재날짜
                        style: TextButton.styleFrom(
                            primary: ConstantValue.titleTextStyle.color, //글자색을 타 텍스트색(검정)과 동일하게
                            padding: EdgeInsets.zero, //기본 패딩 삭제
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap, //탭이 가능한 범위설정
                            minimumSize: Size.zero //기본 최소사이즈 삭제
                        ),
                        child: Text(DateFormat('yyyy-MM-dd').format(dateNow)),
                        onPressed: () => setDate(DateTime.now()) //날짜 클릭 시 현재날짜로 되돌아감
                    ),
                    Row(
                        mainAxisSize: MainAxisSize.max, //가로사이즈 match_parent
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, //정렬방식
                        children: [
                            getNavigateButton(Direction.left), //이전일 버튼
                            dateWidget, //요일위젯
                            getNavigateButton(Direction.right) //다음일 버튼
                        ],
                    )
                ],
            )
        );
    }

    //방향키 눌렸을 때 이벤트
  	void arrowKeysPressed(String direction) {
		switch(direction) {
			case Direction.left:
                if(dateNow.weekday == 1) { //주말은 건너뜀
                    setDate(dateNow.subtract(day*3));
                } else {
                    setDate(dateNow.subtract(day));
                }
				break;
			case Direction.right:
                if(dateNow.weekday == 5) { //주말은 건너뜀
                    setDate(dateNow.add(day*3));
                } else {
                    setDate(dateNow.add(day));
                }
		}
	}

    //방향에따른 버튼생성함수
	IconButton getNavigateButton(String direction) {
		final buttonIcon = direction == Direction.left ? Icons.navigate_before : Icons.navigate_next;

		return IconButton(
			onPressed: () => arrowKeysPressed(direction), 
			icon: Icon(buttonIcon, size: 35), 
		);
	}
}

//방향상수
class Direction {
	static const left = 'LEFT';
	static const right = 'RIGHT';
}