import Carbon
import Foundation
import AppKit

class HotkeySolution {
    static
    func getCarbonFlagsFromCocoaFlags(cocoaFlags: NSEvent.ModifierFlags) -> UInt32 {
        let flags = cocoaFlags.rawValue
        var newFlags: Int = 0

        if ((flags & NSEvent.ModifierFlags.control.rawValue) > 0) {
            newFlags |= controlKey
        }

        if ((flags & NSEvent.ModifierFlags.command.rawValue) > 0) {
            newFlags |= cmdKey
        }

        if ((flags & NSEvent.ModifierFlags.shift.rawValue) > 0) {
            newFlags |= shiftKey;
        }

        if ((flags & NSEvent.ModifierFlags.option.rawValue) > 0) {
            newFlags |= optionKey
        }

        if ((flags & NSEvent.ModifierFlags.capsLock.rawValue) > 0) {
            newFlags |= alphaLock
        }

        return UInt32(newFlags);
    }

    static func register(delegate: AppDelegate) {
        var hotKeyRef: EventHotKeyRef?

        // Set the modifier flags for Command + Shift
        let modifierFlags: UInt32 = getCarbonFlagsFromCocoaFlags(cocoaFlags: [.command, .shift])

        // Set the key code for 'R'
        let keyCode = kVK_ANSI_G

        var gMyHotKeyID = EventHotKeyID()
        gMyHotKeyID.id = UInt32(keyCode)

        // Use a custom signature 'swat' for the hotkey
        gMyHotKeyID.signature = OSType("swat".fourCharCodeValue)

        var eventType = EventTypeSpec()
        eventType.eventClass = OSType(kEventClassKeyboard)
        eventType.eventKind = OSType(kEventHotKeyReleased)

        // Install handler
        InstallEventHandler(GetApplicationEventTarget(), {
            (nextHanlder, theEvent, userData) -> OSStatus in
            // Handle your hotkey action here
            globalAppDelegate.openClosePopOver()
            return noErr
        }, 1, &eventType, nil, nil)

        // Register the hotkey
        let status = RegisterEventHotKey(UInt32(keyCode),
                                         modifierFlags,
                                         gMyHotKeyID,
                                         GetApplicationEventTarget(),
                                         0,
                                         &hotKeyRef)
        assert(status == noErr)
    }
}
