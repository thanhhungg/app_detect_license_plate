import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

enum Variant {
  /// FontSize: 36
  h1(36),

  /// FontSize: 30
  h2(30),

  /// FontSize: 28
  h3(28),

  /// FontSize: 24
  h4(24),

  /// FontSize: 20
  h5(20),

  /// FontSize: 18
  h6(18),

  /// FontSize: 16
  h7(16),

  /// FontSize: 15
  h8(15),

  /// FontSize: 14
  medium(14),

  /// FontSize: 13
  mediums(13),

  /// FontSize: 12
  small(12),

  /// FontSize: 11
  xsmall(11),

  /// FontSize: 10
  xxsmall(10),

  /// FontSize: 8
  xxxsmall(8);

  final double fontSize;

  const Variant(this.fontSize);
}

enum FontStyle {
  /// FontWeight.w700
  bold(FontWeight.w700),

  /// FontWeight.w600
  semiBold(FontWeight.w600),

  /// FontWeight.w400
  regular(FontWeight.w400),

  /// FontWeight.w300
  light(FontWeight.w300),

  /// FontWeight.w500
  medium(FontWeight.w500);

  final FontWeight fontWeight;

  const FontStyle(this.fontWeight);
}

class CommonText extends StatelessWidget {
  final Variant? variant;
  final TextDecoration? decoration;
  final int? maxLines;
  final TextStyle? style;
  final TextAlign? textAlign;
  final FontStyle fontStyle;
  final Color? textColor;
  final double opacity;
  final double height;

  final String data;

  const CommonText(
    this.data, {
    Key? key,
    this.variant,
    this.decoration,
    this.maxLines,
    this.style,
    this.textAlign,
    this.fontStyle = FontStyle.regular,
    this.textColor,
    this.opacity = 1,
    this.height = 1.45,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double fontSize = (variant?.fontSize ?? Variant.medium.fontSize).sp;
    double baseline = height < 1
        ? fontSize * 3 / 4
        : height * fontSize - height * fontSize / 4;
    return Padding(
      padding: EdgeInsets.zero,
      child: Baseline(
        baselineType: TextBaseline.alphabetic,
        baseline: baseline,
        child: Text(
          data,
          maxLines: maxLines,
          style: GoogleFonts.lato(
            decoration: decoration,
            fontWeight: fontStyle.fontWeight,
            fontSize: fontSize,
            color: (textColor ?? Colors.black).withOpacity(opacity),
            height: height,
          ).merge(style),
          textAlign: textAlign,
          overflow: maxLines != null ? TextOverflow.ellipsis : null,
        ),
      ),
    );
  }
}
