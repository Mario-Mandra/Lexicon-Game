// File: lib/data/packs/generic.dart

import 'package:flutter/material.dart';

const String genericId = 'generic';
const String genericTitle = 'Generic';
const String genericSubtitle = 'Everyday objects. Perfect for families.';
const IconData genericIcon = Icons.extension_rounded;
const bool genericIsLocked = false;
const bool genericRequiresPremium = false;

const Map<String, List<String>> genericWords = {
  'en': [
    'Apple', 'Banana', 'Strawberry', 'Cherry', 'Peach', 'Potato', 'Tomato', 'Onion', 'Carrot', 'Bread',
    'Cheese', 'Butter', 'Milk', 'Coffee', 'Tea', 'Water', 'Juice', 'Pizza', 'Burger', 'Soup',
    'Meat', 'Salad', 'Bear', 'Wolf', 'Egg', 'Sugar', 'Salt', 'Pepper', 'Garlic', 'Honey',
    'Dog', 'Cat', 'Mouse', 'Horse', 'Cow', 'Pig', 'Sheep', 'Goat', 'Goose', 'Duck',
    'Bird', 'Shark', 'Frog', 'Snake', 'Turtle', 'Spider', 'Bee', 'Ant', 'Fly', 'Mosquito',
    'House', 'Door', 'Roof', 'Floor', 'Wall', 'Room', 'Kitchen', 'Bathroom', 'Bedroom', 'Basement',
    'Bed', 'Chair', 'Table', 'Sofa', 'Lamp', 'Clock', 'Picture', 'Television', 'Telephone', 'Book',
    'Pen', 'Pencil', 'Paper', 'Box', 'Bag', 'Cup', 'Plate', 'Bowl', 'Fork', 'Knife',
    'Spoon', 'Bottle', 'Glass', 'Shirt', 'Pants', 'Dress', 'Skirt', 'Shoe', 'Sock', 'Hat',
    'Coat', 'Jacket', 'Glove', 'Scarf', 'Belt', 'Ring', 'Bracelet', 'Crown', 'Suit', 'Tie',
    'Car', 'Bus', 'Train', 'Airplane', 'Boat', 'Ship', 'Motorcycle', 'Truck', 'Taxi', 'Tractor',
    'Street', 'Road', 'Highway', 'Airport', 'Station', 'City', 'Town', 'Park', 'School', 'Hospital',
    'Bank', 'Store', 'Restaurant', 'Hotel', 'Church', 'Cinema', 'Theater', 'Museum', 'Gym', 'Stadium',
    'Sun', 'Moon', 'Star', 'Sky', 'Cloud', 'Rain', 'Snow', 'Wind', 'Storm', 'Lightning',
    'Fire', 'Earth', 'Air', 'Tree', 'Grass', 'Leaf', 'Branch', 'Root', 'Seed', 'Dirt',
    'Head', 'Face', 'Eye', 'Ear', 'Nose', 'Mouth', 'Tooth', 'Tongue', 'Hair', 'Neck',
    'Arm', 'Hand', 'Finger', 'Leg', 'Foot', 'Bone', 'Back', 'Chest', 'Heart', 'Stomac',
    'Nurse', 'Teacher', 'Student', 'Policeman', 'Firefighter', 'Pilot', 'Driver', 'Chef', 'Baker', 'Farmer',
    'Artist', 'Singer', 'Actor', 'Writer', 'Painter', 'Worker', 'Boss', 'Judge', 'Lawyer', 'Dentist',
    'Ball', 'Bat', 'Paddle', 'Net', 'Goal', 'Game', 'Toy', 'Doll', 'Puzzle', 'Token',
  ],
  'ro': [
    'Măr', 'Banană', 'Căpșună', 'Cireașă', 'Piersică', 'Cartof', 'Roșie', 'Ceapă', 'Morcov', 'Pâine',
    'Brânză', 'Unt', 'Lapte', 'Cafea', 'Ceai', 'Apă', 'Suc', 'Pizza', 'Burger', 'Supă',
    'Carne', 'Salată', 'Urs', 'Lup', 'Ou', 'Zahăr', 'Sare', 'Piper', 'Usturoi', 'Miere',
    'Câine', 'Pisică', 'Șoarece', 'Cal', 'Vasă', 'Porc', 'Oaie', 'Capră', 'Gâscă', 'Rață',
    'Pasăre', 'Rechin', 'Broască', 'Șarpe', 'Țestoasă', 'Păianjen', 'Albină', 'Furnică', 'Muscă', 'Țânțar',
    'Casă', 'Ușă', 'Acoperiș', 'Podea', 'Perete', 'Încăpere', 'Bucătărie', 'Baie', 'Dormitor', 'Pivniță',
    'Pat', 'Scaun', 'Masă', 'Canapea', 'Lampă', 'Ceas', 'Tablou', 'Televizor', 'Telefon', 'Carte',
    'Stilou', 'Creion', 'Hârtie', 'Cutie', 'Geantă', 'Cană', 'Farfurie', 'Bol', 'Furculiță', 'Cuțit',
    'Lingură', 'Sticlă', 'Pahar', 'Cămașă', 'Pantaloni', 'Rochie', 'Fustă', 'Pantof', 'Șosetă', 'Pălărie',
    'Palton', 'Jachetă', 'Mănușă', 'Fular', 'Curea', 'Inel', 'Brățară', 'Coroană', 'Costum', 'Cravată',
    'Mașină', 'Autobuz', 'Tren', 'Avion', 'Barcă', 'Vapor', 'Motocicletă', 'Camion', 'Taxi', 'Tractor',
    'Stradă', 'Drum', 'Autostradă', 'Aeroport', 'Gară', 'Oraș', 'Orășel', 'Parc', 'Școală', 'Spital',
    'Bancă', 'Magazin', 'Restaurant', 'Hotel', 'Biserică', 'Cinema', 'Teatru', 'Muzeu', 'Sală', 'Stadion',
    'Soare', 'Lună', 'Stea', 'Cer', 'Nor', 'Ploaie', 'Zăpadă', 'Vânt', 'Furtună', 'Fulger',
    'Foc', 'Pământ', 'Aer', 'Copac', 'Iarbă', 'Frunză', 'Creangă', 'Rădăcină', 'Sămânță', 'Noroi',
    'Cap', 'Față', 'Ochi', 'Ureche', 'Nas', 'Gură', 'Dinte', 'Limbă', 'Păr', 'Gât',
    'Braț', 'Mână', 'Deget', 'Picior', 'Talpă', 'Os', 'Spate', 'Piept', 'Inimă', 'Stomac',
    'Asistentă', 'Profesor', 'Elev', 'Polițist', 'Pompier', 'Pilot', 'Șofer', 'Bucătar', 'Brutar', 'Fermier',
    'Artist', 'Cântăreț', 'Actor', 'Scriitor', 'Pictor', 'Muncitor', 'Șef', 'Judecător', 'Avocat', 'Dentist',
    'Minge', 'Bâtă', 'Paletă', 'Plasă', 'Poartă', 'Joc', 'Jucărie', 'Păpușă', 'Puzzle', 'Jeton',
  ],
};