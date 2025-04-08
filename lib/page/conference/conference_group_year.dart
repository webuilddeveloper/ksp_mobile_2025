import 'package:flutter/material.dart';
import 'package:ksp/page/conference/conference_list.dart';
import 'package:ksp/shared/api_provider.dart';
import 'package:ksp/widget/header.dart';

class ConferenceGroupYearPage extends StatefulWidget {
  const ConferenceGroupYearPage({Key? key}) : super(key: key);

  @override
  State<ConferenceGroupYearPage> createState() =>
      _ConferenceGroupYearPageState();
}

class _ConferenceGroupYearPageState extends State<ConferenceGroupYearPage> {
  Future<dynamic> _futureModel = Future.value(null);

  @override
  void initState() {
    _futureModel = postDio('${server}m/conference/group/read', {});
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, () => Navigator.pop(context),
          title: 'ประชุมวิชาการออนไลน์'),
      body: FutureBuilder(
        future: _futureModel,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              padding: EdgeInsets.all(15),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) => _buildCard(snapshot.data[index]),
              separatorBuilder: (_, __) => SizedBox(height: 10),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  _buildCard(param) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ConferenceList(
              title: 'ประชุมวิชาการออนไลน์', year: param['title']),
        ),
      ),
      child: Container(
        height: 50,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              color: Colors.black.withOpacity(0.2),
              offset: Offset(-1, 0.75),
            )
          ],
        ),
        child: Text(
          'พ.ศ. ${int.parse(param['title']) + 543}',
          style: TextStyle(
            fontSize: 15,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
