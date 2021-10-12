
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MenuList extends StatelessWidget {
    final DateTime dateNow;
    final Function setDate;
    final int sliderIndex;

    const MenuList({
        Key? key, 
        required this.dateNow, 
        required this.setDate,
        required this.sliderIndex
    }) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return Expanded(
            child: FutureBuilder(
                future: getMenu(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                    print(snapshot.hasData);
                    if(snapshot.hasError) {
                        return const Center(
                            child: Text(
                                '학식정보를 받아오는데 실패했습니다.',
                                style: TextStyle(fontSize: 20)
                            ),
                        );
                    } else if(snapshot.hasData == false) {
                        return const Expanded(
                            child: Center(
                                child: CircularProgressIndicator(),
                            ),
                        );
                    } else {
                        return CarouselSlider(
                            options: CarouselOptions(
                                aspectRatio: 16/9,
                                scrollDirection: Axis.horizontal, //가로스크롤
                                enableInfiniteScroll: false, //무한스크롤 off
                                enlargeCenterPage: true, //중앙으로 자석효과
                                disableCenter: true,
                                initialPage: sliderIndex,
                                viewportFraction: 0.7
                            ),
                            items: List.generate(3, (index) => index).map((index) {
                                return MenuCard(index: index, menus: snapshot.data[dateNow.weekday]);
                            }).toList(),
                        );
                    }
                }
            )
        );
    }

    Future getMenu() async {
        http.Response response = await http.post(
            Uri.parse('https://www.kopo.ac.kr/semi/content.do?menu=3295'), 
            
            body: {
                'day': DateFormat('yyyyMMdd').format(dateNow)
            }
        );
        if(response.statusCode == 200) {
            dom.Document document = parser.parse(response.body);
            List<dom.Element> tr = document.querySelectorAll('table.tbl_table.menu > tbody > tr');
            Map<int, List<String>> datas = {
                1: List.generate(3, (index) => ''),
                2: List.generate(3, (index) => ''),
                3: List.generate(3, (index) => ''),
                4: List.generate(3, (index) => ''),
                5: List.generate(3, (index) => '')
            };
            
            for(var i=0; i<5; i++) {
                for(var j=1; j<4; j++) {
                    final innerHtml = tr[i].querySelectorAll('td')[j].querySelector('span')!.innerHtml;
                    
                    datas[i+1]![j-1] = innerHtml.replaceAll('\n', '').replaceAll(', ', '\n');
                }
            }
            
            return datas;
        } else {
            throw Exception('response statusCode not 200');
        }
    }
}

class MenuCard extends StatelessWidget {
    final int index;
    final List<String> menus;
    const MenuCard({ Key? key, required this.index, required this.menus }) : super(key: key);

    @override
    Widget build(BuildContext context) {
        List<String> splitedMenu = menus[index].split('\n');
        
        return FractionallySizedBox(
            heightFactor: 0.7,
            child: Card(
                elevation: 30,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                child: Column(
                    children: [
                        ServingTimeInfo(index: index),
                        Expanded(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                    splitedMenu.length, 
                                    (idx) => Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                            splitedMenu[idx].isNotEmpty ? splitedMenu[idx] : '예정된 학식이 없습니다.', 
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(fontSize: 18)
                                        )
                                    )
                                )
                                
                            )
                        ),
                    ],
                ),
            )
        );
    }
}

class ServingTimeInfo extends StatelessWidget {
    final int index;
    const ServingTimeInfo({ Key? key, required this.index }) : super(key: key);
    static const infos = ['조식 (08:00 ~ 09:00)', '중식 (11:50 ~ 13:30)', '석식 (17:20 ~ 18:10)'];

    @override
    Widget build(BuildContext context) {
        return Container(
            height: 55,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)
                ),
                color: Colors.cyan
            ),
            child: Text(
                infos[index], 
                textAlign: TextAlign.center, 
                style: const TextStyle(fontSize: 20)
            ),
        );
    }
}