-- All Credits Go To: Auth Zero#7762

local player = game.Players.LocalPlayer
local villageplace = game:GetService"Workspace":FindFirstChild"rank"
RANKUP = false

function autorank()
while wait() do
            if RANKUP and player.statz.lvl:FindFirstChild("lvl").Value == 500 then
                repeat wait()
                    game.Players.LocalPlayer.startevent:FireServer("rankup")
                until player.statz.lvl:FindFirstChild("lvl").Value == 1 or not RANKUP
            end
        end
end

autorank()
