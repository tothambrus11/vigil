// Public face of the stringify macro for clients (the vigil executable).

@freestanding(expression)
public macro stringify<T>(_ value: T) -> (T, String) =
  #externalMacro(module: "VigilMacros", type: "StringifyMacro")
