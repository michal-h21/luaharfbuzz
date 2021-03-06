// Utility functions to create Lua classes.
#include "luaharfbuzz.h"

int register_class(lua_State *L, const char *name, const luaL_Reg * methods, const luaL_Reg *functions) {
  luaL_newmetatable(L, name);
  lua_pushvalue(L, -1);
  lua_setfield(L, -2, "__index");

  luaL_setfuncs(L, methods, 0);
  lua_pop(L,1);

  luaL_newlib(L, functions);
  luaL_getmetatable(L, name);
  lua_setmetatable(L, -2);
  return 1;
}

