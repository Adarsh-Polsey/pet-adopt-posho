# 🐾 Pet Adoption App

A beautiful and interactive Flutter app that allows users to explore, adopt, and favorite adorable pets. Built with clean architecture, Riverpod for state management, and Firestore as backend — the app supports theming, pagination, offline caching, animations, and more!

---

## 🚀 Hosted Links

| Platform       | Link                                                                 |
|----------------|----------------------------------------------------------------------|
| 🌐 Web App     | [pet-adopt-adarsh-pasho.web.app](https://pet-adopt-adarsh-pasho.web.app/) |
| 📱 Android APK | [Download APK](https://drive.google.com/drive/u/1/folders/1IH9KDwubmLAD4SRW52nM-O0olvvW0MrG)         |

---

## 📱 Screens & Features

### 🏠 Home Page
- ✅ Displays a list of pets
- ✅ Includes a search bar (search by name)
- ✅ Filters by category (Dog, Cat, All)
- ✅ Pagination supported (Firestore cursor-based)
- ✅ Pull-to-refresh
- ✅ Hero animation for image transitions
- ✅ Offline support with Firestore local caching

### 📄 Details Page
- ✅ Displays pet’s name, age, price, and image
- ✅ Interactive image viewer with pinch-to-zoom
- ✅ “Adopt Me” button with popup confirmation
- ✅ Confetti animation on successful adoption
- ✅ Greyed-out UI for adopted pets
- ✅ Persistent adoption status across launches

### 🕓 History Page
- ✅ Shows a chronological list of adopted pets
- ✅ Clear and minimal timeline-style display

### ❤️ Favorites Page
- ✅ Users can favorite/unfavorite pets
- ✅ Favorite status persists across sessions
- ✅ Clean list layout

---

## 🎨 General Features

| Feature                         | Status   |
|---------------------------------|----------|
| Hero Animation (List → Detail) | ✅ Done   |
| Attractive & Responsive UI     | ✅ Done   |
| Dark Mode Support              | ✅ Done   |
| State Management with Riverpod | ✅ Done   |
| SharedPreferences Persistence  | ✅ Done   |
| Offline Firestore Cache        | ✅ Done   |

---

## 🛠️ Architecture

- **MVVM Structure**
- **Riverpod** for clean state management
- **Firestore** as database
- Exception-safe repository pattern
- Models using `.fromJson()` and `.toJson()`
- SOLID and Clean Code principles

---

## 🧪 Testing

| Test Type        | Status |
|------------------|--------|
| ✅ Unit Tests     | ✔️ Done |
| ✅ Widget Tests   | ✔️ Done |
| 🔄 Integration    | Optional |

---

## 📌 Technologies Used

- Flutter (Stable)
- Riverpod
- Cloud Firestore
- SharedPreferences
- Confetti Package
- CachedNetworkImage
- Hero Animations
- Pull-to-Refresh
- Interactive Viewer

---

## 👤 Developer

**Adarsh A. (ADX)**  
Flutter Developer | UI/UX Enthusiast  
📧 sharanya.nambiar@posha.com  

---

> “Adopt a pet. Save a soul. Share a smile.” 🐶🐱  