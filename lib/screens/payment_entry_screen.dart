import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/customer.dart';
import '../models/transaction.dart';
import '../utils/helpers.dart';

class PaymentEntryScreen extends StatefulWidget {
  const PaymentEntryScreen({Key? key}) : super(key: key);

  @override
  State<PaymentEntryScreen> createState() => _PaymentEntryScreenState();
}

class _PaymentEntryScreenState extends State<PaymentEntryScreen> {
  final DatabaseService _dbService = DatabaseService();
  final _formKey = GlobalKey<FormState>();

  String? _selectedCustomerId;
  final _cashController = TextEditingController();
  final _onlineController = TextEditingController();
  final _otherController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _itemsSoldController = TextEditingController();

  List<Customer> _customers = [];

  @override
  void initState() {
    super.initState();
    _loadCustomers();
    _cashController.text = '0';
    _onlineController.text = '0';
    _otherController.text = '0';
  }

  void _loadCustomers() async {
    final customers = await _dbService.getAllCustomers();
    setState(() {
      _customers = customers;
    });
  }

  @override
  void dispose() {
    _cashController.dispose();
    _onlineController.dispose();
    _otherController.dispose();
    _descriptionController.dispose();
    _itemsSoldController.dispose();
    super.dispose();
  }

  Future<void> _saveTransaction() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedCustomerId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a customer')),
        );
        return;
      }

      final transaction = Transaction(
        id: generateId(),
        customerId: _selectedCustomerId!,
        cashAmount: double.parse(_cashController.text),
        onlineAmount: double.parse(_onlineController.text),
        otherAmount: double.parse(_otherController.text),
        description: _descriptionController.text.trim(),
        itemsSold: _itemsSoldController.text.trim(),
        transactionDate: DateTime.now(),
      );

      await _dbService.addTransaction(transaction);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment saved successfully')),
        );
        _resetForm();
      }
    }
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    setState(() {
      _selectedCustomerId = null;
      _cashController.text = '0';
      _onlineController.text = '0';
      _otherController.text = '0';
      _descriptionController.clear();
      _itemsSoldController.clear();
    });
  }

  double get _totalAmount {
    return (double.tryParse(_cashController.text) ?? 0) +
        (double.tryParse(_onlineController.text) ?? 0) +
        (double.tryParse(_otherController.text) ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Payment'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              // Customer selection
              DropdownButtonFormField<String>(
                value: _selectedCustomerId,
                decoration: InputDecoration(
                  labelText: 'Select Customer',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.person),
                ),
                items: _customers.map((customer) {
                  return DropdownMenuItem(
                    value: customer.id,
                    child: Text(customer.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCustomerId = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a customer';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Text(
                'Payment Amount',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              // Cash amount
              TextFormField(
                controller: _cashController,
                decoration: InputDecoration(
                  labelText: 'Cash Amount (₹)',
                  hintText: 'Enter cash amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.money),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter cash amount';
                  }
                  if (double.tryParse(value!) == null) {
                    return 'Please enter valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              // Online amount
              TextFormField(
                controller: _onlineController,
                decoration: InputDecoration(
                  labelText: 'Online Amount (₹)',
                  hintText: 'Enter online payment amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.credit_card),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter online amount';
                  }
                  if (double.tryParse(value!) == null) {
                    return 'Please enter valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              // Other amount
              TextFormField(
                controller: _otherController,
                decoration: InputDecoration(
                  labelText: 'Other Amount (₹)',
                  hintText: 'Enter other payment amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.payment),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter other amount';
                  }
                  if (double.tryParse(value!) == null) {
                    return 'Please enter valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Total display
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Amount:',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      formatCurrency(_totalAmount),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Items sold
              TextFormField(
                controller: _itemsSoldController,
                decoration: InputDecoration(
                  labelText: 'Items Sold',
                  hintText: 'Enter items sold details',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.shopping_bag),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter notes or description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.description),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 32),
              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveTransaction,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Save Payment'),
                ),
              ),
              const SizedBox(height: 12),
              // Reset button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _resetForm,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Reset'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
