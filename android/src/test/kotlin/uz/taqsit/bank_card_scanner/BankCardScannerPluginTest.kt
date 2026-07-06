package uz.taqsit.bank_card_scanner

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.mockito.ArgumentMatchers.anyString
import org.mockito.ArgumentMatchers.eq
import org.mockito.ArgumentMatchers.isNull
import org.mockito.Mockito
import kotlin.test.Test

/*
 * Unit tests for the Kotlin portion of this plugin's implementation.
 *
 * Once you have built the plugin's example app, you can run these tests from the command
 * line by running `./gradlew testDebugUnitTest` in the `example/android/` directory, or
 * you can run them directly from IDEs that support JUnit such as Android Studio.
 */

internal class BankCardScannerPluginTest {
    @Test
    fun onMethodCall_scanCard_withoutActivity_returnsError() {
        val plugin = BankCardScannerPlugin()

        val call = MethodCall("scanCard", null)
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        plugin.onMethodCall(call, mockResult)

        Mockito.verify(mockResult).error(eq("NO_ACTIVITY"), anyString(), isNull())
    }

    @Test
    fun onMethodCall_unknownMethod_returnsNotImplemented() {
        val plugin = BankCardScannerPlugin()

        val call = MethodCall("unknown", null)
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        plugin.onMethodCall(call, mockResult)

        Mockito.verify(mockResult).notImplemented()
    }
}
