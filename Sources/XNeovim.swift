import AppKit
import XNeovimService

@objc public class XNeovim: NSObject {

    @objc public override init() {
        super.init()

        // Add an observer so we get notified when Xcode is actually loaded
        var observer: Any?
        observer =  NotificationCenter.default.addObserver(forName: NSApplication.didFinishLaunchingNotification, object: nil, queue: nil) { [weak self] ntf in
            observer.map {
                NotificationCenter.default.removeObserver($0)
            }

            //  Xcode is actually loaded
            self?.applicationDidFinishLaunching()
        }
    }

    @objc public func applicationDidFinishLaunching() {
        // Plugin initialized!
        logger.info?.write("Plugin Version is \(bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") ?? "Unknown")!")
        logger.info?.write("Plugin NeoVim Service Version is \(XNeovimServiceVersionNumber)!")

        //        NotificationCenter.default.addObserver(forName: nil, object: nil, queue: nil) {
        //            logger.debug?.write($0.name)
        //        }
        
    }

    //
    //  private func configureMenuItems() {
    //    guard let mainMenu = NSApp.mainMenu else { return }
    //    guard let editItem = mainMenu.item(withTitle: "Edit") else { return }
    //    guard let submenu = editItem.submenu else { return }
    //
    //    let pluginMenuItem = NSMenuItem(title:"🔌 XNeovim", action: nil, keyEquivalent:"")
    //
    //    submenu.addItem(pluginMenuItem)
    //
    //    let pluginMenu = NSMenu(title: "🔌 XNeovim")
    //    let aboutMenuItem = NSMenuItem(title: "About", action: #selector(self.aboutMenuAction), keyEquivalent: "")
    //    aboutMenuItem.target = self
    //
    //    pluginMenu.addItem(aboutMenuItem)
    //
    //    submenu.setSubmenu(pluginMenu, for: pluginMenuItem)
    //  }
    //
    //  dynamic private func aboutMenuAction() {
    //    let version = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") ?? "⛔️ Unknown"
    //
    //    let alert = NSAlert()
    //    alert.messageText = "XNeovim version \(version)"
    //    alert.alertStyle = .informational
    //    alert.runModal()
    //  }

    // MARK: - Initialization plugin

    @objc public class func pluginDidLoad(_ bundle: Bundle) {
        // Load only into Xcode
        guard Bundle.main.bundleIdentifier == "com.apple.dt.Xcode" else {
            logger.fatal?.write("Bundle identifier doesn't match 'com.apple.dt.Xcode'. Not loading plugin.")
            return
        }

        logger.info?.write(Bundle.main)
        logger.info?.write(bundle)

        // Entry Point of the Plugin.
        Runtime.Method.merge(SourceEditorView.self, to: "SourceEditor.SourceEditorView", prefix: "xvim_", override: true)
        Runtime.Method.merge(SourceEditorContentView.self, to: "SourceEditor.SourceEditorContentView", prefix: "xvim_", override: true)

        Runtime.Method.merge(SourceEditorCursorLayer.self, to: "SourceEditor.CursorLayer", prefix: "xvim_", override: true)
        
        Runtime.Method.merge(SourceCodeEditor.self, to: "IDEPegasusSourceEditor.SourceCodeEditor", prefix: "xvim_", override: true)

        // The location of the switch to the plug-in
        shared.bundle = bundle
        shared.server.start()
    }

    // MARK: - Property

    @objc public private(set) var bundle: Bundle = .main
    @objc public private(set) var server: XNeovimServer = .shared

    @objc public static let shared: XNeovim = .init()
}

