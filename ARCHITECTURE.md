# Technical Architecture - Indian Cash Counting App

## Technology Stack

### Frontend
- **Framework:** Flutter 2.19.0+
- **UI Framework:** Material 3
- **Language:** Dart

### Backend
- **Database:** SQLite 3 (Local)
- **ORM/Access:** Direct SQLite queries via sqflite

### Build & Deployment
- **Build Tool:** Flutter/Gradle (Android)
- **Target Platforms:** Android 21+, iOS 11+, Web
- **Package Manager:** Dart Pub

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                        UI Layer (Screens)                   │
│  ┌────────────────────────────────────────────────────────┐ │
│  │ Home Screen │ Cash Counter │ Payment │ History │ Customers │
│  └────────────────────────────────────────────────────────┘ │
└────────────────────────────┬────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                  Business Logic Layer                       │
│  ┌────────────────────────────────────────────────────────┐ │
│  │            DatabaseService                             │ │
│  │  • CRUD Operations                                     │ │
│  │  • Query Filtering                                     │ │
│  │  • Date-based Filtering                                │ │
│  └────────────────────────────────────────────────────────┘ │
└────────────────────────────┬────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                      Data Layer                             │
│  ┌────────────────────────────────────────────────────────┐ │
│  │           SQLite Database (Local)                      │ │
│  │  ┌─────────────────┐  ┌──────────────────────┐        │ │
│  │  │ Customers Table │  │ Transactions Table   │        │ │
│  │  │ - id            │  │ - id                 │        │ │
│  │  │ - name          │  │ - customerId (FK)    │        │ │
│  │  │ - phone         │  │ - cashAmount         │        │ │
│  │  │ - address       │  │ - onlineAmount       │        │ │
│  │  │ - createdAt     │  │ - otherAmount        │        │ │
│  │  │                 │  │ - itemsSold          │        │ │
│  │  │                 │  │ - description        │        │ │
│  │  │                 │  │ - transactionDate    │        │ │
│  │  └─────────────────┘  └──────────────────────┘        │ │
│  └────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

## Project Structure

```
indian-cash-counting/
├── lib/
│   ├── main.dart                          # App entry point
│   ├── models/                            # Data models
│   │   ├── customer.dart                  # Customer model
│   │   ├── transaction.dart               # Transaction model
│   │   └── denomination.dart              # Currency denomination
│   ├── screens/                           # UI screens
│   │   ├── home_screen.dart               # Dashboard
│   │   ├── cash_counter_screen.dart       # Cash counting
│   │   ├── customer_entry_screen.dart     # Add customer
│   │   ├── payment_entry_screen.dart      # Add payment
│   │   ├── transactions_screen.dart       # View history
│   │   └── customers_screen.dart          # Manage customers
│   ├── services/                          # Business logic
│   │   └── database_service.dart          # Database operations
│   ├── utils/                             # Utilities
│   │   ├── helpers.dart                   # Helper functions
│   │   └── constants.dart                 # Constants (denominations)
│   └── widgets/                           # Reusable widgets
├── android/                               # Android-specific code
│   ├── app/
│   │   ├── build.gradle
│   │   ├── proguard-rules.pro
│   │   └── src/main/
│   │       ├── AndroidManifest.xml
│   │       └── kotlin/
│   └── build.gradle
├── ios/                                   # iOS-specific code
├── web/                                   # Web version
│   ├── index.html
│   └── manifest.json
├── assets/                                # Images, fonts, etc.
├── pubspec.yaml                           # Dependencies
├── README.md                              # User guide
├── BUILDING.md                            # Build instructions
├── FEATURES.md                            # Feature documentation
└── ARCHITECTURE.md                        # This file
```

## Data Models

### Customer Model

```dart
class Customer {
  final String id;                    // Unique UUID
  final String name;                  // Customer name
  final String phone;                 // Contact number
  final String? address;              // Optional address
  final DateTime createdAt;           // Registration date
}
```

**JSON Representation:**
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "name": "Rajesh Kumar",
  "phone": "9876543210",
  "address": "123 Main Street",
  "createdAt": "2024-05-16T10:30:00Z"
}
```

### Transaction Model

```dart
class Transaction {
  final String id;                    // Unique UUID
  final String customerId;            // FK to Customer
  final double cashAmount;            // Cash payment
  final double onlineAmount;          // Online payment
  final double otherAmount;           // Other payment
  final String description;           // Notes
  final String itemsSold;             // Items description
  final DateTime transactionDate;     // Date and time
  
