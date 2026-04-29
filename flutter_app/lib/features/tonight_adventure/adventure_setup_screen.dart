import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/providers/debug_settings_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/repositories/buddy_repository.dart';
import '../../domain/entities/buddy.dart';

// ── Data model ────────────────────────────────────────────────────────────────

typedef _Option = ({String id, String label, String emoji});

class _ThemeContext {
  final List<_Option> locations;
  final List<_Option> goals;
  const _ThemeContext({required this.locations, required this.goals});
}

// ── Themes ────────────────────────────────────────────────────────────────────

const List<_Option> _themes = [
  (id: 'astronaut',      label: 'Astronaut',      emoji: '🚀'),
  (id: 'pirate',         label: 'Pirate',          emoji: '🏴‍☠️'),
  (id: 'wizard',         label: 'Wizard',          emoji: '🧙'),
  (id: 'princess',       label: 'Princess',        emoji: '👑'),
  (id: 'knight',         label: 'Knight',          emoji: '⚔️'),
  (id: 'mermaid',        label: 'Mermaid',         emoji: '🧜'),
  (id: 'superhero',      label: 'Superhero',       emoji: '🦸'),
  (id: 'chef',           label: 'Chef',            emoji: '👨‍🍳'),
  (id: 'scientist',      label: 'Scientist',       emoji: '🔬'),
  (id: 'ninja',          label: 'Ninja',           emoji: '🥷'),
  (id: 'explorer',       label: 'Explorer',        emoji: '🧭'),
  (id: 'vet',            label: 'Vet',             emoji: '🐾'),
  (id: 'inventor',       label: 'Inventor',        emoji: '💡'),
  (id: 'paleontologist', label: 'Dino Hunter',     emoji: '🦕'),
  (id: 'firefighter',    label: 'Firefighter',     emoji: '🚒'),
  (id: 'robot_pilot',    label: 'Robot Pilot',     emoji: '🤖'),
];

// ── Contextual data: locations & goals per theme ──────────────────────────────

