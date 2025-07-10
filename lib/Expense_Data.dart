import 'package:expense_tracker/Expense_Item.dart';

class ExpenseData {
  static final _listOfExpenses = <ExpenseItem>[];

  static List<ExpenseItem> get expenses {
    return [..._listOfExpenses];
  }

  static void addExpense(ExpenseItem expense) {
    _listOfExpenses.add(expense);
  }

  static bool isEmpty() {
    return _listOfExpenses.isEmpty;
  }

  static void deleteExpense(int id) {
    _listOfExpenses.removeAt(id);
  }
}
