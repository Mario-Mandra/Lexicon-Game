# Lexicon

A fast-paced pass-and-play party game for Android.

## About

Lexicon is a local multiplayer word guessing game. Teams take turns — one player describes a word without saying it, their teammate guesses. Swipe right for correct, left to skip. First team to the target score wins.

## Word Packs

- **Generic** — Free. Everyday objects and concepts.
- **Pop Culture** — Unlockable. Movies, music, gaming, and internet icons.
- **After Dark** — Unlockable. Adults only.
- **Custom** — Premium. Build your own word list.

## Monetization

- Watch an ad to unlock a pack for the session
- One-time purchase per pack
- Premium membership unlocks everything permanently

## Tech Stack

- Flutter (Android only)
- RevenueCat — IAP and entitlements
- Google AdMob — Rewarded ads
- SharedPreferences — Custom pack persistence

## Development
```bash
flutter pub get
flutter run
```

> Requires `android/key.properties` and `android/app/upload-keystore.jks` locally.
> These files are gitignored and never committed.

## Version

1.0.0+2