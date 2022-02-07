--[[

░█████╗░███╗░░██╗░█████╗░███╗░░██╗██╗░░░██╗███╗░░░███╗░█████╗░██╗░░░██╗░██████╗  ██╗░░██╗██╗░░░██╗██████╗░
██╔══██╗████╗░██║██╔══██╗████╗░██║╚██╗░██╔╝████╗░████║██╔══██╗██║░░░██║██╔════╝  ██║░░██║██║░░░██║██╔══██╗
███████║██╔██╗██║██║░░██║██╔██╗██║░╚████╔╝░██╔████╔██║██║░░██║██║░░░██║╚█████╗░  ███████║██║░░░██║██████╦╝
██╔══██║██║╚████║██║░░██║██║╚████║░░╚██╔╝░░██║╚██╔╝██║██║░░██║██║░░░██║░╚═══██╗  ██╔══██║██║░░░██║██╔══██╗
██║░░██║██║░╚███║╚█████╔╝██║░╚███║░░░██║░░░██║░╚═╝░██║╚█████╔╝╚██████╔╝██████╔╝  ██║░░██║╚██████╔╝██████╦╝
╚═╝░░╚═╝╚═╝░░╚══╝░╚════╝░╚═╝░░╚══╝░░░╚═╝░░░╚═╝░░░░░╚═╝░╚════╝░░╚═════╝░╚═════╝░  ╚═╝░░╚═╝░╚═════╝░╚═════╝░

]] --

-- Services
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")

-- Variables
local Player = Players.LocalPlayer
local Gamepass = Player.Data.gamepasses

-- Client Settings
local Client = {
    FarmPage = {
        AutoClick = false,
        AutoSpin = false,
        AutoAchievements = false,
        AutoGifts = false,
        AutoBuyRebirths = false,
        AutoBuyJumps = false
    },
    ImportantPage = {
        AutoHatch = false,
        AutoTripleHatch = false,
        SelectedEgg = "",
        AutoRebirth = false,
        AutoPaidRebirth = false,
        SelectedRebirth = "",
        SelectedPaidRebirth = "",
        AutoShiny = false,
        AutoGolden = false,
        AutoBest = false,
        AutoMassDelete = false
    },
    MiscPage = {
        Zone = "",
        WalkSpeedChanger = false,
        JumpPowerChanger = false
    }
};

-- Tables
local rebirthShop = require(RS.RebirthShopModule).rebirthShop
local mod = require(RS.FunctionsModule)

local shopTable = {}
for _, v in next, rebirthShop do
    if rawget(v, 'name') then
        table.insert(shopTable, v.name)
    end
end

local function giveEggs()
    local eggsTable = {}
    for _, v in next, WS.Eggs:GetChildren() do
        table.insert(eggsTable, v.Name)
    end
    return eggsTable
end

local function giveRebirths()
    local rebirthsTable = {1, 5, 10}
    for _, v in next, rebirthShop do
        if rawget(v, 'rebirthOption') then
            table.insert(rebirthsTable, v.rebirthOption)
        end
    end
    return rebirthsTable
end

local function giveZones()
    local zonesTable = {}
    for i, v in next, WS.Zones:GetChildren() do
        table.insert(zonesTable, v.Name)
    end
    return zonesTable
end

-- Init
local Mercury = loadstring(game:HttpGet("https://raw.githubusercontent.com/deeeity/mercury-lib/master/src.lua"))()
local GUI = Mercury:Create{
    Name = "Andromeda Software",
    Size = UDim2.fromOffset(600, 400),
    Theme = Mercury.Themes.Dark,
    Link = "https://scriptblox.com/script/Clicker-Simulator_588"
}

local FarmTab = GUI:Tab{
    Name = "Player Utilities",
    Icon = "rbxassetid://7072717697"
}

local GameTab = GUI:Tab{
    Name = "Game Utilities",
    Icon = "rbxassetid://7072720922"
}

local MiscTab = GUI:Tab{
    Name = "Misc",
    Icon = "rbxassetid://7072721682"
}

-- Farm Tab | Script
FarmTab:Toggle({
    Name = "Auto Click",
    StartingState = false,
    Description = nil,
    Callback = function(state)
        Client.FarmPage.AutoClick = state

        while Client.FarmPage.AutoClick do
            task.wait()
            local env = getsenv(Player.PlayerGui.mainUI.LocalScript)
            local func = env.activateClick(p12)
        end
    end
});

FarmTab:Toggle({
    Name = "Auto Spin Wheel",
    StartingState = false,
    Description = nil,
    Callback = function(state)
        Client.FarmPage.AutoSpin = state

        while Client.FarmPage.AutoSpin do
            task.wait()
            if Player.Data.freeSpinTimeLeft.Value == 0 then
                RS.Events.Client.spinWheel:InvokeServer()
            end
        end
    end
});

