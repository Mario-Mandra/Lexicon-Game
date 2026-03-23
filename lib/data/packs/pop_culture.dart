// File: lib/data/packs/pop_culture.dart

import 'package:flutter/material.dart';

const String popCultureId = 'pop_culture';
const String popCultureTitle = 'Pop Culture';
const String popCultureSubtitle = 'Movies, music, and internet icons.';
const IconData popCultureIcon = Icons.movie_filter_rounded;
const bool popCultureIsLocked = true;
const bool popCultureRequiresPremium = false;

const Map<String, List<String>> popCultureWords = {
  'en': [
    'Movie', 'Cinema', 'Hollywood', 'Actor', 'Actress', 'Director', 'Producer', 'Script', 'Camera', 'Scene',
    'Oscar', 'Grammy', 'Emmy', 'Tony', 'Award', 'Red Carpet', 'Premiere', 'Sequel', 'Prequel', 'Trilogy',
    'Superhero', 'Villain', 'Comic', 'Manga', 'Anime', 'Cosplay', 'Convention', 'Fandom', 'Geek', 'Nerd',
    'Lightsaber', 'Spaceship', 'Alien', 'Zombie', 'Vampire', 'Werewolf', 'Ghost', 'Monster', 'Robot', 'Cyborg',
    'Music', 'Song', 'Singer', 'Band', 'Concert', 'Festival', 'Album', 'Track', 'Playlist', 'Radio',
    'Pop', 'Rock', 'Rap', 'Hip-hop', 'Jazz', 'Country', 'Electronic', 'Dance', 'DJ', 'Rhythm',
    'Television', 'Series', 'Episode', 'Season', 'Finale', 'Sitcom', 'Drama', 'Comedy', 'Reality', 'Documentary',
    'Internet', 'Web', 'Viral', 'Meme', 'Hashtag', 'Trending', 'Challenge', 'Prank', 'Troll', 'Hater',
    'Social Media', 'Post', 'Story', 'Feed', 'Like', 'Share', 'Comment', 'Follower', 'Subscriber', 'Influencer',
    'Vlogger', 'Streamer', 'Gamer', 'Console', 'Controller', 'Arcade', 'Pixel', 'Avatar', 'Multiplayer', 'Esports',
    'Fashion', 'Model', 'Runway', 'Designer', 'Brand', 'Trend', 'Outfit', 'Style', 'Vintage', 'Retro',
    'Celebrity', 'Paparazzi', 'Gossip', 'Tabloid', 'Scandal', 'Magazine', 'Interview', 'Autograph', 'VIP', 'Fan',
    'Magic', 'Wizard', 'Witch', 'Spell', 'Wand', 'Dragon', 'Fairy', 'Mermaid', 'Unicorn', 'Myth',
    'Detective', 'Spy', 'Secret', 'Mission', 'Agent', 'Gadget', 'Mystery', 'Clue', 'Crime', 'Action',
    'Romance', 'Kiss', 'Date', 'Wedding', 'Couple', 'Love', 'Heartbreak', 'Drama', 'Gossip', 'Friendship',
    'Dance', 'Choreography', 'Ballet', 'Salsa', 'Tango', 'Hip-hop', 'Club', 'Party', 'DJ', 'Beat',
    'Radio', 'Podcast', 'Host', 'Interview', 'Microphone', 'Broadcast', 'Studio', 'Audio', 'Volume', 'Speaker',
    'Magazine', 'Cover', 'Article', 'Headline', 'News', 'Journalist', 'Reporter', 'Camera', 'Flash', 'Lens',
    'Blockbuster', 'Box Office', 'Ticket', 'Popcorn', 'Screen', 'Projector', '3D', 'IMAX', 'Animation', 'Cartoon',
    'Idol', 'Legend', 'Icon', 'Superstar', 'Diva', 'Rock Star', 'Pop Star', 'Maestro', 'Genius', 'Talent',
  ],
  'ro': [
    'Film', 'Cinema', 'Hollywood', 'Actor', 'Actriță', 'Regizor', 'Producător', 'Scenariu', 'Cameră', 'Scenă',
    'Oscar', 'Grammy', 'Premiu', 'Covorul Roșu', 'Premieră', 'Continuare', 'Trilogie', 'Trofeu', 'Gală', 'Vedetă',
    'Supererou', 'Răufăcător', 'Benzi Desenate', 'Manga', 'Anime', 'Cosplay', 'Convenție', 'Fandom', 'Tocilar', 'Pasionat',
    'Sabie Laser', 'Navă Spațială', 'Extraterestru', 'Zombi', 'Vampir', 'Vârcolac', 'Fantomă', 'Monstru', 'Robot', 'Ciborg',
    'Muzică', 'Piesă', 'Cântăreț', 'Trupă', 'Concert', 'Festival', 'Album', 'Hit', 'Playlist', 'Radio',
    'Pop', 'Rock', 'Rap', 'Hip-hop', 'Trap', 'Manele', 'Electronic', 'Lăutari', 'DJ', 'Ritm',
    'Televiziune', 'Serial', 'Episod', 'Sezon', 'Finală', 'Sitcom', 'Dramă', 'Comedie', 'Reality-show', 'Documentar',
    'Internet', 'Viral', 'Meme', 'Hashtag', 'Trending', 'Provocare', 'Farsă', 'Troll', 'Hater', 'Influencer',
    'Social Media', 'Postare', 'Story', 'Feed', 'Like', 'Share', 'Comentariu', 'Urmăritor', 'Abonat', 'Vlogger',
    'Streamer', 'Gamer', 'Consolă', 'Controller', 'Sală de Net', 'Pixel', 'Avatar', 'Multiplayer', 'Esports', 'Twitch',
    'Modă', 'Model', 'Podium', 'Designer', 'Brand', 'Trend', 'Ținută', 'Fițe', 'Vintage', 'Retro',
    'Celebritate', 'Paparazzi', 'Bârfă', 'Tabloid', 'Scandal', 'Revistă', 'Interviu', 'Autograf', 'VIP', 'Fan',
    'Magie', 'Vrăjitor', 'Vrăjitoare', 'Vrajă', 'Baghetă', 'Zmeu', 'Făt-Frumos', 'Ileana Cosânzeana', 'Inorog', 'Mit',
    'Detectiv', 'Spion', 'Secret', 'Misiune', 'Agent', 'Gadget', 'Mister', 'Indiciu', 'Crimă', 'Acțiune',
    'Romantism', 'Sărut', 'Întâlnire', 'Nuntă', 'Cuplu', 'Dragoste', 'Despărțire', 'Dramă', 'Telenovelă', 'Prietenie',
    'Dans', 'Coregrafie', 'Balet', 'Salsa', 'Tango', 'Horă', 'Club', 'Bairam', 'Discotecă', 'Ritm',
    'Radio', 'Podcast', 'Prezentator', 'Interviu', 'Microfon', 'Transmisiune', 'Studio', 'Audio', 'Volum', 'Boxă',
    'Revistă', 'Copertă', 'Articol', 'Titlu', 'Știri', 'Jurnalist', 'Reporter', 'Aparat Foto', 'Bliț', 'Obiectiv',
    'Blockbuster', 'Box Office', 'Bilet', 'Popcorn', 'Ecran', 'Proiector', '3D', 'Desene Animate', 'Animație', 'Dublaj',
    'Idol', 'Legendă', 'Icoană', 'Superstar', 'Divă', 'Șmecher', 'Zeu', 'Maestru', 'Geniu', 'Talent',
  ],
};