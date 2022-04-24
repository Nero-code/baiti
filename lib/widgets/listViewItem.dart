import 'package:flutter/material.dart';

class SimpleListItem extends StatelessWidget {
  const SimpleListItem({
    Key? key,
    required this.title,
    this.subTitle,
    this.leading,
    this.trailling,
    this.rtl = false,
    this.checkMode = false,
    this.onPressed,
    this.onLongPressed,
    this.isChecked = false,
    required this.id,
  }) : super(key: key);

  final String title;
  final String? subTitle;
  final Widget? leading, trailling;
  final bool rtl, checkMode;
  final onPressed, onLongPressed;
  final bool isChecked;
  final int id;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      onLongPress: onLongPressed,
      child: Column(
        children: [
          Row(
            textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (leading != null)
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: leading,
                )
              else
                Container(
                  width: 15,
                ),
              Container(
                width: MediaQuery.of(context).size.width / 1.55,
                child: Column(
                  textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    if (subTitle != null) Text(subTitle.toString()),
                  ],
                ),
              ),
              if (checkMode)
                Checkbox(
                  onChanged: (_) {
                    onPressed();
                  },
                  value: isChecked,
                ),
            ],
          ),
          Container(
            height: 1,
            width: MediaQuery.of(context).size.width - 20,
            color: Colors.black12,
          ),
        ],
      ),
    );
  }
}
