import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/utils/time/times.dart';

final statTimeRangeProvider = StateProvider((ref) => TimeRange.rangeByType(TimeType.month));
