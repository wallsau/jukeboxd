import 'package:flutter/material.dart';
import 'package:jukeboxd/utils/colors.dart';

class MenuOption extends StatelessWidget {
  MenuOption(
      {Key? key,
      required this.title,
      required this.onChanged,
      required this.shape})
      : super(key: key);
  String title;
  Border shape;
  Function() onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        shape: shape,
        title: Text(title, style: const TextStyle(color: bbarGray)),
        trailing: IconButton(
          icon: const Icon(
            Icons.keyboard_arrow_down_sharp,
            color: bbarGray,
          ),
          onPressed: onChanged,
        ));
  }
}
