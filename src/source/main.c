#include <stdio.h>
#include <stdlib.h>

#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

#include <ulib/ulib.h>
#include <fat.h>
#include <unistd.h>

#include <dswifi9.h>
#include <netinet/in.h>

#include "constants.h"
#include "efs_lib.h"

void print_error(char *text)
{
    while (1)
    {
        ulStartDrawing2D();
        ulDrawTextBox(0, 0, 256, 192, text, 0);
        ulEndDrawing();
        ulSyncFrame();
    }
}

int main()
{
    // Initialization of �library
    ulInit(UL_INIT_ALL);
    ulInitGfx();
    ulInitText();

    // Sucks banks C-D + drops at 30 fps
    ulInitDualScreenMode();

    // Banks A-B for textures VRAM
    ulSetTexVramParameters(UL_BANK_A | UL_BANK_B, VRAM_A, 256 << 10);

    // Banks F-G for palettes VRAM
    ulSetTexPalVramParameters(UL_BANK_F | UL_BANK_G, VRAM_F, 32 << 10);

    // Use bright pink as a transparent color
    ulSetTransparentColor(RGB15(31, 0, 31));

    //Initialization libfat
    if (!EFS_Init(EFS_AND_FAT | EFS_DEFAULT_DEVICE, NULL)) {
        print_error("\n\nFailed to initialize embedded file system\n");
        return 0;
    }
    chdir("/");
    
    struct lua_State *l = lua_open();
    if (!l) {
        print_error("\n\nFailed to create a Lua state - Push A to Exit\n");
        return 0;
    }
    
    luaL_openlibs(l);
    uLua_pushConstants(l);
    
    if (luaL_loadfile(l, ULUA_BOOT_FULLPATH)) {
        if (luaL_loadfile(l, "LuAA/core/main.lua")) {
            char text[256];
            sprintf(text,"Error Occured: Couldn't open %s\n", ULUA_BOOT_FILE);
            print_error(text);
            return 0;
        }
    }
    
    if (lua_pcall(l, 0, 0, 0)) {
        print_error(lua_tostring(l, -1));
        lua_pop(l, 1);
        return 0;
    }
    
    lua_close(l);

    return 0;
}
