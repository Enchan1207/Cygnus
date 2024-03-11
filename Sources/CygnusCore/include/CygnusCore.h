//
//  CygnusCore.h - Umbrella header for Lua
//  Cygnus
//
//  Created by EnchantCode on 2024/03/04.
//
#ifndef CygnusCore_h
#define CygnusCore_h

/**
    At umbrella header, you should import all header files of Lua, but following files must be excluded:
     - ljumptab.h: it is used by lvm.c, but it contain codes depends on GCC extension features. clang cannot build such file.
     - ltests.h: it is for unit testing of Lua.
*/

#import "../lua/lapi.h"
#import "../lua/lauxlib.h"
#import "../lua/lcode.h"
#import "../lua/lctype.h"
#import "../lua/ldebug.h"
#import "../lua/ldo.h"
#import "../lua/lfunc.h"
#import "../lua/lgc.h"
#import "../lua/llex.h"
#import "../lua/llimits.h"
#import "../lua/lmem.h"
#import "../lua/lobject.h"
#import "../lua/lopcodes.h"
#import "../lua/lopnames.h"
#import "../lua/lparser.h"
#import "../lua/lprefix.h"
#import "../lua/lstate.h"
#import "../lua/lstring.h"
#import "../lua/ltable.h"
#import "../lua/ltm.h"
#import "../lua/lua.h"
#import "../lua/luaconf.h"
#import "../lua/lualib.h"
#import "../lua/lundump.h"
#import "../lua/lvm.h"
#import "../lua/lzio.h"

#endif /* CygnusCore_h */
