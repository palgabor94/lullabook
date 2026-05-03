// // ─────────────────────────────────────────────────────────────────────────────
// // Lullabook — Adventure Setup Screen
// //
// // Sprint 3 expansion:
// // - 12 locations + 12 goals per theme (was 8+8)
// // - New theme: cosy_home — everyday tales without a hero role, soft bedtime mood
// // - Theme list reordered so cosy_home appears first (most universal)
// // - Goals are now thematically tied to each theme's locations and tone
// // ─────────────────────────────────────────────────────────────────────────────

// import 'dart:io';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:lullabook/generated/l10n/app_localizations.dart';

// import '../../core/providers/debug_settings_provider.dart';
// import '../../core/theme/app_colors.dart';
// import '../../core/theme/app_text_styles.dart';
// import '../../data/repositories/buddy_repository.dart';
// import '../../domain/entities/buddy.dart';

// // ── Data model ────────────────────────────────────────────────────────────────

// typedef _Option = ({String id, String label, String emoji});

// class _ThemeContext {
//   final List<_Option> locations;
//   final List<_Option> goals;
//   const _ThemeContext({required this.locations, required this.goals});
// }

// // ── Const structures for state management (ID lookup only) ───────────────────

// const List<({String id, String emoji})> _kThemeIds = [
//   (id: 'cosy_home',      emoji: '🏠'),
//   (id: 'astronaut',      emoji: '🚀'),
//   (id: 'pirate',         emoji: '🏴‍☠️'),
//   (id: 'wizard',         emoji: '🧙'),
//   (id: 'princess',       emoji: '👑'),
//   (id: 'knight',         emoji: '⚔️'),
//   (id: 'mermaid',        emoji: '🧜'),
//   (id: 'superhero',      emoji: '🦸'),
//   (id: 'chef',           emoji: '👨‍🍳'),
//   (id: 'scientist',      emoji: '🔬'),
//   (id: 'ninja',          emoji: '🥷'),
//   (id: 'explorer',       emoji: '🧭'),
//   (id: 'vet',            emoji: '🐾'),
//   (id: 'inventor',       emoji: '💡'),
//   (id: 'paleontologist', emoji: '🦕'),
//   (id: 'firefighter',    emoji: '🚒'),
//   (id: 'robot_pilot',    emoji: '🤖'),
// ];

// // First location/goal IDs per theme (for state init when switching themes)
// const Map<String, (String, String)> _kThemeFirstIds = {
//   'cosy_home':      ('home_bedroom',     'lost_toy'),
//   'astronaut':      ('space_station',    'fix_rocket'),
//   'pirate':         ('treasure_island',  'buried_treasure'),
//   'wizard':         ('magic_forest',     'break_spell'),
//   'princess':       ('royal_palace',     'missing_crown'),
//   'knight':         ('dragon_lair',      'defeat_dragon'),
//   'mermaid':        ('deep_ocean',       'stolen_pearl'),
//   'superhero':      ('big_city',         'stop_meteor_super'),
//   'chef':           ('magic_kitchen',    'magical_dish'),
//   'scientist':      ('secret_lab',       'new_element'),
//   'ninja':          ('hidden_temple',    'stolen_scroll'),
//   'explorer':       ('amazon_jungle',    'map_island'),
//   'vet':            ('magic_jungle',     'heal_dragon'),
//   'inventor':       ('sky_workshop',     'magical_machine'),
//   'paleontologist': ('dino_valley',      'hidden_fossil'),
//   'firefighter':    ('burning_forest',   'stop_fire'),
//   'robot_pilot':    ('robot_space',      'repair_satellite'),
// };

// // ── Localized theme builder ───────────────────────────────────────────────────

// List<_Option> _buildThemes(AppLocalizations l10n) => [
//   (id: 'cosy_home',      label: l10n.themeCosyHome,      emoji: '🏠'),
//   (id: 'astronaut',      label: l10n.themeAstronaut,     emoji: '🚀'),
//   (id: 'pirate',         label: l10n.themePirate,        emoji: '🏴‍☠️'),
//   (id: 'wizard',         label: l10n.themeWizard,        emoji: '🧙'),
//   (id: 'princess',       label: l10n.themePrincess,      emoji: '👑'),
//   (id: 'knight',         label: l10n.themeKnight,        emoji: '⚔️'),
//   (id: 'mermaid',        label: l10n.themeMermaid,       emoji: '🧜'),
//   (id: 'superhero',      label: l10n.themeSuperhero,     emoji: '🦸'),
//   (id: 'chef',           label: l10n.themeChef,          emoji: '👨‍🍳'),
//   (id: 'scientist',      label: l10n.themeScientist,     emoji: '🔬'),
//   (id: 'ninja',          label: l10n.themeNinja,         emoji: '🥷'),
//   (id: 'explorer',       label: l10n.themeExplorer,      emoji: '🧭'),
//   (id: 'vet',            label: l10n.themeVet,           emoji: '🐾'),
//   (id: 'inventor',       label: l10n.themeInventor,      emoji: '💡'),
//   (id: 'paleontologist', label: l10n.themeDinoHunter,    emoji: '🦕'),
//   (id: 'firefighter',    label: l10n.themeFirefighter,   emoji: '🚒'),
//   (id: 'robot_pilot',    label: l10n.themeRobotPilot,    emoji: '🤖'),
// ];

// // ── Theme contexts (12 locations + 12 goals each) ────────────────────────────

// Map<String, _ThemeContext> _buildThemeContexts(AppLocalizations l10n) => {
//   // ── COSY HOME ─────────────────────────────────────────────────────────────
//   'cosy_home': _ThemeContext(
//     locations: [
//       (id: 'home_bedroom',     label: l10n.locCosyHomeBedroom,        emoji: '🛏️'),
//       (id: 'home_kitchen',     label: l10n.locCosyHomeKitchen,        emoji: '🍳'),
//       (id: 'home_garden',      label: l10n.locCosyHomeGarden,         emoji: '🌷'),
//       (id: 'home_attic',       label: l10n.locCosyHomeAttic,          emoji: '📦'),
//       (id: 'home_livingroom',  label: l10n.locCosyHomeLivingRoom,     emoji: '🛋️'),
//       (id: 'park_nearby',      label: l10n.locCosyParkNearby,         emoji: '🌳'),
//       (id: 'library',          label: l10n.locCosyLibrary,            emoji: '📚'),
//       (id: 'playground',       label: l10n.locCosyPlayground,         emoji: '🎠'),
//       (id: 'farmers_market',   label: l10n.locCosyFarmersMarket,      emoji: '🥕'),
//       (id: 'forest_clearing',  label: l10n.locCosyForestClearing,     emoji: '🍂'),
//       (id: 'pond',             label: l10n.locCosyPond,               emoji: '🦆'),
//       (id: 'meadow',           label: l10n.locCosyMeadow,             emoji: '🌼'),
//     ],
//     goals: [
//       (id: 'lost_toy',         label: l10n.goalCosyLostToy,           emoji: '🧸'),
//       (id: 'first_friend',     label: l10n.goalCosyFirstFriend,       emoji: '🤝'),
//       (id: 'help_neighbour',   label: l10n.goalCosyHelpNeighbour,     emoji: '🌻'),
//       (id: 'tidy_room',        label: l10n.goalCosyTidyRoom,          emoji: '✨'),
//       (id: 'bake_together',    label: l10n.goalCosyBakeTogether,      emoji: '🍪'),
//       (id: 'feed_birds',       label: l10n.goalCosyFeedBirds,         emoji: '🐦'),
//       (id: 'bedtime_fear',     label: l10n.goalCosyBedtimeFear,       emoji: '🌙'),
//       (id: 'share_toy',        label: l10n.goalCosyShareToy,          emoji: '🎁'),
//       (id: 'plant_seed',       label: l10n.goalCosyPlantSeed,         emoji: '🌱'),
//       (id: 'rainy_afternoon',  label: l10n.goalCosyRainyAfternoon,    emoji: '🌧️'),
//       (id: 'visit_grandparent',label: l10n.goalCosyVisitGrandparent,  emoji: '👵'),
//       (id: 'find_pebble',      label: l10n.goalCosyFindPebble,        emoji: '🪨'),
//     ],
//   ),

//   // ── ASTRONAUT ─────────────────────────────────────────────────────────────
//   'astronaut': _ThemeContext(
//     locations: [
//       (id: 'space_station',    label: l10n.locAstronautSpaceStation,    emoji: '🛸'),
//       (id: 'planet_mars',      label: l10n.locAstronautPlanetMars,      emoji: '🔴'),
//       (id: 'moon',             label: l10n.locAstronautMoon,            emoji: '🌕'),
//       (id: 'asteroid_belt',    label: l10n.locAstronautAsteroidBelt,    emoji: '☄️'),
//       (id: 'alien_planet',     label: l10n.locAstronautAlienPlanet,     emoji: '🌍'),
//       (id: 'comet',            label: l10n.locAstronautCometTrail,      emoji: '💫'),
//       (id: 'nebula',           label: l10n.locAstronautCrystalNebula,   emoji: '🌌'),
//       (id: 'black_hole',       label: l10n.locAstronautBlackHole,       emoji: '🌀'),
//       (id: 'rings_of_saturn',  label: l10n.locAstronautRingsOfSaturn,   emoji: '🪐'),
//       (id: 'jupiter_storm',    label: l10n.locAstronautJupiterStorm,    emoji: '🌪️'),
//       (id: 'ice_moon',         label: l10n.locAstronautIceMoon,         emoji: '🧊'),
//       (id: 'lunar_base',       label: l10n.locAstronautLunarBase,       emoji: '🏗️'),
//     ],
//     goals: [
//       (id: 'fix_rocket',       label: l10n.goalAstronautFixRocket,      emoji: '🔧'),
//       (id: 'new_planet',       label: l10n.goalAstronautDiscoverPlanet, emoji: '🔭'),
//       (id: 'save_station',     label: l10n.goalAstronautSaveStation,    emoji: '🛰️'),
//       (id: 'alien_friends',    label: l10n.goalAstronautBefriendAliens, emoji: '👽'),
//       (id: 'find_lost_star',   label: l10n.goalAstronautFindStar,       emoji: '⭐'),
//       (id: 'stop_meteor',      label: l10n.goalAstronautStopMeteor,     emoji: '💥'),
//       (id: 'lost_astronaut',   label: l10n.goalAstronautRescueCrew,     emoji: '🚑'),
//       (id: 'space_treasure',   label: l10n.goalAstronautSpaceCrystal,   emoji: '💎'),
//       (id: 'plant_moon_flag',  label: l10n.goalAstronautPlantFlag,      emoji: '🚩'),
//       (id: 'first_contact',    label: l10n.goalAstronautFirstContact,   emoji: '📡'),
//       (id: 'stardust_sample',  label: l10n.goalAstronautStardustSample, emoji: '✨'),
//       (id: 'space_garden',     label: l10n.goalAstronautSpaceGarden,    emoji: '🌱'),
//     ],
//   ),

