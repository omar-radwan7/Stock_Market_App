# Stock Market App

A comprehensive Flutter application for stock market analysis, portfolio management, and financial news. This cross-platform mobile and web application provides real-time market data, interactive charts, and personalized investment tracking.

---

## App Screenshots & Feature Walkthrough

Below are key sections of the app with screenshots and explanations:

### Registration Screen

![Registration Screen](screenshots/screen1.png)

New users can sign up using email/password or Google/Apple accounts. The form features validation for a secure onboarding experience.

---

### Login Screen

![Login Screen](screenshots/screen2.png)

Returning users log in securely with email/password or third-party providers. Error handling ensures smooth authentication.

---

### Home Dashboard (Dark Theme)

![Home Dashboard](screenshots/screen3.png)

Get an instant overview of portfolio performance, daily gain, and market movers. The dashboard provides quick access to your investment status.

---

### Home Dashboard (Light Theme)

![Home Dashboard Light](screenshots/screen4.png)

A visually appealing light mode for user preference. All essential market data and navigation remain accessible.

---

### Portfolio Screen

![Portfolio Screen](screenshots/screen5.png)

Track your holdings and overall portfolio value. Individual stock performance is visualized, making it easy to manage investments.

---

### Profile & Premium Membership

![Profile Screen](screenshots/screen6.png)

Manage your account settings and premium membership. Upgrade for advanced analytics and exclusive features.

---

### Financial News Feed

![Market News](screenshots/screen7.png)

Stay informed with curated financial news, market analysis, and insights. News articles are categorized for easy browsing.

---

### Live Market Overview

![Market Overview](screenshots/screen8.png)

Visualize sector performance and live market movements with interactive maps and summary charts.

---

### Premium Plans

![Premium Plans](screenshots/screen9.png)

Choose a subscription plan to unlock advanced analytics, enhanced watchlists, and priority support.

---

### Stock Detail View

![Stock Detail Screen](screenshots/screen10.png)

Dive deep into individual stocks: view price history, interactive charts, and key statistics across multiple time ranges.

---

## Overview

The Stock Market App is a modern financial application built with Flutter that offers a complete suite of tools for investors and traders. The application features a clean, intuitive interface with both light and dark themes, providing users with essential market information and portfolio management capabilities.

## Features

### Authentication System
- User registration and login with email and password
- Secure local authentication using SharedPreferences
- Session management and automatic sign-out functionality
- Form validation and error handling

### Portfolio Management
- Real-time portfolio balance tracking
- Investment holdings overview with detailed breakdowns
- Portfolio performance analytics and percentage gains
- Interactive portfolio summary with visual representations
- Stock position management and tracking

### Stock Market Data
- Real-time stock price information
- Interactive stock charts with multiple time ranges
- Market overview with tree map visualization
- Top gainers, losers, and most active stocks
- Stock detail screens with comprehensive information
- Search functionality for stocks and companies

### Financial News
- Curated financial news feed
- Market analysis and expert insights
- Category-based news organization (Monetary Policy, Technology, Global Markets, Energy)
- Detailed article views with full content
- News source attribution and publication dates

### Market Analysis
- Interactive tree map for market sector visualization
- Performance charts with FL Chart integration
- Market trend analysis and insights
- Sector-wise performance tracking

### User Interface
- Modern Material Design interface
- Light and dark theme support
- Responsive design for multiple screen sizes
- Smooth animations and transitions
- Intuitive bottom navigation with four main sections

### Cross-Platform Support
- Native Android and iOS applications
- Web application with responsive design
- Desktop support for Linux, macOS, and Windows
- Consistent user experience across all platforms

## Technical Architecture

### State Management
- Provider pattern for efficient state management
- Separate providers for stocks, portfolio, news, and theme
- Reactive UI updates based on data changes
- Centralized data flow and state handling

### Data Services
- RESTful API integration for real-time market data
- Local data caching and offline support
- Firebase integration for cloud services
- HTTP client for external API communication

