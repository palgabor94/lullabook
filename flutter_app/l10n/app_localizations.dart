import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hu.dart';

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
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hu')
  ];

  /// No description provided for @authSaveMagic.
  ///
  /// In en, this message translates to:
  /// **'Save your magic'**
  String get authSaveMagic;

  /// No description provided for @authSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Continue your adventure and create unlimited bedtime stories.'**
  String get authSubtitle;

  /// No description provided for @authContinueGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get authContinueGoogle;

  /// No description provided for @authContinueEmail.
  ///
  /// In en, this message translates to:
  /// **'Continue with email'**
  String get authContinueEmail;

  /// No description provided for @authTryPreview.
  ///
  /// In en, this message translates to:
  /// **'Try a free preview first →'**
  String get authTryPreview;

  /// No description provided for @authAgreePrefix.
  ///
  /// In en, this message translates to:
  /// **'By continuing you agree to our'**
  String get authAgreePrefix;

  /// No description provided for @authTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms'**
  String get authTerms;

  /// No description provided for @authPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get authPrivacy;

  /// No description provided for @authCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get authCreateAccount;

  /// No description provided for @authSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authSignIn;

  /// No description provided for @authEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmailLabel;

  /// No description provided for @authPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPasswordLabel;

  /// No description provided for @authEmailValidation.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get authEmailValidation;

  /// No description provided for @authPasswordValidation.
  ///
  /// In en, this message translates to:
  /// **'At least 6 characters'**
  String get authPasswordValidation;

  /// No description provided for @authHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get authHaveAccount;

  /// No description provided for @authNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Register'**
  String get authNoAccount;

  /// No description provided for @authErrorApple.
  ///
  /// In en, this message translates to:
  /// **'Apple Sign-In failed. Please try again.'**
  String get authErrorApple;

  /// No description provided for @authErrorGoogle.
  ///
  /// In en, this message translates to:
  /// **'Google Sign-In failed. Please try again.'**
  String get authErrorGoogle;

  /// No description provided for @authErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Sign-in failed. Please try again.'**
  String get authErrorGeneric;

  /// No description provided for @authErrorInvalidCredential.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password.'**
  String get authErrorInvalidCredential;

  /// No description provided for @authErrorEmailExists.
  ///
  /// In en, this message translates to:
  /// **'An account with this email already exists.'**
  String get authErrorEmailExists;

  /// No description provided for @authErrorWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters.'**
  String get authErrorWeakPassword;

  /// No description provided for @authErrorInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get authErrorInvalidEmail;

  /// No description provided for @authErrorTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Try again later.'**
  String get authErrorTooManyRequests;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Bedtime stories starring your child'**
  String get splashTagline;

  /// No description provided for @previewEyebrow.
  ///
  /// In en, this message translates to:
  /// **'FREE PREVIEW · NO SIGNUP'**
  String get previewEyebrow;

  /// No description provided for @previewTitle.
  ///
  /// In en, this message translates to:
  /// **'See your child\nas the hero'**
  String get previewTitle;

  /// No description provided for @previewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll show you a sneak peek before any signup.'**
  String get previewSubtitle;

  /// No description provided for @previewChildNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Child\'s first name'**
  String get previewChildNameLabel;

  /// No description provided for @previewAdventureHeader.
  ///
  /// In en, this message translates to:
  /// **'CHOOSE AN ADVENTURE'**
  String get previewAdventureHeader;

  /// No description provided for @previewArtStyleHeader.
  ///
  /// In en, this message translates to:
  /// **'CHOOSE AN ART STYLE'**
  String get previewArtStyleHeader;

  /// No description provided for @previewPrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'Photo deleted within 24 hours.\nWe never share your child\'s image.'**
  String get previewPrivacyNote;

  /// No description provided for @previewNextButton.
  ///
  /// In en, this message translates to:
  /// **'Next: Add a photo'**
  String get previewNextButton;

  /// No description provided for @previewAlreadyAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get previewAlreadyAccount;

  /// No description provided for @previewNameValidation.
  ///
  /// In en, this message translates to:
  /// **'Enter your child\'s name to continue'**
  String get previewNameValidation;

  /// No description provided for @previewAdventureSpaceExplorer.
  ///
  /// In en, this message translates to:
  /// **'Space Explorer'**
  String get previewAdventureSpaceExplorer;

  /// No description provided for @previewAdventureOceanDiver.
  ///
  /// In en, this message translates to:
  /// **'Ocean Diver'**
  String get previewAdventureOceanDiver;

  /// No description provided for @previewAdventureDragonRider.
  ///
  /// In en, this message translates to:
  /// **'Dragon Rider'**
  String get previewAdventureDragonRider;

  /// No description provided for @previewAdventureForestFairy.
  ///
  /// In en, this message translates to:
  /// **'Forest Fairy'**
  String get previewAdventureForestFairy;

  /// No description provided for @previewAdventureTreasureHunter.
  ///
  /// In en, this message translates to:
  /// **'Treasure Hunter'**
  String get previewAdventureTreasureHunter;

  /// No description provided for @previewAdventureTimeTraveler.
  ///
  /// In en, this message translates to:
  /// **'Time Traveler'**
  String get previewAdventureTimeTraveler;

  /// No description provided for @photoTitle.
  ///
  /// In en, this message translates to:
  /// **'{childName}\'s photo'**
  String photoTitle(String childName);

  /// No description provided for @photoInstruction.
  ///
  /// In en, this message translates to:
  /// **'Add a clear photo of your child\'s face.\nThis will become their storybook hero!'**
  String get photoInstruction;

  /// No description provided for @photoTapGallery.
  ///
  /// In en, this message translates to:
  /// **'Tap to choose from gallery'**
  String get photoTapGallery;

  /// No description provided for @photoCameraButton.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get photoCameraButton;

  /// No description provided for @photoCreatingHero.
  ///
  /// In en, this message translates to:
  /// **'Creating your hero… ~40 seconds'**
  String get photoCreatingHero;

  /// No description provided for @photoCreateCta.
  ///
  /// In en, this message translates to:
  /// **'Create my hero!'**
  String get photoCreateCta;

  /// No description provided for @revealTitle.
  ///
  /// In en, this message translates to:
  /// **'Meet {childName}!'**
  String revealTitle(String childName);

  /// No description provided for @revealContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue →'**
  String get revealContinue;

  /// No description provided for @revealStartAdventure.
  ///
  /// In en, this message translates to:
  /// **'Start {childName}\'s adventure!'**
  String revealStartAdventure(String childName);

  /// No description provided for @heroInfoEyebrow.
  ///
  /// In en, this message translates to:
  /// **'STEP 2 OF 3 · ABOUT THE HERO'**
  String get heroInfoEyebrow;

  /// No description provided for @heroInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Tell us about\n{name}'**
  String heroInfoTitle(String name);

  /// No description provided for @heroNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get heroNameLabel;

  /// No description provided for @heroAgeHeader.
  ///
  /// In en, this message translates to:
  /// **'AGE'**
  String get heroAgeHeader;

  /// No description provided for @heroPronounsHeader.
  ///
  /// In en, this message translates to:
  /// **'PRONOUNS'**
  String get heroPronounsHeader;

  /// No description provided for @heroTraitsLabel.
  ///
  /// In en, this message translates to:
  /// **'DEFINING TRAITS (OPTIONAL)'**
  String get heroTraitsLabel;

  /// No description provided for @heroTraitsHint.
  ///
  /// In en, this message translates to:
  /// **'brown wavy hair, blue glasses, freckles'**
  String get heroTraitsHint;

  /// No description provided for @heroArtStyleHeader.
  ///
  /// In en, this message translates to:
  /// **'ART STYLE'**
  String get heroArtStyleHeader;

  /// No description provided for @heroConfirmButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm hero'**
  String get heroConfirmButton;

  /// No description provided for @heroNextPhotoButton.
  ///
  /// In en, this message translates to:
  /// **'Next: Add photo'**
  String get heroNextPhotoButton;

  /// No description provided for @heroNameValidation.
  ///
  /// In en, this message translates to:
  /// **'Enter your child\'s name'**
  String get heroNameValidation;

  /// No description provided for @heroArtStylePixar.
  ///
  /// In en, this message translates to:
  /// **'Pixar 3D'**
  String get heroArtStylePixar;

  /// No description provided for @heroArtStyleWatercolor.
  ///
  /// In en, this message translates to:
  /// **'Watercolor'**
  String get heroArtStyleWatercolor;

  /// No description provided for @heroArtStyleFlatModern.
  ///
  /// In en, this message translates to:
  /// **'Flat Modern'**
  String get heroArtStyleFlatModern;

  /// No description provided for @heroArtStyleStorybook.
  ///
  /// In en, this message translates to:
  /// **'Storybook Classic'**
  String get heroArtStyleStorybook;

  /// No description provided for @heroPronounHeHim.
  ///
  /// In en, this message translates to:
  /// **'he/him'**
  String get heroPronounHeHim;

  /// No description provided for @heroPronounSheHer.
  ///
  /// In en, this message translates to:
  /// **'she/her'**
  String get heroPronounSheHer;

  /// No description provided for @heroPronounTheyThem.
  ///
  /// In en, this message translates to:
  /// **'they/them'**
  String get heroPronounTheyThem;

  /// No description provided for @heroPhotoEyebrow.
  ///
  /// In en, this message translates to:
  /// **'STEP 3 OF 3 · {name}\'S PHOTO'**
  String heroPhotoEyebrow(String name);

  /// No description provided for @heroPhotoTitle.
  ///
  /// In en, this message translates to:
  /// **'A clear photo\nworks best'**
  String get heroPhotoTitle;

  /// No description provided for @heroPhotoInstruction.
  ///
  /// In en, this message translates to:
  /// **'Front-facing with good lighting works best. Original is deleted within 24 hours.'**
  String get heroPhotoInstruction;

  /// No description provided for @heroPhotoAdd.
  ///
  /// In en, this message translates to:
  /// **'Add a photo'**
  String get heroPhotoAdd;

  /// No description provided for @heroPhotoAddSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A clear photo of your child works best'**
  String get heroPhotoAddSubtitle;

  /// No description provided for @heroPhotoCameraButton.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get heroPhotoCameraButton;

  /// No description provided for @heroPhotoCreating.
  ///
  /// In en, this message translates to:
  /// **'Creating hero… ~40 seconds'**
  String get heroPhotoCreating;

  /// No description provided for @heroPhotoCreateCta.
  ///
  /// In en, this message translates to:
  /// **'Create hero!'**
  String get heroPhotoCreateCta;

  /// No description provided for @heroAnchorTitle.
  ///
  /// In en, this message translates to:
  /// **'Does this look like {name}?'**
  String heroAnchorTitle(String name);

  /// No description provided for @heroAnchorRegenerating.
  ///
  /// In en, this message translates to:
  /// **'Regenerating… ~40 seconds'**
  String get heroAnchorRegenerating;

  /// No description provided for @heroAnchorRegenerationsLeft.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 free regeneration remaining} other{{count} free regenerations remaining}}'**
  String heroAnchorRegenerationsLeft(int count);

  /// No description provided for @heroAnchorTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get heroAnchorTryAgain;

  /// No description provided for @heroAnchorConfirm.
  ///
  /// In en, this message translates to:
  /// **'Yes, that\'s {name}'**
  String heroAnchorConfirm(String name);

  /// No description provided for @adventureStep1Question.
  ///
  /// In en, this message translates to:
  /// **'Who do you want to be tonight?'**
  String get adventureStep1Question;

  /// No description provided for @adventureStep2Question.
  ///
  /// In en, this message translates to:
  /// **'Who comes with you?'**
  String get adventureStep2Question;

  /// No description provided for @adventureStep3Question.
  ///
  /// In en, this message translates to:
  /// **'Where does the adventure happen?'**
  String get adventureStep3Question;

  /// No description provided for @adventureStep4Question.
  ///
  /// In en, this message translates to:
  /// **'What do you want to find?'**
  String get adventureStep4Question;

  /// No description provided for @adventureStep5Question.
  ///
  /// In en, this message translates to:
  /// **'Any final touches?'**
  String get adventureStep5Question;

  /// No description provided for @adventureStepHint1.
  ///
  /// In en, this message translates to:
  /// **'Step 1 of 4'**
  String get adventureStepHint1;

  /// No description provided for @adventureStepHint2.
  ///
  /// In en, this message translates to:
  /// **'Step 2 of 4'**
  String get adventureStepHint2;

  /// No description provided for @adventureStepHint3.
  ///
  /// In en, this message translates to:
  /// **'Step 3 of 4'**
  String get adventureStepHint3;

  /// No description provided for @adventureStepHint4.
  ///
  /// In en, this message translates to:
  /// **'Step 4 of 4'**
  String get adventureStepHint4;

  /// No description provided for @adventureStepHintOptional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get adventureStepHintOptional;

  /// No description provided for @adventureSoloHero.
  ///
  /// In en, this message translates to:
  /// **'Solo Hero'**
  String get adventureSoloHero;

  /// No description provided for @adventureTeachingMomentHeader.
  ///
  /// In en, this message translates to:
  /// **'Add a teaching moment'**
  String get adventureTeachingMomentHeader;

  /// No description provided for @adventureTeachingMomentHelp.
  ///
  /// In en, this message translates to:
  /// **'Optional, for grown-ups. The story will weave it in gently.'**
  String get adventureTeachingMomentHelp;

  /// No description provided for @adventureTeachingMomentPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'or type your own…'**
  String get adventureTeachingMomentPlaceholder;

  /// No description provided for @adventureCreateStoryButton.
  ///
  /// In en, this message translates to:
  /// **'Create story!'**
  String get adventureCreateStoryButton;

  /// No description provided for @adventureNone.
  ///
  /// In en, this message translates to:
  /// **'none'**
  String get adventureNone;

  /// No description provided for @buddyOptionalPhoto.
  ///
  /// In en, this message translates to:
  /// **'Optional photo'**
  String get buddyOptionalPhoto;

  /// No description provided for @buddyNameHint.
  ///
  /// In en, this message translates to:
  /// **'Name (optional, e.g. Rex, Sam…)'**
  String get buddyNameHint;

  /// No description provided for @buddySave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get buddySave;

  /// No description provided for @buddyContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get buddyContinue;

  /// No description provided for @buddySaveError.
  ///
  /// In en, this message translates to:
  /// **'Failed to save. Please try again.'**
  String get buddySaveError;

  /// No description provided for @buddyTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get buddyTakePhoto;

  /// No description provided for @buddyChooseLibrary.
  ///
  /// In en, this message translates to:
  /// **'Choose from library'**
  String get buddyChooseLibrary;

  /// No description provided for @buddyDad.
  ///
  /// In en, this message translates to:
  /// **'Dad'**
  String get buddyDad;

  /// No description provided for @buddyMom.
  ///
  /// In en, this message translates to:
  /// **'Mom'**
  String get buddyMom;

  /// No description provided for @buddySibling.
  ///
  /// In en, this message translates to:
  /// **'Sibling'**
  String get buddySibling;

  /// No description provided for @buddyDog.
  ///
  /// In en, this message translates to:
  /// **'Dog'**
  String get buddyDog;

  /// No description provided for @buddyCat.
  ///
  /// In en, this message translates to:
  /// **'Cat'**
  String get buddyCat;

  /// No description provided for @buddyGrandpa.
  ///
  /// In en, this message translates to:
  /// **'Grandpa'**
  String get buddyGrandpa;

  /// No description provided for @buddyGrandma.
  ///
  /// In en, this message translates to:
  /// **'Grandma'**
  String get buddyGrandma;

  /// No description provided for @buddyFriend.
  ///
  /// In en, this message translates to:
  /// **'Friend'**
  String get buddyFriend;

  /// No description provided for @themeAstronaut.
  ///
  /// In en, this message translates to:
  /// **'Astronaut'**
  String get themeAstronaut;

  /// No description provided for @themePirate.
  ///
  /// In en, this message translates to:
  /// **'Pirate'**
  String get themePirate;

  /// No description provided for @themeWizard.
  ///
  /// In en, this message translates to:
  /// **'Wizard'**
  String get themeWizard;

  /// No description provided for @themePrincess.
  ///
  /// In en, this message translates to:
  /// **'Princess'**
  String get themePrincess;

  /// No description provided for @themeKnight.
  ///
  /// In en, this message translates to:
  /// **'Knight'**
  String get themeKnight;

  /// No description provided for @themeMermaid.
  ///
  /// In en, this message translates to:
  /// **'Mermaid'**
  String get themeMermaid;

  /// No description provided for @themeSuperhero.
  ///
  /// In en, this message translates to:
  /// **'Superhero'**
  String get themeSuperhero;

  /// No description provided for @themeChef.
  ///
  /// In en, this message translates to:
  /// **'Chef'**
  String get themeChef;

  /// No description provided for @themeScientist.
  ///
  /// In en, this message translates to:
  /// **'Scientist'**
  String get themeScientist;

  /// No description provided for @themeNinja.
  ///
  /// In en, this message translates to:
  /// **'Ninja'**
  String get themeNinja;

  /// No description provided for @themeExplorer.
  ///
  /// In en, this message translates to:
  /// **'Explorer'**
  String get themeExplorer;

  /// No description provided for @themeVet.
  ///
  /// In en, this message translates to:
  /// **'Vet'**
  String get themeVet;

  /// No description provided for @themeInventor.
  ///
  /// In en, this message translates to:
  /// **'Inventor'**
  String get themeInventor;

  /// No description provided for @themeDinoHunter.
  ///
  /// In en, this message translates to:
  /// **'Dino Hunter'**
  String get themeDinoHunter;

  /// No description provided for @themeFirefighter.
  ///
  /// In en, this message translates to:
  /// **'Firefighter'**
  String get themeFirefighter;

  /// No description provided for @themeRobotPilot.
  ///
  /// In en, this message translates to:
  /// **'Robot Pilot'**
  String get themeRobotPilot;

  /// No description provided for @teachingBravery.
  ///
  /// In en, this message translates to:
  /// **'Bravery'**
  String get teachingBravery;

  /// No description provided for @teachingKindness.
  ///
  /// In en, this message translates to:
  /// **'Kindness'**
  String get teachingKindness;

  /// No description provided for @teachingSharing.
  ///
  /// In en, this message translates to:
  /// **'Sharing'**
  String get teachingSharing;

  /// No description provided for @teachingHonesty.
  ///
  /// In en, this message translates to:
  /// **'Honesty'**
  String get teachingHonesty;

  /// No description provided for @teachingPatience.
  ///
  /// In en, this message translates to:
  /// **'Patience'**
  String get teachingPatience;

  /// No description provided for @teachingFriendship.
  ///
  /// In en, this message translates to:
  /// **'Friendship'**
  String get teachingFriendship;

  /// No description provided for @teachingPerseverance.
  ///
  /// In en, this message translates to:
  /// **'Perseverance'**
  String get teachingPerseverance;

  /// No description provided for @teachingCreativity.
  ///
  /// In en, this message translates to:
  /// **'Creativity'**
  String get teachingCreativity;

  /// No description provided for @locAstronautSpaceStation.
  ///
  /// In en, this message translates to:
  /// **'Space Station'**
  String get locAstronautSpaceStation;

  /// No description provided for @locAstronautPlanetMars.
  ///
  /// In en, this message translates to:
  /// **'Planet Mars'**
  String get locAstronautPlanetMars;

  /// No description provided for @locAstronautMoon.
  ///
  /// In en, this message translates to:
  /// **'The Moon'**
  String get locAstronautMoon;

  /// No description provided for @locAstronautAsteroidBelt.
  ///
  /// In en, this message translates to:
  /// **'Asteroid Belt'**
  String get locAstronautAsteroidBelt;

  /// No description provided for @locAstronautAlienPlanet.
  ///
  /// In en, this message translates to:
  /// **'Alien Planet'**
  String get locAstronautAlienPlanet;

  /// No description provided for @locAstronautCometTrail.
  ///
  /// In en, this message translates to:
  /// **'Comet Trail'**
  String get locAstronautCometTrail;

  /// No description provided for @locAstronautCrystalNebula.
  ///
  /// In en, this message translates to:
  /// **'Crystal Nebula'**
  String get locAstronautCrystalNebula;

  /// No description provided for @locAstronautBlackHole.
  ///
  /// In en, this message translates to:
  /// **'Black Hole Edge'**
  String get locAstronautBlackHole;

  /// No description provided for @goalAstronautFixRocket.
  ///
  /// In en, this message translates to:
  /// **'Fix the rocket'**
  String get goalAstronautFixRocket;

  /// No description provided for @goalAstronautDiscoverPlanet.
  ///
  /// In en, this message translates to:
  /// **'Discover a new planet'**
  String get goalAstronautDiscoverPlanet;

  /// No description provided for @goalAstronautSaveStation.
  ///
  /// In en, this message translates to:
  /// **'Save the space station'**
  String get goalAstronautSaveStation;

  /// No description provided for @goalAstronautBefriendAliens.
  ///
  /// In en, this message translates to:
  /// **'Befriend aliens'**
  String get goalAstronautBefriendAliens;

  /// No description provided for @goalAstronautFindStar.
  ///
  /// In en, this message translates to:
  /// **'Find a lost star'**
  String get goalAstronautFindStar;

  /// No description provided for @goalAstronautStopMeteor.
  ///
  /// In en, this message translates to:
  /// **'Stop a meteor'**
  String get goalAstronautStopMeteor;

  /// No description provided for @goalAstronautRescueCrew.
  ///
  /// In en, this message translates to:
  /// **'Rescue a lost crew'**
  String get goalAstronautRescueCrew;

  /// No description provided for @goalAstronautSpaceCrystal.
  ///
  /// In en, this message translates to:
  /// **'Find the space crystal'**
  String get goalAstronautSpaceCrystal;

  /// No description provided for @locPirateTreasureIsland.
  ///
  /// In en, this message translates to:
  /// **'Treasure Island'**
  String get locPirateTreasureIsland;

  /// No description provided for @locPirateHighSeas.
  ///
  /// In en, this message translates to:
  /// **'The High Seas'**
  String get locPirateHighSeas;

  /// No description provided for @locPirateSunkenGalleon.
  ///
  /// In en, this message translates to:
  /// **'Sunken Galleon'**
  String get locPirateSunkenGalleon;

  /// No description provided for @locPirateSeaCave.
  ///
  /// In en, this message translates to:
  /// **'Secret Sea Cave'**
  String get locPirateSeaCave;

  /// No description provided for @locPiratePiratePort.
  ///
  /// In en, this message translates to:
  /// **'Pirate Port'**
  String get locPiratePiratePort;

  /// No description provided for @locPirateCoralReef.
  ///
  /// In en, this message translates to:
  /// **'Coral Reef'**
  String get locPirateCoralReef;

  /// No description provided for @locPirateFogIsland.
  ///
  /// In en, this message translates to:
  /// **'Island of Fog'**
  String get locPirateFogIsland;

  /// No description provided for @locPirateStormySea.
  ///
  /// In en, this message translates to:
  /// **'Stormy Sea'**
  String get locPirateStormySea;

  /// No description provided for @goalPirateBuriedTreasure.
  ///
  /// In en, this message translates to:
  /// **'Find buried treasure'**
  String get goalPirateBuriedTreasure;

  /// No description provided for @goalPirateFreeWhale.
  ///
  /// In en, this message translates to:
  /// **'Free a captured whale'**
  String get goalPirateFreeWhale;

  /// No description provided for @goalPirateDecodeMap.
  ///
  /// In en, this message translates to:
  /// **'Decode the ancient map'**
  String get goalPirateDecodeMap;

  /// No description provided for @goalPirateSailStorm.
  ///
  /// In en, this message translates to:
  /// **'Sail through the storm'**
  String get goalPirateSailStorm;

  /// No description provided for @goalPirateSaveLighthouse.
  ///
  /// In en, this message translates to:
  /// **'Save the lighthouse'**
  String get goalPirateSaveLighthouse;

  /// No description provided for @goalPirateFindSunkenShip.
  ///
  /// In en, this message translates to:
  /// **'Find the sunken ship'**
  String get goalPirateFindSunkenShip;

  /// No description provided for @goalPirateBeatRival.
  ///
  /// In en, this message translates to:
  /// **'Outsmart the rival pirate'**
  String get goalPirateBeatRival;

  /// No description provided for @goalPirateMagicShell.
  ///
  /// In en, this message translates to:
  /// **'Find the magic shell'**
  String get goalPirateMagicShell;

  /// No description provided for @locWizardMagicForest.
  ///
  /// In en, this message translates to:
  /// **'Magic Forest'**
  String get locWizardMagicForest;

  /// No description provided for @locWizardEnchantedCastle.
  ///
  /// In en, this message translates to:
  /// **'Enchanted Castle'**
  String get locWizardEnchantedCastle;

  /// No description provided for @locWizardCrystalCave.
  ///
  /// In en, this message translates to:
  /// **'Crystal Cave'**
  String get locWizardCrystalCave;

  /// No description provided for @locWizardWizardTower.
  ///
  /// In en, this message translates to:
  /// **'Wizard Tower'**
  String get locWizardWizardTower;

  /// No description provided for @locWizardSpellLibrary.
  ///
  /// In en, this message translates to:
  /// **'Spell Library'**
  String get locWizardSpellLibrary;

  /// No description provided for @locWizardDragonMountain.
  ///
  /// In en, this message translates to:
  /// **'Dragon Mountain'**
  String get locWizardDragonMountain;

  /// No description provided for @locWizardFloatingIslands.
  ///
  /// In en, this message translates to:
  /// **'Floating Islands'**
  String get locWizardFloatingIslands;

  /// No description provided for @locWizardMirrorRealm.
  ///
  /// In en, this message translates to:
  /// **'Mirror Realm'**
  String get locWizardMirrorRealm;

  /// No description provided for @goalWizardBreakSpell.
  ///
  /// In en, this message translates to:
  /// **'Break the evil spell'**
  String get goalWizardBreakSpell;

  /// No description provided for @goalWizardBrewPotion.
  ///
  /// In en, this message translates to:
  /// **'Brew the lost potion'**
  String get goalWizardBrewPotion;

  /// No description provided for @goalWizardReturnWand.
  ///
  /// In en, this message translates to:
  /// **'Return the stolen wand'**
  String get goalWizardReturnWand;

  /// No description provided for @goalWizardTameSpell.
  ///
  /// In en, this message translates to:
  /// **'Tame a wild spell'**
  String get goalWizardTameSpell;

  /// No description provided for @goalWizardForbiddenBook.
  ///
  /// In en, this message translates to:
  /// **'Open the forbidden book'**
  String get goalWizardForbiddenBook;

  /// No description provided for @goalWizardSaveForest.
  ///
  /// In en, this message translates to:
  /// **'Save the magic forest'**
  String get goalWizardSaveForest;

  /// No description provided for @goalWizardTameDragon.
  ///
  /// In en, this message translates to:
  /// **'Tame the fire dragon'**
  String get goalWizardTameDragon;

  /// No description provided for @goalWizardFindApprentice.
  ///
  /// In en, this message translates to:
  /// **'Find the lost apprentice'**
  String get goalWizardFindApprentice;

  /// No description provided for @locPrincessRoyalPalace.
  ///
  /// In en, this message translates to:
  /// **'Royal Palace'**
  String get locPrincessRoyalPalace;

  /// No description provided for @locPrincessEnchantedGarden.
  ///
  /// In en, this message translates to:
  /// **'Enchanted Garden'**
  String get locPrincessEnchantedGarden;

  /// No description provided for @locPrincessGlassLake.
  ///
  /// In en, this message translates to:
  /// **'Glass Lake'**
  String get locPrincessGlassLake;

  /// No description provided for @locPrincessFairyVillage.
  ///
  /// In en, this message translates to:
  /// **'Fairy Village'**
  String get locPrincessFairyVillage;

  /// No description provided for @locPrincessCloudKingdom.
  ///
  /// In en, this message translates to:
  /// **'Cloud Kingdom'**
  String get locPrincessCloudKingdom;

  /// No description provided for @locPrincessMagicBallroom.
  ///
  /// In en, this message translates to:
  /// **'Magic Ballroom'**
  String get locPrincessMagicBallroom;

  /// No description provided for @locPrincessMoonlitForest.
  ///
  /// In en, this message translates to:
  /// **'Moonlit Forest'**
  String get locPrincessMoonlitForest;

  /// No description provided for @locPrincessRainbowBridge.
  ///
  /// In en, this message translates to:
  /// **'Rainbow Bridge'**
  String get locPrincessRainbowBridge;

  /// No description provided for @goalPrincessMissingCrown.
  ///
  /// In en, this message translates to:
  /// **'Find the missing crown'**
  String get goalPrincessMissingCrown;

  /// No description provided for @goalPrincessSaveGarden.
  ///
  /// In en, this message translates to:
  /// **'Save the enchanted garden'**
  String get goalPrincessSaveGarden;

  /// No description provided for @goalPrincessRoyalBall.
  ///
  /// In en, this message translates to:
  /// **'Dance at the royal ball'**
  String get goalPrincessRoyalBall;

  /// No description provided for @goalPrincessBefriendGiant.
  ///
  /// In en, this message translates to:
  /// **'Befriend the lonely giant'**
  String get goalPrincessBefriendGiant;

  /// No description provided for @goalPrincessSolveMystery.
  ///
  /// In en, this message translates to:
  /// **'Solve the castle mystery'**
  String get goalPrincessSolveMystery;

  /// No description provided for @goalPrincessWakeKingdom.
  ///
  /// In en, this message translates to:
  /// **'Wake the sleeping kingdom'**
  String get goalPrincessWakeKingdom;

  /// No description provided for @goalPrincessRescueUnicorn.
  ///
  /// In en, this message translates to:
  /// **'Rescue the lost unicorn'**
  String get goalPrincessRescueUnicorn;

  /// No description provided for @goalPrincessMagicMirror.
  ///
  /// In en, this message translates to:
  /// **'Answer the magic mirror'**
  String get goalPrincessMagicMirror;

  /// No description provided for @locKnightDragonLair.
  ///
  /// In en, this message translates to:
  /// **'Dragon\'s Lair'**
  String get locKnightDragonLair;

  /// No description provided for @locKnightDarkForest.
  ///
  /// In en, this message translates to:
  /// **'Dark Forest'**
  String get locKnightDarkForest;

  /// No description provided for @locKnightGiantsKeep.
  ///
  /// In en, this message translates to:
  /// **'Giant\'s Keep'**
  String get locKnightGiantsKeep;

  /// No description provided for @locKnightAncientRuins.
  ///
  /// In en, this message translates to:
  /// **'Ancient Ruins'**
  String get locKnightAncientRuins;

  /// No description provided for @locKnightEnchantedBridge.
  ///
  /// In en, this message translates to:
  /// **'Enchanted Bridge'**
  String get locKnightEnchantedBridge;

  /// No description provided for @locKnightMountainPass.
  ///
  /// In en, this message translates to:
  /// **'Mountain Pass'**
  String get locKnightMountainPass;

  /// No description provided for @locKnightFairyKingdom.
  ///
  /// In en, this message translates to:
  /// **'Fairy Kingdom'**
  String get locKnightFairyKingdom;

  /// No description provided for @locKnightFrozenCastle.
  ///
  /// In en, this message translates to:
  /// **'Frozen Castle'**
  String get locKnightFrozenCastle;

  /// No description provided for @goalKnightDefeatDragon.
  ///
  /// In en, this message translates to:
  /// **'Defeat the dragon'**
  String get goalKnightDefeatDragon;

  /// No description provided for @goalKnightRescueHero.
  ///
  /// In en, this message translates to:
  /// **'Rescue the trapped hero'**
  String get goalKnightRescueHero;

  /// No description provided for @goalKnightGoldenSword.
  ///
  /// In en, this message translates to:
  /// **'Find the golden sword'**
  String get goalKnightGoldenSword;

  /// No description provided for @goalKnightProtectVillage.
  ///
  /// In en, this message translates to:
  /// **'Protect the village'**
  String get goalKnightProtectVillage;

  /// No description provided for @goalKnightBreakCurse.
  ///
  /// In en, this message translates to:
  /// **'Break the dark curse'**
  String get goalKnightBreakCurse;

  /// No description provided for @goalKnightWinTournament.
  ///
  /// In en, this message translates to:
  /// **'Win the tournament'**
  String get goalKnightWinTournament;

  /// No description provided for @goalKnightFreeCastle.
  ///
  /// In en, this message translates to:
  /// **'Free the besieged castle'**
  String get goalKnightFreeCastle;

  /// No description provided for @goalKnightMagicGrail.
  ///
  /// In en, this message translates to:
  /// **'Find the magic grail'**
  String get goalKnightMagicGrail;

  /// No description provided for @locMermaidDeepOcean.
  ///
  /// In en, this message translates to:
  /// **'Deep Ocean'**
  String get locMermaidDeepOcean;

  /// No description provided for @locMermaidCoralKingdom.
  ///
  /// In en, this message translates to:
  /// **'Coral Kingdom'**
  String get locMermaidCoralKingdom;

  /// No description provided for @locMermaidUnderwaterCave.
  ///
  /// In en, this message translates to:
  /// **'Underwater Cave'**
  String get locMermaidUnderwaterCave;

  /// No description provided for @locMermaidSeaDragonLair.
  ///
  /// In en, this message translates to:
  /// **'Sea Dragon\'s Lair'**
  String get locMermaidSeaDragonLair;

  /// No description provided for @locMermaidSunkenCity.
  ///
  /// In en, this message translates to:
  /// **'Sunken City'**
  String get locMermaidSunkenCity;

  /// No description provided for @locMermaidRainbowReef.
  ///
  /// In en, this message translates to:
  /// **'Rainbow Reef'**
  String get locMermaidRainbowReef;

  /// No description provided for @locMermaidPearlGrotto.
  ///
  /// In en, this message translates to:
  /// **'Pearl Grotto'**
  String get locMermaidPearlGrotto;

  /// No description provided for @locMermaidWhirlpoolSea.
  ///
  /// In en, this message translates to:
  /// **'Whirlpool Sea'**
  String get locMermaidWhirlpoolSea;

  /// No description provided for @goalMermaidStolenPearl.
  ///
  /// In en, this message translates to:
  /// **'Find the stolen pearl'**
  String get goalMermaidStolenPearl;

  /// No description provided for @goalMermaidSaveReef.
  ///
  /// In en, this message translates to:
  /// **'Save the coral reef'**
  String get goalMermaidSaveReef;

  /// No description provided for @goalMermaidFriendShark.
  ///
  /// In en, this message translates to:
  /// **'Befriend a lonely shark'**
  String get goalMermaidFriendShark;

  /// No description provided for @goalMermaidSunkenTreasure.
  ///
  /// In en, this message translates to:
  /// **'Recover sunken treasure'**
  String get goalMermaidSunkenTreasure;

  /// No description provided for @goalMermaidGuideFish.
  ///
  /// In en, this message translates to:
  /// **'Guide the lost fish home'**
  String get goalMermaidGuideFish;

  /// No description provided for @goalMermaidStopStorm.
  ///
  /// In en, this message translates to:
  /// **'Stop the ocean storm'**
  String get goalMermaidStopStorm;

  /// No description provided for @goalMermaidOutwitWitch.
  ///
  /// In en, this message translates to:
  /// **'Outwit the sea witch'**
  String get goalMermaidOutwitWitch;

  /// No description provided for @goalMermaidWhaleSecret.
  ///
  /// In en, this message translates to:
  /// **'Hear the whale\'s secret'**
  String get goalMermaidWhaleSecret;

  /// No description provided for @locSuperherooBigCity.
  ///
  /// In en, this message translates to:
  /// **'Big City'**
  String get locSuperherooBigCity;

  /// No description provided for @locSuperheroSecretBase.
  ///
  /// In en, this message translates to:
  /// **'Secret Base'**
  String get locSuperheroSecretBase;

  /// No description provided for @locSuperheroVolcanoIsland.
  ///
  /// In en, this message translates to:
  /// **'Volcano Island'**
  String get locSuperheroVolcanoIsland;

  /// No description provided for @locSuperheroOuterSpace.
  ///
  /// In en, this message translates to:
  /// **'Outer Space'**
  String get locSuperheroOuterSpace;

  /// No description provided for @locSuperheroUnderwaterCity.
  ///
  /// In en, this message translates to:
  /// **'Underwater City'**
  String get locSuperheroUnderwaterCity;

  /// No description provided for @locSuperheroStormCloud.
  ///
  /// In en, this message translates to:
  /// **'Storm Cloud'**
  String get locSuperheroStormCloud;

  /// No description provided for @locSuperheroCityRooftops.
  ///
  /// In en, this message translates to:
  /// **'City Rooftops'**
  String get locSuperheroCityRooftops;

  /// No description provided for @locSuperheroTimePortal.
  ///
  /// In en, this message translates to:
  /// **'Time Portal'**
  String get locSuperheroTimePortal;

  /// No description provided for @goalSuperheroStopMeteor.
  ///
  /// In en, this message translates to:
  /// **'Stop the falling meteor'**
  String get goalSuperheroStopMeteor;

  /// No description provided for @goalSuperheroSaveFlood.
  ///
  /// In en, this message translates to:
  /// **'Save city from flood'**
  String get goalSuperheroSaveFlood;

  /// No description provided for @goalSuperheroCatchVillain.
  ///
  /// In en, this message translates to:
  /// **'Catch the sneaky villain'**
  String get goalSuperheroCatchVillain;

  /// No description provided for @goalSuperheroProtectSecret.
  ///
  /// In en, this message translates to:
  /// **'Protect a secret identity'**
  String get goalSuperheroProtectSecret;

  /// No description provided for @goalSuperheroSavePuppy.
  ///
  /// In en, this message translates to:
  /// **'Save a scared puppy'**
  String get goalSuperheroSavePuppy;

  /// No description provided for @goalSuperheroRestorePowers.
  ///
  /// In en, this message translates to:
  /// **'Restore lost powers'**
  String get goalSuperheroRestorePowers;

  /// No description provided for @goalSuperheroStopRobot.
  ///
  /// In en, this message translates to:
  /// **'Stop the evil robot'**
  String get goalSuperheroStopRobot;

  /// No description provided for @goalSuperheroRescueScientist.
  ///
  /// In en, this message translates to:
  /// **'Rescue the scientist'**
  String get goalSuperheroRescueScientist;

  /// No description provided for @locChefMagicKitchen.
  ///
  /// In en, this message translates to:
  /// **'Magic Kitchen'**
  String get locChefMagicKitchen;

  /// No description provided for @locChefEnchantedFarm.
  ///
  /// In en, this message translates to:
  /// **'Enchanted Farm'**
  String get locChefEnchantedFarm;

  /// No description provided for @locChefCandyLand.
  ///
  /// In en, this message translates to:
  /// **'Candy Land'**
  String get locChefCandyLand;

  /// No description provided for @locChefSecretGarden.
  ///
  /// In en, this message translates to:
  /// **'Secret Garden'**
  String get locChefSecretGarden;

  /// No description provided for @locChefGiantMarket.
  ///
  /// In en, this message translates to:
  /// **'Giant Market'**
  String get locChefGiantMarket;

  /// No description provided for @locChefFloatingRestaurant.
  ///
  /// In en, this message translates to:
  /// **'Floating Restaurant'**
  String get locChefFloatingRestaurant;

  /// No description provided for @locChefDragonBakery.
  ///
  /// In en, this message translates to:
  /// **'Dragon Bakery'**
  String get locChefDragonBakery;

  /// No description provided for @locChefMoonlitVineyard.
  ///
  /// In en, this message translates to:
  /// **'Moonlit Vineyard'**
  String get locChefMoonlitVineyard;

  /// No description provided for @goalChefMagicalDish.
  ///
  /// In en, this message translates to:
  /// **'Create the magical dish'**
  String get goalChefMagicalDish;

  /// No description provided for @goalChefMissingIngredient.
  ///
  /// In en, this message translates to:
  /// **'Find the missing ingredient'**
  String get goalChefMissingIngredient;

  /// No description provided for @goalChefCookDragon.
  ///
  /// In en, this message translates to:
  /// **'Cook for a hungry dragon'**
  String get goalChefCookDragon;

  /// No description provided for @goalChefWinContest.
  ///
  /// In en, this message translates to:
  /// **'Win the cooking contest'**
  String get goalChefWinContest;

  /// No description provided for @goalChefStolenRecipe.
  ///
  /// In en, this message translates to:
  /// **'Rescue the stolen recipe'**
  String get goalChefStolenRecipe;

  /// No description provided for @goalChefFeedKingdom.
  ///
  /// In en, this message translates to:
  /// **'Feed the whole kingdom'**
  String get goalChefFeedKingdom;

  /// No description provided for @goalChefImpossibleCake.
  ///
  /// In en, this message translates to:
  /// **'Bake the impossible cake'**
  String get goalChefImpossibleCake;

  /// No description provided for @goalChefCalmIngredients.
  ///
  /// In en, this message translates to:
  /// **'Calm the angry ingredients'**
  String get goalChefCalmIngredients;

  /// No description provided for @locScientistSecretLab.
  ///
  /// In en, this message translates to:
  /// **'Secret Lab'**
  String get locScientistSecretLab;

  /// No description provided for @locScientistUnderwaterStation.
  ///
  /// In en, this message translates to:
  /// **'Underwater Station'**
  String get locScientistUnderwaterStation;

  /// No description provided for @locScientistArcticBase.
  ///
  /// In en, this message translates to:
  /// **'Arctic Base'**
  String get locScientistArcticBase;

  /// No description provided for @locScientistSpaceObservatory.
  ///
  /// In en, this message translates to:
  /// **'Space Observatory'**
  String get locScientistSpaceObservatory;

  /// No description provided for @locScientistJungleResearch.
  ///
  /// In en, this message translates to:
  /// **'Jungle Research'**
  String get locScientistJungleResearch;

  /// No description provided for @locScientistVolcanoLab.
  ///
  /// In en, this message translates to:
  /// **'Volcano Lab'**
  String get locScientistVolcanoLab;

  /// No description provided for @locScientistCloudLab.
  ///
  /// In en, this message translates to:
  /// **'Cloud Laboratory'**
  String get locScientistCloudLab;

  /// No description provided for @locScientistFutureCity.
  ///
  /// In en, this message translates to:
  /// **'Future City'**
  String get locScientistFutureCity;

  /// No description provided for @goalScientistNewElement.
  ///
  /// In en, this message translates to:
  /// **'Discover a new element'**
  String get goalScientistNewElement;

  /// No description provided for @goalScientistFixExperiment.
  ///
  /// In en, this message translates to:
  /// **'Fix the broken experiment'**
  String get goalScientistFixExperiment;

  /// No description provided for @goalScientistStopVirus.
  ///
  /// In en, this message translates to:
  /// **'Stop the spreading virus'**
  String get goalScientistStopVirus;

  /// No description provided for @goalScientistTimeMachine.
  ///
  /// In en, this message translates to:
  /// **'Build the time machine'**
  String get goalScientistTimeMachine;

  /// No description provided for @goalScientistAlienEquation.
  ///
  /// In en, this message translates to:
  /// **'Solve the alien equation'**
  String get goalScientistAlienEquation;

  /// No description provided for @goalScientistSaveIceberg.
  ///
  /// In en, this message translates to:
  /// **'Save the melting iceberg'**
  String get goalScientistSaveIceberg;

  /// No description provided for @goalScientistReverseShrink.
  ///
  /// In en, this message translates to:
  /// **'Reverse the shrink ray'**
  String get goalScientistReverseShrink;

  /// No description provided for @goalScientistTameCreature.
  ///
  /// In en, this message translates to:
  /// **'Tame the giant creature'**
  String get goalScientistTameCreature;

  /// No description provided for @locNinjaHiddenTemple.
  ///
  /// In en, this message translates to:
  /// **'Hidden Temple'**
  String get locNinjaHiddenTemple;

  /// No description provided for @locNinjaBambooForest.
  ///
  /// In en, this message translates to:
  /// **'Bamboo Forest'**
  String get locNinjaBambooForest;

  /// No description provided for @locNinjaMountainFortress.
  ///
  /// In en, this message translates to:
  /// **'Mountain Fortress'**
  String get locNinjaMountainFortress;

  /// No description provided for @locNinjaShadowCity.
  ///
  /// In en, this message translates to:
  /// **'Shadow City'**
  String get locNinjaShadowCity;

  /// No description provided for @locNinjaUndergroundMaze.
  ///
  /// In en, this message translates to:
  /// **'Underground Maze'**
  String get locNinjaUndergroundMaze;

  /// No description provided for @locNinjaAncientRuins.
  ///
  /// In en, this message translates to:
  /// **'Ancient Ruins'**
  String get locNinjaAncientRuins;

  /// No description provided for @locNinjaRooftopVillage.
  ///
  /// In en, this message translates to:
  /// **'Rooftop Village'**
  String get locNinjaRooftopVillage;

  /// No description provided for @locNinjaFogValley.
  ///
  /// In en, this message translates to:
  /// **'Fog Valley'**
  String get locNinjaFogValley;

  /// No description provided for @goalNinjaStolenScroll.
  ///
  /// In en, this message translates to:
  /// **'Retrieve the stolen scroll'**
  String get goalNinjaStolenScroll;

  /// No description provided for @goalNinjaStopShadowVillain.
  ///
  /// In en, this message translates to:
  /// **'Stop the shadow villain'**
  String get goalNinjaStopShadowVillain;

  /// No description provided for @goalNinjaMasterMove.
  ///
  /// In en, this message translates to:
  /// **'Master the secret move'**
  String get goalNinjaMasterMove;

  /// No description provided for @goalNinjaProtectVillage.
  ///
  /// In en, this message translates to:
  /// **'Protect the hidden village'**
  String get goalNinjaProtectVillage;

  /// No description provided for @goalNinjaUncoverMystery.
  ///
  /// In en, this message translates to:
  /// **'Uncover the dark mystery'**
  String get goalNinjaUncoverMystery;

  /// No description provided for @goalNinjaRescueMaster.
  ///
  /// In en, this message translates to:
  /// **'Rescue the trapped master'**
  String get goalNinjaRescueMaster;

  /// No description provided for @goalNinjaFindWeapon.
  ///
  /// In en, this message translates to:
  /// **'Find the ancient weapon'**
  String get goalNinjaFindWeapon;

  /// No description provided for @goalNinjaLearnTechnique.
  ///
  /// In en, this message translates to:
  /// **'Learn the forbidden technique'**
  String get goalNinjaLearnTechnique;

  /// No description provided for @locExplorerAmazonJungle.
  ///
  /// In en, this message translates to:
  /// **'Amazon Jungle'**
  String get locExplorerAmazonJungle;

  /// No description provided for @locExplorerArcticTundra.
  ///
  /// In en, this message translates to:
  /// **'Arctic Tundra'**
  String get locExplorerArcticTundra;

  /// No description provided for @locExplorerLostDesert.
  ///
  /// In en, this message translates to:
  /// **'Lost Desert'**
  String get locExplorerLostDesert;

  /// No description provided for @locExplorerHiddenValley.
  ///
  /// In en, this message translates to:
  /// **'Hidden Valley'**
  String get locExplorerHiddenValley;

  /// No description provided for @locExplorerMistyMountains.
  ///
  /// In en, this message translates to:
  /// **'Misty Mountains'**
  String get locExplorerMistyMountains;

  /// No description provided for @locExplorerUnderwaterCaves.
  ///
  /// In en, this message translates to:
  /// **'Underwater Caves'**
  String get locExplorerUnderwaterCaves;

  /// No description provided for @locExplorerFloatingIslands.
  ///
  /// In en, this message translates to:
  /// **'Floating Islands'**
  String get locExplorerFloatingIslands;

  /// No description provided for @locExplorerUndergroundCity.
  ///
  /// In en, this message translates to:
  /// **'Underground City'**
  String get locExplorerUndergroundCity;

  /// No description provided for @goalExplorerMapIsland.
  ///
  /// In en, this message translates to:
  /// **'Map the lost island'**
  String get goalExplorerMapIsland;

  /// No description provided for @goalExplorerCrossJungle.
  ///
  /// In en, this message translates to:
  /// **'Cross the dangerous jungle'**
  String get goalExplorerCrossJungle;

  /// No description provided for @goalExplorerDiscoverTemple.
  ///
  /// In en, this message translates to:
  /// **'Discover the hidden temple'**
  String get goalExplorerDiscoverTemple;

  /// No description provided for @goalExplorerFindWaterfall.
  ///
  /// In en, this message translates to:
  /// **'Find the magic waterfall'**
  String get goalExplorerFindWaterfall;

  /// No description provided for @goalExplorerTrackCreature.
  ///
  /// In en, this message translates to:
  /// **'Track the rare creature'**
  String get goalExplorerTrackCreature;

  /// No description provided for @goalExplorerReachPeak.
  ///
  /// In en, this message translates to:
  /// **'Reach the mountain peak'**
  String get goalExplorerReachPeak;

  /// No description provided for @goalExplorerFindTribe.
  ///
  /// In en, this message translates to:
  /// **'Find the lost tribe'**
  String get goalExplorerFindTribe;

  /// No description provided for @goalExplorerUncoverCity.
  ///
  /// In en, this message translates to:
  /// **'Uncover a buried city'**
  String get goalExplorerUncoverCity;

  /// No description provided for @locVetMagicJungle.
  ///
  /// In en, this message translates to:
  /// **'Magic Jungle'**
  String get locVetMagicJungle;

  /// No description provided for @locVetArcticTundra.
  ///
  /// In en, this message translates to:
  /// **'Arctic Tundra'**
  String get locVetArcticTundra;

  /// No description provided for @locVetOceanReef.
  ///
  /// In en, this message translates to:
  /// **'Ocean Reef'**
  String get locVetOceanReef;

  /// No description provided for @locVetEnchantedForest.
  ///
  /// In en, this message translates to:
  /// **'Enchanted Forest'**
  String get locVetEnchantedForest;

  /// No description provided for @locVetSafariPlains.
  ///
  /// In en, this message translates to:
  /// **'Safari Plains'**
  String get locVetSafariPlains;

  /// No description provided for @locVetUndergroundWorld.
  ///
  /// In en, this message translates to:
  /// **'Underground World'**
  String get locVetUndergroundWorld;

  /// No description provided for @locVetCloudSanctuary.
  ///
  /// In en, this message translates to:
  /// **'Cloud Sanctuary'**
  String get locVetCloudSanctuary;

  /// No description provided for @locVetDesertOasis.
  ///
  /// In en, this message translates to:
  /// **'Desert Oasis'**
  String get locVetDesertOasis;

  /// No description provided for @goalVetHealDragon.
  ///
  /// In en, this message translates to:
  /// **'Heal the sick dragon'**
  String get goalVetHealDragon;

  /// No description provided for @goalVetSaveBabyWhale.
  ///
  /// In en, this message translates to:
  /// **'Save a lost baby whale'**
  String get goalVetSaveBabyWhale;

  /// No description provided for @goalVetHelpWolf.
  ///
  /// In en, this message translates to:
  /// **'Help the scared wolf'**
  String get goalVetHelpWolf;

  /// No description provided for @goalVetCureFever.
  ///
  /// In en, this message translates to:
  /// **'Cure the magical fever'**
  String get goalVetCureFever;

  /// No description provided for @goalVetRescueAnimals.
  ///
  /// In en, this message translates to:
  /// **'Rescue animals from flood'**
  String get goalVetRescueAnimals;

  /// No description provided for @goalVetFindAnimalFamily.
  ///
  /// In en, this message translates to:
  /// **'Find the lost animal family'**
  String get goalVetFindAnimalFamily;

  /// No description provided for @goalVetInvisibleCreature.
  ///
  /// In en, this message translates to:
  /// **'Find the invisible creature'**
  String get goalVetInvisibleCreature;

  /// No description provided for @goalVetWarmBirds.
  ///
  /// In en, this message translates to:
  /// **'Warm up the freezing birds'**
  String get goalVetWarmBirds;

  /// No description provided for @locInventorSkyWorkshop.
  ///
  /// In en, this message translates to:
  /// **'Sky Workshop'**
  String get locInventorSkyWorkshop;

  /// No description provided for @locInventorUndergroundFactory.
  ///
  /// In en, this message translates to:
  /// **'Underground Factory'**
  String get locInventorUndergroundFactory;

  /// No description provided for @locInventorMagicLibrary.
  ///
  /// In en, this message translates to:
  /// **'Magic Library'**
  String get locInventorMagicLibrary;

  /// No description provided for @locInventorCrystalMountain.
  ///
  /// In en, this message translates to:
  /// **'Crystal Mountain'**
  String get locInventorCrystalMountain;

  /// No description provided for @locInventorFutureMuseum.
  ///
  /// In en, this message translates to:
  /// **'Future Museum'**
  String get locInventorFutureMuseum;

  /// No description provided for @locInventorCloudWorkshop.
  ///
  /// In en, this message translates to:
  /// **'Cloud Workshop'**
  String get locInventorCloudWorkshop;

  /// No description provided for @locInventorRobotCity.
  ///
  /// In en, this message translates to:
  /// **'Robot City'**
  String get locInventorRobotCity;

  /// No description provided for @locInventorVolcanoForge.
  ///
  /// In en, this message translates to:
  /// **'Volcano Forge'**
  String get locInventorVolcanoForge;

  /// No description provided for @goalInventorBuildMachine.
  ///
  /// In en, this message translates to:
  /// **'Build the magical machine'**
  String get goalInventorBuildMachine;

  /// No description provided for @goalInventorFixCity.
  ///
  /// In en, this message translates to:
  /// **'Fix the broken city'**
  String get goalInventorFixCity;

  /// No description provided for @goalInventorRainbowBridge.
  ///
  /// In en, this message translates to:
  /// **'Create a rainbow bridge'**
  String get goalInventorRainbowBridge;

  /// No description provided for @goalInventorSolvePuzzle.
  ///
  /// In en, this message translates to:
  /// **'Solve the impossible puzzle'**
  String get goalInventorSolvePuzzle;

  /// No description provided for @goalInventorPowerLighthouse.
  ///
  /// In en, this message translates to:
  /// **'Power up the lighthouse'**
  String get goalInventorPowerLighthouse;

  /// No description provided for @goalInventorDreamToy.
  ///
  /// In en, this message translates to:
  /// **'Build the dream toy'**
  String get goalInventorDreamToy;

  /// No description provided for @goalInventorFlyingShip.
  ///
  /// In en, this message translates to:
  /// **'Finish the flying ship'**
  String get goalInventorFlyingShip;

  /// No description provided for @goalInventorWakeRobot.
  ///
  /// In en, this message translates to:
  /// **'Wake up a sleeping robot'**
  String get goalInventorWakeRobot;

  /// No description provided for @locDinoHunterDinoValley.
  ///
  /// In en, this message translates to:
  /// **'Dino Valley'**
  String get locDinoHunterDinoValley;

  /// No description provided for @locDinoHunterAncientDesert.
  ///
  /// In en, this message translates to:
  /// **'Ancient Desert'**
  String get locDinoHunterAncientDesert;

  /// No description provided for @locDinoHunterUndergroundCave.
  ///
  /// In en, this message translates to:
  /// **'Underground Cave'**
  String get locDinoHunterUndergroundCave;

  /// No description provided for @locDinoHunterTimePortal.
  ///
  /// In en, this message translates to:
  /// **'Time Portal'**
  String get locDinoHunterTimePortal;

  /// No description provided for @locDinoHunterFossilBeach.
  ///
  /// In en, this message translates to:
  /// **'Fossil Beach'**
  String get locDinoHunterFossilBeach;

  /// No description provided for @locDinoHunterPrehistoricForest.
  ///
  /// In en, this message translates to:
  /// **'Prehistoric Forest'**
  String get locDinoHunterPrehistoricForest;

  /// No description provided for @locDinoHunterAmberJungle.
  ///
  /// In en, this message translates to:
  /// **'Amber Jungle'**
  String get locDinoHunterAmberJungle;

  /// No description provided for @locDinoHunterVolcanicBadlands.
  ///
  /// In en, this message translates to:
  /// **'Volcanic Badlands'**
  String get locDinoHunterVolcanicBadlands;

  /// No description provided for @goalDinoHunterHiddenFossil.
  ///
  /// In en, this message translates to:
  /// **'Uncover the hidden fossil'**
  String get goalDinoHunterHiddenFossil;

  /// No description provided for @goalDinoHunterBabyDino.
  ///
  /// In en, this message translates to:
  /// **'Befriend a baby dinosaur'**
  String get goalDinoHunterBabyDino;

  /// No description provided for @goalDinoHunterSolveMystery.
  ///
  /// In en, this message translates to:
  /// **'Solve the ancient mystery'**
  String get goalDinoHunterSolveMystery;

  /// No description provided for @goalDinoHunterSaveDinoEggs.
  ///
  /// In en, this message translates to:
  /// **'Save the dino eggs'**
  String get goalDinoHunterSaveDinoEggs;

  /// No description provided for @goalDinoHunterDecodeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Decode ancient language'**
  String get goalDinoHunterDecodeLanguage;

  /// No description provided for @goalDinoHunterRescueTraveler.
  ///
  /// In en, this message translates to:
  /// **'Rescue the time traveler'**
  String get goalDinoHunterRescueTraveler;

  /// No description provided for @goalDinoHunterMeteorCrater.
  ///
  /// In en, this message translates to:
  /// **'Find the meteor crater'**
  String get goalDinoHunterMeteorCrater;

  /// No description provided for @goalDinoHunterStopStampede.
  ///
  /// In en, this message translates to:
  /// **'Stop the dino stampede'**
  String get goalDinoHunterStopStampede;

  /// No description provided for @locFirefighterBurningForest.
  ///
  /// In en, this message translates to:
  /// **'Burning Forest'**
  String get locFirefighterBurningForest;

  /// No description provided for @locFirefighterMagicCity.
  ///
  /// In en, this message translates to:
  /// **'Magic City'**
  String get locFirefighterMagicCity;

  /// No description provided for @locFirefighterVolcanoIsland.
  ///
  /// In en, this message translates to:
  /// **'Volcano Island'**
  String get locFirefighterVolcanoIsland;

  /// No description provided for @locFirefighterCrystalTower.
  ///
  /// In en, this message translates to:
  /// **'Crystal Tower'**
  String get locFirefighterCrystalTower;

  /// No description provided for @locFirefighterCloudTown.
  ///
  /// In en, this message translates to:
  /// **'Cloud Town'**
  String get locFirefighterCloudTown;

  /// No description provided for @locFirefighterAncientRuins.
  ///
  /// In en, this message translates to:
  /// **'Ancient Ruins'**
  String get locFirefighterAncientRuins;

  /// No description provided for @locFirefighterHauntedMansion.
  ///
  /// In en, this message translates to:
  /// **'Haunted Mansion'**
  String get locFirefighterHauntedMansion;

  /// No description provided for @locFirefighterIcePalace.
  ///
  /// In en, this message translates to:
  /// **'Ice Palace'**
  String get locFirefighterIcePalace;

  /// No description provided for @goalFirefighterStopFire.
  ///
  /// In en, this message translates to:
  /// **'Stop the forest fire'**
  String get goalFirefighterStopFire;

  /// No description provided for @goalFirefighterRescueFamily.
  ///
  /// In en, this message translates to:
  /// **'Rescue the trapped family'**
  String get goalFirefighterRescueFamily;

  /// No description provided for @goalFirefighterPutOutVolcano.
  ///
  /// In en, this message translates to:
  /// **'Put out the volcano'**
  String get goalFirefighterPutOutVolcano;

  /// No description provided for @goalFirefighterSaveLibrary.
  ///
  /// In en, this message translates to:
  /// **'Save the magic library'**
  String get goalFirefighterSaveLibrary;

  /// No description provided for @goalFirefighterAnimalsEscape.
  ///
  /// In en, this message translates to:
  /// **'Help animals escape'**
  String get goalFirefighterAnimalsEscape;

  /// No description provided for @goalFirefighterProtectCloud.
  ///
  /// In en, this message translates to:
  /// **'Protect the cloud town'**
  String get goalFirefighterProtectCloud;

  /// No description provided for @goalFirefighterMagicHose.
  ///
  /// In en, this message translates to:
  /// **'Find the magic hose'**
  String get goalFirefighterMagicHose;

  /// No description provided for @goalFirefighterFreezeDragon.
  ///
  /// In en, this message translates to:
  /// **'Freeze the fire dragon'**
  String get goalFirefighterFreezeDragon;

  /// No description provided for @locRobotPilotSpaceStation.
  ///
  /// In en, this message translates to:
  /// **'Space Station'**
  String get locRobotPilotSpaceStation;

  /// No description provided for @locRobotPilotRobotFactory.
  ///
  /// In en, this message translates to:
  /// **'Robot Factory'**
  String get locRobotPilotRobotFactory;

  /// No description provided for @locRobotPilotFutureCity.
  ///
  /// In en, this message translates to:
  /// **'Future City'**
  String get locRobotPilotFutureCity;

  /// No description provided for @locRobotPilotCloudHighway.
  ///
  /// In en, this message translates to:
  /// **'Cloud Highway'**
  String get locRobotPilotCloudHighway;

  /// No description provided for @locRobotPilotDigitalWorld.
  ///
  /// In en, this message translates to:
  /// **'Digital World'**
  String get locRobotPilotDigitalWorld;

  /// No description provided for @locRobotPilotCrystalNebula.
  ///
  /// In en, this message translates to:
  /// **'Crystal Nebula'**
  String get locRobotPilotCrystalNebula;

  /// No description provided for @locRobotPilotGiantHangar.
  ///
  /// In en, this message translates to:
  /// **'Giant Hangar'**
  String get locRobotPilotGiantHangar;

  /// No description provided for @locRobotPilotIonStorm.
  ///
  /// In en, this message translates to:
  /// **'Ion Storm Zone'**
  String get locRobotPilotIonStorm;

  /// No description provided for @goalRobotPilotRepairSatellite.
  ///
  /// In en, this message translates to:
  /// **'Repair the satellite'**
  String get goalRobotPilotRepairSatellite;

  /// No description provided for @goalRobotPilotNavigateAsteroid.
  ///
  /// In en, this message translates to:
  /// **'Navigate an asteroid belt'**
  String get goalRobotPilotNavigateAsteroid;

  /// No description provided for @goalRobotPilotRescueRobot.
  ///
  /// In en, this message translates to:
  /// **'Rescue the lost robot'**
  String get goalRobotPilotRescueRobot;

  /// No description provided for @goalRobotPilotWinRace.
  ///
  /// In en, this message translates to:
  /// **'Win the flying race'**
  String get goalRobotPilotWinRace;

  /// No description provided for @goalRobotPilotDecodeSignal.
  ///
  /// In en, this message translates to:
  /// **'Decode the alien signal'**
  String get goalRobotPilotDecodeSignal;

  /// No description provided for @goalRobotPilotPreventCrash.
  ///
  /// In en, this message translates to:
  /// **'Prevent the crash'**
  String get goalRobotPilotPreventCrash;

  /// No description provided for @goalRobotPilotRestorePower.
  ///
  /// In en, this message translates to:
  /// **'Restore the power core'**
  String get goalRobotPilotRestorePower;

  /// No description provided for @goalRobotPilotCalmRobots.
  ///
  /// In en, this message translates to:
  /// **'Calm the robot uprising'**
  String get goalRobotPilotCalmRobots;

  /// No description provided for @locDefaultMagicForest.
  ///
  /// In en, this message translates to:
  /// **'Magic Forest'**
  String get locDefaultMagicForest;

  /// No description provided for @locDefaultCloudKingdom.
  ///
  /// In en, this message translates to:
  /// **'Cloud Kingdom'**
  String get locDefaultCloudKingdom;

  /// No description provided for @locDefaultDeepOcean.
  ///
  /// In en, this message translates to:
  /// **'Deep Ocean'**
  String get locDefaultDeepOcean;

  /// No description provided for @locDefaultMagicCastle.
  ///
  /// In en, this message translates to:
  /// **'Magic Castle'**
  String get locDefaultMagicCastle;

  /// No description provided for @locDefaultVolcanoIsland.
  ///
  /// In en, this message translates to:
  /// **'Volcano Island'**
  String get locDefaultVolcanoIsland;

  /// No description provided for @locDefaultOuterSpace.
  ///
  /// In en, this message translates to:
  /// **'Outer Space'**
  String get locDefaultOuterSpace;

  /// No description provided for @goalDefaultFindTreasure.
  ///
  /// In en, this message translates to:
  /// **'Find the treasure'**
  String get goalDefaultFindTreasure;

  /// No description provided for @goalDefaultRescueFriend.
  ///
  /// In en, this message translates to:
  /// **'Rescue a friend'**
  String get goalDefaultRescueFriend;

  /// No description provided for @goalDefaultBefriendMonster.
  ///
  /// In en, this message translates to:
  /// **'Befriend a monster'**
  String get goalDefaultBefriendMonster;

  /// No description provided for @goalDefaultSolveMystery.
  ///
  /// In en, this message translates to:
  /// **'Solve a mystery'**
  String get goalDefaultSolveMystery;

  /// No description provided for @goalDefaultSaveLand.
  ///
  /// In en, this message translates to:
  /// **'Save the land'**
  String get goalDefaultSaveLand;

  /// No description provided for @goalDefaultWinRace.
  ///
  /// In en, this message translates to:
  /// **'Win the big race'**
  String get goalDefaultWinRace;

  /// No description provided for @homeTabTonight.
  ///
  /// In en, this message translates to:
  /// **'TONIGHT'**
  String get homeTabTonight;

  /// No description provided for @homeTabLibrary.
  ///
  /// In en, this message translates to:
  /// **'LIBRARY'**
  String get homeTabLibrary;

  /// No description provided for @homeTabSettings.
  ///
  /// In en, this message translates to:
  /// **'SETTINGS'**
  String get homeTabSettings;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Good evening, {heroName}'**
  String homeGreeting(String heroName);

  /// No description provided for @homeGreetingGeneric.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get homeGreetingGeneric;

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ready for tonight\'s adventure?'**
  String get homeSubtitle;

  /// No description provided for @homeContinueReading.
  ///
  /// In en, this message translates to:
  /// **'Continue reading'**
  String get homeContinueReading;

  /// No description provided for @homeLibrarySection.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get homeLibrarySection;

  /// No description provided for @homeFilterRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get homeFilterRecent;

  /// No description provided for @homeFilterFavourites.
  ///
  /// In en, this message translates to:
  /// **'Favourites'**
  String get homeFilterFavourites;

  /// No description provided for @homeEmptyFavouritesTitle.
  ///
  /// In en, this message translates to:
  /// **'No favourites yet'**
  String get homeEmptyFavouritesTitle;

  /// No description provided for @homeEmptyFavouritesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap the heart on a story to save it here.'**
  String get homeEmptyFavouritesSubtitle;

  /// No description provided for @homeEmptyStoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Your adventures begin tonight'**
  String get homeEmptyStoriesTitle;

  /// No description provided for @homeEmptyStoriesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap Tonight\'s Adventure to create your first story.'**
  String get homeEmptyStoriesSubtitle;

  /// No description provided for @homeStartNow.
  ///
  /// In en, this message translates to:
  /// **'Start now'**
  String get homeStartNow;

  /// No description provided for @homeCreateHero.
  ///
  /// In en, this message translates to:
  /// **'Create a hero'**
  String get homeCreateHero;

  /// No description provided for @homeAddHero.
  ///
  /// In en, this message translates to:
  /// **'Add hero'**
  String get homeAddHero;

  /// No description provided for @homeAdventureChip.
  ///
  /// In en, this message translates to:
  /// **'Adventure →'**
  String get homeAdventureChip;

  /// No description provided for @homeOfflineIndicator.
  ///
  /// In en, this message translates to:
  /// **'Offline — cached stories'**
  String get homeOfflineIndicator;

  /// No description provided for @homeDeleteHeroError.
  ///
  /// In en, this message translates to:
  /// **'Could not delete hero. Please try again.'**
  String get homeDeleteHeroError;

  /// No description provided for @homeDeleteHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete {heroName}?'**
  String homeDeleteHeroTitle(String heroName);

  /// No description provided for @homeDeleteHeroMessage.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete {heroName}\'s hero profile. Stories created with this hero will remain in your library.'**
  String homeDeleteHeroMessage(String heroName);

  /// No description provided for @homeDialogCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get homeDialogCancel;

  /// No description provided for @homeDialogDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get homeDialogDelete;

  /// No description provided for @homePageCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 page} other{{count} pages}}'**
  String homePageCount(int count);

  /// No description provided for @generationLoadingDrawing.
  ///
  /// In en, this message translates to:
  /// **'Drawing {name}\'s adventure...'**
  String generationLoadingDrawing(String name);

  /// No description provided for @generationLoadingWriting.
  ///
  /// In en, this message translates to:
  /// **'Writing tonight\'s story...'**
  String get generationLoadingWriting;

  /// No description provided for @generationLoadingPainting.
  ///
  /// In en, this message translates to:
  /// **'Painting the moon...'**
  String get generationLoadingPainting;

  /// No description provided for @generationLoadingMixing.
  ///
  /// In en, this message translates to:
  /// **'Mixing the perfect colours...'**
  String get generationLoadingMixing;

  /// No description provided for @generationLoadingMagic.
  ///
  /// In en, this message translates to:
  /// **'Adding a sprinkle of magic...'**
  String get generationLoadingMagic;

  /// No description provided for @generationLoadingAlmost.
  ///
  /// In en, this message translates to:
  /// **'Almost ready...'**
  String get generationLoadingAlmost;

  /// No description provided for @generationCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get generationCancel;

  /// No description provided for @generationErrorDailyLimit.
  ///
  /// In en, this message translates to:
  /// **'Daily story limit reached.\nNew stories available tomorrow at midnight.'**
  String get generationErrorDailyLimit;

  /// No description provided for @generationErrorFreeTier.
  ///
  /// In en, this message translates to:
  /// **'Your free story has been used.\nUpgrade to create more stories.'**
  String get generationErrorFreeTier;

  /// No description provided for @generationErrorContent.
  ///
  /// In en, this message translates to:
  /// **'The story content could not be approved.\nPlease try different settings.'**
  String get generationErrorContent;

  /// No description provided for @generationErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Story generation failed.\nPlease check your connection and try again.'**
  String get generationErrorGeneric;

  /// No description provided for @generationRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get generationRetry;

  /// No description provided for @generationBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get generationBack;

  /// No description provided for @readerListen.
  ///
  /// In en, this message translates to:
  /// **'Listen'**
  String get readerListen;

  /// No description provided for @readerPause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get readerPause;

  /// No description provided for @readerPageIndicator.
  ///
  /// In en, this message translates to:
  /// **'{current} / {total}'**
  String readerPageIndicator(int current, int total);

  /// No description provided for @readerErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not load story'**
  String get readerErrorTitle;

  /// No description provided for @readerErrorBack.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get readerErrorBack;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsSectionAccount.
  ///
  /// In en, this message translates to:
  /// **'ACCOUNT'**
  String get settingsSectionAccount;

  /// No description provided for @settingsSignedInFallback.
  ///
  /// In en, this message translates to:
  /// **'Signed in'**
  String get settingsSignedInFallback;

  /// No description provided for @settingsPremiumLabel.
  ///
  /// In en, this message translates to:
  /// **'Premium subscriber'**
  String get settingsPremiumLabel;

  /// No description provided for @settingsFreePlan.
  ///
  /// In en, this message translates to:
  /// **'Free plan'**
  String get settingsFreePlan;

  /// No description provided for @settingsPremiumBadge.
  ///
  /// In en, this message translates to:
  /// **'PREMIUM'**
  String get settingsPremiumBadge;

  /// No description provided for @settingsFreeBadge.
  ///
  /// In en, this message translates to:
  /// **'FREE'**
  String get settingsFreeBadge;

  /// No description provided for @settingsManageSubscription.
  ///
  /// In en, this message translates to:
  /// **'Manage subscription'**
  String get settingsManageSubscription;

  /// No description provided for @settingsRestorePurchases.
  ///
  /// In en, this message translates to:
  /// **'Restore purchases'**
  String get settingsRestorePurchases;

  /// No description provided for @settingsSectionStoryPrefs.
  ///
  /// In en, this message translates to:
  /// **'STORY PREFERENCES'**
  String get settingsSectionStoryPrefs;

  /// No description provided for @settingsStoryLanguage.
  ///
  /// In en, this message translates to:
  /// **'Story language'**
  String get settingsStoryLanguage;

  /// No description provided for @settingsDefaultArtStyle.
  ///
  /// In en, this message translates to:
  /// **'Default art style'**
  String get settingsDefaultArtStyle;

  /// No description provided for @settingsNarrationVoice.
  ///
  /// In en, this message translates to:
  /// **'Narration voice'**
  String get settingsNarrationVoice;

  /// No description provided for @settingsSectionReader.
  ///
  /// In en, this message translates to:
  /// **'READER'**
  String get settingsSectionReader;

  /// No description provided for @settingsAutoPlay.
  ///
  /// In en, this message translates to:
  /// **'Auto-play narration'**
  String get settingsAutoPlay;

  /// No description provided for @settingsSleepMode.
  ///
  /// In en, this message translates to:
  /// **'Sleep mode'**
  String get settingsSleepMode;

  /// No description provided for @settingsBackgroundMusic.
  ///
  /// In en, this message translates to:
  /// **'Background music'**
  String get settingsBackgroundMusic;

  /// No description provided for @settingsSectionApp.
  ///
  /// In en, this message translates to:
  /// **'APP'**
  String get settingsSectionApp;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsBedtimeReminder.
  ///
  /// In en, this message translates to:
  /// **'Bedtime reminder'**
  String get settingsBedtimeReminder;

  /// No description provided for @settingsSectionSupport.
  ///
  /// In en, this message translates to:
  /// **'SUPPORT'**
  String get settingsSectionSupport;

  /// No description provided for @settingsHelpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help center'**
  String get settingsHelpCenter;

  /// No description provided for @settingsContactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get settingsContactUs;

  /// No description provided for @settingsRateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate Lullabook'**
  String get settingsRateApp;

  /// No description provided for @settingsSectionLegal.
  ///
  /// In en, this message translates to:
  /// **'LEGAL'**
  String get settingsSectionLegal;

  /// No description provided for @settingsTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get settingsTerms;

  /// No description provided for @settingsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settingsPrivacy;

  /// No description provided for @settingsSectionAccountActions.
  ///
  /// In en, this message translates to:
  /// **'ACCOUNT ACTIONS'**
  String get settingsSectionAccountActions;

  /// No description provided for @settingsSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get settingsSignOut;

  /// No description provided for @settingsDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get settingsDeleteAccount;

  /// No description provided for @settingsDeleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account?'**
  String get settingsDeleteAccountTitle;

  /// No description provided for @settingsDeleteAccountMessage.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete your account, heroes, and all stories. This cannot be undone.'**
  String get settingsDeleteAccountMessage;

  /// No description provided for @settingsDeleteAccountCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get settingsDeleteAccountCancel;

  /// No description provided for @settingsDeleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get settingsDeleteAccountConfirm;

  /// No description provided for @settingsPurchasesRestored.
  ///
  /// In en, this message translates to:
  /// **'Purchases restored'**
  String get settingsPurchasesRestored;

  /// No description provided for @settingsNothingToRestore.
  ///
  /// In en, this message translates to:
  /// **'Nothing to restore'**
  String get settingsNothingToRestore;

  /// No description provided for @settingsDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Could not delete account. Contact support.'**
  String get settingsDeleteError;

  /// No description provided for @settingsSectionDeveloper.
  ///
  /// In en, this message translates to:
  /// **'DEVELOPER'**
  String get settingsSectionDeveloper;

  /// No description provided for @settingsDebugMode.
  ///
  /// In en, this message translates to:
  /// **'Debug mode'**
  String get settingsDebugMode;

  /// No description provided for @settingsGenerateTestStory.
  ///
  /// In en, this message translates to:
  /// **'Generate test story'**
  String get settingsGenerateTestStory;

  /// No description provided for @settingsFooter.
  ///
  /// In en, this message translates to:
  /// **'Lullabook · v1.0'**
  String get settingsFooter;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsLanguageHungarian.
  ///
  /// In en, this message translates to:
  /// **'Magyar'**
  String get settingsLanguageHungarian;

  /// No description provided for @paywallTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock Lullabook'**
  String get paywallTitle;

  /// No description provided for @paywallSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Unlimited personalized bedtime stories'**
  String get paywallSubtitle;

  /// No description provided for @paywallWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get paywallWeekly;

  /// No description provided for @paywallYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get paywallYearly;

  /// No description provided for @paywallWeeklySubtitle.
  ///
  /// In en, this message translates to:
  /// **'3-day free trial, then {price}/week'**
  String paywallWeeklySubtitle(String price);

  /// No description provided for @paywallYearlySubtitle.
  ///
  /// In en, this message translates to:
  /// **'{price}/year — best value'**
  String paywallYearlySubtitle(String price);

  /// No description provided for @paywallContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get paywallContinue;

  /// No description provided for @paywallRestorePurchases.
  ///
  /// In en, this message translates to:
  /// **'Restore purchases'**
  String get paywallRestorePurchases;

  /// No description provided for @paywallErrorLoad.
  ///
  /// In en, this message translates to:
  /// **'Could not load offers'**
  String get paywallErrorLoad;

  /// No description provided for @paywallErrorNoOffers.
  ///
  /// In en, this message translates to:
  /// **'No offers available'**
  String get paywallErrorNoOffers;

  /// No description provided for @paywallErrorPurchaseFailed.
  ///
  /// In en, this message translates to:
  /// **'Purchase failed. Please try again.'**
  String get paywallErrorPurchaseFailed;

  /// No description provided for @paywallPurchasesRestored.
  ///
  /// In en, this message translates to:
  /// **'Purchases restored!'**
  String get paywallPurchasesRestored;

  /// No description provided for @paywallNoSubscription.
  ///
  /// In en, this message translates to:
  /// **'No active subscription found.'**
  String get paywallNoSubscription;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hu'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hu':
      return AppLocalizationsHu();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
