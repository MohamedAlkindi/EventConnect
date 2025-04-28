import 'package:flutter/material.dart';

Widget returnEventPicture({
  required String eventPictureLink,
}) {
  return Container(
    height: 200,
    width: double.infinity,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: NetworkImage(eventPictureLink),
        fit: BoxFit.cover,
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
          Text(eventLocation),
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
      Text(text),
    ],
  );
}

Widget returnEventDescription({
  required String description,
}) {
  return Text(
    description,
    maxLines: 3,
    overflow: TextOverflow.ellipsis,
  );
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
