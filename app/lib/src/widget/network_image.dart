import 'package:flutter/material.dart';

class NetworkImage extends StatelessWidget {
  final String src;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final Widget errorWidget;

  const NetworkImage(
      {Key? key,
      required this.src,
      this.fit,
      this.width,
      this.height,
      this.errorWidget = const SizedBox.shrink()})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Builder(builder: (context) {
        try {
          return Image.network(
            src,
            fit: fit,
            width: width,
            height: height,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded.toInt() /
                          loadingProgress.expectedTotalBytes!.toInt()
                      : null,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) => errorWidget,
          );
        } catch (e) {
          return errorWidget;
        }
      }),
    );
  }
}
