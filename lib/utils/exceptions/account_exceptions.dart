class AccountNotEnoughBalanceException implements Exception {
  String accId;
  AccountNotEnoughBalanceException(this.accId);

  @override
  String toString() => "Not enough balance from [$accId] to transact";
}

class CreditOverlimitException implements Exception {
  String accId;
  CreditOverlimitException(this.accId);

  @override
  String toString() => "Credit usage over limit from [$accId]";
}

class WithdrawFromLoanException implements Exception {
  @override
  String toString() => "Cannot withdraw from a loan";
}

class OverflowLoanPaymentException implements Exception {
  @override
  String toString() => "Loan payment overflow";
}

// ------------ REPO exceptions --------------
class AccountRepoException implements Exception {
  String error;
  AccountRepoException(this.error);

  @override
  String toString() => "Error on account repo: $error";
}
