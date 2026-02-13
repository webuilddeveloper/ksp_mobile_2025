import 'package:ksp/shared/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactListVertical extends StatefulWidget {
  ContactListVertical({
    Key? key,
    required this.model,
    required this.title,
    required this.url,
  }) : super(key: key);

  final Future<dynamic> model;
  final String title;
  final String url;

  @override
  _ContactListVertical createState() => _ContactListVertical();
}

class _ContactListVertical extends State<ContactListVertical> {
  @override
  void initState() {
    super.initState();
  }

  final List<String> items =
      List<String>.generate(10, (index) => "Item: ${++index}");

  _makePhoneCall(String url) async {
    await launchUrl(Uri.parse("tel://$url"));
  }

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
              // color: Colors.transparent,
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        margin: EdgeInsets.only(bottom: 5.0),
                        // width: 600,
                        child: Column(
                          children: [
                            Container(
                              constraints: BoxConstraints(
                                minHeight: 80,
                                minWidth: double.infinity,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: new BorderRadius.circular(5.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 0,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                                color: Color(0xFFFFFFFF),
                              ),
                              padding: EdgeInsets.all(10.0),
                              alignment: Alignment.centerLeft,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            '${snapshot.data[index]['imageUrl']}'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    // color: Color(0xFF000070),
                                    alignment: Alignment.centerLeft,
                                    width: 55.0,
                                    height: 55.0,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${snapshot.data[index]['title']}',
                                          style: TextStyle(
                                            fontSize: 13.0,
                                            fontFamily: 'Kanit',
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        if (snapshot.data[index]['urlWeb'] !=
                                                null &&
                                            snapshot.data[index]['urlWeb'] !=
                                                '')
                                          _buildContactRow(
                                            Icons.language,
                                            snapshot.data[index]['titleWeb'] !=
                                                        null &&
                                                    snapshot.data[index]
                                                            ['titleWeb'] !=
                                                        ''
                                                ? '${snapshot.data[index]['titleWeb']}'
                                                : '${snapshot.data[index]['urlWeb']}',
                                            () {
                                              launchUrl(Uri.parse(snapshot
                                                  .data[index]['urlWeb']));
                                            },
                                          ),
                                        if (snapshot.data[index]
                                                    ['urlFacebook'] !=
                                                null &&
                                            snapshot.data[index]
                                                    ['urlFacebook'] !=
                                                '')
                                          _buildContactRow(
                                            Icons.facebook,
                                            snapshot.data[index][
                                                        'titleFacebook'] !=
                                                    null &&
                                                snapshot.data[index][
                                                        'titleFacebook'] !=
                                                    ''
                                                ? '${snapshot.data[index]['titleFacebook']}'
                                                : '${snapshot.data[index]['urlFacebook']}',
                                            () {
                                              launchUrl(Uri.parse(snapshot
                                                  .data[index]['urlFacebook']));
                                            },
                                          ),
                                        if (snapshot.data[index]['phone'] !=
                                                null &&
                                            snapshot.data[index]['phone'] != '')
                                          _buildContactRow(
                                            Icons.phone,
                                            '${snapshot.data[index]['phone']}',
                                            () {
                                              _callReport(snapshot.data[index]);
                                              _makePhoneCall(snapshot
                                                  .data[index]['phone']);
                                            },
                                          ),
                                        if (snapshot.data[index]['email'] !=
                                                null &&
                                            snapshot.data[index]['email'] != '')
                                          _buildContactRow(
                                            Icons.email,
                                            '${snapshot.data[index]['email']}',
                                            () {
                                              launchUrl(Uri.parse(
                                                  'mailto:${snapshot.data[index]['email']}'));
                                            },
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          }
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildContactRow(IconData icon, String text, Function onTap) {
    return Container(
      padding: EdgeInsets.only(top: 5.0),
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Color(0xFFF58A33),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 10.0,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 5),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 12.0,
                  fontFamily: 'Kanit',
                  color: Colors.black,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _callReport(dynamic model) {
    postDio('${contactApi}read', {'code': model['code']});
  }
}
