import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class StyleRes {
  static const dataTextStyle = TextStyle(
    color: Colors.black,
    fontSize: 12,
  );

  static Widget inputLabelWithPadding(String label) => Padding(
        padding: const EdgeInsets.fromLTRB(5.0, 10.0, 0.0, 5.0),
        child: Text(
          label,
          style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
        ),
      );

  static InputDecoration formFieldDecor({
    Icon? icon,
    Widget? suffix,
    String? hintText,
    Widget? label,
  }) =>
      InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
        icon: icon,
        suffix: suffix,
        fillColor: Colors.transparent,
        hintText: hintText,
        label: label,
        labelStyle: const TextStyle(
          fontSize: 14,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      );

  static TextStyle inputTextSuffixStyle() => const TextStyle(
        fontSize: 12,
        color: Colors.black45,
      );

  static AppBar defaultStyledAppBar({
    void Function()? onBackPressed,
    required String title,
    PreferredSizeWidget? bottom,
    List<Widget>? trailings,
  }) {
    return AppBar(
      leading: onBackPressed == null
          ? null
          : IconButton(
              icon: const Icon(
                CupertinoIcons.back,
                color: Colors.black,
              ),
              onPressed: () => onBackPressed(),
            ),
      elevation: 0,
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: const TextStyle(fontSize: 20, color: Colors.black),
      ),
      bottom: bottom,
      actions: trailings,
    );
  }

  static LinearGradient shimmerGradient({List<Color>? colors}) => LinearGradient(
        colors: colors ??
            [
              const Color(0xFFEBEBF4),
              const Color(0xFFF4F4F4),
              const Color(0xFFEBEBF4),
            ],
        stops: const [0.2, 0.5, 0.8],
        begin: const Alignment(-1.0, -0.3),
        end: const Alignment(1.0, 0.3),
        tileMode: TileMode.clamp,
      );
}

class CustomSnackbar {
  static SnackBar success(String content) => customSnackBar("OK!", content, ContentType.success);
  static SnackBar failure(String content) => customSnackBar("Uh oh!", content, ContentType.failure);
  static SnackBar warning(String content) => customSnackBar("Chú ý!", content, ContentType.warning);
  static SnackBar help(String content) => customSnackBar("Thông tin", content, ContentType.help);

  static SnackBar customSnackBar(String title, String content, ContentType type) => SnackBar(
        content: AwesomeSnackbarContent(
          title: title,
          message: content,
          contentType: type,
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: Colors.transparent,
      );
}
