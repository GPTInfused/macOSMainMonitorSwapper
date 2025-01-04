//
//  main.swift
//  MonitorSwapper
//
//  Created by Nicholas Clooney on 4/1/2025.
//

import Foundation
import CoreGraphics
import AppKit
import CoreGraphics

let MAX_DISPLAYS: UInt32 = 32

func swapDisplays() {
    let allScreens = NSScreen.screens

    guard allScreens.count == 2 else {
        print("ERROR: swapDisplays only supports 2 screens")
        return
    }

    var activeDisplays = [CGDirectDisplayID](repeating: 0, count: Int(MAX_DISPLAYS))
    var displayCount: UInt32 = 0
    let err = CGGetActiveDisplayList(MAX_DISPLAYS, &activeDisplays, &displayCount)

    guard err == .success else {
        print("Error: Cannot get active displays")
        return
    }

    var mainDisplayID: CGDirectDisplayID?
    var secondaryDisplayID: CGDirectDisplayID?

    for i in 0..<displayCount {
        let displayID = activeDisplays[Int(i)]
        let bounds = CGDisplayBounds(displayID)

        if bounds.origin.x == 0 && bounds.origin.y == 0 {
            mainDisplayID = displayID
        } else {
            secondaryDisplayID = displayID
        }
    }

    guard let currentMainID = mainDisplayID, let newMainID = secondaryDisplayID else {
        print("Error: Could not determine main and secondary displays")
        return
    }

    print("Current main display: \(currentMainID)")
    print("Switching main display to: \(newMainID)")

    setMainDisplay(newMainID, relativeTo: currentMainID)
}

func setMainDisplay(_ newMainID: CGDirectDisplayID, relativeTo currentMainID: CGDirectDisplayID) {
    var optionalConfigRef: CGDisplayConfigRef?
    let configState = CGBeginDisplayConfiguration(&optionalConfigRef)

    guard
        configState == .success,
        let configRef = optionalConfigRef
    else {
        print("Error: Could not begin display configuration")
        return
    }

    // Make the new main display the primary display (at 0,0)
    CGConfigureDisplayOrigin(configRef, newMainID, 0, 0)

    // Position the old main display relative to the new main display
    let newMainWidth = CGDisplayPixelsWide(newMainID)

    CGConfigureDisplayOrigin(
        configRef,
        currentMainID,
        Int32(newMainWidth),
        0
    ) // Place it to the right

    // Apply the configuration
    let applyErr = CGCompleteDisplayConfiguration(configRef, .permanently)

    if applyErr == .success {
        print("Display configuration successfully updated.")
    } else {
        print("Error: Could not complete display configuration")
    }
}

// Run the swap displays function
swapDisplays()