  // Computed property
  double get totalAmount => 
    cashAmount + onlineAmount + otherAmount;
}
```

**JSON Representation:**
```json
{
  "id": "650e8400-e29b-41d4-a716-446655440001",
  "customerId": "550e8400-e29b-41d4-a716-446655440000",
  "cashAmount": 500.0,
  "onlineAmount": 1000.0,
  "otherAmount": 0.0,
  "description": "Paid after 10 days credit",
  "itemsSold": "5kg Rice, 2L Milk",
  "transactionDate": "2024-05-16T14:25:00Z"
}
```

### Denomination Model

```dart
class Denomination {
  final int value;                    // Note/coin value (₹)
  int count;                          // Number of pieces
  
  // Computed property
  double get total => value * count;  // Total amount
}
```

**Example:**
```dart
Denomination(value: 500, count: 3)   // 3 × ₹500 notes = ₹1500
```

## Database Schema

### Customers Table

```sql
CREATE TABLE customers (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  phone TEXT NOT NULL,
  address TEXT,
  createdAt TEXT NOT NULL
)
```

**Indices:** id (primary key)

**Relationships:** One-to-many with transactions

### Transactions Table

```sql
CREATE TABLE transactions (
  id TEXT PRIMARY KEY,
  customerId TEXT NOT NULL,
  cashAmount REAL NOT NULL,
  onlineAmount REAL NOT NULL,
  otherAmount REAL NOT NULL,
  description TEXT NOT NULL,
  itemsSold TEXT NOT NULL,
  transactionDate TEXT NOT NULL,
  FOREIGN KEY (customerId) REFERENCES customers (id)
)
```

**Indices:** id (primary key), transactionDate

**Relationships:** Many-to-one with customers

## Database Service API

### DatabaseService Class

```dart
class DatabaseService {
  // Singleton pattern
  static final DatabaseService _instance = DatabaseService._internal();
  
  factory DatabaseService() {
    return _instance;
  }
  
  // Customer Operations
  Future<void> addCustomer(Customer customer)
  Future<List<Customer>> getAllCustomers()
  Future<Customer?> getCustomer(String id)
  Future<void> updateCustomer(Customer customer)
  Future<void> deleteCustomer(String id)
  
  // Transaction Operations
  Future<void> addTransaction(Transaction transaction)
  Future<List<Transaction>> getAllTransactions()
  Future<List<Transaction>> getTransactionsByCustomer(String customerId)
  Future<List<Transaction>> getTransactionsByDate(DateTime date)
  Future<List<Transaction>> getTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate
  )
  Future<void> deleteTransaction(String id)
}
```

### Usage Examples

```dart
// Add customer
final customer = Customer(
  id: generateId(),
  name: 'Rajesh Kumar',
  phone: '9876543210',
  address: '123 Main St',
  createdAt: DateTime.now(),
);
await dbService.addCustomer(customer);

// Add transaction
final txn = Transaction(
  id: generateId(),
  customerId: customerId,
  cashAmount: 500,
  onlineAmount: 1000,
  otherAmount: 0,
  description: 'Payment received',
  itemsSold: '5kg Rice',
  transactionDate: DateTime.now(),
);
await dbService.addTransaction(txn);

// Query transactions by date
final txns = await dbService.getTransactionsByDate(DateTime.now());

// Get customer with all transactions
final customer = await dbService.getCustomer(customerId);
final txns = await dbService.getTransactionsByCustomer(customerId);
```

## State Management

**Current Approach:** StatefulWidget with setState()

**Pattern:**
```dart
class MyScreen extends StatefulWidget {
  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  // State variables
  final DatabaseService _dbService = DatabaseService();
  
  @override
  void initState() {
    // Initialize data
    _loadData();
  }
  
  void _loadData() {
    setState(() {
      // Update UI
    });
  }
  
  @override
  Widget build(BuildContext context) {
    // Build UI
  }
}
```

**Future Enhancement:** Consider Provider or Riverpod for better state management

## Navigation

**Navigation Pattern:** MaterialApp with named routes

**Current Routes:**
- `/` (Home/Dashboard)
- `/count-cash` (Cash Counter)
- `/add-payment` (Payment Entry)
- `/transactions` (History)
- `/customers` (Customer Management)
- `/add-customer` (Customer Entry)

**Navigation Example:**
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const PaymentEntryScreen(),
  ),
);

// Or with named routes (future):
Navigator.pushNamed(context, '/add-payment');
```

## Dependencies

### Core Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  sqflite: ^2.3.0          # SQLite database
  path: ^1.8.3              # File path utilities
  uuid: ^4.0.0              # UUID generation
  cupertino_icons: ^1.0.2   # iOS-style icons
