-- 加载h-lua
require "h-lua"

-- 禁用迷雾
cj.FogEnable(false)
cj.FogMaskEnable(false)

types = {
    unit = "创建单位",
    texttag = "创建飘浮字",
    ttgstyle = "创建带缩放漂浮字",
    effect = "创建特效",
    timer = "创建计时器",
}

henemy.setPlayers({
    hplayer.players[2],
    hplayer.players[3],
    hplayer.players[4],
    hplayer.players[5],
    hplayer.players[6],
    hplayer.players[7],
    hplayer.players[8],
    hplayer.players[9],
    hplayer.players[10],
    hplayer.players[11],
    hplayer.players[12],
})

--[[
    测试例子，进入游戏，敲入聊天信息
    -unit [frequency] [number] [during]
    -texttag [frequency] [number] [during]
    -ttgstyle [frequency] [number] [during]
    -effect [frequency] [number] [during]
    -timer [frequency] [number] [during]
]]
hevent.onChat(hplayer.players[1], '-', false, function(evtData)
    local chatString = evtData.chatString
    local chatOptions = string.explode(' ', chatString)
    local type = string.gsub(chatOptions[1] or "", "-", "")
    local frequency = tonumber(chatOptions[2] or 0.1)
    local number = tonumber(chatOptions[3] or 10000)
    local during = tonumber(chatOptions[4] or 3)
    if (type == "" or table.includes(type, {
        "unit",
        "texttag",
        "ttgstyle",
        "effect",
        "timer",
    }) == false) then
        return
    end
    print_mb("========" .. types[type] .. "测试开始========")
    local n = 0
    htime.setInterval(frequency, function(t)
        n = n + 1
        if (n % 1000 == 0) then
            print_mb("=======>" .. types[type] .. n .. "次")
        end
        if (n > number) then
            htime.delTimer(t)
            print_mb("========" .. types[type] .. "测试结束========")
            return
        end
        local x = math.random(0, 1000)
        local y = math.random(0, 1000)
        if (type == "unit") then
            --测试创建单位
            henemy.create({
                unitId = "hfoo",
                x = x,
                y = y,
                during = during,
            })
        elseif (type == "texttag") then
            --测试飘浮字
            htextTag.create2XY(
                x, y,
                math.random(0, 100),
                math.random(5, 10),
                nil,
                1,
                during,
                math.random(0, 50)
            )
        elseif (type == "ttgstyle") then
            --测试飘浮字
            htextTag.style(
                htextTag.create2XY(
                    x, y,
                    math.random(0, 100),
                    math.random(5, 10),
                    nil,
                    1,
                    during,
                    math.random(0, 50)
                ),
                'toggle',
                10,
                10
            )
        elseif (type == "effect") then
            --测试特效
            heffect.toXY(
                "Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl",
                x, y,
                during
            )
        elseif (type == "timer") then
            --测试计时器
            htime.setTimeout(math.random(1, 50), function(tt)
                htime.delTimer(tt)
            end)
        end
    end)

end)
