package unistal.app.gail.flutter_gail
import android.content.Intent
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.gail.app/channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            if (call.method == "openDevSettings") {
                val intent = Intent(Settings.ACTION_APPLICATION_DEVELOPMENT_SETTINGS)
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                startActivity(intent)
                result.success(null)
            }
            else  if (call.method == "isDevMode") {
                try {
                    val devOptionsEnabled = Settings.Global.getInt(
                        contentResolver,
                        Settings.Global.DEVELOPMENT_SETTINGS_ENABLED, 0
                    )
                    result.success(devOptionsEnabled == 1)
                } catch (e: Exception) {
                    result.error("UNAVAILABLE", "Could not read dev mode status.", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