FarmTab:Button({
    Name = "Redeem All Codes",
    Description = nil,
    Callback = function()
        local codesTable = {"freeautohatch", "20KLIKES", "30klikes", "50KLikes", "75KLIKES"}
        for _, v in pairs(codesTable) do
            RS.Events.Client.useTwitterCode:InvokeServer(v)
        end
    end
});

FarmTab:Toggle({
    Name = "Auto Collect Quests",
    StartingState = false,
    Description = nil,
    Callback = function(state)
        Client.FarmPage.AutoAchievements = state

        while Client.FarmPage.AutoAchievements do
            task.wait(0.1)
            for i, v in next, Player.currentQuests:GetChildren() do
                if v.questCompleted.Value == true then
                    RS.Events.Client.claimQuest:FireServer(v.Name)
                end
            end
        end
    end
});

FarmTab:Toggle({
    Name = "Auto Collect Gifts",
    StartingState = false,
    Description = nil,
    Callback = function(state)
        Client.FarmPage.AutoGifts = state

        while Client.FarmPage.AutoGifts do
            task.wait()
            for i, v in pairs(getconnections(Player.PlayerGui.randomGiftUI.randomGiftBackground.Background.confirm
                                                 .MouseButton1Click)) do
                v.Function()
            end
        end
    end
});

FarmTab:Button({
    Name = "Collect Chests",
    Description = nil,
    Callback = function()
        for i, v in pairs(WS.Chests:GetChildren()) do
            RS.Events.Client.claimChestReward:InvokeServer(v.Name)
        end
    end
});

FarmTab:Toggle({
    Name = "Auto Buy Rebirths",
    StartingState = false,
    Description = nil,
    Callback = function(state)
        Client.FarmPage.AutoBuyRebirths = state

        while Client.FarmPage.AutoBuyRebirths do
            task.wait(0.2)
            for _, v in pairs(shopTable) do
                RS.Events.Client.purchaseRebirthShopItem:FireServer(v)
            end
        end
    end
});

FarmTab:Toggle({
    Name = "Auto Buy Jumps",
    StartingState = false,
    Description = nil,
    Callback = function(state)
        Client.FarmPage.AutoBuyJumps = state

        while Client.FarmPage.AutoBuyJumps do
            task.wait(0.2)
            for i, v in next, WS.Clouds:GetChildren() do
                RS.Events.Client.upgrades.upgradeDoubleJump:FireServer(v.Name)
            end
        end
    end
});

-- Game Tab | Script
GameTab:Dropdown({
    Name = "Eggs List",
    StartingText = "Select...",
    Description = nil,
    Items = giveEggs(),
    Callback = function(value)
        Client.ImportantPage.SelectedEgg = value
    end
});

GameTab:Toggle({
    Name = "Auto Hatch",
    StartingState = false,
    Description = nil,
    Callback = function(state)
        Client.ImportantPage.AutoHatch = state

        while Client.ImportantPage.AutoHatch do
            task.wait(0.1)
            RS.Events.Client.purchaseEgg2:InvokeServer(WS.Eggs[Client.ImportantPage.SelectedEgg], false, false)
        end
    end
});

GameTab:Dropdown({
    Name = "Rebirths List",
    StartingText = "Select...",
    Description = nil,
    Items = giveRebirths(),
    Callback = function(value)
        Client.ImportantPage.SelectedRebirth = value
    end
});

GameTab:Toggle({
    Name = "Auto Rebirth",
    StartingState = false,
    Description = nil,
    Callback = function(state)
        Client.ImportantPage.AutoRebirth = state

        while Client.ImportantPage.AutoRebirth do
            task.wait(0.3)
            local calculate =
                mod.calculateRebirthsCost(Player.Data.Rebirths.Value, Client.ImportantPage.SelectedRebirth)
            if calculate <= tonumber(Player.Data.Clicks.Value) then
                RS.Events.Client.requestRebirth:FireServer(tonumber(Client.ImportantPage.SelectedRebirth), false, false)
            end
        end
    end
});

GameTab:Textbox({
    Name = "Rebirth Value",
    Callback = function(value)
        Client.ImportantPage.SelectedPaidRebirth = value
    end
});

