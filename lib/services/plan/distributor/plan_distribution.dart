import 'package:myfinplan/data/models/category/category/category.dart';
import 'package:myfinplan/data/models/category/transact_type/transaction_type.dart';
import 'package:myfinplan/data/models/plan/distributor/summary_model.dart';
import 'package:myfinplan/data/models/transaction/transaction.dart';

enum DistType {
  d721,
  d532,
  d82;
}

DistType distTypeFromString(String type) {
  for (var val in DistType.values) {
    if (type == val.toString()) {
      return val;
    }
  }
  throw Exception("Invalid distType type=[$type]");
}

sealed class PlanDistribution {
  Map<Level, double> data;
  PlanDistribution({this.data = const {}});

  DistType get type;
  String get description;
  String get title;
  Map<Level, double> get dist;

  factory PlanDistribution.fromType(String type) {
    final distType = distTypeFromString(type);
    switch (distType) {
      case DistType.d721:
        return Distribution721();
      case DistType.d532:
        return Distribution532();
      case DistType.d82:
        return Distribution82();
      default:
        throw Exception("Invalid plan code: $type");
    }
  }

  Map<String, dynamic> toJson() {
    return {"type": type.toString()};
  }

  bool isSuitable(List<Transaction> transacts);

  SummaryModel getSummary(List<Category> categories, List<Transaction> plan, List<Transaction> actual);
}

class Distribution721 extends PlanDistribution {
  @override
  DistType get type => DistType.d721;

  @override
  String get description => """Thu nhập của bạn sẽ được chia thành 3 phần:
  - Chi phí bắt buộc: 70%
  - Chi phí cá nhân: 20%
  - Tiết kiệm: 10%""";

  @override
  String get title => "70-20-10";

  @override
  Map<Level, double> get dist => {
        Level.must: 0.7,
        Level.may: 0.2,
        Level.saving: 0.1,
      };

  @override
  bool isSuitable(List<Transaction> transacts) {
    return true;
  }

  @override
  SummaryModel getSummary(
    List<Category> categories,
    List<Transaction> plan,
    List<Transaction> actual,
  ) {
    // incomes
    final planIncome = plan.where((e) => e.transactType == TransactionType.income).fold(0, (prev, e) => prev + e.amount.abs());
    final actualIncome = 0;
    // must
    // may
    // saving
    return SummaryModel(
      plan: {
        Level.saving: 0,
        Level.income: 0,
        Level.must: 0,
        Level.may: 0,
      },
      actual: {
        Level.saving: 0,
        Level.income: 0,
        Level.must: 0,
        Level.may: 0,
      },
    );
  }
}

class Distribution532 extends PlanDistribution {
  @override
  DistType get type => DistType.d532;

  @override
  String get description => """Thu nhập của bạn sẽ được chia thành 3 phần:
  - Chi phí bắt buộc: 50%
  - Chi phí cá nhân: 30%
  - Tiết kiệm: 20%""";

  @override
  String get title => "50-30-20";

  @override
  Map<Level, double> get dist => {
        Level.must: 0.5,
        Level.may: 0.3,
        Level.saving: 0.2,
      };

  @override
  bool isSuitable(List<Transaction> transacts) {
    return true;
  }

  @override
  SummaryModel getSummary(
    List<Category> categories,
    List<Transaction> plan,
    List<Transaction> actual,
  ) {
    // TODO: implement getSummary
    throw UnimplementedError();
  }
}

class Distribution82 extends PlanDistribution {
  @override
  DistType get type => DistType.d82;

  @override
  String get description => """Thu nhập của bạn sẽ được chia thành 2 phần:
  - Chi tiêu (bắt buộc + cá nhân): 80%
  - Tiết kiệm: 20%""";

  @override
  String get title => "80-20";

  @override
  Map<Level, double> get dist => {
        Level.must: 0.8,
        Level.may: 0.8,
        Level.saving: 0.2,
      };

  @override
  bool isSuitable(List<Transaction> transacts) {
    return false;
  }

  @override
  SummaryModel getSummary(
    List<Category> categories,
    List<Transaction> plan,
    List<Transaction> actual,
  ) {
    // TODO: implement getSummary
    throw UnimplementedError();
  }
}