const Map<String, _ThemeContext> _themeContexts = {
  'astronaut': _ThemeContext(
    locations: [
      (id: 'space_station',  label: 'Space Station',  emoji: '🛸'),
      (id: 'planet_mars',    label: 'Planet Mars',    emoji: '🔴'),
      (id: 'moon',           label: 'The Moon',       emoji: '🌕'),
      (id: 'asteroid_belt',  label: 'Asteroid Belt',  emoji: '☄️'),
      (id: 'alien_planet',   label: 'Alien Planet',   emoji: '🌍'),
      (id: 'comet',          label: 'Comet Trail',    emoji: '💫'),
      (id: 'nebula',         label: 'Crystal Nebula', emoji: '🌌'),
      (id: 'black_hole',     label: 'Black Hole Edge',emoji: '🌀'),
    ],
    goals: [
      (id: 'fix_rocket',      label: 'Fix the rocket',        emoji: '🔧'),
      (id: 'new_planet',      label: 'Discover a new planet', emoji: '🔭'),
      (id: 'save_station',    label: 'Save the space station',emoji: '🛰️'),
      (id: 'alien_friends',   label: 'Befriend aliens',       emoji: '👽'),
      (id: 'find_lost_star',  label: 'Find a lost star',      emoji: '⭐'),
      (id: 'stop_meteor',     label: 'Stop a meteor',         emoji: '💥'),
      (id: 'lost_astronaut',  label: 'Rescue a lost crew',    emoji: '🚑'),
      (id: 'space_treasure',  label: 'Find the space crystal',emoji: '💎'),
    ],
  ),
  'pirate': _ThemeContext(
    locations: [
      (id: 'treasure_island', label: 'Treasure Island',   emoji: '🏝️'),
      (id: 'high_seas',       label: 'The High Seas',     emoji: '⛵'),
      (id: 'sunken_ship',     label: 'Sunken Galleon',    emoji: '🚢'),
      (id: 'sea_cave',        label: 'Secret Sea Cave',   emoji: '🦀'),
      (id: 'pirate_port',     label: 'Pirate Port',       emoji: '⚓'),
      (id: 'coral_reef',      label: 'Coral Reef',        emoji: '🪸'),
      (id: 'fog_island',      label: 'Island of Fog',     emoji: '🌫️'),
      (id: 'stormy_sea',      label: 'Stormy Sea',        emoji: '⛈️'),
    ],
    goals: [
      (id: 'buried_treasure', label: 'Find buried treasure',  emoji: '💰'),
      (id: 'free_whale',      label: 'Free a captured whale', emoji: '🐋'),
      (id: 'decode_map',      label: 'Decode the ancient map',emoji: '🗺️'),
      (id: 'sail_storm',      label: 'Sail through the storm',emoji: '⛵'),
      (id: 'save_lighthouse', label: 'Save the lighthouse',   emoji: '🏮'),
      (id: 'sunken_ship_goal',label: 'Find the sunken ship',  emoji: '🤿'),
      (id: 'beat_pirate',     label: 'Outsmart the rival pirate',emoji: '🏴‍☠️'),
      (id: 'magic_shell',     label: 'Find the magic shell',  emoji: '🐚'),
    ],
  ),
  'wizard': _ThemeContext(
    locations: [
      (id: 'magic_forest',    label: 'Magic Forest',     emoji: '🌲'),
      (id: 'wizard_castle',   label: 'Enchanted Castle', emoji: '🏰'),
      (id: 'crystal_cave',    label: 'Crystal Cave',     emoji: '💎'),
      (id: 'wizard_tower',    label: 'Wizard Tower',     emoji: '🗼'),
      (id: 'spell_library',   label: 'Spell Library',    emoji: '📚'),
      (id: 'dragon_mountain', label: 'Dragon Mountain',  emoji: '🐉'),
      (id: 'floating_islands',label: 'Floating Islands', emoji: '🏝️'),
      (id: 'mirror_realm',    label: 'Mirror Realm',     emoji: '🪞'),
    ],
    goals: [
      (id: 'break_spell',     label: 'Break the evil spell',     emoji: '🔮'),
      (id: 'brew_potion',     label: 'Brew the lost potion',     emoji: '🧪'),
      (id: 'stolen_wand',     label: 'Return the stolen wand',   emoji: '🪄'),
      (id: 'wild_spell',      label: 'Tame a wild spell',        emoji: '✨'),
      (id: 'forbidden_book',  label: 'Open the forbidden book',  emoji: '📖'),
      (id: 'save_forest',     label: 'Save the magic forest',    emoji: '🌳'),
      (id: 'tame_dragon',     label: 'Tame the fire dragon',     emoji: '🐲'),
      (id: 'find_apprentice', label: 'Find the lost apprentice', emoji: '🧑‍🎓'),
    ],
  ),
  'princess': _ThemeContext(
    locations: [
      (id: 'royal_palace',    label: 'Royal Palace',     emoji: '🏰'),
      (id: 'enchanted_garden',label: 'Enchanted Garden', emoji: '🌸'),
      (id: 'glass_lake',      label: 'Glass Lake',       emoji: '🏞️'),
      (id: 'fairy_village',   label: 'Fairy Village',    emoji: '🧚'),
      (id: 'cloud_kingdom',   label: 'Cloud Kingdom',    emoji: '☁️'),
      (id: 'magic_ballroom',  label: 'Magic Ballroom',   emoji: '💃'),
      (id: 'moonlit_forest',  label: 'Moonlit Forest',   emoji: '🌙'),
      (id: 'rainbow_bridge',  label: 'Rainbow Bridge',   emoji: '🌈'),
    ],
    goals: [
      (id: 'missing_crown',   label: 'Find the missing crown',        emoji: '👑'),
      (id: 'save_garden',     label: 'Save the enchanted garden',     emoji: '🌺'),
      (id: 'royal_ball',      label: 'Dance at the royal ball',       emoji: '💃'),
      (id: 'lonely_giant',    label: 'Befriend the lonely giant',     emoji: '🤝'),
      (id: 'castle_mystery',  label: 'Solve the castle mystery',      emoji: '🔍'),
      (id: 'sleeping_kingdom',label: 'Wake the sleeping kingdom',     emoji: '😴'),
      (id: 'rescue_unicorn',  label: 'Rescue the lost unicorn',       emoji: '🦄'),
      (id: 'magic_mirror',    label: 'Answer the magic mirror',       emoji: '🪞'),
    ],
  ),
  'knight': _ThemeContext(
    locations: [
      (id: 'dragon_lair',     label: "Dragon's Lair",    emoji: '🐉'),
      (id: 'dark_forest',     label: 'Dark Forest',      emoji: '🌲'),
      (id: 'giants_keep',     label: "Giant's Keep",     emoji: '🏰'),
      (id: 'ancient_ruins',   label: 'Ancient Ruins',    emoji: '🏛️'),
      (id: 'enchanted_bridge',label: 'Enchanted Bridge', emoji: '🌉'),
      (id: 'mountain_pass',   label: 'Mountain Pass',    emoji: '⛰️'),
      (id: 'fairy_kingdom',   label: 'Fairy Kingdom',    emoji: '🧚'),
      (id: 'frozen_castle',   label: 'Frozen Castle',    emoji: '❄️'),
    ],
    goals: [
      (id: 'defeat_dragon',   label: 'Defeat the dragon',        emoji: '⚔️'),
      (id: 'rescue_princess', label: 'Rescue the trapped hero',  emoji: '🤝'),
      (id: 'golden_sword',    label: 'Find the golden sword',    emoji: '⚔️'),
      (id: 'protect_village', label: 'Protect the village',      emoji: '🛡️'),
      (id: 'break_curse',     label: 'Break the dark curse',     emoji: '💀'),
      (id: 'win_tournament',  label: 'Win the tournament',       emoji: '🏆'),
      (id: 'siege_castle',    label: 'Free the besieged castle', emoji: '🏰'),
      (id: 'holy_grail',      label: 'Find the magic grail',     emoji: '🏆'),
    ],
  ),
  'mermaid': _ThemeContext(
    locations: [
      (id: 'deep_ocean',      label: 'Deep Ocean',       emoji: '🌊'),
      (id: 'coral_kingdom',   label: 'Coral Kingdom',    emoji: '🪸'),
      (id: 'underwater_cave', label: 'Underwater Cave',  emoji: '🕳️'),
      (id: 'sea_dragon_lair', label: "Sea Dragon's Lair",emoji: '🐲'),
      (id: 'sunken_city',     label: 'Sunken City',      emoji: '🏙️'),
      (id: 'rainbow_reef',    label: 'Rainbow Reef',     emoji: '🌈'),
      (id: 'pearl_grotto',    label: 'Pearl Grotto',     emoji: '🐚'),
      (id: 'whirlpool_sea',   label: 'Whirlpool Sea',    emoji: '🌀'),
    ],
    goals: [
      (id: 'stolen_pearl',    label: 'Find the stolen pearl',    emoji: '🔮'),
      (id: 'save_reef',       label: 'Save the coral reef',      emoji: '🪸'),
      (id: 'lonely_shark',    label: 'Befriend a lonely shark',  emoji: '🦈'),
      (id: 'sunken_treasure', label: 'Recover sunken treasure',  emoji: '💰'),
      (id: 'guide_fish',      label: 'Guide the lost fish home', emoji: '🐟'),
      (id: 'ocean_storm',     label: 'Stop the ocean storm',     emoji: '⛈️'),
      (id: 'sea_witch',       label: 'Outwit the sea witch',     emoji: '🧙'),
      (id: 'whale_song',      label: "Hear the whale's secret",  emoji: '🐋'),
    ],
  ),
  'superhero': _ThemeContext(
    locations: [
      (id: 'big_city',        label: 'Big City',         emoji: '🏙️'),
      (id: 'secret_base',     label: 'Secret Base',      emoji: '🦇'),
      (id: 'volcano_island',  label: 'Volcano Island',   emoji: '🌋'),
      (id: 'hero_space',      label: 'Outer Space',      emoji: '🌌'),
      (id: 'underwater_city', label: 'Underwater City',  emoji: '🌊'),
      (id: 'storm_cloud',     label: 'Storm Cloud',      emoji: '⛈️'),
      (id: 'rooftops',        label: 'City Rooftops',    emoji: '🏗️'),
      (id: 'time_portal',     label: 'Time Portal',      emoji: '⏳'),
    ],
    goals: [
      (id: 'stop_meteor',     label: 'Stop the falling meteor',  emoji: '☄️'),
      (id: 'save_flood',      label: 'Save city from flood',     emoji: '🌊'),
      (id: 'catch_villain',   label: 'Catch the sneaky villain', emoji: '🦹'),
      (id: 'protect_secret',  label: 'Protect a secret identity',emoji: '🕵️'),
      (id: 'help_puppy',      label: 'Save a scared puppy',      emoji: '🐕'),
      (id: 'restore_powers',  label: 'Restore lost powers',      emoji: '⚡'),
      (id: 'evil_robot',      label: 'Stop the evil robot',      emoji: '🤖'),
      (id: 'rescue_scientist',label: 'Rescue the scientist',     emoji: '👨‍🔬'),
    ],
  ),
  'chef': _ThemeContext(
    locations: [
      (id: 'magic_kitchen',   label: 'Magic Kitchen',    emoji: '🍳'),
      (id: 'enchanted_farm',  label: 'Enchanted Farm',   emoji: '🌾'),
      (id: 'candy_land',      label: 'Candy Land',       emoji: '🍭'),
      (id: 'secret_garden',   label: 'Secret Garden',    emoji: '🌻'),
      (id: 'giant_market',    label: 'Giant Market',     emoji: '🛒'),
      (id: 'floating_rest',   label: 'Floating Restaurant',emoji: '🍽️'),
      (id: 'dragon_bakery',   label: 'Dragon Bakery',    emoji: '🐉'),
      (id: 'moonlit_vineyard',label: 'Moonlit Vineyard', emoji: '🍇'),
    ],
    goals: [
      (id: 'magical_dish',    label: 'Create the magical dish',      emoji: '✨'),
      (id: 'missing_ingredient',label: 'Find the missing ingredient',emoji: '🧂'),
      (id: 'hungry_dragon',   label: 'Cook for a hungry dragon',     emoji: '🔥'),
      (id: 'cooking_contest', label: 'Win the cooking contest',      emoji: '🏆'),
      (id: 'stolen_recipe',   label: 'Rescue the stolen recipe',     emoji: '📜'),
      (id: 'feed_kingdom',    label: 'Feed the whole kingdom',       emoji: '🍞'),
      (id: 'magic_cake',      label: 'Bake the impossible cake',     emoji: '🎂'),
      (id: 'angry_food',      label: 'Calm the angry ingredients',   emoji: '🫙'),
    ],
  ),
  'scientist': _ThemeContext(
    locations: [
      (id: 'secret_lab',      label: 'Secret Lab',       emoji: '🧪'),
      (id: 'underwater_station',label: 'Underwater Station',emoji: '🌊'),
      (id: 'arctic_base',     label: 'Arctic Base',      emoji: '🧊'),
      (id: 'space_observatory',label: 'Space Observatory',emoji: '🔭'),
      (id: 'jungle_research', label: 'Jungle Research',  emoji: '🌴'),
      (id: 'volcano_lab',     label: 'Volcano Lab',      emoji: '🌋'),
      (id: 'cloud_lab',       label: 'Cloud Laboratory', emoji: '☁️'),
      (id: 'future_city',     label: 'Future City',      emoji: '🏙️'),
    ],
    goals: [
      (id: 'new_element',     label: 'Discover a new element',   emoji: '⚗️'),
      (id: 'fix_experiment',  label: 'Fix the broken experiment',emoji: '🔧'),
      (id: 'stop_virus',      label: 'Stop the spreading virus', emoji: '🦠'),
      (id: 'time_machine',    label: 'Build the time machine',   emoji: '⏳'),
      (id: 'alien_equation',  label: 'Solve the alien equation', emoji: '👽'),
      (id: 'save_iceberg',    label: 'Save the melting iceberg', emoji: '🧊'),
      (id: 'shrink_ray',      label: 'Reverse the shrink ray',   emoji: '🔬'),
      (id: 'grow_creature',   label: 'Tame the giant creature',  emoji: '🦖'),
    ],
  ),
  'ninja': _ThemeContext(
    locations: [
      (id: 'hidden_temple',   label: 'Hidden Temple',    emoji: '⛩️'),
      (id: 'bamboo_forest',   label: 'Bamboo Forest',    emoji: '🎋'),
      (id: 'mountain_fortress',label: 'Mountain Fortress',emoji: '🏔️'),
      (id: 'shadow_city',     label: 'Shadow City',      emoji: '🌃'),
      (id: 'underground_maze',label: 'Underground Maze', emoji: '🗺️'),
      (id: 'ancient_ruins_n', label: 'Ancient Ruins',    emoji: '🏛️'),
      (id: 'rooftop_village', label: 'Rooftop Village',  emoji: '🏘️'),
      (id: 'fog_valley',      label: 'Fog Valley',       emoji: '🌫️'),
    ],
    goals: [
      (id: 'stolen_scroll',   label: 'Retrieve the stolen scroll',   emoji: '📜'),
      (id: 'shadow_villain',  label: 'Stop the shadow villain',      emoji: '🦹'),
      (id: 'secret_move',     label: 'Master the secret move',       emoji: '🥋'),
      (id: 'protect_village', label: 'Protect the hidden village',   emoji: '🛡️'),
      (id: 'uncover_mystery', label: 'Uncover the dark mystery',     emoji: '🔍'),
      (id: 'rescue_master',   label: 'Rescue the trapped master',    emoji: '🙏'),
      (id: 'ancient_weapon',  label: 'Find the ancient weapon',      emoji: '⚔️'),
      (id: 'forbidden_technique',label: 'Learn the forbidden technique',emoji: '💨'),
    ],
  ),
  'explorer': _ThemeContext(
    locations: [
      (id: 'amazon_jungle',   label: 'Amazon Jungle',    emoji: '🌴'),
      (id: 'arctic_tundra',   label: 'Arctic Tundra',    emoji: '🧊'),
      (id: 'lost_desert',     label: 'Lost Desert',      emoji: '🏜️'),
      (id: 'hidden_valley',   label: 'Hidden Valley',    emoji: '🏞️'),
      (id: 'misty_mountains', label: 'Misty Mountains',  emoji: '⛰️'),
      (id: 'underwater_caves',label: 'Underwater Caves', emoji: '🤿'),
      (id: 'floating_islands2',label: 'Floating Islands',emoji: '🏝️'),
      (id: 'underground_city',label: 'Underground City', emoji: '🏙️'),
    ],
    goals: [
      (id: 'map_island',      label: 'Map the lost island',      emoji: '🗺️'),
      (id: 'cross_jungle',    label: 'Cross the dangerous jungle',emoji: '🌿'),
      (id: 'hidden_temple',   label: 'Discover the hidden temple',emoji: '🏛️'),
      (id: 'magic_waterfall', label: 'Find the magic waterfall', emoji: '💧'),
      (id: 'rare_creature',   label: 'Track the rare creature',  emoji: '🦋'),
      (id: 'mountain_peak',   label: 'Reach the mountain peak',  emoji: '🏔️'),
      (id: 'lost_tribe',      label: 'Find the lost tribe',      emoji: '🏕️'),
      (id: 'buried_city',     label: 'Uncover a buried city',    emoji: '🏟️'),
    ],
  ),
  'vet': _ThemeContext(
    locations: [
      (id: 'magic_jungle',    label: 'Magic Jungle',     emoji: '🌴'),
      (id: 'arctic_tundra_v', label: 'Arctic Tundra',    emoji: '🧊'),
      (id: 'ocean_reef',      label: 'Ocean Reef',       emoji: '🪸'),
      (id: 'enchanted_forest',label: 'Enchanted Forest', emoji: '🌲'),
      (id: 'safari_plains',   label: 'Safari Plains',    emoji: '🦁'),
      (id: 'underground_world',label: 'Underground World',emoji: '🕳️'),
      (id: 'cloud_sanctuary', label: 'Cloud Sanctuary',  emoji: '☁️'),
      (id: 'desert_oasis',    label: 'Desert Oasis',     emoji: '🌵'),
    ],
    goals: [
      (id: 'heal_dragon',     label: 'Heal the sick dragon',         emoji: '🐉'),
      (id: 'baby_whale',      label: 'Save a lost baby whale',       emoji: '🐳'),
      (id: 'scared_wolf',     label: 'Help the scared wolf',         emoji: '🐺'),
      (id: 'magic_fever',     label: 'Cure the magical fever',       emoji: '💊'),
      (id: 'flood_rescue',    label: 'Rescue animals from flood',    emoji: '🌊'),
      (id: 'animal_family',   label: 'Find the lost animal family',  emoji: '🐾'),
      (id: 'invisible_creature',label: 'Find the invisible creature',emoji: '👁️'),
      (id: 'freezing_birds',  label: 'Warm up the freezing birds',   emoji: '🐦'),
    ],
  ),
  'inventor': _ThemeContext(
    locations: [
      (id: 'sky_workshop',    label: 'Sky Workshop',     emoji: '⚙️'),
      (id: 'underground_factory',label: 'Underground Factory',emoji: '🏭'),
      (id: 'magic_library',   label: 'Magic Library',    emoji: '📚'),
      (id: 'crystal_mountain',label: 'Crystal Mountain', emoji: '💎'),
      (id: 'future_museum',   label: 'Future Museum',    emoji: '🏛️'),
      (id: 'cloud_workshop',  label: 'Cloud Workshop',   emoji: '☁️'),
      (id: 'robot_city',      label: 'Robot City',       emoji: '🤖'),
      (id: 'volcano_forge',   label: 'Volcano Forge',    emoji: '🌋'),
    ],
    goals: [
      (id: 'magical_machine', label: 'Build the magical machine',    emoji: '⚙️'),
      (id: 'fix_broken_city', label: 'Fix the broken city',         emoji: '🏙️'),
      (id: 'rainbow_bridge_i',label: 'Create a rainbow bridge',     emoji: '🌈'),
      (id: 'impossible_puzzle',label: 'Solve the impossible puzzle', emoji: '🧩'),
      (id: 'power_lighthouse',label: 'Power up the lighthouse',     emoji: '🏮'),
      (id: 'dream_toy',       label: 'Build the dream toy',         emoji: '🪁'),
      (id: 'flying_ship',     label: 'Finish the flying ship',      emoji: '✈️'),
      (id: 'robot_friend',    label: 'Wake up a sleeping robot',    emoji: '🤖'),
    ],
  ),
  'paleontologist': _ThemeContext(
    locations: [
      (id: 'dino_valley',     label: 'Dino Valley',      emoji: '🦕'),
      (id: 'ancient_desert',  label: 'Ancient Desert',   emoji: '🏜️'),
      (id: 'underground_cave',label: 'Underground Cave', emoji: '🕳️'),
      (id: 'time_portal',     label: 'Time Portal',      emoji: '⏳'),
      (id: 'fossil_beach',    label: 'Fossil Beach',     emoji: '🐚'),
      (id: 'prehistoric_forest',label: 'Prehistoric Forest',emoji: '🌿'),
      (id: 'amber_jungle',    label: 'Amber Jungle',     emoji: '🌳'),
      (id: 'volcanic_badlands',label: 'Volcanic Badlands',emoji: '🌋'),
    ],
    goals: [
      (id: 'hidden_fossil',   label: 'Uncover the hidden fossil',   emoji: '🦴'),
      (id: 'baby_dino',       label: 'Befriend a baby dinosaur',    emoji: '🦖'),
      (id: 'ancient_mystery', label: 'Solve the ancient mystery',   emoji: '🔍'),
      (id: 'save_dino_eggs',  label: 'Save the dino eggs',          emoji: '🥚'),
      (id: 'ancient_language',label: 'Decode ancient language',     emoji: '📜'),
      (id: 'time_rescue',     label: 'Rescue the time traveler',    emoji: '⏰'),
      (id: 'meteor_discovery',label: 'Find the meteor crater',      emoji: '☄️'),
      (id: 'dino_stampede',   label: 'Stop the dino stampede',      emoji: '🦏'),
    ],
  ),
  'firefighter': _ThemeContext(
    locations: [
      (id: 'burning_forest',  label: 'Burning Forest',   emoji: '🔥'),
      (id: 'magic_city',      label: 'Magic City',       emoji: '🏙️'),
      (id: 'volcano_island_f',label: 'Volcano Island',   emoji: '🌋'),
      (id: 'crystal_tower',   label: 'Crystal Tower',    emoji: '🗼'),
      (id: 'cloud_town',      label: 'Cloud Town',       emoji: '☁️'),
      (id: 'ancient_ruins_f', label: 'Ancient Ruins',    emoji: '🏛️'),
      (id: 'haunted_mansion', label: 'Haunted Mansion',  emoji: '🏚️'),
      (id: 'ice_palace',      label: 'Ice Palace',       emoji: '❄️'),
    ],
    goals: [
      (id: 'stop_fire',       label: 'Stop the forest fire',     emoji: '🌲'),
      (id: 'rescue_family',   label: 'Rescue the trapped family',emoji: '👨‍👩‍👦'),
      (id: 'put_out_volcano', label: 'Put out the volcano',      emoji: '🌋'),
      (id: 'save_library',    label: 'Save the magic library',   emoji: '📚'),
      (id: 'animals_escape',  label: 'Help animals escape',      emoji: '🐾'),
      (id: 'protect_cloud',   label: 'Protect the cloud town',   emoji: '☁️'),
      (id: 'magic_hose',      label: 'Find the magic hose',      emoji: '💦'),
      (id: 'ice_dragon_fire', label: 'Freeze the fire dragon',   emoji: '🐉'),
    ],
  ),
  'robot_pilot': _ThemeContext(
    locations: [
      (id: 'robot_space',     label: 'Space Station',    emoji: '🛸'),
      (id: 'robot_factory',   label: 'Robot Factory',    emoji: '🏭'),
      (id: 'future_city_r',   label: 'Future City',      emoji: '🏙️'),
      (id: 'cloud_highway',   label: 'Cloud Highway',    emoji: '☁️'),
      (id: 'digital_world',   label: 'Digital World',    emoji: '💻'),
      (id: 'crystal_nebula',  label: 'Crystal Nebula',   emoji: '🌌'),
      (id: 'giant_hangar',    label: 'Giant Hangar',     emoji: '🏗️'),
      (id: 'ion_storm_zone',  label: 'Ion Storm Zone',   emoji: '⚡'),
    ],
    goals: [
      (id: 'repair_satellite',label: 'Repair the satellite',      emoji: '🛰️'),
      (id: 'asteroid_navigate',label: 'Navigate an asteroid belt',emoji: '☄️'),
      (id: 'lost_robot',      label: 'Rescue the lost robot',     emoji: '🤖'),
      (id: 'flying_race',     label: 'Win the flying race',       emoji: '🏆'),
      (id: 'alien_signal',    label: 'Decode the alien signal',   emoji: '📡'),
      (id: 'prevent_crash',   label: 'Prevent the crash',         emoji: '💥'),
      (id: 'power_core',      label: 'Restore the power core',    emoji: '⚡'),
      (id: 'robot_uprising',  label: 'Calm the robot uprising',   emoji: '🦾'),
    ],
  ),
};

