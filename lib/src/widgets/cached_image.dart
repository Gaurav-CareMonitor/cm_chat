import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A versatile image widget that supports loading images from
/// network, memory, asset, and file sources with caching, error handling,
/// placeholder support, and optional tap-to-open functionality.
class CachedImage extends StatelessWidget {
  const CachedImage._({
    required this.imageBuilder,
    required this.borderRadius,
    this.hasAnimation,
    this.url,
    this.bytes,
    this.assetName,
    this.filePath,
    this.heroTag,
    this.enableTapToOpen = false,
    this.onTap,
  });

  /// Factory constructors for various image types

  /// Creates a CachedImage from a network URL
  factory CachedImage.network(
    String? url, {
    double? width,
    double? height,
    BoxFit? fit,
    double borderRadius = 8,
    Widget? placeholder,
    Widget? errorWidget,
    bool? hasAnimation,
    String? heroTag,
    bool enableTapToOpen = false,
    VoidCallback? onTap,
  }) {
    return CachedImage._(
      imageBuilder: (context) {
        if (url == null) {
          return _buildErrorWidget(errorWidget, width, height);
        }
        return ExtendedImage.network(
          url,
          width: width,
          height: height,
          fit: fit,
          maxBytes: 1000 * 1000, // 1MB
          loadStateChanged: (state) => _loadStateChanged(
            state,
            placeholder,
            errorWidget,
            width,
            height,
          ),
          mode: enableTapToOpen ? ExtendedImageMode.gesture : ExtendedImageMode.none,
        );
      },
      url: url,
      borderRadius: borderRadius,
      hasAnimation: hasAnimation,
      heroTag: heroTag,
      enableTapToOpen: enableTapToOpen,
      onTap: onTap,
    );
  }

  /// Creates a CachedImage from memory bytes
  factory CachedImage.memory(
    Uint8List? bytes, {
    double? width,
    double? height,
    BoxFit? fit,
    double borderRadius = 8,
    Widget? placeholder,
    Widget? errorWidget,
    bool? hasAnimation,
    String? heroTag,
    bool enableTapToOpen = false,
    VoidCallback? onTap,
  }) {
    return CachedImage._(
      imageBuilder: (context) {
        if (bytes == null) {
          return _buildErrorWidget(errorWidget, width, height);
        }
        return ExtendedImage.memory(
          bytes,
          width: width,
          height: height,
          fit: fit,
          loadStateChanged: (state) => _loadStateChanged(
            state,
            placeholder,
            errorWidget,
            width,
            height,
          ),
          mode: enableTapToOpen ? ExtendedImageMode.gesture : ExtendedImageMode.none,
        );
      },
      bytes: bytes,
      borderRadius: borderRadius,
      hasAnimation: hasAnimation,
      heroTag: heroTag,
      enableTapToOpen: enableTapToOpen,
      onTap: onTap,
    );
  }

  /// Creates a CachedImage from an asset
  factory CachedImage.asset(
    String? assetName, {
    double? width,
    double? height,
    BoxFit? fit,
    double borderRadius = 8,
    Widget? placeholder,
    Widget? errorWidget,
    bool? hasAnimation,
    String? heroTag,
    bool enableTapToOpen = false,
    VoidCallback? onTap,
  }) {
    return CachedImage._(
      imageBuilder: (context) {
        if (assetName == null) {
          return _buildErrorWidget(errorWidget, width, height);
        }
        return ExtendedImage.asset(
          assetName,
          width: width,
          height: height,
          fit: fit,
          loadStateChanged: (state) => _loadStateChanged(
            state,
            placeholder,
            errorWidget,
            width,
            height,
          ),
          mode: enableTapToOpen ? ExtendedImageMode.gesture : ExtendedImageMode.none,
        );
      },
      assetName: assetName,
      borderRadius: borderRadius,
      hasAnimation: hasAnimation,
      heroTag: heroTag,
      enableTapToOpen: enableTapToOpen,
      onTap: onTap,
    );
  }