//   // ── PIRATE ────────────────────────────────────────────────────────────────
//   'pirate': _ThemeContext(
//     locations: [
//       (id: 'treasure_island',  label: l10n.locPirateTreasureIsland,    emoji: '🏝️'),
//       (id: 'high_seas',        label: l10n.locPirateHighSeas,          emoji: '⛵'),
//       (id: 'sunken_ship',      label: l10n.locPirateSunkenGalleon,     emoji: '🚢'),
//       (id: 'sea_cave',         label: l10n.locPirateSeaCave,           emoji: '🦀'),
//       (id: 'pirate_port',      label: l10n.locPiratePiratePort,        emoji: '⚓'),
//       (id: 'coral_reef',       label: l10n.locPirateCoralReef,         emoji: '🪸'),
//       (id: 'fog_island',       label: l10n.locPirateFogIsland,         emoji: '🌫️'),
//       (id: 'stormy_sea',       label: l10n.locPirateStormySea,         emoji: '⛈️'),
//       (id: 'volcanic_atoll',   label: l10n.locPirateVolcanicAtoll,     emoji: '🌋'),
//       (id: 'mermaid_lagoon',   label: l10n.locPirateMermaidLagoon,     emoji: '🧜'),
//       (id: 'kraken_waters',    label: l10n.locPirateKrakenWaters,      emoji: '🐙'),
//       (id: 'ghost_ship',       label: l10n.locPirateGhostShip,         emoji: '👻'),
//     ],
//     goals: [
//       (id: 'buried_treasure',  label: l10n.goalPirateBuriedTreasure,   emoji: '💰'),
//       (id: 'free_whale',       label: l10n.goalPirateFreeWhale,        emoji: '🐋'),
//       (id: 'decode_map',       label: l10n.goalPirateDecodeMap,        emoji: '🗺️'),
//       (id: 'sail_storm',       label: l10n.goalPirateSailStorm,        emoji: '⛵'),
//       (id: 'save_lighthouse',  label: l10n.goalPirateSaveLighthouse,   emoji: '🏮'),
//       (id: 'sunken_ship_goal', label: l10n.goalPirateFindSunkenShip,   emoji: '🤿'),
//       (id: 'beat_pirate',      label: l10n.goalPirateBeatRival,        emoji: '🏴‍☠️'),
//       (id: 'magic_shell',      label: l10n.goalPirateMagicShell,       emoji: '🐚'),
//       (id: 'tame_kraken',      label: l10n.goalPirateTameKraken,       emoji: '🐙'),
//       (id: 'mutiny_calm',      label: l10n.goalPirateMutinyCalm,       emoji: '🤝'),
//       (id: 'rescue_parrot',    label: l10n.goalPirateRescueParrot,     emoji: '🦜'),
//       (id: 'free_ghost_crew',  label: l10n.goalPirateFreeGhostCrew,    emoji: '👻'),
//     ],
//   ),

//   // ── WIZARD ────────────────────────────────────────────────────────────────
//   'wizard': _ThemeContext(
//     locations: [
//       (id: 'magic_forest',     label: l10n.locWizardMagicForest,       emoji: '🌲'),
//       (id: 'wizard_castle',    label: l10n.locWizardEnchantedCastle,   emoji: '🏰'),
//       (id: 'crystal_cave',     label: l10n.locWizardCrystalCave,       emoji: '💎'),
//       (id: 'wizard_tower',     label: l10n.locWizardWizardTower,       emoji: '🗼'),
//       (id: 'spell_library',    label: l10n.locWizardSpellLibrary,      emoji: '📚'),
//       (id: 'dragon_mountain',  label: l10n.locWizardDragonMountain,    emoji: '🐉'),
//       (id: 'floating_islands', label: l10n.locWizardFloatingIslands,   emoji: '🏝️'),
//       (id: 'mirror_realm',     label: l10n.locWizardMirrorRealm,       emoji: '🪞'),
//       (id: 'starlit_glade',    label: l10n.locWizardStarlitGlade,      emoji: '🌟'),
//       (id: 'phoenix_nest',     label: l10n.locWizardPhoenixNest,       emoji: '🔥'),
//       (id: 'mooncourt',        label: l10n.locWizardMoonCourt,         emoji: '🌙'),
//       (id: 'fae_market',       label: l10n.locWizardFaeMarket,         emoji: '🍄'),
//     ],
//     goals: [
//       (id: 'break_spell',      label: l10n.goalWizardBreakSpell,       emoji: '🔮'),
//       (id: 'brew_potion',      label: l10n.goalWizardBrewPotion,       emoji: '🧪'),
//       (id: 'stolen_wand',      label: l10n.goalWizardReturnWand,       emoji: '🪄'),
//       (id: 'wild_spell',       label: l10n.goalWizardTameSpell,        emoji: '✨'),
//       (id: 'forbidden_book',   label: l10n.goalWizardForbiddenBook,    emoji: '📖'),
//       (id: 'save_forest',      label: l10n.goalWizardSaveForest,       emoji: '🌳'),
//       (id: 'tame_dragon',      label: l10n.goalWizardTameDragon,       emoji: '🐲'),
//       (id: 'find_apprentice',  label: l10n.goalWizardFindApprentice,   emoji: '🧑‍🎓'),
//       (id: 'first_spell',      label: l10n.goalWizardFirstSpell,       emoji: '⚡'),
//       (id: 'restore_phoenix',  label: l10n.goalWizardRestorePhoenix,   emoji: '🔥'),
//       (id: 'moon_blessing',    label: l10n.goalWizardMoonBlessing,     emoji: '🌙'),
//       (id: 'fae_bargain',      label: l10n.goalWizardFaeBargain,       emoji: '🤝'),
//     ],
//   ),

//   // ── PRINCESS ──────────────────────────────────────────────────────────────
//   'princess': _ThemeContext(
//     locations: [
//       (id: 'royal_palace',     label: l10n.locPrincessRoyalPalace,     emoji: '🏰'),
//       (id: 'enchanted_garden', label: l10n.locPrincessEnchantedGarden, emoji: '🌸'),
//       (id: 'glass_lake',       label: l10n.locPrincessGlassLake,       emoji: '🏞️'),
//       (id: 'fairy_village',    label: l10n.locPrincessFairyVillage,    emoji: '🧚'),
//       (id: 'cloud_kingdom',    label: l10n.locPrincessCloudKingdom,    emoji: '☁️'),
//       (id: 'magic_ballroom',   label: l10n.locPrincessMagicBallroom,   emoji: '💃'),
//       (id: 'moonlit_forest',   label: l10n.locPrincessMoonlitForest,   emoji: '🌙'),
//       (id: 'rainbow_bridge',   label: l10n.locPrincessRainbowBridge,   emoji: '🌈'),
//       (id: 'rose_maze',        label: l10n.locPrincessRoseMaze,        emoji: '🌹'),
//       (id: 'crystal_tower',    label: l10n.locPrincessCrystalTower,    emoji: '💠'),
//       (id: 'dawn_gardens',     label: l10n.locPrincessDawnGardens,     emoji: '🌅'),
//       (id: 'tea_pavilion',     label: l10n.locPrincessTeaPavilion,     emoji: '🍵'),
//     ],
//     goals: [
//       (id: 'missing_crown',    label: l10n.goalPrincessMissingCrown,   emoji: '👑'),
//       (id: 'save_garden',      label: l10n.goalPrincessSaveGarden,     emoji: '🌺'),
//       (id: 'royal_ball',       label: l10n.goalPrincessRoyalBall,      emoji: '💃'),
//       (id: 'lonely_giant',     label: l10n.goalPrincessBefriendGiant,  emoji: '🤝'),
//       (id: 'castle_mystery',   label: l10n.goalPrincessSolveMystery,   emoji: '🔍'),
//       (id: 'sleeping_kingdom', label: l10n.goalPrincessWakeKingdom,    emoji: '😴'),
//       (id: 'rescue_unicorn',   label: l10n.goalPrincessRescueUnicorn,  emoji: '🦄'),
//       (id: 'magic_mirror',     label: l10n.goalPrincessMagicMirror,    emoji: '🪞'),
//       (id: 'tea_with_dragon',  label: l10n.goalPrincessTeaWithDragon,  emoji: '🍵'),
//       (id: 'fairy_pact',       label: l10n.goalPrincessFairyPact,      emoji: '🧚'),
//       (id: 'singing_rose',     label: l10n.goalPrincessSingingRose,    emoji: '🌹'),
//       (id: 'lost_kitten',      label: l10n.goalPrincessLostKitten,     emoji: '🐱'),
//     ],
//   ),