// ── Fallback context (if theme not found) ─────────────────────────────────────

const _defaultContext = _ThemeContext(
  locations: [
    (id: 'magic_forest',  label: 'Magic Forest',  emoji: '🌲'),
    (id: 'cloud_kingdom', label: 'Cloud Kingdom', emoji: '☁️'),
    (id: 'ocean',         label: 'Deep Ocean',    emoji: '🌊'),
    (id: 'castle',        label: 'Magic Castle',  emoji: '🏰'),
    (id: 'volcano',       label: 'Volcano Island',emoji: '🌋'),
    (id: 'space',         label: 'Outer Space',   emoji: '🌌'),
  ],
  goals: [
    (id: 'find_treasure', label: 'Find the treasure',    emoji: '💎'),
    (id: 'rescue_friend', label: 'Rescue a friend',      emoji: '🤝'),
    (id: 'defeat_monster',label: 'Befriend a monster',   emoji: '👾'),
    (id: 'solve_mystery', label: 'Solve a mystery',      emoji: '🔍'),
    (id: 'save_planet',   label: 'Save the land',        emoji: '🌍'),
    (id: 'win_race',      label: 'Win the big race',     emoji: '🏆'),
  ],
);

_ThemeContext _contextFor(String theme) =>
    _themeContexts[theme] ?? _defaultContext;

