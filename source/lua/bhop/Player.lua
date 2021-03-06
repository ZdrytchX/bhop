local kBodyYawTurnThreshold = Math.Radians(50) --85deg

function Player:GetAirControl()
    return 0
end


function Player:ModifyVelocity(input, velocity, deltaTime)

    if not self.onGround then

      --initialisin
      local laccelmod = 70--acceleration modifier
      local lAirAcceleration = self:GetMaxSpeed() * 2 --accelerate to maximum speed in one second
      local wishDir = self:GetViewCoords():TransformVector(input.move) --this is a unit vector
      --remove vertical direction, UWE fucked something up again
      wishDir.y = 0
      wishDir:Normalize()

      local wishDircurrentspeed = velocity:DotProduct(wishDir) --current velocity along wishdir axis

      lAirAcceleration = lAirAcceleration * 0.1

      local addspeedlimit = lAirAcceleration - wishDircurrentspeed
      if addspeedlimit <= 0 then return end

      accelerationIncrement = laccelmod * deltaTime * lAirAcceleration
      if accelerationIncrement > addspeedlimit then
        accelerationIncrement = addspeedlimit
      end

      velocity:Add(wishDir * accelerationIncrement)

    end

end

function Player:GetGroundFriction()
    return 3
end
