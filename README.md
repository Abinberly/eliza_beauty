<p align="center">
  <img src="assets/images/app-logo.png" width="100" alt="Eliza Logo"/>
</p>

<h1 align="center">Eliza</h1>

<p align="center">
  <em>Curated elegance meets lifestyle.</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.11+-02569B?logo=flutter&logoColor=white" alt="Flutter 3.11+"/>
  <img src="https://img.shields.io/badge/Dart-3.11+-0175C2?logo=dart&logoColor=white" alt="Dart 3.11+"/>
  <img src="https://img.shields.io/badge/Platform-iOS%20%7C%20Android%20%7C%20Web-lightgrey" alt="Platforms"/>
  <img src="https://img.shields.io/badge/Architecture-Clean%20Architecture-blueviolet" alt="Clean Architecture"/>
  <img src="https://img.shields.io/badge/State-Riverpod-orange" alt="Riverpod"/>
</p>

---

## About

**Eliza** is a premium beauty & lifestyle e-commerce app built with Flutter. It features a rich onboarding experience, secure JWT-based authentication with silent token refresh, product browsing by category, full-text search with sort & filter, a local-first shopping cart, user profiles, dark mode, and bilingual support (English & Arabic with RTL).

The app consumes the [DummyJSON](https://dummyjson.com) REST API and follows **Clean Architecture** for its codebase.

---

## ✨ Key Features

| Feature | Description |
|---|---|
| **Onboarding** | 4-page immersive walkthrough — Welcome, Curated for You, Inner Circle, Seamless Discovery — with page indicators, skip, and animated transitions |
| **Authentication** | Login, Register, Forgot Password screens built with reusable auth templates |
| **Session Management** | JWT access + refresh tokens stored in Keychain / Keystore via `flutter_secure_storage`; automatic silent refresh via a custom Chopper `Authenticator` |
| **Fresh-Install Detection** | File-marker strategy in the Documents directory to detect iOS reinstalls and clear stale Keychain data |
| **Home Feed** | Featured product carousel, horizontal category bar, infinite-scroll product grid with shimmer loading placeholders |
| **Product Details** | Swipeable image gallery, pricing with discount tags, star ratings, customer reviews, "Add to Cart" / "Buy Now" actions, and a similar-products carousel |
| **Product Search** | Live search with sort (price, rating) & order (asc/desc) controls, paginated results, shimmer loading, and empty-state handling |
| **Shopping Cart** | Local-first cart state — add, remove, update quantity — with total price summary and checkout UI |
| **User Profile** | Avatar, contact info, career details, physical details, notification toggle, dark mode toggle, language picker, and logout with confirmation dialog |
| **Dark Mode** | Full light/dark theme with persisted preference, Material 3 color schemes, and custom `ThemeExtension` |
| **Localization** | English 🇬🇧 and Arabic 🇸🇦 with full RTL support; language preference persisted to SQLite |
| **Offline Resilience** | Cached user data restored from secure storage when the network is unavailable; background validation refreshes the session silently |

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Presentation Layer                    │
│  Pages · Widgets · Templates                             │
│  Riverpod Providers (app, auth, cart, shop)              │
├─────────────────────────────────────────────────────────┤
│                      Domain Layer                        │
│  Entities (User, CartItem)                               │
│  Use Cases (Login, Initialization, Onboarding)           │
│  Repository Contracts                                    │
├─────────────────────────────────────────────────────────┤
│                       Data Layer                         │
│  Chopper API Services (Auth, Product, Cart)              │
│  Data Models (Freezed + JSON Serializable)               │
│  Repository Implementations                              │
│  Local Storage (Secure Storage, SQLite)                   │
├─────────────────────────────────────────────────────────┤
│                       Core Layer                         │
│  Router (GoRouter) · Theme · Network (Chopper Client)    │
│  Localization (ARB) · Constants · Utilities              │
└─────────────────────────────────────────────────────────┘
```

### UI Layer

All reusable UI components live in a single `widgets/` directory for simplicity:

| Category | Examples |
|---|---|
| **Widgets** | `ShimmerBox`, `AppTextFormField`, `ProductCard`, `FeatureCarousel`, `CartList`, `CustomNavBar`, `RatingRow`, `SortFilterBar`, `SettingsGroup`, `LoginFormMolecule` |
| **Templates** | `AuthLayoutTemplate` |
| **Pages** | `HomeScreen`, `ProductDetailsPage`, `SearchProductPage`, `CartPage`, `ProfilePage`, `OnboardingPage`, `LoginPage` |

---

## 🛠️ Tech Stack

| Concern | Library |
|---|---|
| UI Framework | **Flutter** (Dart SDK ≥ 3.11) |
| State Management | **Riverpod** + Riverpod Generator + Flutter Hooks |
| Navigation | **GoRouter** — declarative, `StatefulShellRoute` for bottom-nav tabs |
| HTTP Client | **Chopper** — type-safe REST client with code generation |
| Serialization | **Freezed** + **JSON Serializable** |
| Secure Storage | **flutter_secure_storage** (tokens, onboarding, theme) |
| Local Database | **sqflite** (language preference) |
| Theming | Material 3 + custom `ThemeExtension` + **Google Fonts** |
| Localization | Flutter `intl` + ARB files (EN, AR) |
| Loading UX | **Shimmer** placeholders |
| Grid Layouts | **flutter_staggered_grid_view** |
| Code Generation | **build_runner** for Chopper, Freezed, Riverpod, JSON |

---

## 📂 Project Structure

```
lib/
├── main.dart                           # Entry point
├── eliza_app.dart                      # Root MaterialApp.router with theme & locale
│
├── core/
│   ├── constants/
│   │   └── api_endpoints.dart          # Base URL + all endpoint paths
│   ├── l10n/
│   │   ├── app_en.arb                  # English translations
│   │   ├── app_ar.arb                  # Arabic translations
│   │   └── app_localizations.dart      # Generated delegates
│   ├── network/
│   │   ├── chopper_client.dart         # ChopperClient, AuthInterceptor, MyAuthenticator
│   │   └── network_info.dart           # Connectivity helper
│   ├── router/
│   │   ├── app_routes.dart             # Route path constants
│   │   └── app_router.dart             # GoRouter config with shell navigation
│   ├── theme/
│   │   ├── app_colors.dart             # Light & dark color palette
│   │   ├── app_images.dart             # Asset path constants
│   │   ├── app_text_styles.dart        # Typography
│   │   └── app_theme.dart              # AppCustomColors ThemeExtension
│   └── utils/
│       ├── alert_service.dart          # Snackbar helpers
│       └── validation_utils.dart       # Form validators
│
├── data/
│   ├── local/
│   │   ├── secure_storage_helper.dart  # Token, theme, onboarding persistence
│   │   ├── database_helper.dart        # SQLite setup
│   │   ├── database_provider.dart      # Riverpod DB provider
│   │   └── language_local_service.dart # Language preference via SQLite
│   ├── models/
│   │   ├── product_model.dart          # Freezed product + review models
│   │   ├── category_model.dart         # Category DTO
│   │   ├── user_model.dart             # User DTO
│   │   └── product_search_state.dart   # Freezed search state
│   ├── repositories/
│   │   ├── auth_repository_impl.dart   # Auth repo (login, token storage)
│   │   └── local_cache_repository.dart # Cached user data
│   └── sources/
│       ├── auth_api_service.dart       # POST /login, /refresh, GET /me
│       ├── product_api_service.dart    # Categories, products by slug, details, search
│       └── cart_api_service.dart       # CRUD cart operations
│
├── domain/
│   ├── entities/
│   │   ├── user.dart                   # User entity
│   │   └── cart_item.dart              # CartItem entity
│   ├── repository/
│   │   └── auth_repository.dart        # Repository contract
│   └── use_case/
│       ├── login_usecase.dart          # Login orchestration
│       ├── initialization_use_case.dart
│       └── onboarding_use_case.dart
│
└── presentation/
    ├── widgets/                        # 42 reusable UI components
    ├── templates/
    │   └── auth_layout_template.dart   # Shared auth page scaffold
    ├── pages/
    │   ├── splash_screen.dart          # Animated splash with progress bar
    │   ├── onboarding_page.dart        # 4-page premium onboarding
    │   ├── login_page.dart             # Login with error handling
    │   ├── register_page.dart          # Registration form
    │   ├── forgot_password_page.dart   # Password recovery
    │   ├── home_screen.dart            # Carousel + categories + product grid
    │   ├── search_product_page.dart    # Search with sort/filter
    │   ├── product_details_page.dart   # Full product view
    │   ├── cart_page.dart              # Cart with checkout
    │   └── profile_page.dart           # User profile & settings
    ├── main_layout/
    │   └── main_layout_screen.dart     # Bottom nav shell (Home, Search, Profile)
    └── providers/
        ├── app/                        # Theme, locale, splash, onboarding
        ├── auth/                       # Login controller, user profile, password visibility
        ├── cart/                       # Cart notifier
        └── shop/                       # Products, categories, details, search
```

---

## 🌐 API Reference

All endpoints target **`https://dummyjson.com`**:

### Authentication
| Method | Endpoint | Purpose |
|---|---|---|
| `POST` | `/auth/login` | Authenticate user → returns access + refresh tokens |
| `POST` | `/auth/refresh` | Refresh expired access token |
| `GET` | `/auth/me` | Get current authenticated user |

### Products
| Method | Endpoint | Purpose |
|---|---|---|
| `GET` | `/products/categories` | List all categories |
| `GET` | `/products/category/{slug}` | Products by category (paginated) |
| `GET` | `/products/{id}` | Single product details |
| `GET` | `/products/search?q=` | Full-text search (paginated, sortable) |

### Cart
| Method | Endpoint | Purpose |
|---|---|---|
| `GET` | `/carts/user/{userId}` | Fetch user's carts |
| `POST` | `/carts/add` | Add new cart |
| `PUT` | `/carts/{id}` | Update cart items |
| `DELETE` | `/carts/{id}` | Delete cart |

---

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK** ≥ 3.11.0  
- **Xcode** 15+ (for iOS builds)  
- **Android Studio** / Android SDK (for Android builds)

### Setup

```bash
# Clone
git clone https://github.com/Abinberly/eliza_beauty.git
cd eliza_beauty

# Install dependencies
flutter pub get

# Run code generation
dart run build_runner build --delete-conflicting-outputs

# Launch on connected device
flutter run
```

### Development

Use watch mode for code generation during active development:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

### Test Credentials

The app uses [DummyJSON auth](https://dummyjson.com/docs/auth). You can log in with any user from the DummyJSON users database, for example:

| Username | Password |
|---|---|
| `emilys` | `emilyspass` |

---

## 🎨 Theming

| Token | Light | Dark |
|---|---|---|
| Primary | `#2563EB` 🔵 | `#3B82F6` 🔵 |
| Secondary | `#F59E0B` 🟡 | `#FBBF24` 🟡 |
| Background | `#F7F9FB` | `#020617` |
| Card | `#F8FAFC` | `#0F172A` |
| Text Primary | `#0F172A` | `#F8FAFC` |
| Text Secondary | `#64748B` | `#94A3B8` |
| Success | `#10B981` 🟢 | `#10B981` 🟢 |
| Error | `#EF4444` 🔴 | `#EF4444` 🔴 |

The app uses `AppCustomColors` via `ThemeExtension` for semantic colors and Google Fonts (`Inter`, `Playfair Display`, `Poppins`) for typography.

---

## 🌍 Localization

| Language | File | Direction |
|---|---|---|
| English | `lib/core/l10n/app_en.arb` | LTR → |
| Arabic | `lib/core/l10n/app_ar.arb` | ← RTL |

Language preference is persisted to a local SQLite database and restored on app launch. Switching languages is available from **Profile → Languages**.

---

## 🔐 Security

- **Tokens** are stored in iOS Keychain / Android Keystore via `flutter_secure_storage`
- **Auth interceptor** injects `Bearer` tokens into every request automatically  
- **Token refresh** is handled transparently by a custom `Authenticator` on 401 responses  
- **Fresh-install detection** uses a file marker in the Documents directory to wipe stale Keychain data after iOS reinstalls  
- Sensitive user data is cached locally in encrypted storage for offline session restoration

---

## 🧪 Testing

```bash
flutter test
```

---

## 📄 License

This project is for educational and demonstration purposes.

---

<p align="center">
  Built with ❤️ using <a href="https://flutter.dev">Flutter</a>
</p>