//   // ── KNIGHT ────────────────────────────────────────────────────────────────
//   'knight': _ThemeContext(
//     locations: [
//       (id: 'dragon_lair',      label: l10n.locKnightDragonLair,        emoji: '🐉'),
//       (id: 'dark_forest',      label: l10n.locKnightDarkForest,        emoji: '🌲'),
//       (id: 'giants_keep',      label: l10n.locKnightGiantsKeep,        emoji: '🏰'),
//       (id: 'ancient_ruins',    label: l10n.locKnightAncientRuins,      emoji: '🏛️'),
//       (id: 'enchanted_bridge', label: l10n.locKnightEnchantedBridge,   emoji: '🌉'),
//       (id: 'mountain_pass',    label: l10n.locKnightMountainPass,      emoji: '⛰️'),
//       (id: 'fairy_kingdom',    label: l10n.locKnightFairyKingdom,      emoji: '🧚'),
//       (id: 'frozen_castle',    label: l10n.locKnightFrozenCastle,      emoji: '❄️'),
//       (id: 'silver_lake',      label: l10n.locKnightSilverLake,        emoji: '🌊'),
//       (id: 'tournament_field', label: l10n.locKnightTournamentField,   emoji: '🏇'),
//       (id: 'wizard_grove',     label: l10n.locKnightWizardGrove,       emoji: '🌳'),
//       (id: 'haunted_keep',     label: l10n.locKnightHauntedKeep,       emoji: '👻'),
//     ],
//     goals: [
//       (id: 'defeat_dragon',    label: l10n.goalKnightDefeatDragon,     emoji: '⚔️'),
//       (id: 'rescue_princess',  label: l10n.goalKnightRescueHero,       emoji: '🤝'),
//       (id: 'golden_sword',     label: l10n.goalKnightGoldenSword,      emoji: '⚔️'),
//       (id: 'protect_village',  label: l10n.goalKnightProtectVillage,   emoji: '🛡️'),
//       (id: 'break_curse',      label: l10n.goalKnightBreakCurse,       emoji: '💀'),
//       (id: 'win_tournament',   label: l10n.goalKnightWinTournament,    emoji: '🏆'),
//       (id: 'siege_castle',     label: l10n.goalKnightFreeCastle,       emoji: '🏰'),
//       (id: 'holy_grail',       label: l10n.goalKnightMagicGrail,       emoji: '🏆'),
//       (id: 'tame_griffin',     label: l10n.goalKnightTameGriffin,      emoji: '🦅'),
//       (id: 'cross_bridge',     label: l10n.goalKnightCrossBridge,      emoji: '🌉'),
//       (id: 'first_quest',      label: l10n.goalKnightFirstQuest,       emoji: '✨'),
//       (id: 'soothe_ghost',     label: l10n.goalKnightSootheGhost,      emoji: '👻'),
//     ],
//   ),

//   // ── MERMAID ───────────────────────────────────────────────────────────────
//   'mermaid': _ThemeContext(
//     locations: [
//       (id: 'deep_ocean',       label: l10n.locMermaidDeepOcean,        emoji: '🌊'),
//       (id: 'coral_kingdom',    label: l10n.locMermaidCoralKingdom,     emoji: '🪸'),
//       (id: 'underwater_cave',  label: l10n.locMermaidUnderwaterCave,   emoji: '🕳️'),
//       (id: 'sea_dragon_lair',  label: l10n.locMermaidSeaDragonLair,    emoji: '🐲'),
//       (id: 'sunken_city',      label: l10n.locMermaidSunkenCity,       emoji: '🏙️'),
//       (id: 'rainbow_reef',     label: l10n.locMermaidRainbowReef,      emoji: '🌈'),
//       (id: 'pearl_grotto',     label: l10n.locMermaidPearlGrotto,      emoji: '🐚'),
//       (id: 'whirlpool_sea',    label: l10n.locMermaidWhirlpoolSea,     emoji: '🌀'),
//       (id: 'kelp_forest',      label: l10n.locMermaidKelpForest,       emoji: '🌿'),
//       (id: 'moonlight_bay',    label: l10n.locMermaidMoonlightBay,     emoji: '🌙'),
//       (id: 'jellyfish_glade',  label: l10n.locMermaidJellyfishGlade,   emoji: '🪼'),
//       (id: 'shipwreck_garden', label: l10n.locMermaidShipwreckGarden,  emoji: '🚢'),
//     ],
//     goals: [
//       (id: 'stolen_pearl',     label: l10n.goalMermaidStolenPearl,     emoji: '🔮'),
//       (id: 'save_reef',        label: l10n.goalMermaidSaveReef,        emoji: '🪸'),
//       (id: 'lonely_shark',     label: l10n.goalMermaidFriendShark,     emoji: '🦈'),
//       (id: 'sunken_treasure',  label: l10n.goalMermaidSunkenTreasure,  emoji: '💰'),
//       (id: 'guide_fish',       label: l10n.goalMermaidGuideFish,       emoji: '🐟'),
//       (id: 'ocean_storm',      label: l10n.goalMermaidStopStorm,       emoji: '⛈️'),
//       (id: 'sea_witch',        label: l10n.goalMermaidOutwitWitch,     emoji: '🧙'),
//       (id: 'whale_song',       label: l10n.goalMermaidWhaleSecret,     emoji: '🐋'),
//       (id: 'baby_octopus',     label: l10n.goalMermaidBabyOctopus,     emoji: '🐙'),
//       (id: 'lost_starfish',    label: l10n.goalMermaidLostStarfish,    emoji: '⭐'),
//       (id: 'tide_pool_friend', label: l10n.goalMermaidTidePoolFriend,  emoji: '🦀'),
//       (id: 'mermaid_song',     label: l10n.goalMermaidLearnSong,       emoji: '🎵'),
//     ],
//   ),

//   // ── SUPERHERO ─────────────────────────────────────────────────────────────
//   'superhero': _ThemeContext(
//     locations: [
//       (id: 'big_city',         label: l10n.locSuperherooBigCity,       emoji: '🏙️'),
//       (id: 'secret_base',      label: l10n.locSuperheroSecretBase,     emoji: '🦇'),
//       (id: 'volcano_island',   label: l10n.locSuperheroVolcanoIsland,  emoji: '🌋'),
//       (id: 'hero_space',       label: l10n.locSuperheroOuterSpace,     emoji: '🌌'),
//       (id: 'underwater_city',  label: l10n.locSuperheroUnderwaterCity, emoji: '🌊'),
//       (id: 'storm_cloud',      label: l10n.locSuperheroStormCloud,     emoji: '⛈️'),
//       (id: 'rooftops',         label: l10n.locSuperheroCityRooftops,   emoji: '🏗️'),
//       (id: 'time_portal',      label: l10n.locSuperheroTimePortal,     emoji: '⏳'),
//       (id: 'subway_tunnels',   label: l10n.locSuperheroSubwayTunnels,  emoji: '🚇'),
//       (id: 'sky_arena',        label: l10n.locSuperheroSkyArena,       emoji: '🌤️'),
//       (id: 'frozen_metropolis',label: l10n.locSuperheroFrozenCity,     emoji: '❄️'),
//       (id: 'parallel_world',   label: l10n.locSuperheroParallelWorld,  emoji: '🪞'),
//     ],
//     goals: [
//       (id: 'stop_meteor_super',label: l10n.goalSuperheroStopMeteor,    emoji: '☄️'),
//       (id: 'save_flood',       label: l10n.goalSuperheroSaveFlood,     emoji: '🌊'),
//       (id: 'catch_villain',    label: l10n.goalSuperheroCatchVillain,  emoji: '🦹'),
//       (id: 'protect_secret',   label: l10n.goalSuperheroProtectSecret, emoji: '🕵️'),
//       (id: 'help_puppy',       label: l10n.goalSuperheroSavePuppy,     emoji: '🐕'),
//       (id: 'restore_powers',   label: l10n.goalSuperheroRestorePowers, emoji: '⚡'),
//       (id: 'evil_robot',       label: l10n.goalSuperheroStopRobot,     emoji: '🤖'),
//       (id: 'rescue_scientist', label: l10n.goalSuperheroRescueScientist,emoji: '👨‍🔬'),
//       (id: 'first_save',       label: l10n.goalSuperheroFirstSave,     emoji: '✨'),
//       (id: 'team_up_hero',     label: l10n.goalSuperheroTeamUp,        emoji: '👥'),
//       (id: 'reverse_freeze',   label: l10n.goalSuperheroReverseFreeze, emoji: '❄️'),
//       (id: 'find_mentor',      label: l10n.goalSuperheroFindMentor,    emoji: '🦸'),
//     ],
//   ),

//   // ── CHEF ──────────────────────────────────────────────────────────────────
//   'chef': _ThemeContext(
//     locations: [
//       (id: 'magic_kitchen',    label: l10n.locChefMagicKitchen,        emoji: '🍳'),
//       (id: 'enchanted_farm',   label: l10n.locChefEnchantedFarm,       emoji: '🌾'),
//       (id: 'candy_land',       label: l10n.locChefCandyLand,           emoji: '🍭'),
//       (id: 'secret_garden',    label: l10n.locChefSecretGarden,        emoji: '🌻'),
//       (id: 'giant_market',     label: l10n.locChefGiantMarket,         emoji: '🛒'),
//       (id: 'floating_rest',    label: l10n.locChefFloatingRestaurant,  emoji: '🍽️'),
//       (id: 'dragon_bakery',    label: l10n.locChefDragonBakery,        emoji: '🐉'),
//       (id: 'moonlit_vineyard', label: l10n.locChefMoonlitVineyard,     emoji: '🍇'),
//       (id: 'spice_caravan',    label: l10n.locChefSpiceCaravan,        emoji: '🐪'),
//       (id: 'cloud_pantry',     label: l10n.locChefCloudPantry,         emoji: '☁️'),
//       (id: 'rainbow_orchard',  label: l10n.locChefRainbowOrchard,      emoji: '🌈'),
//       (id: 'underwater_galley',label: l10n.locChefUnderwaterGalley,    emoji: '🐠'),
//     ],
//     goals: [
//       (id: 'magical_dish',     label: l10n.goalChefMagicalDish,        emoji: '✨'),
//       (id: 'missing_ingredient',label: l10n.goalChefMissingIngredient, emoji: '🧂'),
//       (id: 'hungry_dragon',    label: l10n.goalChefCookDragon,         emoji: '🔥'),
//       (id: 'cooking_contest',  label: l10n.goalChefWinContest,         emoji: '🏆'),
//       (id: 'stolen_recipe',    label: l10n.goalChefStolenRecipe,       emoji: '📜'),
//       (id: 'feed_kingdom',     label: l10n.goalChefFeedKingdom,        emoji: '🍞'),
//       (id: 'magic_cake',       label: l10n.goalChefImpossibleCake,     emoji: '🎂'),
//       (id: 'angry_food',       label: l10n.goalChefCalmIngredients,    emoji: '🫙'),
//       (id: 'rainbow_pie',      label: l10n.goalChefRainbowPie,         emoji: '🥧'),
//       (id: 'midnight_feast',   label: l10n.goalChefMidnightFeast,      emoji: '🌙'),
//       (id: 'spice_quest',      label: l10n.goalChefSpiceQuest,         emoji: '🌶️'),
//       (id: 'first_dish',       label: l10n.goalChefFirstDish,          emoji: '🍲'),
//     ],
//   ),

