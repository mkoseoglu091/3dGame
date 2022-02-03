pico-8 cartridge // http://www.pico-8.com
version 34
__lua__
--find your way out of the maze 

function _init()
 music()
 pl={}
 restart()
 pl.fly=false
end

function restart()
 pl.x = 3 
 pl.y = 3
 pl.z = 12
 pl.d = -0.25
 pl.dz = 0
end

function mc(x,y)
 return mget(x,y)
end

function mz(x,y)
 local col=mget(x,y)
 return 16-col*0.2
end

function _update()
 if pl.z == 16 then restart() sfx(1) end

 if (btn(0)) then pl.d=(pl.d+0.02)%1 end
 if (btn(1)) then pl.d=(pl.d+0.98)%1 end

 if (btn(2) or btn(3)) then
  if (btn(2)) then m=0.2 else m=-0.2 end
   dx = cos(pl.d)*m
   dy = sin(pl.d)*m
   if (mz(pl.x+dx*3, pl.y+dy*3) >
    pl.z - 0.4) then
     pl.x=pl.x+cos(pl.d)*m
     pl.y=pl.y+sin(pl.d)*m
   end
 end
 if (btn(5)) then
  restart()
 end

 -- z means player feet
 if (pl.z >= mz(pl.x,pl.y) and pl.dz >=0) then
  pl.z = mz(pl.x,pl.y)
  pl.dz = 0
 else
  pl.dz=pl.dz+0.01
  pl.z =pl.z + pl.dz
 end

 if (btn(4)) then 
  if (pl.z <= 15.9) and (pl.fly or mz(pl.x,pl.y) < pl.z+0.1) then
   sfx(0)
   pl.dz=-0.15
  end
 end

end

function draw_3d()
 local celz0
 local col
 -- calculate view plane (line)

 local v={}
 v.x0 = cos(pl.d+0.1) 
 v.y0 = sin(pl.d+0.1)
 v.x1 = cos(pl.d-0.1)
 v.y1 = sin(pl.d-0.1)


 for sx=0,127 do

  sy=127

  -- camera based on player pos
  x=pl.x
  y=pl.y
  z=pl.z-1 -- 1 unit high

  ix=flr(x)
  iy=flr(y)
  tdist=0
  col=mget(ix,iy)
  celz=16-col*0.2
  
  -- calc cast vector
  local t=sx/127
  vx = v.x0 * (1-t) + v.x1 * t
  vy = v.y0 * (1-t) + v.y1 * t
  dir_x = sgn(vx)
  dir_y = sgn(vy)

  skip_x = 1/abs(vx)
  skip_y = 1/abs(vy)

  if (sgn(vx) > 0) then
   dist_x = 1-(x%1) else
   dist_x =   (x%1) end
  if (sgn(vy) > 0) then
   dist_y = 1-(y%1) else
   dist_y =   (y%1) end

  dist_x = dist_x * skip_x
  dist_y = dist_y * skip_y

  -- start skipping
  skip=true
  skips=0

  while (skip) do

   skips = skips + 1
   if (dist_x < dist_y) then
    ix=ix+dir_x
    last_dir = 0
    dist_y = dist_y - dist_x
    tdist = tdist + dist_x
    dist_x = skip_x
    
    
   else
    iy=iy+dir_y
    last_dir = 1
    dist_x = dist_x - dist_y
    tdist = tdist + dist_y
    dist_y = skip_y
    
    
   end

   -- prev cel properties
   col0=col
   celz0=celz
   -- new cel properties
   col=mget(ix,iy)
   celz=16-col*0.2


--   print(ix.." "..iy.." "..col)
    
   if (col==15) then skip=false end

   --discard close hits
   if (tdist > 0.1) then
   -- screen space

   local sy1 = celz0-z
   sy1 = (sy1 * 64)/tdist
   sy1 = sy1 + 64 -- horizon 

   -- draw ground to new point
   if (sy1 < sy) then
    --line(sx,sy1-1,sx,sy,col0)
    gcol=8 -- ground color
    if(celz0 < 16) then 
     gcol=3 -- platform top color
    end
    line(sx,sy1-1,sx,sy,gcol)
    sy=sy1
   end

   -- draw wall if higher
   
   
   if (celz < celz0) then
    local sy1 = celz-z
    sy1 = (sy1 * 64)/tdist
    sy1 = sy1 + 64 -- horizon 
    if (sy1 < sy) then
     
     top_wall = flr(sy1-1)
     bottom_wall = flr(sy)
     
     --[[ --texture!!
     if sx < sy then -- what condition to use???
      tline(sx,top_wall,sx,bottom_wall, (pl.x+vx*dist_x)%1*2, 34, 0, 2/(bottom_wall-top_wall))
     else
      tline(sx,top_wall,sx,bottom_wall, (pl.y+vy*dist_y)%1*2, 34, 0, 2/(bottom_wall-top_wall))
     end
     ]]--
     
     --tline(sx,top_wall,sx,bottom_wall, (pl.x+vx*dist_x)%1*2, 34, 0, 2/(bottom_wall-top_wall))
     line(sx,sy1-1,sx,sy, last_dir*1+5)
     sy=sy1
    end
   end
  end   
  end -- skipping

 end -- sx

 --cursor(0,0) color(7)
 --print(pl.z)
 --print(pl.x)
 --print(pl.y)
 --print(stat(1))
