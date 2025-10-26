import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money by Avitor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: const MoneyHomePage(),
    );
  }
}

class Transaction {
  final String description;
  final double amount;
  final bool isIncome;

  Transaction({required this.description, required this.amount, required this.isIncome});
}

class MoneyHomePage extends StatefulWidget {
  const MoneyHomePage({super.key});

  @override
  State<MoneyHomePage> createState() => _MoneyHomePageState();
}

class _MoneyHomePageState extends State<MoneyHomePage> {
  double _balance = 0.0;
  final List<Transaction> _transactions = [];

  void _addTransaction(String description, double amount, bool isIncome) {
    setState(() {
      _transactions.add(Transaction(description: description, amount: amount, isIncome: isIncome));
      _balance += isIncome ? amount : -amount;
    });
  }

  void _showAddTransactionDialog() {
    final TextEditingController descController = TextEditingController();
    final TextEditingController amountController = TextEditingController();
    bool isIncome = true;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Transaction'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text('Income'),
                    value: true,
                    groupValue: isIncome,
                    onChanged: (value) => setState(() => isIncome = value!),
                  ),
                ),
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text('Expense'),
                    value: false,
                    groupValue: isIncome,
                    onChanged: (value) => setState(() => isIncome = value!),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final desc = descController.text;
              final amt = double.tryParse(amountController.text) ?? 0.0;
              if (desc.isNotEmpty && amt > 0) {
                _addTransaction(desc, amt, isIncome);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Money by Avitor'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Center(
              child: Text(
                'Balance: \$ ${_balance.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                final transaction = _transactions[index];
                return ListTile(
                  title: Text(transaction.description),
                  subtitle: Text(transaction.isIncome ? 'Income' : 'Expense'),
                  trailing: Text(
                    '${transaction.isIncome ? '+' : '-'}\$${transaction.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: transaction.isIncome ? Colors.green : Colors.red,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTransactionDialog,
        tooltip: 'Add Transaction',
        child: const Icon(Icons.add),
      ),
    );
  }
}