import Flutter
import UIKit

public class BankCardScannerPlugin: NSObject, FlutterPlugin {
  private var pendingResult: FlutterResult?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "bank_card_scanner", binaryMessenger: registrar.messenger())
    let instance = BankCardScannerPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "scanCard":
      scanCard(call, result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func scanCard(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard pendingResult == nil else {
      result(FlutterError(code: "ALREADY_ACTIVE", message: "A card scan is already in progress.", details: nil))
      return
    }
    guard let presenter = Self.topViewController() else {
      result(FlutterError(code: "NO_ACTIVITY", message: "No view controller available to present the scanner.", details: nil))
      return
    }

    pendingResult = result

    let scanner = CreditCardScannerViewController(delegate: self)
    let arguments = call.arguments as? [String: Any]
    scanner.titleLabelText = arguments?["scanCardText"] as? String ?? ""
    scanner.subtitleLabelText = arguments?["positionCardText"] as? String ?? ""
    scanner.modalPresentationStyle = .fullScreen
    presenter.present(scanner, animated: true)
  }

  private func complete(with value: Any?) {
    pendingResult?(value)
    pendingResult = nil
  }

  private static func topViewController() -> UIViewController? {
    let keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }
    var top = keyWindow?.rootViewController
    while let presented = top?.presentedViewController {
      top = presented
    }
    return top
  }
}

extension BankCardScannerPlugin: CreditCardScannerViewControllerDelegate {
  public func creditCardScannerViewControllerDidCancel(_ viewController: CreditCardScannerViewController) {
    viewController.dismiss(animated: true)
    complete(with: nil)
  }

  public func creditCardScannerViewController(
    _ viewController: CreditCardScannerViewController,
    didErrorWith error: CreditCardScannerError
  ) {
    viewController.dismiss(animated: true)
    switch error.kind {
    case .authorizationDenied:
      complete(with: FlutterError(
        code: "PERMISSION_DENIED",
        message: "Camera access was denied.",
        details: nil))
    default:
      complete(with: FlutterError(
        code: "SCAN_ERROR",
        message: error.errorDescription ?? "An error occurred while scanning.",
        details: nil))
    }
  }

  public func creditCardScannerViewController(
    _ viewController: CreditCardScannerViewController,
    didFinishWith card: CreditCard
  ) {
    viewController.dismiss(animated: true)
    var payload: [String: Any] = ["cardNumber": card.number ?? ""]
    if let month = card.expireDate?.month {
      payload["expiryMonth"] = month
    }
    if let year = card.expireDate?.year {
      payload["expiryYear"] = year
    }
    complete(with: payload)
  }
}
