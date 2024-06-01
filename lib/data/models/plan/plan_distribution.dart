enum DistType {
  d721,
  d532,
  d82;
}

enum ExpenseLevel {
  must,
  may,
  saving,
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
  PlanDistribution();

  DistType get type;
  String get description;
  String get title;
  Map<ExpenseLevel, double> get dist;

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
  Map<ExpenseLevel, double> get dist => {
        ExpenseLevel.must: 0.7,
        ExpenseLevel.may: 0.2,
        ExpenseLevel.saving: 0.1,
      };
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
  Map<ExpenseLevel, double> get dist => {
        ExpenseLevel.must: 0.5,
        ExpenseLevel.may: 0.3,
        ExpenseLevel.saving: 0.2,
      };
}

class Distribution82 extends PlanDistribution {
  @override
  DistType get type => DistType.d82;

  @override
  String get description => """Thu nhập của bạn sẽ được chia thành 3 phần:
  - Chi phí bắt buộc + cá nhân: 80%
  - Tiết kiệm: 10%""";

  @override
  String get title => "80-20";

  @override
  Map<ExpenseLevel, double> get dist => {
        ExpenseLevel.must: 0.8,
        ExpenseLevel.may: 0.8,
        ExpenseLevel.saving: 0.2,
      };
}
