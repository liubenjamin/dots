// pointer-size: Instantly resize the macOS mouse pointer
// Uses private SkyLight framework API (CGSSetCursorScale)
//
// Usage:
//   pointer-size <scale>      Direct mode (spawns process each call)
//   pointer-size daemon       Run as background daemon
//   pointer-size shrink       Signal daemon to shrink (starts daemon if needed)
//   pointer-size restore      Signal daemon to restore (starts daemon if needed)

import Foundation

let pidFile = NSString(string: "~/.pointer-size.pid").expandingTildeInPath
let smallSize: Float = 1.0
let largeSize: Float = 4.0

// Load SkyLight symbols
let skylight = dlopen("/System/Library/PrivateFrameworks/SkyLight.framework/SkyLight", RTLD_NOW)
typealias CGSMainConnectionIDFunc = @convention(c) () -> UInt32
typealias CGSSetCursorScaleFunc = @convention(c) (UInt32, Float) -> Int32

guard let cid_sym = dlsym(skylight, "CGSMainConnectionID"),
      let scale_sym = dlsym(skylight, "CGSSetCursorScale") else {
    fputs("Failed to load SkyLight symbols\n", stderr)
    exit(1)
}

let CGSMainConnectionID = unsafeBitCast(cid_sym, to: CGSMainConnectionIDFunc.self)
let CGSSetCursorScale = unsafeBitCast(scale_sym, to: CGSSetCursorScaleFunc.self)

func setScale(_ scale: Float) {
    let cid = CGSMainConnectionID()
    CGSSetCursorScale(cid, scale)
}

func daemonIsRunning() -> pid_t? {
    guard let pidStr = try? String(contentsOfFile: pidFile, encoding: .utf8),
          let pid = pid_t(pidStr.trimmingCharacters(in: .whitespacesAndNewlines)) else {
        return nil
    }
    // Check if process exists
    if kill(pid, 0) == 0 {
        return pid
    }
    return nil
}

func startDaemon() {
    let proc = Process()
    proc.executableURL = URL(fileURLWithPath: CommandLine.arguments[0])
    proc.arguments = ["daemon"]
    try? proc.run()
    // Wait briefly for daemon to write PID
    usleep(50000) // 50ms
}

func sendSignal(_ sig: Int32) {
    if let pid = daemonIsRunning() {
        kill(pid, sig)
    } else {
        startDaemon()
        if let pid = daemonIsRunning() {
            kill(pid, sig)
        }
    }
}

// Main
guard CommandLine.arguments.count > 1 else {
    fputs("Usage: pointer-size <scale|daemon|shrink|restore>\n", stderr)
    exit(1)
}

let arg = CommandLine.arguments[1]

switch arg {
case "daemon":
    // Write PID
    try? String(getpid()).write(toFile: pidFile, atomically: true, encoding: .utf8)

    // Set up signal handlers
    signal(SIGUSR1) { _ in setScale(smallSize) }
    signal(SIGUSR2) { _ in setScale(largeSize) }
    signal(SIGTERM) { _ in
        try? FileManager.default.removeItem(atPath: pidFile)
        exit(0)
    }

    // Keep running
    dispatchMain()

case "shrink":
    sendSignal(SIGUSR1)

case "restore":
    sendSignal(SIGUSR2)

default:
    if let scale = Float(arg) {
        setScale(scale)
    } else {
        fputs("Unknown argument: \(arg)\n", stderr)
        exit(1)
    }
}