//   // ── SCIENTIST ─────────────────────────────────────────────────────────────
//   'scientist': _ThemeContext(
//     locations: [
//       (id: 'secret_lab',         label: l10n.locScientistSecretLab,         emoji: '🧪'),
//       (id: 'underwater_station', label: l10n.locScientistUnderwaterStation, emoji: '🌊'),
//       (id: 'arctic_base',        label: l10n.locScientistArcticBase,        emoji: '🧊'),
//       (id: 'space_observatory',  label: l10n.locScientistSpaceObservatory,  emoji: '🔭'),
//       (id: 'jungle_research',    label: l10n.locScientistJungleResearch,    emoji: '🌴'),
//       (id: 'volcano_lab',        label: l10n.locScientistVolcanoLab,        emoji: '🌋'),
//       (id: 'cloud_lab',          label: l10n.locScientistCloudLab,          emoji: '☁️'),
//       (id: 'future_city',        label: l10n.locScientistFutureCity,        emoji: '🏙️'),
//       (id: 'mushroom_lab',       label: l10n.locScientistMushroomLab,       emoji: '🍄'),
//       (id: 'particle_chamber',   label: l10n.locScientistParticleChamber,   emoji: '⚛️'),
//       (id: 'desert_dig',         label: l10n.locScientistDesertDig,         emoji: '🏜️'),
//       (id: 'rainforest_canopy',  label: l10n.locScientistRainforestCanopy,  emoji: '🐒'),
//     ],
//     goals: [
//       (id: 'new_element',      label: l10n.goalScientistNewElement,    emoji: '⚗️'),
//       (id: 'fix_experiment',   label: l10n.goalScientistFixExperiment, emoji: '🔧'),
//       (id: 'stop_virus',       label: l10n.goalScientistStopVirus,     emoji: '🦠'),
//       (id: 'time_machine',     label: l10n.goalScientistTimeMachine,   emoji: '⏳'),
//       (id: 'alien_equation',   label: l10n.goalScientistAlienEquation, emoji: '👽'),
//       (id: 'save_iceberg',     label: l10n.goalScientistSaveIceberg,   emoji: '🧊'),
//       (id: 'shrink_ray',       label: l10n.goalScientistReverseShrink, emoji: '🔬'),
//       (id: 'grow_creature',    label: l10n.goalScientistTameCreature,  emoji: '🦖'),
//       (id: 'first_invention',  label: l10n.goalScientistFirstInvention,emoji: '💡'),
//       (id: 'glowing_plant',    label: l10n.goalScientistGlowingPlant,  emoji: '🌱'),
//       (id: 'particle_puzzle',  label: l10n.goalScientistParticlePuzzle,emoji: '⚛️'),
//       (id: 'animal_language',  label: l10n.goalScientistAnimalLanguage,emoji: '🐾'),
//     ],
//   ),

//   // ── NINJA ─────────────────────────────────────────────────────────────────
//   'ninja': _ThemeContext(
//     locations: [
//       (id: 'hidden_temple',     label: l10n.locNinjaHiddenTemple,      emoji: '⛩️'),
//       (id: 'bamboo_forest',     label: l10n.locNinjaBambooForest,      emoji: '🎋'),
//       (id: 'mountain_fortress', label: l10n.locNinjaMountainFortress,  emoji: '🏔️'),
//       (id: 'shadow_city',       label: l10n.locNinjaShadowCity,        emoji: '🌃'),
//       (id: 'underground_maze',  label: l10n.locNinjaUndergroundMaze,   emoji: '🗺️'),
//       (id: 'ancient_ruins_n',   label: l10n.locNinjaAncientRuins,      emoji: '🏛️'),
//       (id: 'rooftop_village',   label: l10n.locNinjaRooftopVillage,    emoji: '🏘️'),
//       (id: 'fog_valley',        label: l10n.locNinjaFogValley,         emoji: '🌫️'),
//       (id: 'cherry_grove',      label: l10n.locNinjaCherryGrove,       emoji: '🌸'),
//       (id: 'koi_pond',          label: l10n.locNinjaKoiPond,           emoji: '🐟'),
//       (id: 'iron_dojo',         label: l10n.locNinjaIronDojo,          emoji: '🥋'),
//       (id: 'lantern_pass',      label: l10n.locNinjaLanternPass,       emoji: '🏮'),
//     ],
//     goals: [
//       (id: 'stolen_scroll',    label: l10n.goalNinjaStolenScroll,      emoji: '📜'),
//       (id: 'shadow_villain',   label: l10n.goalNinjaStopShadowVillain, emoji: '🦹'),
//       (id: 'secret_move',      label: l10n.goalNinjaMasterMove,        emoji: '🥋'),
//       (id: 'protect_village',  label: l10n.goalNinjaProtectVillage,    emoji: '🛡️'),
//       (id: 'uncover_mystery',  label: l10n.goalNinjaUncoverMystery,    emoji: '🔍'),
//       (id: 'rescue_master',    label: l10n.goalNinjaRescueMaster,      emoji: '🙏'),
//       (id: 'ancient_weapon',   label: l10n.goalNinjaFindWeapon,        emoji: '⚔️'),
//       (id: 'forbidden_technique',label: l10n.goalNinjaLearnTechnique,  emoji: '💨'),
//       (id: 'silent_passage',   label: l10n.goalNinjaSilentPassage,     emoji: '🤫'),
//       (id: 'first_test',       label: l10n.goalNinjaFirstTest,         emoji: '✨'),
//       (id: 'tame_tiger',       label: l10n.goalNinjaTameTiger,         emoji: '🐯'),
//       (id: 'restore_balance',  label: l10n.goalNinjaRestoreBalance,    emoji: '☯️'),
//     ],
//   ),

//   // ── EXPLORER ──────────────────────────────────────────────────────────────
//   'explorer': _ThemeContext(
//     locations: [
//       (id: 'amazon_jungle',     label: l10n.locExplorerAmazonJungle,    emoji: '🌴'),
//       (id: 'arctic_tundra',     label: l10n.locExplorerArcticTundra,    emoji: '🧊'),
//       (id: 'lost_desert',       label: l10n.locExplorerLostDesert,      emoji: '🏜️'),
//       (id: 'hidden_valley',     label: l10n.locExplorerHiddenValley,    emoji: '🏞️'),
//       (id: 'misty_mountains',   label: l10n.locExplorerMistyMountains,  emoji: '⛰️'),
//       (id: 'underwater_caves',  label: l10n.locExplorerUnderwaterCaves, emoji: '🤿'),
//       (id: 'floating_islands2', label: l10n.locExplorerFloatingIslands, emoji: '🏝️'),
//       (id: 'underground_city',  label: l10n.locExplorerUndergroundCity, emoji: '🏙️'),
//       (id: 'cloud_forest',      label: l10n.locExplorerCloudForest,     emoji: '☁️'),
//       (id: 'salt_flats',        label: l10n.locExplorerSaltFlats,       emoji: '🌫️'),
//       (id: 'glowworm_cave',     label: l10n.locExplorerGlowwormCave,    emoji: '✨'),
//       (id: 'sky_canyon',        label: l10n.locExplorerSkyCanyon,       emoji: '🦅'),
//     ],
//     goals: [
//       (id: 'map_island',       label: l10n.goalExplorerMapIsland,      emoji: '🗺️'),
//       (id: 'cross_jungle',     label: l10n.goalExplorerCrossJungle,    emoji: '🌿'),
//       (id: 'hidden_temple',    label: l10n.goalExplorerDiscoverTemple, emoji: '🏛️'),
//       (id: 'magic_waterfall',  label: l10n.goalExplorerFindWaterfall,  emoji: '💧'),
//       (id: 'rare_creature',    label: l10n.goalExplorerTrackCreature,  emoji: '🦋'),
//       (id: 'mountain_peak',    label: l10n.goalExplorerReachPeak,      emoji: '🏔️'),
//       (id: 'lost_tribe',       label: l10n.goalExplorerFindTribe,      emoji: '🏕️'),
//       (id: 'buried_city',      label: l10n.goalExplorerUncoverCity,    emoji: '🏟️'),
//       (id: 'first_discovery',  label: l10n.goalExplorerFirstDiscovery, emoji: '✨'),
//       (id: 'follow_starmap',   label: l10n.goalExplorerStarMap,        emoji: '🌟'),
//       (id: 'rescue_companion', label: l10n.goalExplorerRescueCompanion,emoji: '🤝'),
//       (id: 'ancient_clue',     label: l10n.goalExplorerAncientClue,    emoji: '🗝️'),
//     ],
//   ),

