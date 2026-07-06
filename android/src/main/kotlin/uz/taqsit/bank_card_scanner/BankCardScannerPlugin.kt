package uz.taqsit.bank_card_scanner

import android.app.Activity
import android.content.Intent
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import uz.scan_card.cardscan.ScanActivity
import uz.scan_card.cardscan.base.ScanActivityImpl
import uz.scan_card.cardscan.base.ScanBaseActivity

/** BankCardScannerPlugin */
class BankCardScannerPlugin :
    FlutterPlugin,
    MethodCallHandler,
    ActivityAware,
    PluginRegistry.ActivityResultListener {
    private lateinit var channel: MethodChannel
    private var activityBinding: ActivityPluginBinding? = null
    private var pendingResult: Result? = null

    companion object {
        private const val CHANNEL_NAME = "bank_card_scanner"
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL_NAME)
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(
        call: MethodCall,
        result: Result
    ) {
        when (call.method) {
            "scanCard" -> startScan(call, result)
            else -> result.notImplemented()
        }
    }

    private fun startScan(call: MethodCall, result: Result) {
        val activity = activityBinding?.activity
        if (activity == null) {
            result.error("NO_ACTIVITY", "bank_card_scanner requires a foreground activity.", null)
            return
        }
        if (pendingResult != null) {
            result.error("ALREADY_ACTIVE", "A card scan is already in progress.", null)
            return
        }
        pendingResult = result

        // Initializes the TFLite models on a background thread while the
        // scanner activity is launching; safe to call repeatedly.
        ScanActivity.warmUp(activity)

        val intent = Intent(activity, ScanActivityImpl::class.java)
        call.argument<String>("scanCardText")?.let {
            intent.putExtra(ScanActivityImpl.SCAN_CARD_TEXT, it)
        }
        call.argument<String>("positionCardText")?.let {
            intent.putExtra(ScanActivityImpl.POSITION_CARD_TEXT, it)
        }
        activity.startActivityForResult(intent, ScanActivity.SCAN_REQUEST_CODE)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (!ScanActivity.isScanResult(requestCode)) return false
        val result = pendingResult ?: return true
        pendingResult = null

        val card = if (resultCode == Activity.RESULT_OK && data != null) {
            ScanActivity.creditCardFromResult(data)
        } else {
            null
        }
        when {
            card != null -> result.success(
                mapOf(
                    "cardNumber" to card.number,
                    "expiryMonth" to card.expiryMonth?.toIntOrNull(),
                    "expiryYear" to card.expiryYear?.toIntOrNull()
                )
            )

            data?.getBooleanExtra(ScanBaseActivity.RESULT_PERMISSION_DENIED, false) == true ->
                result.error("PERMISSION_DENIED", "Camera access was denied.", null)

            data?.getBooleanExtra(ScanBaseActivity.RESULT_CAMERA_OPEN_ERROR, false) == true ->
                result.error("CAMERA_ERROR", "Could not open the camera.", null)

            data?.getBooleanExtra(ScanBaseActivity.RESULT_FATAL_ERROR, false) == true ->
                result.error("SCAN_ERROR", "A fatal error occurred while scanning.", null)

            // User cancelled (back button / close button).
            else -> result.success(null)
        }
        return true
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activityBinding = binding
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() = detachActivity()

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) =
        onAttachedToActivity(binding)

    override fun onDetachedFromActivity() = detachActivity()

    private fun detachActivity() {
        activityBinding?.removeActivityResultListener(this)
        activityBinding = null
    }
}
