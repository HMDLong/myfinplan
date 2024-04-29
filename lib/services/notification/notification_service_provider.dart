import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/services/notification/notification_service.dart';

final notificationServiceProvider = Provider((ref) => NotificationService());