//   // ── VET ───────────────────────────────────────────────────────────────────
//   'vet': _ThemeContext(
//     locations: [
//       (id: 'magic_jungle',      label: l10n.locVetMagicJungle,         emoji: '🌴'),
//       (id: 'arctic_tundra_v',   label: l10n.locVetArcticTundra,        emoji: '🧊'),
//       (id: 'ocean_reef',        label: l10n.locVetOceanReef,           emoji: '🪸'),
//       (id: 'enchanted_forest',  label: l10n.locVetEnchantedForest,     emoji: '🌲'),
//       (id: 'safari_plains',     label: l10n.locVetSafariPlains,        emoji: '🦁'),
//       (id: 'underground_world', label: l10n.locVetUndergroundWorld,    emoji: '🕳️'),
//       (id: 'cloud_sanctuary',   label: l10n.locVetCloudSanctuary,      emoji: '☁️'),
//       (id: 'desert_oasis',      label: l10n.locVetDesertOasis,         emoji: '🌵'),
//       (id: 'butterfly_meadow',  label: l10n.locVetButterflyMeadow,     emoji: '🦋'),
//       (id: 'snowy_pinewood',    label: l10n.locVetSnowyPinewood,       emoji: '🌲'),
//       (id: 'firefly_swamp',     label: l10n.locVetFireflySwamp,        emoji: '🐸'),
//       (id: 'rescue_clinic',     label: l10n.locVetRescueClinic,        emoji: '🏥'),
//     ],
//     goals: [
//       (id: 'heal_dragon',      label: l10n.goalVetHealDragon,          emoji: '🐉'),
//       (id: 'baby_whale',       label: l10n.goalVetSaveBabyWhale,       emoji: '🐳'),
//       (id: 'scared_wolf',      label: l10n.goalVetHelpWolf,            emoji: '🐺'),
//       (id: 'magic_fever',      label: l10n.goalVetCureFever,           emoji: '💊'),
//       (id: 'flood_rescue',     label: l10n.goalVetRescueAnimals,       emoji: '🌊'),
//       (id: 'animal_family',    label: l10n.goalVetFindAnimalFamily,    emoji: '🐾'),
//       (id: 'invisible_creature',label: l10n.goalVetInvisibleCreature,  emoji: '👁️'),
//       (id: 'freezing_birds',   label: l10n.goalVetWarmBirds,           emoji: '🐦'),
//       (id: 'butterfly_wing',   label: l10n.goalVetButterflyWing,       emoji: '🦋'),
//       (id: 'lost_puppy',       label: l10n.goalVetLostPuppy,           emoji: '🐶'),
//       (id: 'shy_unicorn',      label: l10n.goalVetShyUnicorn,          emoji: '🦄'),
//       (id: 'sleeping_bear',    label: l10n.goalVetSleepingBear,        emoji: '🐻'),
//     ],
//   ),

//   // ── INVENTOR ──────────────────────────────────────────────────────────────
//   'inventor': _ThemeContext(
//     locations: [
//       (id: 'sky_workshop',         label: l10n.locInventorSkyWorkshop,        emoji: '⚙️'),
//       (id: 'underground_factory',  label: l10n.locInventorUndergroundFactory, emoji: '🏭'),
//       (id: 'magic_library',        label: l10n.locInventorMagicLibrary,       emoji: '📚'),
//       (id: 'crystal_mountain',     label: l10n.locInventorCrystalMountain,    emoji: '💎'),
//       (id: 'future_museum',        label: l10n.locInventorFutureMuseum,       emoji: '🏛️'),
//       (id: 'cloud_workshop',       label: l10n.locInventorCloudWorkshop,      emoji: '☁️'),
//       (id: 'robot_city',           label: l10n.locInventorRobotCity,          emoji: '🤖'),
//       (id: 'volcano_forge',        label: l10n.locInventorVolcanoForge,       emoji: '🌋'),
//       (id: 'tinker_market',        label: l10n.locInventorTinkerMarket,       emoji: '🔧'),
//       (id: 'gear_garden',          label: l10n.locInventorGearGarden,         emoji: '⚙️'),
//       (id: 'lightning_lab',        label: l10n.locInventorLightningLab,       emoji: '⚡'),
//       (id: 'paper_workshop',       label: l10n.locInventorPaperWorkshop,      emoji: '📄'),
//     ],
//     goals: [
//       (id: 'magical_machine',  label: l10n.goalInventorBuildMachine,    emoji: '⚙️'),
//       (id: 'fix_broken_city',  label: l10n.goalInventorFixCity,         emoji: '🏙️'),
//       (id: 'rainbow_bridge_i', label: l10n.goalInventorRainbowBridge,   emoji: '🌈'),
//       (id: 'impossible_puzzle',label: l10n.goalInventorSolvePuzzle,     emoji: '🧩'),
//       (id: 'power_lighthouse', label: l10n.goalInventorPowerLighthouse, emoji: '🏮'),
//       (id: 'dream_toy',        label: l10n.goalInventorDreamToy,        emoji: '🪁'),
//       (id: 'flying_ship',      label: l10n.goalInventorFlyingShip,      emoji: '✈️'),
//       (id: 'robot_friend',     label: l10n.goalInventorWakeRobot,       emoji: '🤖'),
//       (id: 'first_invention',  label: l10n.goalInventorFirstInvention,  emoji: '💡'),
//       (id: 'fix_clock_tower',  label: l10n.goalInventorFixClockTower,   emoji: '🕰️'),
//       (id: 'paper_creature',   label: l10n.goalInventorPaperCreature,   emoji: '📄'),
//       (id: 'kite_storm',       label: l10n.goalInventorKiteStorm,       emoji: '🪁'),
//     ],
//   ),

//   // ── PALEONTOLOGIST ────────────────────────────────────────────────────────
//   'paleontologist': _ThemeContext(
//     locations: [
//       (id: 'dino_valley',        label: l10n.locDinoHunterDinoValley,        emoji: '🦕'),
//       (id: 'ancient_desert',     label: l10n.locDinoHunterAncientDesert,     emoji: '🏜️'),
//       (id: 'underground_cave',   label: l10n.locDinoHunterUndergroundCave,   emoji: '🕳️'),
//       (id: 'time_portal',        label: l10n.locDinoHunterTimePortal,        emoji: '⏳'),
//       (id: 'fossil_beach',       label: l10n.locDinoHunterFossilBeach,       emoji: '🐚'),
//       (id: 'prehistoric_forest', label: l10n.locDinoHunterPrehistoricForest, emoji: '🌿'),
//       (id: 'amber_jungle',       label: l10n.locDinoHunterAmberJungle,       emoji: '🌳'),
//       (id: 'volcanic_badlands',  label: l10n.locDinoHunterVolcanicBadlands,  emoji: '🌋'),
//       (id: 'tar_pit',            label: l10n.locDinoHunterTarPit,            emoji: '🕳️'),
//       (id: 'frozen_tundra',      label: l10n.locDinoHunterFrozenTundra,      emoji: '🧊'),
//       (id: 'museum_archive',     label: l10n.locDinoHunterMuseumArchive,     emoji: '🏛️'),
//       (id: 'shallow_lagoon',     label: l10n.locDinoHunterShallowLagoon,     emoji: '🌊'),
//     ],
//     goals: [
//       (id: 'hidden_fossil',    label: l10n.goalDinoHunterHiddenFossil,   emoji: '🦴'),
//       (id: 'baby_dino',        label: l10n.goalDinoHunterBabyDino,       emoji: '🦖'),
//       (id: 'ancient_mystery',  label: l10n.goalDinoHunterSolveMystery,   emoji: '🔍'),
//       (id: 'save_dino_eggs',   label: l10n.goalDinoHunterSaveDinoEggs,   emoji: '🥚'),
//       (id: 'ancient_language', label: l10n.goalDinoHunterDecodeLanguage, emoji: '📜'),
//       (id: 'time_rescue',      label: l10n.goalDinoHunterRescueTraveler, emoji: '⏰'),
//       (id: 'meteor_discovery', label: l10n.goalDinoHunterMeteorCrater,   emoji: '☄️'),
//       (id: 'dino_stampede',    label: l10n.goalDinoHunterStopStampede,   emoji: '🦏'),
//       (id: 'first_fossil',     label: l10n.goalDinoHunterFirstFossil,    emoji: '✨'),
//       (id: 'mammoth_friend',   label: l10n.goalDinoHunterMammothFriend,  emoji: '🦣'),
//       (id: 'sky_pterodactyl',  label: l10n.goalDinoHunterPterodactyl,    emoji: '🦅'),
//       (id: 'lost_skeleton',    label: l10n.goalDinoHunterLostSkeleton,   emoji: '🦴'),
//     ],
//   ),

//   // ── FIREFIGHTER ───────────────────────────────────────────────────────────
//   'firefighter': _ThemeContext(
//     locations: [
//       (id: 'burning_forest',   label: l10n.locFirefighterBurningForest,  emoji: '🔥'),
//       (id: 'magic_city',       label: l10n.locFirefighterMagicCity,      emoji: '🏙️'),
//       (id: 'volcano_island_f', label: l10n.locFirefighterVolcanoIsland,  emoji: '🌋'),
//       (id: 'crystal_tower',    label: l10n.locFirefighterCrystalTower,   emoji: '🗼'),
//       (id: 'cloud_town',       label: l10n.locFirefighterCloudTown,      emoji: '☁️'),
//       (id: 'ancient_ruins_f',  label: l10n.locFirefighterAncientRuins,   emoji: '🏛️'),
//       (id: 'haunted_mansion',  label: l10n.locFirefighterHauntedMansion, emoji: '🏚️'),
//       (id: 'ice_palace',       label: l10n.locFirefighterIcePalace,      emoji: '❄️'),
//       (id: 'rooftop_district', label: l10n.locFirefighterRooftopDistrict,emoji: '🏗️'),
//       (id: 'tunnel_network',   label: l10n.locFirefighterTunnelNetwork,  emoji: '🚇'),
//       (id: 'circus_tent',      label: l10n.locFirefighterCircusTent,     emoji: '🎪'),
//       (id: 'lighthouse_cliff', label: l10n.locFirefighterLighthouse,     emoji: '🏮'),
//     ],
//     goals: [
//       (id: 'stop_fire',        label: l10n.goalFirefighterStopFire,        emoji: '🌲'),
//       (id: 'rescue_family',    label: l10n.goalFirefighterRescueFamily,    emoji: '👨‍👩‍👦'),
//       (id: 'put_out_volcano',  label: l10n.goalFirefighterPutOutVolcano,   emoji: '🌋'),
//       (id: 'save_library',     label: l10n.goalFirefighterSaveLibrary,     emoji: '📚'),
//       (id: 'animals_escape',   label: l10n.goalFirefighterAnimalsEscape,   emoji: '🐾'),
//       (id: 'protect_cloud',    label: l10n.goalFirefighterProtectCloud,    emoji: '☁️'),
//       (id: 'magic_hose',       label: l10n.goalFirefighterMagicHose,       emoji: '💦'),
//       (id: 'ice_dragon_fire',  label: l10n.goalFirefighterFreezeDragon,    emoji: '🐉'),
//       (id: 'first_call',       label: l10n.goalFirefighterFirstCall,       emoji: '🚒'),
//       (id: 'rescue_kitten',    label: l10n.goalFirefighterRescueKitten,    emoji: '🐱'),
//       (id: 'calm_circus',      label: l10n.goalFirefighterCalmCircus,      emoji: '🎪'),
//       (id: 'storm_lighthouse', label: l10n.goalFirefighterStormLighthouse, emoji: '🏮'),
//     ],
//   ),

