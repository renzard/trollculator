# 🤡 Trollculator (Ubuntu Touch / Lomiri Edition)

*[English version below ⬇️](#-trollculator-ubuntu-touch--lomiri-edition-english)*

Η original έκδοση του **Trollculator**, γραμμένη σε **QML** για **Ubuntu Touch**, με τη βοήθεια των **Lomiri Components**. Μια αριθμομηχανή που φαίνεται αθώα, αλλά κρύβει ένα ολόκληρο σύστημα trolling: λάθος αποτελέσματα, easter eggs, memes, βίντεο και ήχους. Αυτή είναι η αρχική υλοποίηση (`Main.qml`) από την οποία έγινε αργότερα το 1:1 port σε Kotlin/Jetpack Compose για Android.

---

## ✨ Χαρακτηριστικά

- **Troll Mode** (ενεργό by default): οι πράξεις βγάζουν **εγγυημένα λάθος** αποτέλεσμα με τυχαία απόκλιση, εκτός αν χτυπήσει κάποιο ειδικό easter egg:
  - `1 + 1` → `Hello World`
  - `6 + 7` → `67`
  - `2 * 2` → `4` (μαζί με Plankton overlay + ήχο, αυτόματο κλείσιμο μετά από λίγα δευτερόλεπτα μέσω `Timer`)
  - `5 / 5` → `1` (μαζί με "funny" overlay + ήχο)
- **Επιστημονικές συναρτήσεις** σε ξεχωριστό, αναδιπλούμενο `scientificDrawer`: τετράγωνο, κύβος, αντίστροφο, παραγοντικό, τριγωνομετρικές, λογάριθμος, `eⁿ`, `π`, `i` κ.λπ. — όλες παίρνουν τυχαία απόκλιση όταν είναι ενεργό το Troll Mode.
- **Το κουμπί `π`**: αντί για 3.14159..., δίνει `3` και ανοίγει το **Princess Sofia overlay** με μουσική.
- **Το κουμπί `i`**: γίνεται `j` σε Troll Mode.
- **`cos(`**: ανοίγει κοινό video-overlay (`sharedVideoOverlay`) παίζοντας ένα συγκεκριμένο meme video.
- **`log(`**: ίδιο overlay, διαφορετικό video.
- **Top bar με 3 κουμπιά**:
  - ⚙️ **Settings** — toggle για Troll Mode, Sound, Vibration, Dark/Light Mode, και κουμπί **"Hack My App"** που ανοίγει ένα ψεύτικο hacker overlay με ήχο dramatic sound effect.
  - 🎨 **UI Selector** — animated dropdown menu για εναλλαγή ανάμεσα σε **5 διαφορετικά UI styles**: iOS Style, Ubuntu Classic, Original First, Firsht UI, Modern Pink.
  - 👤 **Login** — ψεύτικη οθόνη σύνδεσης (username/password) που, ό,τι κι αν πληκτρολογήσεις, καταλήγει σε ένα joke overlay με τη ερώτηση *"Why would you want to login to a calculator?"* και μουσική.
- **Haptics & sound**: `HapticsEffect` για δόνηση σε κάθε πάτημα, `MediaPlayer` για click sound, με δυνατότητα on/off από τις ρυθμίσεις.
- **Dark/Light mode** με πλήρες theming σε όλα τα overlays και τα UI styles.
- **Πλήρως animated menus/overlays** με `NumberAnimation` (fade + scale, easing `OutBack`) για smooth εμφάνιση/απόκρυψη.

---

## 🗂️ Δομή αρχείου

Όλη η εφαρμογή βρίσκεται σε ένα ενιαίο `Main.qml` (~1930 γραμμές), οργανωμένο σε:

1. **State & λογική** (`handlePress()`, `playClick()`) — στην αρχή του αρχείου, ταυτόσημη λογική με το Android port.
2. **Top bar κουμπιά** (Settings, UI Selector, Login) και το animated UI selector menu.
3. **5 πλήρη UI layouts** (ένα για κάθε `uiStyle`), το καθένα με το δικό του `ColumnLayout`/`GridLayout` από αριθμητικά πλήκτρα, εμφανές μόνο όταν `root.uiStyle` ταιριάζει.
4. **Scientific Drawer** — αναδιπλούμενο συρτάρι με τις επιστημονικές συναρτήσεις.
5. **Overlays**: Settings, Login, Hacker, Plankton, Funny, Joke (μετά το login), Princess Sofia (`π`), Shared Video (`cos(`/`log(`) — καθένα `Rectangle` με δικό του `MediaPlayer`/`Video`, back button, και animation.

---

## 🎵 Media files

Οι αναφορές σε αρχεία ήχου/εικόνας/βίντεο μέσα στο QML είναι με **σχετικό path** (πρέπει να βρίσκονται στον φάκελο του πακέτου). Ενδεικτικά αρχεία που χρειάζονται:

| Αρχείο | Χρήση |
|---|---|
| `freesound_community-pick-92276.mp3` | Ήχος click |
| `sofia_theme.mp3` | Princess Sofia overlay (`π`) |
| `Wii music.mp3` | Joke overlay (μετά το login) |
| `DUN DUN DUNNNNN!! _ (SOUND EFFECT)DOWNLOAD.mp3` | Hacker overlay |
| `Funny sound that will make you laugh.mp3` | Funny overlay (`5 / 5`) |
| `Ijustcant_proveit.mp4` | Shared video overlay (`cos(`) |
| `playback.mp4` | Shared video overlay (`log(`) |
| `bc39d92888c7edcb3d948ea9cf4b1961-2174070125.jpg` | Εικόνα στο Funny overlay |
| `cover3-1217099268.jpg` | Εικόνα στο Joke overlay |
| `princess-sofia-with-whatnaught-and-clover-b4lsa9v66e27fr0h-785642301.jpg` | Εικόνα στο Sofia overlay |
| `7fhly5-2602662083.png` | Εικόνα στο Hacker overlay |

Λόγω πνευματικών δικαιωμάτων στα memes, τα ίδια τα αρχεία δεν περιλαμβάνονται στο repo.

---

## 🚀 Build & Run (Ubuntu Touch)

1. Χρειάζεσαι το **Clickable** ή το **Ubuntu Touch SDK** για build/deploy σε συσκευή ή emulator.
2. Βεβαιώσου ότι υπάρχει `manifest.json` / `.desktop` file και τα απαραίτητα assets στον φάκελο του πακέτου.
3. `clickable build` και `clickable install` (ή `clickable desktop` για δοκιμή σε desktop mode) ανάλογα με το setup σου.

---

## ⚠️ Disclaimer

Άδεια χρήσης: **GNU GPL v3** (βλ. header στο `Main.qml`). Η εφαρμογή είναι φτιαγμένη για πλάκα — μην την εμπιστεύεσαι για πραγματικούς υπολογισμούς όσο είναι ενεργό το Troll Mode 😏.

---

## 📄 License

GNU General Public License v3.0 — © 2026 renzard politakis.

<br>

---
---

<br>

# 🤡 Trollculator (Ubuntu Touch / Lomiri Edition) (English)

*[Ελληνική έκδοση παραπάνω ⬆️](#-trollculator-ubuntu-touch--lomiri-edition)*

The original version of **Trollculator**, written in **QML** for **Ubuntu Touch**, using the **Lomiri Components** toolkit. A calculator that looks innocent but hides a whole trolling system: wrong results, easter eggs, memes, videos and sounds. This is the original implementation (`Main.qml`) that was later ported 1:1 to Kotlin/Jetpack Compose for Android.

---

## ✨ Features

- **Troll Mode** (enabled by default): operations return a **guaranteed wrong** result with a random offset, unless a special easter egg is triggered:
  - `1 + 1` → `Hello World`
  - `6 + 7` → `67`
  - `2 * 2` → `4` (plus a Plankton overlay + sound, auto-closing after a few seconds via a `Timer`)
  - `5 / 5` → `1` (plus a "funny" overlay + sound)
- **Scientific functions** in a separate, collapsible `scientificDrawer`: square, cube, reciprocal, factorial, trig functions, logarithm, `eⁿ`, `π`, `i`, etc. — all of them get a random offset applied when Troll Mode is on.
- **The `π` button**: instead of 3.14159..., returns `3` and opens the **Princess Sofia overlay** with music.
- **The `i` button**: becomes `j` in Troll Mode.
- **`cos(`**: opens a shared video overlay (`sharedVideoOverlay`) playing a specific meme video.
- **`log(`**: same overlay, different video.
- **Top bar with 3 buttons**:
  - ⚙️ **Settings** — toggles for Troll Mode, Sound, Vibration, Dark/Light Mode, plus a **"Hack My App"** button that opens a fake hacker overlay with a dramatic sound effect.
  - 🎨 **UI Selector** — animated dropdown menu to switch between **5 different UI styles**: iOS Style, Ubuntu Classic, Original First, Firsht UI, Modern Pink.
  - 👤 **Login** — a fake login screen (username/password) that, no matter what you type, always ends up on a joke overlay asking *"Why would you want to login to a calculator?"* with music.
- **Haptics & sound**: `HapticsEffect` for vibration on every press, `MediaPlayer` for the click sound, both toggleable from settings.
- **Dark/Light mode** with full theming across all overlays and UI styles.
- **Fully animated menus/overlays** using `NumberAnimation` (fade + scale, `OutBack` easing) for smooth show/hide transitions.

---

## 🗂️ File structure

The whole app lives in a single `Main.qml` file (~1930 lines), organized into:

1. **State & logic** (`handlePress()`, `playClick()`) — at the top of the file, logic identical to the Android port.
2. **Top bar buttons** (Settings, UI Selector, Login) and the animated UI selector menu.
3. **5 full UI layouts** (one per `uiStyle`), each with its own `ColumnLayout`/`GridLayout` of number pad buttons, only visible when `root.uiStyle` matches.
4. **Scientific Drawer** — a collapsible drawer with the scientific functions.
5. **Overlays**: Settings, Login, Hacker, Plankton, Funny, Joke (after login), Princess Sofia (`π`), Shared Video (`cos(`/`log(`) — each a `Rectangle` with its own `MediaPlayer`/`Video`, back button, and animation.

---

## 🎵 Media files

References to audio/image/video files inside the QML use **relative paths** (they must live in the package folder). Files referenced include:

| File | Used for |
|---|---|
| `freesound_community-pick-92276.mp3` | Click sound |
| `sofia_theme.mp3` | Princess Sofia overlay (`π`) |
| `Wii music.mp3` | Joke overlay (after login) |
| `DUN DUN DUNNNNN!! _ (SOUND EFFECT)DOWNLOAD.mp3` | Hacker overlay |
| `Funny sound that will make you laugh.mp3` | Funny overlay (`5 / 5`) |
| `Ijustcant_proveit.mp4` | Shared video overlay (`cos(`) |
| `playback.mp4` | Shared video overlay (`log(`) |
| `bc39d92888c7edcb3d948ea9cf4b1961-2174070125.jpg` | Image in the Funny overlay |
| `cover3-1217099268.jpg` | Image in the Joke overlay |
| `princess-sofia-with-whatnaught-and-clover-b4lsa9v66e27fr0h-785642301.jpg` | Image in the Sofia overlay |
| `7fhly5-2602662083.png` | Image in the Hacker overlay |

Due to meme copyright, the actual media files are not included in this repo.

---

## 🚀 Build & Run (Ubuntu Touch)

1. You need **Clickable** or the **Ubuntu Touch SDK** to build/deploy to a device or emulator.
2. Make sure you have a `manifest.json` / `.desktop` file and the required assets in the package folder.
3. Run `clickable build` and `clickable install` (or `clickable desktop` to test in desktop mode) depending on your setup.

---

## ⚠️ Disclaimer

License: **GNU GPL v3** (see the header in `Main.qml`). This app is built for fun — don't rely on it for real calculations while Troll Mode is enabled 😏.

---

## 📄 License

GNU General Public License v3.0 — © 2026 renzard politakis.
