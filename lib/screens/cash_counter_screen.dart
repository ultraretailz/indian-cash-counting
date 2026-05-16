import 'package:flutter/material.dart';
import '../models/denomination.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class CashCounterScreen extends StatefulWidget {
  const CashCounterScreen({Key? key}) : super(key: key);

  @override
  State<CashCounterScreen> createState() => _CashCounterScreenState();
}

class _CashCounterScreenState extends State<CashCounterScreen> {
  late List<Denomination> denominations;

  @override
  void initState() {
    super.initState();
    denominations =
        indianDenominations.map((v) => Denomination(value: v)).toList();
  }

  void _resetCounter() {
    setState(() {
      denominations.forEach((d) => d.count = 0);
    });
  }

  double get _totalAmount {
    return denominations.fold(0, (sum, d) => sum + d.total);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cash Counter'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetCounter,
          ),
        ],
      ),
      body: Column(
        children: [
          // Total amount display
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue.withOpacity(0.1),
            child: Column(
              children: [
                const Text(
                  'Total Amount',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  formatCurrency(_totalAmount),
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          // Denomination list
          Expanded(
            child: ListView.builder(
              itemCount: denominations.length,
              itemBuilder: (context, index) {
                final denom = denominations[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          // Denomination value
                          SizedBox(
                            width: 80,
                            child: Text(
                              formatCurrency(denom.value.toDouble()),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // Minus button
                          IconButton(
                            onPressed: () {
                              setState(() {
                                if (denom.count > 0) denom.count--;
                              });
                            },
                            icon: const Icon(Icons.remove_circle),
                            color: Colors.red,
                          ),
                          // Count display
                          SizedBox(
                            width: 60,
                            child: TextField(
                              controller:
                                  TextEditingController(text: denom.count.toString()),
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              onChanged: (value) {
                                setState(() {
                                  denom.count = int.tryParse(value) ?? 0;
                                });
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                            ),
                          ),
                          // Plus button
                          IconButton(
                            onPressed: () {
                              setState(() {
                                denom.count++;
                              });
                            },
                            icon: const Icon(Icons.add_circle),
                            color: Colors.green,
                          ),
                          // Subtotal
                          Expanded(
                            child: Text(
                              formatCurrency(denom.total),
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Action buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _resetCounter,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Reset'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Copy to clipboard or use in payment entry
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Total Amount: ${formatCurrency(_totalAmount)}',
                          ),
                        ),
                      );
                    },
                    child: const Text('Use This Amount'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
