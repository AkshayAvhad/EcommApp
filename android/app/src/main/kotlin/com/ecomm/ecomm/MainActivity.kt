package com.ecomm.ecomm

import android.content.Context
import android.os.BatteryManager
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager.BATTERY_STATUS_CHARGING
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Bind this activity instance directly to the generated pigeon receiver
//        NativeDeviceApi.setUp(flutterEngine.dartExecutor.binaryMessenger, this)
    }
    // Explicitly typed override mandated by our Pigeon design contract
//    override fun getDetailedBattery(): BatteryResponse {
//        val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
//        val percentage = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
//
//        // Grab current charging status flags via standard intent broadcast
//        val intentFilter = IntentFilter(Intent.ACTION_BATTERY_CHANGED)
//        val batteryStatus: Intent? = registerReceiver(null, intentFilter)
//        val status = batteryStatus?.getIntExtra(BatteryManager.EXTRA_STATUS, -1) ?: -1
//        val isCharging = status == BATTERY_STATUS_CHARGING
//
//        // Return a strongly typed Kotlin class representation!
//        return BatteryResponse(percentage = percentage.toLong(), isCharging = isCharging)
//    }


}