// ── Screen ────────────────────────────────────────────────────────────────────

class AdventureSetupScreen extends ConsumerStatefulWidget {
  const AdventureSetupScreen({super.key, required this.heroId});
  final String heroId;

  @override
  ConsumerState<AdventureSetupScreen> createState() => _AdventureSetupScreenState();
}

class _AdventureSetupScreenState extends ConsumerState<AdventureSetupScreen> {
  int _step = 0;

  String _theme    = _themes.first.id;
  String _location = _contextFor(_themes.first.id).locations.first.id;
  String _goal     = _contextFor(_themes.first.id).goals.first.id;

  // Companion selection (null = solo hero)
  BuddyType? _selectedCompanionType;
  String? _buddyPhotoStoragePath;
  String? _buddyCompanionName;

  // Debug: image count (only relevant when debugModeProvider is on)
  int _debugImageCount = 0;

  final _teachingController = TextEditingController();

  _ThemeContext get _ctx => _contextFor(_theme);

  @override
  void dispose() {
    _teachingController.dispose();
    super.dispose();
  }

  void _selectTheme(String id) {
    final ctx = _contextFor(id);
    setState(() {
      _theme    = id;
      _location = ctx.locations.first.id;
      _goal     = ctx.goals.first.id;
      _step     = 1;
    });
  }

