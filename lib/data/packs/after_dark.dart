// File: lib/data/packs/after_dark.dart

import 'package:flutter/material.dart';

const String afterDarkId = 'after_dark';
const String afterDarkTitle = 'After Dark';
const String afterDarkSubtitle = 'Late night party vibes. Awkward, fun, and parent-safe.';
const IconData afterDarkIcon = Icons.nightlight_round;
const bool afterDarkIsLocked = true;
const bool afterDarkRequiresPremium = false;

const Map<String, List<String>> afterDarkWords = {
 'en': [
    // Party & Drinks (20)
    'Party', 'Club', 'DJ', 'Bartender', 'Bouncer', 'VIP', 'Karaoke', 'Dancefloor', 'Cocktail', 'Shot', 
    'Tequila', 'Vodka', 'Beer', 'Wine', 'Champagne', 'Cheers', 'Hangover', 'Tipsy', 'Wasted', 'Blackout',
    // Late Night Out (20)
    'Happy Hour', 'Pub', 'Tavern', 'Brewery', 'Icebreaker', 'Confetti', 'Midnight', 'Taxi', 'Uber', 'Kebab', 
    'Pizza', 'Fast Food', 'Cravings', 'Snack', 'Sleepover', 'Pyjamas', 'Afterparty', 'Playlist', 'Speaker', 'Microphone',
    // Dating & Apps (20)
    'Tinder', 'Match', 'Swipe', 'Profile', 'Bio', 'Selfie', 'Filter', 'DM', 'Seen', 'Ghosting', 
    'Catfish', 'Red Flag', 'Green Flag', 'Date', 'Third Wheel', 'Wingman', 'Flirting', 'Wink', 'Crush', 'Friendzone',
    // Romance & Drama (20)
    'Ex-boyfriend', 'Ex-girlfriend', 'Single', 'Heartbreak', 'Jealousy', 'Serenade', 'Smooch', 'Cuddle', 'Snuggle', 'Romance', 
    'Soulmate', 'Heartthrob', 'Chemistry', 'Rejection', 'Compliment', 'Sparks', 'Love', 'Kiss', 'Hug', 'Boyfriend',
    // Social & Gossip (20)
    'Gossip', 'Rumor', 'Drama', 'Paparazzi', 'Celebrity', 'Influencer', 'Viral', 'Trending', 'Troll', 'Hater', 
    'Fake News', 'Hashtag', 'Follower', 'Subscriber', 'Unfollow', 'Block', 'Mute', 'Notification', 'Podcast', 'Vlogger',
    // Confessions & Awkwardness (20)
    'Embarrassment', 'Awkward', 'Cringe', 'Blushing', 'Apology', 'Excuse', 'Alibi', 'Lie', 'Truth', 'Dare', 
    'Confession', 'Whisper', 'Promise', 'Betrayal', 'Revenge', 'Grudge', 'Forgiveness', 'Loyalty', 'Bestie', 'Frenemy',
    // Late Night Binging (20)
    'Binge-watching', 'Netflix', 'Streaming', 'Episode', 'Spoiler', 'Plot Twist', 'Finale', 'Cliffhanger', 'Cinema', 'Popcorn', 
    'Ticket', 'Screen', 'Director', 'Actor', 'Actress', 'Red Carpet', 'Award', 'Trophy', 'Speech', 'Applause',
    // Vices & Luck (20)
    'Casino', 'Poker', 'Blackjack', 'Roulette', 'Jackpot', 'Bet', 'Gamble', 'Chips', 'Dealer', 'Bluff', 
    'Lottery', 'Luck', 'Fortune', 'Superstition', 'Jinx', 'Karma', 'Destiny', 'Fate', 'Horoscope', 'Zodiac',
    // Moods & Energy (20)
    'Insomnia', 'Night Owl', 'Nightmare', 'Dream', 'Sleepwalking', 'Snoring', 'Yawn', 'Exhausted', 'Alarm', 'Snooze', 
    'Caffeine', 'Coffee', 'Energy Drink', 'Espresso', 'Adrenaline', 'Panic', 'Chill', 'Relax', 'Massage', 'Spa',
    // Night Themes & Tropes (20)
    'Vampire', 'Bat', 'Owl', 'Moon', 'Stars', 'Galaxy', 'Telescope', 'Shadow', 'Silhouette', 'Ghost', 
    'Mystery', 'Detective', 'Clue', 'Suspect', 'Witness', 'Guilty', 'Innocent', 'Handcuffs', 'Police', 'Siren'
  ],
  'ro': [
    // Petrecere & Băuturi (20)
    'Petrecere', 'Club', 'DJ', 'Barman', 'Bodyguard', 'VIP', 'Karaoke', 'Ring de dans', 'Cocktail', 'Shot', 
    'Tequila', 'Vodcă', 'Bere', 'Vin', 'Șampanie', 'Noroc', 'Mahmureală', 'Amețit', 'Pilit', 'Rangă',
    // Ieșiri Nocturne (20)
    'Happy Hour', 'Pub', 'Tavernă', 'Berărie', 'Spărgător de gheață', 'Confeti', 'Miezul nopții', 'Taxi', 'Uber', 'Shaorma', 
    'Pizza', 'Fast Food', 'Pofte', 'Gustare', 'Somn', 'Pijama', 'Afterparty', 'Playlist', 'Boxă', 'Microfon',
    // Dating & Aplicații (20)
    'Tinder', 'Match', 'Swipe', 'Profil', 'Bio', 'Selfie', 'Filtru', 'Mesaj', 'Seen', 'Ghosting', 
    'Catfish', 'Steag roșu', 'Steag verde', 'Întâlnire', 'A treia roată', 'Complice', 'Flirt', 'Clipit', 'Pasiune', 'Friendzone',
    // Romanță & Dramă (20)
    'Fostul', 'Fosta', 'Singur', 'Inimă frântă', 'Gelozie', 'Serenadă', 'Pupic', 'Îmbrățișare', 'Alint', 'Romanță', 
    'Suflet pereche', 'Cuceritor', 'Chimie', 'Refuz', 'Compliment', 'Scântei', 'Iubire', 'Sărut', 'Iubit', 'Iubită',
    // Bârfă & Social Media (20)
    'Bârfă', 'Zvon', 'Dramă', 'Paparazzi', 'Celebritate', 'Influencer', 'Viral', 'Trending', 'Troll', 'Hater', 
    'Fake News', 'Hashtag', 'Urmăritor', 'Abonat', 'Unfollow', 'Block', 'Mute', 'Notificare', 'Podcast', 'Vlogger',
    // Confesiuni & Situații Penibile (20)
    'Rușine', 'Penibil', 'Cringe', 'Roșeață', 'Scuză', 'Pretext', 'Alibi', 'Minciună', 'Adevăr', 'Provocare', 
    'Confesiune', 'Șoaptă', 'Promisiune', 'Trădare', 'Răzbunare', 'Pică', 'Iertare', 'Loialitate', 'BFF', 'Inamic',
    // Binge-watching de Noapte (20)
    'Maraton de seriale', 'Netflix', 'Streaming', 'Episod', 'Spoiler', 'Răsturnare de situație', 'Finală', 'Cliffhanger', 'Cinema', 'Floricele', 
    'Bilet', 'Ecran', 'Regizor', 'Actor', 'Actriță', 'Covorul roșu', 'Premiu', 'Trofeu', 'Discurs', 'Aplauze',
    // Vicii & Noroc (20)
    'Cazinou', 'Poker', 'Blackjack', 'Ruletă', 'Jackpot', 'Pariu', 'Joc de noroc', 'Jetoane', 'Dealer', 'Cacealma', 
    'Loterie', 'Noroc', 'Avere', 'Superstiție', 'Ghinion', 'Karma', 'Destin', 'Soartă', 'Horoscop', 'Zodiac',
    // Stări & Energie (20)
    'Insomnie', 'Pasăre de noapte', 'Coșmar', 'Vis', 'Somnambul', 'Sforăit', 'Căscat', 'Epuizat', 'Alarmă', 'Snooze', 
    'Cofeină', 'Cafea', 'Energizant', 'Espresso', 'Adrenalină', 'Panică', 'Chill', 'Relaxare', 'Masaj', 'Spa',
    // Tropi & Concepte Nocturne (20)
    'Vampir', 'Liliac', 'Bufniță', 'Lună', 'Stele', 'Galaxie', 'Telescop', 'Umbră', 'Siluetă', 'Fantomă', 
    'Mister', 'Detectiv', 'Indiciu', 'Suspect', 'Martor', 'Vinovat', 'Nevinovat', 'Cătușe', 'Poliție', 'Sirenă'
  ],
};