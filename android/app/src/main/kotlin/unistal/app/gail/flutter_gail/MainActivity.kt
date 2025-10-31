package unistal.app.gail.flutter_gail

import android.content.Intent
import android.os.Bundle
import android.os.Process
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val METHOD_CHANNEL = "com.gail.app/channel"
    private val EVENT_CHANNEL = "com.gail.app/events"

    companion object {
        var eventSink: EventChannel.EventSink? = null
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        println("🟢 MainActivity onCreate — App started or resumed")
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // ✅ MethodChannel for communication with Flutter
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {

                    "openDevSettings" -> {
                        val intent = Intent(Settings.ACTION_APPLICATION_DEVELOPMENT_SETTINGS)
                        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        startActivity(intent)
                        result.success(null)
                    }

                    "isDevMode" -> {
                        try {
                            val devOptionsEnabled = Settings.Global.getInt(
                                contentResolver,
                                Settings.Global.DEVELOPMENT_SETTINGS_ENABLED, 0
                            )
                            result.success(devOptionsEnabled == 1)
                        } catch (e: Exception) {
                            result.error("UNAVAILABLE", "Could not read dev mode status.", null)
                        }
                    }

                    else -> result.notImplemented()
                }
            }

        // ✅ EventChannel for lifecycle updates
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL)
            .setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    eventSink = events
                }

                override fun onCancel(arguments: Any?) {
                    eventSink = null
                }
            })
    }


}
