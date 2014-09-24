{
  This are the pascal headers for LuaJIT, based on 
  
  'luajit.h',
  'lua.h',
  'lualib.h' and
  'lauxlib.h'.
   
  LuaJIT commit: cb886b58176dc5cd969f512d1a633f06d7120941
   
  Partially used the original FPC Headers by Lavergne Thomas and others.
}
{
  Original license for LuaJIT:
}
{*
** LuaJIT -- a Just-In-Time Compiler for Lua. http://luajit.org/
**
** Copyright (C) 2005-2014 Mike Pall. All rights reserved.
**
** Permission is hereby granted, free of charge, to any person obtaining
** a copy of this software and associated documentation files (the
** 'Software'), to deal in the Software without restriction, including
** without limitation the rights to use, copy, modify, merge, publish,
** distribute, sublicense, and/or sell copies of the Software, and to
** permit persons to whom the Software is furnished to do so, subject to
** the following conditions:
**
** The above copyright notice and this permission notice shall be
** included in all copies or substantial portions of the Software.
**
** THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
** EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
** MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
** IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
** CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
** TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
** SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
**
** [ MIT license: http://www.opensource.org/licenses/mit-license.php ]
*}
{
  Original license for lua.h, lualib.h and lauxlib.h:
}
{******************************************************************************
* Copyright (C) 1994-2008 Lua.org, PUC-Rio.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining
* a copy of this software and associated documentation files (the
* 'Software'), to deal in the Software without restriction, including
* without limitation the rights to use, copy, modify, merge, publish,
* distribute, sublicense, and/or sell copies of the Software, and to
* permit persons to whom the Software is furnished to do so, subject to
* the following conditions:
*
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
* IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
* CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
* TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
* SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
******************************************************************************}
unit luajit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

  {$IFDEF WINDOWS}
    {$IFDEF WIN64}
      LUAJIT_LibName = 'lua5.1-x64.dll';
    {$ELSE}
      LUAJIT_LibName = 'lua5.1.dll';
    {$ENDIF}
  {$ENDIF}

  {$IFDEF UNIX}
    {$IFDEF DARWIN}
      LUAJIT_LibName = 'lua5.1.dylib';
    {$ELSE}
      LUAJIT_LibName = 'libluajit-5.1.so';
    {$ENDIF}
  {$ENDIF}

  {$IFDEF MACOS}
    SDLgfxLibName = 'lua5.1';
    {$IFDEF FPC}
      {$linklib lua5.1}
    {$ENDIF}
  {$ENDIF}

{ Lua }

const
  LUA_VERSION     = 'Lua 5.1';
  LUA_RELEASE     = 'Lua 5.1.4';
  LUA_VERSION_NUM = 501;
  LUA_COPYRIGHT   = 'Copyright (C) 1994-2008 Lua.org, PUC-Rio';
  LUA_AUTHORS     = 'R. Ierusalimschy, L. H. de Figueiredo & W. Celes';

  {* mark for precompiled code (`<esc>Lua') *}
  LUA_SIGNATURE   = '\033Lua';

  {* option for multiple returns in `lua_pcall' and `lua_call' *}
  LUA_MULTRET     = (-1);

{*
** pseudo-indices
*}
const
  TLUA_REGISTRYINDEX = (-10000);
  TLUA_ENVIRONINDEX  = (-10001);
  TLUA_GLOBALSINDEX  = (-10002);
  
function lua_upvalueindex(i: Integer): Integer; inline;

{* thread status; 0 is OK *}
  TLUA_YIELD     = 1;
  TLUA_ERRRUN    = 2;
  TLUA_ERRSYNTAX = 3;
  TLUA_ERRMEM    = 4;
  TLUA_ERRERR    = 5;

type
  TLua_State = record
  end;
  PLua_State = ^TLua_State;
  TLua_CFunction = function(L: Plua_State): Integer; cdecl;
  PLua_CFunction = ^TLua_CFunction;

{*
** functions that read/write blocks when loading/dumping Lua chunks
*}
type
  TLua_Reader = function(L: Plua_State; ud: Pointer; sz: Psize_t): PChar; cdecl;
  TLua_Writer = function(L: Plua_State; const p: Pointer; sz: size_t; ud: Pointer): Integer; cdecl; 

{*
** prototype for memory-allocation functions
*}
  TLua_Alloc = function(ud, ptr: Pointer; osize, nsize: size_t): Pointer; cdecl;


{*
** basic types
*}
const
  TLUA_TNONE          = (-1);

  TLUA_TNIL           = 0;
  TLUA_TBOOLEAN       = 1;
  TLUA_TLIGHTUSERDATA = 2;
  TLUA_TNUMBER        = 3;
  TLUA_TSTRING        = 4;
  TLUA_TTABLE         = 5;
  TLUA_TFUNCTION      = 6;
  TLUA_TUSERDATA      = 7;
  TLUA_TTHREAD        = 8;

{* minimum Lua stack available to a C function *}
  TLUA_MINSTACK       = 20;

{* Type of Numbers in Lua *}
  TLua_Number = Double;
  TLua_Integer = PtrInt;  

{*
** state manipulation
*}
function lua_newstate(f: lua_Alloc; ud: Pointer): Plua_state; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_newstate' {$ENDIF} {$ENDIF};
procedure lua_close(L: Plua_State); cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_close' {$ENDIF} {$ENDIF};
function lua_newthread(L: Plua_State): Plua_State; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_newthread' {$ENDIF} {$ENDIF};

function lua_atpanic(L: Plua_State; panicf: lua_CFunction): lua_CFunction; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_atpanic' {$ENDIF} {$ENDIF}; 

{*
** basic stack manipulation
*}
function lua_gettop(L: Plua_State): Integer; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_gettop' {$ENDIF} {$ENDIF}; 
procedure lua_settop(L: Plua_State; idx: Integer); cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_settop' {$ENDIF} {$ENDIF}; 
procedure lua_pushvalue(L: Plua_State; Idx: Integer); cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_pushvalue' {$ENDIF} {$ENDIF}; 
procedure lua_remove(L: Plua_State; idx: Integer); cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_remove' {$ENDIF} {$ENDIF}; 
procedure lua_insert(L: Plua_State; idx: Integer); cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_insert' {$ENDIF} {$ENDIF}; 
procedure lua_replace(L: Plua_State; idx: Integer); cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_replace' {$ENDIF} {$ENDIF}; 
function lua_checkstack(L: Plua_State; sz: Integer): LongBool; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_checkstack' {$ENDIF} {$ENDIF}; 

procedure lua_xmove(from, to_: Plua_State; n: Integer); cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_xmove' {$ENDIF} {$ENDIF};            

{*
** access functions (stack -> C)
*}
  
function lua_isnumber(L: Plua_State; idx: Integer): LongBool; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_isnumber' {$ENDIF} {$ENDIF};            
function lua_isstring(L: Plua_State; idx: Integer): LongBool; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_isstring' {$ENDIF} {$ENDIF};            
function lua_iscfunction(L: Plua_State; idx: Integer): LongBool; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_iscfunction' {$ENDIF} {$ENDIF};            
function lua_isuserdata(L: Plua_State; idx: Integer): LongBool; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_isuserdata' {$ENDIF} {$ENDIF};            
function lua_type(L: Plua_State; idx: Integer): Integer; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_type' {$ENDIF} {$ENDIF};            
function lua_typename(L: Plua_State; tp: Integer): PChar; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_typename' {$ENDIF} {$ENDIF};            

function lua_equal(L: Plua_State; idx1, idx2: Integer): LongBool; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_equal' {$ENDIF} {$ENDIF};            
function lua_rawequal(L: Plua_State; idx1, idx2: Integer): LongBool; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_rawequal' {$ENDIF} {$ENDIF};            
function lua_lessthan(L: Plua_State; idx1, idx2: Integer): LongBool; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_lessthan' {$ENDIF} {$ENDIF};            

function lua_tonumber(L: Plua_State; idx: Integer): lua_Number; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_tonumber' {$ENDIF} {$ENDIF};            
function lua_tointeger(L: Plua_State; idx: Integer): lua_Integer; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_tointeger' {$ENDIF} {$ENDIF};            
function lua_toboolean(L: Plua_State; idx: Integer): LongBool; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_toboolean' {$ENDIF} {$ENDIF};            
function lua_tolstring(L: Plua_State; idx: Integer; len: Psize_t): PChar; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_tolstring' {$ENDIF} {$ENDIF};            
function lua_objlen(L: Plua_State; idx: Integer): size_t; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_objlen' {$ENDIF} {$ENDIF};            
function lua_tocfunction(L: Plua_State; idx: Integer): lua_CFunction; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_tocfunction' {$ENDIF} {$ENDIF};            
function lua_touserdata(L: Plua_State; idx: Integer): Pointer; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_touserdata' {$ENDIF} {$ENDIF};            
function lua_tothread(L: Plua_State; idx: Integer): Plua_State; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_tothread' {$ENDIF} {$ENDIF};            
function lua_topointer(L: Plua_State; idx: Integer): Pointer; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_topointer' {$ENDIF} {$ENDIF};               


{*
** push functions (C -> stack)
*}
procedure lua_pushnil(L: Plua_State); cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_pushnil' {$ENDIF} {$ENDIF};               
procedure lua_pushnumber(L: Plua_State; n: lua_Number); cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_pushnumber' {$ENDIF} {$ENDIF};               
procedure lua_pushinteger(L: Plua_State; n: lua_Integer); cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_pushinteger' {$ENDIF} {$ENDIF};               
procedure lua_pushlstring(L: Plua_State; const s: PChar; l_: size_t); cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_pushlstring' {$ENDIF} {$ENDIF};               
procedure lua_pushstring(L: Plua_State; const s: PChar); cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_pushstring' {$ENDIF} {$ENDIF};               
function lua_pushvfstring(L: Plua_State; const fmt: PChar; argp: Pointer): PChar; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_pushvfstring' {$ENDIF} {$ENDIF};               
function lua_pushfstring(L: Plua_State; const fmt: PChar): PChar; cdecl; varargs; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_pushfstring' {$ENDIF} {$ENDIF};               
procedure lua_pushcclosure(L: Plua_State; fn: lua_CFunction; n: Integer); cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_pushcclosure' {$ENDIF} {$ENDIF};               
procedure lua_pushboolean(L: Plua_State; b: LongBool); cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_pushboolean' {$ENDIF} {$ENDIF};               
procedure lua_pushlightuserdata(L: Plua_State; p: Pointer); cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_pushlightuserdata' {$ENDIF} {$ENDIF};               
procedure lua_pushthread(L: Plua_State); cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_pushthread' {$ENDIF} {$ENDIF};                 

{*
** get functions (Lua -> stack)
*}
procedure lua_gettable(L: Plua_State; idx: Integer); cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_gettable' {$ENDIF} {$ENDIF};                 
procedure lua_getfield(L: Plua_state; idx: Integer; k: PChar); cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_getfield' {$ENDIF} {$ENDIF};                 
procedure lua_rawget(L: Plua_State; idx: Integer); cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_rawget' {$ENDIF} {$ENDIF};                 
procedure lua_rawgeti(L: Plua_State; idx, n: Integer); cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_rawgeti' {$ENDIF} {$ENDIF};                 
procedure lua_createtable(L: Plua_State; narr, nrec: Integer); cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_createtable' {$ENDIF} {$ENDIF};                 
function lua_newuserdata(L: Plua_State; sz: size_t): Pointer; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_newuserdata' {$ENDIF} {$ENDIF};                 
function lua_getmetatable(L: Plua_State; objindex: Integer): Integer; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_getmetatable' {$ENDIF} {$ENDIF};                 
procedure lua_getfenv(L: Plua_State; idx: Integer); cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_getfenv' {$ENDIF} {$ENDIF};                 
                 
{*
** set functions (stack -> Lua)
*}
procedure lua_settable(L: Plua_State; idx: Integer); cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_settable' {$ENDIF} {$ENDIF};                 
procedure lua_setfield(L: Plua_State; idx: Integer; const k: PChar); cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_setfield' {$ENDIF} {$ENDIF};                 
procedure lua_rawset(L: Plua_State; idx: Integer); cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_rawset' {$ENDIF} {$ENDIF};                 
procedure lua_rawseti(L: Plua_State; idx, n: Integer); cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_rawseti' {$ENDIF} {$ENDIF};                 
function lua_setmetatable(L: Plua_State; objindex: Integer): Integer; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_setmetatable' {$ENDIF} {$ENDIF};                 
function lua_setfenv(L: Plua_State; idx: Integer): Integer; cdecl;  external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_setfenv' {$ENDIF} {$ENDIF};                 

{*
** `load' and `call' functions (load and run Lua code)
*}
procedure lua_call(L: Plua_State; nargs, nresults: Integer); cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_call' {$ENDIF} {$ENDIF};                 
function lua_pcall(L: Plua_State; nargs, nresults, errf: Integer): Integer; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_pcall' {$ENDIF} {$ENDIF};                 
function lua_cpcall(L: Plua_State; func: lua_CFunction; ud: Pointer): Integer; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_cpcall' {$ENDIF} {$ENDIF};                 
function lua_load(L: Plua_State; reader: lua_Reader; dt: Pointer; const chunkname: PChar): Integer; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_load' {$ENDIF} {$ENDIF};                 

function lua_dump(L: Plua_State; writer: lua_Writer; data: Pointer): Integer; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_dump' {$ENDIF} {$ENDIF};                         

{*
** coroutine functions
*}
function lua_yield(L: Plua_State; nresults: Integer): Integer; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_yield' {$ENDIF} {$ENDIF};                         
function lua_resume(L: Plua_State; narg: Integer): Integer; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_resume' {$ENDIF} {$ENDIF};                         
function lua_status(L: Plua_State): Integer; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_status' {$ENDIF} {$ENDIF};                         

{*
** garbage-collection function and options
*}
const
  LUA_GCSTOP       = 0;
  LUA_GCRESTART    = 1;
  LUA_GCCOLLECT    = 2;
  LUA_GCCOUNT      = 3;
  LUA_GCCOUNTB     = 4;
  LUA_GCSTEP       = 5;
  LUA_GCSETPAUSE   = 6;
  LUA_GCSETSTEPMUL = 7;

function lua_gc(L: Plua_State; what, data: Integer): Integer; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_gc' {$ENDIF} {$ENDIF};                          

{*
** miscellaneous functions
*}
function lua_error(L: Plua_State): Integer; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_error' {$ENDIF} {$ENDIF};                         

function lua_next(L: Plua_State; idx: Integer): Integer; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_next' {$ENDIF} {$ENDIF};                         

procedure lua_concat(L: Plua_State; n: Integer); cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_concat' {$ENDIF} {$ENDIF};                         

function lua_getallocf(L: Plua_State; ud: PPointer): lua_Alloc; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_getallocf' {$ENDIF} {$ENDIF};                         
procedure lua_setallocf(L: Plua_State; f: lua_Alloc; ud: Pointer); cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_setallocf' {$ENDIF} {$ENDIF};                            

{*
** ===============================================================
** some useful macros
** ===============================================================
*}
procedure lua_pop(L: Plua_State; n: Integer); inline;

procedure lua_newtable(L: Plua_state); inline;

procedure lua_register(L: Plua_State; const n: PChar; f: lua_CFunction); inline;
procedure lua_pushcfunction(L: Plua_State; f: lua_CFunction); inline;

function lua_strlen(L: Plua_state; i: Integer): size_t; inline;

function lua_isfunction(L: Plua_State; n: Integer): Boolean; inline;
function lua_istable(L: Plua_State; n: Integer): Boolean; inline;
function lua_islightuserdata(L: Plua_State; n: Integer): Boolean; inline;
function lua_isnil(L: Plua_State; n: Integer): Boolean; inline;
function lua_isboolean(L: Plua_State; n: Integer): Boolean; inline;
function lua_isthread(L: Plua_State; n: Integer): Boolean; inline;
function lua_isnone(L: Plua_State; n: Integer): Boolean; inline;
function lua_isnoneornil(L: Plua_State; n: Integer): Boolean; inline;

procedure lua_pushliteral(L: Plua_State; s: PChar); inline;

procedure lua_setglobal(L: Plua_State; const s: PChar); inline;
procedure lua_getglobal(L: Plua_State; const s: PChar); inline;

function lua_tostring(L: Plua_State; i: Integer): PChar; inline;

{*
** compatibility macros and functions
*}

procedure lua_getregistry(L: Plua_State); inline;

function lua_getgccount(L: Plua_State): Integer; inline;

type
  lua_Chunkreader = lua_Reader;
  lua_Chunkwriter = lua_Writer;
                    
{* hack *}
procedure lua_setlevel(from: Plua_state, to_: Plua_state); cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_setlevel' {$ENDIF} {$ENDIF};                             

{*
** {======================================================================
** Debug API
** =======================================================================
*}

{*
** Event codes
*}
const
  LUA_HOOKCALL    = 0;
  LUA_HOOKRET     = 1;
  LUA_HOOKLINE    = 2;
  LUA_HOOKCOUNT   = 3;
  LUA_HOOKTAILRET = 4;

{*
** Event masks
*}
const
  LUA_MASKCALL  = 1 shl Ord(LUA_HOOKCALL);
  LUA_MASKRET   = 1 shl Ord(LUA_HOOKRET);
  LUA_MASKLINE  = 1 shl Ord(LUA_HOOKLINE);
  LUA_MASKCOUNT = 1 shl Ord(LUA_HOOKCOUNT);

const
  LUA_IDSIZE = 60;   

type
  lua_Debug = record           {* activation record *}
    event: Integer;
    name: PChar;               {* (n) *}
    namewhat: PChar;           {* (n) `global', `local', `field', `method' *}
    what: PChar;               {* (S) `Lua', `C', `main', `tail'*}
    source: PChar;             {* (S) *}
    currentline: Integer;      {* (l) *}
    nups: Integer;             {* (u) number of upvalues *}
    linedefined: Integer;      {* (S) *}
    lastlinedefined: Integer;  {* (S) *}
    short_src: array[0..LUA_IDSIZE - 1] of Char; {* (S) *}
    {* private part *}
    i_ci: Integer;              {* active function *}
  end;
  Plua_Debug = ^lua_Debug;

{* Functions to be called by the debuger in specific events *}
  lua_Hook = procedure(L: Plua_State; ar: Plua_Debug); cdecl;
           
function lua_getstack(L: Plua_State; level: Integer; ar: Plua_Debug): Integer; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_getstack' {$ENDIF} {$ENDIF};                             
function lua_getinfo(L: Plua_State; const what: PChar; ar: Plua_Debug): Integer; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_getinfo' {$ENDIF} {$ENDIF};                             
function lua_getlocal(L: Plua_State; const ar: Plua_Debug; n: Integer): PChar; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_getlocal' {$ENDIF} {$ENDIF};                             
function lua_setlocal(L: Plua_State; const ar: Plua_Debug; n: Integer): PChar; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_setlocal' {$ENDIF} {$ENDIF};                             
function lua_getupvalue(L: Plua_State; funcindex: Integer; n: Integer): PChar; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_getupvalue' {$ENDIF} {$ENDIF};                             
function lua_setupvalue(L: Plua_State; funcindex: Integer; n: Integer): PChar; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_setupvalue' {$ENDIF} {$ENDIF};                             

function lua_sethook(L: Plua_State; func: lua_Hook; mask: Integer; count: Integer): Integer; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_sethook' {$ENDIF} {$ENDIF};                             
function lua_gethook(L: Plua_State): lua_Hook; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_gethook' {$ENDIF} {$ENDIF};                             
function lua_gethookmask(L: Plua_State): Integer; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_gethookmask' {$ENDIF} {$ENDIF};                             
function lua_gethookcount(L: Plua_State): Integer; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_gethookcount' {$ENDIF} {$ENDIF};                                

{* From Lua 5.2. *}
function lua_upvalueid(L: Plua_State; idx: Integer; n: Integer): Pointer; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_upvalueid' {$ENDIF} {$ENDIF};                                
procedure lua_upvaluejoin(L: Plua_State; idx1, n1, idx2, n2: Integer); cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_upvaluejoin' {$ENDIF} {$ENDIF};                                
function lua_loadx(L: Plua_State; reader: lua_Reader; dt: Pointer; const chunkname: PChar; const mode: PChar): Integer; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_loadx' {$ENDIF} {$ENDIF};                                

{ lauxlib }

// functions added for Pascal
procedure lua_pushstring(L: Plua_State; const s: String); 

// compatibilty macros
function luaL_getn(L: Plua_State; n: Integer): Integer; // calls lua_objlen
procedure luaL_setn(L: Plua_State; t, n: Integer); // does nothing!
                           
{* extra error code for `luaL_load' *}
const
  LUA_ERRFILE = (LUA_ERRERR+1)
  
type
  luaL_reg = record
    name: PChar;
    func: lua_CFunction;
  end;
  PluaL_reg = ^luaL_reg;

procedure luaL_openlib(L: Plua_State; const libname: PChar; const lr: PluaL_reg; nup: Integer); cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_luaL_openload' {$ENDIF} {$ENDIF};                                
procedure luaL_register(L: Plua_State; const libname: PChar; const lr: PluaL_reg); cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_luaL_register' {$ENDIF} {$ENDIF};                                
function luaL_getmetafield(L: Plua_State; obj: Integer; const e: PChar): Integer; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_luaL_getmetafield' {$ENDIF} {$ENDIF};                                
function luaL_callmeta(L: Plua_State; obj: Integer; const e: PChar): Integer; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_luaL_callmeta' {$ENDIF} {$ENDIF};                                
function luaL_typerror(L: Plua_State; narg: Integer; const tname: PChar): Integer; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_luaL_typeerror' {$ENDIF} {$ENDIF};                                
function luaL_argerror(L: Plua_State; numarg: Integer; const extramsg: PChar): Integer; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_luaL_argerror' {$ENDIF} {$ENDIF};                                
function luaL_checklstring(L: Plua_State; numArg: Integer; l_: Psize_t): PChar; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_luaL_checklstring' {$ENDIF} {$ENDIF};                                
function luaL_optlstring(L: Plua_State; numArg: Integer; const def: PChar; l_: Psize_t): PChar; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_luaL_optlstring' {$ENDIF} {$ENDIF};                                
function luaL_checknumber(L: Plua_State; numArg: Integer): lua_Number; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_luaL_checknumber' {$ENDIF} {$ENDIF};                                
function luaL_optnumber(L: Plua_State; nArg: Integer; def: lua_Number): lua_Number; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_luaL_optnumber' {$ENDIF} {$ENDIF};                                
function luaL_checkinteger(L: Plua_State; numArg: Integer): lua_Integer; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_luaL_checkinteger' {$ENDIF} {$ENDIF};                                
function luaL_optinteger(L: Plua_State; nArg: Integer; def: lua_Integer): lua_Integer; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_luaL_optinteger' {$ENDIF} {$ENDIF};                                

procedure luaL_checkstack(L: Plua_State; sz: Integer; const msg: PChar); cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_luaL_checkstack' {$ENDIF} {$ENDIF};                                
procedure luaL_checktype(L: Plua_State; narg, t: Integer); cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_luaL_checkstack' {$ENDIF} {$ENDIF};                                
procedure luaL_checkany(L: Plua_State; narg: Integer); cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_luaL_checkany' {$ENDIF} {$ENDIF};                                

function luaL_newmetatable(L: Plua_State; const tname: PChar): Integer; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_luaL_newmetatable' {$ENDIF} {$ENDIF};                                
function luaL_checkudata(L: Plua_State; ud: Integer; const tname: PChar): Pointer; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_luaL_checkudata' {$ENDIF} {$ENDIF};                                

procedure luaL_where(L: Plua_State; lvl: Integer); cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_luaL_where' {$ENDIF} {$ENDIF};                                
{$IFNDEF DELPHI}
function luaL_error(L: Plua_State; const fmt: PChar; args: array of const): Integer; cdecl; external LUA_LIB_NAME; // note: C's ... to array of const conversion is not portable to Delphi
{$ENDIF}

function luaL_checkoption(L: Plua_State; narg: Integer; def: PChar; lst: PPChar): Integer; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_luaL_checkoption' {$ENDIF} {$ENDIF};                                

function luaL_ref(L: Plua_State; t: Integer): Integer; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_luaL_ref' {$ENDIF} {$ENDIF};                                
procedure luaL_unref(L: Plua_State; t, ref: Integer); cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_luaL_unref' {$ENDIF} {$ENDIF};                                

function luaL_loadfile(L: Plua_State; const filename: PChar): Integer; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_luaL_loadfile' {$ENDIF} {$ENDIF};                                
function luaL_loadbuffer(L: Plua_State; const buff: PChar; size: size_t; const name: PChar): Integer; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_luaL_loadbuffer' {$ENDIF} {$ENDIF};                                
function luaL_loadstring(L: Plua_State; const s: PChar): Integer; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_luaL_loadstring' {$ENDIF} {$ENDIF};                                

function luaL_newstate: Plua_State; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_luaL_newstate' {$ENDIF} {$ENDIF};                                
function lua_open: Plua_State; // compatibility; moved from unit lua to lauxlib because it needs luaL_newstate

function luaL_gsub(L: Plua_State; const s, p, r: PChar): PChar; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_luaL_gsub' {$ENDIF} {$ENDIF};                                
function luaL_findtable(L: Plua_State; idx: Integer; const fname: PChar; szhint: Integer): PChar; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_luaL_findtable' {$ENDIF} {$ENDIF};                                
                
{* From Lua 5.2. *}
function luaL_fileresult(L: Plua_State; stat: Integer; const fname: PChar): Integer; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_luaL_fileresult' {$ENDIF} {$ENDIF};                                
function luaL_execresult(L: Plua_State; state: Integer): Integer; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_luaL_execresult' {$ENDIF} {$ENDIF};                                
function luaL_loadfilex(L: Plua_State; const filename: PChar; const mode: PChar): Integer; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_luaL_loadfilex' {$ENDIF} {$ENDIF};                                
function luaL_loadbufferx(L: Plua_State; const buff: PChar; sz: size_t; const name: PChar; const mode: PChar): Integer; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_luaL_loadbufferx' {$ENDIF} {$ENDIF};                                
procedure luaL_traceback(L, L1: Plua_State; const msg: PChar; level: Integer); cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_luaL_traceback' {$ENDIF} {$ENDIF};                                

{*
** ===============================================================
** some useful macros
** ===============================================================
*}
procedure luaL_argcheck(L: Plua_State; cond: Boolean; numarg: Integer; extramsg: PChar); inline;
function luaL_checkstring(L: Plua_State; n: Integer): PChar; inline;
function luaL_optstring(L: Plua_State; n: Integer; d: PChar): PChar; inline;
function luaL_checkint(L: Plua_State; n: Integer): Integer; inline;
function luaL_checklong(L: Plua_State; n: Integer): LongInt; inline;
function luaL_optint(L: Plua_State; n: Integer; d: Double): Integer; inline;
function luaL_optlong(L: Plua_State; n: Integer; d: Double): LongInt; inline;

function luaL_typename(L: Plua_State; i: Integer): PChar; inline;

function lua_dofile(L: Plua_State; const filename: PChar): Integer; inline;
function lua_dostring(L: Plua_State; const str: PChar): Integer; inline;

procedure lua_Lgetmetatable(L: Plua_State; tname: PChar); inline;
         
//luaL_opt(L,f,n,d)	(lua_isnoneornil(L,(n)) ? (d) : f(L,(n)))

{*
** =======================================================
** Generic Buffer manipulation
** =======================================================
*}

const
  // note: this is just arbitrary, as it related to the BUFSIZ defined in stdio.h ...
  LUAL_BUFFERSIZE = 4096;  
  
type
  luaL_Buffer = record
    p: PChar;       (* current position in buffer *)
    lvl: Integer;   (* number of strings in the stack (level) *)
    L: Plua_State;
    buffer: array [0..LUAL_BUFFERSIZE - 1] of Char; // warning: see note above about LUAL_BUFFERSIZE
  end;
  PluaL_Buffer = ^luaL_Buffer;       
  
procedure luaL_addchar(B: PluaL_Buffer; c: Char); inline; // warning: see note above about LUAL_BUFFERSIZE

(* compatibility only (alias for luaL_addchar) *)
procedure luaL_putchar(B: PluaL_Buffer; c: Char); inline; // warning: see note above about LUAL_BUFFERSIZE

procedure luaL_addsize(B: PluaL_Buffer; n: Integer); inline;

procedure luaL_buffinit(L: Plua_State; B: PluaL_Buffer); cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_luaL_buffinit' {$ENDIF} {$ENDIF};                                
function luaL_prepbuffer(B: PluaL_Buffer): PChar; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_luaL_prepbuffer' {$ENDIF} {$ENDIF};                                
procedure luaL_addlstring(B: PluaL_Buffer; const s: PChar; l: size_t); cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_luaL_addlstring' {$ENDIF} {$ENDIF};                                
procedure luaL_addstring(B: PluaL_Buffer; const s: PChar); cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_luaL_addstring' {$ENDIF} {$ENDIF};                                
procedure luaL_addvalue(B: PluaL_Buffer); cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_luaL_addvalue' {$ENDIF} {$ENDIF};                                
procedure luaL_pushresult(B: PluaL_Buffer); cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_luaL_pushresult' {$ENDIF} {$ENDIF};                                

{* compatibility with ref system *}

{* pre-defined references *}
const
  LUA_NOREF  = -2;
  LUA_REFNIL = -1;       

  {lua_ref(L,lock) ((lock) ? luaL_ref(L, LUA_REGISTRYINDEX) : \
      (lua_pushstring(L, 'unlocked references are obsolete'), lua_error(L), 0))}

procedure lua_unref(L: Plua_State; ref: Integer); inline;
procedure lua_getref(L: Plua_State; ref: Integer); inline;
                
{ LuaLib }

const
  LUA_FILEHANDLE  = 'FILE*';

  LUA_COLIBNAME   = 'coroutine';
  LUA_TABLIBNAME  = 'table';
  LUA_IOLIBNAME   = 'io';
  LUA_OSLIBNAME   = 'os';
  LUA_STRLINAME   = 'string';
  LUA_MATHLIBNAME = 'math';
  LUA_DBLIBNAME   = 'debug';
  LUA_LOADLIBNAME = 'package'; 

function luaopen_base(L: Plua_State): LongBool; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_openbase' {$ENDIF} {$ENDIF};                                  
function luaopen_math(L: Plua_State): LongBool; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_openmath' {$ENDIF} {$ENDIF}; 
function luaopen_string(L: Plua_State): LongBool; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_openstring' {$ENDIF} {$ENDIF};    
function luaopen_table(L: Plua_State): LongBool; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_opentable' {$ENDIF} {$ENDIF};  
function luaopen_io(L: Plua_State): LongBool; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_openio' {$ENDIF} {$ENDIF}; 
function luaopen_os(L: Plua_State): LongBool; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_openos' {$ENDIF} {$ENDIF}; 
function luaopen_package(L: Plua_State): LongBool; cdecl;external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_openpackage' {$ENDIF} {$ENDIF};  
function luaopen_debug(L: Plua_State): LongBool; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_opendebug' {$ENDIF} {$ENDIF}; 
function luaopen_bit(L: Plua_State): LongBool; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_openbit' {$ENDIF} {$ENDIF}; 
function luaopen_jit(L: Plua_State): LongBool; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_openjit' {$ENDIF} {$ENDIF}; 
function luaopen_ffi(L: Plua_State): LongBool; cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_lua_openffi' {$ENDIF} {$ENDIF}; 

procedure luaL_openlibs(L: Plua_State); cdecl; external LUAJIT_LIBNAME {$IFDEF DELPHI} {$IFDEF MACOS} name '_luaL_openlibs' {$ENDIF} {$ENDIF}; 

{ LuaJIT }

const
  LUAJIT_VERSION     = 'LuaJIT 2.0.3';
  LUAJIT_VERSION_NUM = 20003;  {* Version 2.0.3 = 02.00.03. *}
  //LUAJIT_VERSION_SYM = luaJIT_version_2_0_3
  LUAJIT_COPYRIGHT   = 'Copyright (C) 2005-2014 Mike Pall';
  LUAJIT_URL         = 'http://luajit.org/';

  {* Modes for luaJIT_setmode. *}
  LUAJIT_MODE_MASK   = $00ff;

type
  TLUAJIT_MODE = (
  LUAJIT_MODE_ENGINE,		{* Set mode for whole JIT engine. *}
  LUAJIT_MODE_DEBUG,		{* Set debug mode (idx = level). *}

  LUAJIT_MODE_FUNC,		{* Change mode for a function. *}
  LUAJIT_MODE_ALLFUNC,		{* Recurse into subroutine protos. *}
  LUAJIT_MODE_ALLSUBFUNC,	{* Change only the subroutines. *}

  LUAJIT_MODE_TRACE,		{* Flush a compiled trace. *}

  LUAJIT_MODE_WRAPCFUNC = 0x10,	{* Set wrapper mode for C function calls. *}

  LUAJIT_MODE_MAX
  );

  {* Flags or'ed in to the mode. *}
  LUAJIT_MODE_OFF   = $0000;	{* Turn feature off. *}
  LUAJIT_MODE_ON    = $0100;	{* Turn feature on. *}
  LUAJIT_MODE_FLUSH = $0200;	{* Flush JIT-compiled code. *}

{* LuaJIT public C API. *}

{* Control the JIT engine. *}
function luaJIT_setmode(lua_State *L, int idx, int mode): Integer;

{* Enforce (dynamic) linker error for version mismatches. Call from main. *}
//procedure LUAJIT_VERSION_SYM();

implementation

function lua_upvalueindex(i: Integer): Integer;
begin
  Result := LUA_GLOBALSINDEX - i;
end;

procedure lua_pop(L: Plua_State; n: Integer);
begin
  lua_settop(L, -n - 1);
end;

procedure lua_newtable(L: Plua_State);
begin
  lua_createtable(L, 0, 0);
end;

procedure lua_register(L: Plua_State; const n: PChar; f: lua_CFunction);
begin
  lua_pushcfunction(L, f);
  lua_setglobal(L, n);
end;

procedure lua_pushcfunction(L: Plua_State; f: lua_CFunction);
begin
  lua_pushcclosure(L, f, 0);
end;

function lua_strlen(L: Plua_State; i: Integer): size_t;
begin
  Result := lua_objlen(L, i);
end;

function lua_isfunction(L: Plua_State; n: Integer): Boolean;
begin
  Result := lua_type(L, n) = LUA_TFUNCTION;
end;

function lua_istable(L: Plua_State; n: Integer): Boolean;
begin
  Result := lua_type(L, n) = LUA_TTABLE;
end;

function lua_islightuserdata(L: Plua_State; n: Integer): Boolean;
begin
  Result := lua_type(L, n) = LUA_TLIGHTUSERDATA;
end;

function lua_isnil(L: Plua_State; n: Integer): Boolean;
begin
  Result := lua_type(L, n) = LUA_TNIL;
end;

function lua_isboolean(L: Plua_State; n: Integer): Boolean;
begin
  Result := lua_type(L, n) = LUA_TBOOLEAN;
end;

function lua_isthread(L: Plua_State; n: Integer): Boolean;
begin
  Result := lua_type(L, n) = LUA_TTHREAD;
end;

function lua_isnone(L: Plua_State; n: Integer): Boolean;
begin
  Result := lua_type(L, n) = LUA_TNONE;
end;

function lua_isnoneornil(L: Plua_State; n: Integer): Boolean;
begin
  Result := lua_type(L, n) <= 0;
end;

procedure lua_pushliteral(L: Plua_State; s: PChar);
begin
  lua_pushlstring(L, s, Length(s));
end;

procedure lua_setglobal(L: Plua_State; const s: PChar);
begin
  lua_setfield(L, LUA_GLOBALSINDEX, s);
end;

procedure lua_getglobal(L: Plua_State; const s: PChar);
begin
  lua_getfield(L, LUA_GLOBALSINDEX, s);
end;

function lua_tostring(L: Plua_State; i: Integer): PChar;
begin
  Result := lua_tolstring(L, i, nil);
end;         

procedure lua_getregistry(L: Plua_State);
begin
  lua_pushvalue(L, LUA_REGISTRYINDEX);
end;

function lua_getgccount(L: Plua_State): Integer;
begin
  Result := lua_gc(L, LUA_GCCOUNT, 0);
end;         

procedure lua_pushstring(L: Plua_State; const s: string);
begin
  lua_pushlstring(L, PChar(s), Length(s));
end;

function luaL_getn(L: Plua_State; n: Integer): Integer;
begin
  Result := lua_objlen(L, n);
end;

procedure luaL_setn(L: Plua_State; t, n: Integer);
begin
  // does nothing as this operation is deprecated
end;        

procedure luaL_argcheck(L: Plua_State; cond: Boolean; numarg: Integer; extramsg: PChar);
begin
  if not cond then
    luaL_argerror(L, numarg, extramsg)
end;

function luaL_checkstring(L: Plua_State; n: Integer): PChar;
begin
  Result := luaL_checklstring(L, n, nil)
end;

function luaL_optstring(L: Plua_State; n: Integer; d: PChar): PChar;
begin
  Result := luaL_optlstring(L, n, d, nil)
end;

function luaL_checkint(L: Plua_State; n: Integer): Integer;
begin
  Result := Integer(Trunc(luaL_checknumber(L, n)))
end;

function luaL_checklong(L: Plua_State; n: Integer): LongInt;
begin
  Result := LongInt(Trunc(luaL_checknumber(L, n)))
end;

function luaL_optint(L: Plua_State; n: Integer; d: Double): Integer;
begin
  Result := Integer(Trunc(luaL_optnumber(L, n, d)))
end;

function luaL_optlong(L: Plua_State; n: Integer; d: Double): LongInt;
begin
  Result := LongInt(Trunc(luaL_optnumber(L, n, d)))
end;           

function luaL_typename(L: Plua_State; i: Integer): PChar;
begin
  Result := lua_typename(L, lua_type(L, i));
end;  

function lua_dofile(L: Plua_State; const filename: PChar): Integer;
begin
  Result := luaL_loadfile(L, filename);
  if Result = 0 then
    Result := lua_pcall(L, 0, LUA_MULTRET, 0);
end;

function lua_dostring(L: Plua_State; const str: PChar): Integer;
begin
  Result := luaL_loadstring(L, str);
  if Result = 0 then
    Result := lua_pcall(L, 0, LUA_MULTRET, 0);
end;   

procedure lua_Lgetmetatable(L: Plua_State; tname: PChar);
begin
  lua_getfield(L, LUA_REGISTRYINDEX, tname);
end;        

procedure luaL_addchar(B: PluaL_Buffer; c: Char);
begin
  if Cardinal(@(B^.p)) < (Cardinal(@(B^.buffer[0])) + LUAL_BUFFERSIZE) then
    luaL_prepbuffer(B);
  B^.p[1] := c;
  B^.p := B^.p + 1;
end;

procedure luaL_putchar(B: PluaL_Buffer; c: Char);
begin
  luaL_addchar(B, c);
end;

procedure luaL_addsize(B: PluaL_Buffer; n: Integer);
begin
  B^.p := B^.p + n;
end;             

procedure lua_unref(L: Plua_State; ref: Integer);
begin
  luaL_unref(L, LUA_REGISTRYINDEX, ref);
end;

procedure lua_getref(L: Plua_State; ref: Integer);
begin
  lua_rawgeti(L, LUA_REGISTRYINDEX, ref);
end;     

end.

