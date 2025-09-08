local lfs = require("lfs")

local function getFileList(directory)
    local fileList = {}
    for file in lfs.dir(directory) do
        if file ~= "." and file ~= ".." then
            table.insert(fileList, file)
        end
    end
    return fileList
end

local directory = "C:\\Users\\Adam\\Desktop\\Lua Game\\Maker"
local files = getFileList(directory)

return files