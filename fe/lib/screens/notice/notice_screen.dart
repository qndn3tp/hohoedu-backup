import 'package:flutter/material.dart';
import 'package:flutter_application/models/notice_data/notice_data.dart';
import 'package:flutter_application/screens/Notice/Notice_list_tile.dart';
import 'package:flutter_application/screens/notice/tab_bar_scroller.dart';
import 'package:flutter_application/services/notice/get_notice_data.dart';
import 'package:flutter_application/widgets/app_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '../../style.dart';
////////////////////////
//    알림장  화면    //
////////////////////////

class NoticeScreen extends StatefulWidget {
  const NoticeScreen({super.key});

  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  final ScrollController scrollController = ScrollController();

  // TabBar 인덱스
  int current = 0;
  // TabBar Tabs
  final List<String> tabs = ["공지", "수업", "출석", "결제", "독클"];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // 상단바
      appBar: customAppBar("알림장"),
      // TabBar, TabView
      body: Column(
        children: [
          // TabBar
          SizedBox(
            height: 60,
            width: double.infinity,
            child: ListView.builder(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: tabs.length,
              itemBuilder: ((context, index) {
                return GestureDetector(
                  onTap: () async{
                    setState(() {
                      current = index;
                      // tab 클릭시 인덱스에 따른 TabBar 내 스크롤 이동
                      scrollToIndex(index, scrollController, tabs.length);
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                    height: 40,
                    width: 80,
                    decoration: BoxDecoration(
                      color: current == index 
                        ? CommonColors.grey4
                        : Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: current == index
                        ? Border.all(color: CommonColors.grey4, width: 2)
                        : Border.all(color: const Color(0xffdfdfdf), width: 2),
                    ),
                    // Tabs 텍스트
                    child: Center(
                      child: Text(
                        tabs[index],
                        style: TextStyle(
                          color: current == index
                            ? Colors.white
                            : CommonColors.grey4,
                            fontWeight: FontWeight.bold
                        ),),
                    ),
                  ),
                );
              })
            ),
          ),
          // Tab View
          Expanded(
            child: FutureBuilder<void>(
              future: getNoticeData(current.toString()),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SpinKitThreeBounce(color: Theme.of(context).colorScheme.onSecondary);
                } else if (snapshot.hasError) {
                  return Container();
                } else {
                  return TabPage();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Tab View Page
class TabPage extends StatelessWidget {
  final noticeDataController = Get.put(NoticeDataController());

  TabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: noticeDataController.noticeDataList?.length ?? 0,
      itemBuilder: (context, index) {
        return noticeListTile(index);
      }
    );
  }
}