//   // ── ROBOT PILOT ───────────────────────────────────────────────────────────
//   'robot_pilot': _ThemeContext(
//     locations: [
//       (id: 'robot_space',      label: l10n.locRobotPilotSpaceStation,  emoji: '🛸'),
//       (id: 'robot_factory',    label: l10n.locRobotPilotRobotFactory,  emoji: '🏭'),
//       (id: 'future_city_r',    label: l10n.locRobotPilotFutureCity,    emoji: '🏙️'),
//       (id: 'cloud_highway',    label: l10n.locRobotPilotCloudHighway,  emoji: '☁️'),
//       (id: 'digital_world',    label: l10n.locRobotPilotDigitalWorld,  emoji: '💻'),
//       (id: 'crystal_nebula',   label: l10n.locRobotPilotCrystalNebula, emoji: '🌌'),
//       (id: 'giant_hangar',     label: l10n.locRobotPilotGiantHangar,   emoji: '🏗️'),
//       (id: 'ion_storm_zone',   label: l10n.locRobotPilotIonStorm,      emoji: '⚡'),
//       (id: 'scrap_yard',       label: l10n.locRobotPilotScrapYard,     emoji: '🔩'),
//       (id: 'quantum_arena',    label: l10n.locRobotPilotQuantumArena,  emoji: '⚛️'),
//       (id: 'data_canyon',      label: l10n.locRobotPilotDataCanyon,    emoji: '📊'),
//       (id: 'orbital_garden',   label: l10n.locRobotPilotOrbitalGarden, emoji: '🌱'),
//     ],
//     goals: [
//       (id: 'repair_satellite', label: l10n.goalRobotPilotRepairSatellite, emoji: '🛰️'),
//       (id: 'asteroid_navigate',label: l10n.goalRobotPilotNavigateAsteroid,emoji: '☄️'),
//       (id: 'lost_robot',       label: l10n.goalRobotPilotRescueRobot,     emoji: '🤖'),
//       (id: 'flying_race',      label: l10n.goalRobotPilotWinRace,         emoji: '🏆'),
//       (id: 'alien_signal',     label: l10n.goalRobotPilotDecodeSignal,    emoji: '📡'),
//       (id: 'prevent_crash',    label: l10n.goalRobotPilotPreventCrash,    emoji: '💥'),
//       (id: 'power_core',       label: l10n.goalRobotPilotRestorePower,    emoji: '⚡'),
//       (id: 'robot_uprising',   label: l10n.goalRobotPilotCalmRobots,      emoji: '🦾'),
//       (id: 'first_flight',     label: l10n.goalRobotPilotFirstFlight,     emoji: '✨'),
//       (id: 'rebuild_friend',   label: l10n.goalRobotPilotRebuildFriend,   emoji: '🔧'),
//       (id: 'data_mystery',     label: l10n.goalRobotPilotDataMystery,     emoji: '🔍'),
//       (id: 'tend_garden',      label: l10n.goalRobotPilotTendGarden,      emoji: '🌱'),
//     ],
//   ),
// };

// _ThemeContext _buildDefaultContext(AppLocalizations l10n) => _ThemeContext(
//   locations: [
//     (id: 'magic_forest',  label: l10n.locDefaultMagicForest,   emoji: '🌲'),
//     (id: 'cloud_kingdom', label: l10n.locDefaultCloudKingdom,  emoji: '☁️'),
//     (id: 'ocean',         label: l10n.locDefaultDeepOcean,     emoji: '🌊'),
//     (id: 'castle',        label: l10n.locDefaultMagicCastle,   emoji: '🏰'),
//     (id: 'volcano',       label: l10n.locDefaultVolcanoIsland, emoji: '🌋'),
//     (id: 'space',         label: l10n.locDefaultOuterSpace,    emoji: '🌌'),
//   ],
//   goals: [
//     (id: 'find_treasure',  label: l10n.goalDefaultFindTreasure,    emoji: '💎'),
//     (id: 'rescue_friend',  label: l10n.goalDefaultRescueFriend,    emoji: '🤝'),
//     (id: 'defeat_monster', label: l10n.goalDefaultBefriendMonster, emoji: '👾'),
//     (id: 'solve_mystery',  label: l10n.goalDefaultSolveMystery,    emoji: '🔍'),
//     (id: 'save_planet',    label: l10n.goalDefaultSaveLand,        emoji: '🌍'),
//     (id: 'win_race',       label: l10n.goalDefaultWinRace,         emoji: '🏆'),
//   ],
// );

// _ThemeContext _ctxFor(String theme, Map<String, _ThemeContext> contexts, AppLocalizations l10n) =>
//     contexts[theme] ?? _buildDefaultContext(l10n);

// List<String> _buildTeachingTopics(AppLocalizations l10n) => [
//   l10n.teachingBravery,
//   l10n.teachingKindness,
//   l10n.teachingSharing,
//   l10n.teachingHonesty,
//   l10n.teachingPatience,
//   l10n.teachingFriendship,
//   l10n.teachingPerseverance,
//   l10n.teachingCreativity,
// ];

// // ── Screen ────────────────────────────────────────────────────────────────────

// class AdventureSetupScreen extends ConsumerStatefulWidget {
//   const AdventureSetupScreen({super.key, required this.heroId});
//   final String heroId;

//   @override
//   ConsumerState<AdventureSetupScreen> createState() => _AdventureSetupScreenState();
// }

// class _AdventureSetupScreenState extends ConsumerState<AdventureSetupScreen> {
//   int _step = 0;

//   String _theme    = _kThemeIds.first.id;
//   String _location = _kThemeFirstIds[_kThemeIds.first.id]!.$1;
//   String _goal     = _kThemeFirstIds[_kThemeIds.first.id]!.$2;

//   BuddyType? _selectedCompanionType;
//   String? _buddyPhotoStoragePath;
//   String? _buddyCompanionName;

//   int _debugImageCount = 0;

//   final _teachingController = TextEditingController();

//   @override
//   void dispose() {
//     _teachingController.dispose();
//     super.dispose();
//   }

//   void _selectTheme(String id) {
//     final firstIds = _kThemeFirstIds[id];
//     setState(() {
//       _theme    = id;
//       _location = firstIds?.$1 ?? 'magic_forest';
//       _goal     = firstIds?.$2 ?? 'find_treasure';
//       _step     = 1;
//     });
//   }

//   void _selectCompanion({BuddyType? type, String? photoStoragePath, String? displayName}) {
//     setState(() {
//       _selectedCompanionType = type;
//       _buddyPhotoStoragePath = photoStoragePath;
//       _buddyCompanionName    = displayName;
//       _step = 2;
//     });
//   }

//   void _selectLocation(String id) {
//     setState(() {
//       _location = id;
//       _step = 3;
//     });
//   }

//   void _selectGoal(String id) {
//     setState(() {
//       _goal = id;
//       _step = 4;
//     });
//   }

//   void _back() {
//     if (_step > 0) setState(() => _step--);
//   }

//   void _startGeneration(AppLocalizations l10n) {
//     final contexts = _buildThemeContexts(l10n);
//     final themes   = _buildThemes(l10n);
//     final ctx      = _ctxFor(_theme, contexts, l10n);

//     final theme    = themes.firstWhere((t) => t.id == _theme);
//     final location = ctx.locations.firstWhere((l) => l.id == _location);
//     final goal     = ctx.goals.firstWhere((g) => g.id == _goal);

//     String? buddyStoragePath = _buddyPhotoStoragePath;
//     String? buddyDisplayName = _buddyCompanionName;
//     if (_selectedCompanionType != null) {
//       final buddies = ref.read(buddyListProvider).valueOrNull ?? [];
//       final buddy = buddies.where((b) => b.type == _selectedCompanionType).firstOrNull;
//       buddyStoragePath = buddy?.photoStoragePath;
//       buddyDisplayName = buddy?.displayName ?? _selectedCompanionType!.localizedLabel(l10n);
//     }

//     final debugMode = ref.read(debugModeProvider);

//     context.push('/story/generating', extra: {
//       'heroId': widget.heroId,
//       'setup': {
//         'theme':                 theme.label,
//         'themeId':               _theme, // NEW: pass id so backend can detect cosy_home
//         'companion':             _selectedCompanionType?.id,
//         'companionName':         buddyDisplayName,
//         'location':              location.label,
//         'goal':                  goal.label,
//         'teachingMoment':        _teachingController.text.trim().isEmpty
//                                      ? null
//                                      : _teachingController.text.trim(),
//         'buddyPhotoStoragePath': buddyStoragePath,
//       },
//       if (debugMode) 'debugMode': true,
//       if (debugMode) 'debugImageCount': _debugImageCount,
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final l10n     = AppLocalizations.of(context)!;
//     final contexts = _buildThemeContexts(l10n);
//     final themes   = _buildThemes(l10n);
//     final ctx      = _ctxFor(_theme, contexts, l10n);
//     final topics   = _buildTeachingTopics(l10n);

//     final steps = [
//       _StepSpec(question: l10n.adventureStep1Question, hint: l10n.adventureStepHint1),
//       _StepSpec(question: l10n.adventureStep2Question, hint: l10n.adventureStepHint2),
//       _StepSpec(question: l10n.adventureStep3Question, hint: l10n.adventureStepHint3),
//       _StepSpec(question: l10n.adventureStep4Question, hint: l10n.adventureStepHint4),
//       _StepSpec(question: l10n.adventureStep5Question, hint: l10n.adventureStepHintOptional),
//     ];

//     return Scaffold(
//       backgroundColor: AppColors.bgBase,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // ── Header ────────────────────────────────────────────────────
//             Padding(
//               padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
//               child: Row(
//                 children: [
//                   IconButton(
//                     icon: Icon(
//                       _step == 0 ? Icons.close : Icons.arrow_back,
//                       color: AppColors.textSecondary,
//                     ),
//                     onPressed: _step == 0
//                         ? () => context.pop()
//                         : _back,
//                   ),
//                   Expanded(
//                     child: Text(
//                       steps[_step].hint,
//                       textAlign: TextAlign.center,
//                       style: AppTextStyles.eyebrowSm(color: AppColors.textTertiary),
//                     ),
//                   ),
//                   const SizedBox(width: 48),
//                 ],
//               ),
//             ),

