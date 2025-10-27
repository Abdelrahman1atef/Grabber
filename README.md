# 🍎 FreshFruits - Flutter Grocery Delivery App

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)
![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white)

*A modern, beautiful grocery delivery app built with Flutter*

[![GitHub stars](https://img.shields.io/github/stars/Abdelrahman1atef/freshfruits?style=social)](https://github.com/Abdelrahman1atef/freshfruits)
[![GitHub forks](https://img.shields.io/github/forks/Abdelrahman1atef/freshfruits?style=social)](https://github.com/Abdelrahman1atef/freshfruits)

</div>

---

## 📱 Screenshots

<div align="center">

### 🏠 Home Screen
<!-- Add your home screen screenshot here -->
<img src="screenshots/[home_screen.png](https://github.com/user-attachments/assets/b7818d7b-a8e5-4bff-aa64-0b68b0d2cf1f)" alt="Home Screen" width="200" style="border-radius: 20px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);">

### 🛒 Shopping Cart
<!-- Add your cart screen screenshot here -->
<img src="screenshots/[cart_screen.png](https://github.com/user-attachments/assets/8bf211f2-b2b5-4dc8-af66-0ce1329d086d)" alt="Cart Screen" width="200" style="border-radius: 20px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);">

### 💳 Checkout & Payment
<!-- Add your checkout/payment screenshots here -->
<img src="screenshots/checkout_screen.png" alt="[Checkout Screen](https://github.com/user-attachments/assets/0a43a1e6-042e-4021-8be5-7ba0d1583f08)" width="200" style="border-radius: 20px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);">
<img src="[screenshots/payment_screen.png](https://github.com/user-attachments/assets/d2a44976-da03-4838-85c4-fceeb389f9ae)" alt="Payment Screen" width="200" style="border-radius: 20px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);">

### 🗺️ Order Tracking
<!-- Add your order tracking/map screenshots here -->
<img src="screenshots/order_tracking.png" alt="Order Tracking" width="200" style="border-radius: 20px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);">

</div>

---

## ✨ Features

### 🛍️ **Shopping Experience**
- **Beautiful Product Catalog** - Browse fresh fruits and vegetables with high-quality images
- **Smart Categories** - Organized by product types (Fruits, Vegetables, Beverages, etc.)
- **Product Ratings** - See ratings and reviews from other customers
- **Real-time Inventory** - Live stock updates and availability

### 🛒 **Cart & Checkout**
- **Interactive Shopping Cart** - Add/remove items with smooth animations
- **Cart Persistence** - Your cart is saved across app sessions
- **Quantity Management** - Easy quantity adjustment with intuitive controls
- **Price Calculation** - Real-time total calculation with taxes

### 💳 **Payment Integration**
- **Multiple Payment Methods** - Credit cards, Apple Pay, Google Pay
- **Secure Payment Processing** - PCI-compliant payment handling
- **Custom Payment UI** - Beautiful, user-friendly payment forms
- **Payment Validation** - Real-time form validation and error handling

### 🗺️ **Order Tracking**
- **Real-time Order Tracking** - Track your delivery in real-time
- **Interactive Maps** - Google Maps integration with custom markers
- **Delivery Status Updates** - Get notified at each delivery stage
- **Estimated Delivery Time** - Accurate delivery time predictions

### 🎨 **User Experience**
- **Modern Material Design** - Clean, intuitive interface
- **Smooth Animations** - Delightful micro-interactions and transitions
- **Dark/Light Theme** - Adaptive theming support
- **Responsive Design** - Optimized for all screen sizes

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.9.2 or higher)
- Dart SDK
- Android Studio / VS Code
- iOS Simulator (for iOS development)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Abdelrahman1atef/Grabber.git
   cd Grabber
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate assets**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Build for Production

**Android APK:**
```bash
flutter build apk --release
```

**iOS App:**
```bash
flutter build ios --release
```

---

## 🏗️ Project Structure

```
lib/
├── core/                    # Core functionality
│   ├── common_widgets/     # Reusable UI components
│   ├── model/              # Data models
│   ├── routes/             # App routing
│   └── theme/              # App theming
├── features/               # Feature modules
│   ├── cart/               # Shopping cart
│   ├── checkout/           # Checkout process
│   ├── home/               # Home screen & products
│   ├── main/               # Main navigation
│   ├── order_map/          # Order tracking
│   ├── payment/            # Payment processing
│   └── splash/             # Splash screen
├── gen/                    # Generated files
└── utils/                  # Utility functions
```

---

## 🛠️ Tech Stack

### **Frontend**
- **Flutter** - Cross-platform mobile framework
- **Dart** - Programming language
- **Material Design** - UI/UX design system

### **State Management**
- **Bloc/Cubit** - Predictable state management
- **Freezed** - Code generation for immutable classes
- **Equatable** - Value equality

### **Maps & Location**
- **Google Maps Flutter** - Interactive maps
- **Location** - GPS location services
- **Polyline** - Route visualization

### **UI/UX Libraries**
- **Flutter Animate** - Smooth animations
- **Carousel Slider** - Image carousels
- **Shimmer** - Loading placeholders
- **Gap** - Spacing utilities

### **Code Generation**
- **Flutter Gen** - Asset generation
- **Build Runner** - Code generation tools

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  gap: ^2.0.0
  flutter_svg: ^2.0.0
  carousel_slider: ^4.0.0
  flutter_bloc: ^8.0.0
  bloc: ^8.0.0
  freezed: ^2.0.0
  equatable: ^2.0.0
  flutter_animate: ^4.0.0
  google_maps_flutter: ^2.0.0
  http: ^1.0.0
  polyline_codec: ^0.2.0
  flutter_polyline_points: ^2.0.0
  location: ^5.0.0
  intl: ^0.18.0
  shimmer: ^3.0.0
```

---

## 🎯 Key Features Implementation

### **Shopping Cart Management**
- Real-time cart updates using Bloc pattern
- Persistent cart state across app sessions
- Smooth add/remove animations

### **Payment Processing**
- Custom keyboard for secure input
- Credit card validation and formatting
- Multiple payment method support

### **Order Tracking**
- Real-time location updates
- Interactive map with custom markers
- Order status progression visualization

### **Product Management**
- Dynamic product loading
- Category-based filtering
- Rating and review system

---

## 🔧 Configuration

### **Google Maps Setup**
1. Get your Google Maps API key
2. Add it to `android/app/src/main/AndroidManifest.xml`
3. Configure in `ios/Runner/AppDelegate.swift`

### **Payment Integration**
1. Configure payment gateway credentials
2. Set up webhook endpoints
3. Test with sandbox environment

---

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test/

# Run tests with coverage
flutter test --coverage
```

---

## 📱 Platform Support

- ✅ **Android** (API 21+)
- ✅ **iOS** (iOS 11.0+)
- ✅ **Web** (Chrome, Safari, Firefox)
- ✅ **Desktop** (Windows, macOS, Linux)

---

## 🤝 Contributing

We welcome contributions! To get started:

1. Fork the repository: [https://github.com/Abdelrahman1atef/Grabber.git](https://github.com/Abdelrahman1atef/Grabber.git)
2. Create your feature branch:  
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. Commit your changes:  
   ```bash
   git commit -m "Describe your feature"
   ```
4. Push to your branch:  
   ```bash
   git push origin feature/your-feature-name
   ```
5. Open a Pull Request on GitHub against the main repository.

Thank you for contributing!

### **Development Guidelines**
- Follow Flutter/Dart style guidelines
- Write meaningful commit messages
- Add tests for new features
- Update documentation as needed

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

**Abdelrahman Atef**
- GitHub: [@Abdelrahman1atef](https://github.com/Abdelrahman1atef)
- LinkedIn: [Abdelrahman Atef](https://www.linkedin.com/in/abdelrahman-atef-b1a59b24a/)
- University: Mansura University
- Email: abdelrahman.atef@example.com

**About the Developer:**
Passionate mobile developer specializing in Android and Flutter development. Currently studying at Mansura University and building innovative mobile applications with clean architecture principles. Experienced in Java, Kotlin, Flutter, and Firebase integration.

---

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Google Maps for location services
- All contributors and testers
- Open source community

---

<div align="center">

**⭐ Star this repository if you found it helpful!**

Made with ❤️ using Flutter

</div>
