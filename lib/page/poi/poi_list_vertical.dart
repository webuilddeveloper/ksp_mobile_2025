import 'package:flutter/material.dart';
import 'package:ksp/page/poi/poi_form.dart';
import 'package:ksp/shared/api_provider.dart';
import 'package:ksp/widget/loading.dart';

class PoiListVertical extends StatefulWidget {
  PoiListVertical({Key? key, required this.model}) : super(key: key);

  final Future<dynamic> model;

  @override
  _PoiListVertical createState() => _PoiListVertical();
}

class _PoiListVertical extends State<PoiListVertical> {
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
        // AsyncSnapshot<Your object type>

        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Container(
              height: 200,
              alignment: Alignment.center,
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
              padding: EdgeInsets.only(left: 5.0, right: 5.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: MediaQuery.of(context).size.width /
                      (MediaQuery.of(context).size.height / 1.85),
                ),
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PoiForm(
                            code: snapshot.data[index]['code'],
                            model: snapshot.data[index],
                            url: poiApi,
                            urlComment: poiCommentApi,
                            urlGallery: poiGalleryApi,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 5.0, vertical: 7),
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.circular(5),
                        color: Colors.transparent,
                      ),
                      width: 170.0,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Positioned.fill(
                            child: Container(
                              height: 170.0,
                              width: double.infinity,
                              padding: EdgeInsets.only(bottom: 45),
                              decoration: BoxDecoration(
                                borderRadius: new BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 2,
                                    color: Color(0xFFcfcfcf),
                                    offset: Offset(0, 0.75),
                                  )
                                ],
                                color: Colors.white,
                              ),
                              alignment: Alignment.center,
                              child: loadingImageNetwork(
                                snapshot.data[index]['imageUrl'],
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.all(5),
                              alignment: Alignment.topLeft,
                              height: 45.0,
                              decoration: BoxDecoration(
                                borderRadius: new BorderRadius.only(
                                  bottomLeft: const Radius.circular(5.0),
                                  bottomRight: const Radius.circular(5.0),
                                ),
                                color: Color(0xFFF99608),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapshot.data[index]['title'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontFamily: 'Kanit',
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  textDistance(
                                      snapshot.data[index]['distance']),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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

  textDistance(dynamic value) {
    var distance;
    if (value == 0) {
      distance = "N/A";
    } else {
      distance = value.toStringAsFixed(2);
    }
    return Text(
      "ระยะทาง " + distance + " กิโลเมตร",
      style: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 8,
        fontFamily: 'Kanit',
        color: Colors.white,
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }
}
