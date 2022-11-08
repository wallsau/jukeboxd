import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:jukeboxd/services/firebase.dart';
import 'package:jukeboxd/utils/colors.dart';

class RateBar extends StatefulWidget {
  RateBar({
    required this.initRating,
    required this.ignoreChange,
    required this.starSize,
    this.id,
    this.type,
    super.key,
  });
  double initRating;
  final bool ignoreChange;
  final double starSize;
  final String? id;
  final String? type;

  @override
  State<RateBar> createState() => _RateBarState();
}

class _RateBarState extends State<RateBar> {
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RatingBar(
        initialRating: widget.initRating,
        ignoreGestures: widget.ignoreChange,
        itemSize: widget.starSize,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemCount: 5,
        glow: false,
        ratingWidget: RatingWidget(
          full: const Icon(Icons.star, color: buttonRed),
          half: const Icon(Icons.star_half, color: buttonRed),
          empty: const Icon(Icons.star_outline, color: buttonRed),
        ),
        onRatingUpdate: (value) {
          setState(() {
            if (_debounce?.isActive ?? false) _debounce?.cancel();
            _debounce = Timer(const Duration(seconds: 1), () {
              DataBase().setRating(value, widget.id!, widget.type);
              widget.initRating = value;
            });
          });
        });
  }
}
