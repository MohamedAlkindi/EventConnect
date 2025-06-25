import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({super.key});

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _dateTimeController;

  String? _selectedCategory;
  String? _selectedLocation;
  String? _selectedGenderRestriction;

  final List<String> _categories = [
    'Conference',
    'Workshop',
    'Meetup',
    'Seminar',
    'Party',
    'Other'
  ];
  final List<String> _locations = [
    'Sana\'a',
    'Aden',
    'Taiz',
    'Ibb',
    'Hadramout',
    'Other'
  ];
  final List<String> _genderRestrictions = [
    'No Restrictions',
    'Male Only',
    'Female Only'
  ];

  XFile? _eventImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _eventImage = image;
      });
    }
  }

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
    return Scaffold(
      body: Stack(
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
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                            color: Colors.black.withOpacity(0.2), width: 1.2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.3),
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
                                "Add New Event",
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
                                      color: Colors.black.withOpacity(0.08),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(22),
                                  child: _eventImage != null
                                      ? Image.file(
                                          File(_eventImage!.path),
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
                                    onPressed: _pickImage,
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
                                  color: Colors.black.withOpacity(0.1),
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
                                  value: _selectedCategory,
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
                                  items: _categories.map((String category) {
                                    return DropdownMenuItem<String>(
                                      value: category,
                                      child: Text(category,
                                          style: GoogleFonts.poppins()),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedCategory = newValue;
                                    });
                                  },
                                ),
                                const SizedBox(height: 18),
                                // Location Dropdown
                                DropdownButtonFormField<String>(
                                  value: _selectedLocation,
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
                                  items: _locations.map((String location) {
                                    return DropdownMenuItem<String>(
                                      value: location,
                                      child: Text(location,
                                          style: GoogleFonts.poppins()),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedLocation = newValue;
                                    });
                                  },
                                ),
                                const SizedBox(height: 18),
                                // Gender Restriction Dropdown
                                DropdownButtonFormField<String>(
                                  value: _selectedGenderRestriction,
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
                                  items:
                                      _genderRestrictions.map((String gender) {
                                    return DropdownMenuItem<String>(
                                      value: gender,
                                      child: Text(gender,
                                          style: GoogleFonts.poppins()),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedGenderRestriction = newValue;
                                    });
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
                                            .withOpacity(0.18),
                                        blurRadius: 10,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        // TODO: Implement event creation logic
                                      },
                                      borderRadius: BorderRadius.circular(16),
                                      child: Center(
                                        child: Text(
                                          'Add Event',
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
    );
  }
}