### Dependencies
- **Flutter SDK**: Cross-platform development framework
- **Provider**: State management solution
- **FL Chart**: Interactive chart visualization
- **SharedPreferences**: Local data storage
- **Firebase**: Authentication and cloud services
- **HTTP**: API communication
- **Geolocator**: Location services
- **URL Launcher**: External link handling

## Project Structure

```
lib/
├── app/
│   ├── models/          # Data models for stocks, portfolio, news
│   ├── providers/       # State management providers
│   ├── screens/         # Application screens and pages
│   │   ├── home/        # Dashboard and main screen
│   │   ├── portfolio/   # Portfolio management
│   │   ├── stocks/      # Stock market data and charts
│   │   ├── news/        # Financial news feed
│   │   ├── profile/     # User profile management
│   │   └── premium/     # Premium features
│   ├── services/        # API and data services
│   └── widgets/         # Reusable UI components
├── auth/                # Authentication screens and services
└── main.dart           # Application entry point
```

## Web Application

The project includes a complementary web application built with HTML, CSS, and JavaScript:

- **TradeWise Platform**: Web-based trading interface
- Real-time stock data visualization
- Portfolio management dashboard
- Market research tools
- User profile management
- Responsive design for desktop and mobile browsers

## Installation and Setup

### Prerequisites
- Flutter SDK (version 3.7.2 or higher)
- Dart SDK
- Node.js (for web components)
- Android Studio or Xcode (for mobile development)

### Quick Setup
Run the automated setup script to install dependencies and configure the project:

```bash
chmod +x setup.sh
./setup.sh
```

### Manual Setup
1. Clone the repository
2. Install Flutter dependencies:
   ```bash
   flutter pub get
   ```
3. Install web dependencies:
   ```bash
   cd stock_market_website
   npm install
   ```

### Development Commands

The project includes a comprehensive Makefile for automation:

```bash
# Show all available commands
make help

# Quick start (setup and run)
make quick-start

# Run the application
make run

# Run web version
make run-web

# Build for all platforms
make build-all

# Run tests
make test

# Clean project
make clean
```

## Building and Deployment

### Mobile Applications
- **Android**: Generate APK or App Bundle for Google Play Store
- **iOS**: Build for App Store distribution (macOS required)

### Web Application
- Build optimized web version for deployment
- Serve locally for testing and development
- Deploy to web hosting services

### Desktop Applications
- Build native desktop apps for Windows, macOS, and Linux
- Cross-platform compatibility with platform-specific optimizations

## Configuration

### Environment Setup
- Configure Firebase project for authentication and cloud services
- Set up API keys for market data providers
- Configure build settings for different platforms

### Customization
- Modify theme colors and styling
- Add custom stock data sources
- Implement additional chart types and visualizations
- Extend news feed with custom sources

## Testing

The application includes comprehensive testing capabilities:
- Unit tests for business logic
- Widget tests for UI components
- Integration tests for user workflows
- Performance testing and optimization

## Performance Optimization

- Efficient state management with Provider
- Optimized chart rendering with FL Chart
- Lazy loading for large datasets
- Image caching and optimization
- Memory management and cleanup

## Security Features

- Secure authentication with Firebase
- Local data encryption
- API key protection
- Input validation and sanitization
- Secure communication protocols

## Future Enhancements

- Real-time push notifications
- Advanced charting tools
- Social trading features
- AI-powered market predictions
- Cryptocurrency support
- Advanced portfolio analytics
- Paper trading simulation
- Watchlist management
- Price alerts and notifications

## Contributing

This project follows Flutter best practices and includes:
- Comprehensive code documentation
- Consistent coding standards
- Modular architecture
- Error handling and logging
- Performance monitoring

## License

This project is developed for educational and demonstration purposes. Please ensure compliance with financial data provider terms of service when using real market data.

## Support

For technical support and questions:
- Review the Flutter documentation
- Check the project issue tracker
- Consult the Makefile help command for available operations
- Refer to the comprehensive code comments for implementation details