  void _selectCompanion({BuddyType? type, String? photoStoragePath, String? displayName}) {
    setState(() {
      _selectedCompanionType  = type;
      _buddyPhotoStoragePath  = photoStoragePath;
      _buddyCompanionName     = displayName;
      _step = 2;
    });
  }

  void _selectLocation(String id) {
    setState(() {
      _location = id;
      _step = 3;
    });
  }

  void _selectGoal(String id) {
    setState(() {
      _goal = id;
      _step = 4;
    });
  }

  void _back() {
    if (_step > 0) setState(() => _step--);
  }

  void _startGeneration() {
    final theme    = _themes.firstWhere((t) => t.id == _theme);
    final location = _ctx.locations.firstWhere((l) => l.id == _location);
    final goal     = _ctx.goals.firstWhere((g) => g.id == _goal);

    // Resolve latest buddy data at generation time
    String? buddyStoragePath = _buddyPhotoStoragePath;
    String? buddyDisplayName = _buddyCompanionName;
    if (_selectedCompanionType != null) {
      final buddies = ref.read(buddyListProvider).valueOrNull ?? [];
      final buddy = buddies.where((b) => b.type == _selectedCompanionType).firstOrNull;
      buddyStoragePath = buddy?.photoStoragePath;
      buddyDisplayName = buddy?.displayName ?? _selectedCompanionType!.label;
    }

    final debugMode = ref.read(debugModeProvider);

    context.push('/story/generating', extra: {
      'heroId': widget.heroId,
      'setup': {
        'theme':                 theme.label,
        'companion':             _selectedCompanionType?.id,
        'companionName':         buddyDisplayName,
        'location':              location.label,
        'goal':                  goal.label,
        'teachingMoment':        _teachingController.text.trim().isEmpty
                                     ? null
                                     : _teachingController.text.trim(),
        'buddyPhotoStoragePath': buddyStoragePath,
      },
      if (debugMode) 'debugMode': true,
      if (debugMode) 'debugImageCount': _debugImageCount,
    });
  }

