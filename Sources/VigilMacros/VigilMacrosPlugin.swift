// Experiment: a trivial Swift macro plugin to test whether 6.3.1-RELEASE
// + WindowsExperimental.sdk + -static-stdlib can build a `.macro` target on
// Windows. Macro plugins are built by SwiftPM as separate executables; this
// is the build path that fails for hylo-new on the same toolchain.

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxMacros

public struct StringifyMacro: ExpressionMacro {
  public static func expansion(
    of node: some FreestandingMacroExpansionSyntax,
    in context: some MacroExpansionContext
  ) throws -> ExprSyntax {
    guard let argument = node.arguments.first?.expression else {
      fatalError("compiler bug: the macro does not have any arguments")
    }
    return "(\(argument), \(literal: argument.description))"
  }
}

@main
struct VigilMacrosPlugin: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    StringifyMacro.self,
  ]
}
