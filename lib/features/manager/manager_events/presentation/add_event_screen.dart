import 'package:event_connect/core/constants/event_categories.dart';
import 'package:event_connect/core/constants/gender_restrictions.dart';
import 'package:event_connect/core/constants/user_cities.dart';
import 'package:event_connect/core/utils/loading_dialog.dart';
import 'package:event_connect/core/utils/localization_extensions.dart';
import 'package:event_connect/core/utils/message_dialogs.dart';
import 'package:event_connect/core/widgets/manager_widgets/event_management_widgets.dart';
import 'package:event_connect/core/widgets/shared/app_background.dart';
import 'package:event_connect/features/manager/manager_events/presentation/cubit/add_event_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_connect/l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

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
            appBackgroundColors(),
            managementBackgroundWidget(
              childWidget: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  managementMainBarItems(
                    context: context,
                    barText: AppLocalizations.of(context)!.addNewEvent,
                  ),
                  const SizedBox(height: 35),
                  // Event Image Container
                  Stack(
                    children: [
                      imageContainer(
                        childWidget: BlocBuilder<AddEventCubit, AddEventState>(
                          builder: (context, state) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(22),
                              child: cubit.getImageForClipRRect(),
                            );
                          },
                        ),
                      ),
                      managementCameraButton(
                        onPressed: () {
                          cubit.pickImage();
                        },
                      )
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Form Card
                  managementFormCardContainer(
                    childWidget: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name
                        managementFormFields(
                          controller: _nameController,
                          maxLength: 20,
                          labelText: AppLocalizations.of(context)!.eventName,
                          hintText: AppLocalizations.of(context)!.eventNameHint,
                          context: context,
                        ),

                        const SizedBox(height: 18),
                        // Description
                        managementFormFields(
                          controller: _descriptionController,
                          maxLength: null,
                          labelText: AppLocalizations.of(context)!.description,
                          hintText:
                              AppLocalizations.of(context)!.descriptionHint,
                          context: context,
                        ),

                        const SizedBox(height: 18),
                        // Date & Time
                        managementFormFields(
                          controller: _dateTimeController,
                          maxLength: null,
                          labelText: AppLocalizations.of(context)!.dateAndTime,
                          hintText:
                              AppLocalizations.of(context)!.dateAndTimeHint,
                          isDateTimeField: true,
                          context: context,
                        ),

                        const SizedBox(height: 18),
                        // Category Dropdown
                        managementDropDownFormFields(
                          value: cubit.selectedCategory,
                          labelText: AppLocalizations.of(context)!.category,
                          itemsList: eventCategories.map((String category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Text(
                                cubit.getCategoryDisplay(
                                    category, AppLocalizations.of(context)!),
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
                        managementDropDownFormFields(
                          value: cubit.selectedLocation,
                          labelText: AppLocalizations.of(context)!.location,
                          itemsList: cities.map((String location) {
                            return DropdownMenuItem<String>(
                              value: location,
                              child: Text(
                                cubit.getCityDisplay(
                                    location, AppLocalizations.of(context)!),
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
                        managementDropDownFormFields(
                          value: cubit.selectedGenderRestriction,
                          labelText:
                              AppLocalizations.of(context)!.genderRestriction,
                          itemsList: genderRestrictions.map((String gender) {
                            return DropdownMenuItem<String>(
                              value: gender,
                              child: Text(
                                cubit.getGenderRestrictionDisplay(
                                    gender, AppLocalizations.of(context)!),
                                style: GoogleFonts.poppins(),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? selectedRes) {
                            cubit.selectGenderRestriction(selectedRes);
                          },
                        ),

                        const SizedBox(height: 32),
                        // Save Button
                        managementButtonContainer(
                          childWidget: managementButton(
                            onTap: () {
                              cubit.addEventInfo(
                                  name: _nameController.text,
                                  dateAndTime: _dateTimeController.text,
                                  description: _descriptionController.text);
                            },
                            textButton:
                                AppLocalizations.of(context)!.addEventButton,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
