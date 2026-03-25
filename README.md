# Stock Market App

A comprehensive cross-platform Flutter application for stock market analysis, portfolio management, and financial news. Provides real-time market data, interactive charts, and personalized investment tracking across mobile, web, and desktop.

---

## Overview

The Stock Market App gives investors and traders a complete suite of tools in one clean, intuitive interface. Built with Flutter, it supports both light and dark themes and delivers a consistent experience across Android, iOS, Web, and Desktop.

---

## Screenshots

| Registration | Login | Home (Dark) |
|---|---|---|
| ![Registration](https://github.com/user-attachments/assets/7145f81b-6f2a-4cf5-80cc-c3b416715869) | ![Login](https://github.com/user-attachments/assets/9261b7d9-540b-4519-ae76-dfeb469056a3) | ![Home Dark](https://github.com/user-attachments/assets/b63153f3-6bbf-4f37-b6aa-93004e59ed85) |

| Home (Light) | Portfolio | Stock Detail |
|---|---|---|
| ![Home Light](https://github.com/user-attachments/assets/b4192c9d-adbc-45b1-8d1f-31061ff95ef2) | ![Portfolio](https://github.com/user-attachments/assets/c1eaf8a5-657d-4ed6-82e0-ab9daec93299) | ![Stock Detail](https://github.com/user-attachments/assets/f3fe798c-7698-4861-9c36-ba3e7f4196ae) |

| News Feed | Market Overview | Premium Plans |
|---|---|---|
| ![News](https://github.com/user-attachments/assets/26956ca4-8b52-4608-a020-206eb1a5c5e5) | ![Market](https://github.com/user-attachments/assets/db231847-745b-4f46-abb5-98531a3816f7) | ![Premium](https://github.com/user-attachments/assets/1b913c4b-acd6-422b-b03d-c358f7f82a21) |

---

## Features

### Authentication
- Email/password registration and login with form validation
- Google and Apple sign-in support
- Session management and automatic sign-out
- Secure local authentication using SharedPreferences

### Portfolio Management
- Real-time portfolio balance and performance tracking
- Holdings overview with detailed breakdowns and percentage gains
- Interactive portfolio summary with visual representations
- Stock position management and tracking

### Stock Market Data
- Real-time stock prices with interactive charts
- Multiple time range views per stock
- Market overview with tree map visualization
- Top gainers, losers, and most active stocks
- Company search functionality

### Financial News
- Curated news feed with category filtering (Monetary Policy, Technology, Global Markets, Energy)
- Market analysis and expert insights
- Full article view with source attribution and publication dates

### User Interface
- Light and dark theme support
- Modern Material Design
- Smooth animations and transitions
- Responsive layout for all screen sizes
- Bottom navigation with four main sections

### Cross-Platform Support
- Android and iOS mobile apps
- Web application with responsive design
- Desktop support for Windows, macOS, and Linux

---

## Architecture

The app follows a **Provider-based state management** pattern with a clean separation between data, business logic, and UI layers.

```
lib/
├── app/
│   ├── models/          # Data models — stocks, portfolio, news
│   ├── providers/       # State management — StockProvider, PortfolioProvider, NewsProvider, ThemeProvider
│   ├── screens/
│   │   ├── home/        # Dashboard and main screen
│   │   ├── portfolio/   # Portfolio management
│   │   ├── stocks/      # Market data and charts
│   │   ├── news/        # Financial news feed
│   │   ├── profile/     # User profile and settings
│   │   └── premium/     # Subscription and premium features
│   ├── services/        # API and Firebase communication layer
│   └── widgets/         # Reusable UI components
├── auth/                # Authentication screens and services
└── main.dart            # App entry point
```

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (Dart) |
| State Management | Provider |
| Authentication | Firebase Auth |
| Cloud Services | Firebase |
| Charts | FL Chart |
| Local Storage | SharedPreferences |
| Networking | HTTP |
| Location | Geolocator |

---

## Dependencies

```yaml
provider              # State management using the Provider pattern
fl_chart              # Interactive charts for stock price visualization
firebase_core         # Firebase initialization
firebase_auth         # User authentication and session management
shared_preferences    # Local storage for caching and offline support
http                  # RESTful API communication for market data
geolocator            # Location services for region-based data
url_launcher          # External link handling for news and resources
```

---

## Getting Started

### Prerequisites
- Flutter SDK 3.7.2+
- Dart SDK
- Node.js (for web components)
- Android Studio or Xcode (for mobile)

### Quick Setup

```bash
chmod +x setup.sh
./setup.sh
```

### Manual Setup

```bash
# 1. Clone the repository
git clone https://github.com/omar-radwan7/Stock_Market_App.git
cd Stock_Market_App

# 2. Install Flutter dependencies
flutter pub get

# 3. Install web dependencies
cd stock_market_website
npm install

# 4. Run the app
flutter run
```

### Makefile Commands

```bash
make help          # Show all available commands
make quick-start   # Setup and run in one step
make run           # Run mobile app
make run-web       # Run web version
make build-all     # Build for all platforms
make test          # Run tests
make clean         # Clean build artifacts
```

---

## Configuration

### Firebase Setup
1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Enable Authentication (Email/Password, Google, Apple)
3. Add your Android/iOS app and download the config files
4. Place `google-services.json` in `android/app/` and `GoogleService-Info.plist` in `ios/Runner/`

### Market Data API
- Configure your market data provider API key in the environment settings
- Ensure compliance with the provider's terms of service for real-time data usage

---

## Testing

```bash
# Unit tests
flutter test

# Widget tests
flutter test test/widget_test.dart

# Integration tests
flutter drive --target=test_driver/app.dart
```

---

## Web Application

The project includes a companion web app — **TradeWise Platform** — built with HTML, CSS, and JavaScript:

- Real-time stock data visualization
- Portfolio management dashboard
- Market research tools
- Responsive design for desktop and mobile browsers

---

## Security

- Firebase Authentication for secure user management
- Local data encryption for sensitive storage
- API key protection via environment configuration
- Input validation and sanitization throughout
- Secure HTTPS communication

---

## License

This project is developed for educational and demonstration purposes. Please ensure compliance with your financial data provider's terms of service when using real market data.

---

## Support

- Review the [Flutter documentation](https://flutter.dev/docs)
- Check the project issue tracker on GitHub
- Run `make help` for available CLI operations
