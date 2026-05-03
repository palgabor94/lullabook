// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get authSaveMagic => 'Save your magic';

  @override
  String get authSubtitle =>
      'Continue your adventure and create unlimited bedtime stories.';

  @override
  String get authContinueGoogle => 'Continue with Google';

  @override
  String get authContinueEmail => 'Continue with email';

  @override
  String get authTryPreview => 'Try a free preview first →';

  @override
  String get authAgreePrefix => 'By continuing you agree to our';

  @override
  String get authTerms => 'Terms';

  @override
  String get authPrivacy => 'Privacy Policy';

  @override
  String get authCreateAccount => 'Create account';

  @override
  String get authSignIn => 'Sign in';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authEmailValidation => 'Enter a valid email';

  @override
  String get authPasswordValidation => 'At least 6 characters';

  @override
  String get authHaveAccount => 'Already have an account? Sign in';

  @override
  String get authNoAccount => 'Don\'t have an account? Register';

  @override
  String get authErrorApple => 'Apple Sign-In failed. Please try again.';

  @override
  String get authErrorGoogle => 'Google Sign-In failed. Please try again.';

  @override
  String get authErrorGeneric => 'Sign-in failed. Please try again.';

  @override
  String get authErrorInvalidCredential => 'Invalid email or password.';

  @override
  String get authErrorEmailExists =>
      'An account with this email already exists.';

  @override
  String get authErrorWeakPassword => 'Password must be at least 6 characters.';

  @override
  String get authErrorInvalidEmail => 'Please enter a valid email address.';

  @override
  String get authErrorTooManyRequests => 'Too many attempts. Try again later.';

  @override
  String get splashTagline => 'Bedtime stories starring your child';

  @override
  String get previewEyebrow => 'FREE PREVIEW · NO SIGNUP';

  @override
  String get previewTitle => 'See your child\nas the hero';

  @override
  String get previewSubtitle =>
      'We\'ll show you a sneak peek before any signup.';

  @override
  String get previewChildNameLabel => 'Child\'s first name';

  @override
  String get previewAdventureHeader => 'CHOOSE AN ADVENTURE';

  @override
  String get previewArtStyleHeader => 'CHOOSE AN ART STYLE';

  @override
  String get previewPrivacyNote =>
      'Photo deleted within 24 hours.\nWe never share your child\'s image.';

  @override
  String get previewNextButton => 'Next: Add a photo';

  @override
  String get previewAlreadyAccount => 'Already have an account? Sign in';

  @override
  String get previewNameValidation => 'Enter your child\'s name to continue';

  @override
  String get previewAdventureSpaceExplorer => 'Space Explorer';

  @override
  String get previewAdventureOceanDiver => 'Ocean Diver';

  @override
  String get previewAdventureDragonRider => 'Dragon Rider';

  @override
  String get previewAdventureForestFairy => 'Forest Fairy';

  @override
  String get previewAdventureTreasureHunter => 'Treasure Hunter';

  @override
  String get previewAdventureTimeTraveler => 'Time Traveler';

  @override
  String photoTitle(String childName) {
    return '$childName\'s photo';
  }

  @override
  String get photoInstruction =>
      'Add a clear photo of your child\'s face.\nThis will become their storybook hero!';

  @override
  String get photoTapGallery => 'Tap to choose from gallery';

  @override
  String get photoCameraButton => 'Take a photo';

  @override
  String get photoCreatingHero => 'Creating your hero… ~40 seconds';

  @override
  String get photoCreateCta => 'Create my hero!';

  @override
  String revealTitle(String childName) {
    return 'Meet $childName!';
  }

  @override
  String get revealContinue => 'Continue →';

  @override
  String revealStartAdventure(String childName) {
    return 'Start $childName\'s adventure!';
  }

  @override
  String get heroInfoEyebrow => 'STEP 2 OF 3 · ABOUT THE HERO';

  @override
  String heroInfoTitle(String name) {
    return 'Tell us about\n$name';
  }

  @override
  String get heroNameLabel => 'Name';

  @override
  String get heroAgeHeader => 'AGE';

  @override
  String get heroPronounsHeader => 'PRONOUNS';

  @override
  String get heroTraitsLabel => 'DEFINING TRAITS (OPTIONAL)';

  @override
  String get heroTraitsHint => 'brown wavy hair, blue glasses, freckles';

  @override
  String get heroArtStyleHeader => 'ART STYLE';

  @override
  String get heroConfirmButton => 'Confirm hero';

  @override
  String get heroNextPhotoButton => 'Next: Add photo';

  @override
  String get heroNameValidation => 'Enter your child\'s name';

  @override
  String get heroArtStylePixar => 'Pixar 3D';

  @override
  String get heroArtStyleWatercolor => 'Watercolor';

  @override
  String get heroArtStyleFlatModern => 'Flat Modern';

  @override
  String get heroArtStyleStorybook => 'Storybook Classic';

  @override
  String get heroArtStyleGhibli => 'Ghibli';

  @override
  String get heroArtStyleAnime => 'Anime';

  @override
  String get heroArtStyleComic => 'Comic';

  @override
  String get heroPronounHeHim => 'he/him';

  @override
  String get heroPronounSheHer => 'she/her';

  @override
  String get heroPronounTheyThem => 'they/them';

  @override
  String heroPhotoEyebrow(String name) {
    return 'STEP 3 OF 3 · $name\'S PHOTO';
  }

  @override
  String get heroPhotoTitle => 'A clear photo\nworks best';

  @override
  String get heroPhotoInstruction =>
      'Front-facing with good lighting works best. Original is deleted within 24 hours.';

  @override
  String get heroPhotoAdd => 'Add a photo';

  @override
  String get heroPhotoAddSubtitle => 'A clear photo of your child works best';

  @override
  String get heroPhotoCameraButton => 'Take a photo';

  @override
  String get heroPhotoCreating => 'Creating hero… ~40 seconds';

  @override
  String get heroPhotoCreateCta => 'Create hero!';

  @override
  String heroAnchorTitle(String name) {
    return 'Does this look like $name?';
  }

  @override
  String get heroAnchorRegenerating => 'Regenerating… ~40 seconds';

  @override
  String heroAnchorRegenerationsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count free regenerations remaining',
      one: '1 free regeneration remaining',
    );
    return '$_temp0';
  }

  @override
  String get heroAnchorTryAgain => 'Try again';

  @override
  String heroAnchorConfirm(String name) {
    return 'Yes, that\'s $name';
  }

  @override
  String get adventureStep1Question => 'Who do you want to be tonight?';

  @override
  String get adventureStep2Question => 'Who comes with you?';

  @override
  String get adventureStep3Question => 'Where does the adventure happen?';

  @override
  String get adventureStep4Question => 'What do you want to find?';

  @override
  String get adventureStep5Question => 'Any final touches?';

  @override
  String get adventureStepHint1 => 'Step 1 of 4';

  @override
  String get adventureStepHint2 => 'Step 2 of 4';

  @override
  String get adventureStepHint3 => 'Step 3 of 4';

  @override
  String get adventureStepHint4 => 'Step 4 of 4';

  @override
  String get adventureStepHintOptional => 'Optional';

  @override
  String get adventureSoloHero => 'Solo Hero';

  @override
  String get adventureTeachingMomentHeader => 'Add a teaching moment';

  @override
  String get adventureTeachingMomentHelp =>
      'Optional, for grown-ups. The story will weave it in gently.';

  @override
  String get adventureTeachingMomentPlaceholder => 'or type your own…';

  @override
  String get adventureCreateStoryButton => 'Create story!';

  @override
  String get adventureNone => 'none';

  @override
  String get buddyOptionalPhoto => 'Optional photo';

  @override
  String get buddyNameHint => 'Name (optional, e.g. Rex, Sam…)';

  @override
  String get buddySave => 'Save';

  @override
  String get buddyContinue => 'Continue';

  @override
  String get buddySaveError => 'Failed to save. Please try again.';

  @override
  String get buddyTakePhoto => 'Take photo';

  @override
  String get buddyChooseLibrary => 'Choose from library';

  @override
  String get buddyDad => 'Dad';

  @override
  String get buddyMom => 'Mom';

  @override
  String get buddySibling => 'Sibling';

  @override
  String get buddyDog => 'Dog';

  @override
  String get buddyCat => 'Cat';

  @override
  String get buddyGrandpa => 'Grandpa';

  @override
  String get buddyGrandma => 'Grandma';

  @override
  String get buddyFriend => 'Friend';

  @override
  String get themeAstronaut => 'Astronaut';

  @override
  String get themePirate => 'Pirate';

  @override
  String get themeWizard => 'Wizard';

  @override
  String get themePrincess => 'Princess';

  @override
  String get themeKnight => 'Knight';

  @override
  String get themeMermaid => 'Mermaid';

  @override
  String get themeSuperhero => 'Superhero';

  @override
  String get themeChef => 'Chef';

  @override
  String get themeScientist => 'Scientist';

  @override
  String get themeNinja => 'Ninja';

  @override
  String get themeExplorer => 'Explorer';

  @override
  String get themeVet => 'Vet';

  @override
  String get themeInventor => 'Inventor';

  @override
  String get themeDinoHunter => 'Dino Hunter';

  @override
  String get themeFirefighter => 'Firefighter';

  @override
  String get themeRobotPilot => 'Robot Pilot';

  @override
  String get themeCosyHome => 'Cosy Tale';

  @override
  String get locCosyHomeBedroom => 'Bedroom';

  @override
  String get locCosyHomeKitchen => 'Kitchen';

  @override
  String get locCosyHomeGarden => 'Garden';

  @override
  String get locCosyHomeAttic => 'Attic';

  @override
  String get locCosyHomeLivingRoom => 'Living Room';

  @override
  String get locCosyParkNearby => 'Nearby Park';

  @override
  String get locCosyLibrary => 'Library';

  @override
  String get locCosyPlayground => 'Playground';

  @override
  String get locCosyFarmersMarket => 'Market';

  @override
  String get locCosyForestClearing => 'Forest Clearing';

  @override
  String get locCosyPond => 'Duck Pond';

  @override
  String get locCosyMeadow => 'Meadow';

  @override
  String get goalCosyLostToy => 'Find a Lost Toy';

  @override
  String get goalCosyFirstFriend => 'Make a New Friend';

  @override
  String get goalCosyHelpNeighbour => 'Help a Neighbour';

  @override
  String get goalCosyTidyRoom => 'Tidy the Room';

  @override
  String get goalCosyBakeTogether => 'Bake Together';

  @override
  String get goalCosyFeedBirds => 'Feed the Birds';

  @override
  String get goalCosyBedtimeFear => 'Brave the Dark';

  @override
  String get goalCosyShareToy => 'Share a Toy';

  @override
  String get goalCosyPlantSeed => 'Plant a Seed';

  @override
  String get goalCosyRainyAfternoon => 'Rainy Afternoon';

  @override
  String get goalCosyVisitGrandparent => 'Visit Grandparents';

  @override
  String get goalCosyFindPebble => 'Find a Special Pebble';

  @override
  String get locAstronautRingsOfSaturn => 'Rings of Saturn';

  @override
  String get locAstronautJupiterStorm => 'Jupiter Storm';

  @override
  String get locAstronautIceMoon => 'Ice Moon';

  @override
  String get locAstronautLunarBase => 'Lunar Base';

  @override
  String get goalAstronautPlantFlag => 'Plant a Flag';

  @override
  String get goalAstronautFirstContact => 'First Contact';

  @override
  String get goalAstronautStardustSample => 'Collect Stardust';

  @override
  String get goalAstronautSpaceGarden => 'Grow a Space Garden';

  @override
  String get locPirateVolcanicAtoll => 'Volcanic Atoll';

  @override
  String get locPirateMermaidLagoon => 'Mermaid Lagoon';

  @override
  String get locPirateKrakenWaters => 'Kraken Waters';

  @override
  String get locPirateGhostShip => 'Ghost Ship';

  @override
  String get goalPirateTameKraken => 'Tame the Kraken';

  @override
  String get goalPirateMutinyCalm => 'Calm a Mutiny';

  @override
  String get goalPirateRescueParrot => 'Rescue the Parrot';

  @override
  String get goalPirateFreeGhostCrew => 'Free the Ghost Crew';

  @override
  String get locWizardStarlitGlade => 'Starlit Glade';

  @override
  String get locWizardPhoenixNest => 'Phoenix Nest';

  @override
  String get locWizardMoonCourt => 'Moon Court';

  @override
  String get locWizardFaeMarket => 'Fae Market';

  @override
  String get goalWizardFirstSpell => 'Cast Your First Spell';

  @override
  String get goalWizardRestorePhoenix => 'Restore the Phoenix';

  @override
  String get goalWizardMoonBlessing => 'Earn the Moon\'s Blessing';

  @override
  String get goalWizardFaeBargain => 'Strike a Fae Bargain';

  @override
  String get locPrincessRoseMaze => 'Rose Maze';

  @override
  String get locPrincessCrystalTower => 'Crystal Tower';

  @override
  String get locPrincessDawnGardens => 'Dawn Gardens';

  @override
  String get locPrincessTeaPavilion => 'Tea Pavilion';

  @override
  String get goalPrincessTeaWithDragon => 'Tea with a Dragon';

  @override
  String get goalPrincessFairyPact => 'Make a Fairy Pact';

  @override
  String get goalPrincessSingingRose => 'Wake the Singing Rose';

  @override
  String get goalPrincessLostKitten => 'Find the Lost Kitten';

  @override
  String get locKnightSilverLake => 'Silver Lake';

  @override
  String get locKnightTournamentField => 'Tournament Field';

  @override
  String get locKnightWizardGrove => 'Wizard\'s Grove';

  @override
  String get locKnightHauntedKeep => 'Haunted Keep';

  @override
  String get goalKnightTameGriffin => 'Tame a Griffin';

  @override
  String get goalKnightCrossBridge => 'Cross the Enchanted Bridge';

  @override
  String get goalKnightFirstQuest => 'First Quest';

  @override
  String get goalKnightSootheGhost => 'Soothe a Lonely Ghost';

  @override
  String get locMermaidKelpForest => 'Kelp Forest';

  @override
  String get locMermaidMoonlightBay => 'Moonlight Bay';

  @override
  String get locMermaidJellyfishGlade => 'Jellyfish Glade';

  @override
  String get locMermaidShipwreckGarden => 'Shipwreck Garden';

  @override
  String get goalMermaidBabyOctopus => 'Help a Baby Octopus';

  @override
  String get goalMermaidLostStarfish => 'Guide a Lost Starfish';

  @override
  String get goalMermaidTidePoolFriend => 'Make a Tide-Pool Friend';

  @override
  String get goalMermaidLearnSong => 'Learn the Mermaid Song';

  @override
  String get locSuperheroSubwayTunnels => 'Subway Tunnels';

  @override
  String get locSuperheroSkyArena => 'Sky Arena';

  @override
  String get locSuperheroFrozenCity => 'Frozen Metropolis';

  @override
  String get locSuperheroParallelWorld => 'Parallel World';

  @override
  String get goalSuperheroFirstSave => 'Your First Rescue';

  @override
  String get goalSuperheroTeamUp => 'Team Up With a Hero';

  @override
  String get goalSuperheroReverseFreeze => 'Thaw the City';

  @override
  String get goalSuperheroFindMentor => 'Find a Mentor';

  @override
  String get locChefSpiceCaravan => 'Spice Caravan';

  @override
  String get locChefCloudPantry => 'Cloud Pantry';

  @override
  String get locChefRainbowOrchard => 'Rainbow Orchard';

  @override
  String get locChefUnderwaterGalley => 'Underwater Galley';

  @override
  String get goalChefRainbowPie => 'Bake a Rainbow Pie';

  @override
  String get goalChefMidnightFeast => 'Midnight Feast';

  @override
  String get goalChefSpiceQuest => 'Find a Magic Spice';

  @override
  String get goalChefFirstDish => 'Your First Dish';

  @override
  String get locScientistMushroomLab => 'Mushroom Lab';

  @override
  String get locScientistParticleChamber => 'Particle Chamber';

  @override
  String get locScientistDesertDig => 'Desert Dig Site';

  @override
  String get locScientistRainforestCanopy => 'Rainforest Canopy';

  @override
  String get goalScientistFirstInvention => 'Your First Invention';

  @override
  String get goalScientistGlowingPlant => 'Grow a Glowing Plant';

  @override
  String get goalScientistParticlePuzzle => 'Solve a Particle Puzzle';

  @override
  String get goalScientistAnimalLanguage => 'Decode Animal Language';

  @override
  String get locNinjaCherryGrove => 'Cherry Grove';

  @override
  String get locNinjaKoiPond => 'Koi Pond';

  @override
  String get locNinjaIronDojo => 'Iron Dojo';

  @override
  String get locNinjaLanternPass => 'Lantern Pass';

  @override
  String get goalNinjaSilentPassage => 'Pass in Silence';

  @override
  String get goalNinjaFirstTest => 'Your First Test';

  @override
  String get goalNinjaTameTiger => 'Befriend the Tiger';

  @override
  String get goalNinjaRestoreBalance => 'Restore the Balance';

  @override
  String get locExplorerCloudForest => 'Cloud Forest';

  @override
  String get locExplorerSaltFlats => 'Salt Flats';

  @override
  String get locExplorerGlowwormCave => 'Glowworm Cave';

  @override
  String get locExplorerSkyCanyon => 'Sky Canyon';

  @override
  String get goalExplorerFirstDiscovery => 'Your First Discovery';

  @override
  String get goalExplorerStarMap => 'Follow the Star Map';

  @override
  String get goalExplorerRescueCompanion => 'Rescue a Companion';

  @override
  String get goalExplorerAncientClue => 'Decipher an Ancient Clue';

  @override
  String get locVetButterflyMeadow => 'Butterfly Meadow';

  @override
  String get locVetSnowyPinewood => 'Snowy Pinewood';

  @override
  String get locVetFireflySwamp => 'Firefly Swamp';

  @override
  String get locVetRescueClinic => 'Rescue Clinic';

  @override
  String get goalVetButterflyWing => 'Mend a Butterfly Wing';

  @override
  String get goalVetLostPuppy => 'Find the Lost Puppy';

  @override
  String get goalVetShyUnicorn => 'Coax a Shy Unicorn';

  @override
  String get goalVetSleepingBear => 'Wake a Sleeping Bear Cub';

  @override
  String get locInventorTinkerMarket => 'Tinker Market';

  @override
  String get locInventorGearGarden => 'Gear Garden';

  @override
  String get locInventorLightningLab => 'Lightning Lab';

  @override
  String get locInventorPaperWorkshop => 'Paper Workshop';

  @override
  String get goalInventorFirstInvention => 'Your First Invention';

  @override
  String get goalInventorFixClockTower => 'Fix the Clock Tower';

  @override
  String get goalInventorPaperCreature => 'Build a Paper Creature';

  @override
  String get goalInventorKiteStorm => 'Tame the Kite Storm';

  @override
  String get locDinoHunterTarPit => 'Tar Pit';

  @override
  String get locDinoHunterFrozenTundra => 'Frozen Tundra';

  @override
  String get locDinoHunterMuseumArchive => 'Museum Archive';

  @override
  String get locDinoHunterShallowLagoon => 'Shallow Lagoon';

  @override
  String get goalDinoHunterFirstFossil => 'Your First Fossil';

  @override
  String get goalDinoHunterMammothFriend => 'Befriend a Mammoth Calf';

  @override
  String get goalDinoHunterPterodactyl => 'Sky Ride With a Pterodactyl';

  @override
  String get goalDinoHunterLostSkeleton => 'Reassemble a Lost Skeleton';

  @override
  String get locFirefighterRooftopDistrict => 'Rooftop District';

  @override
  String get locFirefighterTunnelNetwork => 'Tunnel Network';

  @override
  String get locFirefighterCircusTent => 'Circus Tent';

  @override
  String get locFirefighterLighthouse => 'Lighthouse Cliff';

  @override
  String get goalFirefighterFirstCall => 'Your First Call';

  @override
  String get goalFirefighterRescueKitten => 'Rescue a Kitten';

  @override
  String get goalFirefighterCalmCircus => 'Calm the Circus';

  @override
  String get goalFirefighterStormLighthouse => 'Save the Lighthouse';

  @override
  String get locRobotPilotScrapYard => 'Scrap Yard';

  @override
  String get locRobotPilotQuantumArena => 'Quantum Arena';

  @override
  String get locRobotPilotDataCanyon => 'Data Canyon';

  @override
  String get locRobotPilotOrbitalGarden => 'Orbital Garden';

  @override
  String get goalRobotPilotFirstFlight => 'Your First Flight';

  @override
  String get goalRobotPilotRebuildFriend => 'Rebuild a Robot Friend';

  @override
  String get goalRobotPilotDataMystery => 'Solve a Data Mystery';

  @override
  String get goalRobotPilotTendGarden => 'Tend the Orbital Garden';

  @override
  String get teachingBravery => 'Bravery';

  @override
  String get teachingKindness => 'Kindness';

  @override
  String get teachingSharing => 'Sharing';

  @override
  String get teachingHonesty => 'Honesty';

  @override
  String get teachingPatience => 'Patience';

  @override
  String get teachingFriendship => 'Friendship';

  @override
  String get teachingPerseverance => 'Perseverance';

  @override
  String get teachingCreativity => 'Creativity';

  @override
  String get locAstronautSpaceStation => 'Space Station';

  @override
  String get locAstronautPlanetMars => 'Planet Mars';

  @override
  String get locAstronautMoon => 'The Moon';

  @override
  String get locAstronautAsteroidBelt => 'Asteroid Belt';

  @override
  String get locAstronautAlienPlanet => 'Alien Planet';

  @override
  String get locAstronautCometTrail => 'Comet Trail';

  @override
  String get locAstronautCrystalNebula => 'Crystal Nebula';

  @override
  String get locAstronautBlackHole => 'Black Hole Edge';

  @override
  String get goalAstronautFixRocket => 'Fix the rocket';

  @override
  String get goalAstronautDiscoverPlanet => 'Discover a new planet';

  @override
  String get goalAstronautSaveStation => 'Save the space station';

  @override
  String get goalAstronautBefriendAliens => 'Befriend aliens';

  @override
  String get goalAstronautFindStar => 'Find a lost star';

  @override
  String get goalAstronautStopMeteor => 'Stop a meteor';

  @override
  String get goalAstronautRescueCrew => 'Rescue a lost crew';

  @override
  String get goalAstronautSpaceCrystal => 'Find the space crystal';

  @override
  String get locPirateTreasureIsland => 'Treasure Island';

  @override
  String get locPirateHighSeas => 'The High Seas';

  @override
  String get locPirateSunkenGalleon => 'Sunken Galleon';

  @override
  String get locPirateSeaCave => 'Secret Sea Cave';

  @override
  String get locPiratePiratePort => 'Pirate Port';

  @override
  String get locPirateCoralReef => 'Coral Reef';

  @override
  String get locPirateFogIsland => 'Island of Fog';

  @override
  String get locPirateStormySea => 'Stormy Sea';

  @override
  String get goalPirateBuriedTreasure => 'Find buried treasure';

  @override
  String get goalPirateFreeWhale => 'Free a captured whale';

  @override
  String get goalPirateDecodeMap => 'Decode the ancient map';

  @override
  String get goalPirateSailStorm => 'Sail through the storm';

  @override
  String get goalPirateSaveLighthouse => 'Save the lighthouse';

  @override
  String get goalPirateFindSunkenShip => 'Find the sunken ship';

  @override
  String get goalPirateBeatRival => 'Outsmart the rival pirate';

  @override
  String get goalPirateMagicShell => 'Find the magic shell';

  @override
  String get locWizardMagicForest => 'Magic Forest';

  @override
  String get locWizardEnchantedCastle => 'Enchanted Castle';

  @override
  String get locWizardCrystalCave => 'Crystal Cave';

  @override
  String get locWizardWizardTower => 'Wizard Tower';

  @override
  String get locWizardSpellLibrary => 'Spell Library';

  @override
  String get locWizardDragonMountain => 'Dragon Mountain';

  @override
  String get locWizardFloatingIslands => 'Floating Islands';

  @override
  String get locWizardMirrorRealm => 'Mirror Realm';

  @override
  String get goalWizardBreakSpell => 'Break the evil spell';

  @override
  String get goalWizardBrewPotion => 'Brew the lost potion';

  @override
  String get goalWizardReturnWand => 'Return the stolen wand';

  @override
  String get goalWizardTameSpell => 'Tame a wild spell';

  @override
  String get goalWizardForbiddenBook => 'Open the forbidden book';

  @override
  String get goalWizardSaveForest => 'Save the magic forest';

  @override
  String get goalWizardTameDragon => 'Tame the fire dragon';

  @override
  String get goalWizardFindApprentice => 'Find the lost apprentice';

  @override
  String get locPrincessRoyalPalace => 'Royal Palace';

  @override
  String get locPrincessEnchantedGarden => 'Enchanted Garden';

  @override
  String get locPrincessGlassLake => 'Glass Lake';

  @override
  String get locPrincessFairyVillage => 'Fairy Village';

  @override
  String get locPrincessCloudKingdom => 'Cloud Kingdom';

  @override
  String get locPrincessMagicBallroom => 'Magic Ballroom';

  @override
  String get locPrincessMoonlitForest => 'Moonlit Forest';

  @override
  String get locPrincessRainbowBridge => 'Rainbow Bridge';

  @override
  String get goalPrincessMissingCrown => 'Find the missing crown';

  @override
  String get goalPrincessSaveGarden => 'Save the enchanted garden';

  @override
  String get goalPrincessRoyalBall => 'Dance at the royal ball';

  @override
  String get goalPrincessBefriendGiant => 'Befriend the lonely giant';

  @override
  String get goalPrincessSolveMystery => 'Solve the castle mystery';

  @override
  String get goalPrincessWakeKingdom => 'Wake the sleeping kingdom';

  @override
  String get goalPrincessRescueUnicorn => 'Rescue the lost unicorn';

  @override
  String get goalPrincessMagicMirror => 'Answer the magic mirror';

  @override
  String get locKnightDragonLair => 'Dragon\'s Lair';

  @override
  String get locKnightDarkForest => 'Dark Forest';

  @override
  String get locKnightGiantsKeep => 'Giant\'s Keep';

  @override
  String get locKnightAncientRuins => 'Ancient Ruins';

  @override
  String get locKnightEnchantedBridge => 'Enchanted Bridge';

  @override
  String get locKnightMountainPass => 'Mountain Pass';

  @override
  String get locKnightFairyKingdom => 'Fairy Kingdom';

  @override
  String get locKnightFrozenCastle => 'Frozen Castle';

  @override
  String get goalKnightDefeatDragon => 'Defeat the dragon';

  @override
  String get goalKnightRescueHero => 'Rescue the trapped hero';

  @override
  String get goalKnightGoldenSword => 'Find the golden sword';

  @override
  String get goalKnightProtectVillage => 'Protect the village';

  @override
  String get goalKnightBreakCurse => 'Break the dark curse';

  @override
  String get goalKnightWinTournament => 'Win the tournament';

  @override
  String get goalKnightFreeCastle => 'Free the besieged castle';

  @override
  String get goalKnightMagicGrail => 'Find the magic grail';

  @override
  String get locMermaidDeepOcean => 'Deep Ocean';

  @override
  String get locMermaidCoralKingdom => 'Coral Kingdom';

  @override
  String get locMermaidUnderwaterCave => 'Underwater Cave';

  @override
  String get locMermaidSeaDragonLair => 'Sea Dragon\'s Lair';

  @override
  String get locMermaidSunkenCity => 'Sunken City';

  @override
  String get locMermaidRainbowReef => 'Rainbow Reef';

  @override
  String get locMermaidPearlGrotto => 'Pearl Grotto';

  @override
  String get locMermaidWhirlpoolSea => 'Whirlpool Sea';

  @override
  String get goalMermaidStolenPearl => 'Find the stolen pearl';

  @override
  String get goalMermaidSaveReef => 'Save the coral reef';

  @override
  String get goalMermaidFriendShark => 'Befriend a lonely shark';

  @override
  String get goalMermaidSunkenTreasure => 'Recover sunken treasure';

  @override
  String get goalMermaidGuideFish => 'Guide the lost fish home';

  @override
  String get goalMermaidStopStorm => 'Stop the ocean storm';

  @override
  String get goalMermaidOutwitWitch => 'Outwit the sea witch';

  @override
  String get goalMermaidWhaleSecret => 'Hear the whale\'s secret';

  @override
  String get locSuperherooBigCity => 'Big City';

  @override
  String get locSuperheroSecretBase => 'Secret Base';

  @override
  String get locSuperheroVolcanoIsland => 'Volcano Island';

  @override
  String get locSuperheroOuterSpace => 'Outer Space';

  @override
  String get locSuperheroUnderwaterCity => 'Underwater City';

  @override
  String get locSuperheroStormCloud => 'Storm Cloud';

  @override
  String get locSuperheroCityRooftops => 'City Rooftops';

  @override
  String get locSuperheroTimePortal => 'Time Portal';

  @override
  String get goalSuperheroStopMeteor => 'Stop the falling meteor';

  @override
  String get goalSuperheroSaveFlood => 'Save city from flood';

  @override
  String get goalSuperheroCatchVillain => 'Catch the sneaky villain';

  @override
  String get goalSuperheroProtectSecret => 'Protect a secret identity';

  @override
  String get goalSuperheroSavePuppy => 'Save a scared puppy';

  @override
  String get goalSuperheroRestorePowers => 'Restore lost powers';

  @override
  String get goalSuperheroStopRobot => 'Stop the evil robot';

  @override
  String get goalSuperheroRescueScientist => 'Rescue the scientist';

  @override
  String get locChefMagicKitchen => 'Magic Kitchen';

  @override
  String get locChefEnchantedFarm => 'Enchanted Farm';

  @override
  String get locChefCandyLand => 'Candy Land';

  @override
  String get locChefSecretGarden => 'Secret Garden';

  @override
  String get locChefGiantMarket => 'Giant Market';

  @override
  String get locChefFloatingRestaurant => 'Floating Restaurant';

  @override
  String get locChefDragonBakery => 'Dragon Bakery';

  @override
  String get locChefMoonlitVineyard => 'Moonlit Vineyard';

  @override
  String get goalChefMagicalDish => 'Create the magical dish';

  @override
  String get goalChefMissingIngredient => 'Find the missing ingredient';

  @override
  String get goalChefCookDragon => 'Cook for a hungry dragon';

  @override
  String get goalChefWinContest => 'Win the cooking contest';

  @override
  String get goalChefStolenRecipe => 'Rescue the stolen recipe';

  @override
  String get goalChefFeedKingdom => 'Feed the whole kingdom';

  @override
  String get goalChefImpossibleCake => 'Bake the impossible cake';

  @override
  String get goalChefCalmIngredients => 'Calm the angry ingredients';

  @override
  String get locScientistSecretLab => 'Secret Lab';

  @override
  String get locScientistUnderwaterStation => 'Underwater Station';

  @override
  String get locScientistArcticBase => 'Arctic Base';

  @override
  String get locScientistSpaceObservatory => 'Space Observatory';

  @override
  String get locScientistJungleResearch => 'Jungle Research';

  @override
  String get locScientistVolcanoLab => 'Volcano Lab';

  @override
  String get locScientistCloudLab => 'Cloud Laboratory';

  @override
  String get locScientistFutureCity => 'Future City';

  @override
  String get goalScientistNewElement => 'Discover a new element';

  @override
  String get goalScientistFixExperiment => 'Fix the broken experiment';

  @override
  String get goalScientistStopVirus => 'Stop the spreading virus';

  @override
  String get goalScientistTimeMachine => 'Build the time machine';

  @override
  String get goalScientistAlienEquation => 'Solve the alien equation';

  @override
  String get goalScientistSaveIceberg => 'Save the melting iceberg';

  @override
  String get goalScientistReverseShrink => 'Reverse the shrink ray';

  @override
  String get goalScientistTameCreature => 'Tame the giant creature';

  @override
  String get locNinjaHiddenTemple => 'Hidden Temple';

  @override
  String get locNinjaBambooForest => 'Bamboo Forest';

  @override
  String get locNinjaMountainFortress => 'Mountain Fortress';

  @override
  String get locNinjaShadowCity => 'Shadow City';

  @override
  String get locNinjaUndergroundMaze => 'Underground Maze';

  @override
  String get locNinjaAncientRuins => 'Ancient Ruins';

  @override
  String get locNinjaRooftopVillage => 'Rooftop Village';

  @override
  String get locNinjaFogValley => 'Fog Valley';

  @override
  String get goalNinjaStolenScroll => 'Retrieve the stolen scroll';

  @override
  String get goalNinjaStopShadowVillain => 'Stop the shadow villain';

  @override
  String get goalNinjaMasterMove => 'Master the secret move';

  @override
  String get goalNinjaProtectVillage => 'Protect the hidden village';

  @override
  String get goalNinjaUncoverMystery => 'Uncover the dark mystery';

  @override
  String get goalNinjaRescueMaster => 'Rescue the trapped master';

  @override
  String get goalNinjaFindWeapon => 'Find the ancient weapon';

  @override
  String get goalNinjaLearnTechnique => 'Learn the forbidden technique';

  @override
  String get locExplorerAmazonJungle => 'Amazon Jungle';

  @override
  String get locExplorerArcticTundra => 'Arctic Tundra';

  @override
  String get locExplorerLostDesert => 'Lost Desert';

  @override
  String get locExplorerHiddenValley => 'Hidden Valley';

  @override
  String get locExplorerMistyMountains => 'Misty Mountains';

  @override
  String get locExplorerUnderwaterCaves => 'Underwater Caves';

  @override
  String get locExplorerFloatingIslands => 'Floating Islands';

  @override
  String get locExplorerUndergroundCity => 'Underground City';

  @override
  String get goalExplorerMapIsland => 'Map the lost island';

  @override
  String get goalExplorerCrossJungle => 'Cross the dangerous jungle';

  @override
  String get goalExplorerDiscoverTemple => 'Discover the hidden temple';

  @override
  String get goalExplorerFindWaterfall => 'Find the magic waterfall';

  @override
  String get goalExplorerTrackCreature => 'Track the rare creature';

  @override
  String get goalExplorerReachPeak => 'Reach the mountain peak';

  @override
  String get goalExplorerFindTribe => 'Find the lost tribe';

  @override
  String get goalExplorerUncoverCity => 'Uncover a buried city';

  @override
  String get locVetMagicJungle => 'Magic Jungle';

  @override
  String get locVetArcticTundra => 'Arctic Tundra';

  @override
  String get locVetOceanReef => 'Ocean Reef';

  @override
  String get locVetEnchantedForest => 'Enchanted Forest';

  @override
  String get locVetSafariPlains => 'Safari Plains';

  @override
  String get locVetUndergroundWorld => 'Underground World';

  @override
  String get locVetCloudSanctuary => 'Cloud Sanctuary';

  @override
  String get locVetDesertOasis => 'Desert Oasis';

  @override
  String get goalVetHealDragon => 'Heal the sick dragon';

  @override
  String get goalVetSaveBabyWhale => 'Save a lost baby whale';

  @override
  String get goalVetHelpWolf => 'Help the scared wolf';

  @override
  String get goalVetCureFever => 'Cure the magical fever';

  @override
  String get goalVetRescueAnimals => 'Rescue animals from flood';

  @override
  String get goalVetFindAnimalFamily => 'Find the lost animal family';

  @override
  String get goalVetInvisibleCreature => 'Find the invisible creature';

  @override
  String get goalVetWarmBirds => 'Warm up the freezing birds';

  @override
  String get locInventorSkyWorkshop => 'Sky Workshop';

  @override
  String get locInventorUndergroundFactory => 'Underground Factory';

  @override
  String get locInventorMagicLibrary => 'Magic Library';

  @override
  String get locInventorCrystalMountain => 'Crystal Mountain';

  @override
  String get locInventorFutureMuseum => 'Future Museum';

  @override
  String get locInventorCloudWorkshop => 'Cloud Workshop';

  @override
  String get locInventorRobotCity => 'Robot City';

  @override
  String get locInventorVolcanoForge => 'Volcano Forge';

  @override
  String get goalInventorBuildMachine => 'Build the magical machine';

  @override
  String get goalInventorFixCity => 'Fix the broken city';

  @override
  String get goalInventorRainbowBridge => 'Create a rainbow bridge';

  @override
  String get goalInventorSolvePuzzle => 'Solve the impossible puzzle';

  @override
  String get goalInventorPowerLighthouse => 'Power up the lighthouse';

  @override
  String get goalInventorDreamToy => 'Build the dream toy';

  @override
  String get goalInventorFlyingShip => 'Finish the flying ship';

  @override
  String get goalInventorWakeRobot => 'Wake up a sleeping robot';

  @override
  String get locDinoHunterDinoValley => 'Dino Valley';

  @override
  String get locDinoHunterAncientDesert => 'Ancient Desert';

  @override
  String get locDinoHunterUndergroundCave => 'Underground Cave';

  @override
  String get locDinoHunterTimePortal => 'Time Portal';

  @override
  String get locDinoHunterFossilBeach => 'Fossil Beach';

  @override
  String get locDinoHunterPrehistoricForest => 'Prehistoric Forest';

  @override
  String get locDinoHunterAmberJungle => 'Amber Jungle';

  @override
  String get locDinoHunterVolcanicBadlands => 'Volcanic Badlands';

  @override
  String get goalDinoHunterHiddenFossil => 'Uncover the hidden fossil';

  @override
  String get goalDinoHunterBabyDino => 'Befriend a baby dinosaur';

  @override
  String get goalDinoHunterSolveMystery => 'Solve the ancient mystery';

  @override
  String get goalDinoHunterSaveDinoEggs => 'Save the dino eggs';

  @override
  String get goalDinoHunterDecodeLanguage => 'Decode ancient language';

  @override
  String get goalDinoHunterRescueTraveler => 'Rescue the time traveler';

  @override
  String get goalDinoHunterMeteorCrater => 'Find the meteor crater';

  @override
  String get goalDinoHunterStopStampede => 'Stop the dino stampede';

  @override
  String get locFirefighterBurningForest => 'Burning Forest';

  @override
  String get locFirefighterMagicCity => 'Magic City';

  @override
  String get locFirefighterVolcanoIsland => 'Volcano Island';

  @override
  String get locFirefighterCrystalTower => 'Crystal Tower';

  @override
  String get locFirefighterCloudTown => 'Cloud Town';

  @override
  String get locFirefighterAncientRuins => 'Ancient Ruins';

  @override
  String get locFirefighterHauntedMansion => 'Haunted Mansion';

  @override
  String get locFirefighterIcePalace => 'Ice Palace';

  @override
  String get goalFirefighterStopFire => 'Stop the forest fire';

  @override
  String get goalFirefighterRescueFamily => 'Rescue the trapped family';

  @override
  String get goalFirefighterPutOutVolcano => 'Put out the volcano';

  @override
  String get goalFirefighterSaveLibrary => 'Save the magic library';

  @override
  String get goalFirefighterAnimalsEscape => 'Help animals escape';

  @override
  String get goalFirefighterProtectCloud => 'Protect the cloud town';

  @override
  String get goalFirefighterMagicHose => 'Find the magic hose';

  @override
  String get goalFirefighterFreezeDragon => 'Freeze the fire dragon';

  @override
  String get locRobotPilotSpaceStation => 'Space Station';

  @override
  String get locRobotPilotRobotFactory => 'Robot Factory';

  @override
  String get locRobotPilotFutureCity => 'Future City';

  @override
  String get locRobotPilotCloudHighway => 'Cloud Highway';

  @override
  String get locRobotPilotDigitalWorld => 'Digital World';

  @override
  String get locRobotPilotCrystalNebula => 'Crystal Nebula';

  @override
  String get locRobotPilotGiantHangar => 'Giant Hangar';

  @override
  String get locRobotPilotIonStorm => 'Ion Storm Zone';

  @override
  String get goalRobotPilotRepairSatellite => 'Repair the satellite';

  @override
  String get goalRobotPilotNavigateAsteroid => 'Navigate an asteroid belt';

  @override
  String get goalRobotPilotRescueRobot => 'Rescue the lost robot';

  @override
  String get goalRobotPilotWinRace => 'Win the flying race';

  @override
  String get goalRobotPilotDecodeSignal => 'Decode the alien signal';

  @override
  String get goalRobotPilotPreventCrash => 'Prevent the crash';

  @override
  String get goalRobotPilotRestorePower => 'Restore the power core';

  @override
  String get goalRobotPilotCalmRobots => 'Calm the robot uprising';

  @override
  String get locDefaultMagicForest => 'Magic Forest';

  @override
  String get locDefaultCloudKingdom => 'Cloud Kingdom';

  @override
  String get locDefaultDeepOcean => 'Deep Ocean';

  @override
  String get locDefaultMagicCastle => 'Magic Castle';

  @override
  String get locDefaultVolcanoIsland => 'Volcano Island';

  @override
  String get locDefaultOuterSpace => 'Outer Space';

  @override
  String get goalDefaultFindTreasure => 'Find the treasure';

  @override
  String get goalDefaultRescueFriend => 'Rescue a friend';

  @override
  String get goalDefaultBefriendMonster => 'Befriend a monster';

  @override
  String get goalDefaultSolveMystery => 'Solve a mystery';

  @override
  String get goalDefaultSaveLand => 'Save the land';

  @override
  String get goalDefaultWinRace => 'Win the big race';

  @override
  String get homeTabTonight => 'TONIGHT';

  @override
  String get homeTabLibrary => 'LIBRARY';

  @override
  String get homeTabSettings => 'SETTINGS';

  @override
  String homeGreeting(String heroName) {
    return 'Good evening, $heroName';
  }

  @override
  String get homeGreetingGeneric => 'Good evening';

  @override
  String get homeSubtitle => 'Ready for tonight\'s adventure?';

  @override
  String get homeContinueReading => 'Continue reading';

  @override
  String get homeLibrarySection => 'Library';

  @override
  String get homeFilterRecent => 'Recent';

  @override
  String get homeFilterFavourites => 'Favourites';

  @override
  String get homeEmptyFavouritesTitle => 'No favourites yet';

  @override
  String get homeEmptyFavouritesSubtitle =>
      'Tap the heart on a story to save it here.';

  @override
  String get homeEmptyStoriesTitle => 'Your adventures begin tonight';

  @override
  String get homeEmptyStoriesSubtitle =>
      'Tap Tonight\'s Adventure to create your first story.';

  @override
  String get homeStartNow => 'Start now';

  @override
  String get homeCreateHero => 'Create a hero';

  @override
  String get homeAddHero => 'Add hero';

  @override
  String get homeAdventureChip => 'Adventure →';

  @override
  String get homeOfflineIndicator => 'Offline — cached stories';

  @override
  String get homeDeleteHeroError => 'Could not delete hero. Please try again.';

  @override
  String homeDeleteHeroTitle(String heroName) {
    return 'Delete $heroName?';
  }

  @override
  String homeDeleteHeroMessage(String heroName) {
    return 'This will permanently delete $heroName\'s hero profile. Stories created with this hero will remain in your library.';
  }

  @override
  String get homeDialogCancel => 'Cancel';

  @override
  String get homeDialogDelete => 'Delete';

  @override
  String homePageCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pages',
      one: '1 page',
    );
    return '$_temp0';
  }

  @override
  String generationLoadingDrawing(String name) {
    return 'Drawing $name\'s adventure...';
  }

  @override
  String get generationLoadingWriting => 'Writing tonight\'s story...';

  @override
  String get generationLoadingPainting => 'Painting the moon...';

  @override
  String get generationLoadingMixing => 'Mixing the perfect colours...';

  @override
  String get generationLoadingMagic => 'Adding a sprinkle of magic...';

  @override
  String get generationLoadingAlmost => 'Almost ready...';

  @override
  String get generationCancel => 'Cancel';

  @override
  String get generationErrorDailyLimit =>
      'Daily story limit reached.\nNew stories available tomorrow at midnight.';

  @override
  String get generationErrorFreeTier =>
      'Your free story has been used.\nUpgrade to create more stories.';

  @override
  String get generationErrorContent =>
      'The story content could not be approved.\nPlease try different settings.';

  @override
  String get generationErrorGeneric =>
      'Story generation failed.\nPlease check your connection and try again.';

  @override
  String get generationRetry => 'Try again';

  @override
  String get generationBack => 'Back';

  @override
  String get readerListen => 'Listen';

  @override
  String get readerPause => 'Pause';

  @override
  String get readerNext => 'Next';

  @override
  String get readerFinish => 'Finish';

  @override
  String get readerAgain => 'Again';

  @override
  String readerPageIndicator(int current, int total) {
    return '$current / $total';
  }

  @override
  String get readerErrorTitle => 'Could not load story';

  @override
  String get readerErrorBack => 'Go back';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSectionAccount => 'ACCOUNT';

  @override
  String get settingsSignedInFallback => 'Signed in';

  @override
  String get settingsPremiumLabel => 'Premium subscriber';

  @override
  String get settingsFreePlan => 'Free plan';

  @override
  String get settingsPremiumBadge => 'PREMIUM';

  @override
  String get settingsFreeBadge => 'FREE';

  @override
  String get settingsManageSubscription => 'Manage subscription';

  @override
  String get settingsRestorePurchases => 'Restore purchases';

  @override
  String get settingsSectionStoryPrefs => 'STORY PREFERENCES';

  @override
  String get settingsStoryLanguage => 'Story language';

  @override
  String get settingsDefaultArtStyle => 'Default art style';

  @override
  String get settingsNarrationVoice => 'Narration voice';

  @override
  String get settingsSectionReader => 'READER';

  @override
  String get settingsAutoPlay => 'Auto-play narration';

  @override
  String get settingsSleepMode => 'Sleep mode';

  @override
  String get settingsBackgroundMusic => 'Background music';

  @override
  String get settingsSectionApp => 'APP';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsBedtimeReminder => 'Bedtime reminder';

  @override
  String get settingsSectionSupport => 'SUPPORT';

  @override
  String get settingsHelpCenter => 'Help center';

  @override
  String get settingsContactUs => 'Contact us';

  @override
  String get settingsRateApp => 'Rate Lullabook';

  @override
  String get settingsSectionLegal => 'LEGAL';

  @override
  String get settingsTerms => 'Terms of Service';

  @override
  String get settingsPrivacy => 'Privacy Policy';

  @override
  String get settingsSectionAccountActions => 'ACCOUNT ACTIONS';

  @override
  String get settingsSignOut => 'Sign out';

  @override
  String get settingsDeleteAccount => 'Delete account';

  @override
  String get settingsDeleteAccountTitle => 'Delete account?';

  @override
  String get settingsDeleteAccountMessage =>
      'This will permanently delete your account, heroes, and all stories. This cannot be undone.';

  @override
  String get settingsDeleteAccountCancel => 'Cancel';

  @override
  String get settingsDeleteAccountConfirm => 'Delete';

  @override
  String get settingsPurchasesRestored => 'Purchases restored';

  @override
  String get settingsNothingToRestore => 'Nothing to restore';

  @override
  String get settingsDeleteError =>
      'Could not delete account. Contact support.';

  @override
  String get settingsSectionDeveloper => 'DEVELOPER';

  @override
  String get settingsDebugMode => 'Debug mode';

  @override
  String get settingsGenerateTestStory => 'Generate test story';

  @override
  String get settingsFooter => 'Lullabook · v1.0';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageHungarian => 'Magyar';

  @override
  String get paywallTitle => 'Unlock Lullabook';

  @override
  String get paywallSubtitle => 'Unlimited personalized bedtime stories';

  @override
  String get paywallWeekly => 'Weekly';

  @override
  String get paywallYearly => 'Yearly';

  @override
  String paywallWeeklySubtitle(String price) {
    return '3-day free trial, then $price/week';
  }

  @override
  String paywallYearlySubtitle(String price) {
    return '$price/year — best value';
  }

  @override
  String get paywallContinue => 'Continue';

  @override
  String get paywallRestorePurchases => 'Restore purchases';

  @override
  String get paywallErrorLoad => 'Could not load offers';

  @override
  String get paywallErrorNoOffers => 'No offers available';

  @override
  String get paywallErrorPurchaseFailed => 'Purchase failed. Please try again.';

  @override
  String get paywallPurchasesRestored => 'Purchases restored!';

  @override
  String get paywallNoSubscription => 'No active subscription found.';
}
