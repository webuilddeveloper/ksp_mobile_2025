import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ksp/page/privilege/privilege_form.dart';
import 'package:ksp/page/privilege/privilege_main.dart';
import 'package:ksp/policy.dart';
import 'package:ksp/shared/api_provider.dart';
import 'package:ksp/widget/data_error.dart';
import 'package:ksp/widget/extension.dart';
import 'package:ksp/widget/loading.dart';
import 'package:ksp/widget/stack_tap.dart';


class BuildPrivilege extends StatefulWidget {
  BuildPrivilege({
    Key? key,
    required this.title,
    required this.model,
    this.showHeader= true,
    this.showError= false,
    required this.onError,
  }) : super(key: key);

  final Future<dynamic> model;
  final String title;
  final bool showHeader;
  final bool showError;
  final Function() onError;

  @override
  BuildPrivilegeState createState() => BuildPrivilegeState();
}

class BuildPrivilegeState extends State<BuildPrivilege> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showHeader)
      return Column(
        children: [
          buildHeader(),
          SizedBox(height: 20),
          buildGrid(),
        ],
      );
    else
      return buildGrid();
  }

  Widget buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              color: Color(0xFF000000),
              fontWeight: FontWeight.w500,
              fontSize: 15,
              fontFamily: 'Kanit',
            ),
          ),
          InkWell(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => MartShopPage(
                //       category: {'title': widget.title},
                //     ),
                //   ),
                // );
                postTrackClick('ดูทั้งหมดสิทธิ์ประโยชน์');
                _callReadPolicyPrivilege('สิทธิ์ประโยชน์');
              },
              child: Container(
                child: Image.asset(
                  'assets/icon_seemore.png',
                  width: 60,
                  height: 20,
                ),
              )
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              //   decoration: BoxDecoration(
              //     color: Color(0xFFF5661F),
              //     borderRadius: BorderRadius.circular(21),
              //   ),
              //   child: Text(
              //     'ดูทั้งหมด',
              //     style: TextStyle(
              //       color: Color(0xFFFFFFFF),
              //       fontWeight: FontWeight.bold,
              //       fontSize: 12,
              //       fontFamily: 'Kanit',
              //     ),
              //   ),
              // ),
              ),
        ],
      ),
    );
  }

  buildGrid() {
    var size = MediaQuery.of(context).size;
    final double itemWidth = (size.width / 2) - 20;
    return FutureBuilder<dynamic>(
      future: widget.model, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return GridView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                // childAspectRatio: 2,
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height / 1.45),
              ),
              padding: EdgeInsets.symmetric(horizontal: 15),
              itemCount: 2,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: 0,
                    left: index % 2 != 0 ? 5 : 0,
                    right: index % 2 == 0 ? 5 : 0,
                  ),
                  child: buildCard(
                    model: snapshot.data[index],
                    index: index,
                    lastIndex: 2,
                    itemWidth: itemWidth,
                  ),
                );
              },
            );
          } else {
            return Container(
              height: 300,
            );
          }
        } else if (snapshot.hasError) {
          return widget.showError
              ? DataError(onTap: () => widget.onError())
              : Container(
                  height: 300,
                );
        } else {
          return GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 15),
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
            ),
            itemCount: 2,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  left: index % 2 != 0 ? 5 : 0,
                  right: index % 2 == 0 ? 5 : 0,
                ),
                child: LoadingTween(height: 100),
              );
            },
          );
        }
      },
    );
  }

  Future<Null> _callReadPolicyPrivilege(String title) async {
    var policy = await postDio(server + "m/policy/read",
        {"category": "marketing", "skip": 0, "limit": 10});

    if (policy.length > 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          // ignore: missing_required_param
          // builder: (context) => PolicyIdentityVerificationPage(),
          builder: (context) => PolicyPage(
            category: 'marketing',
            navTo: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => PrivilegeMain(
                    title: title,
                  ),
                ),
              );
            },
          ),
        ),
      );

      // if (!isPolicyFasle) {
      //   logout(context);
      //   _onRefresh();
      // }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PrivilegeMain(
            title: title,
          ),
        ),
      );
    }
  }

  buildCard(
      {dynamic model, int index = 0, int lastIndex = 0, double? itemWidth}) {
    return StackTap(
      borderRadius: BorderRadius.circular(15),
      onTap: () {
        postTrackClick('ดูข้อมูลสิทธิ์ประโยชน์');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PrivilegeForm(
              code: model['code'],
              model: model,
            ),
          ),
        );
      },
      child: Container(
        height: 300,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: loadingImageNetwork(
                model['imageUrl'],
                width: 150,
                height: 150,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(height: 7),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  model['title'],
                  style:
                      TextStyle(fontSize: 15, fontFamily: 'Kanit', height: 1),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  parseHtmlString(model['description']),
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'Kanit',
                    color: Color(0xFF707070),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