  @override
  Widget build(BuildContext context) {
    const steps = [
      _StepSpec(
        question: 'Who do you want to be tonight?',
        hint: 'Step 1 of 4',
      ),
      _StepSpec(
        question: 'Who comes with you?',
        hint: 'Step 2 of 4',
      ),
      _StepSpec(
        question: 'Where does the adventure happen?',
        hint: 'Step 3 of 4',
      ),
      _StepSpec(
        question: 'What do you want to find?',
        hint: 'Step 4 of 4',
      ),
      _StepSpec(
        question: 'Any final touches?',
        hint: 'Optional',
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      _step == 0 ? Icons.close : Icons.arrow_back,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: _step == 0
                        ? () => context.pop()
                        : _back,
                  ),
                  Expanded(
                    child: Text(
                      steps[_step].hint,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.eyebrowSm(color: AppColors.textTertiary),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // ── Progress bar ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 10, 24, 0),
              child: _StepProgressBar(current: _step, total: 5),
            ),

            // ── Question ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
              child: Text(
                steps[_step].question,
                style: AppTextStyles.displayLg(color: AppColors.textPrimary),
              ),
            ),

            // ── Content ───────────────────────────────────────────────────
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: KeyedSubtree(
                  key: ValueKey(_step),
                  child: [
                    // Step 0: Theme
                    _TileGrid(
                      items: _themes,
                      selected: _theme,
                      onSelect: _selectTheme,
                    ),
                    // Step 1: Companion picker
                    _CompanionPickerStep(
                      selectedType: _selectedCompanionType,
                      onSelect: _selectCompanion,
                    ),
                    // Step 2: Location
                    _TileGrid(
                      items: _ctx.locations,
                      selected: _location,
                      onSelect: _selectLocation,
                    ),
                    // Step 3: Goal
                    _TileGrid(
                      items: _ctx.goals,
                      selected: _goal,
                      onSelect: _selectGoal,
                    ),
                    // Step 4: Teaching moment (parent) + optional debug image count
                    _TeachingStep(
                      controller: _teachingController,
                      debugImageCount: ref.watch(debugModeProvider) ? _debugImageCount : null,
                      onDebugImageCountChanged: (v) => setState(() => _debugImageCount = v),
                    ),
                  ][_step],
                ),
              ),
            ),

