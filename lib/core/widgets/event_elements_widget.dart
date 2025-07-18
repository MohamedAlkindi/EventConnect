import 'dart:io';

import 'package:flutter/material.dart';

Widget returnEventPicture({
  required String eventPictureLink,
}) {
  return Container(
    height: 350,
    width: double.infinity,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: eventPictureLink.contains("https:/")
            ? NetworkImage(
                "$eventPictureLink?updated=${DateTime.now().millisecondsSinceEpoch}")
            : FileImage(File(eventPictureLink)),
        fit: BoxFit.fill,
      ),
    ),
  );
}

Widget returnEventMainElements({
  required String eventName,
  required String eventLocation,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      // Name
      Expanded(
        child: Text(
          eventName,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // Location
      Row(
        children: [
          const Icon(Icons.location_on, size: 16),
          const SizedBox(width: 4),
          Text(
            eventLocation,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ],
      ),
    ],
  );
}

Widget returnEventElements({
  required String text,
  required IconData icon,
  IconData? icon2,
}) {
  return Row(
    children: [
      Icon(icon, size: 16),
      const SizedBox(width: 4),
      if (icon2 != null) ...[
        Icon(icon2, size: 16),
        const SizedBox(width: 4),
        // const SizedBox(width: 16),
      ],
      Text(
        text,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    ],
  );
}

Widget returnEventDescription({
  required String description,
}) {
  return _EventDescriptionWidget(description: description);
}

class _EventDescriptionWidget extends StatefulWidget {
  final String description;

  const _EventDescriptionWidget({required this.description});

  @override
  State<_EventDescriptionWidget> createState() =>
      _EventDescriptionWidgetState();
}

class _EventDescriptionWidgetState extends State<_EventDescriptionWidget> {
  bool isExpanded = false;

  bool get _shouldShowButton => widget.description.length > 100;

  @override
  Widget build(BuildContext context) {
    final showButton = _shouldShowButton;
    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white.withAlpha((0.8 * 255).round()),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha((0.1 * 255).round()),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Text(
                widget.description,
                maxLines: showButton && !isExpanded ? 2 : null,
                overflow:
                    showButton && !isExpanded ? TextOverflow.ellipsis : null,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ),
            if (showButton) ...[
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Text(
                  isExpanded ? 'Read less' : 'Read more...',
                  style: TextStyle(
                    color: Colors.blue.shade600,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

Widget returnEventButton({
  required String buttonText,
  required void Function() onPressed,
}) {
  return Container(
    padding: const EdgeInsets.all(7),
    width: double.infinity,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      child: Text(
        buttonText,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