//             // ── Progress bar ──────────────────────────────────────────────
//             Padding(
//               padding: const EdgeInsets.fromLTRB(24, 10, 24, 0),
//               child: _StepProgressBar(current: _step, total: 5),
//             ),

//             // ── Question ──────────────────────────────────────────────────
//             Padding(
//               padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
//               child: Text(
//                 steps[_step].question,
//                 style: AppTextStyles.displayLg(color: AppColors.textPrimary),
//               ),
//             ),

//             // ── Content ───────────────────────────────────────────────────
//             Expanded(
//               child: AnimatedSwitcher(
//                 duration: const Duration(milliseconds: 250),
//                 child: KeyedSubtree(
//                   key: ValueKey(_step),
//                   child: [
//                     // Step 0: Theme
//                     _TileGrid(
//                       items: themes,
//                       selected: _theme,
//                       onSelect: _selectTheme,
//                     ),
//                     // Step 1: Companion picker
//                     _CompanionPickerStep(
//                       selectedType: _selectedCompanionType,
//                       onSelect: _selectCompanion,
//                     ),
//                     // Step 2: Location
//                     _TileGrid(
//                       items: ctx.locations,
//                       selected: _location,
//                       onSelect: _selectLocation,
//                     ),
//                     // Step 3: Goal
//                     _TileGrid(
//                       items: ctx.goals,
//                       selected: _goal,
//                       onSelect: _selectGoal,
//                     ),
//                     // Step 4: Teaching moment + optional debug image count
//                     _TeachingStep(
//                       controller: _teachingController,
//                       topics: topics,
//                       headerLabel: l10n.adventureTeachingMomentHeader,
//                       helpLabel: l10n.adventureTeachingMomentHelp,
//                       placeholderLabel: l10n.adventureTeachingMomentPlaceholder,
//                       debugImageCount: ref.watch(debugModeProvider) ? _debugImageCount : null,
//                       onDebugImageCountChanged: (v) => setState(() => _debugImageCount = v),
//                     ),
//                   ][_step],
//                 ),
//               ),
//             ),

//             // ── CTA (only on last step) ───────────────────────────────────
//             if (_step == 4)
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
//                 child: FilledButton(
//                   onPressed: () => _startGeneration(l10n),
//                   child: Text(l10n.adventureCreateStoryButton),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ── Companion picker step ─────────────────────────────────────────────────────

// class _CompanionPickerStep extends ConsumerWidget {
//   const _CompanionPickerStep({
//     required this.selectedType,
//     required this.onSelect,
//   });

//   final BuddyType? selectedType;
//   final void Function({BuddyType? type, String? photoStoragePath, String? displayName}) onSelect;

//   void _openEditSheet(BuildContext context, BuddyType type, Buddy? existing) {
//     showModalBottomSheet<void>(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: AppColors.bgBase,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       builder: (_) => _EditBuddySheet(
//         type: type,
//         existing: existing,
//         onContinue: () => onSelect(
//           type: type,
//           photoStoragePath: null,
//           displayName: null,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final l10n = AppLocalizations.of(context)!;
//     final buddyMap = ref.watch(buddyListProvider).when(
//       data: (list) => {for (final b in list) b.type: b},
//       loading: () => <BuddyType, Buddy>{},
//       error: (_, __) => <BuddyType, Buddy>{},
//     );

//     const allTypes = BuddyType.values;

//     return GridView.builder(
//       padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3,
//         childAspectRatio: 0.9,
//         crossAxisSpacing: 10,
//         mainAxisSpacing: 10,
//       ),
//       itemCount: allTypes.length + 1, // +1 for Solo Hero
//       itemBuilder: (ctx, i) {
//         if (i == 0) {
//           return _BuddyTileShell(
//             selected: selectedType == null,
//             onTap: () => onSelect(type: null, photoStoragePath: null, displayName: null),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text('🌟', style: TextStyle(fontSize: 32)),
//                 const SizedBox(height: 6),
//                 Text(
//                   l10n.adventureSoloHero,
//                   style: AppTextStyles.bodySm(
//                     color: selectedType == null ? AppColors.gold500 : AppColors.textSecondary,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ],
//             ),
//           );
//         }
//         final type = allTypes[i - 1];
//         final buddy = buddyMap[type];
//         return _CompanionTypeTile(
//           type: type,
//           buddy: buddy,
//           selected: selectedType == type,
//           onTap: () => _openEditSheet(ctx, type, buddy),
//         );
//       },
//     );
//   }
// }

// class _CompanionTypeTile extends StatelessWidget {
//   const _CompanionTypeTile({
//     required this.type,
//     required this.buddy,
//     required this.selected,
//     required this.onTap,
//   });

//   final BuddyType type;
//   final Buddy? buddy;
//   final bool selected;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     final l10n = AppLocalizations.of(context)!;
//     final photoUrl = buddy?.photoThumbUrl ?? buddy?.photoUrl;
//     return _BuddyTileShell(
//       selected: selected,
//       onTap: onTap,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           if (photoUrl != null && photoUrl.isNotEmpty)
//             ClipOval(
//               child: CachedNetworkImage(
//                 imageUrl: photoUrl,
//                 width: 48,
//                 height: 48,
//                 fit: BoxFit.cover,
//                 errorWidget: (_, __, ___) =>
//                     Text(type.emoji, style: const TextStyle(fontSize: 30)),
//               ),
//             )
//           else
//             Text(type.emoji, style: const TextStyle(fontSize: 30)),
//           const SizedBox(height: 4),
//           Text(
//             buddy?.displayName ?? type.localizedLabel(l10n),
//             style: AppTextStyles.bodySm(
//               color: selected ? AppColors.gold500 : AppColors.textSecondary,
//             ),
//             textAlign: TextAlign.center,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _BuddyTileShell extends StatelessWidget {
//   const _BuddyTileShell({
//     required this.selected,
//     required this.onTap,
//     required this.child,
//   });
//   final bool selected;
//   final VoidCallback onTap;
//   final Widget child;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Stack(
//         fit: StackFit.expand,
//         children: [
//           AnimatedContainer(
//             duration: const Duration(milliseconds: 200),
//             decoration: BoxDecoration(
//               color: selected ? const Color(0x26FFB84D) : AppColors.bgCard,
//               borderRadius: BorderRadius.circular(18),
//               border: Border.all(
//                 color: selected ? AppColors.gold500 : AppColors.borderSubtle,
//                 width: selected ? 1.5 : 1.0,
//               ),
//               boxShadow: selected
//                   ? [BoxShadow(color: AppColors.gold500.withAlpha(50), blurRadius: 12)]
//                   : null,
//             ),
//             child: child,
//           ),
//           if (selected)
//             Positioned(
//               top: 6,
//               right: 6,
//               child: Container(
//                 width: 18,
//                 height: 18,
//                 decoration: const BoxDecoration(
//                   color: AppColors.gold500,
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(Icons.check, size: 12, color: AppColors.bgBase),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// // ── Edit-buddy bottom sheet (UNCHANGED from previous version) ───────────────

// class _EditBuddySheet extends ConsumerStatefulWidget {
//   const _EditBuddySheet({required this.type, this.existing, this.onContinue});
//   final BuddyType type;
//   final Buddy? existing;
//   final VoidCallback? onContinue;

//   @override
//   ConsumerState<_EditBuddySheet> createState() => _EditBuddySheetState();
// }

// class _EditBuddySheetState extends ConsumerState<_EditBuddySheet> {
//   File? _photo;
//   late final TextEditingController _nameController;
//   bool _saving = false;

//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController(text: widget.existing?.name ?? '');
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     super.dispose();
//   }

//   Future<void> _pickPhoto(ImageSource source) async {
//     final xFile = await ImagePicker().pickImage(
//       source: source,
//       imageQuality: 80,
//       maxWidth: 1024,
//     );
//     if (xFile != null && mounted) setState(() => _photo = File(xFile.path));
//   }

//   Future<void> _save({bool advance = false}) async {
//     if (_saving) return;
//     setState(() => _saving = true);
//     try {
//       await ref.read(buddyRepositoryProvider).upsertBuddy(
//         type: widget.type,
//         name: _nameController.text.trim().isEmpty ? null : _nameController.text.trim(),
//         photo: _photo,
//       );
//       if (mounted) {
//         if (advance) widget.onContinue?.call();
//         Navigator.of(context).pop();
//       }
//     } catch (_) {
//       if (mounted) {
//         setState(() => _saving = false);
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Failed to save. Please try again.')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final l10n = AppLocalizations.of(context)!;
//     final existingPhotoUrl = widget.existing?.photoUrl;
//     final hasPhoto = _photo != null || (existingPhotoUrl != null && existingPhotoUrl.isNotEmpty);

//     return Padding(
//       padding: EdgeInsets.only(
//         left: 24,
//         right: 24,
//         top: 24,
//         bottom: MediaQuery.of(context).viewInsets.bottom + 32,
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 40,
//             height: 4,
//             decoration: BoxDecoration(
//               color: AppColors.borderDefault,
//               borderRadius: BorderRadius.circular(2),
//             ),
//           ),
//           const SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(widget.type.emoji, style: const TextStyle(fontSize: 24)),
//               const SizedBox(width: 8),
//               Text(widget.type.localizedLabel(l10n),
//                   style: AppTextStyles.displaySm(color: AppColors.textPrimary)),
//             ],
//           ),
//           const SizedBox(height: 24),

//           GestureDetector(
//             onTap: _showSourceDialog,
//             child: Container(
//               width: 88,
//               height: 88,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: AppColors.bgElevated,
//                 border: Border.all(
//                   color: hasPhoto ? AppColors.gold500 : AppColors.borderDefault,
//                   width: 2,
//                 ),
//               ),
//               child: _photo != null
//                   ? ClipOval(child: Image.file(_photo!, fit: BoxFit.cover, width: 88, height: 88))
//                   : existingPhotoUrl != null && existingPhotoUrl.isNotEmpty
//                       ? ClipOval(
//                           child: CachedNetworkImage(
//                             imageUrl: existingPhotoUrl,
//                             width: 88,
//                             height: 88,
//                             fit: BoxFit.cover,
//                           ),
//                         )
//                       : const Icon(Icons.add_a_photo, color: AppColors.textTertiary, size: 32),
//             ),
//           ),
//           const SizedBox(height: 6),
//           Text('Optional photo', style: AppTextStyles.bodySm(color: AppColors.textTertiary)),
//           const SizedBox(height: 20),

