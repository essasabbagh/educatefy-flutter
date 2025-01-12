import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:template/core/log/app_log.dart';
import 'package:template/core/themes/app_colors.dart';

import 'placeholder_image.dart';

class CachedImage extends StatelessWidget {
  const CachedImage({
    super.key,
    this.width,
    this.height,
    required this.imageUrl,
  });

  final double? width;
  final double? height;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    // if (!imageUrl.isURLImage) {
    //   return PlaceHolderImage(
    //     height: height,
    //     width: width,
    //   );
    // }
    return CachedNetworkImage(
      width: width,
      height: height,
      fit: BoxFit.cover,
      imageUrl: imageUrl,
      errorWidget: (context, val, _) => PlaceHolderImage(
        height: height,
        width: width,
      ),
      errorListener: (value) {
        AppLog.error(
          '$value',
          'Cached Image',
          {
            'imageUrl': imageUrl,
          },
        );
      },
      progressIndicatorBuilder: (context, url, downloadProgress) {
        return Center(
          child: CircularProgressIndicator.adaptive(
            strokeWidth: 1,
            strokeCap: StrokeCap.round,
            value: downloadProgress.progress,
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppColors.primaryColor,
            ),
          ),
        );
      },
    );
  }
}