GameTab:Toggle({
    Name = "Auto Infinite Rebirth",
    StartingState = false,
    Description = "Require the infinite rebirth gamepass!",
    Callback = function(state)
        Client.ImportantPage.AutoRebirth = state

        while Client.ImportantPage.AutoRebirth do
            task.wait(0.3)
            local calculate = mod.calculateRebirthsCost(Player.Data.Rebirths.Value,
                Client.ImportantPage.SelectedPaidRebirth)
            if calculate <= tonumber(Player.Data.Clicks.Value) then
                RS.Events.Client.requestRebirth:FireServer(tonumber(Client.ImportantPage.SelectedPaidRebirth), true,
                    false)
            end
        end
    end
});

GameTab:Toggle({
    Name = "Auto Shiny",
    StartingState = false,
    Description = false,
    Callback = function(state)
        Client.ImportantPage.AutoShiny = state

        while Client.ImportantPage.AutoShiny do
            task.wait(0.3)
            for i, v in pairs(Player.petOwned:GetChildren()) do
                RS.Events.Client.upgradePet:FireServer(v.name.Value, 1, v)
            end
        end
    end
});

GameTab:Toggle({
    Name = "Auto Golden",
    StartingState = false,
    Description = false,
    Callback = function(state)
        Client.ImportantPage.AutoGolden = state

        while Client.ImportantPage.AutoGolden do
            task.wait(0.3)
            for i, v in pairs(Player.petOwned:GetChildren()) do
                RS.Events.Client.upgradePet:FireServer(v.name.Value, 2, v)
            end
        end
    end
});

GameTab:Toggle({
    Name = "Auto Equip Best",
    StartingState = false,
    Description = false,
    Callback = function(state)
        Client.ImportantPage.AutoBest = state

        while Client.ImportantPage.AutoBest do
            task.wait()
            if Player.PlayerGui.framesUI.petsBackground.Background.background.tools.equipBest.BackgroundColor3 ==
                Color3.fromRGB(64, 125, 255) then
                RS.Events.Client.petsTools.equipBest:FireServer()
            end
        end
    end
});

GameTab:Toggle({
    Name = "Auto Mass Delete",
    StartingState = false,
    Description = false,
    Callback = function(state)
        Client.ImportantPage.AutoMassDelete = state

        while Client.ImportantPage.AutoMassDelete do
            task.wait(0.5)
            RS.Events.Client.petsTools.deleteUnlocked:FireServer()
        end
    end
});

-- Misc Tab | Script

MiscTab:Button({
    Name = "Unlock Auto Click Gamepass",
    Description = nil,
    Callback = function()
        Gamepass.Value = Gamepass.Value .. ";autoclicker;"
    end
});

MiscTab:Button({
    Name = "Unlock Auto Rebirth Gamepass",
    Description = nil,
    Callback = function()
        Gamepass.Value = Gamepass.Value .. ";autorebirth;"
    end
});

MiscTab:Button({
    Name = "2x Clicks",
    Description = nil,
    Callback = function()
        Player.Boosts.DoubleClicks.isActive.Value = true
    end
});

MiscTab:Dropdown({
    Name = "Zones List",
    StartingText = "Select...",
    Description = nil,
    Items = giveZones(),
    Callback = function(value)
        Client.MiscPage.Zone = value
    end
});

MiscTab:Button({
    Name = "Teleport",
    Description = nil,
    Callback = function()
        Player.Character.HumanoidRootPart.CFrame = CFrame.new(
            WS.Zones[Client.MiscPage.Zone].Island.Platform.UIPart.Position)
    end
});

MiscTab:Toggle({
    Name = "WalkSpeed",
    StartingState = false,
    Description = false,
    Callback = function(state)
        Client.MiscPage.WalkSpeedChanger = state
    end
});

MiscTab:Slider({
    Name = "WalkSpeed Amount",
    Default = 16,
    Min = 1,
    Max = 500,
    Callback = function(value)
        while task.wait() do
            if Client.MiscPage.WalkSpeedChanger == true then
                Player.Character.Humanoid.WalkSpeed = value
            else
                if Client.MiscPage.WalkSpeedChanger == false then
                    Player.Character.Humanoid.WalkSpeed = 16
                end
            end
        end
    end
});

MiscTab:Toggle({
    Name = "JumpPower",
    StartingState = false,
    Description = false,
    Callback = function(state)
        Client.MiscPage.JumpPowerChanger = state
    end
});

MiscTab:Slider({
    Name = "JumpPower Amount",
    Default = 50,
    Min = 1,
    Max = 500,
    Callback = function(value)
        while task.wait() do
            if Client.MiscPage.JumpPowerChanger == true then
                Player.Character.Humanoid.JumpPower = value
            else
                if Client.MiscPage.JumpPowerChanger == false then
                    Player.Character.Humanoid.JumpPower = 50
                end
            end
        end
    end
});
