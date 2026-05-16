import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/transaction.dart';
import '../models/customer.dart';
import '../utils/helpers.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final DatabaseService _dbService = DatabaseService();
  DateTime? _selectedDate;
  DateTime? _startDate;
  DateTime? _endDate;
  int _filterMode = 0; // 0: All, 1: Single date, 2: Date range

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter info
          if (_filterMode > 0)
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.blue.withOpacity(0.1),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _filterMode == 1
                          ? 'Filtered by: ${formatDate(_selectedDate!)}'
                          : 'Filtered by: ${formatDate(_startDate!)} to ${formatDate(_endDate!)}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _filterMode = 0;
                        _selectedDate = null;
                        _startDate = null;
                        _endDate = null;
                      });
                    },
                    child: const Text('Clear'),
                  ),
                ],
              ),
            ),
          // Transaction list
          Expanded(
            child: FutureBuilder(
              future: _getTransactions(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final transactions = snapshot.data as List<Transaction>;

                if (transactions.isEmpty) {
                  return Center(
                    child: Text(
                      _filterMode > 0
                          ? 'No transactions found for selected period'
                          : 'No transactions yet',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    return TransactionTile(
                      transaction: transactions[index],
                      dbService: _dbService,
                      onDelete: () {
                        setState(() {});
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Transaction>> _getTransactions() async {
    if (_filterMode == 0) {
      return await _dbService.getAllTransactions();
    } else if (_filterMode == 1) {
      return await _dbService.getTransactionsByDate(_selectedDate!);
    } else {
      return await _dbService.getTransactionsByDateRange(_startDate!, _endDate!);
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Transactions'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('All Transactions'),
              onTap: () {
                setState(() {
                  _filterMode = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('By Single Date'),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() {
                    _filterMode = 1;
                    _selectedDate = date;
                  });
                  if (mounted) Navigator.pop(context);
                }
              },
            ),
            ListTile(
              title: const Text('By Date Range'),
              onTap: () async {
                final picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  setState(() {
                    _filterMode = 2;
                    _startDate = picked.start;
                    _endDate = picked.end;
                  });
                  if (mounted) Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final DatabaseService dbService;
  final VoidCallback onDelete;

  const TransactionTile({
    Key? key,
    required this.transaction,
    required this.dbService,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Customer?>(
      future: dbService.getCustomer(transaction.customerId),
      builder: (context, snapshot) {
        final customer = snapshot.data;
        final customerName = customer?.name ?? 'Unknown';

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ExpansionTile(
            title: Text(customerName),
            subtitle: Text(formatDateTime(transaction.transactionDate)),
            trailing: Popup(
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                PopupMenuItem(
                  onTap: () {
                    dbService.deleteTransaction(transaction.id);
                    onDelete();
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
              child: const Icon(Icons.more_vert),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DetailRow(
                      label: 'Cash',
                      value: formatCurrency(transaction.cashAmount),
                      color: Colors.orange,
                    ),
                    const SizedBox(height: 8),
                    DetailRow(
                      label: 'Online',
                      value: formatCurrency(transaction.onlineAmount),
                      color: Colors.purple,
                    ),
                    const SizedBox(height: 8),
                    DetailRow(
                      label: 'Other',
                      value: formatCurrency(transaction.otherAmount),
                      color: Colors.teal,
                    ),
                    const Divider(height: 20),
                    DetailRow(
                      label: 'Total',
                      value: formatCurrency(transaction.totalAmount),
                      color: Colors.blue,
                      isBold: true,
                    ),
                    const SizedBox(height: 12),
                    if (transaction.itemsSold.isNotEmpty) ...[
                      const Text(
                        'Items Sold:',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(transaction.itemsSold),
                      const SizedBox(height: 12),
                    ],
                    if (transaction.description.isNotEmpty) ...[
                      const Text(
                        'Description:',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(transaction.description),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool isBold;

  const DetailRow({
    Key? key,
    required this.label,
    required this.value,
    required this.color,
    this.isBold = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: color,
            fontSize: isBold ? 16 : 14,
          ),
        ),
      ],
    );
  }
}

class Popup extends PopupMenuButton {
  const Popup({
    Key? key,
    required List<PopupMenuEntry> Function(BuildContext) itemBuilder,
    Widget? child,
  }) : super(
    key: key,
    itemBuilder: itemBuilder,
    child: child,
  );
}
