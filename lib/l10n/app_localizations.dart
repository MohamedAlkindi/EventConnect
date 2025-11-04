import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to EventConnect!'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your Ultimate Event Companion'**
  String get welcomeSubtitle;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @alreadyUser.
  ///
  /// In en, this message translates to:
  /// **'Already a user?'**
  String get alreadyUser;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcomeBack;

  /// No description provided for @signInToContinue.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get signInToContinue;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @joinCommunity.
  ///
  /// In en, this message translates to:
  /// **'Join our community today'**
  String get joinCommunity;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @repeatPassword.
  ///
  /// In en, this message translates to:
  /// **'Repeat your password'**
  String get repeatPassword;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @dontHaveAccountYet.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account yet?'**
  String get dontHaveAccountYet;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'example@ex.com'**
  String get emailHint;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// No description provided for @createPassword.
  ///
  /// In en, this message translates to:
  /// **'Create a password'**
  String get createPassword;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @helpRecoverPassword.
  ///
  /// In en, this message translates to:
  /// **'We\'ll help you recover it'**
  String get helpRecoverPassword;

  /// No description provided for @profileSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Success! 🥳'**
  String get profileSuccessTitle;

  /// No description provided for @profileSuccessContent.
  ///
  /// In en, this message translates to:
  /// **'You have successfully completed your profile!'**
  String get profileSuccessContent;

  /// No description provided for @proceed.
  ///
  /// In en, this message translates to:
  /// **'Proceed'**
  String get proceed;

  /// No description provided for @completeProfile.
  ///
  /// In en, this message translates to:
  /// **'Complete Your Profile'**
  String get completeProfile;

  /// No description provided for @addProfilePicAndLocation.
  ///
  /// In en, this message translates to:
  /// **'Add your profile picture and location to get started'**
  String get addProfilePicAndLocation;

  /// No description provided for @checkYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Check your email'**
  String get checkYourEmail;

  /// No description provided for @emailSentMessage.
  ///
  /// In en, this message translates to:
  /// **'Hello! We\'ve sent you an email containing a verification link. Please check your inbox or spam folder to activate your account.'**
  String get emailSentMessage;

  /// No description provided for @wrongEmail.
  ///
  /// In en, this message translates to:
  /// **'Wrong email?'**
  String get wrongEmail;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @eventAddSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Success 🥳'**
  String get eventAddSuccessTitle;

  /// No description provided for @eventAddSuccessContent.
  ///
  /// In en, this message translates to:
  /// **'Your event has been added successfully!'**
  String get eventAddSuccessContent;

  /// No description provided for @okay.
  ///
  /// In en, this message translates to:
  /// **'Okay!'**
  String get okay;

  /// No description provided for @addNewEvent.
  ///
  /// In en, this message translates to:
  /// **'Add New Event'**
  String get addNewEvent;

  /// No description provided for @eventName.
  ///
  /// In en, this message translates to:
  /// **'Event Name'**
  String get eventName;

  /// No description provided for @profileUpdateSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Success! 🎉'**
  String get profileUpdateSuccessTitle;

  /// No description provided for @profileUpdateSuccessContent.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get profileUpdateSuccessContent;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Your Profile'**
  String get editProfile;

  /// No description provided for @emptyFieldMessage.
  ///
  /// In en, this message translates to:
  /// **'Please provide info for all fields.'**
  String get emptyFieldMessage;

  /// No description provided for @firebaseWeakPassMessage.
  ///
  /// In en, this message translates to:
  /// **'Please provide a stronger password.'**
  String get firebaseWeakPassMessage;

  /// No description provided for @firebaseEmailInUseMessage.
  ///
  /// In en, this message translates to:
  /// **'This email is already in use.'**
  String get firebaseEmailInUseMessage;

  /// No description provided for @firebaseInvalidEmailMessage.
  ///
  /// In en, this message translates to:
  /// **'Please provide a valid email.'**
  String get firebaseInvalidEmailMessage;

  /// No description provided for @firebaseUnknownException.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection or try again later.'**
  String get firebaseUnknownException;

  /// No description provided for @passwordsDontMatchMessage.
  ///
  /// In en, this message translates to:
  /// **'Please provide the same password.'**
  String get passwordsDontMatchMessage;

  /// No description provided for @firebaseInvalidCredentialsException.
  ///
  /// In en, this message translates to:
  /// **'Please check your inputs or try to sign up.'**
  String get firebaseInvalidCredentialsException;

  /// No description provided for @firebaseNoConnectionException.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection.'**
  String get firebaseNoConnectionException;

  /// No description provided for @genericExceptionMessage.
  ///
  /// In en, this message translates to:
  /// **'An error occurred, please check your inputs or try again later.'**
  String get genericExceptionMessage;

  /// No description provided for @notUniqueUsernameMessage.
  ///
  /// In en, this message translates to:
  /// **'This username is already being used.'**
  String get notUniqueUsernameMessage;

  /// No description provided for @shortUsernameMessage.
  ///
  /// In en, this message translates to:
  /// **'This username is too short, please at least enter 6 characters.'**
  String get shortUsernameMessage;

  /// No description provided for @apiError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong, restart the app.'**
  String get apiError;

  /// No description provided for @categoryError.
  ///
  /// In en, this message translates to:
  /// **'An error happened while fetching the category events.'**
  String get categoryError;

  /// No description provided for @addEventError.
  ///
  /// In en, this message translates to:
  /// **'An error happened while adding an event to your events.'**
  String get addEventError;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Ouch! 😓'**
  String get errorTitle;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @selectYourCity.
  ///
  /// In en, this message translates to:
  /// **'Select Your City'**
  String get selectYourCity;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @dateAndTime.
  ///
  /// In en, this message translates to:
  /// **'Date & Time'**
  String get dateAndTime;

  /// No description provided for @addEvent.
  ///
  /// In en, this message translates to:
  /// **'Add Event'**
  String get addEvent;

  /// No description provided for @manageEvents.
  ///
  /// In en, this message translates to:
  /// **'Manage Events'**
  String get manageEvents;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @rememberPassword.
  ///
  /// In en, this message translates to:
  /// **'Remember your password?'**
  String get rememberPassword;

  /// No description provided for @discoverEvents.
  ///
  /// In en, this message translates to:
  /// **'Discover Events'**
  String get discoverEvents;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success 🎉'**
  String get success;

  /// No description provided for @eventAdded.
  ///
  /// In en, this message translates to:
  /// **'The event has been added to your events!'**
  String get eventAdded;

  /// No description provided for @eventDeleted.
  ///
  /// In en, this message translates to:
  /// **'The event has been deleted from your events!'**
  String get eventDeleted;

  /// No description provided for @noEventsYet.
  ///
  /// In en, this message translates to:
  /// **'No Events Yet! 😱'**
  String get noEventsYet;

  /// No description provided for @clickToRefresh.
  ///
  /// In en, this message translates to:
  /// **'Click here to refresh'**
  String get clickToRefresh;

  /// No description provided for @addToSchedule.
  ///
  /// In en, this message translates to:
  /// **'Add to Schedule'**
  String get addToSchedule;

  /// No description provided for @removeFromSchedule.
  ///
  /// In en, this message translates to:
  /// **'Remove from Schedule'**
  String get removeFromSchedule;

  /// No description provided for @noWeatherInfo.
  ///
  /// In en, this message translates to:
  /// **'No weather info'**
  String get noWeatherInfo;

  /// No description provided for @myEvents.
  ///
  /// In en, this message translates to:
  /// **'My Events'**
  String get myEvents;

  /// No description provided for @addSomeEvents.
  ///
  /// In en, this message translates to:
  /// **'Add some events to your schedule'**
  String get addSomeEvents;

  /// No description provided for @orClickToRefresh.
  ///
  /// In en, this message translates to:
  /// **'Or click here to refresh'**
  String get orClickToRefresh;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @editAccount.
  ///
  /// In en, this message translates to:
  /// **'Edit Account'**
  String get editAccount;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @signOutTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out😐'**
  String get signOutTitle;

  /// No description provided for @signOutContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get signOutContent;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account 😐'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account?'**
  String get deleteAccountContent;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @allEvents.
  ///
  /// In en, this message translates to:
  /// **'All Events'**
  String get allEvents;

  /// No description provided for @eventConnect.
  ///
  /// In en, this message translates to:
  /// **'EventConnect 🎉'**
  String get eventConnect;

  /// No description provided for @categoryMusic.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get categoryMusic;

  /// No description provided for @categoryArt.
  ///
  /// In en, this message translates to:
  /// **'Art'**
  String get categoryArt;

  /// No description provided for @categorySports.
  ///
  /// In en, this message translates to:
  /// **'Sports'**
  String get categorySports;

  /// No description provided for @categoryFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get categoryFood;

  /// No description provided for @categoryBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get categoryBusiness;

  /// No description provided for @categoryTechnology.
  ///
  /// In en, this message translates to:
  /// **'Technology'**
  String get categoryTechnology;

  /// No description provided for @categoryEducation.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get categoryEducation;

  /// No description provided for @cityHadramout.
  ///
  /// In en, this message translates to:
  /// **'Hadramout'**
  String get cityHadramout;

  /// No description provided for @citySanaa.
  ///
  /// In en, this message translates to:
  /// **'San\'aa'**
  String get citySanaa;

  /// No description provided for @cityAden.
  ///
  /// In en, this message translates to:
  /// **'Aden'**
  String get cityAden;

  /// No description provided for @cityTaiz.
  ///
  /// In en, this message translates to:
  /// **'Taiz'**
  String get cityTaiz;

  /// No description provided for @cityIbb.
  ///
  /// In en, this message translates to:
  /// **'Ibb'**
  String get cityIbb;

  /// No description provided for @cityHudaydah.
  ///
  /// In en, this message translates to:
  /// **'Al Hudaydah'**
  String get cityHudaydah;

  /// No description provided for @cityMarib.
  ///
  /// In en, this message translates to:
  /// **'Marib'**
  String get cityMarib;

  /// No description provided for @cityMukalla.
  ///
  /// In en, this message translates to:
  /// **'Al Mukalla'**
  String get cityMukalla;

  /// No description provided for @genderNoRestrictions.
  ///
  /// In en, this message translates to:
  /// **'No Restrictions'**
  String get genderNoRestrictions;

  /// No description provided for @genderMaleOnly.
  ///
  /// In en, this message translates to:
  /// **'Male Only'**
  String get genderMaleOnly;

  /// No description provided for @genderFemaleOnly.
  ///
  /// In en, this message translates to:
  /// **'Female Only'**
  String get genderFemaleOnly;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @genderRestriction.
  ///
  /// In en, this message translates to:
  /// **'Gender Restriction'**
  String get genderRestriction;

  /// No description provided for @attendant.
  ///
  /// In en, this message translates to:
  /// **'Attendant'**
  String get attendant;

  /// No description provided for @attendees.
  ///
  /// In en, this message translates to:
  /// **'Attendees'**
  String get attendees;

  /// No description provided for @editEvent.
  ///
  /// In en, this message translates to:
  /// **'Edit Event'**
  String get editEvent;

  /// No description provided for @deleteEvent.
  ///
  /// In en, this message translates to:
  /// **'Delete Event'**
  String get deleteEvent;

  /// No description provided for @editEventTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Event'**
  String get editEventTitle;

  /// No description provided for @eventNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter event name'**
  String get eventNameHint;

  /// No description provided for @descriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Enter event description'**
  String get descriptionHint;

  /// No description provided for @dateAndTimeHint.
  ///
  /// In en, this message translates to:
  /// **'Select date and time'**
  String get dateAndTimeHint;

  /// No description provided for @addEventButton.
  ///
  /// In en, this message translates to:
  /// **'Add Event'**
  String get addEventButton;

  /// No description provided for @updateEventButton.
  ///
  /// In en, this message translates to:
  /// **'Update Event'**
  String get updateEventButton;

  /// No description provided for @deleteEventDialogContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this event?'**
  String get deleteEventDialogContent;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allCategories;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @youAre.
  ///
  /// In en, this message translates to:
  /// **'You are:'**
  String get youAre;

  /// No description provided for @roleAttendee.
  ///
  /// In en, this message translates to:
  /// **'An attendee'**
  String get roleAttendee;

  /// No description provided for @roleManager.
  ///
  /// In en, this message translates to:
  /// **'A manager'**
  String get roleManager;

  /// No description provided for @finalizeProfile.
  ///
  /// In en, this message translates to:
  /// **'Finalize Profile'**
  String get finalizeProfile;

  /// No description provided for @confirmationEmailResent.
  ///
  /// In en, this message translates to:
  /// **'We\'ve resent you the confirmation email.'**
  String get confirmationEmailResent;

  /// No description provided for @emailNotConfirmed.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t confirmed your email yet!'**
  String get emailNotConfirmed;

  /// No description provided for @headToHomeScreen.
  ///
  /// In en, this message translates to:
  /// **'Head to Home Screen'**
  String get headToHomeScreen;

  /// No description provided for @resendEmail.
  ///
  /// In en, this message translates to:
  /// **'Resend email?'**
  String get resendEmail;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @eventUpdateSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Success 🥳'**
  String get eventUpdateSuccessTitle;

  /// No description provided for @eventUpdateSuccessContent.
  ///
  /// In en, this message translates to:
  /// **'Your event has been updated successfully!'**
  String get eventUpdateSuccessContent;

  /// No description provided for @resetPassEmail.
  ///
  /// In en, this message translates to:
  /// **'Reset Email Sent!'**
  String get resetPassEmail;

  /// No description provided for @resetMessage.
  ///
  /// In en, this message translates to:
  /// **'A password reset email has been sent to your email address. Please check your inbox or spam folder.'**
  String get resetMessage;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
