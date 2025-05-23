import 'package:flutter/material.dart';
import 'package:ksp/shared/api_provider.dart';
import 'package:ksp/widget/button.dart';
import 'package:ksp/widget/comment.dart';
import 'package:ksp/widget/content.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// ignore: must_be_immutable
class WelfareForm extends StatefulWidget {
  WelfareForm({
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
  _WelfareForm createState() => _WelfareForm();
}

class _WelfareForm extends State<WelfareForm> {
  late Comment comment;
  late int _limit;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onLoading() async {
    setState(() {
      _limit = _limit + 10;

      comment = Comment(
        code: widget.code,
        url: welfareCommentApi,
        model: post('${welfareCommentApi}read',
            {'skip': 0, 'limit': _limit, 'code': widget.code}),
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
      url: welfareCommentApi,
      model: post('${welfareCommentApi}read',
          {'skip': 0, 'limit': _limit, 'code': widget.code}),
      limit: _limit,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
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
              // Expanded(
              //   child:
              Stack(
                // fit: StackFit.expand,
                // alignment: AlignmentDirectional.bottomCenter,
                // shrinkWrap: true,
                // physics: ClampingScrollPhysics(),
                children: [
                  Content(
                    pathShare: 'content/welfare/',
                    code: widget.code,
                    url: widget.url,
                    model: widget.model,
                    urlGallery: widget.urlGallery,
                    urlRotation: rotationWelfareApi,
                  ),
                  Positioned(
                    right: 0,
                    top: statusBarHeight + 5,
                    child: Container(
                      child: buttonCloseBack(context),
                    ),
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
    );
  }
}
