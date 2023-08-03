install( "packages/markers-base", "https://github.com/Pika-Software/markers-base" )

if SERVER then
    local packageName = gpm.Package:GetIdentifier()
    local CurTime = CurTime

    hook.Add( "MarkerCreate", "Rate Limiter", function( ply, traceResult )
        if not traceResult.Hit or traceResult.HitSky then return false end
        ply[ packageName ] = CurTime()
    end )

    hook.Add( "CanCreateMarker", "Simple Rate Limiter", function( ply )
        if not ply:Alive() then return false end

        local lastCreation = ply[ packageName ]
        if not lastCreation then return end
        if ( CurTime() - lastCreation ) < 0.1 then
            return false
        end
    end )

    return
end

local LocalPlayer = LocalPlayer
local IN_ATTACK = IN_ATTACK
local IN_WALK = IN_WALK

local lastClick = 0

hook.Add( "CreateMove", "Easy Creating", function( cmd )
    if cmd:KeyDown( IN_WALK ) and cmd:KeyDown( IN_ATTACK ) then
        cmd:RemoveKey( IN_ATTACK )

        local time = CurTime()
        local isBlocked = time - lastClick < 0.025
        lastClick = time

        local ply = LocalPlayer()
        if not ply:Alive() then return end
        if isBlocked then return end

        ply:ConCommand( "marker" )
    end
end )