function Skulk:GetAirControl()
    return 0
end

function Skulk:ModifyVelocity(input, velocity, deltaTime)
    --Air Strafe testing...
    if not self.onGround then

      --initialisin
      local laccelmod = 70--acceleration value
      local lAirAcceleration = self:GetMaxSpeed() * 2--maxSpeedTable.maxSpeed --accelerate to maximum speed in one second
      local wishDir = self:GetViewCoords():TransformVector(input.move) --this is a unit vector

      local wishDircurrentspeed = velocity:DotProduct(wishDir) --current velocity along wishdir axis
      --Q1 strafe check
      laccelmod = 70
      lAirAcceleration = lAirAcceleration * 0.1

      local addspeedlimit = lAirAcceleration - wishDircurrentspeed
      if addspeedlimit <= 0 then return end

      accelerationIncrement = laccelmod * deltaTime * lAirAcceleration
      if accelerationIncrement > addspeedlimit then accelerationIncrement = addspeedlimit end

      --remove vertical speed
      wishDir.y = 0
      wishDir:Normalize()

      velocity:Add(wishDir * accelerationIncrement)

  end

end

function Skulk:GetAirFriction()
    return 0
end
