-- Welcome to your new Castle project!
-- https://playcastle.io/get-started
-- Castle uses Love2D 11.1 for rendering and input: https://love2d.org/
-- See here for some useful Love2D documentation:
-- https://love2d-community.github.io/love-api/

-- Constants
local GAME_WIDTH = 320
local GAME_HEIGHT = 200
local RENDER_SCALE = 3
local NUM_STARS_PER_PLANE = 50
local WARP_FACTOR=3

-- Game vars
local total_time_elapsed = 0
local stars={}

-- helper function
function fromRGB(red, green, blue) -- alpha?
 return {red/255, green/255, blue/255}
end

local star_cols={
 -- dark to lightest
 fromRGB(24,20,37),
 fromRGB(58,68,102),
 fromRGB(139,155,180),
 fromRGB(255,255,255),
 fromRGB(44,232,245),
 fromRGB(255,00,68),
}



function love.load()
 -- force "point" scaling
 love.graphics.setDefaultFilter('nearest', 'nearest', 0)
 
 -- create the starfield
 for i = 1,#star_cols do
  for j = 1,NUM_STARS_PER_PLANE/i do
   -- create star
   local star = {
    x = love.math.random(0,GAME_WIDTH),
    y = love.math.random(0,GAME_HEIGHT),
    z = i,
    col = star_cols[i]
   }
   -- add to field
   table.insert(stars, star)
  end
 end
end

function love.draw()
 -- Resize the draw area
 
 love.graphics.scale(RENDER_SCALE, RENDER_SCALE)

 -- Draw stars
 for _, star in ipairs(stars) do
  love.graphics.setColor(star.col)
  love.graphics.rectangle("fill", star.x, star.y, 1, 1 )
  --love.graphics.points(5, 5) -- ignores scale factor *facepalm* 
 end

  local y_offset = 8 * math.sin(total_time_elapsed * 3)
  --love.graphics.print('Space... the Final Frontier!', 20, 30 + y_offset)
end

function love.update(dt)
  total_time_elapsed = total_time_elapsed + dt

  -- Move stars
  for _, star in ipairs(stars) do
    -- ...based on their Z-order depth
    star.x = star.x - (star.z * WARP_FACTOR*10) * dt
    -- Wrap star around screen
    if star.x < 0 then
     star.x=GAME_WIDTH
     star.y=love.math.random(0,GAME_HEIGHT)
    end
  end
end

