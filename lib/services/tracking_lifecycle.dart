import 'dart:developer';

import 'package:flutter_gail/feature/task/viewTask/domain/model/task_model.dart';
import 'package:flutter_gail/localDataBase/shared_preferences_utils.dart';
import 'package:flutter_gail/services/background_location_service.dart';
import 'package:flutter_gail/services/session_helper.dart';
import 'package:flutter_gail/utils/commonClass/app_config.dart';
import 'package:flutter_gail/utils/res/enums.dart';

/// 🔁 Keeps the background service in step with what the user is doing.
///
/// Starting it is the map page's job, because only that page knows which
/// task is open. Stopping it is easy to miss, though: the service used to
/// keep running after the last task was finished and even after logout,
/// burning battery and posting with a stale token.
class TrackingLifecycle {
  /// Stop tracking when no task is running any more.
  ///
  /// Called from the task list, which is the one place that sees every task
  /// at once — the map page only ever knows about the task it opened.
  static Future<void> syncWithTasks(List<TaskModel> tasks) async {
    try {
      final hasActiveTask = tasks.any(
        (task) =>
            task.taskStatus == TaskStatus.started ||
            task.taskStatus == TaskStatus.resume,
      );
      if (hasActiveTask) return;

      final manager = BackgroundManager();
      if (await manager.isRunning()) {
        log("🛑 No task running any more, stopping background service");
        await manager.stopService();
      }
    } catch (e, s) {
      log("⚠️ Could not sync tracking with tasks: $e", stackTrace: s);
    }
  }

  /// Everything that has to be torn down when the user signs out.
  ///
  /// The service outlives the session otherwise: it would carry on posting
  /// the previous user's points with their token.
  static Future<void> handleLogout() async {
    try {
      await BackgroundManager().stopService();
      log("🔴 Background service stopped for logout");
    } catch (e, s) {
      log("⚠️ Could not stop service on logout: $e", stackTrace: s);
    }

    // Drop the session from memory as well as disk, or SessionHelper would
    // keep handing out the old token from its cache.
    SessionHelper.clear();
    AppConfig.instance = null;

    try {
      await SharedPreferencesUtils.clearAll();
    } catch (e, s) {
      log("⚠️ Could not clear preferences on logout: $e", stackTrace: s);
    }
  }
}