  /// Creates a CachedImage from a file
  factory CachedImage.file(
    String? filePath, {
    double? width,
    double? height,
    BoxFit? fit,
    double borderRadius = 8,
    Widget? placeholder,
    Widget? errorWidget,
    bool? hasAnimation,
    String? heroTag,
    bool enableTapToOpen = false,
    VoidCallback? onTap,
  }) {
    return CachedImage._(
      imageBuilder: (context) {
        if (filePath == null) {
          return _buildErrorWidget(errorWidget, width, height);
        }
        return ExtendedImage.file(
          File(filePath),
          width: width,
          height: height,
          fit: fit,
          loadStateChanged: (state) => _loadStateChanged(
            state,
            placeholder,
            errorWidget,
            width,
            height,
          ),
          mode: enableTapToOpen ? ExtendedImageMode.gesture : ExtendedImageMode.none,
        );
      },
      filePath: filePath,
      borderRadius: borderRadius,
      hasAnimation: hasAnimation,
      heroTag: heroTag,
      enableTapToOpen: enableTapToOpen,
      onTap: onTap,
    );
  }

  /// Builder function for the underlying ExtendedImage widget
  final Widget Function(BuildContext) imageBuilder;

  /// Border radius for rounded corners
  final double borderRadius;

  /// Whether to wrap the image with a [Hero] animation
  final bool? hasAnimation;

  /// Optional hero tag for unique identification in [Hero] animation
  final String? heroTag;

  /// Whether to enable tap-to-open functionality
  final bool enableTapToOpen;

  /// Optional callback when the image is tapped
  final VoidCallback? onTap;

  /// Image source URL
  final String? url;

  /// Image source bytes
  final Uint8List? bytes;

  /// Image source asset name
  final String? assetName;

  /// Image source file path
  final String? filePath;

  /// Helper function to handle load state changes (loading, error, completed)
  static Widget? _loadStateChanged(
    ExtendedImageState state,
    Widget? placeholder,
    Widget? errorWidget,
    double? width,
    double? height,
  ) {
    switch (state.extendedImageLoadState) {
      case LoadState.loading:
        return SizedBox(
          height: height,
          width: width,
          child: placeholder ?? _buildPlaceholder(width, height),
        );
      case LoadState.failed:
        return _buildErrorWidget(errorWidget, width, height);

      case LoadState.completed:
        return null;
    }
  }

  /// Default placeholder widget
  static Widget _buildPlaceholder([double? width, double? height]) {
    return Container(
      alignment: Alignment.center,
      width: width,
      height: height,
      decoration: BoxDecoration(color: Colors.grey.shade300),
    );
  }

  /// Default error widget
  static Widget _buildErrorWidget(
    Widget? errorWidget, [
    double? width,
    double? height,
  ]) {
    if (errorWidget != null) {
      return SizedBox(
        height: height,
        width: width,
        child: errorWidget,
      );
    }
    return Container(
      alignment: Alignment.center,
      width: width,
      height: height,
      decoration: BoxDecoration(color: Colors.grey.shade300),
      child: Icon(Icons.error, color: Colors.grey.shade500),
    );
  }

  String get _heroTag =>
      heroTag ?? url ?? bytes?.firstOrNull?.toString() ?? assetName?.toString() ?? filePath?.toString() ?? 'image';

  /// Wraps the image in a [Hero] widget if animation is enabled
  Widget _wrapWithHero(Widget child) {
    if (hasAnimation ?? false) {
      return Hero(tag: _heroTag, child: child);
    }
    return child;
  }

  /// Opens the image in a full-screen slideable view
  void _openImageView(
    BuildContext context,
    Widget image,
    String? url,
    Uint8List? bytes,
    String? assetName,
    String? filePath,
  ) {
    // If no image source is provided, do nothing
    if (url == null && bytes == null && assetName == null && filePath == null) {
      return;
    }
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.transparent,
        pageBuilder: (context, animation1, animation2) => ImageViewerPage(
          sourceUrl: url,
          sourceBytes: bytes,
          sourceAsset: assetName,
          sourceFile: filePath,
          fit: BoxFit.contain,
          heroTag: (hasAnimation ?? false) ? _heroTag : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageWidget = imageBuilder(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: _wrapWithHero(
        enableTapToOpen
            ? GestureDetector(
                onTap: onTap ?? () => _openImageView(context, imageWidget, url, bytes, assetName, filePath),
                child: imageWidget,
              )
            : imageWidget,
      ),
    );
  }
}

/// A fullscreen page for viewing and interacting with images
class ImageViewerPage extends StatefulWidget {
  const ImageViewerPage({
    required this.fit,
    super.key,
    this.sourceUrl,
    this.sourceBytes,
    this.sourceAsset,
    this.sourceFile,
    this.heroTag,
  });

