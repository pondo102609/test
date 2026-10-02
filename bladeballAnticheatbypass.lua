-- 1q2l // bom
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lp = Players.LocalPlayer
local cam = workspace.CurrentCamera or workspace:WaitForChild("Camera")

local controllers = ReplicatedStorage.Controllers
local sc
for _, c in ipairs(controllers:GetChildren()) do
    if c.Name:match("SwordsController") then
        sc = c
        break
    end
end

local pry = require(sc:FindFirstChild("PRY"))
local ups = debug.getupvalues(pry)

local done = {}
local channels = {}
for _, r in ipairs({ups[1], ups[2]}) do
    if r and r:IsA("RemoteEvent") and not done[r] then
        done[r] = true
        table.insert(channels, r)
    end
end

local alertBlocked = 0
local x23Blocked = 0
local alertKeys = {["64565gfdd"] = true, ["494kjkdf"] = true}

for _, ch in ipairs(channels) do
    local orig = ch.FireServer
    local prev
    prev = hookfunction(orig, function(self, ...)
        local a = {...}
        if type(a[2]) == "string" and alertKeys[a[2]] then
            alertBlocked = alertBlocked + 1
            return
        end
        if #a == 1 and type(a[1]) == "string" and a[1] == "X-23" then
            x23Blocked = x23Blocked + 1
            return
        end
        return prev(self, ...)
    end)
end

local cfg = {
    toggle = Enum.KeyCode.P,
    stop = Enum.KeyCode.Insert,
    parryCd = 0.0,
    spamRate = 0.045,
}

local on = false
local mainLoop = nil
local lastParry = 0
local t0 = 0
local shots = 0

local function ball()
    local b = workspace:FindFirstChild("Balls")
    if not b then return nil end
    for _, v in ipairs(b:GetChildren()) do
        if v:GetAttribute("realBall") == true then return v end
    end
    return nil
end

local function pick()
    local best = nil
    local bestD = math.huge
    local mp = UserInputService:GetMouseLocation()
    local af = workspace:FindFirstChild("Alive")
    if not af then return nil end
    for _, ch in ipairs(af:GetChildren()) do
        if ch:IsA("Model") and ch:FindFirstChild("HumanoidRootPart") and ch ~= lp.Character then
            local v, onS = cam:WorldToViewportPoint(ch.HumanoidRootPart.Position)
            if onS then
                local d = (Vector2.new(v.X, v.Y) - mp).Magnitude
                if d < bestD then
                    best = ch
                    bestD = d
                end
            end
        end
    end
    return best
end

local function nearest()
    local c = workspace.CurrentCamera
    if not c then return nil end
    local cf = c.CFrame
    local bd = -math.huge
    local bp
    local af = workspace:FindFirstChild("Alive")
    if not af then return nil end
    for _, ch in pairs(af:GetChildren()) do
        if ch.Name ~= lp.Name and ch.PrimaryPart then
            local dir = (ch.PrimaryPart.Position - cf.Position).Unit
            local d = cf.LookVector:Dot(dir)
            if d > bd then
                bd = d
                bp = ch
            end
        end
    end
    if bd > 0.7 then return bp end
    return nil
end

local function pos()
    local p = {}
    local me = lp.Character
    local box = workspace:FindFirstChild("Alive") or workspace
    for _, ch in ipairs(box:GetChildren()) do
        if ch:IsA("Model") then
            local hrp = ch:FindFirstChild("HumanoidRootPart")
            if hrp then
                local pl = Players:GetPlayerFromCharacter(ch)
                local k
                if ch == me then k = lp.Name
                elseif pl then k = "Target<" .. pl.UserId .. ">"
                else k = ch.Name end
                p[k] = cam:WorldToScreenPoint(hrp.Position)
            end
        end
    end
    return p
end

local function shoot()
    local now = tick()
    if now - lastParry < cfg.parryCd then return end
    lastParry = now

    local p = pos()
    local m = UserInputService:GetMouseLocation()
    pcall(function()
        pry(0.5, cam.CFrame, p, {m.X, m.Y}, false)
    end)
    shots = shots + 1
end

local function spam()
    if not on then return end
    shoot()
end

local function tick_()
    if not on then return end

    local now = tick()
    local b = ball()
    local ch = lp.Character

    local clash = false
    if b and b:GetAttribute("target") == lp.Name and b:IsA("BasePart") then
        local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
        local foe = pick() or nearest()
        if hrp and foe and foe.PrimaryPart then
            local bv = 0
            if b.AssemblyLinearVelocity then
                bv = b.AssemblyLinearVelocity.Magnitude
            end
            local pbd = (hrp.Position - b.Position).Magnitude
            local ped = (hrp.Position - foe.PrimaryPart.Position).Magnitude
            local ping = 5
            local rng = ping + math.min(bv / 6, 95)
            if rng and pbd <= rng and ped <= (rng * 1.5) and pbd <= 25 then
                clash = true
            end
        end
    end

    if clash then
        if now - lastParry < cfg.spamRate then
            shoot()
        end
    end
end

RunService.Heartbeat:Connect(tick_)

UserInputService.InputBegan:Connect(function(i, g)
    if g then return end
    if i.KeyCode == cfg.stop then
        on = false
        if mainLoop then mainLoop:Disconnect(); mainLoop = nil end
        return
    end
    if i.KeyCode == cfg.toggle then
        on = true
        t0 = tick()
        if mainLoop then mainLoop:Disconnect() end
        mainLoop = RunService.Heartbeat:Connect(spam)
        shoot()
    end
end)

UserInputService.InputEnded:Connect(function(i)
    if i.KeyCode == cfg.toggle then
        on = false
        if mainLoop then mainLoop:Disconnect(); mainLoop = nil end
    end
end)
