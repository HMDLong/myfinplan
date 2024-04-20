import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/domain/categories/category_notifier.dart';
import 'package:myfinplan/domain/transactions/transaction_notifier.dart';
import 'package:myfinplan/presentation/plan/plan_transaction/add_plan_transact_screen.dart';
import 'package:myfinplan/presentation/plan/plan_transaction/plan_transact_tab.dart';
import 'package:myfinplan/presentation/plan/schedule/schedule_calendart_state.dart';
import 'package:myfinplan/utils/time/times.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ScheduleTab extends ConsumerStatefulWidget {
  const ScheduleTab({super.key});

  @override
  ConsumerState<ScheduleTab> createState() => _ScheduleTabState();
}

final scheduleDetailsProvider = FutureProvider((ref) async {
  final planTransacts = (await ref.watch(transactionNotifierProvider).getAllTransaction()).where((e) => e.planTransactId != null).toList();
  final res = <ScheduleItem>[];
  for (var planTransact in planTransacts) {
    final category = await ref.watch(categoryNotifierProvider).getCategoryById(planTransact.categoryId);
    res.add(ScheduleItem(
        transactId: planTransact.id, title: "${category?.name}", note: "", status: PlanTransactStatus.upcoming, amount: 100000, actual: planTransact.amount, timestamp: planTransact.timestamp));
  }
  return res;
});

class _ScheduleTabState extends ConsumerState<ScheduleTab> {
  @override
  Widget build(BuildContext context) {
    final items = ref.watch(scheduleDetailsProvider).when<List<ScheduleItem>>(
          data: (data) => data,
          error: (error, _) {
            return [];
          },
          loading: () => [],
        );
    return Scaffold(
      body: SfCalendar(
        view: CalendarView.month,
        monthViewSettings: const MonthViewSettings(
          showAgenda: true,
          agendaItemHeight: 60,
          appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
        ),
        dataSource: PlanScheduleDataSource(items),
        appointmentBuilder: (context, calendarAppointmentDetails) {
          final scheduleItem = calendarAppointmentDetails.appointments.first as ScheduleItem;
          return Card(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: _getColor(scheduleItem),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 16,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            scheduleItem.title,
                            style: const TextStyle(fontSize: 14),
                          ),
                          const Text(
                            "This is some noteeeeeeeeeeee",
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: PopupMenuButton(
                      padding: EdgeInsets.zero,
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem(
                            onTap: () {},
                            child: Text("Thực hiện"),
                          ),
                        ];
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          pushNewScreen(context, screen: const NewPlanTransactScreen());
        },
      ),
    );
  }

  _getColor(ScheduleItem item) {
    final isEarly = item.timestamp.isAfter(DateTime.now().toDateOnly());
    final paid = item.actual == 0;
    if (!paid && !isEarly) {
      return Colors.red;
    }
    if (paid && isEarly) {
      return Colors.green;
    }
    if (paid) {
      return Colors.amber;
    }
    return Colors.blue;
  }
}
