import 'package:flutter/material.dart';
import 'package:ksp/page/reporter/reporter_form.dart';
import 'package:ksp/page/reporter/reporter_form_fixcode.dart';

// import 'reporter_list.dart';

class ReporterListCategoryVertical extends StatefulWidget {
  ReporterListCategoryVertical({
    Key? key,
    required this.model,
  }) : super(key: key);

  final Future<dynamic> model;

  @override
  _ReporterListCategoryVertical createState() =>
      _ReporterListCategoryVertical();
}

class _ReporterListCategoryVertical
    extends State<ReporterListCategoryVertical> {
  @override
  void initState() {
    super.initState();
  }

  final List<String> items =
      List<String>.generate(10, (index) => "Item: ${++index}");

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
            return ListView.builder(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              physics: ScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    snapshot.data[index]['fixcode'] == "1"
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReporterFormFixcodePage(
                                title: snapshot.data[index]['title'],
                                code: snapshot.data[index]['code'],
                                imageUrl: snapshot.data[index]['imageUrl'],
                              ),
                            ),
                          )
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReporterFormPage(
                                title: snapshot.data[index]['title'],
                                code: snapshot.data[index]['code'],
                                imageUrl: snapshot.data[index]['imageUrl'],
                              ),
                            ),
                          );
                  },
                  child: Container(
                    height: 80.0,
                    margin: EdgeInsets.only(bottom: 5.0),
                    decoration: BoxDecoration(
                      borderRadius: new BorderRadius.circular(15.0),
                      color: Color(0xFFF58A33),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                // borderRadius:
                                //     BorderRadius.circular(5),
                                image: DecorationImage(
                                  image: NetworkImage(
                                      '${snapshot.data[index]['imageUrl']}'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              // color: Color(0xFF000070),
                              alignment: Alignment.centerLeft,
                              width: 50.0,
                              height: 50.0,
                              padding: EdgeInsets.all(10),
                            ),
                            SizedBox(width: 10),
                            Container(
                              child: Text(
                                '${snapshot.data[index]['title']}',
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15,
                                    fontFamily: 'Kanit',
                                    color: Colors.white
                                    // color:
                                    //     Color.fromRGBO(0, 0, 0, 0.6),
                                    ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          // color: Colors.yellow,
                          child: Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.white,
                            // color: Color.fromRGBO(0, 0, 0, 0.5),
                            size: 40.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        } else {
          return Container();
        }
      },
    );
  }
}
