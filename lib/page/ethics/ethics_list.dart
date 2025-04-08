import 'package:flutter/material.dart';
import 'package:ksp/page/ethics/ethics_list_vertical.dart';
import 'package:ksp/shared/api_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ksp/widget/header.dart';
import 'package:ksp/widget/key_search.dart';
import 'package:ksp/widget/tab_category.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class EthicsList extends StatefulWidget {
  EthicsList({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _EthicsList createState() => _EthicsList();
}

class _EthicsList extends State<EthicsList> {
  late EthicsListVertical gridView;
  final txtDescription = TextEditingController();
  bool hideSearch = true;
  String keySearch = '';
  String category = '';
  int _limit = 0;
  Future<dynamic> _futureCategory = Future.value(null);

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final storage = new FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _onLoading();
    // gridView = new EthicsListVertical(
    //   site: 'DDPM',
    //   model: service
    //       .postDio('${ethicsApi}read', {'skip': 0, 'limit': _limit}),
    // );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onLoading() async {
    // var profileCode = await storage.read(key: 'profileCode9');
    // if (profileCode != '' && profileCode != null) {
    setState(() {
      _limit = _limit + 10;
      _futureCategory = postCategory(
        '${ethicsCategoryApi}read',
        {
          'skip': 0,
          'limit': 100,
          // 'profileCode': profileCode,
        },
      );
      gridView = new EthicsListVertical(
        model: postDio('${ethicsApi}read', {
          'skip': 0,
          'limit': _limit,
          'category': category,
          "keySearch": keySearch,
          // 'profileCode': profileCode
        }),
      );
    });
    // }

    await Future.delayed(Duration(milliseconds: 1000));

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
        body: new GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Column(
            children: [
              SizedBox(height: 5),
              CategorySelector(
                model: _futureCategory,
                onChange: (String val) {
                  setState(
                    () {
                      category = val;
                    },
                  );
                  _onLoading();
                },
              ),
              SizedBox(
                height: 5.0,
              ),
              KeySearch(
                show: hideSearch,
                onKeySearchChange: (String val) {
                  setState(
                    () {
                      keySearch = val;
                    },
                  );
                  _onLoading();
                },
              ),
              SizedBox(
                height: 10.0,
              ),
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
                    children: [gridView],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
