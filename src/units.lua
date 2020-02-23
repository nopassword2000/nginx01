--
-- Created by IntelliJ IDEA.
-- User: Administrator
-- Date: 2020/2/22 0022
-- Time: 22:27
-- To change this template use File | Settings | File Templates.
--

local _M = {}


local function splitex(szFullString, szSeparator)
    local nFindStartIndex = 1
    local nSplitIndex = 1
    local nSplitArray = {}
    while true do
        local nFindLastIndex,v = string.find(szFullString, szSeparator, nFindStartIndex)
        if  nFindLastIndex == nil
        then
            if nFindStartIndex > string.len(szFullString) then
                break
            else
                nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
                break
            end
        end

        if nFindLastIndex - 1 == 0 then
            nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex)
            nFindStartIndex = nFindLastIndex + string.len(szSeparator)
            nSplitIndex = nSplitIndex + 1
        else
            nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex -1)
            nFindStartIndex = nFindLastIndex + string.len(szSeparator)
            nSplitIndex = nSplitIndex + 1
        end
    end
    return nSplitArray
end

local function split(str, split_char)
    local sub_str_tab = {};

    while (true) do
        local pos = string.find(str, split_char);
        if (not pos) then
            local size_t = table.getn(sub_str_tab)
            table.insert(sub_str_tab,size_t+1,str);
            break;
        end

        local sub_str = string.sub(str, 1, pos - 1);
        local size_t = table.getn(sub_str_tab)
        table.insert(sub_str_tab,size_t+1,sub_str);
        local t = string.len(str);
        str = string.sub(str, pos + 1, t);
    end
    return sub_str_tab;
end
_M.split = split
_M.splitex = splitex

return _M

