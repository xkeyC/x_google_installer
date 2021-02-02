package co.clinux.x_google_installer

import com.tananaev.adblib.AdbConnection
import com.tananaev.adblib.AdbCrypto
import com.tananaev.adblib.AdbStream
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import java.io.DataOutputStream
import java.net.Socket


class MainActivity : FlutterActivity() {

    companion object {
        private var adbStream: AdbStream? = null
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        MethodChannel(flutterEngine.dartExecutor, "x_google_install")
                .setMethodCallHandler { call, result ->
                    when (call.method) {
                        "checkRoot" -> {
                            checkRoot(result)
                        }
                        "startWifiAdb" -> {
                            startWifiAdb(result)
                        }
                        "connectToWifiAdb" -> {
                            connectToWifiAdb(result)
                        }
                        "checkSyslock" -> {
                            checkSyslock(result)
                        }
                        else -> result.notImplemented()
                    }
                }
        super.configureFlutterEngine(flutterEngine)
    }

    private fun getRootProcess(): Process {
        return Runtime.getRuntime().exec("su");
    }

    /// check Root
    private fun checkRoot(result: MethodChannel.Result) {
        try {
            val p = getRootProcess()
            val cmd = DataOutputStream(p.outputStream)
            cmd.writeBytes("whoami")
            cmd.close()
            val string = p.inputStream.readBytes().decodeToString()
            if (string.indexOf("root") != -1) {
                result.success(true)
                return
            } else {
                result.success(false)
            }
        } catch (e: Exception) {
            result.success(false)
        }
    }

    /// start wifi adb
    private fun startWifiAdb(result: MethodChannel.Result) {
        result.success(true)
        return;
        try {
            val p = getRootProcess()
            val cmd = DataOutputStream(p.outputStream)
            cmd.writeBytes("setprop service.adb.tcp.port 5555 & stop adbd & start adbd")
            cmd.close()
            if (p.exitValue() == 0) {
                result.success(true)
            } else {
                result.success(false)
            }
        } catch (e: Exception) {
            result.success(false)
        }
    }

    /// connectToWifiAdb
    private fun connectToWifiAdb(result: MethodChannel.Result) {
        try {
            GlobalScope.launch(Dispatchers.IO) {
                if (adbStream != null) {
                    if (!adbStream!!.isClosed) {
                        adbStream!!.close()
                    }
                    adbStream = null
                }
                val socket = Socket("127.0.0.1", 5555)
                val crypto = AdbCrypto.generateAdbKeyPair { data ->
                    android.util.Base64.encodeToString(data, 16)
                }
                val connection = AdbConnection.create(socket, crypto)
                connection.connect()
                adbStream = connection.open("shell:logcat")
                adbStream!!.write("su")
            }
            result.success(true)
        } catch (e: Exception) {
            println(e)
            result.success(false)
        }
    }

    private fun checkSyslock(result: MethodChannel.Result) {
        try {
            GlobalScope.launch(Dispatchers.IO) {
                if (adbStream == null) {
                    result.success(-1)
                    return@launch
                }
                if (!adbStream!!.isClosed) {
                    result.success(-1)
                    return@launch
                }
                adbStream!!.write("enable-verity")
                val string = adbStream!!.read().decodeToString();
                when {
                    string.indexOf("Successfully enabled verity") != -1 -> {
                        result.success(1)
                    }
                    string.indexOf("verity is already enabled") != -1 -> {
                        result.success(0)
                    }
                    else -> {
                        result.success(-1)
                    }
                }
            }
        } catch (e: Exception) {
            result.success(-1)
        }
    }

}
