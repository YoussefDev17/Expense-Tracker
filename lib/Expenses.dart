// import 'dart:nativewrappers/_internal/vm/lib/ffi_native_type_patch.dart';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:expense_tracker/Expense_Data.dart';
import 'package:expense_tracker/Expense_Item.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  DateTime? _Picked;
  TextEditingController _dateController = TextEditingController();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();

  List<double> _getWeekleyTotal() {
    final totals = List<double>.filled(7, 0.0); // 7 Days of the week

    for (var expense in ExpenseData.expenses) {
      final dayOfWeek = expense.date.weekday - 1; // Convert to 0-6 range
      totals[dayOfWeek] += double.parse(expense.amount);
    }

    return totals;
  }

  List<BarChartGroupData> _createBarGroups(List<double> weeklyTotals) {
    return List.generate(7, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: weeklyTotals[index],
            color: Colors.grey[800],
            width: 25,
            borderRadius: BorderRadius.zero,
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: 200, // Adjust this value as needed
              color: Colors.grey[200],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildBarChart() {
    final weeklyTotals = _getWeekleyTotal();
    final barGroups = _createBarGroups(weeklyTotals);

    return Container(
      height: 200, // ✅ Important!
      width: double.infinity, // 💡 This makes it take all horizontal space
      margin: const EdgeInsets.only(top: 30),
      child: BarChart(
        BarChartData(
          barGroups: barGroups,
          alignment: BarChartAlignment.spaceEvenly,
          titlesData: FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const days = ['M', 'Tu', 'W', 'Th', 'F', 'Sa', 'Su'];
                  if (value.toInt() < 0 || value.toInt() >= days.length) {
                    return const SizedBox.shrink();
                  }
                  return Text(days[value.toInt()]);
                },
              ),
            ),
          ),
          gridData: FlGridData(show: false), // ❌ Hide grid lines
          borderData: FlBorderData(show: false), // ❌ Hide chart borders
        ),
      ),
    );
  }

  // BarChartGroupData _createBarChartGroupData(int x) {
  //   return BarChartGroupData(
  //     x: x,

  //     barRods: [
  //       BarChartRodData(
  //         toY: 10, // here where i can update the value of the bar
  //         color: Colors.grey[800],
  //         width: 25,
  //         borderRadius: BorderRadius.zero,
  //         backDrawRodData: BackgroundBarChartRodData(
  //           show: true,
  //           toY: 200,
  //           color: Colors.grey[200],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildBarChart() {
  //   // This function will build the bar chart
  //   // You can use a package like charts_flutter or fl_chart to create the chart
  //   return Container(
  //     height: 200, // ✅ Important!
  //     width: double.infinity, // 💡 This makes it take all horizontal space
  //     // margin: const EdgeInsets.all(20),
  //     margin: const EdgeInsets.only(top: 30),
  //     child: BarChart(
  //       BarChartData(
  //         barGroups: [
  //           _createBarChartGroupData(0),
  //           _createBarChartGroupData(1),
  //           _createBarChartGroupData(2),
  //           _createBarChartGroupData(3),
  //           _createBarChartGroupData(4),
  //           _createBarChartGroupData(5),
  //           _createBarChartGroupData(6),
  //         ],
  //         alignment: BarChartAlignment.spaceEvenly,
  //         titlesData: FlTitlesData(
  //           topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
  //           rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
  //           leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
  //           bottomTitles: AxisTitles(
  //             // 👈 You can keep bottom if needed
  //             sideTitles: SideTitles(
  //               showTitles: true,

  //               getTitlesWidget: (value, meta) {
  //                 const days = ['M', 'Tu', 'W', 'Th', 'F', 'Sa', 'Su'];
  //                 if (value.toInt() < 0 || value.toInt() >= days.length) {
  //                   return const SizedBox.shrink();
  //                 }
  //                 return Text(days[value.toInt()]);
  //               },
  //             ),
  //           ),
  //         ),
  //         gridData: FlGridData(show: false), // ❌ Hide grid lines
  //         borderData: FlBorderData(show: false), // ❌ Hide chart borders
  //       ),
  //     ),
  //   );
  // }

  Future<void> _SelectDate() async {
    _Picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (_Picked != null) {
      setState(() {
        _dateController.text = _Picked.toString().split(" ")[0];
      });
    }
  }

  void _saveNewExpense(String Name, String Amount, DateTime Date) {
    var NewExpense = ExpenseItem(name: Name, amount: Amount, date: Date);
    setState(() {
      ExpenseData.addExpense(NewExpense);
    });
  }

  void _clearDialog() {
    _nameController.clear();
    _amountController.clear();
    _dateController.clear();
  }

  Future _buildShowDialogAddExpense() {
    final _formKey = GlobalKey<FormState>();
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Form(
            key: _formKey,
            child: Container(
              width: 300, // 👈 custom width
              height: 290, // 👈 custom height
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                    CrossAxisAlignment.start, // 👈 align to the left
                children: [
                  Text(
                    'New Expense',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 50,
                    child: TextFormField(
                      controller: _nameController,
                      autofocus: true,
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Expense name cannot be empty';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Expense Name',
                        // hintText: 'Enter the name of the expense',
                      ),
                    ),
                  ),

                  SizedBox(height: 5),
                  Container(
                    height: 50,
                    child: TextFormField(
                      controller: _amountController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Amount cannot be empty';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Amount',
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 50,
                    child: TextField(
                      controller: _dateController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        filled: true,
                        labelText: 'Date',
                      ),
                      onTap: _SelectDate,
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          _clearDialog();
                          Navigator.of(context).pop(); // Close the dialog
                        },
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        child: Text('Save'),
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            // If the form is valid, save the new expense
                            final name = _nameController.text;
                            final amount = _amountController.text;
                            _saveNewExpense(name, amount, _Picked!);
                            _clearDialog();
                            Navigator.of(context).pop(); // Close the dialog
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildButtonAddExpense() {
    return FloatingActionButton(
      onPressed: () {
        // Execute Modal Bottom Sheet
        _buildShowDialogAddExpense();
      },
      shape: CircleBorder(),
      backgroundColor: const Color.fromARGB(
        255,
        58,
        58,
        58,
      ), // optional: change color
      child: Icon(Icons.add, color: Colors.white),
    );
  }

  void _deleteExpense(int expenseID) {
    setState(() {
      ExpenseData.deleteExpense(expenseID);
    });
  }

  Widget _buildExpenseWidget(ExpenseItem expense, int id) {
    return Slidable(
      key: ValueKey(id),

      // Add sliding action when swiping to the left
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              // _deleteExpense(expense); // your delete method
              _deleteExpense(id); // your delete method
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey), // gray border color
          borderRadius: BorderRadius.circular(5), // optional rounded corners
        ),
        title: Text(expense.name),
        subtitle: Text(expense.date.toString().split(" ")[0]),
        trailing: Text('\$${expense.amount.toString()}'),
      ),
    );
  }

  Widget _PrintExpenses() {
    final listOfExpenses = ExpenseData.expenses;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              for (var expense in listOfExpenses)
                _buildExpenseWidget(expense, listOfExpenses.indexOf(expense)),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],

      body: Column(
        children: [
          _buildBarChart(),
          const SizedBox(height: 20),
          ExpenseData.isEmpty() ? const SizedBox() : _PrintExpenses(),
          const SizedBox(height: 20),
        ],
      ),
      floatingActionButton: _buildButtonAddExpense(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
