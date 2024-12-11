import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/common_widgets/generic_image_error.dart';
import 'package:vndb_lite/src/common_widgets/status_label.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/features/settings/presentation/settings_general_state.dart';
import 'package:vndb_lite/src/features/vn/domain/p1.dart';
import 'package:vndb_lite/src/features/vn/domain/p2.dart';
import 'package:vndb_lite/src/features/vn_item/presentation/detail_non_summary/vn_record_controller.dart';
import 'package:vndb_lite/src/util/check_media_cache.dart';
import 'package:vndb_lite/src/util/custom_cache_manager.dart';
import 'package:vndb_lite/src/util/widget_zoom/widget_zoom.dart';

class VnDetailTopHeaderCover extends ConsumerStatefulWidget {
  const VnDetailTopHeaderCover({
    super.key,
    required this.p1,
    required this.p2,
    required this.animationController,
  });

  final VnDataPhase01 p1;
  final VnDataPhase02 p2;
  final AnimationController animationController;

  @override
  ConsumerState<VnDetailTopHeaderCover> createState() => _VnDetailTopHeaderCoverState();
}

class _VnDetailTopHeaderCoverState extends ConsumerState<VnDetailTopHeaderCover> {
  bool _imageCached = false;
  bool _censorCover = false;

  @override
  void initState() {
    super.initState();
    _censorCover = _coverNeedCensor;

    // Checks whether vn image already cached or not.
    didMediaCache(widget.p1.id).then((value) {
      _imageCached = value;
    });
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  bool get _vnHasCover {
    return widget.p1.image != null && widget.p1.image!.url != null;
  }

  bool get _coverNeedCensor {
    final settings = ref.read(settingsGeneralStateProvider);

    if (settings.showCoverCensor) {
      if (_vnMatchCensorRequirement) return true;
    }

    return false;
  }

  bool get _vnMatchCensorRequirement {
    return (widget.p1.image!.sexual ?? 0) >= 1 || (widget.p1.image!.violence ?? 0) >= 1;
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Widget _imgCover({required bool isCensor}) {
    return CachedNetworkImage(
      imageUrl: (_vnHasCover && !_imageCached) ? widget.p1.image!.url! : '',
      fit: BoxFit.cover,
      height: responsiveUI.own(0.6),
      filterQuality: FilterQuality.high,
      placeholder: (context, str) => SizedBox(width: responsiveUI.own(0.4), height: responsiveUI.own(0.45)),
      errorWidget: (context, url, error) => const GenericErrorImage(),
      cacheKey: widget.p1.id,
      cacheManager: (!App.isInSearchScreen) ? CustomCacheManager() : null,
      maxHeightDiskCache: (isCensor) ? 15 : (MediaQuery.sizeOf(context).height * 2.5).toInt(),
      maxWidthDiskCache: (isCensor) ? 15 : (MediaQuery.sizeOf(context).width * 2.5).toInt(),
    );
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: responsiveUI.own(0.045)),
      constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.45),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: ScaleTransition(
          scale: widget.animationController.drive(CurveTween(curve: Curves.ease)),
          child: FadeTransition(
            opacity: widget.animationController.drive(CurveTween(curve: Curves.linear)),
            child: Stack(
              children: [
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Cover
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Card(
                    elevation: 10,
                    margin: EdgeInsets.zero,
                    clipBehavior: Clip.hardEdge,
                    color: const Color.fromARGB(120, 0, 0, 0),
                    shadowColor: App.themeColor.primary.withOpacity(0.8),
                    child: Consumer(
                      builder: (context, ref, child) {
                        return GestureDetector(
                          onDoubleTap: () {
                            setState(() {
                              _censorCover = !_censorCover;
                            });
                          },
                          child: WidgetZoom(
                            heroAnimationTag: widget.p1.id,
                            zoomWidget: Center(
                              child: _imgCover(isCensor: _censorCover),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Status label
                Consumer(
                  builder: (context, ref, child) {
                    final record = ref.watch(vnRecordControllerProvider(widget.p1.id));
                    String status = "";

                    // If vn exists in collection, then show the status label.
                    if (record != null) status = record.status;
                    return StatusLabel(labelCode: status);
                  },
                ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
              ],
            ),
          ),
        ),
      ),
    );
  }
}
