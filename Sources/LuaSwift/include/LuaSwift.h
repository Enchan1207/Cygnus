//
//  LuaSwift.h - Umbrella header for Lua
//  LuaSwift
//
//  Created by EnchantCode on 2024/03/04.
//
#ifndef LuaSwift_h
#define LuaSwift_h

// import all header files of Lua, but following files are excluded:
//  - lua.hpp: it is for C++, not C.
//  - ljumptab.h: it is included at lvm.c, but only in GCC.

#import "lapi.h"
#import "lauxlib.h"
#import "lcode.h"
#import "lctype.h"
#import "ldebug.h"
#import "ldo.h"
#import "lfunc.h"
#import "lgc.h"
#import "llex.h"
#import "llimits.h"
#import "lmem.h"
#import "lobject.h"
#import "lopcodes.h"
#import "lopnames.h"
#import "lparser.h"
#import "lprefix.h"
#import "lstate.h"
#import "lstring.h"
#import "ltable.h"
#import "ltm.h"
#import "lua.h"
#import "luaconf.h"
#import "lualib.h"
#import "lundump.h"
#import "lvm.h"
#import "lzio.h"

#endif /* LuaSwift_h */
