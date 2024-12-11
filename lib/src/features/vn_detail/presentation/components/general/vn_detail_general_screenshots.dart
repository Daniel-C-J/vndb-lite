import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/common_widgets/custom_button.dart';
import 'package:vndb_lite/src/common_widgets/generic_image_error.dart';
import 'package:vndb_lite/src/common_widgets/generic_shadowy_text.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/features/vn/domain/others.dart';
import 'package:vndb_lite/src/features/vn/domain/p2.dart';
import 'package:vndb_lite/src/features/vn_detail/presentation/components/general/vn_detail_screenshots_state.dart';
import 'package:vndb_lite/src/util/alt_provider_reader.dart';
import 'package:vndb_lite/src/util/widget_zoom/widget_zoom.dart';

class VnDetailGeneralScreenshots extends StatefulWidget {
  const VnDetailGeneralScreenshots({super.key, required this.p2});

  final VnDataPhase02 p2;

  @override
  State<VnDetailGeneralScreenshots> createState() => _VnDetailGeneralScreenshotsState();
}

class _VnDetailGeneralScreenshotsState extends State<VnDetailGeneralScreenshots> {
  bool _screenshotsContentExplicit = false;

  List<String> get _screenshotsUrl {
    final List<String> screenshotsUrl = [];

    for (VnImage screenshot in (widget.p2.screenshots ?? [])) {
      if (!_screenshotsContentExplicit) {
        if (screenshot.sexual! <= 1 && screenshot.violence! <= 1) {
          screenshotsUrl.add(screenshot.url!);
        }

        continue;
      }

      screenshotsUrl.add(screenshot.url!);
    }

    return screenshotsUrl;
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Widget _screenshotContentButton({
    required bool contentLevelExplicit,
    required Color color,
    required String title,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: responsiveUI.own(0.01),
      ),
      child: Opacity(
        opacity: (contentLevelExplicit)
            ? (_screenshotsContentExplicit)
                ? 1
                : 0.7
            : (!_screenshotsContentExplicit)
                ? 1
                : 0.7,
        child: CustomButton(
          onTap: () {
            setState(() {
              _screenshotsContentExplicit = (contentLevelExplicit) ? true : false;
            });
          },
          size: EdgeInsets.symmetric(
            horizontal: responsiveUI.own(0.025),
          ),
          color: (contentLevelExplicit)
              ? (_screenshotsContentExplicit)
                  ? color
                  : Colors.grey
              : (!_screenshotsContentExplicit)
                  ? color
                  : Colors.grey,
          content: ShadowText(title),
        ),
      ),
    );
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  @override
  Widget build(BuildContext context) {
    final List<String> screenshotsUrl = _screenshotsUrl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
        Wrap(
          children: [
            ShadowText('Content level: '),
            _screenshotContentButton(contentLevelExplicit: false, color: Colors.green, title: 'Safe'),
            _screenshotContentButton(contentLevelExplicit: true, color: Colors.red, title: 'Explicit'),
          ],
        ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Screenshot image swipe
        SizedBox(height: responsiveUI.own(0.03)),
        (screenshotsUrl.isEmpty)
            ? ShadowText('--')
            : Container(
                alignment: Alignment.center,
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).width * 0.55,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Swiper(
                    scrollDirection: Axis.horizontal,
                    itemCount: screenshotsUrl.length,
                    axisDirection: AxisDirection.right,
                    pagination: SwiperPagination(
                      alignment: Alignment.bottomCenter,
                      builder: DotSwiperPaginationBuilder(
                        color: const Color.fromARGB(140, 160, 160, 160),
                        activeColor: App.themeColor.secondary,
                        activeSize: 14,
                        size: 8,
                      ),
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return WidgetZoom(
                        onTap: () {
                          SchedulerBinding.instance.addPostFrameCallback((_) {
                            ref_.read(vnDetailScreenshotStateProvider.notifier).click = true;
                          });
                        },
                        onExit: () {
                          SchedulerBinding.instance.addPostFrameCallback((_) {
                            ref_.read(vnDetailScreenshotStateProvider.notifier).click = false;
                          });
                        },
                        heroAnimationTag: 'vnScreenshots$index',
                        zoomWidget: Consumer(
                          builder: (context, ref, child) {
                            final imgClicked = ref.watch(vnDetailScreenshotStateProvider);

                            return CachedNetworkImage(
                              imageUrl: screenshotsUrl[index],
                              filterQuality: FilterQuality.high,
                              fit: (imgClicked) ? null : BoxFit.cover,
                              height: (imgClicked) ? responsiveUI.own(0.9) : responsiveUI.own(0.6),
                              placeholder: (context, str) =>
                                  SizedBox(width: responsiveUI.own(0.4), height: responsiveUI.own(0.2)),
                              errorWidget: (context, url, error) => const GenericErrorImage(),
                              maxHeightDiskCache: (MediaQuery.sizeOf(context).height * 1.75).toInt(),
                              maxWidthDiskCache: (MediaQuery.sizeOf(context).width * 1.75).toInt(),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
      ],
    );
  }
}
