import 'package:flutter/material.dart';
import 'package:galaxia/theme/theme.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TimelineItem extends StatefulWidget {
  final bool completed;
  final String time;
  final String day;
  final String title;
  final String location;
  const TimelineItem(
      {Key? key,
      required this.completed,
      required this.day,
      required this.time,
      required this.title,
      required this.location})
      : super(key: key);

  @override
  TimelineItemState createState() => TimelineItemState();
}

class TimelineItemState extends State<TimelineItem> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return TimelineTile(
      isFirst: false,
      beforeLineStyle: LineStyle(
          color: widget.completed ? primary[500]! : grayscale[200]!,
          thickness: 2),
      alignment: TimelineAlign.manual,
      lineXY: 0.24,
      endChild: Padding(
        padding: EdgeInsets.only(left: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.location,
              style: TextStyle(color: grayscale[500]),
              softWrap: true,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              widget.title,
              softWrap: true,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      startChild: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.day,
            style:
                TextStyle(fontWeight: FontWeight.bold, fontSize: width * 0.028),
          ),
          Text(
            widget.time,
            style: TextStyle(color: grayscale[500], fontSize: width * 0.024),
          )
        ],
      ),
      indicatorStyle: IndicatorStyle(
          color: widget.completed ? primary[500]! : grayscale[200]!,
          width: width * 0.06),
    );
  }
}
