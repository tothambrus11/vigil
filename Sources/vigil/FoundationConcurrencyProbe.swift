// Experiment: exercise full Foundation + Swift Concurrency surface to see
// whether 6.3.1-RELEASE static-stdlib on Windows can link a binary that
// uses these features. Not actually wired into the CLI; merely referenced
// from a public symbol so the linker doesn't dead-strip it.

import Foundation

@MainActor
internal enum FoundationConcurrencyProbe {
  static func touchFoundation() -> String {
    let now = Date()
    let formatter = ISO8601DateFormatter()
    let timestamp = formatter.string(from: now)

    let url = URL(string: "https://example.org/")!
    let data = "hello".data(using: .utf8) ?? Data()
    let json: [String: Any] = ["ts": timestamp, "host": url.host ?? "", "len": data.count]
    let bytes = (try? JSONSerialization.data(withJSONObject: json)) ?? Data()

    let regex = try? NSRegularExpression(pattern: #"^[a-z]+$"#)
    let matches = regex?.numberOfMatches(in: "hello", range: NSRange(location: 0, length: 5)) ?? 0

    return "ts=\(timestamp) bytes=\(bytes.count) matches=\(matches)"
  }

  static func touchConcurrency() async -> Int {
    async let a = compute(1)
    async let b = compute(2)
    let pair = await (a, b)

    let group = await withTaskGroup(of: Int.self, returning: Int.self) { group in
      for i in 0..<4 {
        group.addTask { await compute(i) }
      }
      var total = 0
      for await v in group { total += v }
      return total
    }

    try? await Task.sleep(for: .milliseconds(1))
    return pair.0 + pair.1 + group
  }

  private static func compute(_ n: Int) async -> Int {
    await Task.yield()
    return n * n
  }

  // Public entry point so the symbol is reachable from the executable and
  // not stripped by the linker.
  internal static func run() async -> String {
    let f = touchFoundation()
    let c = await touchConcurrency()
    return "\(f) sum=\(c)"
  }
}
