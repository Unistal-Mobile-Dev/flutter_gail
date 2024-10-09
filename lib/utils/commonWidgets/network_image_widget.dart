import 'package:flutter/material.dart';

class NetworkImageWidget extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit? fit;

  const NetworkImageWidget(
      {super.key, required this.imageUrl, this.height, this.width, this.fit});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl.toString(),
      height: height,
      width: width,
      fit: fit ?? BoxFit.cover,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
    );
  }
}