  final String? sourceUrl;
  final Uint8List? sourceBytes;
  final String? sourceAsset;
  final String? sourceFile;
  final BoxFit fit;
  final String? heroTag;

  @override
  State<ImageViewerPage> createState() => _ImageViewerPageState();
}

class _ImageViewerPageState extends State<ImageViewerPage> {
  final StreamController<bool> rebuildSwiper = StreamController<bool>.broadcast();
  bool _showSwiper = true;

  @override
  void dispose() {
    rebuildSwiper.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget image;

    if (widget.sourceUrl != null) {
      image = ExtendedImage.network(
        widget.sourceUrl!,
        fit: widget.fit,
        mode: ExtendedImageMode.gesture,
        enableSlideOutPage: true,
        initGestureConfigHandler: (state) => GestureConfig(inPageView: true, initialScale: 0.8),
      );
    } else if (widget.sourceBytes != null) {
      image = ExtendedImage.memory(
        widget.sourceBytes!,
        fit: widget.fit,
        enableSlideOutPage: true,
        mode: ExtendedImageMode.gesture,
        initGestureConfigHandler: (state) => GestureConfig(inPageView: true, initialScale: 0.8),
      );
    } else if (widget.sourceAsset != null) {
      image = ExtendedImage.asset(
        widget.sourceAsset!,
        fit: widget.fit,
        enableSlideOutPage: true,
        mode: ExtendedImageMode.gesture,
        initGestureConfigHandler: (state) => GestureConfig(inPageView: true, initialScale: 0.8),
      );
    } else if (widget.sourceFile != null) {
      image = ExtendedImage.file(
        File(widget.sourceFile!),
        fit: widget.fit,
        enableSlideOutPage: true,
        mode: ExtendedImageMode.gesture,
        initGestureConfigHandler: (state) => GestureConfig(inPageView: true, initialScale: 0.8),
      );
    } else {
      image = Container();
    }

    final result = widget.heroTag != null
        ? Hero(
            tag: widget.heroTag!,
            child: image,
          )
        : image;

    return Stack(
      fit: StackFit.expand,
      children: [
        ExtendedImageSlidePage(
          onSlidingPage: (state) {
            final showSwiper = !state.isSliding;
            if (showSwiper != _showSwiper) {
              _showSwiper = showSwiper;
              rebuildSwiper.add(_showSwiper);
            }
          },
          slideType: SlideType.wholePage,
          slidePageBackgroundHandler: (offset, pageSize) {
            num opacity = 0;
            opacity = offset.distance / (Offset(pageSize.width, pageSize.height).distance / 2.0);
            return Colors.black.withValues(alpha: min(1, max(1.0 - opacity, 0)));
          },
          slideScaleHandler: (offset, {ExtendedImageSlidePageState? state}) {
            if (state == null) return 0.8;
            final scale = offset.distance / Offset(state.pageSize.width, state.pageSize.height).distance;
            return max(1.0 - scale, 0.8);
          },
          slideEndHandler: (offset, {ScaleEndDetails? details, ExtendedImageSlidePageState? state}) {
            if (state == null) return false;
            return offset.distance > Offset(state.pageSize.width, state.pageSize.height).distance / 3.5;
          },
          child: result,
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: StreamBuilder<bool>(
            stream: rebuildSwiper.stream,
            initialData: _showSwiper,
            builder: (context, snapshot) {
              return AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: snapshot.data! ? 1 : 0,
                child: Container(
                  color: Colors.black.withValues(alpha: 0.5),
                  padding: const EdgeInsets.all(8),
                  child: const SafeArea(
                    top: false,
                    child: Text(
                      'Swipe down to close',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // cross button
        Positioned(
          right: 0,
          top: 0,
          child: StreamBuilder<bool>(
            stream: rebuildSwiper.stream,
            initialData: _showSwiper,
            builder: (context, snapshot) {
              return AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: snapshot.data! ? 1 : 0,
                child: SafeArea(
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
