# Indian Cash Counting App

A Flutter application for managing cash payments, payment tracking, and customer management for retail businesses.

## Features

- **Cash Counter**: Calculate total cash amount using Indian currency denominations (₹1-₹2000)
- **Payment Entry**: Record payments from customers in multiple modes:
  - Cash
  - Online
  - Other payment methods
- **Customer Management**: 
  - Add and manage customers
  - Store customer details and contact information
  - View payment history per customer
- **Transaction History**:
  - View all transactions
  - Filter by date or date range
  - Track items sold
  - View payment breakdown by type
- **Reporting**:
  - Date-wise reporting
  - Customer-wise summaries
  - Payment mode analysis

## Getting Started

### Prerequisites
- Flutter SDK (>=2.19.0)
- Dart SDK

### Installation

1. Clone the repository:
```bash
git clone https://github.com/ultraretailz/indian-cash-counting.git
cd indian-cash-counting
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Building APK

To build a production APK:

```bash
flutter build apk --release
```

The APK will be generated at: `build/app/outputs/flutter-apk/app-release.apk`

For split APKs (if app is large):
```bash
flutter build apk --release --split-per-abi
```

## Project Structure

```
lib/
├── main.dart              # Main app entry point
├── models/                # Data models
│   ├── customer.dart
│   ├── transaction.dart
│   └── denomination.dart
├── screens/               # UI screens
│   ├── home_screen.dart
│   ├── cash_counter_screen.dart
│   ├── customer_entry_screen.dart
│   ├── payment_entry_screen.dart
│   ├── transactions_screen.dart
│   └── customers_screen.dart
├── services/              # Business logic
│   └── database_service.dart
└── utils/                 # Utility functions
    ├── helpers.dart
    └── constants.dart
```

## Database

The app uses SQLite for local data persistence with two main tables:
- `customers`: Stores customer information
- `transactions`: Stores payment transactions linked to customers

## App Screens

1. **Dashboard**: Quick stats and summary
2. **Cash Counter**: Calculate cash using denominations
3. **Payment Entry**: Record customer payments
4. **Transaction History**: View and filter transactions
5. **Customers**: Manage customer list and view customer summaries

## Dependencies

- `sqflite`: SQLite database
- `uuid`: Generate unique IDs
- `path`: File path utilities

## Features Implemented

✅ Cash counting with Indian denominations
✅ Customer management
✅ Multi-mode payment tracking
✅ Transaction history with filtering
✅ Date-wise reporting
✅ Customer payment summaries
✅ Items sold tracking
✅ Local SQLite database
✅ User-friendly UI

## Future Enhancements

- CSV/PDF export functionality
- Invoice generation
- Multi-user support
- Cloud backup
- Advanced analytics and charts
- Receipt printing

## License

This project is licensed under the MIT License - see LICENSE file for details.

## Contact

For support and queries, please visit: https://github.com/ultraretailz/indian-cash-counting