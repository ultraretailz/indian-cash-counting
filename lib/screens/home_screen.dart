import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/customer.dart';
import 'customer_entry_screen.dart';
import 'payment_entry_screen.dart';
import 'transactions_screen.dart';
import 'customers_screen.dart';
import 'cash_counter_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseService _dbService = DatabaseService();
  int _selectedIndex = 0;

  late List<Widget> screens;

  @override
  void initState() {
    super.initState();
    screens = [
      const DashboardTab(),
      const CashCounterScreen(),
      const PaymentEntryScreen(),
      const TransactionsScreen(),
      const CustomersScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Count Cash',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Payment',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Customers',
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class DashboardTab extends StatefulWidget {
  const DashboardTab({Key? key}) : super(key: key);

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  final DatabaseService _dbService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Indian Cash Counting'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: Future.wait([
          _dbService.getAllCustomers(),
          _dbService.getAllTransactions(),
        ]),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final customers = snapshot.data![0] as List<Customer>;
          final transactions = snapshot.data![1] as List;

          double totalCash = 0;
          double totalOnline = 0;
          double totalOther = 0;

          for (var txn in transactions) {
            totalCash += txn.cashAmount;
            totalOnline += txn.onlineAmount;
            totalOther += txn.otherAmount;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  'Quick Stats',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    StatCard(
                      title: 'Total Customers',
                      value: customers.length.toString(),
                      color: Colors.blue,
                      icon: Icons.people,
                    ),
                    StatCard(
                      title: 'Total Transactions',
                      value: transactions.length.toString(),
                      color: Colors.green,
                      icon: Icons.history,
                    ),
                    StatCard(
                      title: 'Cash',
                      value: '₹${totalCash.toStringAsFixed(0)}',
                      color: Colors.orange,
                      icon: Icons.money,
                    ),
                    StatCard(
                      title: 'Online',
                      value: '₹${totalOnline.toStringAsFixed(0)}',
                      color: Colors.purple,
                      icon: Icons.credit_card,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Quick Actions',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CustomerEntryScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.person_add),
                        label: const Text('Add Customer'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PaymentEntryScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add_circle),
                        label: const Text('Add Payment'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const StatCard({
    Key? key,
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
