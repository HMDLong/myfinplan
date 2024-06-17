import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/providers/categories/category_notifier.dart';
import 'package:myfinplan/providers/transactions/transaction_notifier.dart';
import 'package:myfinplan/screens/plan/plan_transaction/add_plan_transact_screen.dart';
import 'package:myfinplan/screens/plan/schedule/schedule_calendart_state.dart';
import 'package:myfinplan/screens/transactions/add_transaction/add_transaction_screen.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ScheduleTab extends ConsumerStatefulWidget {
  const ScheduleTab({super.key});

  @override
  ConsumerState<ScheduleTab> createState() => _ScheduleTabState();
}

final scheduleDetailsProvider = FutureProvider((ref) async {
  final planTransacts = (await ref.watch(transactionNotifierProvider).getAllTransaction()).where((e) => e.planDetail != null).toList();
  final res = <ScheduleItem>[];
  for (var planTransact in planTransacts) {
    final category = await ref.watch(categoryNotifierProvider).getCategoryById(planTransact.categoryId);
    res.add(
      ScheduleItem(
        transact: planTransact,
        transactId: planTransact.id,
        title: "${category?.name}",
        note: planTransact.description ?? "",
        amount: planTransact.planDetail!.planAmount,
        actual: planTransact.amount,
        transactTime: planTransact.timestamp,
        scheduleTime: planTransact.planDetail!.planTime,
      ),
    );
  }
  return res;
});

const menuItemStyle = TextStyle(
  fontSize: 14,
);

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
        showNavigationArrow: true,
        view: CalendarView.month,
        monthViewSettings: const MonthViewSettings(
          showAgenda: true,
          agendaItemHeight: 60,
          appointmentDisplayCount: 5,
          appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
        ),
        onViewChanged: (viewChangedDetails) {},
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
                        color: scheduleItem.color,
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
                            style: const TextStyle(fontSize: 12),
                          ),
                          Text(scheduleItem.statusText, style: const TextStyle(fontSize: 10)),
                          Text("${scheduleItem.actual}/${scheduleItem.amount}", style: const TextStyle(fontSize: 10)),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: PopupMenuButton(
                      padding: EdgeInsets.zero,
                      itemBuilder: (BuildContext context) {
                        return _buildPopupMenuItems(scheduleItem);
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

  _buildPopupMenuItems(ScheduleItem item) {
    if (item.paid) {
      return [
        const PopupMenuItem(
          height: 30,
          child: Text(
            "Chỉnh sửa",
            style: menuItemStyle,
          ),
        ),
      ];
    }
    return [
      PopupMenuItem(
        height: 30,
        child: const Text(
          "Thực hiện",
          style: menuItemStyle,
        ),
        onTap: () {
          pushNewScreen(
            context,
            screen: AddOrEditTransactScreen(prefill: item.transact),
          );
        },
      ),
      const PopupMenuItem(
        height: 30,
        child: Text(
          "Hủy lịch",
          style: menuItemStyle,
        ),
      ),
      PopupMenuItem(
        height: 30,
        onTap: () {
          pushNewScreen(context, screen: AddOrEditTransactScreen(prefill: item.transact));
        },
        child: const Text(
          "Chỉnh sửa",
          style: menuItemStyle,
        ),
      ),
    ];
  }
}
