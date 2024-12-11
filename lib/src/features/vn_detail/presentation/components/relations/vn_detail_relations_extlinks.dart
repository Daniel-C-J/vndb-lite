import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/common_widgets/generic_shadowy_text.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/features/vn/domain/p3.dart';

class VnDetailRelationsExtlinks extends StatefulWidget {
  const VnDetailRelationsExtlinks({
    super.key,
    required this.p3,
  });

  final VnDataPhase03 p3;

  @override
  State<VnDetailRelationsExtlinks> createState() => _VnDetailRelationsExtlinksState();
}

class _VnDetailRelationsExtlinksState extends State<VnDetailRelationsExtlinks> {
  bool _showMoreLinks = false;

  Stream<List<Widget>> get _extLinks async* {
    List<Widget> tempExtLinks = [];

    for (String extlink in (widget.p3.extlinks ?? [])) {
      // Get only the first 5 links to be shown and add an additional widget.
      // (See below additional widget, why 5?)
      if (tempExtLinks.length >= 6) {
        if (!_showMoreLinks) break;
      }

      final Uri extLinked = Uri.parse(extlink);
      await Future.microtask(() {
        tempExtLinks.add(
          Tooltip(
            message: extlink,
            child: InkWell(
              onTap: () => launchUrlString(extlink),
              child: ShadowText(extLinked.host),
            ),
          ),
        );
      });

      yield tempExtLinks;
    }

    if (tempExtLinks.isEmpty) {
      tempExtLinks.add(ShadowText('--'));
      yield tempExtLinks;
      return;
    }

    // Adds additional widget to show less or show more of the external links.
    if (tempExtLinks.length >= 6) {
      // Removing the last if not showing full links, eventually will be replaced by the additional widget.
      if (!_showMoreLinks) tempExtLinks.removeLast();

      tempExtLinks.add(
        InkWell(
          onTap: () {
            setState(() => _showMoreLinks = !_showMoreLinks);
          },
          child: ShadowText(
            (_showMoreLinks) ? 'Show Less' : 'Show More',
            fontWeight: FontWeight.bold,
            fontSize: responsiveUI.normalSize,
            color: App.themeColor.secondary,
            shadows: [
              Shadow(
                color: Color.alphaBlend(
                  Colors.black.withOpacity(0.5),
                  App.themeColor.primary,
                ),
                blurRadius: 15,
              )
            ],
          ),
        ),
      );

      yield tempExtLinks;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShadowText(
          'External Links',
          fontSize: responsiveUI.own(0.045),
          fontWeight: FontWeight.bold,
        ),
        SizedBox(height: responsiveUI.own(0.01)),
        StreamBuilder(
          stream: _extLinks,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ShadowText('Loading...');
            }

            if (snapshot.hasError) {
              return ShadowText('Something went wrong.', color: Colors.red);
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: snapshot.data,
            );
          },
        ),
      ],
    );
  }
}