//           TextField(
//             controller: _nameController,
//             style: AppTextStyles.bodyMd(color: AppColors.textPrimary),
//             textCapitalization: TextCapitalization.words,
//             decoration: InputDecoration(
//               hintText: 'Name (optional, e.g. Rex, Bence…)',
//               hintStyle: AppTextStyles.bodyMd(color: AppColors.textFaint),
//             ),
//           ),
//           const SizedBox(height: 28),

//           Row(
//             children: [
//               Expanded(
//                 child: OutlinedButton(
//                   onPressed: _saving ? null : () => _save(),
//                   child: const Text('Save'),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: FilledButton(
//                   onPressed: _saving ? null : () => _save(advance: true),
//                   child: _saving
//                       ? const SizedBox(
//                           width: 20,
//                           height: 20,
//                           child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
//                         )
//                       : const Text('Continue'),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   void _showSourceDialog() {
//     showModalBottomSheet<void>(
//       context: context,
//       backgroundColor: AppColors.bgBase,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (ctx) => SafeArea(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               leading: const Icon(Icons.camera_alt, color: AppColors.textSecondary),
//               title: Text('Take photo', style: AppTextStyles.bodyMd(color: AppColors.textPrimary)),
//               onTap: () { Navigator.pop(ctx); _pickPhoto(ImageSource.camera); },
//             ),
//             ListTile(
//               leading: const Icon(Icons.photo_library, color: AppColors.textSecondary),
//               title: Text('Choose from library', style: AppTextStyles.bodyMd(color: AppColors.textPrimary)),
//               onTap: () { Navigator.pop(ctx); _pickPhoto(ImageSource.gallery); },
//             ),
//             const SizedBox(height: 8),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ── Tile grid ─────────────────────────────────────────────────────────────────

// class _TileGrid extends StatelessWidget {
//   const _TileGrid({
//     required this.items,
//     required this.selected,
//     required this.onSelect,
//   });

//   final List<_Option> items;
//   final String selected;
//   final ValueChanged<String> onSelect;

//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//       padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3,
//         childAspectRatio: 1.0,
//         crossAxisSpacing: 10,
//         mainAxisSpacing: 10,
//       ),
//       itemCount: items.length,
//       itemBuilder: (ctx, i) => _AdventureTile(
//         option: items[i],
//         selected: selected == items[i].id,
//         onTap: () => onSelect(items[i].id),
//       ),
//     );
//   }
// }

// class _AdventureTile extends StatelessWidget {
//   const _AdventureTile({
//     required this.option,
//     required this.selected,
//     required this.onTap,
//   });

//   final _Option option;
//   final bool selected;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Stack(
//         fit: StackFit.expand,
//         children: [
//           AnimatedContainer(
//             duration: const Duration(milliseconds: 200),
//             decoration: BoxDecoration(
//               color: selected ? const Color(0x26FFB84D) : AppColors.bgCard,
//               borderRadius: BorderRadius.circular(18),
//               border: Border.all(
//                 color: selected ? AppColors.gold500 : AppColors.borderSubtle,
//                 width: selected ? 1.5 : 1.0,
//               ),
//               boxShadow: selected
//                   ? [BoxShadow(color: AppColors.gold500.withAlpha(50), blurRadius: 12)]
//                   : null,
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(option.emoji, style: const TextStyle(fontSize: 32)),
//                 const SizedBox(height: 6),
//                 Text(
//                   option.label,
//                   style: AppTextStyles.bodySm(
//                     color: selected ? AppColors.gold500 : AppColors.textSecondary,
//                   ),
//                   textAlign: TextAlign.center,
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ],
//             ),
//           ),
//           if (selected)
//             Positioned(
//               top: 6,
//               right: 6,
//               child: Container(
//                 width: 18,
//                 height: 18,
//                 decoration: const BoxDecoration(
//                   color: AppColors.gold500,
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(Icons.check, size: 12, color: AppColors.bgBase),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// // ── Teaching moment step (UNCHANGED) ─────────────────────────────────────────

// class _TeachingStep extends StatefulWidget {
//   const _TeachingStep({
//     required this.controller,
//     required this.topics,
//     required this.headerLabel,
//     required this.helpLabel,
//     required this.placeholderLabel,
//     this.debugImageCount,
//     this.onDebugImageCountChanged,
//   });
//   final TextEditingController controller;
//   final List<String> topics;
//   final String headerLabel;
//   final String helpLabel;
//   final String placeholderLabel;
//   final int? debugImageCount;
//   final ValueChanged<int>? onDebugImageCountChanged;

//   @override
//   State<_TeachingStep> createState() => _TeachingStepState();
// }

// class _TeachingStepState extends State<_TeachingStep> {
//   String? _selectedTopic;

//   @override
//   void initState() {
//     super.initState();
//     widget.controller.addListener(_onControllerChanged);
//   }

//   @override
//   void dispose() {
//     widget.controller.removeListener(_onControllerChanged);
//     super.dispose();
//   }

//   void _onControllerChanged() {
//     final text = widget.controller.text;
//     final match = widget.topics.contains(text) ? text : null;
//     if (match != _selectedTopic) setState(() => _selectedTopic = match);
//   }

//   void _selectTopic(String topic) {
//     widget.controller.text = topic;
//     setState(() => _selectedTopic = topic);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             widget.headerLabel,
//             style: AppTextStyles.displaySm(color: AppColors.textSecondary),
//           ),
//           const SizedBox(height: 6),
//           Text(
//             widget.helpLabel,
//             style: AppTextStyles.bodyMd(color: AppColors.textTertiary),
//           ),
//           const SizedBox(height: 24),
//           Wrap(
//             spacing: 8,
//             runSpacing: 8,
//             children: widget.topics.map((topic) => _TeachingChip(
//               label: topic,
//               selected: _selectedTopic == topic,
//               onTap: () => _selectTopic(topic),
//             )).toList(),
//           ),
//           const SizedBox(height: 20),
//           TextField(
//             controller: widget.controller,
//             style: AppTextStyles.bodyMd(color: AppColors.textPrimary),
//             decoration: InputDecoration(
//               hintText: widget.placeholderLabel,
//               hintStyle: AppTextStyles.bodyMd(color: AppColors.textFaint),
//             ),
//             textCapitalization: TextCapitalization.sentences,
//           ),
//           if (widget.debugImageCount != null) ...[
//             const SizedBox(height: 28),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               decoration: BoxDecoration(
//                 color: AppColors.bgCard,
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: AppColors.gold500.withAlpha(80)),
//               ),
//               child: Row(
//                 children: [
//                   const Text('🛠', style: TextStyle(fontSize: 16)),
//                   const SizedBox(width: 10),
//                   Text(
//                     'Images to generate:',
//                     style: AppTextStyles.bodyMd(color: AppColors.textSecondary),
//                   ),
//                   const Spacer(),
//                   _CountStepper(
//                     value: widget.debugImageCount!,
//                     min: 0,
//                     max: 8,
//                     onChanged: widget.onDebugImageCountChanged,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }

// class _CountStepper extends StatelessWidget {
//   const _CountStepper({
//     required this.value,
//     required this.min,
//     required this.max,
//     required this.onChanged,
//   });
//   final int value;
//   final int min;
//   final int max;
//   final ValueChanged<int>? onChanged;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         _StepBtn(
//           icon: Icons.remove,
//           onTap: value > min ? () => onChanged?.call(value - 1) : null,
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 14),
//           child: Text(
//             value == 0 ? 'none' : '$value',
//             style: AppTextStyles.bodyMd(color: AppColors.gold500),
//           ),
//         ),
//         _StepBtn(
//           icon: Icons.add,
//           onTap: value < max ? () => onChanged?.call(value + 1) : null,
//         ),
//       ],
//     );
//   }
// }

// class _StepBtn extends StatelessWidget {
//   const _StepBtn({required this.icon, required this.onTap});
//   final IconData icon;
//   final VoidCallback? onTap;

//   @override
//   Widget build(BuildContext context) {
//     final enabled = onTap != null;
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 30,
//         height: 30,
//         decoration: BoxDecoration(
//           color: enabled ? AppColors.bgElevated : AppColors.bgCard,
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(color: AppColors.borderSubtle),
//         ),
//         child: Icon(
//           icon,
//           size: 16,
//           color: enabled ? AppColors.textSecondary : AppColors.textFaint,
//         ),
//       ),
//     );
//   }
// }

// class _TeachingChip extends StatelessWidget {
//   const _TeachingChip({required this.label, required this.selected, required this.onTap});
//   final String label;
//   final bool selected;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 150),
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
//         decoration: BoxDecoration(
//           color: selected ? const Color(0x26FFB84D) : AppColors.bgCard,
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//             color: selected ? AppColors.gold500 : AppColors.borderDefault,
//             width: selected ? 1.5 : 1.0,
//           ),
//         ),
//         child: Text(
//           label,
//           style: AppTextStyles.bodySm(
//             color: selected ? AppColors.textPrimary : AppColors.textSecondary,
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ── Step progress bar ─────────────────────────────────────────────────────────

// class _StepProgressBar extends StatelessWidget {
//   const _StepProgressBar({required this.current, required this.total});
//   final int current;
//   final int total;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: List.generate(total, (i) {
//         return Expanded(
//           child: Container(
//             height: 3,
//             margin: EdgeInsets.only(right: i < total - 1 ? 4 : 0),
//             decoration: BoxDecoration(
//               color: i <= current ? AppColors.gold500 : AppColors.borderSubtle,
//               borderRadius: BorderRadius.circular(2),
//             ),
//           ),
//         );
//       }),
//     );
//   }
// }

// // ── Step spec helper ──────────────────────────────────────────────────────────

// class _StepSpec {
//   final String question;
//   final String hint;
//   const _StepSpec({required this.question, required this.hint});
// }
