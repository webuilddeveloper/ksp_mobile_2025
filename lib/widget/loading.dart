import 'package:flutter/material.dart';
import 'package:ksp/widget/color_loader.dart';

loadingImageNetwork(String? url, {BoxFit? fit, double? height, double? width}) {
  if (url == null) url = '';
  return Image.network(
    url,
    fit: BoxFit.cover,
    height: height,
    width: width,
    loadingBuilder: (
      BuildContext context,
      Widget child,
      ImageChunkEvent? loadingProgress,
    ) {
      if (loadingProgress == null) return child;
      return Center(
        child:
            loadingProgress.expectedTotalBytes != null
                ? ColorLoader3(radius: 15, dotRadius: 6)
                : Container(),
      );
    },
  );
}

class ListContentHorizontalLoading extends StatefulWidget {
  // CardLoading({Key key, this.title}) : super(key: key);

  // final String title;

  @override
  _ListContentHorizontalLoading createState() =>
      _ListContentHorizontalLoading();
}

class _ListContentHorizontalLoading extends State<ListContentHorizontalLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  dispose() {
    _controller.dispose(); // you need this
    super.dispose();
  }

  Animatable<Color?> background = TweenSequence<Color?>([
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
        begin: Colors.black.withAlpha(20),
        end: Colors.black.withAlpha(50),
      ),
    ),
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
        begin: Colors.black.withAlpha(50),
        end: Colors.black.withAlpha(20),
      ),
    ),
  ]);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),

      width: 150,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            padding: EdgeInsets.all(5),
            alignment: Alignment.topLeft,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: new BorderRadius.circular(5),
              color: background.evaluate(
                AlwaysStoppedAnimation(_controller.value),
              ),
            ),
          );
        },
      ),
    );
  }
}

class LoadingTween extends StatefulWidget {
  LoadingTween({
    Key? key,
    this.height = 150,
    this.width = 150,
    this.borderRadius = 5,
    this.child,
  }) : super(key: key);

  final double height;
  final double width;
  final double borderRadius;
  final Widget? child;

  @override
  _LoadingTween createState() => _LoadingTween();
}

class _LoadingTween extends State<LoadingTween>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  dispose() {
    _controller.dispose(); // you need this
    super.dispose();
  }

  Animatable<Color?> background = TweenSequence<Color?>([
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
        begin: Colors.black.withAlpha(20),
        end: Colors.black.withAlpha(50),
      ),
    ),
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
        begin: Colors.black.withAlpha(50),
        end: Colors.black.withAlpha(20),
      ),
    ),
  ]);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Container(
            padding: EdgeInsets.all(5),
            alignment: Alignment.topLeft,
            height: widget.height,
            width: widget.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              color: background.evaluate(
                AlwaysStoppedAnimation(_controller.value),
              ),
            ),
            child: widget.child,
          );
        },
      ),
    );
  }
}

loadingImageNetworkClipRRect(
  String url, {
  BoxFit? fit,
  double? height,
  double? width,
}) {
  return ClipRRect(
    child: Image.network(
      url,
      fit: BoxFit.fill,
      height: height,
      width: width,
      loadingBuilder: (
        BuildContext context,
        Widget child,
        ImageChunkEvent? loadingProgress,
      ) {
        if (loadingProgress == null) return child;
        return Center(
          child:
              loadingProgress.expectedTotalBytes != null
                  ? ColorLoader3(radius: 15, dotRadius: 6)
                  : Container(),
        );
      },
    ),
  );
}
