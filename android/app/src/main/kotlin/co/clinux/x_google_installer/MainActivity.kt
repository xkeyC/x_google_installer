package co.clinux.x_google_installer

import android.os.Bundle
import com.tencent.bugly.Bugly
import com.tencent.bugly.beta.Beta
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        /// init Tencent Bugly
        Beta.autoInit = true
        Beta.enableHotfix = false
        Bugly.init(applicationContext, "2cd59481e3", false)
        println("init")
        super.onCreate(savedInstanceState)
    }
}
