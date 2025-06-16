# 🚀 SubReach - Social Media Growth Platform

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![Next.js](https://img.shields.io/badge/Next.js-000000?style=for-the-badge&logo=nextdotjs&logoColor=white)
![TypeScript](https://img.shields.io/badge/TypeScript-007ACC?style=for-the-badge&logo=typescript&logoColor=white)
![Stripe](https://img.shields.io/badge/Stripe-008CDD?style=for-the-badge&logo=stripe&logoColor=white)

*Empowering content creators to grow their audience through authentic engagement*

</div>

## 📱 About SubReach

SubReach is a comprehensive social media growth platform that connects content creators with their audience through authentic engagement strategies. The platform enables creators to increase their reach, manage campaigns, and monetize their content through a points-based engagement system.

### ✨ Key Features

- 🎯 **Smart Campaign Management**: Create and manage targeted engagement campaigns
- 💰 **Points-Based Economy**: Earn and spend points for authentic interactions
- 📊 **Analytics Dashboard**: Track performance and growth metrics
- 🔔 **Real-time Notifications**: Stay updated with campaign progress
- 💳 **Secure Payments**: Integrated Stripe payment processing
- 👑 **VIP Membership**: Premium features for power users
- 📱 **Cross-Platform**: Mobile app and web dashboard

## 🏗️ Architecture

SubReach consists of two main components:

### 📱 Mobile Application (Flutter)
- **Framework**: Flutter with Dart
- **State Management**: Riverpod
- **Backend**: Firebase (Auth, Firestore, Storage, Messaging)
- **Payments**: Stripe integration
- **Authentication**: Google Sign-In & Firebase Auth

### 🌐 Admin Dashboard (Next.js)
- **Framework**: Next.js with TypeScript
- **UI Library**: Material-UI (MUI) + Tailwind CSS
- **Database**: Vercel Postgres
- **Analytics**: Custom dashboard with real-time metrics

## 🚀 Quick Start

### Prerequisites

- **Flutter SDK** (>= 3.5.4)
- **Node.js** (>= 18.0.0)
- **Firebase Account** with project setup
- **Stripe Account** for payment processing

### 📱 Mobile App Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/ramezlahzy/SubReach.git
   cd SubReach/SubReach
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Update `firebase_options.dart` with your configuration

4. **Configure Stripe**
   - Replace the publishable key in `main.dart` with your Stripe key

5. **Run the application**
   ```bash
   flutter run
   ```

### 🌐 Dashboard Setup

1. **Navigate to dashboard directory**
   ```bash
   cd nextjs-dashboard
   ```

2. **Install dependencies**
   ```bash
   npm install
   # or
   pnpm install
   ```

3. **Environment setup**
   ```bash
   cp .env.example .env.local
   # Configure your environment variables
   ```

4. **Run development server**
   ```bash
   npm run dev
   # or
   pnpm dev
   ```

   Visit [http://localhost:3000](http://localhost:3000) to access the dashboard.

## 📁 Project Structure

```
SubReach/
├── SubReach/                 # Flutter Mobile Application
│   ├── lib/
│   │   ├── screens/         # UI Screens
│   │   ├── services/        # API & Firebase Services
│   │   ├── providers/       # Riverpod State Management
│   │   ├── shared_widgets/  # Reusable Components
│   │   └── theme.dart       # App Theming
│   ├── android/             # Android Configuration
│   ├── ios/                 # iOS Configuration
│   └── pubspec.yaml         # Dependencies
│
├── nextjs-dashboard/        # Next.js Admin Dashboard
│   ├── app/                 # App Router Pages
│   ├── components/          # React Components
│   ├── lib/                 # Utility Functions
│   ├── models/              # Data Models
│   └── package.json         # Dependencies
│
└── README.md               # Project Documentation
```

## 🔧 Core Technologies

### Mobile Stack
- **Flutter & Dart**: Cross-platform mobile development
- **Firebase Suite**: Authentication, Firestore, Cloud Storage, Push Notifications
- **Riverpod**: Reactive state management
- **Stripe Flutter**: Payment processing
- **YouTube Player**: Video content integration

### Web Stack
- **Next.js**: React framework with server-side rendering
- **TypeScript**: Type-safe development
- **Material-UI**: Modern React component library
- **Tailwind CSS**: Utility-first CSS framework
- **Vercel Postgres**: Serverless database

## 🎯 Features Deep Dive

### 📊 Campaign Management
- Create targeted engagement campaigns
- Set campaign budgets and durations
- Track real-time campaign performance
- Automated campaign optimization

### 💰 Points Economy
- Earn points through authentic engagement
- Spend points to boost your content
- Transparent point transaction history
- Fair distribution algorithms

### 👑 VIP Membership
- Priority campaign placement
- Advanced analytics access
- Exclusive features and tools
- Dedicated customer support

### 📈 Analytics Dashboard
- Real-time engagement metrics
- Audience demographics analysis
- Campaign ROI tracking
- Growth trend visualization

## 🔐 Security Features

- **Firebase Security Rules**: Secure database access
- **Authentication**: Multi-provider auth (Google, Email)
- **Payment Security**: PCI-compliant Stripe integration
- **Data Encryption**: End-to-end data protection

## 🌟 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Team

- **Lead Developer**: [Ramez Nashaat Lahzy](https://github.com/ramezlahzy)
- **Frontend Specialist**: [Mark Mahrous](https://github.com/MarkMahrous)

## 📞 Support

- 📧 **Email**: lahzyramez@gmail.com
- 🔗 **LinkedIn**: [Ramez Lahzy](https://linkedin.com/in/ramez-lahzy-37188021a/)
- 🐛 **Issues**: [GitHub Issues](https://github.com/ramezlahzy/SubReach/issues)

## 🚀 Deployment

### Mobile App
- **Android**: Build APK/AAB for Google Play Store
- **iOS**: Build IPA for Apple App Store

### Web Dashboard
- **Vercel**: Optimized for Next.js deployment
- **Custom**: Docker containerization available

---

<div align="center">

**Built with ❤️ by the SubReach Team**

[⭐ Star this repo](https://github.com/ramezlahzy/SubReach) | [🐛 Report Bug](https://github.com/ramezlahzy/SubReach/issues) | [💡 Request Feature](https://github.com/ramezlahzy/SubReach/issues)

</div>
