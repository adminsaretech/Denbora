import Flutter
import UIKit
import Darwin

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "TempoMonotonicClock")
    let channel = FlutterMethodChannel(
      name: "com.saretech.tempo/clock",
      binaryMessenger: registrar.messenger()
    )
    channel.setMethodCallHandler { call, result in
      guard call.method == "nowMicroseconds" else {
        result(FlutterMethodNotImplemented)
        return
      }
      var timebase = mach_timebase_info_data_t()
      guard mach_timebase_info(&timebase) == KERN_SUCCESS, timebase.denom != 0 else {
        result(FlutterError(code: "CLOCK_UNAVAILABLE", message: "Could not read the monotonic clock.", details: nil))
        return
      }
      let ticks = mach_continuous_time()
      let denominator = UInt64(timebase.denom)
      let numerator = UInt64(timebase.numer)
      let nanoseconds = (ticks / denominator) * numerator + ((ticks % denominator) * numerator / denominator)
      result(Int64(nanoseconds / 1_000))
    }
  }
}