            // ── CTA (only on last step) ───────────────────────────────────
            if (_step == 4)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                child: FilledButton(
                  onPressed: _startGeneration,
                  child: const Text('Create story!'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Companion picker step ─────────────────────────────────────────────────────

class _CompanionPickerStep extends ConsumerWidget {
  const _CompanionPickerStep({
    required this.selectedType,
    required this.onSelect,
  });

  final BuddyType? selectedType;
  final void Function({BuddyType? type, String? photoStoragePath, String? displayName}) onSelect;

  void _openEditSheet(BuildContext context, BuddyType type, Buddy? existing) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bgBase,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _EditBuddySheet(
        type: type,
        existing: existing,
        onContinue: () => onSelect(
          type: type,
          photoStoragePath: null,
          displayName: null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buddyMap = ref.watch(buddyListProvider).when(
      data: (list) => {for (final b in list) b.type: b},
      loading: () => <BuddyType, Buddy>{},
      error: (_, __) => <BuddyType, Buddy>{},
    );

    const allTypes = BuddyType.values;

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.9,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: allTypes.length + 1, // +1 for Solo Hero
      itemBuilder: (ctx, i) {
        if (i == 0) {
          return _BuddyTileShell(
            selected: selectedType == null,
            onTap: () => onSelect(type: null, photoStoragePath: null, displayName: null),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🌟', style: TextStyle(fontSize: 32)),
                const SizedBox(height: 6),
                Text(
                  'Solo Hero',
                  style: AppTextStyles.bodySm(
                    color: selectedType == null ? AppColors.gold500 : AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
        final type = allTypes[i - 1];
        final buddy = buddyMap[type];
        return _CompanionTypeTile(
          type: type,
          buddy: buddy,
          selected: selectedType == type,
          onTap: () => _openEditSheet(ctx, type, buddy),
        );
      },
    );
  }
}

class _CompanionTypeTile extends StatelessWidget {
  const _CompanionTypeTile({
    required this.type,
    required this.buddy,
    required this.selected,
    required this.onTap,
  });

  final BuddyType type;
  final Buddy? buddy;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final photoUrl = buddy?.photoThumbUrl ?? buddy?.photoUrl;
    return _BuddyTileShell(
      selected: selected,
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (photoUrl != null && photoUrl.isNotEmpty)
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: photoUrl,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) =>
                    Text(type.emoji, style: const TextStyle(fontSize: 30)),
              ),
            )
          else
            Text(type.emoji, style: const TextStyle(fontSize: 30)),
          const SizedBox(height: 4),
          Text(
            buddy?.displayName ?? type.label,
            style: AppTextStyles.bodySm(
              color: selected ? AppColors.gold500 : AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _BuddyTileShell extends StatelessWidget {
  const _BuddyTileShell({
    required this.selected,
    required this.onTap,
    required this.child,
  });
  final bool selected;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: selected ? const Color(0x26FFB84D) : AppColors.bgCard,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: selected ? AppColors.gold500 : AppColors.borderSubtle,
                width: selected ? 1.5 : 1.0,
              ),
              boxShadow: selected
                  ? [BoxShadow(color: AppColors.gold500.withAlpha(50), blurRadius: 12)]
                  : null,
            ),
            child: child,
          ),
          if (selected)
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(
                  color: AppColors.gold500,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 12, color: AppColors.bgBase),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Edit-buddy bottom sheet ───────────────────────────────────────────────────

class _EditBuddySheet extends ConsumerStatefulWidget {
  const _EditBuddySheet({required this.type, this.existing, this.onContinue});
  final BuddyType type;
  final Buddy? existing;
  final VoidCallback? onContinue;

  @override
  ConsumerState<_EditBuddySheet> createState() => _EditBuddySheetState();
}

class _EditBuddySheetState extends ConsumerState<_EditBuddySheet> {
  File? _photo;
  late final TextEditingController _nameController;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existing?.name ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto(ImageSource source) async {
    final xFile = await ImagePicker().pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 1024,
    );
    if (xFile != null && mounted) setState(() => _photo = File(xFile.path));
  }

  Future<void> _save({bool advance = false}) async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await ref.read(buddyRepositoryProvider).upsertBuddy(
        type: widget.type,
        name: _nameController.text.trim().isEmpty ? null : _nameController.text.trim(),
        photo: _photo,
      );
      if (mounted) {
        if (advance) widget.onContinue?.call();
        Navigator.of(context).pop();
      }
    } catch (_) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final existingPhotoUrl = widget.existing?.photoUrl;
    final hasPhoto = _photo != null || (existingPhotoUrl != null && existingPhotoUrl.isNotEmpty);

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.borderDefault,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.type.emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Text(widget.type.label, style: AppTextStyles.displaySm(color: AppColors.textPrimary)),
            ],
          ),
          const SizedBox(height: 24),

          GestureDetector(
            onTap: _showSourceDialog,
            child: Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.bgElevated,
                border: Border.all(
                  color: hasPhoto ? AppColors.gold500 : AppColors.borderDefault,
                  width: 2,
                ),
              ),
              child: _photo != null
                  ? ClipOval(child: Image.file(_photo!, fit: BoxFit.cover, width: 88, height: 88))
                  : existingPhotoUrl != null && existingPhotoUrl.isNotEmpty
                      ? ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: existingPhotoUrl,
                            width: 88,
                            height: 88,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(Icons.add_a_photo, color: AppColors.textTertiary, size: 32),
            ),
          ),
          const SizedBox(height: 6),
          Text('Optional photo', style: AppTextStyles.bodySm(color: AppColors.textTertiary)),
          const SizedBox(height: 20),

