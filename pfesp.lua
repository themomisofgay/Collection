local FILL_COLOR = Color3.fromRGB(47, 117, 135) -- fill color
local OUT_COLOR = Color3.fromRGB(67, 170, 193) -- outline color

local PlayerService = game:GetService('Players')

local playerFolder = workspace.Players
local player = PlayerService.LocalPlayer

local highlights = {}

local function GetTeam()
    return player.TeamColor
end

local function AddESP(character: Model)
    local highlight
    
    for i, v in highlights do
        if not v.Adornee or not v.Adornee.Parent then
            highlight = v
            break
        end
    end

    if not highlight then
        highlight = Instance.new('Highlight')
        highlight.FillColor = FILL_COLOR
        highlight.OutlineColor = OUT_COLOR
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Adornee = character

        table.insert(highlights, highlight)

        highlight.Parent = game:GetService('CoreGui')
    else
        highlight.Adornee = character
    end

    return highlight
end

-- check if requested character is an enemy
local function CheckEnemy(character: Model)
    local tag = character:FindFirstChild('PlayerTag', true)

    if tag then
        local name = tag.Text
        local plr = PlayerService:FindFirstChild(name)

        if plr then
            return plr.TeamColor ~= GetTeam()
        end
    end
end

local function CheckObj(obj: Instance)
    if obj:IsA('Model') and obj:FindFirstChildOfClass('Folder') then
        task.wait()
        
        -- make sure its a plr bc on one map some random gas canister was being highlighted n that was taking up a highlight
        if not obj:FindFirstChild('PlayerTag', true) then
            return
        end

        local isEnemy = CheckEnemy(obj)

        if isEnemy then
            AddESP(obj)
        end
    end
end

for i, obj in playerFolder:GetDescendants() do
    CheckObj(obj)
end

playerFolder.DescendantAdded:Connect(function(obj: Instance)
    CheckObj(obj)
end)