```

### Why These Dependencies?

- **sqflite**: SQLite implementation for Flutter
  - Local data persistence
  - Secure and reliable
  - No internet required
  
- **path**: Cross-platform file path handling
  - Works on Android, iOS, Web
  - Handles path separators correctly
  
- **uuid**: Generate unique identifiers
  - Unique customer and transaction IDs
  - No server required
  - Works offline

## Build Process

### Android Build

```
1. flutter build apk --release
2. Runs Gradle build
3. Compiles Dart to native code
4. Packages resources
5. Creates .apk file
6. Signs with debug keystore
```

**Output:** `build/app/outputs/flutter-apk/app-release.apk`

### iOS Build

```
1. flutter build ios --release
2. Compiles Swift/Objective-C
3. Compiles Dart code
4. Links frameworks
5. Creates .app bundle
```

**Output:** `build/ios/iphoneos/Runner.app`

### Web Build

```
1. flutter build web --release
2. Compiles Dart to JavaScript
3. Optimizes with minification
4. Creates web assets
5. Ready for deployment
```

**Output:** `build/web/`

## Performance Considerations

### Database Performance

- **Indexing:** Date-based queries use indices for fast lookups
- **Query Optimization:** Only fetch needed fields
- **Pagination:** Future enhancement for large datasets

### UI Performance

- **ListView Builder:** Efficient list rendering
- **Lazy Loading:** Data loaded on demand
- **State Updates:** Only rebuild necessary widgets

### Memory Management

- **Singleton Pattern:** Single database connection
- **Resource Cleanup:** Proper disposal of controllers
- **Garbage Collection:** Automatic via Dart VM

## Security Considerations

### Data Security

- **Local Storage:** Data stored locally on device
- **No Network:** No internet required, no data transmission
- **Encryption:** SQLite supports encryption (future enhancement)
- **Permissions:** Minimal app permissions required

### Input Validation

- **Customer Input:** Name validation, phone format
- **Payment Input:** Amount format validation
- **Database:** Foreign key constraints

## Error Handling

### Exception Handling

```dart
try {
  await dbService.addCustomer(customer);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Customer added successfully')),
  );
} catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Error: $e')),
  );
}
```

### Validation

```dart
if (value?.isEmpty ?? true) {
  return 'This field is required';
}
if (double.tryParse(value!) == null) {
  return 'Please enter a valid number';
}
```

## Testing Strategy

### Unit Tests (Future)
- Model serialization/deserialization
- Calculation logic
- Validation functions

### Widget Tests (Future)
- Screen UI rendering
- User interactions
- Navigation

### Integration Tests (Future)
- End-to-end flows
- Database operations
- Multiple screen interactions

## Future Enhancements

### Version 2.0 Features
- Cloud backup (Firebase)
- CSV/PDF export
- Multi-user support
- Advanced analytics
- Receipt printing
- Invoice generation
- Mobile payment integration

### Performance Improvements
- Provider/Riverpod state management
- Database pagination
- Image caching
- Code generation (build_runner)

### Security Features
- SQLite encryption
- Biometric authentication
- Data backup encryption
- Secure deletion

## Deployment

### Google Play Store
1. Create developer account ($25 one-time)
2. Sign APK with release keystore
3. Create app bundle (AAB)
4. Upload to Play Console
5. Fill store listing
6. Submit for review

### Alternative Stores
- F-Droid (Open source)
- APKPure
- Huawei AppGallery

### Direct Distribution
- Host APK on website
- Share via cloud storage
- In-app update mechanism

## Monitoring & Analytics (Future)

- Firebase Analytics
- Crash reporting
- User engagement tracking
- Performance monitoring

## Documentation

- **README.md**: User guide and quick start
- **BUILDING.md**: Build and deployment guide
- **FEATURES.md**: Feature documentation
- **ARCHITECTURE.md**: Technical architecture (this file)

---

## Quick Reference

### Key Files

| File | Purpose |
|------|---------|
| `lib/main.dart` | App entry point |
| `lib/services/database_service.dart` | Database operations |
| `lib/screens/home_screen.dart` | Dashboard |
| `pubspec.yaml` | Dependencies and configuration |
| `android/app/build.gradle` | Android build configuration |

### Key Classes

| Class | Purpose |
|-------|---------|
| `CashCountingApp` | App widget |
| `HomeScreen` | Dashboard screen |
| `DatabaseService` | Database operations |
| `Customer` | Customer model |
| `Transaction` | Transaction model |

### Key Functions

| Function | Purpose |
|----------|---------|
| `generateId()` | Generate unique ID |
| `formatCurrency()` | Format number as currency |
| `formatDate()` | Format DateTime as date |
| `formatDateTime()` | Format DateTime with time |

---

For more information, see README.md, BUILDING.md, and FEATURES.md
