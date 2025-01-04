//
//  main.swift
//  MonitorSwapper
//
//  Created by Nicholas Clooney on 4/1/2025.
//

import Foundation
import AppKit
import CoreGraphics

private let supportedNumberOfScreens = 2

// Run the swap displays function
swapDisplays()

private func swapDisplays() {
    guard let (mainScreen, secondaryScreen) = screens() else {
        return
    }

    set(mainDisplay: secondaryScreen, relativeTo: mainScreen)
}

private func error(_ message: String) -> Never {
    print("Error: \(message)")

    exit(1)
}

private func screens() -> (main: NSScreen, secondary: NSScreen)? {
    let screens = NSScreen.screens

    guard screens.count == supportedNumberOfScreens else {
        error("swapDisplays only supports \(supportedNumberOfScreens) screens")
    }

    guard
        let mainScreen = screens.first(where: { $0.frame.origin == .zero }),
        let secondaryScreen = screens.first(where: { $0.frame.origin != .zero })
    else {
        error("Could not determine main and secondary screens")
    }

    return (main: mainScreen, secondary: secondaryScreen)
}

private func set(mainDisplay newMainScreen: NSScreen, relativeTo currentMainScrren: NSScreen) {
    guard
        let currentMainScreenID = currentMainScrren.displayID,
        let newMainScreenID = newMainScreen.displayID
    else {
        error("Could not determine main and secondary displays")
    }

    print("Current main screen: \(currentMainScreenID)")
    print("Switching main screen to: \(newMainScreenID)")

    // Position displays the same as before
    let newCurrentMainScreenFrame = currentMainScrren.frame.convert(
        to: newMainScreen
    )

    let x = Int32(newCurrentMainScreenFrame.origin.x)
    let y = Int32(newCurrentMainScreenFrame.origin.y)

    print("Setting current main screen's new origin at (x: \(x), y: \(y))")

    var optionalConfigRef: CGDisplayConfigRef?
    var configState: CGError

    configState = CGBeginDisplayConfiguration(&optionalConfigRef)

    guard
        configState == .success,
        let configRef = optionalConfigRef
    else {
        error("Could not begin display configuration")
    }

    configState = CGConfigureDisplayOrigin(
        configRef,
        currentMainScreenID,
        x,
        -y // NOTE: Somehow, `CGConfigureDisplayOrigin` set the `y` at `-y`... So we flip it here.
    )

    if configState != .success {
        print("Error: Could not set current display's new origin")
    }

    // Make the new main display the primary display (at 0,0)
    configState = CGConfigureDisplayOrigin(configRef, newMainScreenID, 0, 0)

    if configState != .success {
        print("Error: Could not set new display's new origin")
    }

    // Apply the configuration
    configState = CGCompleteDisplayConfiguration(configRef, .permanently)

    if configState == .success {
        print("Display configuration successfully updated.")
    } else {
        error("Could not complete display configuration")
    }
}

private extension NSDeviceDescriptionKey {
    static let screenNumber = NSDeviceDescriptionKey(rawValue: "NSScreenNumber")
}


private extension NSScreen {
    var displayID: CGDirectDisplayID? {
        guard
            let nsScreenNumber = deviceDescription[NSDeviceDescriptionKey.screenNumber] as? NSNumber
        else {
            print("Error: Cannot find display ID")

            return nil
        }

        let displayID = CGDirectDisplayID(nsScreenNumber.intValue)

        return displayID
    }
}

private extension CGRect {
    func convert(to targetScreen: NSScreen) -> CGRect {
        let targetScreenOrigin = targetScreen.frame.origin

        let newOrigin = CGPoint(
            x: origin.x - targetScreenOrigin.x,
            y: origin.y - targetScreenOrigin.y
        )

        return CGRect(origin: newOrigin, size: size)
    }
}
