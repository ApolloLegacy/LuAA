--[[
                     _               ____ ____
                    | |             / _  |  _ \
                    | |      __  __/ /_| | |_\ \ 
                    | |     / / / /  __  |  __  \
                    | |____/ /_/ /  /  | | |  \  \ 
                    |______\____/__/   |_|_|   \__\
                    
    Name :          LuAA - system.lua
                    System library.
    Purpose :        
                    LuAA is a mobile visual novel application programmed in an open-source distribution of the extensible language, Lua, namely MicroLua. MicroLua is designed for ARM hardware architecture, specifically for an ARM7/ARM9 processor configuration found in the Nintendo DS. Thus, it disallows allocation of memory past 4MB, internally. It is packaged with the compiled (proprietary) ARM7/ARM9 binaries to prevent user manipulation. However, the front-end programmed in MicroLua is powerful enough for user customizability (re-compile all included files using NDSTool -> Pack to compile a .nds file). LuAA placed 1st in the Neoflash Spring Coding Competition 2009, originally named AceAttorneyDS (http://www.neoflash.com/forum/index.php?topic=5557.0), winning a $300 prize.

    Author :        Copyright 2009 Daniel Li (http://x711Li.com/)
    Created :       12/27/09
    Tools :         MicroLua used under GNU GPL, version 3.0
    License :
                    This file is part of LuAA.
                    LuAA is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
                    LuAA is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
                    You should have received a copy of the GNU General Public License along with LuAA. If not, see http://www.gnu.org/licenses/.
]]

System = {}

System.currentDirectory = function() return ds_system.currentDirectory() end
System.changeDirectory = function(dir)
	assert(dir ~= nil, "Directory name can't be null")
	ds_system.changeCurrentDirectory(dir)
end
System.remove = function(file)
	assert(file ~= nil, "Parameter must be a file name or a directory name")
	ds_system.remove(file)
end	
System.rename = function(file1, file2)
	assert(file1 ~= nil, "Parameters 1 must be a file name or a directory name")
	assert(file2 ~= nil, "Parameters 2 must be a file name or a directory name")
	ds_system.rename(file1, file2)
end
System.makeDirectory = function(dir)
	assert(dir ~= nil, "Parameter must be a directory name")
	ds_system.makeDirectory(dir)
end
System.listDirectory = function(dir)
	assert(dir ~= nil, "Parameter must be a directory name")
	tabFile = {}
	tabDir = {}
	ret = ds_system.listDirectory(dir)		
	while ret ~= "##" do
		if string.sub(ret,1 , 1) ~= "ù" then -- Strange but useful...
			obj = {}
			if string.sub(ret,1 , 1) == "*" then
				obj.name = string.sub(ret, 2)
				obj.isDir = true
				table.insert(tabDir, obj)			
			else
				obj.name = ret
				obj.isDir = false
				table.insert(tabFile, obj)
			end
		end
		ret = ds_system.listDirectory(dir)
	end
	tab = {}
	for key, value in pairs(tabDir) do table.insert(tab, value) end
	for key, value in pairs(tabFile) do table.insert(tab, value) end
	tabDir = nil
	tabFile = nil
	return tab
end