# Features Documentation - Indian Cash Counting App

## Overview

The Indian Cash Counting App is a Flutter-based mobile application designed for retail businesses to manage customer payments, track cash transactions, and maintain a complete payment history.

## Main Features

### 1. **Dashboard (Home Screen)**

**Purpose:** Quick overview of business statistics and easy access to main features.

**Displays:**
- Total number of customers
- Total number of transactions
- Total cash received
- Total online payments received
- Total other payments

**Quick Actions:**
- Add New Customer button
- Add Payment button

**Benefits:**
- Get instant insights into daily business
- Quick access to frequently used features

---

### 2. **Cash Counter Screen**

**Purpose:** Accurately count and calculate total cash using Indian currency denominations.

**Supported Denominations:**
- ₹2000 note
- ₹500 note
- ₹200 note
- ₹100 note
- ₹50 note
- ₹20 note
- ₹10 note
- ₹5 note
- ₹2 coin
- ₹1 coin

**How to Use:**

1. **Enter Cash Count:**
   - For each denomination, enter the number of notes/coins
   - Use + button to increment or - button to decrement
   - Or type directly in the count field

2. **View Total:**
   - Real-time display of total amount calculated
   - Formatted in Indian rupees (₹)

3. **Actions:**
   - Reset all counts to start fresh
   - Use this amount in payment entry

**Example:**
```
If you have:
- 2 × ₹2000 notes = ₹4000
- 3 × ₹500 notes = ₹1500
- 5 × ₹100 notes = ₹500
Total = ₹6000
```

**Features:**
- Real-time calculation
- Quick increment/decrement buttons
- Manual count entry
- Clear display of subtotals
- Reset functionality

---

### 3. **Customer Management**

#### 3.1 **Add New Customer**

**Purpose:** Register and maintain a database of your customers.

**Required Information:**
- Customer Name *(required)*
- Phone Number *(required - minimum 10 digits)*
- Address *(optional)*

**How to Add:**

1. Navigate to "Customers" tab
2. Click "Add Customer" button (+ button in FAB)
3. Fill in customer details
4. Tap "Save Customer"

**Validation:**
- Name cannot be empty
- Phone number must be at least 10 digits
- Phone number must be valid format

**Benefits:**
- Maintain complete customer database
- Quick lookup of customer information
- Payment history tracking

#### 3.2 **View Customer List**

**Purpose:** See all registered customers with their payment summaries.

**Information Displayed:**
- Customer name
- Phone number
- Total transactions made
- Total cash received
- Total online payments
- Total other payments
- Grand total from customer

**How to Use:**

1. Go to "Customers" tab
2. View all customers in list
3. Tap on any customer to expand details
4. See payment breakdown:
   - Cash: amount in orange
   - Online: amount in purple
   - Other: amount in teal
   - Total: amount in blue

**Delete Customer:**
- Click the three-dot menu on customer card
- Select "Delete"
- Customer and all associated transactions are removed

---

### 4. **Payment Entry**

**Purpose:** Record customer payments with multiple payment modes.

**Payment Modes:**
- Cash payment
- Online payment (UPI, Bank Transfer, Card)
- Other payment methods

**Fields:**

1. **Customer Selection:**
   - Dropdown to select customer
   - Must select a customer before saving

2. **Payment Amounts:**
   - Cash Amount (₹)
   - Online Amount (₹)
   - Other Amount (₹)
   - All fields required (can be 0)

3. **Total Display:**
   - Automatically calculated
   - Shows sum of all payment modes
   - Color-coded (Blue for emphasis)

4. **Items Sold:**
   - Description of items sold
   - Optional but recommended
   - Example: "5kg Rice, 2L Milk, 500g Sugar"

5. **Description:**
   - Additional notes or remarks
   - Optional field
   - Example: "Paid after 10 days credit"

**How to Add Payment:**

1. Go to "Payment" tab
2. Select customer from dropdown
3. Enter amounts for each payment mode
4. Enter items sold (optional)
5. Add description (optional)
6. Tap "Save Payment"

**Example Entry:**
```
Customer: Rajesh Kumar
Cash: ₹500
Online: ₹1000
Other: ₹0
Total: ₹1500
Items: Groceries, 5kg Rice
```

**Validation:**
- Customer must be selected
- All amount fields must have valid numbers
- Empty amounts default to 0

**Reset:**
- Click "Reset" button to clear all fields
- Useful for quick sequential entries

---

### 5. **Transaction History**

**Purpose:** View all payment transactions with filtering and detailed information.

**Default View:**
- All transactions sorted by date (newest first)
- Each transaction shows:
  - Customer name
  - Transaction date and time
  - Options menu (delete)

**Expand Transaction Details:**
- Click on any transaction to expand
- View detailed breakdown:
  - Cash amount
  - Online amount
  - Other amount
  - Grand total
  - Items sold
  - Description
  - Date and time

#### 5.1 **Filter by Date**

**Single Date Filter:**
1. Tap filter icon (funnel icon)
2. Select "By Single Date"
3. Choose date from calendar
4. Transactions for that date are displayed

**Example:** View all payments made on 15-May-2024

**Date Range Filter:**
1. Tap filter icon
2. Select "By Date Range"
3. Choose start date
4. Choose end date
5. Transactions within range are displayed

**Example:** View payments from 1-May-2024 to 31-May-2024

#### 5.2 **View All Transactions**

1. Tap filter icon
2. Select "All Transactions"
3. All transactions are displayed

**Clear Filters:**
- "Clear" button appears when filters are active
- Tap to remove filter and see all transactions

#### 5.3 **Delete Transaction**

1. Expand the transaction
2. Click three-dot menu on right
3. Select "Delete"
4. Transaction is permanently removed

