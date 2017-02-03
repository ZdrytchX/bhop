local kBlinkSpeed = 14
local kBlinkAcceleration = 40
local kBlinkAddAcceleration = 1

Fade.kShadowStepDuration = 0.4--0.25

-- Delay before you can blink again after a blink.
local kMinEnterEtherealTime = 0.75--0.4

function Fade:GetGroundFriction()
    return 3.72
end

function Fade:GetAirControl()
    return 0
end

function Fade:GetAirFriction()
    return 0
end

function Fade:GetRecentlyBlinked(player)
    return Shared.GetTime() - self.etherealEndTime < kMinEnterEtherealTime
end

function Fade:ModifyVelocity(input, velocity, deltaTime)

    if self:GetIsBlinking() then

        local wishDir = self:GetViewCoords().zAxis
        local maxSpeedTable = { maxSpeed = kBlinkSpeed }
        self:ModifyMaxSpeed(maxSpeedTable, input)
        local prevSpeed = velocity:GetLength()
        local maxSpeed = math.max(prevSpeed, maxSpeedTable.maxSpeed)
        local maxSpeed = math.min(25, maxSpeed)

        velocity:Add(wishDir * kBlinkAcceleration * deltaTime)

        if velocity:GetLength() > maxSpeed then

            velocity:Normalize()
            velocity:Scale(maxSpeed)

        end

        -- additional acceleration when holding down blink to exceed max speed
        velocity:Add(wishDir * kBlinkAddAcceleration * deltaTime)

    end

    if not self.onGround then

      --initialisin
      local laccelmod = 70--acceleration value
      local lAirAcceleration = self:GetMaxSpeed() * 2 --accelerate to maximum speed in one second
      local wishDir = self:GetViewCoords():TransformVector(input.move) --this is a unit vector

      --remove vertical direction, UWE fucked something up again
      wishDir.y = 0

      local wishDircurrentspeed = velocity:DotProduct(wishDir) --current velocity along wishdir axis

      lAirAcceleration = lAirAcceleration * 0.1

      local addspeedlimit = lAirAcceleration - wishDircurrentspeed
      if addspeedlimit <= 0 then return end

      accelerationIncrement = laccelmod * deltaTime * lAirAcceleration
      if accelerationIncrement > addspeedlimit then
        accelerationIncrement = addspeedlimit
      end

      wishDir:Normalize()

      velocity:Add(wishDir * accelerationIncrement)

    end

end
