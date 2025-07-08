import 'dart:io';
import 'dart:ui';

import 'package:event_connect/core/models/event_model.dart';
import 'package:event_connect/core/utils/loading_dialog.dart';
import 'package:event_connect/core/utils/message_dialogs.dart';
import 'package:event_connect/features/manager/manager_events/presentation/cubit/edit_event_cubit.dart';
import 'package:event_connect/features/manager/manager_events/presentation/cubit/manager_events_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class EditEventScreen extends StatefulWidget {
  final EventModel eventModel;
  const EditEventScreen({
    super.key,
    required this.eventModel,
  });

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _dateTimeController;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.eventModel.name);
    _dateTimeController =
        TextEditingController(text: widget.eventModel.dateAndTime);
    _descriptionController =
        TextEditingController(text: widget.eventModel.description);
    context.read<EditEventCubit>().selectedCategory =
        widget.eventModel.category;
    context.read<EditEventCubit>().selectedGenderRestriction =
        widget.eventModel.genderRestriction;
    context.read<EditEventCubit>().selectedLocation =
        widget.eventModel.location;
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
    final cubit = context.read<EditEventCubit>();
    return Scaffold(
      body: BlocListener<EditEventCubit, EditEventState>(
        listener: (context, state) {
          if (state is ManagerEventsLoading) {
            showLoadingDialog(context);
          } else if (state is EventUpdatedSuccessfully) {
            hideLoadingDialog(context);
            showMessageDialog(
              context: context,
              icon: Icons.check_circle_outline_rounded,
              titleText: "Success 🥳",
              contentText: "Your event has been updated successfully!",
              iconColor: Colors.green,
              buttonText: "Okay!",
              onPressed: () {
                Navigator.pop(context);
              },
            );
          } else if (state is EditEventError) {
            hideLoadingDialog(context);
            showErrorDialog(
              context: context,
              message: state.message,
            );
          }
        },
        child: Stack(children: [
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 22.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha((0.18 * 255).round()),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                          color: Colors.black.withAlpha((0.2 * 255).round()),
                          width: 1.2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withAlpha((0.3 * 255).round()),
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
                              "Edit Event",
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
                                  BlocBuilder<EditEventCubit, EditEventState>(
                                builder: (context, state) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(22),
                                    // prioritize the new image over the old "cached" one.
                                    child: cubit.eventImage != null
                                        ? Image.file(
                                            File(cubit.eventImage!.path),
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                          )
                                        : widget.eventModel.picture
                                                .startsWith("http")
                                            ? Container(
                                                color: const Color.fromARGB(
                                                    255, 230, 232, 241),
                                                child: Center(
                                                  child: Image.network(
                                                      "${widget.eventModel.picture}?updated=${DateTime.now().millisecondsSinceEpoch}"),
                                                ),
                                              )
                                            : Image.file(
                                                File(widget.eventModel.picture),
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: double.infinity,
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
                                color:
                                    Colors.black.withAlpha((0.1 * 255).round()),
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
                                  labelText: "Event Name",
                                  labelStyle:
                                      GoogleFonts.poppins(color: Colors.grey),
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
                                  labelText: "Description",
                                  labelStyle:
                                      GoogleFonts.poppins(color: Colors.grey),
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
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
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
                                  labelText: "Date & Time",
                                  labelStyle:
                                      GoogleFonts.poppins(color: Colors.grey),
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
                                  labelText: "Category",
                                  labelStyle:
                                      GoogleFonts.poppins(color: Colors.grey),
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
                                items: cubit.categories.map((String category) {
                                  return DropdownMenuItem<String>(
                                    value: category,
                                    child: Text(category,
                                        style: GoogleFonts.poppins()),
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
                                  labelText: "Location",
                                  labelStyle:
                                      GoogleFonts.poppins(color: Colors.grey),
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
                                    cubit.yemeniCities.map((String location) {
                                  return DropdownMenuItem<String>(
                                    value: location,
                                    child: Text(location,
                                        style: GoogleFonts.poppins()),
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
                                  labelText: "Gender Restriction",
                                  labelStyle:
                                      GoogleFonts.poppins(color: Colors.grey),
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
                                    child: Text(gender,
                                        style: GoogleFonts.poppins()),
                                  );
                                }).toList(),
                                onChanged: (String? selectedRes) {
                                  cubit.selectGenderRestriction(selectedRes);
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
                                      cubit.editEventInfo(
                                        name: _nameController.text,
                                        dateAndTime: _dateTimeController.text,
                                        description:
                                            _descriptionController.text,
                                        docID: widget.eventModel.eventID!,
                                        supabaseImageUrl:
                                            widget.eventModel.picture,
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(16),
                                    child: Center(
                                      child: Text(
                                        'Update Event',
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
          )),
        ]),
      ),
    );
  }
}
