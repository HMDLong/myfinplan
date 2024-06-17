import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/account/amortizing_info.dart';
import 'package:myfinplan/screens/plan/debts/components/provider/providers.dart';
import 'package:myfinplan/screens/plan/summary/components/monthly_recap/widgets/comment_card.dart';
import 'package:myfinplan/screens/plan/summary/components/monthly_recap/widgets/recap_section_title.dart';
import 'package:myfinplan/utils/format.dart';

class LoansSection extends ConsumerStatefulWidget {
  const LoansSection({super.key});

  @override
  ConsumerState<LoansSection> createState() => _LoansSectionState();
}

const rowTextStyle = TextStyle(
  fontSize: 12,
);

const dataTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 12,
);

class _LoansSectionState extends ConsumerState<LoansSection> {
  Widget _infoRow(String label, String value, {bool fill = false}) {
    return Container(
      color: fill ? Colors.blue.shade100 : Colors.white,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: dataTextStyle),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(value, style: dataTextStyle),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoanRow(String label, int actual, int plan, {bool fill = false}) {
    return Container(
      color: fill ? Colors.blue.shade100 : Colors.white,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: dataTextStyle),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: Formatter.amountToDecimal(actual),
                      style: TextStyle(
                        fontSize: 12,
                        color: plan < actual ? Colors.green : Colors.red,
                      ),
                    ),
                    const TextSpan(text: " / "),
                    TextSpan(
                      text: Formatter.amountToDecimal(plan),
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildLoans(LoanInfo info) {
    final res = <Widget>[];
    for (var i = 0; i < info.loans.length; i++) {
      res.add(
        _buildLoanRow(info.loans[i].title, info.paysThisMonth[i].toInt(), 1000000),
      );
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(loansInfoProvider).when(
      data: (data) {
        final totalPaid = data.paysThisMonth.fold<double>(0, (prev, e) => prev + e);
        final totalLoan = data.loans.fold(0, (prev, e) => prev + e.balance);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const RecapSectionTitle(title: "Khoản nợ"),
            const SizedBox(height: 15),
            _infoRow("Dư nợ gốc", Formatter.amountToDecimal(0), fill: true),
            _infoRow("Trả dự kiến", Formatter.amountToDecimal(15540000)),
            _infoRow("Thực trả kì này", Formatter.amountToDecimal(totalPaid.toInt()), fill: true),
            _infoRow("Dư nợ kì sau", Formatter.amountToDecimal(200000000)),
            // _infoRow("Giảm nợ", "", fill: true),
            const Padding(
              padding: EdgeInsets.all(14.0),
              child: Text(
                "Chi tiết các khoản",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            ..._buildLoans(data),
            // CommentCard(
            //   child: Text(
            //     "Trong tháng 4/2022, bạn đã không trả đủ theo kế hoạch (${amountToDecimal(0, currency: null)}/${amountToDecimal(15540000)}). Kế hoạch sẽ bị ảnh hưởng n",
            //   ),
            // ),
          ],
        );
      },
      error: (error, _) {
        return SizedBox(
          height: 200,
          child: Text("$error"),
        );
      },
      loading: () {
        return const SizedBox(
          height: 200,
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
