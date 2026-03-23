// File: lib/data/packs/retro.dart

import 'package:flutter/material.dart';

const String retroId = 'retro';
const String retroTitle = 'Retro';
const String retroSubtitle = 'Old school classics from the good old days.';
const IconData retroIcon = Icons.videogame_asset_rounded;
const bool retroIsLocked = true;
const bool retroRequiresPremium = false;

const Map<String, List<String>> retroWords = {
  'en': [
    'Cassette', 'Walkman', 'VHS', 'Floppy', 'Disk', 'Tape', 'Radio', 'Boombox', 'Pager', 'Dial-up',
    'Tamagotchi', 'Arcade', 'Pinball', 'Joystick', 'Console', 'Gameboy', 'Tetris', 'Pac-Man', 'Pixel', 'Retro',
    'Polaroid', 'Film', 'Projector', 'Typewriter', 'Telegraph', 'Gramophone', 'Vinyl', 'Record', 'Jukebox', 'Disco',
    'Rollerblades', 'Skates', 'Yoyo', 'Frisbee', 'Rubik', 'Cube', 'Lego', 'Play-Doh', 'Slime', 'Neon',
    'Spandex', 'Mullet', 'Perm', 'Denim', 'Choker', 'Bandana', 'Scrunchie', 'Overalls', 'Windbreaker', 'Mixtape',
    'CD', 'DVD', 'Walkie-Talkie', 'Antenna', 'Tube', 'Television', 'VCR', 'Modem', 'Fax', 'Encyclopedia',
    'Map', 'Atlas', 'Chalkboard', 'Chalk', 'Eraser', 'Marble', 'Hopscotch', 'Rope', 'Pogs', 'Kite',
    'Action', 'Figure', 'Transformer', 'Ninja', 'Turtle', 'Dinosaur', 'Alien', 'MTV', 'Blockbuster', 'Rent',
    'Cartridge', 'Rewind', 'Forward', 'Pause', 'Beanie', 'Furby', 'Troll', 'Doll', 'Slinky', 'Sketch',
    'View-Master', 'Kaleidoscope', 'Flash', 'Bulb', 'Darkroom', 'Negative', 'Album', 'Scrapbook', 'Diary', 'Vintage',
    'Antique', 'Classic', 'Nostalgia', 'Throwback', 'Decade', 'Millennium', 'Y2K', 'Grunge', 'Emo', 'Punk',
    'Goth', 'Prep', 'Skater', 'Hippie', 'Boomer', 'Discman', 'MP3', 'iPod', 'LimeWire', 'Napster',
    'Burn', 'MSN', 'Messenger', 'Yahoo', 'Chatroom', 'Forum', 'Blog', 'MySpace', 'AOL', 'Email',
    'Nokia', 'Snake', 'Polyphonic', 'Ringtone', 'Flip-Phone', 'Keypad', 'Battery', 'Charger', 'Skateboard', 'BMX',
    'Scooter', 'Tricycle', 'Wagon', 'Sled', 'Drive-in', 'Diner', 'Milkshake', 'Greaser', 'Poodle', 'Leather',
    'Jacket', 'Pompadour', 'Ribbon', 'Ink', 'Quill', 'Parchment', 'Scroll', 'Wax', 'Seal', 'Stamp',
    'Envelope', 'Postcard', 'Telegram', 'Postage', 'Mailbox', 'Courier', 'Delivery', 'Newspaper', 'Magazine', 'Comic',
    'Super', 'Mario', 'Sonic', 'Crash', 'Bandicoot', 'Lara', 'Croft', 'Zelda', 'Link', 'Pokemon',
    'Charizard', 'Pikachu', 'Digimon', 'Yu-Gi-Oh', 'Beyblade', 'Bakugan', 'Cartoon', 'Network', 'Fox', 'Kids',
    'Disney', 'Nickelodeon', 'Jetix', 'Minimax', 'Animaniacs', 'Looney', 'Tunes', 'Tom', 'Jerry', 'Flintstones',
  ],
  'ro': [
    'Casetă', 'Walkman', 'VHS', 'Dischetă', 'Disc', 'Bandă', 'Radio', 'Casetofon', 'Pager', 'Dial-up',
    'Tamagotchi', 'Arcade', 'Pinball', 'Joystick', 'Consolă', 'Gameboy', 'Tetris', 'Pac-Man', 'Pixel', 'Retro',
    'Polaroid', 'Film', 'Proiector', 'Mașină de scris', 'Telegraf', 'Gramofon', 'Vinil', 'Placă', 'Jukebox', 'Disco',
    'Role', 'Patine', 'Yoyo', 'Frisbee', 'Rubik', 'Cub', 'Lego', 'Plastilină', 'Slime', 'Neon',
    'Spandex', 'Mullet', 'Permanent', 'Blugi', 'Choker', 'Bandană', 'Elastic', 'Salopetă', 'Fâș', 'Mixtape',
    'CD', 'DVD', 'Walkie-Talkie', 'Antenă', 'Tub', 'Televizor', 'Video', 'Modem', 'Fax', 'Teleenciclopedia',
    'Hartă', 'Atlas', 'Tablă', 'Cretă', 'Burete', 'Cornete', 'Șotron', 'Coardă', 'Guma Turbo', 'Zmeu',
    'Acțiune', 'Figurină', 'Transformer', 'Ninja', 'Țestoasă', 'Dino', 'Extraterestru', 'MTV', 'Închirieri', 'Casete',
    'Cartuș', 'Derulare', 'Înainte', 'Pauză', 'Beanie', 'Furby', 'Trol', 'Păpușă', 'Arc', 'Oracol',
    'View-Master', 'Caleidoscop', 'Bliț', 'Bec', 'Cameră Obscură', 'Negativ', 'Album', 'Amintiri', 'Jurnal', 'Vintage',
    'Antichitate', 'Clasic', 'Nostalgie', 'Vechi', 'Deceniu', 'Mileniu', 'Y2K', 'Grunge', 'Emo', 'Punk',
    'Goth', 'Tocilar', 'Skater', 'Hippie', 'Boomer', 'Discman', 'MP3', 'iPod', 'ODC', 'Napster',
    'Track-uri', 'MSN', 'Messenger', 'Yahoo', 'mIRC', 'Forum', 'Blog', 'MySpace', 'Sală de Net', 'Email',
    'Nokia', 'Șarpe', 'Polifonic', 'Sonerie', 'Clapetă', 'Tastatură', 'Baterie', 'Încărcător', 'Skateboard', 'BMX',
    'Trotinetă', 'Tricicletă', 'Cărucior', 'Sanie', 'Drive-in', 'Diner', 'Milkshake', 'Rocker', 'Fustă', 'Piele',
    'Geacă', 'Freză', 'Panglică', 'Cerneală', 'Pană', 'Pergament', 'Papirus', 'Ceară', 'Sigiliu', 'Ștampilă',
    'Plic', 'Vedere', 'Telegramă', 'Timbru', 'Cutie Poștală', 'Poștaș', 'Livrare', 'Ziar', 'Revistă', 'Benzi desenate',
    'Super', 'Mario', 'Sonic', 'Crash', 'Bandicoot', 'Lara', 'Croft', 'Zelda', 'Link', 'Pokemon',
    'Charizard', 'Pikachu', 'Digimon', 'Yu-Gi-Oh', 'Beyblade', 'Bakugan', 'Cartoon', 'Network', 'Fox', 'Kids',
    'Disney', 'Nickelodeon', 'Jetix', 'Minimax', 'Animaniacs', 'Looney', 'Tunes', 'Tom', 'Jerry', 'Flintstones',
  ],
};