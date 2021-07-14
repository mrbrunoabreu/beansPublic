import 'package:flutter/material.dart';

class BeansCustomAppBar extends StatelessWidget {
  final bool isBackButton;
  final Icon leadingIcon;
  final String centerTitle;
  final Icon trailingIcon;
  final VoidCallback trailingIconAction;
  final Color backgroundColor;

  const BeansCustomAppBar({
    this.isBackButton,
    this.leadingIcon,
    this.centerTitle,
    this.trailingIcon,
    this.trailingIconAction,
    this.backgroundColor,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (isBackButton)
            Material(
              color: Colors.white60,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.black,
                  size: 22,
                ),
                onPressed: Navigator.of(context).pop,
              ),
            ),
            const SizedBox(width: 50),
            if (trailingIcon != null)
            Material(
              color: Colors.white60,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: IconButton(
                icon: trailingIcon,
                onPressed: trailingIconAction,
              ),
            )
          ],
        ),
      ),
    );
  }
}