**Note:** Cannot undo deletion

---

### 6. **Reporting & Analysis**

#### 6.1 **Customer-wise Summary**

**Access:** Go to "Customers" tab

**Information:**
- Customer name and contact
- Number of transactions
- Total cash received from customer
- Total online payment from customer
- Total other payment from customer
- Grand total amount

**Use Cases:**
- Check total credit given to customer
- See preferred payment method
- Track customer payment patterns

**Example:**
```
Customer: Rajesh Kumar
Transactions: 12
Cash: ₹5000
Online: ₹2000
Other: ₹500
Total: ₹7500
```

#### 6.2 **Date-wise Summary**

**Access:** Go to "History" tab, use filters

**Shows:**
- All transactions on selected date
- Customer name and payment breakdown
- Items sold and description

**Use Cases:**
- View daily sales and collections
- Reconcile daily cash
- Generate daily report

#### 6.3 **Payment Mode Analysis**

**View in:**
1. Dashboard (total cash vs online)
2. Transaction history (each transaction breakdown)
3. Customer page (payment mode summary)

**Information:**
- Cash: Orange color
- Online: Purple color
- Other: Teal color
- Total: Blue color

---

## Data Management

### Database Storage

**Location:**
- Android: `/data/data/com.example.indian_cash_counting/databases/cash_counting.db`
- iOS: App Documents directory
- Data automatically synced to app

**Tables:**

1. **Customers Table:**
   - ID: Unique identifier
   - Name: Customer name
   - Phone: Contact number
   - Address: Address (optional)
   - Created At: Registration date

2. **Transactions Table:**
   - ID: Transaction identifier
   - Customer ID: Link to customer
   - Cash Amount: Cash payment
   - Online Amount: Online payment
   - Other Amount: Other payment
   - Description: Notes
   - Items Sold: What was sold
   - Transaction Date: Date and time

### Data Security

- Local storage on device
- SQLite encrypted database
- No internet required (offline-first)
- No cloud backup (privacy-focused)

### Data Export

**Note:** Current version stores data locally. Future versions may add:
- CSV export
- PDF reports
- Cloud backup
- Email receipts

---

## User Workflows

### Workflow 1: New Customer Payment Entry

```
1. Customer arrives
2. [Customers tab] → Add Customer
3. Enter: Name, Phone, Address
4. Save Customer
5. [Payment tab] → Select customer
6. Enter: Cash, Online, Other amounts
7. Enter: Items sold details
8. Save Payment
9. Payment recorded
```

### Workflow 2: End of Day Reconciliation

```
1. [History tab] → Filter by date (today)
2. View all transactions for today
3. Check cash vs online breakdown
4. [Dashboard] → Review stats
5. Verify total matches cash count
6. [Cash Counter] → Count actual cash
7. Compare with recorded amount
```

### Workflow 3: Customer Credit Tracking

```
1. [Customers tab]
2. Find customer → Expand
3. View total amount due
4. Check payment breakdown
5. See if customer owes money
```

### Workflow 4: Monthly Review

```
1. [History tab] → Filter by date range
2. Set: Start = 1st of month, End = Last day
3. View all transactions for month
4. Analyze payment trends
5. See which customers paid
6. [Dashboard] → Overall monthly stats
```

---

## Tips & Best Practices

### Payment Entry Tips

1. **Always add items sold** - Helps track inventory and sales
2. **Add descriptions** - For future reference of payment terms
3. **Save immediately** - Don't lose transaction data
4. **Verify totals** - Check amount before saving

### Customer Management Tips

1. **Use complete names** - For easy identification
2. **Verify phone numbers** - For contacting customers
3. **Add address** - For delivery or reference
4. **Review regularly** - Check customer payment history

### Cash Counting Tips

1. **Count at end of day** - Keep running totals updated
2. **Use denominations** - More accurate than rough estimates
3. **Double-check** - Count twice for accuracy
4. **Record immediately** - Don't rely on memory

### Reporting Tips

1. **Daily review** - Check transactions daily
2. **Weekly analysis** - Review customer payments
3. **Monthly summary** - Identify trends
4. **Export data** - Keep backup copies

---

## Troubleshooting

### Issue: Customer not appearing in dropdown

**Solution:**
- Ensure customer was saved successfully
- Refresh app (close and reopen)
- Add customer again if needed

### Issue: Transaction not saved

**Solution:**
- Check all required fields filled
- Verify customer was selected
- Check amount format (numbers only)
- Try saving again

### Issue: Date filter not working

**Solution:**
- Select valid dates
- End date should be after start date
- Try different dates
- Restart app

### Issue: Can't delete customer

**Solution:**
- Only customers with valid ID can be deleted
- Confirm deletion in popup
- Data is permanently removed

---

## Feature Summary

| Feature | Purpose | Access | Status |
|---------|---------|--------|--------|
| Dashboard | Quick stats | Home tab | ✓ Active |
| Cash Counter | Count denominations | Count Cash tab | ✓ Active |
| Customer Add | Register customers | Customers tab | ✓ Active |
| Payment Entry | Record payments | Payment tab | ✓ Active |
| Transaction History | View transactions | History tab | ✓ Active |
| Customer Summary | Customer report | Customers tab | ✓ Active |
| Date Filter | Filter by date | History tab | ✓ Active |
| Date Range Filter | Filter by range | History tab | ✓ Active |

---

## Version Information

- **App Version:** 1.0.0
- **Build Number:** 1
- **Platform:** Android, iOS, Web
- **Flutter SDK:** >= 2.19.0
- **Database:** SQLite 3

---

For more help, visit: https://github.com/ultraretailz/indian-cash-counting
