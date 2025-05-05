import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mahmoud_hassan/features/customers/data/models/debt.dart';

class DebtScreen extends StatefulWidget {
  const DebtScreen({super.key});

  @override
  State<DebtScreen> createState() => _DebtScreenState();
}

class _DebtScreenState extends State<DebtScreen> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  late Box<Debt> debtBox;

  @override
  void initState() {
    super.initState();
    debtBox = Hive.box<Debt>('debts');
  }

  void _addDebt() {
    final name = _nameController.text.trim();
    final amount = double.tryParse(_amountController.text) ?? 0;
    final note = _noteController.text.trim();

    if (name.isNotEmpty && amount > 0) {
      final debt = Debt(
        name: name,
        amount: amount,
        note: note.isEmpty ? null : note,
        date: DateTime.now(),
      );

      debtBox.add(debt);

      _nameController.clear();
      _amountController.clear();
      _noteController.clear();

      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("أدخل اسم صحيح ومبلغ أكبر من صفر.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final debts = debtBox.values.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل الديون')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'اسم الشخص'),
            ),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'المبلغ'),
            ),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(labelText: 'ملاحظة (اختياري)'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addDebt,
              child: const Text('إضافة الدين'),
            ),
            const SizedBox(height: 20),
            const Divider(),
            Expanded(
              child: debts.isEmpty
                  ? const Center(child: Text('لا يوجد ديون مسجلة.'))
                  : ListView.builder(
                      itemCount: debts.length,
                      itemBuilder: (context, index) {
                        final debt = debts[index];
                        return ListTile(
                          title: Text('${debt.name} - ${debt.amount}'),
                          subtitle: Text(debt.note ?? 'بدون ملاحظة'),
                          trailing: Text(
                            '${debt.date.day}/${debt.date.month}/${debt.date.year}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          onLongPress: () {
                            debt.delete();
                            setState(() {});
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
