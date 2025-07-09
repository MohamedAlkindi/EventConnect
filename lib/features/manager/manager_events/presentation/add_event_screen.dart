import 'dart:io';
import 'dart:ui';

import 'package:event_connect/core/utils/loading_dialog.dart';
import 'package:event_connect/core/utils/message_dialogs.dart';
import 'package:event_connect/features/manager/manager_events/presentation/cubit/add_event_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:event_connect/core/utils/localization_extensions.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventState();
}

class _AddEventState extends State<AddEventScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _dateTimeController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _dateTimeController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateTimeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddEventCubit>();
    return Scaffold(
      body: BlocListener<AddEventCubit, AddEventState>(
        listener: (context, state) {
          if (state is ManagerEventsLoading) {
            showLoadingDialog(context);
          } else if (state is EventAddedSuccessfully) {
            hideLoadingDialog(context);
            showMessageDialog(
              context: context,
              icon: Icons.check_circle_outline_rounded,
              titleText: AppLocalizations.of(context)!.eventAddSuccessTitle,
              contentText: AppLocalizations.of(context)!.eventAddSuccessContent,
              iconColor: Colors.green,
              buttonText: AppLocalizations.of(context)!.okay,
              onPressed: () {
                Navigator.pop(context);
              },
            );
          } else if (state is AddEventError) {
            hideLoadingDialog(context);
            final l10n = AppLocalizations.of(context)!;
            final errorMsg = l10n.tryTranslate(state.message);
            showErrorDialog(
              context: context,
              message: errorMsg,
            );
          }
        },
        child: Stack(
          children: [
            // Gradient background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFe0e7ff),
                    Color(0xFFfceabb),
                    Color(0xFFf8b6b8)
                  ],
                ),
              ),
            ),

            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 22.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha((0.18 * 255).round()),
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                              color:
                                  Colors.black.withAlpha((0.2 * 255).round()),
                              width: 1.2),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.white.withAlpha((0.3 * 255).round()),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          // mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.arrow_back_rounded),
                                  color: Colors.black,
                                  // iconSize: 28,
                                  tooltip: 'Back',
                                ),
                                Text(
                                  AppLocalizations.of(context)!.addNewEvent,
                                  style: GoogleFonts.poppins(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF6C63FF),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 35),
                            // Event Image Container
                            Stack(
                              children: [
                                Container(
                                  width: 500,
                                  height: 300,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black
                                            .withAlpha((0.08 * 255).round()),
                                        blurRadius: 10,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child:
                                      BlocBuilder<AddEventCubit, AddEventState>(
                                    builder: (context, state) {
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(22),
                                        child: cubit.eventImage != null
                                            ? Image.file(
                                                File(cubit.eventImage!.path),
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: double.infinity,
                                              )
                                            : Container(
                                                color: const Color.fromARGB(
                                                    255, 230, 232, 241),
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.event,
                                                    size: 64,
                                                    color: Color(0xFF6C63FF),
                                                  ),
                                                ),
                                              ),
                                      );
                                    },
                                  ),
                                ),
                                Positioned(
                                  bottom: 3,
                                  right: 3,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF6C63FF),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: IconButton(
                                      onPressed: cubit.pickImage,
                                      icon: const Icon(
                                        Icons.image,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
                            // Form Card
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withAlpha((0.1 * 255).round()),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Name
                                  TextField(
                                    controller: _nameController,
                                    maxLength: 20,
                                    decoration: InputDecoration(
                                      labelText: AppLocalizations.of(context)!
                                          .eventName,
                                      hintText: AppLocalizations.of(context)!
                                          .eventNameHint,
                                      labelStyle: GoogleFonts.poppins(
                                          color: Colors.grey),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: Color(0xFF6C63FF),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: Color(0xFF6C63FF),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  // Description
                                  TextField(
                                    controller: _descriptionController,
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                      labelText: AppLocalizations.of(context)!
                                          .description,
                                      hintText: AppLocalizations.of(context)!
                                          .descriptionHint,
                                      labelStyle: GoogleFonts.poppins(
                                          color: Colors.grey),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: Color(0xFF6C63FF),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: Color(0xFF6C63FF),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  // Date & Time
                                  TextField(
                                    controller: _dateTimeController,
                                    readOnly: true,
                                    onTap: () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2020),
                                        lastDate: DateTime(2100),
                                      );
                                      if (pickedDate != null) {
                                        TimeOfDay? pickedTime =
                                            await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        );
                                        if (pickedTime != null) {
                                          final dt = DateTime(
                                            pickedDate.year,
                                            pickedDate.month,
                                            pickedDate.day,
                                            pickedTime.hour,
                                            pickedTime.minute,
                                          );
                                          _dateTimeController.text =
                                              "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} ${pickedTime.format(context)}";
                                        }
                                      }
                                    },
                                    decoration: InputDecoration(
                                      labelText: AppLocalizations.of(context)!
                                          .dateAndTime,
                                      hintText: AppLocalizations.of(context)!
                                          .dateAndTimeHint,
                                      labelStyle: GoogleFonts.poppins(
                                          color: Colors.grey),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: Color(0xFF6C63FF),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: Color(0xFF6C63FF),
                                        ),
                                      ),
                                      suffixIcon: const Icon(
                                          Icons.calendar_today_rounded,
                                          color: Color(0xFF6C63FF)),
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  // Category Dropdown
                                  DropdownButtonFormField<String>(
                                    value: cubit.selectedCategory,
                                    decoration: InputDecoration(
                                      labelText: AppLocalizations.of(context)!
                                          .category,
                                      labelStyle: GoogleFonts.poppins(
                                          color: Colors.grey),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: Color(0xFF6C63FF),
                                        ),
                                      ),
                                    ),
                                    items:
                                        cubit.categories.map((String category) {
                                      return DropdownMenuItem<String>(
                                        value: category,
                                        child: Text(
                                          cubit.getCategoryDisplay(category,
                                              AppLocalizations.of(context)!),
                                          style: GoogleFonts.poppins(),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String? newCategory) {
                                      cubit.selectCategoty(newCategory);
                                    },
                                  ),
                                  const SizedBox(height: 18),
                                  // Location Dropdown
                                  DropdownButtonFormField<String>(
                                    value: cubit.selectedLocation,
                                    decoration: InputDecoration(
                                      labelText: AppLocalizations.of(context)!
                                          .location,
                                      labelStyle: GoogleFonts.poppins(
                                          color: Colors.grey),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: Color(0xFF6C63FF),
                                        ),
                                      ),
                                    ),
                                    items: cubit.yemeniCities
                                        .map((String location) {
                                      return DropdownMenuItem<String>(
                                        value: location,
                                        child: Text(
                                          cubit.getCityDisplay(location,
                                              AppLocalizations.of(context)!),
                                          style: GoogleFonts.poppins(),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String? newLocation) {
                                      cubit.selectLocation(newLocation);
                                    },
                                  ),
                                  const SizedBox(height: 18),
                                  // Gender Restriction Dropdown
                                  DropdownButtonFormField<String>(
                                    value: cubit.selectedGenderRestriction,
                                    decoration: InputDecoration(
                                      labelText: AppLocalizations.of(context)!
                                          .genderRestriction,
                                      labelStyle: GoogleFonts.poppins(
                                          color: Colors.grey),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: Color(0xFF6C63FF),
                                        ),
                                      ),
                                    ),
                                    items: cubit.genderRestrictions
                                        .map((String gender) {
                                      return DropdownMenuItem<String>(
                                        value: gender,
                                        child: Text(
                                          cubit.getGenderRestrictionDisplay(
                                              gender,
                                              AppLocalizations.of(context)!),
                                          style: GoogleFonts.poppins(),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String? selectedRes) {
                                      cubit
                                          .selectGenderRestriction(selectedRes);
                                    },
                                  ),
                                  const SizedBox(height: 32),
                                  // Save Button
                                  Container(
                                    width: double.infinity,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xFF6C63FF),
                                          Color(0xFFFF6584)
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF6C63FF)
                                              .withAlpha((0.18 * 255).round()),
                                          blurRadius: 10,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          cubit.addEventInfo(
                                              name: _nameController.text,
                                              dateAndTime:
                                                  _dateTimeController.text,
                                              description:
                                                  _descriptionController.text);
                                        },
                                        borderRadius: BorderRadius.circular(16),
                                        child: Center(
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .addEventButton,
                                            style: GoogleFonts.poppins(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
