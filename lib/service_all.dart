import 'package:flutter/material.dart';
import 'package:ksp/page/about_us/about_us_form.dart';
import 'package:ksp/page/contact/contact_list_category.dart';
import 'package:ksp/page/ethics/ethics_list.dart';
import 'package:ksp/page/event_calendar/event_calendar_main.dart';
import 'package:ksp/page/knowledge/knowledge_list.dart';
import 'package:ksp/page/news/news_list.dart';
import 'package:ksp/page/other/other_menu.dart';
import 'package:ksp/page/poi/poi_list.dart';
import 'package:ksp/page/poll/poll_list.dart';
import 'package:ksp/page/privilege/privilege_special_list.dart';
import 'package:ksp/page/question_and_answer/question_list.dart';
import 'package:ksp/page/reporter/reporter_list_category.dart';
import 'package:ksp/page/teacher/teacher_form.dart';
import 'package:ksp/page/video/video_clips.dart';
import 'package:ksp/shared/api_provider.dart';
import 'package:ksp/widget/header.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceAllPage extends StatefulWidget {
  final String profileCode;
  final Future<dynamic> futureAboutUs;

  const ServiceAllPage({
    Key? key,
    required this.profileCode,
    required this.futureAboutUs,
  }) : super(key: key);

  @override
  State<ServiceAllPage> createState() => _ServiceAllPageState();
}

class _ServiceAllPageState extends State<ServiceAllPage> {
  late List<Map<String, dynamic>> services;

