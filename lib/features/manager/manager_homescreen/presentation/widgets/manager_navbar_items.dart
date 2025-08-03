import 'package:event_connect/features/manager/manager_homescreen/presentation/cubit/manager_homescreen_cubit.dart';
import 'package:flutter/material.dart';

BottomNavigationBarItem bottomNavBarItem({
  required ManagerHomescreenState state,
  required ManagerHomescreenCubit? cubit,
  required IconData? icon,
  required String itemLabel,
  required int itemIndex,
}) {
  return BottomNavigationBarItem(
    icon: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: state.currentIndex == itemIndex
            ? const Color(0xFF6C63FF).withAlpha((0.1 * 255).round())
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: icon != null
          ? Icon(icon)
          : CircleAvatar(
              radius: 12,
              backgroundColor: Colors.purple.shade100,
              child: state.imageFile != null
                  ? CircleAvatar(
                      radius: 12,
                      backgroundImage: cubit!.getPicturePath(state: state),
                    )
                  : const Icon(Icons.person, color: Colors.white, size: 16),
            ),
    ),
    label: itemLabel,
  );
}
