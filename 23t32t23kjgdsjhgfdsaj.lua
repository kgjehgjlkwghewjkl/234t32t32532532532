local OriginalLookAlong = CFrame.lookAlong
local CFrameHookActive = false

local function HookedLookAlong(position, direction, up)
    if position == Vector3.zero or (position.X == 0 and position.Y == 0 and position.Z == 0) then
        if getgenv().Config and getgenv().Config.SilentAimEnabled and getgenv().currentSilentTarget then
            local target = getgenv().currentSilentTarget
            if target.Parent and target:IsDescendantOf(workspace) then
                local Camera = workspace.CurrentCamera
                if Camera then
                    local camPos = Camera.CFrame.Position
                    local targetPos = target.Position
                    local newDir = (targetPos - camPos).Unit

                    if up then
                        return OriginalLookAlong(position, newDir, up)
                    else
                        return OriginalLookAlong(position, newDir)
                    end
                end
            else
                getgenv().currentSilentTarget = nil
            end
        end
    end
        if up then
        return OriginalLookAlong(position, direction, up)
    else
        return OriginalLookAlong(position, direction)
    end
end

if hookfunction and not CFrameHookActive then
    local success = pcall(function()
        OriginalLookAlong = hookfunction(CFrame.lookAlong, HookedLookAlong)
        CFrameHookActive = true
    end)
    
    if not success then
        --warn("[Silent Aim] Failed to setup hook")
    end
end