          TextField(
            controller: _nameController,
            style: AppTextStyles.bodyMd(color: AppColors.textPrimary),
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              hintText: 'Name (optional, e.g. Rex, Bence…)',
              hintStyle: AppTextStyles.bodyMd(color: AppColors.textFaint),
            ),
          ),
          const SizedBox(height: 28),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _saving ? null : () => _save(),
                  child: const Text('Save'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: _saving ? null : () => _save(advance: true),
                  child: _saving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Continue'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showSourceDialog() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.bgBase,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColors.textSecondary),
              title: Text('Take photo', style: AppTextStyles.bodyMd(color: AppColors.textPrimary)),
              onTap: () { Navigator.pop(ctx); _pickPhoto(ImageSource.camera); },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppColors.textSecondary),
              title: Text('Choose from library', style: AppTextStyles.bodyMd(color: AppColors.textPrimary)),
              onTap: () { Navigator.pop(ctx); _pickPhoto(ImageSource.gallery); },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// ── Tile grid §3.4 ───────────────────────────────────────────────────────────

class _TileGrid extends StatelessWidget {
  const _TileGrid({
    required this.items,
    required this.selected,
    required this.onSelect,
  });

  final List<_Option> items;
  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: items.length,
      itemBuilder: (ctx, i) => _AdventureTile(
        option: items[i],
        selected: selected == items[i].id,
        onTap: () => onSelect(items[i].id),
      ),
    );
  }
}

class _AdventureTile extends StatelessWidget {
  const _AdventureTile({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final _Option option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: selected ? const Color(0x26FFB84D) : AppColors.bgCard,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: selected ? AppColors.gold500 : AppColors.borderSubtle,
                width: selected ? 1.5 : 1.0,
              ),
              boxShadow: selected
                  ? [BoxShadow(color: AppColors.gold500.withAlpha(50), blurRadius: 12)]
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(option.emoji, style: const TextStyle(fontSize: 32)),
                const SizedBox(height: 6),
                Text(
                  option.label,
                  style: AppTextStyles.bodySm(
                    color: selected ? AppColors.gold500 : AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (selected)
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(
                  color: AppColors.gold500,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 12, color: AppColors.bgBase),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Teaching moment step ──────────────────────────────────────────────────────

class _TeachingStep extends StatefulWidget {
  const _TeachingStep({
    required this.controller,
    this.debugImageCount,
    this.onDebugImageCountChanged,
  });
  final TextEditingController controller;
  final int? debugImageCount;
  final ValueChanged<int>? onDebugImageCountChanged;

  @override
  State<_TeachingStep> createState() => _TeachingStepState();
}

class _TeachingStepState extends State<_TeachingStep> {
  static const _topics = [
    'Bravery', 'Kindness', 'Sharing',
    'Honesty', 'Patience', 'Friendship',
    'Perseverance', 'Creativity',
  ];

  String? _selectedTopic;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    final text = widget.controller.text;
    final match = _topics.contains(text) ? text : null;
    if (match != _selectedTopic) setState(() => _selectedTopic = match);
  }

  void _selectTopic(String topic) {
    widget.controller.text = topic;
    setState(() => _selectedTopic = topic);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add a teaching moment',
            style: AppTextStyles.displaySm(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 6),
          Text(
            'Optional, for grown-ups. The story will weave it in gently.',
            style: AppTextStyles.bodyMd(color: AppColors.textTertiary),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _topics.map((topic) => _TeachingChip(
              label: topic,
              selected: _selectedTopic == topic,
              onTap: () => _selectTopic(topic),
            )).toList(),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: widget.controller,
            style: AppTextStyles.bodyMd(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'or type your own…',
              hintStyle: AppTextStyles.bodyMd(color: AppColors.textFaint),
            ),
            textCapitalization: TextCapitalization.sentences,
          ),
          if (widget.debugImageCount != null) ...[
            const SizedBox(height: 28),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.gold500.withAlpha(80)),
              ),
              child: Row(
                children: [
                  const Text('🛠', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 10),
                  Text(
                    'Images to generate:',
                    style: AppTextStyles.bodyMd(color: AppColors.textSecondary),
                  ),
                  const Spacer(),
                  _CountStepper(
                    value: widget.debugImageCount!,
                    min: 0,
                    max: 8,
                    onChanged: widget.onDebugImageCountChanged,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CountStepper extends StatelessWidget {
  const _CountStepper({
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });
  final int value;
  final int min;
  final int max;
  final ValueChanged<int>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StepBtn(
          icon: Icons.remove,
          onTap: value > min ? () => onChanged?.call(value - 1) : null,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            value == 0 ? 'none' : '$value',
            style: AppTextStyles.bodyMd(color: AppColors.gold500),
          ),
        ),
        _StepBtn(
          icon: Icons.add,
          onTap: value < max ? () => onChanged?.call(value + 1) : null,
        ),
      ],
    );
  }
}

class _StepBtn extends StatelessWidget {
  const _StepBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: enabled ? AppColors.bgElevated : AppColors.bgCard,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Icon(
          icon,
          size: 16,
          color: enabled ? AppColors.textSecondary : AppColors.textFaint,
        ),
      ),
    );
  }
}

class _TeachingChip extends StatelessWidget {
  const _TeachingChip({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? const Color(0x26FFB84D) : AppColors.bgCard,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppColors.gold500 : AppColors.borderDefault,
            width: selected ? 1.5 : 1.0,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodySm(
            color: selected ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

// ── Step progress bar ─────────────────────────────────────────────────────────

class _StepProgressBar extends StatelessWidget {
  const _StepProgressBar({required this.current, required this.total});
  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (i) {
        return Expanded(
          child: Container(
            height: 3,
            margin: EdgeInsets.only(right: i < total - 1 ? 4 : 0),
            decoration: BoxDecoration(
              color: i <= current ? AppColors.gold500 : AppColors.borderSubtle,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}

// ── Step spec helper ──────────────────────────────────────────────────────────

class _StepSpec {
  final String question;
  final String hint;
  const _StepSpec({required this.question, required this.hint});
}
