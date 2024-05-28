import 'package:flutter/material.dart';
import 'package:flutter_application/models/book_data/monthly_book_title_data.dart';
import 'package:flutter_application/widgets/theme_controller.dart';
import 'package:flutter_application/widgets/box_decoration.dart';
import 'package:flutter_application/widgets/dropdown_button_controller.dart';
import 'package:flutter_application/widgets/text_span.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../style.dart';

/////////////////////////////////
// 독클 결과1 (월간 독서리스트) //
/////////////////////////////////

class BookResult1 extends StatefulWidget {
  final int year;
  final int month;
  final String pageDate;

  BookResult1({super.key, required this.year, required this.month}) : pageDate = DateFormat('yyyy년 M월').format(DateTime(year, month));

  @override
  State<BookResult1> createState() => _BookResult1State();
}

class _BookResult1State extends State<BookResult1> {
  // 컨트롤러
  final bookTitleDataController = Get.put(BookTitleDataController());  
  final dropdownButtonController = Get.put(DropdownButtonController());    
  final themeController = Get.put(ThemeController());                      

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final pageHeight = screenSize.height - 200;
    final pointTextColor = themeController.isLightTheme.value ? LightColors.indigo : DarkColors.blue;
    final detailTextColor = themeController.isLightTheme.value ? CommonColors.grey4 : CommonColors.grey3;

    return Column(
      children: [
        SizedBox(height: pageHeight * 0.1,),
        // 텍스트
        Obx(() => RichText(
          text: TextSpan(
            children: [
              normalText("${dropdownButtonController.currentItem.value} 학생은 "),
              colorText(widget.pageDate, pointTextColor),
              normalText("에"),
            ]),
          )), 
        SizedBox(
          height: pageHeight * 0.15,
          child: RichText(
            text: TextSpan(
              children: [
                normalText("총 "),
                colorText("${bookTitleDataController.monthlyBookCount}권", pointTextColor),
                normalText("의 책을 읽었어요!"),
              ]),
          ),
        ),
        // 독서클리닉 목록(책 제목 리스트)
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: bookTitleDataController.monthlyBookCount,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(left: screenSize.width * 0.1),
              child: Row(
                children: [
                  Icon(Icons.remove, color: detailTextColor),
                  Text(
                    bookTitleDataController.bookTitleDataList?[index].title ?? "",
                    style: TextStyle(fontSize: 16, color: detailTextColor),
                  )
                ],
              ),
            );
          },
        ),
        // 이미지, 월간 읽은 책의 권수
        Stack(
          children: [
            // 이미지(배경)
            Container(
              height: 200,
              width: double.infinity,
              decoration: imageBoxDecoration("assets/images/book/book_report1_1.png", BoxFit.contain)
            ),
            // 이미지(풍선)
            Positioned(
              left: screenSize.width - 120,
              child: Container(
                height: 120,
                width: 120,
                decoration: imageBoxDecoration("assets/images/book/book_report1_2.png", BoxFit.contain)
              ),
            ),
            // 월간 읽은 책의 권수
            Positioned(
              left: screenSize.width - 95,
              top: 5,
              child: SizedBox(
                height: 80,
                width: 80,
                child: Center(
                  child: Text(
                    "${bookTitleDataController.monthlyBookCount}",
                    style: const TextStyle(
                      fontSize: 35, 
                      color: Colors.white, 
                      fontFamily: "BMJUA"))
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: pageHeight * 0.2,),
      ],
    );
  }
}