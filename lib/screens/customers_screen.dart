import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/customer.dart';
import '../models/transaction.dart';
import '../utils/helpers.dart';
import 'customer_entry_screen.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({Key? key}) : super(key: key);

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  final DatabaseService _dbService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
      ),
      body: FutureBuilder<List<Customer>>(
        future: _dbService.getAllCustomers(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final customers = snapshot.data!;

          if (customers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('No customers yet'),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CustomerEntryScreen(),
                        ),
                      ).then((_) {
                        setState(() {});
                      });
                    },
                    icon: const Icon(Icons.person_add),
                    label: const Text('Add Customer'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: customers.length,
            itemBuilder: (context, index) {
              return CustomerCard(
                customer: customers[index],
                dbService: _dbService,
                onUpdate: () {
                  setState(() {});
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CustomerEntryScreen(),
            ),
          ).then((_) {
            setState(() {});
          });
        },
        child: const Icon(Icons.person_add),
      ),
    );
  }
}

class CustomerCard extends StatefulWidget {
  final Customer customer;
  final DatabaseService dbService;
  final VoidCallback onUpdate;

  const CustomerCard({
    Key? key,
    required this.customer,
    required this.dbService,
    required this.onUpdate,
  }) : super(key: key);

  @override
  State<CustomerCard> createState() => _CustomerCardState();
}

class _CustomerCardState extends State<CustomerCard> {
  late Future<List<Transaction>> _transactionsFuture;

  @override
  void initState() {
    super.initState();
    _transactionsFuture =
        widget.dbService.getTransactionsByCustomer(widget.customer.id);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: FutureBuilder<List<Transaction>>(
        future: _transactionsFuture,
        builder: (context, snapshot) {
          final transactions = snapshot.data ?? [];
          final totalCash =
              transactions.fold(0.0, (sum, t) => sum + t.cashAmount);
          final totalOnline =
              transactions.fold(0.0, (sum, t) => sum + t.onlineAmount);
          final totalOther =
              transactions.fold(0.0, (sum, t) => sum + t.otherAmount);
          final totalAmount = totalCash + totalOnline + totalOther;

          return ExpansionTile(
            title: Text(
              widget.customer.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(widget.customer.phone),
            trailing: PopupMenuButton(
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                PopupMenuItem(
                  onTap: () {
                    widget.dbService.deleteCustomer(widget.customer.id);
                    widget.onUpdate();
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete'),
                    ],
                  ),
                ),
              ],
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.customer.address != null &&
                        widget.customer.address!.isNotEmpty) ...[
                      const Text(
                        'Address:',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(widget.customer.address!),
                      const SizedBox(height: 12),
                    ],
                    const Text(
                      'Payment Summary:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Transactions:'),
                        Text(
                          transactions.length.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Cash:'),
                        Text(
                          formatCurrency(totalCash),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Online:'),
                        Text(
                          formatCurrency(totalOnline),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Other:'),
                        Text(
                          formatCurrency(totalOther),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          formatCurrency(totalAmount),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
