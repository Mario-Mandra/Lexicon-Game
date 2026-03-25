// File: lib/data/packs/after_dark.dart

import 'package:flutter/material.dart';

const String afterDarkId = 'after_dark';
const String afterDarkTitle = 'After Dark';
const String afterDarkSubtitle = 'Late night party vibes. Awkward, funny, and fast-paced.';
const IconData afterDarkIcon = Icons.nightlight_round;
const bool afterDarkIsLocked = true;
const bool afterDarkRequiresPremium = false;

const Map<String, List<String>> afterDarkWords = {
 'en': [
    // Drinks & Party (20)
    'Beer', 'Wine', 'Vodka', 'Shot', 'Drunk', 'Tipsy', 'Hangover', 'Bar', 'Club', 'Bartender', 
    'Bouncer', 'ID', 'Cocktail', 'Toast', 'Cheers', 'Sip', 'Thirst', 'Keg', 'Pub', 'Menu',
    // Dating & Romance (20)
    'Kiss', 'Hug', 'Date', 'Flirt', 'Crush', 'Ex', 'Single', 'Married', 'Divorce', 'Ring', 
    'Wedding', 'Bride', 'Groom', 'Jealous', 'Cheating', 'Secret', 'Whisper', 'Wink', 'Smile', 'Blush',
    // The Body & Bathroom (20) - Mild toilet humor is great for Alias
    'Toilet', 'Poop', 'Pee', 'Fart', 'Burp', 'Sweat', 'Spit', 'Sneeze', 'Cough', 'Snore', 
    'Naked', 'Shower', 'Bath', 'Towel', 'Soap', 'Toilet Paper', 'Belly', 'Butt', 'Lips', 'Tongue',
    // Night & Sleep (20)
    'Night', 'Dark', 'Sleep', 'Dream', 'Nightmare', 'Bed', 'Pillow', 'Blanket', 'Pajamas', 'Mattress', 
    'Moon', 'Star', 'Midnight', 'Vampire', 'Ghost', 'Zombie', 'Monster', 'Bat', 'Owl', 'Shadow',
    // Vices & Mischief (20)
    'Smoke', 'Cigarette', 'Lighter', 'Ashtray', 'Casino', 'Bet', 'Cards', 'Poker', 'Money', 'Cash', 
    'Thief', 'Steal', 'Police', 'Arrest', 'Jail', 'Handcuffs', 'Lie', 'Truth', 'Dare', 'Rule',
    // Social & Loud (20)
    'Party', 'Music', 'Dance', 'Song', 'DJ', 'Speaker', 'Microphone', 'Karaoke', 'Singer', 'Concert', 
    'Crowd', 'VIP', 'Ticket', 'Invite', 'Guest', 'Host', 'Pizza', 'Snack', 'Trash', 'Mess',
    // Modern Life (20)
    'Phone', 'App', 'Swipe', 'Tinder', 'Text', 'Message', 'Call', 'Photo', 'Selfie', 'Video', 
    'Screen', 'Password', 'Internet', 'Viral', 'Trend', 'Drama', 'Gossip', 'Rumor', 'Fake', 'News',
    // Clothing (20)
    'Bra', 'Underwear', 'Socks', 'Shoes', 'Heels', 'Dress', 'Skirt', 'Shirt', 'Pants', 'Belt', 
    'Zipper', 'Button', 'Pocket', 'Hat', 'Glasses', 'Makeup', 'Lipstick', 'Perfume', 'Mirror', 'Comb',
    // Emotions & Reactions (20)
    'Cry', 'Laugh', 'Angry', 'Sad', 'Happy', 'Scared', 'Shock', 'Surprise', 'Bored', 'Tired', 
    'Crazy', 'Stupid', 'Smart', 'Lazy', 'Fast', 'Slow', 'Loud', 'Quiet', 'Hot', 'Cold',
    // Grown-up Basics (20)
    'Boss', 'Job', 'Work', 'Office', 'Bill', 'Debt', 'Rent', 'Tax', 'Coffee', 'Traffic', 
    'Car', 'Key', 'Door', 'Window', 'House', 'Neighbor', 'Doctor', 'Nurse', 'Sick', 'Pill'
  ],
  'ro': [
    // Băuturi & Petrecere (20)
    'Bere', 'Vin', 'Vodcă', 'Shot', 'Beat', 'Amețit', 'Mahmureală', 'Bar', 'Club', 'Barman', 
    'Bodyguard', 'Buletin', 'Cocktail', 'Toast', 'Noroc', 'Înghițitură', 'Sete', 'Butoi', 'Pub', 'Meniu',
    // Întâlniri & Romanță (20)
    'Sărut', 'Îmbrățișare', 'Întâlnire', 'Flirt', 'Pasiune', 'Fostul', 'Singur', 'Căsătorit', 'Divorț', 'Inel', 
    'Nuntă', 'Mireasă', 'Mire', 'Gelos', 'Înșelat', 'Secret', 'Șoaptă', 'Clipit', 'Zâmbet', 'Roșeață',
    // Corp & Baie (20)
    'Toaletă', 'Caca', 'Pișu', 'Pârț', 'Râgâit', 'Transpirație', 'Scuipat', 'Strănut', 'Tuse', 'Sforăit', 
    'Dezbrăcat', 'Duș', 'Baie', 'Prosop', 'Săpun', 'Hârtie igienică', 'Burtă', 'Fund', 'Buze', 'Limbă',
    // Noapte & Somn (20)
    'Noapte', 'Întuneric', 'Somn', 'Vis', 'Coșmar', 'Pat', 'Pernă', 'Pătură', 'Pijama', 'Saltea', 
    'Lună', 'Stea', 'Miezul nopții', 'Vampir', 'Fantomă', 'Zombi', 'Monstru', 'Liliac', 'Bufniță', 'Umbră',
    // Vicii & Pozne (20)
    'Fum', 'Țigară', 'Brichetă', 'Scrumieră', 'Cazinou', 'Pariu', 'Cărți', 'Poker', 'Bani', 'Cash', 
    'Hoț', 'Furt', 'Poliție', 'Arest', 'Închisoare', 'Cătușe', 'Minciună', 'Adevăr', 'Provocare', 'Regulă',
    // Socializare (20)
    'Petrecere', 'Muzică', 'Dans', 'Cântec', 'DJ', 'Boxă', 'Microfon', 'Karaoke', 'Cântăreț', 'Concert', 
    'Mulțime', 'VIP', 'Bilet', 'Invitație', 'Musafir', 'Gazdă', 'Pizza', 'Gustare', 'Gunoi', 'Dezordine',
    // Viață Modernă (20)
    'Telefon', 'Aplicație', 'Swipe', 'Tinder', 'Text', 'Mesaj', 'Apel', 'Poză', 'Selfie', 'Video', 
    'Ecran', 'Parolă', 'Internet', 'Viral', 'Trend', 'Dramă', 'Bârfă', 'Zvon', 'Fals', 'Știri',
    // Îmbrăcăminte (20)
    'Sutien', 'Chiloți', 'Șosete', 'Pantofi', 'Tocuri', 'Rochie', 'Fustă', 'Cămașă', 'Pantaloni', 'Curea', 
    'Fermoar', 'Nasture', 'Buzunar', 'Pălărie', 'Ochelari', 'Machiaj', 'Ruj', 'Parfum', 'Oglindă', 'Pieptene',
    // Emoții & Reacții (20)
    'Plâns', 'Râs', 'Supărat', 'Trist', 'Fericit', 'Speriat', 'Șoc', 'Surpriză', 'Plictisit', 'Obosit', 
    'Nebun', 'Prost', 'Deștept', 'Leneș', 'Rapid', 'Încet', 'Gălăgios', 'Liniștit', 'Fierbinte', 'Rece',
    // Chestii de "Oameni Mari" (20)
    'Șef', 'Job', 'Muncă', 'Birou', 'Factură', 'Datorie', 'Chirie', 'Taxă', 'Cafea', 'Trafic', 
    'Mașină', 'Cheie', 'Ușă', 'Fereastră', 'Casă', 'Vecin', 'Doctor', 'Asistentă', 'Bolnav', 'Pastilă'
  ],
};