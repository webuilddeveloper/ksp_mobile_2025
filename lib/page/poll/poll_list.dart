import 'package:flutter/material.dart';
import 'package:ksp/page/poll/poll_list_vertical.dart';
import 'package:ksp/shared/api_provider.dart' as service;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ksp/widget/header.dart';
import 'package:ksp/widget/key_search.dart';
import 'package:ksp/widget/tab_category.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PollList extends StatefulWidget {
  PollList({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _PollList createState() => _PollList();
}

class _PollList extends State<PollList> {
  final storage = FlutterSecureStorage();
  late PollListVertical poll;
  bool hideSearch = true;
  final txtDescription = TextEditingController();
  String keySearch = '';
  String category = '';
  int _limit = 0;
  Future<dynamic> _futureCategory = Future.value(null);

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
    // _controller.addListener(_scrollListener);
    _onLoading();
    super.initState();
  }

  void _onLoading() async {
    // var profileCode = await storage.read(key: 'profileCode9');
    // if (profileCode != '' && profileCode != null) {
    setState(() {
      _limit = _limit + 10;
      _futureCategory = service.postCategory('${service.pollCategoryApi}read', {
        'skip': 0,
        'limit': 100,
        // 'profileCode': profileCode,
      });

      poll = PollListVertical(
        model: service.postDio('${service.pollApi}read', {
          'skip': 0,
          'limit': _limit,
          'category': category,
          'keySearch': keySearch,
          // 'profileCode': profileCode,
        }),
        title: '',
        titleHome: widget.title,
        url: '${service.pollApi}read',
        urlGallery: service.pollGalleryApi,
        callBack: () => {_onLoading()},
      );
    });
    // }

    await Future.delayed(Duration(milliseconds: 1000));

    _refreshController.loadComplete();
  }

  void goBack() async {
    Navigator.of(context).popUntil((route) => route.isFirst);
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => Menu(),
    //   ),
    // );
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
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Column(
              // physics: ScrollPhysics(),
              // shrinkWrap: true,
              // controller: _controller,
              children: [
                SizedBox(height: 5),
                CategorySelector(
                  model: _futureCategory,
                  onChange: (String val) {
                    setState(() {
                      category = val;
                    });
                    _onLoading();
                  },
                ),
                SizedBox(height: 5),
                KeySearch(
                  show: hideSearch,
                  onKeySearchChange: (String val) {
                    // pollList(context, service.postDio('${service.pollApi}read', {'skip': 0, 'limit': 100,"keySearch": val}),'');
                    setState(() {
                      keySearch = val;
                    });
                    _onLoading();
                  },
                ),
                SizedBox(height: 10),
                Expanded(
                  child: SmartRefresher(
                    enablePullDown: false,
                    enablePullUp: true,
                    footer: ClassicFooter(
                      loadingText: ' ',
                      canLoadingText: ' ',
                      idleText: ' ',
                      idleIcon: Icon(
                        Icons.arrow_upward,
                        color: Colors.transparent,
                      ),
                    ),
                    controller: _refreshController,
                    onLoading: _onLoading,
                    child: ListView(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      // controller: _controller,
                      children: [poll],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
