import 'package:event_connect/core/constants/event_categories.dart';
import 'package:event_connect/core/constants/gender_restrictions.dart';
import 'package:event_connect/core/constants/user_cities.dart';
import 'package:event_connect/core/models/event_model.dart';
import 'package:event_connect/core/utils/loading_dialog.dart';
import 'package:event_connect/core/utils/localization_extensions.dart';
import 'package:event_connect/core/utils/message_dialogs.dart';
import 'package:event_connect/core/widgets/manager_widgets/event_management_widgets.dart';
import 'package:event_connect/core/widgets/shared/app_background.dart';
import 'package:event_connect/features/manager/manager_events/presentation/cubit/edit_event_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
          if (state is EventUpdateLoading) {
            showLoadingDialog(context);
          } else if (state is EventUpdatedSuccessfully) {
            hideLoadingDialog(context);
            showMessageDialog(
              context: context,
              icon: Icons.check_circle_outline_rounded,
              titleText: AppLocalizations.of(context)!.eventUpdateSuccessTitle,
              contentText:
                  AppLocalizations.of(context)!.eventUpdateSuccessContent,
              iconColor: Colors.green,
              buttonText: "Okay!",
              onPressed: () {
                Navigator.pop(context);
              },
            );
          } else if (state is EditEventError) {
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
                    barText: AppLocalizations.of(context)!.editEventTitle,
                  ),
                  const SizedBox(height: 35),
                  // Event Image Container
                  Stack(
                    children: [
                      imageContainer(
                        childWidget:
                            BlocBuilder<EditEventCubit, EditEventState>(
                          builder: (context, state) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(22),
                              // prioritize the new image over the old "cached" one.
                              // TODO: Fix the caching and storing issue!!
                              child: cubit.getImageForClipRRect(
                                picturePath:
                                    widget.eventModel.cachedPicturePath!,
                              ),
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
                              cubit.editEventInfo(
                                name: _nameController.text,
                                dateAndTime: _dateTimeController.text,
                                description: _descriptionController.text,
                                docID: widget.eventModel.eventID!,
                                supabaseImageUrl: widget.eventModel.pictureUrl,
                                oldPicturePath:
                                    widget.eventModel.cachedPicturePath!,
                              );
                            },
                            textButton:
                                AppLocalizations.of(context)!.updateEventButton,
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
