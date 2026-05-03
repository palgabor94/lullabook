// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get authSaveMagic => 'Mentsd el a varázslatot!';

  @override
  String get authSubtitle =>
      'Folytasd a kalandot és hozz létre korlátlan mesét.';

  @override
  String get authContinueGoogle => 'Folytatás Google-lal';

  @override
  String get authContinueEmail => 'Folytatás e-maillel';

  @override
  String get authTryPreview => 'Előnézet regisztráció nélkül →';

  @override
  String get authAgreePrefix => 'A folytatással elfogadod a';

  @override
  String get authTerms => 'Felhasználási feltételeket';

  @override
  String get authPrivacy => 'Adatvédelmi nyilatkozatot';

  @override
  String get authCreateAccount => 'Fiók létrehozása';

  @override
  String get authSignIn => 'Bejelentkezés';

  @override
  String get authEmailLabel => 'E-mail';

  @override
  String get authPasswordLabel => 'Jelszó';

  @override
  String get authEmailValidation => 'Adj meg egy érvényes e-mail címet';

  @override
  String get authPasswordValidation => 'Legalább 6 karakter';

  @override
  String get authHaveAccount => 'Van már fiókod? Bejelentkezés';

  @override
  String get authNoAccount => 'Nincs fiókod? Regisztráció';

  @override
  String get authErrorApple =>
      'Apple bejelentkezés sikertelen. Kérlek próbáld újra.';

  @override
  String get authErrorGoogle =>
      'Google bejelentkezés sikertelen. Kérlek próbáld újra.';

  @override
  String get authErrorGeneric =>
      'Bejelentkezés sikertelen. Kérlek próbáld újra.';

  @override
  String get authErrorInvalidCredential => 'Érvénytelen e-mail vagy jelszó.';

  @override
  String get authErrorEmailExists => 'Már létezik fiók ezzel az e-mail címmel.';

  @override
  String get authErrorWeakPassword => 'A jelszó legalább 6 karakter legyen.';

  @override
  String get authErrorInvalidEmail => 'Kérlek adj meg érvényes e-mail címet.';

  @override
  String get authErrorTooManyRequests =>
      'Túl sok próbálkozás. Kérlek próbáld később.';

  @override
  String get splashTagline => 'Esti mesék, amelyekben a gyereked a főszereplő';

  @override
  String get previewEyebrow => 'INGYENES ELŐNÉZET · REGISZTRÁCIÓ NÉLKÜL';

  @override
  String get previewTitle => 'Lásd gyerekedet\nhőskéntként';

  @override
  String get previewSubtitle =>
      'Mutatunk egy előzetes ízelítőt regisztráció előtt.';

  @override
  String get previewChildNameLabel => 'A gyerek keresztneve';

  @override
  String get previewAdventureHeader => 'VÁLASSZ KALANDOT';

  @override
  String get previewArtStyleHeader => 'VÁLASSZ STÍLUST';

  @override
  String get previewPrivacyNote =>
      'A fényképet 24 órán belül töröljük.\nA gyereked képét soha nem osztjuk meg.';

  @override
  String get previewNextButton => 'Következő: Fénykép hozzáadása';

  @override
  String get previewAlreadyAccount => 'Van már fiókod? Bejelentkezés';

  @override
  String get previewNameValidation => 'Add meg a gyereked nevét a folytatáshoz';

  @override
  String get previewAdventureSpaceExplorer => 'Űrfelfedező';

  @override
  String get previewAdventureOceanDiver => 'Óceánbúvár';

  @override
  String get previewAdventureDragonRider => 'Sárkánylovag';

  @override
  String get previewAdventureForestFairy => 'Erdei Tündér';

  @override
  String get previewAdventureTreasureHunter => 'Kincsvadász';

  @override
  String get previewAdventureTimeTraveler => 'Időutazó';

  @override
  String photoTitle(String childName) {
    return '$childName fényképe';
  }

  @override
  String get photoInstruction =>
      'Adj hozzá egy tiszta fényképet a gyereked arcáról.\nEbből lesz a meséskönyv hőse!';

  @override
  String get photoTapGallery => 'Érintsd meg a galériából való választáshoz';

  @override
  String get photoCameraButton => 'Fénykép készítése';

  @override
  String get photoCreatingHero => 'Hős létrehozása… ~40 másodperc';

  @override
  String get photoCreateCta => 'Hőst létrehozom!';

  @override
  String revealTitle(String childName) {
    return 'Találkozz $childName-vel!';
  }

  @override
  String get revealContinue => 'Tovább →';

  @override
  String revealStartAdventure(String childName) {
    return 'Kezdjük $childName kalandját!';
  }

  @override
  String get heroInfoEyebrow => '2. LÉPÉS / 3 · A HŐS ADATAI';

  @override
  String heroInfoTitle(String name) {
    return 'Mesélj nekünk\n$name-ről';
  }

  @override
  String get heroNameLabel => 'Név';

  @override
  String get heroAgeHeader => 'KOR';

  @override
  String get heroPronounsHeader => 'NÉVMÁS';

  @override
  String get heroTraitsLabel => 'MEGHATÁROZÓ VONÁSOK (OPCIONÁLIS)';

  @override
  String get heroTraitsHint => 'barna hullámos haj, kék szemüveg, szeplők';

  @override
  String get heroArtStyleHeader => 'RAJZSTÍLUS';

  @override
  String get heroConfirmButton => 'Hős megerősítése';

  @override
  String get heroNextPhotoButton => 'Következő: Fénykép hozzáadása';

  @override
  String get heroNameValidation => 'Add meg a gyereked nevét';

  @override
  String get heroArtStylePixar => 'Pixar 3D';

  @override
  String get heroArtStyleWatercolor => 'Akvarell';

  @override
  String get heroArtStyleFlatModern => 'Modern lapos';

  @override
  String get heroArtStyleStorybook => 'Klasszikus meséskönyv';

  @override
  String get heroPronounHeHim => 'ő (fiú)';

  @override
  String get heroPronounSheHer => 'ő (lány)';

  @override
  String get heroPronounTheyThem => 'ő (semleges)';

  @override
  String heroPhotoEyebrow(String name) {
    return '3. LÉPÉS / 3 · $name FÉNYKÉPE';
  }

  @override
  String get heroPhotoTitle => 'Egy tiszta fénykép\na legjobb';

  @override
  String get heroPhotoInstruction =>
      'Szemből, jó megvilágításban a legjobb. Az eredeti 24 órán belül törlődik.';

  @override
  String get heroPhotoAdd => 'Fénykép hozzáadása';

  @override
  String get heroPhotoAddSubtitle => 'A gyereked egy tiszta fényképe a legjobb';

  @override
  String get heroPhotoCameraButton => 'Fénykép készítése';

  @override
  String get heroPhotoCreating => 'Hős létrehozása… ~40 másodperc';

  @override
  String get heroPhotoCreateCta => 'Hőst létrehozom!';

  @override
  String heroAnchorTitle(String name) {
    return 'Így néz ki $name?';
  }

  @override
  String get heroAnchorRegenerating => 'Újragenerálás… ~40 másodperc';

  @override
  String heroAnchorRegenerationsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ingyenes újragenerálás maradt',
      one: '1 ingyenes újragenerálás maradt',
    );
    return '$_temp0';
  }

  @override
  String get heroAnchorTryAgain => 'Próbáld újra';

  @override
  String heroAnchorConfirm(String name) {
    return 'Igen, ez $name';
  }

  @override
  String get adventureStep1Question => 'Ki szeretnél lenni ma este?';

  @override
  String get adventureStep2Question => 'Ki jön veled?';

  @override
  String get adventureStep3Question => 'Hol játszódik a kaland?';

  @override
  String get adventureStep4Question => 'Mit szeretnél megtalálni?';

  @override
  String get adventureStep5Question => 'Bármilyen utolsó simítás?';

  @override
  String get adventureStepHint1 => '1. lépés / 4';

  @override
  String get adventureStepHint2 => '2. lépés / 4';

  @override
  String get adventureStepHint3 => '3. lépés / 4';

  @override
  String get adventureStepHint4 => '4. lépés / 4';

  @override
  String get adventureStepHintOptional => 'Opcionális';

  @override
  String get adventureSoloHero => 'Egyedüli hős';

  @override
  String get adventureTeachingMomentHeader => 'Adj hozzá egy tanulságot';

  @override
  String get adventureTeachingMomentHelp =>
      'Opcionális, szülőknek. A mese finoman beleszövi.';

  @override
  String get adventureTeachingMomentPlaceholder => 'vagy írj saját szöveget…';

  @override
  String get adventureCreateStoryButton => 'Mese létrehozása!';

  @override
  String get adventureNone => 'semmi';

  @override
  String get buddyOptionalPhoto => 'Opcionális fotó';

  @override
  String get buddyNameHint => 'Név (opcionális, pl. Rex, Bence…)';

  @override
  String get buddySave => 'Mentés';

  @override
  String get buddyContinue => 'Tovább';

  @override
  String get buddySaveError => 'Mentés sikertelen. Kérlek próbáld újra.';

  @override
  String get buddyTakePhoto => 'Fénykép készítése';

  @override
  String get buddyChooseLibrary => 'Kiválasztás a galériából';

  @override
  String get buddyDad => 'Apa';

  @override
  String get buddyMom => 'Anya';

  @override
  String get buddySibling => 'Testvér';

  @override
  String get buddyDog => 'Kutya';

  @override
  String get buddyCat => 'Cica';

  @override
  String get buddyGrandpa => 'Papa';

  @override
  String get buddyGrandma => 'Nagymama';

  @override
  String get buddyFriend => 'Barát';

  @override
  String get themeAstronaut => 'Űrhajós';

  @override
  String get themePirate => 'Kalóz';

  @override
  String get themeWizard => 'Varázsló';

  @override
  String get themePrincess => 'Hercegnő';

  @override
  String get themeKnight => 'Lovag';

  @override
  String get themeMermaid => 'Sellő';

  @override
  String get themeSuperhero => 'Szuperhős';

  @override
  String get themeChef => 'Séf';

  @override
  String get themeScientist => 'Tudós';

  @override
  String get themeNinja => 'Ninja';

  @override
  String get themeExplorer => 'Felfedező';

  @override
  String get themeVet => 'Állatorvos';

  @override
  String get themeInventor => 'Feltaláló';

  @override
  String get themeDinoHunter => 'Dinóvadász';

  @override
  String get themeFirefighter => 'Tűzoltó';

  @override
  String get themeRobotPilot => 'Robotpilóta';

  @override
  String get teachingBravery => 'Bátorság';

  @override
  String get teachingKindness => 'Kedvesség';

  @override
  String get teachingSharing => 'Megosztás';

  @override
  String get teachingHonesty => 'Őszinteség';

  @override
  String get teachingPatience => 'Türelem';

  @override
  String get teachingFriendship => 'Barátság';

  @override
  String get teachingPerseverance => 'Kitartás';

  @override
  String get teachingCreativity => 'Kreativitás';

  @override
  String get locAstronautSpaceStation => 'Űrállomás';

  @override
  String get locAstronautPlanetMars => 'Mars bolygó';

  @override
  String get locAstronautMoon => 'A Hold';

  @override
  String get locAstronautAsteroidBelt => 'Aszteroidaöv';

  @override
  String get locAstronautAlienPlanet => 'Idegen bolygó';

  @override
  String get locAstronautCometTrail => 'Üstökös nyomvonal';

  @override
  String get locAstronautCrystalNebula => 'Kristályköd';

  @override
  String get locAstronautBlackHole => 'Feketelyuk széle';

  @override
  String get goalAstronautFixRocket => 'Megjavítani a rakétát';

  @override
  String get goalAstronautDiscoverPlanet => 'Felfedezni egy új bolygót';

  @override
  String get goalAstronautSaveStation => 'Megmenteni az űrállomást';

  @override
  String get goalAstronautBefriendAliens => 'Barátságot kötni az idegenekkel';

  @override
  String get goalAstronautFindStar => 'Megtalálni az elveszett csillagot';

  @override
  String get goalAstronautStopMeteor => 'Megállítani a meteorit';

  @override
  String get goalAstronautRescueCrew => 'Megmenteni az elveszett legénységet';

  @override
  String get goalAstronautSpaceCrystal => 'Megtalálni az űrkristályt';

  @override
  String get locPirateTreasureIsland => 'Kincses sziget';

  @override
  String get locPirateHighSeas => 'A nyílt tenger';

  @override
  String get locPirateSunkenGalleon => 'Elsüllyedt gálya';

  @override
  String get locPirateSeaCave => 'Titkos tengeri barlang';

  @override
  String get locPiratePiratePort => 'Kalózkikötő';

  @override
  String get locPirateCoralReef => 'Korallzátony';

  @override
  String get locPirateFogIsland => 'Ködös sziget';

  @override
  String get locPirateStormySea => 'Viharos tenger';

  @override
  String get goalPirateBuriedTreasure => 'Megtalálni az elásott kincset';

  @override
  String get goalPirateFreeWhale => 'Kiszabadítani a fogságba esett bálnát';

  @override
  String get goalPirateDecodeMap => 'Megfejteni az ősi térképet';

  @override
  String get goalPirateSailStorm => 'Átvitorlázni a viharon';

  @override
  String get goalPirateSaveLighthouse => 'Megmenteni a világítótornyot';

  @override
  String get goalPirateFindSunkenShip => 'Megtalálni az elsüllyedt hajót';

  @override
  String get goalPirateBeatRival => 'Felülkerekedni a riválisokon';

  @override
  String get goalPirateMagicShell => 'Megtalálni a varázsló csigaházat';

  @override
  String get locWizardMagicForest => 'Varázslatos erdő';

  @override
  String get locWizardEnchantedCastle => 'Elvarázsolt kastély';

  @override
  String get locWizardCrystalCave => 'Kristálybarlang';

  @override
  String get locWizardWizardTower => 'Varázslótorony';

  @override
  String get locWizardSpellLibrary => 'Varázslatkönyvtár';

  @override
  String get locWizardDragonMountain => 'Sárkányhegy';

  @override
  String get locWizardFloatingIslands => 'Lebegő szigetek';

  @override
  String get locWizardMirrorRealm => 'Tükörvilág';

  @override
  String get goalWizardBreakSpell => 'Feltörni a gonosz varázslatot';

  @override
  String get goalWizardBrewPotion => 'Megfőzni az elveszett bájitalt';

  @override
  String get goalWizardReturnWand => 'Visszaadni az ellopott varázspálcát';

  @override
  String get goalWizardTameSpell => 'Megszelídíteni a vad varázslatot';

  @override
  String get goalWizardForbiddenBook => 'Kinyitni a tiltott könyvet';

  @override
  String get goalWizardSaveForest => 'Megmenteni a varázslatos erdőt';

  @override
  String get goalWizardTameDragon => 'Megszelídíteni a tűzsárkányt';

  @override
  String get goalWizardFindApprentice => 'Megtalálni az elveszett tanoncot';

  @override
  String get locPrincessRoyalPalace => 'Királyi palota';

  @override
  String get locPrincessEnchantedGarden => 'Elvarázsolt kert';

  @override
  String get locPrincessGlassLake => 'Üvegtó';

  @override
  String get locPrincessFairyVillage => 'Tündérfalu';

  @override
  String get locPrincessCloudKingdom => 'Felhőkirályság';

  @override
  String get locPrincessMagicBallroom => 'Varázslatos bálterem';

  @override
  String get locPrincessMoonlitForest => 'Holdfényes erdő';

  @override
  String get locPrincessRainbowBridge => 'Szivárványhíd';

  @override
  String get goalPrincessMissingCrown => 'Megtalálni az elveszett koronát';

  @override
  String get goalPrincessSaveGarden => 'Megmenteni az elvarázsolt kertet';

  @override
  String get goalPrincessRoyalBall => 'Táncolni a királyi bálon';

  @override
  String get goalPrincessBefriendGiant =>
      'Barátságot kötni a magányos óriással';

  @override
  String get goalPrincessSolveMystery => 'Megoldani a kastély titkát';

  @override
  String get goalPrincessWakeKingdom => 'Felébreszteni az alvó királyságot';

  @override
  String get goalPrincessRescueUnicorn => 'Megmenteni az elveszett egyszarvút';

  @override
  String get goalPrincessMagicMirror => 'Válaszolni a varázstükörnek';

  @override
  String get locKnightDragonLair => 'Sárkánybarlang';

  @override
  String get locKnightDarkForest => 'Sötét erdő';

  @override
  String get locKnightGiantsKeep => 'Óriásvár';

  @override
  String get locKnightAncientRuins => 'Ősi romok';

  @override
  String get locKnightEnchantedBridge => 'Elvarázsolt híd';

  @override
  String get locKnightMountainPass => 'Hegyiszoros';

  @override
  String get locKnightFairyKingdom => 'Tündérkirályság';

  @override
  String get locKnightFrozenCastle => 'Fagyott kastély';

  @override
  String get goalKnightDefeatDragon => 'Legyőzni a sárkányt';

  @override
  String get goalKnightRescueHero => 'Megmenteni a csapdába esett hőst';

  @override
  String get goalKnightGoldenSword => 'Megtalálni az arany kardot';

  @override
  String get goalKnightProtectVillage => 'Megvédeni a falut';

  @override
  String get goalKnightBreakCurse => 'Feltörni a sötét átkot';

  @override
  String get goalKnightWinTournament => 'Megnyerni a tornát';

  @override
  String get goalKnightFreeCastle => 'Felszabadítani az ostromlott kastélyt';

  @override
  String get goalKnightMagicGrail => 'Megtalálni a varázslatos kelyhet';

  @override
  String get locMermaidDeepOcean => 'Mély óceán';

  @override
  String get locMermaidCoralKingdom => 'Korállkirályság';

  @override
  String get locMermaidUnderwaterCave => 'Víz alatti barlang';

  @override
  String get locMermaidSeaDragonLair => 'Tengeri sárkány tanyája';

  @override
  String get locMermaidSunkenCity => 'Elsüllyedt város';

  @override
  String get locMermaidRainbowReef => 'Szivárvány zátony';

  @override
  String get locMermaidPearlGrotto => 'Gyöngy barlang';

  @override
  String get locMermaidWhirlpoolSea => 'Örvénylő tenger';

  @override
  String get goalMermaidStolenPearl => 'Megtalálni az ellopott gyöngyöt';

  @override
  String get goalMermaidSaveReef => 'Megmenteni a korallzátonyát';

  @override
  String get goalMermaidFriendShark => 'Barátságot kötni a magányos cápával';

  @override
  String get goalMermaidSunkenTreasure => 'Megtalálni az elsüllyedt kincset';

  @override
  String get goalMermaidGuideFish => 'Hazavezetni az elveszett halat';

  @override
  String get goalMermaidStopStorm => 'Megállítani az óceáni vihart';

  @override
  String get goalMermaidOutwitWitch => 'Überlistázni a tengeri boszorkányt';

  @override
  String get goalMermaidWhaleSecret => 'Meghallani a bálna titkát';

  @override
  String get locSuperherooBigCity => 'Nagyváros';

  @override
  String get locSuperheroSecretBase => 'Titkos bázis';

  @override
  String get locSuperheroVolcanoIsland => 'Vulkán sziget';

  @override
  String get locSuperheroOuterSpace => 'Világűr';

  @override
  String get locSuperheroUnderwaterCity => 'Víz alatti város';

  @override
  String get locSuperheroStormCloud => 'Viharfelhő';

  @override
  String get locSuperheroCityRooftops => 'Várostetők';

  @override
  String get locSuperheroTimePortal => 'Időkapu';

  @override
  String get goalSuperheroStopMeteor => 'Megállítani a zuhanó meteorit';

  @override
  String get goalSuperheroSaveFlood => 'Megmenteni a várost az áradástól';

  @override
  String get goalSuperheroCatchVillain => 'Elkapni a ravasz gonosztevőt';

  @override
  String get goalSuperheroProtectSecret => 'Megvédeni a titkos identitást';

  @override
  String get goalSuperheroSavePuppy => 'Megmenteni az ijedt kutyust';

  @override
  String get goalSuperheroRestorePowers =>
      'Visszaszerezni az elveszett képességeket';

  @override
  String get goalSuperheroStopRobot => 'Megállítani a gonosz robotot';

  @override
  String get goalSuperheroRescueScientist => 'Megmenteni a tudóst';

  @override
  String get locChefMagicKitchen => 'Varázslatos konyha';

  @override
  String get locChefEnchantedFarm => 'Elvarázsolt farm';

  @override
  String get locChefCandyLand => 'Cukorkafölde';

  @override
  String get locChefSecretGarden => 'Titkos kert';

  @override
  String get locChefGiantMarket => 'Óriáspiac';

  @override
  String get locChefFloatingRestaurant => 'Lebegő étterem';

  @override
  String get locChefDragonBakery => 'Sárkány pékség';

  @override
  String get locChefMoonlitVineyard => 'Holdfényes szőlőskert';

  @override
  String get goalChefMagicalDish => 'Elkészíteni a varázslatos ételt';

  @override
  String get goalChefMissingIngredient => 'Megtalálni a hiányzó hozzávalót';

  @override
  String get goalChefCookDragon => 'Főzni az éhes sárkánynak';

  @override
  String get goalChefWinContest => 'Megnyerni a főzőversenyt';

  @override
  String get goalChefStolenRecipe => 'Visszaszerezni az ellopott receptet';

  @override
  String get goalChefFeedKingdom => 'Megetetni az egész királyságot';

  @override
  String get goalChefImpossibleCake => 'Megsütni a lehetetlen tortát';

  @override
  String get goalChefCalmIngredients => 'Megbékíteni a dühös hozzávalókat';

  @override
  String get locScientistSecretLab => 'Titkos labor';

  @override
  String get locScientistUnderwaterStation => 'Víz alatti állomás';

  @override
  String get locScientistArcticBase => 'Sarki bázis';

  @override
  String get locScientistSpaceObservatory => 'Csillagvizsgáló';

  @override
  String get locScientistJungleResearch => 'Dzsungel kutatóállomás';

  @override
  String get locScientistVolcanoLab => 'Vulkán labor';

  @override
  String get locScientistCloudLab => 'Felhő laboratórium';

  @override
  String get locScientistFutureCity => 'Jövő városa';

  @override
  String get goalScientistNewElement => 'Felfedezni egy új elemet';

  @override
  String get goalScientistFixExperiment => 'Megjavítani a törött kísérletet';

  @override
  String get goalScientistStopVirus => 'Megállítani a terjedő vírust';

  @override
  String get goalScientistTimeMachine => 'Megépíteni az időgépet';

  @override
  String get goalScientistAlienEquation => 'Megoldani az idegen egyenletet';

  @override
  String get goalScientistSaveIceberg => 'Megmenteni az olvadó jéghegyet';

  @override
  String get goalScientistReverseShrink => 'Visszaállítani a zsugorítósugarat';

  @override
  String get goalScientistTameCreature => 'Megszelídíteni az óriás teremtményt';

  @override
  String get locNinjaHiddenTemple => 'Rejtett templom';

  @override
  String get locNinjaBambooForest => 'Bambuszerdő';

  @override
  String get locNinjaMountainFortress => 'Hegyivár';

  @override
  String get locNinjaShadowCity => 'Árnyékváros';

  @override
  String get locNinjaUndergroundMaze => 'Föld alatti labirintus';

  @override
  String get locNinjaAncientRuins => 'Ősi romok';

  @override
  String get locNinjaRooftopVillage => 'Tetőfalú';

  @override
  String get locNinjaFogValley => 'Ködvölgy';

  @override
  String get goalNinjaStolenScroll => 'Visszaszerezni az ellopott tekercset';

  @override
  String get goalNinjaStopShadowVillain => 'Megállítani az árnyékgonosztevőt';

  @override
  String get goalNinjaMasterMove => 'Elsajátítani a titkos mozdulatot';

  @override
  String get goalNinjaProtectVillage => 'Megvédeni a rejtett falut';

  @override
  String get goalNinjaUncoverMystery => 'Feltárni a sötét rejtélyt';

  @override
  String get goalNinjaRescueMaster => 'Megmenteni a csapdába esett mestert';

  @override
  String get goalNinjaFindWeapon => 'Megtalálni az ősi fegyvert';

  @override
  String get goalNinjaLearnTechnique => 'Megtanulni a tiltott technikát';

  @override
  String get locExplorerAmazonJungle => 'Amazon dzsungel';

  @override
  String get locExplorerArcticTundra => 'Sarki tundra';

  @override
  String get locExplorerLostDesert => 'Elveszett sivatag';

  @override
  String get locExplorerHiddenValley => 'Rejtett völgy';

  @override
  String get locExplorerMistyMountains => 'Ködös hegyek';

  @override
  String get locExplorerUnderwaterCaves => 'Víz alatti barlangok';

  @override
  String get locExplorerFloatingIslands => 'Lebegő szigetek';

  @override
  String get locExplorerUndergroundCity => 'Föld alatti város';

  @override
  String get goalExplorerMapIsland => 'Feltérképezni az elveszett szigetet';

  @override
  String get goalExplorerCrossJungle => 'Átkelni a veszélyes dzsungelen';

  @override
  String get goalExplorerDiscoverTemple => 'Felfedezni a rejtett templomot';

  @override
  String get goalExplorerFindWaterfall => 'Megtalálni a varázslatos vízesést';

  @override
  String get goalExplorerTrackCreature => 'Nyomon követni a ritka teremtményt';

  @override
  String get goalExplorerReachPeak => 'Eljutni a hegycsúcsra';

  @override
  String get goalExplorerFindTribe => 'Megtalálni az elveszett törzset';

  @override
  String get goalExplorerUncoverCity => 'Feltárni egy eltemetett várost';

  @override
  String get locVetMagicJungle => 'Varázslatos dzsungel';

  @override
  String get locVetArcticTundra => 'Sarki tundra';

  @override
  String get locVetOceanReef => 'Óceáni zátony';

  @override
  String get locVetEnchantedForest => 'Elvarázsolt erdő';

  @override
  String get locVetSafariPlains => 'Szafari síkság';

  @override
  String get locVetUndergroundWorld => 'Föld alatti világ';

  @override
  String get locVetCloudSanctuary => 'Felhő menedék';

  @override
  String get locVetDesertOasis => 'Sivatagi oázis';

  @override
  String get goalVetHealDragon => 'Meggyógyítani a beteg sárkányt';

  @override
  String get goalVetSaveBabyWhale => 'Megmenteni az elveszett bálnaborjút';

  @override
  String get goalVetHelpWolf => 'Segíteni az ijedt farkasnak';

  @override
  String get goalVetCureFever => 'Meggyógyítani a varázslatos lázat';

  @override
  String get goalVetRescueAnimals => 'Megmenteni az állatokat az áradástól';

  @override
  String get goalVetFindAnimalFamily => 'Megtalálni az elveszett állatcsaládot';

  @override
  String get goalVetInvisibleCreature => 'Megtalálni a láthatatlan teremtményt';

  @override
  String get goalVetWarmBirds => 'Felmelegíteni a fázó madarakat';

  @override
  String get locInventorSkyWorkshop => 'Égi műhely';

  @override
  String get locInventorUndergroundFactory => 'Föld alatti gyár';

  @override
  String get locInventorMagicLibrary => 'Varázslatos könyvtár';

  @override
  String get locInventorCrystalMountain => 'Kristályhegy';

  @override
  String get locInventorFutureMuseum => 'Jövő múzeuma';

  @override
  String get locInventorCloudWorkshop => 'Felhő műhely';

  @override
  String get locInventorRobotCity => 'Robotváros';

  @override
  String get locInventorVolcanoForge => 'Vulkán kohó';

  @override
  String get goalInventorBuildMachine => 'Megépíteni a varázslatos gépet';

  @override
  String get goalInventorFixCity => 'Megjavítani a törött várost';

  @override
  String get goalInventorRainbowBridge => 'Megépíteni a szivárványhidat';

  @override
  String get goalInventorSolvePuzzle => 'Megoldani a lehetetlen rejtvényt';

  @override
  String get goalInventorPowerLighthouse => 'Megjavítani a világítótornyot';

  @override
  String get goalInventorDreamToy => 'Megépíteni az álomjátékszert';

  @override
  String get goalInventorFlyingShip => 'Befejezni a repülő hajót';

  @override
  String get goalInventorWakeRobot => 'Felébreszteni az alvó robotot';

  @override
  String get locDinoHunterDinoValley => 'Dino völgy';

  @override
  String get locDinoHunterAncientDesert => 'Ősi sivatag';

  @override
  String get locDinoHunterUndergroundCave => 'Föld alatti barlang';

  @override
  String get locDinoHunterTimePortal => 'Időkapu';

  @override
  String get locDinoHunterFossilBeach => 'Fosszília tengerpart';

  @override
  String get locDinoHunterPrehistoricForest => 'Őserdő';

  @override
  String get locDinoHunterAmberJungle => 'Borostyán dzsungel';

  @override
  String get locDinoHunterVolcanicBadlands => 'Vulkáni sivatag';

  @override
  String get goalDinoHunterHiddenFossil => 'Feltárni a rejtett fosszíliát';

  @override
  String get goalDinoHunterBabyDino => 'Barátságot kötni a bébi dinóval';

  @override
  String get goalDinoHunterSolveMystery => 'Megoldani az ősi rejtélyt';

  @override
  String get goalDinoHunterSaveDinoEggs => 'Megmenteni a dino tojásokat';

  @override
  String get goalDinoHunterDecodeLanguage => 'Megfejteni az ősi nyelvet';

  @override
  String get goalDinoHunterRescueTraveler => 'Megmenteni az időutazót';

  @override
  String get goalDinoHunterMeteorCrater => 'Megtalálni a meteorit kráterét';

  @override
  String get goalDinoHunterStopStampede => 'Megállítani a dino rohamot';

  @override
  String get locFirefighterBurningForest => 'Égő erdő';

  @override
  String get locFirefighterMagicCity => 'Varázslatos város';

  @override
  String get locFirefighterVolcanoIsland => 'Vulkán sziget';

  @override
  String get locFirefighterCrystalTower => 'Kristálytorony';

  @override
  String get locFirefighterCloudTown => 'Felhőváros';

  @override
  String get locFirefighterAncientRuins => 'Ősi romok';

  @override
  String get locFirefighterHauntedMansion => 'Kísértetjárta kastély';

  @override
  String get locFirefighterIcePalace => 'Jégpalota';

  @override
  String get goalFirefighterStopFire => 'Megállítani az erdőtüzet';

  @override
  String get goalFirefighterRescueFamily =>
      'Megmenteni a csapdába esett családot';

  @override
  String get goalFirefighterPutOutVolcano => 'Eloltani a vulkánt';

  @override
  String get goalFirefighterSaveLibrary =>
      'Megmenteni a varázslatos könyvtárat';

  @override
  String get goalFirefighterAnimalsEscape =>
      'Segíteni az állatoknak elmenekülni';

  @override
  String get goalFirefighterProtectCloud => 'Megvédeni a felhővárost';

  @override
  String get goalFirefighterMagicHose => 'Megtalálni a varázslatos tömlőt';

  @override
  String get goalFirefighterFreezeDragon => 'Megfagyasztani a tűzsárkányt';

  @override
  String get locRobotPilotSpaceStation => 'Űrállomás';

  @override
  String get locRobotPilotRobotFactory => 'Robotgyár';

  @override
  String get locRobotPilotFutureCity => 'Jövő városa';

  @override
  String get locRobotPilotCloudHighway => 'Felhős autópálya';

  @override
  String get locRobotPilotDigitalWorld => 'Digitális világ';

  @override
  String get locRobotPilotCrystalNebula => 'Kristályköd';

  @override
  String get locRobotPilotGiantHangar => 'Óriás hangár';

  @override
  String get locRobotPilotIonStorm => 'Ionvihar zóna';

  @override
  String get goalRobotPilotRepairSatellite => 'Megjavítani a műholdat';

  @override
  String get goalRobotPilotNavigateAsteroid => 'Navigálni az aszteroidaövön';

  @override
  String get goalRobotPilotRescueRobot => 'Megmenteni az elveszett robotot';

  @override
  String get goalRobotPilotWinRace => 'Megnyerni a repülőversenyt';

  @override
  String get goalRobotPilotDecodeSignal => 'Megfejteni az idegenjelzést';

  @override
  String get goalRobotPilotPreventCrash => 'Megakadályozni az összeütközést';

  @override
  String get goalRobotPilotRestorePower => 'Visszaállítani az energiamagot';

  @override
  String get goalRobotPilotCalmRobots => 'Lecsillapítani a robot felkelést';

  @override
  String get locDefaultMagicForest => 'Varázslatos erdő';

  @override
  String get locDefaultCloudKingdom => 'Felhőkirályság';

  @override
  String get locDefaultDeepOcean => 'Mély óceán';

  @override
  String get locDefaultMagicCastle => 'Varázslatos kastély';

  @override
  String get locDefaultVolcanoIsland => 'Vulkán sziget';

  @override
  String get locDefaultOuterSpace => 'Világűr';

  @override
  String get goalDefaultFindTreasure => 'Megtalálni a kincset';

  @override
  String get goalDefaultRescueFriend => 'Megmenteni egy barátot';

  @override
  String get goalDefaultBefriendMonster => 'Barátságot kötni egy szörnnyel';

  @override
  String get goalDefaultSolveMystery => 'Megoldani egy rejtélyt';

  @override
  String get goalDefaultSaveLand => 'Megmenteni a földet';

  @override
  String get goalDefaultWinRace => 'Megnyerni a nagy versenyt';

  @override
  String get homeTabTonight => 'MA ESTE';

  @override
  String get homeTabLibrary => 'KÖNYVTÁR';

  @override
  String get homeTabSettings => 'BEÁLLÍTÁSOK';

  @override
  String homeGreeting(String heroName) {
    return 'Jó estét, $heroName';
  }

  @override
  String get homeGreetingGeneric => 'Jó estét';

  @override
  String get homeSubtitle => 'Készen állsz a mai estei kalandra?';

  @override
  String get homeContinueReading => 'Olvasás folytatása';

  @override
  String get homeLibrarySection => 'Könyvtár';

  @override
  String get homeFilterRecent => 'Legutóbbi';

  @override
  String get homeFilterFavourites => 'Kedvencek';

  @override
  String get homeEmptyFavouritesTitle => 'Még nincsenek kedvencek';

  @override
  String get homeEmptyFavouritesSubtitle =>
      'Érintsd meg a szív ikont egy mesén, hogy ide mentsd.';

  @override
  String get homeEmptyStoriesTitle => 'A kalandok ma este kezdődnek';

  @override
  String get homeEmptyStoriesSubtitle =>
      'Érintsd meg a Ma esti kaland gombot az első mese létrehozásához.';

  @override
  String get homeStartNow => 'Kezdjük most';

  @override
  String get homeCreateHero => 'Hős létrehozása';

  @override
  String get homeAddHero => 'Hős hozzáadása';

  @override
  String get homeAdventureChip => 'Kaland →';

  @override
  String get homeOfflineIndicator => 'Offline — gyorsítótárazott mesék';

  @override
  String get homeDeleteHeroError =>
      'Nem sikerült törölni a hőst. Kérlek próbáld újra.';

  @override
  String homeDeleteHeroTitle(String heroName) {
    return '$heroName törlése?';
  }

  @override
  String homeDeleteHeroMessage(String heroName) {
    return '$heroName hősprofiljának végleges törlése. A hőssel létrehozott mesék megmaradnak a könyvtárban.';
  }

  @override
  String get homeDialogCancel => 'Mégse';

  @override
  String get homeDialogDelete => 'Törlés';

  @override
  String homePageCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count oldal',
      one: '1 oldal',
    );
    return '$_temp0';
  }

  @override
  String generationLoadingDrawing(String name) {
    return '$name kalandjának rajzolása...';
  }

  @override
  String get generationLoadingWriting => 'A mai esti mese írása...';

  @override
  String get generationLoadingPainting => 'A hold festése...';

  @override
  String get generationLoadingMixing => 'A tökéletes színek keverése...';

  @override
  String get generationLoadingMagic => 'Egy csipet varázslat hozzáadása...';

  @override
  String get generationLoadingAlmost => 'Már majdnem kész...';

  @override
  String get generationCancel => 'Mégse';

  @override
  String get generationErrorDailyLimit =>
      'Elérted a napi mesék számát.\nHolnap éjféltől újra lehet mesét létrehozni.';

  @override
  String get generationErrorFreeTier =>
      'Az ingyenes mesét már felhasználtad.\nElőfizess a további mesékhez.';

  @override
  String get generationErrorContent =>
      'A mese tartalmát nem lehetett jóváhagyni.\nPróbálj más beállításokat.';

  @override
  String get generationErrorGeneric =>
      'A mese létrehozása sikertelen.\nEllenőrizd a kapcsolatot és próbáld újra.';

  @override
  String get generationRetry => 'Újra próbálom';

  @override
  String get generationBack => 'Vissza';

  @override
  String get readerListen => 'Hallgatás';

  @override
  String get readerPause => 'Szünet';

  @override
  String readerPageIndicator(int current, int total) {
    return '$current / $total';
  }

  @override
  String get readerErrorTitle => 'A mese betöltése sikertelen';

  @override
  String get readerErrorBack => 'Vissza';

  @override
  String get settingsTitle => 'Beállítások';

  @override
  String get settingsSectionAccount => 'FIÓK';

  @override
  String get settingsSignedInFallback => 'Bejelentkezve';

  @override
  String get settingsPremiumLabel => 'Prémium előfizető';

  @override
  String get settingsFreePlan => 'Ingyenes csomag';

  @override
  String get settingsPremiumBadge => 'PRÉMIUM';

  @override
  String get settingsFreeBadge => 'INGYENES';

  @override
  String get settingsManageSubscription => 'Előfizetés kezelése';

  @override
  String get settingsRestorePurchases => 'Vásárlások visszaállítása';

  @override
  String get settingsSectionStoryPrefs => 'MESE BEÁLLÍTÁSOK';

  @override
  String get settingsStoryLanguage => 'Mese nyelve';

  @override
  String get settingsDefaultArtStyle => 'Alapértelmezett rajzstílus';

  @override
  String get settingsNarrationVoice => 'Felolvasó hang';

  @override
  String get settingsSectionReader => 'OLVASÓ';

  @override
  String get settingsAutoPlay => 'Automatikus felolvasás';

  @override
  String get settingsSleepMode => 'Alvó mód';

  @override
  String get settingsBackgroundMusic => 'Háttérzene';

  @override
  String get settingsSectionApp => 'ALKALMAZÁS';

  @override
  String get settingsTheme => 'Téma';

  @override
  String get settingsThemeDark => 'Sötét';

  @override
  String get settingsBedtimeReminder => 'Lefekvési emlékeztető';

  @override
  String get settingsSectionSupport => 'TÁMOGATÁS';

  @override
  String get settingsHelpCenter => 'Súgóközpont';

  @override
  String get settingsContactUs => 'Kapcsolat';

  @override
  String get settingsRateApp => 'Értékeld a Lullabookot';

  @override
  String get settingsSectionLegal => 'JOGI';

  @override
  String get settingsTerms => 'Felhasználási feltételek';

  @override
  String get settingsPrivacy => 'Adatvédelmi nyilatkozat';

  @override
  String get settingsSectionAccountActions => 'FIÓKMŰVELETEK';

  @override
  String get settingsSignOut => 'Kijelentkezés';

  @override
  String get settingsDeleteAccount => 'Fiók törlése';

  @override
  String get settingsDeleteAccountTitle => 'Fiók törlése?';

  @override
  String get settingsDeleteAccountMessage =>
      'Ezzel véglegesen törlöd a fiókodat, hőseidet és az összes mesét. Ez nem vonható vissza.';

  @override
  String get settingsDeleteAccountCancel => 'Mégse';

  @override
  String get settingsDeleteAccountConfirm => 'Törlés';

  @override
  String get settingsPurchasesRestored => 'Vásárlások visszaállítva';

  @override
  String get settingsNothingToRestore => 'Nincs visszaállítható vásárlás';

  @override
  String get settingsDeleteError =>
      'Nem sikerült törölni a fiókot. Lépj kapcsolatba az ügyfélszolgálattal.';

  @override
  String get settingsSectionDeveloper => 'FEJLESZTŐI';

  @override
  String get settingsDebugMode => 'Debug mód';

  @override
  String get settingsGenerateTestStory => 'Teszt mese generálása';

  @override
  String get settingsFooter => 'Lullabook · v1.0';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageHungarian => 'Magyar';

  @override
  String get paywallTitle => 'Nyisd fel a Lullabookot';

  @override
  String get paywallSubtitle => 'Korlátlan személyre szabott esti mesék';

  @override
  String get paywallWeekly => 'Heti';

  @override
  String get paywallYearly => 'Éves';

  @override
  String paywallWeeklySubtitle(String price) {
    return '3 napos ingyenes próbaidőszak, majd $price/hét';
  }

  @override
  String paywallYearlySubtitle(String price) {
    return '$price/év — legjobb érték';
  }

  @override
  String get paywallContinue => 'Tovább';

  @override
  String get paywallRestorePurchases => 'Vásárlások visszaállítása';

  @override
  String get paywallErrorLoad => 'Nem sikerült betölteni az ajánlatokat';

  @override
  String get paywallErrorNoOffers => 'Nincs elérhető ajánlat';

  @override
  String get paywallErrorPurchaseFailed =>
      'Vásárlás sikertelen. Kérlek próbáld újra.';

  @override
  String get paywallPurchasesRestored => 'Vásárlások visszaállítva!';

  @override
  String get paywallNoSubscription => 'Nincs aktív előfizetés.';
}