end




function _draw()
 cls()
 -- sky color
 rectfill(0,0,127,127,0)
 draw_3d()
 if (false) then -- show map for debug
  mapdraw(0,0,0,0,32,32)
  pset(pl.x*8,pl.y*8,12)
  pset(pl.x*8+cos(pl.d)*2,pl.y*8+sin(pl.d)*2,13)
 end
 
 -- victory text
 if (pl.x > 0) and (pl.x < 4) and (pl.y > 22) and (pl.y < 31) then
  print("victory!!!", 55, 55, 0)
 end
end




__gfx__
00000000111111112222222233333333444444445555555566666666777777778888888899999999aaaaaaaabbbbbbbbccccccccddddddddeeeeeeeeffffffff
00000000111111112222222233333333444444445555555566666666777777778888888899999999aaaaaaaabbbbbbbbccccccccddddddddeeeeeeeeffffffff
00700700111111112222222233333333444444445555555566666666777777778888888899999999aaaaaaaabbbbbbbbccccccccddddddddeeeeeeeeffffffff
00077000111111112222222233333333444444445555555566666666777777778888888899999999aaaaaaaabbbbbbbbccccccccddddddddeeeeeeeeffffffff
00077000111111112222222233333333444444445555555566666666777777778888888899999999aaaaaaaabbbbbbbbccccccccddddddddeeeeeeeeffffffff
00700700111111112222222233333333444444445555555566666666777777778888888899999999aaaaaaaabbbbbbbbccccccccddddddddeeeeeeeeffffffff
00000000111111112222222233333333444444445555555566666666777777778888888899999999aaaaaaaabbbbbbbbccccccccddddddddeeeeeeeeffffffff
00000000111111112222222233333333444444445555555566666666777777778888888899999999aaaaaaaabbbbbbbbccccccccddddddddeeeeeeeeffffffff
cccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ccaaaacc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ccaaaacc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ccaaaacc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ccaaaacc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55555555556666550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55555555556666650000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55555555556666650000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55555555556666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55555555555666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55555555555555650000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55555555555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55555555555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55555555555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55555555555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55555555555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55555555555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55555555555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55555555555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55555555555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55555555555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04140000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05150000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f01010101010f01010101010101010101010f01010101010101010101010f01010101010101010101010f00000000000000000000000f07070700000000000f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f01010101010f01010101010101010101010f01010101010101010101010f01010101010101010101010f00040404000000000000000f07070700000007000f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f01010101010f01010101010101010101010f01010101010101010101010f01010101010101010101010f00040404000000040404000f07070700000007000f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f01010101010f01010101010101010101010f01010101010101010101010f01010101010101010101010f00000000000000040404000f0000000f0f0000000f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f01010101010f01010101010101010101010f01010101010101010101010f01010101010101010101010f00000000000000000000000f0000000f0f0000000f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f01010101010f01010101010f01010101010f01010101010f00000000000f00000000000f00000000000f00040400000f00000000000f0000000f0f0000000f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f01010101010f01010101010f01010101010f00000000000f00000000000f00000000000f02000000000f00040400000f00000000000f0000000f0f0007000f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f01010101010f00000100000f00000000000f00010101000f00010100000f00040404000f02000000000f00000000000f00000000000f0707070f0f0007000f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f01010101010f00000100000f00000000000f00010101000f00010100000f00040404000f00000000040f00000000000f00060606000f0707070f0f0000000f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f00000000000f00000000000f00010101000f00000000000f00000000000f00000000000f00000000040f00020200000f00060606000f0707070f0f0000000f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f00000000000f00000000000f00010101000f00010101000f00000000000f00030303000f05000000000f00020200000f00060606000f0000000f0f0000000f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f01010101010f00000100000f00010101000f00010101000f00000000000f00030303000f05000000000f00000000000f00000000000f0000000f0f0007000f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f01010101010f00000100000f00000000000f00000000000f00000101000f00000000000f00000000070f00000000000f00000000000f0000000f0f0007000f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f01010101010f01010101010f00000000000f00010101000f00000101000f00020202000f00000000070f00020200000f00000000000f0000000f0f0000000f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f01010101010f01010101010f01010101010f00010101000f00000000000f00020202000f00000000000f00020200000f00000000000f0707070f0f0000000f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f01010101010f01010101010f01010101010f00000000000f00000000000f00000000000f00000000000f00000000000f00000000000f0707070f0f0000000f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f01010101010101010101010f01010101010101010101010f01010101010101010101010f01010101010101010101010f0007070700000707070f0f0007000f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f01010101010101010101010f01010101010101010101010f01010101010101010101010f01010101010101010101010f0007070700000000000f0f0007000f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f01010101010101010101010f01010101010101010101010f01010101010101010101010f01010101010101010101010f0007070700000000000f0f0000000f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f01010101010101010101010f01010101010101010101010f01010101010101010101010f01010101010101010101010f0000000000000000000f0f0000000f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f01010101010101010101010f01010101010101010101010f01010101010101010101010f01010101010101010101010f0000000000000000000f0f0000000f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0101010f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f010101000000000f0000000000000000000f0000000000000000000f0000000000000000000000000707000000000000000000000707070707070f0202020f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f010101000000000f0000000000000000000f0000000000000000000f0000000000000000000000000707000000000000000000000707070707070f0303030f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f010101000000000f0000000000000000000f0000000000000000000f0000000000000000000000000000000000000000000000000707070707070f0404040f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f010101000000000f000000000000070000000000070000000000000f0000000000000707000000000000000000070700000000000707070707070f0505050f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f010101000000000f0000000000000000000f0000000000000000000f0000000000000707000000000000000000070700000000000707070707070f0606060f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f01010100070000000000070000000000000f00000000000000070000000007000000000000000000000000000000000000000000070707070707070707070f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f010101000000000f0000000000000000000f0000000000000000000f000000000000000000000000000000000000000000000707070707070707070707070f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f010101000000000f0000000000000000000f0000000000000000000f000000000000000000000000000000000000000000000707070707070707070707070f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100000e3200e3200e3200f3200f3200f3101031011310113101232012320133201431015310173101a3001c3001f3002130021300260002300021000000000000000000000000000000000000000000000000
00030000371203a1203b1503b1503915035150291502615023150221502215025150281502a1502a15029150231501a15018150151501415013150151501a1501c1501c1501b1501715013150101500d1500b150
010d00000d0500d050180501805019050190500d0500d050180501805015050150500d0500d05015050150500d0500d050150501505014050140500d0500d0501505015050120501205012050120551205012050
010d00000c053000003f005000003f025000003f0000000024625000003f000000003f0250c0003f000000003f025000003f000000003f025000003f0000c00024625000000c053000003f025000003f00024600
010d00000c053000003f005000003f025000003f0000000024625000003f000000003f0250c0000c053000003f0250000000000000003f025000000000000000246250000000000000003f025000002462524625
010d00000c0530000024625000003f025000003f0000000024625000003f000000003f0250c0000c053000003f0250000024625000003f025000000000000000246250000000000000003f025000002462524625
010d00000c0530000024625000003f025000003f0000000024625000003f000000003f0250c0000c053000003f0250000024625000003f025000000000000000246250000000000000003f025000000000000000
010d00000d0500d050140501405015050150500d0500d050150501505012050120500d0500d05012050120500d0500d050120501205014050140500d0500d0501505015050110501105011050110551105011050
010d000014050140501b0501b0501c0501c05014050140501c0501c050190501905014050140501905019050140501405019050190501b0501b05014050140501c0501c050180501805018050180551805018050
010d0000190501905020050200502105021050190501905021050210501e0501e05019050190501e0501e05019050190501e0501e0502005020050190501905021050210501d0501d0501d0501d0551d0501d050
010d00000c063000003f005000003f225002053f0000000024655000003f000000003f2250c0003f000000003f225000003f000000003f225000003f0000c00024655000000c063000003f225000003f00024600
010d00000c063000003f005000003f225000003f0000000024655000003f000000003f2250c0000c063000003f2250000000000000003f225000000000000000246550000000000000003f225000002465524655
010d00000c0630000024655000003f225000003f0000000024655000003f000000003f2250c0000c063000003f2250000024655000003f225000000000000000246550000000000000003f225000002465524655
010d00000c0630000024655000003f225000003f0000000024655000003f000000003f2250c0000c063000003f2250000024655000003f225000000000000000246550000000000000003f225000000000000000
__music__
01 03024344
00 04024344
00 05024344
00 06024344
00 03024344
00 04024344
00 05024344
00 06024344
00 0a070809
00 0b070809
00 0c070809
02 0d070809
00 03070809
00 04070809
00 05070809
02 06070809

