import 'package:flutter/material.dart';
import 'package:ksp/page/poll/poll_form.dart';
import 'package:ksp/widget/blank.dart';
import 'package:ksp/widget/dialog.dart';
import 'package:ksp/widget/extension.dart';

class PollListVertical extends StatefulWidget {
  PollListVertical({
    Key? key,
    required this.model,
    required this.title,
    required this.url,
    this.urlComment = '',
    required this.urlGallery,
    required this.titleHome,
    required this.callBack,
  }) : super(key: key);

  final Future<dynamic> model;
  final String title;
  final String url;
  final String urlComment;
  final String urlGallery;
  final String titleHome;
  final Function callBack;

  @override
  _PollListVertical createState() => _PollListVertical();
}

class _PollListVertical extends State<PollListVertical> {
  @override
  void initState() {
    super.initState();
  }

  final List<String> items = List<String>.generate(
    10,
    (index) => "Item: ${++index}",
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: widget.model, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Container(
              alignment: Alignment.center,
              height: 200,
              child: Text(
                'ไม่พบข้อมูล',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Kanit',
                  color: Color.fromRGBO(0, 0, 0, 0.6),
                ),
              ),
            );
          } else {
            return Container(
              color: Colors.transparent,
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      snapshot.data[index]['status2']
                          ? toastFail(context, text: 'คุณตอบแบบสอบถามนี้แล้ว')
                          : Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => PollForm(
                                    code: snapshot.data[index]['code'],
                                    model: snapshot.data[index],
                                    titleMenu: widget.title,
                                    titleHome: widget.titleHome,
                                    url: widget.url,
                                  ),
                            ),
                          );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            snapshot.data[index]['status2']
                                ? Colors.grey[300]
                                : Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 0,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        padding: EdgeInsets.all(5),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(5),
                                  height: 120,
                                  width: 120,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.network(
                                      '${snapshot.data[index]['imageUrl']}',
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 120,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.all(5),
                                            child: Text(
                                              '${snapshot.data[index]['title']}',
                                              style: TextStyle(
                                                fontFamily: 'Kanit',
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 35,
                                          child: Row(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: Image.network(
                                                  '${snapshot.data[index]['imageUrlCreateBy']}',
                                                  // fit: BoxFit.cover,
                                                ),
                                              ),
                                              SizedBox(width: 5),
                                              Expanded(
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 5,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '${snapshot.data[index]['createBy']}',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontFamily: 'Kanit',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        maxLines: 1,
                                                        overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                      ),
                                                      Text(
                                                        snapshot.data[index]['createDate'] !=
                                                                null
                                                            ? 'วันที่ ${dateStringToDate('${snapshot.data[index]['createDate']}')}'
                                                            : '',
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          fontFamily: 'Kanit',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        maxLines: 1,
                                                        overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            Container(
                              color: Color(0xFF707070).withOpacity(0.5),
                              height: 1,
                            ),
                            SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        } else {
          return blankListData(context);
        }
      },
    );
  }
}
