import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/external/notification/notification_service.dart';

final notificationServiceProvider = Provider((ref) => NotificationService());
