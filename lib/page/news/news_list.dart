import 'package:flutter/material.dart';
import 'package:ksp/page/news/news_form.dart';
import 'package:ksp/shared/api_provider.dart';
import 'package:ksp/widget/blank.dart';
import 'package:ksp/widget/extension.dart';
import 'package:ksp/widget/header.dart';
import 'package:ksp/widget/key_search.dart';
import 'package:ksp/widget/tab_category.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NewsList extends StatefulWidget {
  NewsList({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _NewsList createState() => _NewsList();
}

class _NewsList extends State<NewsList> {
  bool hideSearch = true;
  final txtDescription = TextEditingController();
  String keySearch = '';
  String category = '';
  int _limit = 10;

  Future<dynamic> futureModel = Future.value(null);
  Future<dynamic> futureCategory = Future.value(null);
  List<dynamic> listTemp = [
    {
      'code': '',
      'title': '',
      'imageUrl': '',
      'createDate': '',
      'userList': [
        {'imageUrl': '', 'firstName': '', 'lastName': ''},
      ],
    },
  ];
  bool showLoadingItem = true;

  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  // final ScrollController _controller = ScrollController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtDescription.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    futureModel = postDio('${newsApi}read', {
      'skip': 0,
      'limit': _limit,
      "category": category,
      "keySearch": keySearch,
    });

    futureCategory = postDioCategory('${newsCategoryApi}read', {
      'skip': 0,
      'limit': 100,
    });
  }

  void _onLoading() async {
    setState(() {
      _limit = _limit + 10;

      futureModel = postDio('${newsApi}read', {
        'skip': 0,
        'limit': _limit,
        "category": category,
        "keySearch": keySearch,
      });
    });

    await Future.delayed(Duration(milliseconds: 2000));

    _refreshController.loadComplete();
  }

  void goBack() async {
    Navigator.pop(context, false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        // Note: Sensitivity is integer used when you don't want to mess up vertical drag
        if (details.delta.dx > 10) {
          // Right Swipe
          Navigator.pop(context);
        } else if (details.delta.dx < -0) {
          //Left Swipe
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: header(context, goBack, title: widget.title),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overScroll) {
            return false;
          },
          child: new InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Column(
              children: [
                SizedBox(height: 5),
                CategorySelector(
                  model: futureCategory,
                  onChange: (String val) {
                    setData(val, keySearch);
                  },
                ),
                SizedBox(height: 5),
                KeySearch(
                  show: hideSearch,
                  onKeySearchChange: (String val) {
                    setData(category, val);
                  },
                ),
                SizedBox(height: 10),
                Expanded(child: buildNewsList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  FutureBuilder buildNewsList() {
    return FutureBuilder<dynamic>(
      future: futureModel, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          if (showLoadingItem) {
            return blankListData(context, height: 300);
          } else {
            return refreshList(listTemp);
          }
        } else if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                showLoadingItem = false;
                listTemp = snapshot.data;
              });
            });
            return refreshList(snapshot.data);
          } else {
            return Container(
              alignment: Alignment.center,
              height: 200,
              child: Text(
                'ไม่พบข้อมูล',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Kanit',
                  color: Colors.grey,
                ),
              ),
            );
          }
        } else if (snapshot.hasError) {
          // return dialogFail(context);
          return InkWell(
            onTap: () {
              setState(() {
                futureModel = postDio('${newsApi}read', {
                  'skip': 0,
                  'limit': _limit,
                  "category": category,
                  "keySearch": keySearch,
                });
              });
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.refresh, size: 50.0, color: Colors.blue),
                Text('ลองใหม่อีกครั้ง'),
              ],
            ),
          );
        } else {
          return refreshList(listTemp);
        }
      },
    );
  }

  SmartRefresher refreshList(List<dynamic> model) {
    return SmartRefresher(
      enablePullDown: false,
      enablePullUp: true,
      footer: ClassicFooter(
        loadingText: ' ',
        canLoadingText: ' ',
        idleText: ' ',
        idleIcon: Icon(Icons.arrow_upward, color: Colors.transparent),
      ),
      controller: _refreshController,
      onLoading: _onLoading,
      child: ListView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: model.length,
        padding: EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (context, index) {
          if (index == 0)
            return cardTop(model[index]);
          else
            return cardNormal(model[index]);
        },
      ),
    );
  }

  setData(String category, String keySearkch) {
    setState(() {
      if (keySearch != "") {
        showLoadingItem = true;
      }
      keySearch = keySearkch;
      _limit = 10;
      futureModel = postDio('${newsApi}read', {
        'skip': 0,
        'limit': _limit,
        "category": category,
        "keySearch": keySearch,
      });
    });
  }

  cardTop(model) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => NewsForm(
                  code: model['code'],
                  model: model,
                  url: '${newsApi}read',
                  urlGallery: newsGalleryApi,
                ),
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFFFFFFF),
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
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 205,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.network(
                            '${model['imageUrl']}',
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${model['title']}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Kanit',
                                fontSize: 15.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Container(color: Color(0xFF707070).withOpacity(0.5), height: 1),
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      padding: EdgeInsets.all(5),
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.circular(100),
                      //   gradient: LinearGradient(
                      //     colors: [
                      //       Color(0xFF33B1C4),
                      //       Color(0xFF1B6CA8),
                      //     ],
                      //   ),
                      // ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network(
                          '${model['imageUrlCreateBy']}',
                          // fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${model['createBy']}',
                              style: TextStyle(
                                fontSize: 10,
                                fontFamily: 'Kanit',
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 3,
                            ),
                            Row(
                              children: [
                                Text(
                                  model['createDate'] != null
                                      ? 'วันที่ ${dateStringToDate('${model['createDate']}')}'
                                      : '',
                                  style: TextStyle(
                                    fontSize: 8,
                                    fontFamily: 'Kanit',
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  cardNormal(model) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => NewsForm(
                  code: model['code'],
                  model: model,
                  url: '${newsApi}read',
                  urlGallery: newsGalleryApi,
                ),
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFFFFFFF),
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
                            '${model['imageUrl']}',
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 120,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                    '${model['title']}',
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
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.network(
                                        '${model['imageUrlCreateBy']}',
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
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${model['createBy']}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'Kanit',
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              model['createDate'] != null
                                                  ? 'วันที่ ${dateStringToDate('${model['createDate']}')}'
                                                  : '',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontFamily: 'Kanit',
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
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
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
