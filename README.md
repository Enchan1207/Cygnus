![Cygnus](banner.png)

[![Latest release](https://img.shields.io/github/v/release/Enchan1207/LuaSwift)](https://github.com/Enchan1207/LuaSwift/releases/latest)

**Cygnus** is Swift package for embedding Lua into your projects.

## Overview

> [!NOTE]
> There is **no Lua code in branch `master`** (it will be cloned from [official mirror](https://github.com/lua/lua) and injected at CI). **Please specify `release` branch when you install.**

### The simplest example: Execute Lua code passed as a string literal

```swift
// import Cygnus

let lua = Lua()
do {
    try lua.eval("print(\"Hello, Lua!\")")
} catch let luaError as LuaError {
    print(luaError)
} catch {
    print("Unexpected error: \(error)")
}
```

Console output:

```
Hello, Lua!
```

### Application example: Capture data from Lua standard output

```swift
// import Cygnus

let lua = Lua()

// connect standard I/O to internal pipes
do {
    try lua.configureStandardIO()
} catch {
    print("Failed to configure standard I/O: \(error)")
}

// Invoke lua code that access to standard output
do {
    try lua.eval("print(\"This text will be emitted to Lua.stdout instead of standard output of host application.\")")
} catch let luaError as LuaError {
    print(luaError)
} catch {
    print("Unexpected error: \(error)")
}

// Capture standard output content
guard let outputData = lua.stdout?.availableData,
        let outputString = String(data: outputData, encoding: .utf8) else {return}
print("Lua output: \(outputString)")
```

Console output:

```
Lua output: This text will be emitted to Lua.stdout instead of standard output of host application.
Lua state 0x0000000000000000: stdout closed
Lua state 0x0000000000000000: stdin closed
```

> [!WARNING]
> Lua's `print` statement is replaced to custom function at `lua.configureStandardIO`. In details, see [About print statement of Lua](#warning-about-print-statement-of-lua).

### Application example: Inject data to Lua standard input

```swift
// import Cygnus

let lua = Lua()

// connect standard I/O to internal pipes
do {
    try lua.configureStandardIO()
} catch {
    print("Failed to configure standard I/O: \(error)")
}

let luaSemaphore = DispatchSemaphore(value: 0)
DispatchQueue.global().async {
    do {
        try lua.eval("print(string.lower(io.read()))")
    } catch let luaError as LuaError {
        print(luaError)
    } catch {
        print("Unexpected error: \(error)")
    }
    
    guard let outputData = lua.stdout?.availableData,
            let outputString = String(data: outputData, encoding: .utf8) else {return}
    print("Lua output: \(outputString)")
    luaSemaphore.signal()
}

let content = "HELLO, LUA!"
do {
    // The function `io.read` of Lua reads string until line break or EOF,
    // so you should to add '\n' to end of data.
    try lua.stdin?.write(contentsOf: (content + "\n").data(using: .utf8)!)
} catch let luaError as LuaError {
    print(luaError)
} catch {
    print("Unexpected error: \(error)")
}
luaSemaphore.wait()
```

Console output:

```
Lua output: hello, lua!
Lua state 0x0000000000000000: stdout closed
Lua state 0x0000000000000000: stdin closed
```

> [!WARNING]
> Lua's `print` statement is replaced to custom function at `lua.configureStandardIO`. In details, see [About print statement of Lua](#warning-about-print-statement-of-lua).

### Warning: About print statement of Lua

In default, Lua's statement `print` uses stdout defined at `stdio.h`. It means there is no way to capture output.  
To avoid this, Cygnus internally replaces `print` to custom function calling `io.write()` and `io.flush()`.
If you don't need this, set argument `replacePrintStatement` to false of function `lua.configureStandardIO`.

## Details

This package contains following 3 modules:

 - `Cygnus` : High-level Swift API
 - `CygnusCore` : Lua core
 - `CygnusMacros` : Lua macro definitions (`lua_pop`, `lua_pcall`, ...)

If you only use High-level API, just import `Cygnus`.
To use Lua API directly or invoke function that is not implemented at `Cygnus`, please import `CygnusCore` (and `CygnusCoreMacros` if needed) additionaly.

> [!IMPORTANT]
> **`Cygnus` is not API wrapper.** It provides simpler method to use Lua from your app (such as I/O capture, executing code passed as a string) but not all functions of Lua C API.

## License

This package is published under [MIT License](LICENSE).

Lua is copyright (c) 1994–2023 [Lua.org](https://www.lua.org/), [PUC-Rio](https://www.puc-rio.br/).