  @override
  void initState() {
    super.initState();
    services = [
      {
        'title': 'ตรวจสอบข้อมูลใบอนุญาต',
        'img': 'http://ksp.we-builds.com/ksp-document/images/menu/menu_ksp.png',
        'onTap': () {
          postTrackClick("ข้อมูลใบอนุญาต");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TeacherForm(
                title: 'ข้อมูลใบอนุญาต',
                profileCode: widget.profileCode,
              ),
            ),
          );
        }
      },
      {
        'title': 'ปฏิทินกิจกรรม',
        'img': 'http://ksp.we-builds.com/ksp-document/images/menu/menu_event.png',
        'onTap': () {
          postTrackClick("ปฏิทินกิจกรรม");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventCalendarMain(title: 'ปฏิทินกิจกรรม'),
            ),
          );
        }
      },
      {
        'title': 'ข่าวประชาสัมพันธ์',
        'img': 'http://ksp.we-builds.com/ksp-document/images/menu/menu_new.png',
        'onTap': () {
          postTrackClick("ข่าวประชาสัมพันธ์");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewsList(title: 'ข่าวประชาสัมพันธ์'),
            ),
          );
        }
      },
      {
        'title': 'KSP Service',
        'img': 'http://ksp.we-builds.com/ksp-document/images/menu/menu_service.png',
        'onTap': () {
          postTrackClick("KSP Self-service");
          launchUrl(
              Uri.parse('https://www.ksp.or.th/ksp2018/ksp-selfservice/'));
        }
      },
      {
        'title': 'KSP School',
        'img': 'http://ksp.we-builds.com/ksp-document/images/menu/menu_school.png',
        'onTap': () {
          postTrackClick("KSP School");
          launchUrl(Uri.parse('https://www.ksp.or.th/ksp2018/ksp-school/'));
        }
      },
      {
        'title': 'KSP Bandit',
        'img': 'http://ksp.we-builds.com/ksp-document/images/menu/menu_bandit.png',
        'onTap': () {
          postTrackClick("KSP Bundit");
          launchUrl(Uri.parse('https://www.ksp.or.th/ksp2018/uni-bundit/'));
        }
      },
      {
        'title': 'สถาบันผลิตครูที่คุรุสภารับรอง',
        'img': 'http://ksp.we-builds.com/ksp-document/images/menu/menu_tt.png',
        'onTap': () {
          postTrackClick("สถาบันผลิตครูที่คุรุสภารับรอง");
          launchUrl(Uri.parse('https://www.ksp.or.th/ksp2018/cert-stdksp/'));
        }
      },
      {
        'title': 'ค้นหาผู้ได้รับรางวัลคุรุสภา',
        'img': 'http://ksp.we-builds.com/ksp-document/images/menu/menu_reward.png',
        'onTap': () {
          postTrackClick("ค้นหาผู้ได้รับรางวัลคุรุสภา");
          launchUrl(
              Uri.parse('https://www.ksp.or.th/service/check_reward.php'));
        }
      },
      {
        'title': 'สารคุรุสภา',
        'img': 'http://ksp.we-builds.com/ksp-document/images/menu/menu_kanowledge.png',
        'onTap': () {
          postTrackClick("สารคุรุสภา");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => KnowledgeList(title: 'สารคุรุสภา'),
            ),
          );
        }
      },
      {
        'title': 'สิทธิพิเศษ',
        'img': 'http://ksp.we-builds.com/ksp-document/images/menu/menu_privileges.png',
        'onTap': () {
          postTrackClick("สิทธิพิเศษ");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PrivilegeSpecialList(title: 'สิทธิพิเศษ'),
            ),
          );
        }
      },
      {
        'title': 'จรรยาบรรณวิชาชีพ',
        'img': 'http://ksp.we-builds.com/ksp-document/images/menu/menu_ethics.png',
        'onTap': () {
          postTrackClick("จรรยาบรรณวิชาชีพ");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EthicsList(title: 'จรรยาบรรณวิชาชีพ'),
            ),
          );
        }
      },
      {
        'title': 'คลิปคุรุสภา',
        'img': 'http://ksp.we-builds.com/ksp-document/images/menu/menu_vdo.png',
        'onTap': () {
          postTrackClick("คลิปคุรุสภา");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoClipsPage(title: 'คลิปคุรุสภา'),
            ),
          );
        }
      },
      {
        'title': 'รับเรื่องร้องเรียน',
        'img': 'http://ksp.we-builds.com/ksp-document/images/menu/menu_reporter.png',
        'onTap': () {
          postTrackClick("รับเรื่องร้องเรียน");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ReporterListCategory(title: 'รับเรื่องร้องเรียน'),
            ),
          );
        }
      },
      {
        'title': 'หน่วยงานที่เกี่ยวข้อง',
        'img': 'http://ksp.we-builds.com/ksp-document/images/menu/menu_ra.png',
        'onTap': () {
          postTrackClick("หน่วยงานที่เกี่ยวข้อง");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  OtherMenuPage(title: 'หน่วยงานที่เกี่ยวข้อง'),
            ),
          );
        }
      },
      {
        'title': 'เบอร์เร่งด่วน',
        'img': 'http://ksp.we-builds.com/ksp-document/images/menu/menu_contact.png',
        'onTap': () {
          postTrackClick("เบอร์ติดต่อเร่งด่วน");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ContactListCategory(title: 'เบอร์ติดต่อเร่งด่วน'),
            ),
          );
        }
      },
      {
        'title': 'แบบสอบถาม',
        'img': 'http://ksp.we-builds.com/ksp-document/images/menu/menu_poll.png',
        'onTap': () {
          postTrackClick("แบบสอบถาม");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PollList(title: 'แบบสอบถาม'),
            ),
          );
        }
      },
      {
        'title': 'ถามตอบ',
        'img': 'http://ksp.we-builds.com/ksp-document/images/menu/menu_qa.png',
        'onTap': () {
          postTrackClick("ถาม - ตอบ");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BuildQuestionList(
                menuModel: {'title': 'ถาม - ตอบ'},
              ),
            ),
          );
        }
      },
      {
        'title': 'จุดน่าสนใจ',
        'img': 'http://ksp.we-builds.com/ksp-document/images/menu/menu_poi.png',
        'onTap': () {
          postTrackClick("จุดน่าสนใจ");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PoiList(title: 'จุดน่าสนใจ'),
            ),
          );
        }
      },
      // {
      //   'title': 'เกี่ยวกับเรา',
      //   'img': 'http://ksp.we-builds.com/ksp-document/images/images/bot_icon1.png',
      //   'onTap': () {
      //     postTrackClick("เกี่ยวกับเรา");
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => AboutUsForm(
      //           model: widget.futureAboutUs,
      //           title: 'เกี่ยวกับเรา',
      //         ),
      //       ),
      //     );
      //   }
      // },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: header(
        context,
        () {
          Navigator.pop(context);
        },
        title: 'บริการทั้งหมด',
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: services.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.85,
            ),
            itemBuilder: (context, index) {
              return _buildServiceCard(
                services[index]['title'],
                services[index]['img'],
                onTap: services[index]['onTap'],
              );
            },
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildServiceCard(String title, String imageUrl, {Function? onTap}) {
    return InkWell(
      onTap: () {
        if (onTap != null) onTap();
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              imageUrl,
              fit: BoxFit.fill,
              width: double.infinity,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              height: 35,
              color: const Color(0xFFF57F20),
              alignment: Alignment.center,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Kanit',
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}