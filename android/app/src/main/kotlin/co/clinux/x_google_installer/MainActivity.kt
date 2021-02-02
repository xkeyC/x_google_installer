package co.clinux.x_google_installer

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.DataOutputStream

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        MethodChannel(flutterEngine.dartExecutor, "x_google_install")
                .setMethodCallHandler { call, result ->
                    when (call.method) {
                        "checkRoot" -> {
                            checkRoot(result)
                        }
                        else -> result.notImplemented()
                    }
                }
        super.configureFlutterEngine(flutterEngine)
    }

    /// check Root
    private fun checkRoot(result: MethodChannel.Result) {
        var ok = false
        try {
            val p = Runtime.getRuntime().exec("su")
            val cmd = DataOutputStream(p.outputStream)
            cmd.writeBytes("whoami")
            cmd.close()
            val string = p.inputStream.readBytes().decodeToString()
            if (string == "root") {
                ok = true
            }
        } catch (e: Exception) {
            ok = false
        }
        result.success(ok)
    }

}
