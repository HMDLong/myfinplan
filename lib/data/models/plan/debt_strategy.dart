sealed class DebtStrategy {
  String get key;
  String get title;
  String get description;

  DebtStrategy();

  factory DebtStrategy.fromTypeString(String type) {
    if (type == SnowballStrategy().key) {
      return SnowballStrategy();
    }
    if (type == AvalancheStrategy().key) {
      return AvalancheStrategy();
    }
    throw Exception("Unrecognized type {$type}");
  }
}

class SnowballStrategy extends DebtStrategy {
  @override
  String get description => """Tập trung trả thêm vào khoản có số nợ thấp nhất
  - Giúp giảm số lượng khoản vay, tạo cảm giác duy trì động lực trả nợ.
  - Phù hợp nếu bạn có nhiều khoản vay lãi suất thấp.""";

  @override
  String get title => "Cầu tuyết";

  @override
  String get key => "snowball";
}

class AvalancheStrategy extends DebtStrategy {
  @override
  String get description => """Tập trung trả thêm vào khoản có số lãi phát sinh cao nhất
  - Giúp ngăn các khoản vay lãi cao phát sinh
  - Phù hợp nếu bạn có khoản nợ lãi cao hoặc khoản vay lớn có lãi""";

  @override
  String get title => "Tuyết lở";

  @override
  String get key => "avalanche";
}
