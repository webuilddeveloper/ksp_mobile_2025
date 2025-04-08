import 'package:flutter/material.dart';
import 'package:ksp/shared/api_provider.dart';
import 'package:ksp/widget/button.dart';
import 'package:ksp/widget/comment.dart';
import 'package:ksp/widget/content.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// ignore: must_be_immutable
class NewsForm extends StatefulWidget {
  NewsForm({
    Key? key,
    required this.url,
    required this.code,
    this.model,
    this.urlComment = '',
    required this.urlGallery,
  }) : super(key: key);

  final String url;
  final String code;
  final dynamic model;
  final String urlComment;
  final String urlGallery;

  @override
  _NewsForm createState() => _NewsForm();
}

class _NewsForm extends State<NewsForm> {
  late Comment comment;
  late int _limit = 0;

  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  void _onLoading() async {
    setState(() {
      _limit = _limit + 10;

      comment = Comment(
        code: widget.code,
        url: newsCommentApi,
        model: postDio('${newsCommentApi}read', {
          'skip': 0,
          'limit': _limit,
          'code': widget.code,
        }),
        limit: _limit,
      );
    });

    await Future.delayed(Duration(milliseconds: 1000));

    _refreshController.loadComplete();
  }

  @override
  void initState() {
    setState(() {
      _limit = 10;
    });

    comment = Comment(
      code: widget.code,
      url: newsCommentApi,
      model: postDio('${newsCommentApi}read', {
        'skip': 0,
        'limit': _limit,
        'code': widget.code,
      }),
      limit: _limit,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
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
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overScroll) {
            return false;
          },
          child: SmartRefresher(
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
            child: ListView(
              shrinkWrap: true,
              children: [
                Stack(
                  children: [
                    Content(
                      pathShare: 'content/news/',
                      code: widget.code,
                      url: widget.url,
                      model: widget.model,
                      urlGallery: widget.urlGallery,
                      urlRotation: rotationNewsApi,
                    ),
                    Positioned(
                      right: 0,
                      top: statusBarHeight + 5,
                      child: Container(child: buttonCloseBack(context)),
                    ),
                  ],
                  // overflow: Overflow.clip,
                ),
                // ),
                widget.urlComment != '' ? comment : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
