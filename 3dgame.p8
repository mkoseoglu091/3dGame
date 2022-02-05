pico-8 cartridge // http://www.pico-8.com
version 34
__lua__
--find your way out of the maze 

function _init()
 poke(0x5f10+8, 128+8)
 poke(0x5f10+6, 128+6)
 poke(0x5f10+0, 128+0)
 music()
 init_title()
end

function _update()
 if mode == 0 then
  update_title()
 elseif mode == 1 then
  update_game()
 end
end


function _draw()
 if mode == 0 then
  draw_title()
 elseif mode == 1 then
  draw_game()
 end
end





-- title state
function init_title()
 initglobal()
 mode = 0
end

function draw_title()
 draw_title_screen()
 print("hold 🅾️ to start", 7, 50, 0)
end

function update_title()
 if btn(4) then
  init_game()
 end
end


-- game state
function init_game()
 mode = 1
 pl={}
 restart()
 pl.fly=false
end

function update_game()
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


function draw_game()
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
  print("victory!!!", 55, 55, 11)
 end
end

-->8
-- title screen compress

-- main program ---------------
function draw_title_screen()
 cls()
 --info()
 t="/b0.@y@7i8h8h8h8xuu/b0.y@yh@h8h8h8hvuu!/b0.y@7x@i8h@i8uuuu/b0.@ye8y8y@y8hvuuu/b9.y@yv7x@h@y8y@uuuu!/b9.y@ye8y8y@i@yvuuuu/b9.@yv7x8h@i@x@yuuuu/b9.y@ye8i8y@x8yvuuuu!/b8.y@yv7h8h@i8i@yuuuuu/b8.@y@ue8h8y8x@x@uuuuu/b8.y@yvuh8h@i8y8yuuuuu!/b8.y@ue8h8x8h@h@/af.u@/b7.y@yevh8h8i8y8x/af.uy/b7.@y@ux7h8h@h@i@/af.u!/b7.y@yu7h8h8x8h8x/ag.u@/b7.y@uh8x8h@i8h@/ag.uy/b7.@yu7h8i8x@h8x/ag.u!/b6.y@yvue8h@h8y8h8/ah.u@/b6.y@uuuh8x8x@h8x/ah.uy/b6.@yvuu8x@i8y8h@/ah.u!/b6.y@uuui8x@x@i8x/ai.u@/b5.y@yuuu!h8i8y@h8/ai.uy/b5.@y@uuuy@h8h@y8hv/ah.u!/b5.y@yuuu@i8h@x@i8y/ai.u@y@yfqdq@y@y@y@qdqdy@ydqdq@yfqdq@ydqdq/be.@yfqdq@qdq0ydqdyvqdqy@hqdqyrdqdqt/af.uy@y@ydqdy@y@y@yfqdq0y@qdqdy@ydqdy@qdqd/be.y@ydqdyfqdq@qdq0ueqd!i8dqd!iqdqdqdquuuu!y@y@qdq0y@y@y@ydqdq0yfqdq0y@qdq@ydqdq0/be.y@qdq0ydqdyfqdqvudqd!hqdqt@/bd.dquuuu@y@yfqdq@y@y@y@qdqdq@yfqdq@ydqdy@qdqdq/be.@yfqdq@qdq0ydqduuqdqd8dqdqyrdqdqdqduuuuy@y@ydqdy@y@y@ydqdqdy@ydqdy@qdq0yfqdqdq/be.@ydqdqfqdq@qdqtueqdqhqdqd!hqdquqdqduuu!y@y@qdq0y@y@y@qdqdqdy@qdq0yfqdq@ydqdqd/be.y@qdqdydqdyfqdquudqd7dqdqd8dqduuudqtuuu@y@yfqdq@y@y@yfqdqdq0yfqdq@ydq0yfqdqdq0/bd.y@yfqdq0qdq0ydqduu/bd.qdqhrdqtuuqdquuuy@y@ydqdy@y@y@ydq0qdq@yfqdy@qdq@ydq0qdq/bd.@y@qdqdqfqdq@qdqtue/bd.qd7iqdquqdqduuu!y@yfqdq0y@y@y@qdq@qdq@ydqdydqdy@qdq@qdq/bd.@yfqdqdydqdyfqdquu/bd.dqd@/bd.dqtuuu@y@ydqdq@y@y@yfqdy@qdy@qdq0qdq0yfq0yfqd/bd.y@ydqdq0qdq0ydqduu/bd.qdqhr/bd.dquuuy@y@qdqdy@y@y@qdq@yfq0yfqdqfqdy@qdq@yfq0/bd.y@qdqdqfqdq@qdqtu/be.dqhqdqdqdqtuuu!y@y@qdq0y@y@yfqdy@ydq@yfqdqdq0yfq0y@ydq/bd.@yfqdqdydqdyfqdqu/be.qd7dqdqdqduuuuu@y@yfqdq@y@y@y/bd.dq@ydqdqdq@ydqdqdqd/bd.y@ydqdq0qdq0udqdue/bd.qdqtrdqdqtutuuuuy@y@ydqdy@y@y@/bd.qdy@qdqdqdy@/bd.qdy@y@yfy@qdqdyfqdquqdqtudqdqi!dqdqiqdquuuquuuu!y@y@qdq0y@y@yfqdqdqdq0yfqdqdq@y/bd.dq0y@y@ydqfqdq0yfqdqdqdqurdqt@yrdqd!dqduuueuuuuu@y@yfqdqdqdq@y/bd.dq0yfqdqdy@/bd.qdq@y@yfqdqdqdq@ydqdqdqd!iqdqy@iqdqtrdqt/ah.uy@y@y/bd.dqfqdq0ydqdq@ydqdq0yf/bd.qdy@y@ydqdqdq0y@qdqdqdqt@dqd!y@dqdqiqdq/ah.u!y@y@/bd.qdydqdy@qdqdy@qdqdq@ydqdy@qdqdy@yfqdqdqdq@yfqdqdqdqyrdqt@irdqd!dqd/ai.u@y@yfqdqdqdq0qdq0y@qdqdyfqdq0yfqdq0y@qdq0y@ydqdqdqdy@ydqdqdqd!iqdqy8hqdqtrdqt/ah.uy@y@ydqdqdqdy@q@q@yfqdq0yfqdq@ydqdy@yfqdq@y@ydqdqdq0yvquuuuuqt8d@t@i8dqdqiqdq/ah.u!y@y@q@y@y@y0yfyfy@y0y0y@ydqd/bh.y@q@ydqdq@yeuuuuue!irxry@hrh@t@d8t/ai.u@y@yfy@y@y@q@y0y@y@y@q@y@q@q0/bg.y@yfy@y@yfyv/ag.ut8h7y@y8i7xryrhr/ai.uy@y@y0/bi.y@yfyf/bh.y@y0y@y@y0yuuuuu7uri8d@y@h@d8y@i8h/ai.u!/bm.y@y0/bh.y@q@y@y@qvuuuuuhvy8h8y@i8x8h@y@hvt/ai.u@/bm.y@q/bl.@yuuuuu7x!i8h@y8h8i8y@i8x/aj.uy/by.@yvuuuuue8y@h8x@h8h8h@y@h8/aj.u!/by.y@/af.u7h@y8h8i8h8h8x@y8hv/aj.u@/bx.y@yvuuuuue8h@i8x@h8i8h8y@i8/ak.uy/bx.@y@/ag.uh8x@h8i8x8h8h@y8hv/aj.u!/bx.y@y/ag.u7h8y8x@x8i8h8y@h8x/ak.u@/bw.y@yv/ag.ue8x@i8i8y@x8h@y8h8/ak.uy/bx.@y/ag.u!h8y@x8h@y8i8x@i8x/ak.u!/bw.y@yv/ah.u8h@y@i8x@h@h8y8h8/al.u@/bw.y@yuuuue8u!h8x@i8h8y8y@h@i8hv/ak.uy/bw.@yvuuuuuhvu8h8y8h8h@h@y@y@h8/al.u!/bw.y@yuuuuu7h@i8h@i8h8y@h@y@i8x/am.u@/bv.y@yvuuuuue8x8h8x8h8h@y8y@y@h8/am.uy/bv.@y@/ag.uh@i8h@h8h8y@h@y@i8hv/al.u!/bv.y@yv/af.u7x@h8x8h8x@i8x@y@h8x/am.u@/bv.y@/ag.ue8y8h@h8h8y@h@y@i8h8/am.uy/bv.@yv/af.u7h@i@y8h8h@i8x@y8h8hv/al.u!/bv.y@/ag.uh8x@y@i8h@y8h8y@i8h8/an.u@/bu.y@yv/af.u7h@y@y8h8y@i8h@y8h8hv/am.uy/bu.@y@/ag.uh8x@y@h8h8y8h8y@i8h8x/am.u!/bu.y@y/ag.u7h8y@i8h8h8i8h@y8h8h8/an.u@/bu.y@/ag.ui8h@y@h8h8h@h8x@i8h8x/an.uy/bu.@y/ag.u@h8h@y8i8h8x8h@y@i8x/ao.u!/bt.y@yv/ag.ui8h@x@y@i8h8i8x@y8h8/ap.u@/bt.y@/ah.u@h@x@y@y8h8x8h@y@i8hv/ao.uy/bt.@y/ag.u!y8h8y@y@h8h8i8x@y@i8/ap.u!/bs.y@yv/ah.u@h@h@y@y8h8h@i@y@y8hv/ap.u@/bs.y@/ah.u!y8x8x@y@h8h8x@x@y@i8/aq.uy/bs.@y/ai.u8i@y8y@y8h8h8y@y@y8x/aq.u!/br.y@y/ai.u!h@y@i@y@h8h8h@y@y@i8/ar.u@/bq.y@yv/ai.uy8x@y@y@y8h8h8x@y@y@hv/aq.uy/bq.@y@/aj.u@i8y@y@y@h8h8h/bd.@y/aq.u!/bq.y@yuuuuxuuuu!y@h@y@y@y8h8h8x@y@y@y@/ar.u@/bp.y@yvuuuu7xuuuy@y8x@y@y@i8h8h@y@y@i@yv/aq.uy/bp.@y@uuuuuh8uuu!y@h8y@y@y8h8h8h@y@y@x@y/aq.u!/bp.y@yuuuuu7hvuuy@h8h@y@y8i8x8y@x@y@i8y@/ar.u@/bo.y@yvuuuuuh8xuu@i8h8x@y@i@y8h@y8y@y@h@yv/aq.uy/bo.@y@/af.u7h8u!y@h8h8y@y8x@y@y@i8y@i8x@y/aq.u!/bo.y@y/af.ue8hvy@h8h8h@y@i8/bd.y@y8h8y@/ar.u@/bn.y@yv/ag.uh8x@y8h8h8y@y8h/bd.@y@h8x@yv/aq.uy/bo.@y/af.ue8h8y@h8h8h@y@i8x@y@y@y@i8h8y@y/aq.u!/bn.y@yv/ag.uh8h@i8h8h8x@y8h8y@y@y@y8h8h@y@/ar.u@/bm.y@yv/ag.ue8h8x8h8h8h@y@i8h@y@y8x@i8h8x@y/ar.uy/bm.@y@/ai.uh8h8i8h8h8y@y8h8x@y@h8y8h8h8y@/ar.u!/bm.y@y/ai.u8h8x8h8h8x@y@i8h8y@y8h8i8h8h@yv/ar.u@/bl.y@yv/af.u7u!i8h8i8h8h8x@y@h8h@y@i8h@h8h8x@y/ar.uy/bl.@y@/ag.ue8y8h8h@h8h8h8y@y8h8x@y8h8x8h8h8yv/ar.u!/bl.y@y/ah.uh@i8h8h8h@y8h@y@i8h@y@i8h@h8h8x@y/as.u@/bk.y@yv/ah.u7h@h8h8h8y@i8y@y@h8x@y8h8x8h8h8y@/as.uy/bk.@yv/ai.ui/bd.8h@y8h@y@y8h8y@h8h8i8h8x@y/as.u!/bk.y@/aj.u@/bd.h8y@i8x@y@h8x@y8h8x@h8h8y@/at.u@/bj.y@y/ai.u!i/bd.8h@y8h8y@y8h8y@h8h8i8h8x@y/at.uy/bj.@yv/aj.u8/bd.h8y@i8h@y@h8x@i8h8h@h8h8y@/at.u!/bj.y@/aj.u!i8h8h8h8x@y8h8x@y8h8y@/bd.h8x@yv/at.u@/bi.y@y/aj.uy/bd.8h@y@h8h@y@h8h8y/bd.8h8y@/au.uy/bi.@yv/aj.u@/bd.h8x@y8h8x@y8h8h@/bd.h8h@yv/at.u!/bi.y@/aj.u!i8h8h@h8h@y@h8h8y@h8h@/be.h8y@y/au.u@/bh.y@/ah.u7uuy8h8h8y8x8y@i8h8h@h8h8x/be.8h@y@/au.uy/bg.@y@/ai.uhvu@y8h8x@y@y@y/be.8h@i/bd.8h8x@yv/at.u!/bg.y@/aj.u7x!y@i8x@y@y@y@h8h8h@h8h8x@/be.h8y@y/au.u@/bf.y@/ak.uh@y@y@y@h8y@y@/be.h8h@y/be.8h@y@/au.uy/be.@y/ag.u7xuuue8x@y@y@i8h@y@i/be.8h8y@/be.h8x@yv/at.u!/bd.y@y/ah.ue8uuuuh8y@y@y8h8x@y/bf.8h@y/be.8h8y@y/au.u@y@y@y@/aj.u7hvuuy8h@y@y@h8h8y@/bf.h8y@/be.h8h@y@/au.uy@y@y@/ak.uh8xuu@h8x@y@i8h8h@i/be.8h8x@y/be.8h8x@yv/at.u!y@y@/ak.ue8hvu@i8h@y@y8h8h8y/bf.8h@y@i/be.8h8y@/av.u@y@/al.u7h8x!y@h8x@y@i8h8x@i/be.8h8y@y@/be.h8h@yv/au.uyv/am.uh8h@y@i8h8y@y8h8h8y/be.8h8x@y@i/be.8h8x@y/a9.ue8h8x@y@h8h@y@/bi.h8y@y@h8h8h@y8h8h8y@/a6.ue8uuh8h8y@i8h8y@i/bi.8h@y@i8h8h8x@y@i8h@yv/a5.u7hve8h8x@y8h8h@y/bi.8h8y@y8h8h8h@y@y@h8x@y/a5.ue8x7h8h8y@h8h8x/bi.8h8x@y@h8h8h8y@y@i8h8y@/a5.u7h8h8h8h@i/bl.8h8y@i8h8h8h@y@y8h8h@y/a5.ue8h8h8h8x/bm.8h@y@h8h8h8y@y@i8h8y@/a6.uh/bp.8h8x@i8h8h8h@y@y8h8h@yv/a4.ue/bq.8h8y@h8h8h8y@y@i8h8x@/a5.u!/bq.h8x@i8h8h8h@y@y@h8h8yv/a3.u!i/bq.8h8y@h8h8h8y@y@y8h8h@/a3.u@y/br.8h@y8h8h8h@y@y@i8h8xv/a1.u@y@i/bq.8h8y@h8h8h8x@y@y8h8h8y/aw.ue"
 bit6to8(t, 24576)
end--main()

-- init global variables ------

function initglobal()
 chr6x,asc6x={},{}
 local b6=".abcdefghijklmnopqrstuvwxyz1234567890!@#$%^&*()`~-_=+[]{};':,<>?"
 local i,c
  for i=0,63 do
   c=sub(b6,i+1,i+1)
   chr6x[i]=c asc6x[c]=i
  end  
 compressdepth=2
end--initglobal()

-- functions ------------------

-- convert integer a to char-6
function chr6(a)
 local r=chr6x[a]
 if (r=="" or r==nil) r="."
 return r
end--chr6(.)

-- test bit #b in a
function btst(a,b)
local r=false
 if (band(a,2^b)>0) r=true
 return r
end--btst(..)

-- return asc-6 of string a
-- from character position b
function fnca(a,b)
local r=asc6x[sub(a,b,b)]
 if (r=="" or r==nil) r=0
 return r
end--fnca(..)

-- return string a repeats of b
function strng(a,b)
local i,r=0,""
 for i=1,a do
  r=r..b
 end
 return r
end--strng(..)

-- convert compressed 6-bit
-- string to 8-bit binary
-- memory
function bit6to8(t,m)
local i,d,e,f,n,p=0,0,0,0,0,1
 repeat
  if sub(t,p,p)=="/" then
   d=fnca(t,p+1)
   e=fnca(t,p+2)+64*fnca(t,p+3)
   t=sub(t,1,p-1)..strng(e,sub(t,p+4,p+4+d-1))..sub(t,p+d+4)
   p+=d*e-1
  end
  p+=1
  until p>=#t
   p=1 d=0 e=0
   for i=1,#t do
    c=fnca(t,i)
    for n=0,5 do
     if (btst(c,n)) e+=2^d
     d+=1
     if (d==8) poke(m+f,e) d=0 e=0 f+=1
  end
 end
end--bit6to8(..)

-- convert 8-bit binary memory
-- area to compressed 6-bit
-- clipboard ready sourcecode
function bit8to6clip(i,m)
 bit8to6(i,m,0)
end--bit8to6clip(...)

-- convert 8-bit binary memory
-- area to compressed 6-bit
-- string or save to clipboard
function bit8to6(i,m,f)
local j,k,l,p,n,c,t=0,0,0,0,0,0,""
 m+=i-1
 for j=i,m do
  p=peek(j)
  for k=0,7 do
   if (btst(p,k)) c+=2^l
    l+=1 if (l==6 or (j==m and k==7)) t=t..chr6(c) c=0 l=0
   end
  end
 for i=1,compressdepth do
  j=1
  repeat
   c=sub(t,j,j+i-1) d=sub(t,j,j)
   n=0 p=j
    if d=="/" then
     j+=i+3
    else
     repeat
      ok=1
      if (c==sub(t,p,p+i-1)) n+=1 p+=i ok=0
       until ok==1 or n==4095
      end
      if n>0 and n!=nil then
       a="/"..chr6(i)..chr6(n%64)..chr6(flr(n/64))..c
      if #a<i*n then
       t=sub(t,1,j-1)..a..sub(t,j+i*n)
       j+=#a-1
      end
     end
     j+=1
    until j>#t-i
 end
 if f==0 then
  printh("t=\""..t.."\"\n","@clip")
 else
  return t
 end
end


-->8
-- game and map functions

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
  z=pl.z-2 -- 1 unit high

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
    gcol=8 -- lava color
    if(celz0 < 16) then 
     gcol=6 -- platform top color
    end
    line(sx,sy1-1,sx,sy,gcol)
    --tline(sx,sy1-1,sx,sy,2, 34, 0, 0)
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
     
     
     if last_dir*1+5 == 6 then -- what condition to use???
      tline(sx,top_wall,sx,bottom_wall, (pl.x+vx*dist_x)%1*2, 36, 0, 2/(bottom_wall-top_wall))
     else
      tline(sx,top_wall,sx,bottom_wall, (pl.y+vy*dist_y)%1*2, 34, 0, 2/(bottom_wall-top_wall))
     end
     
     
     --tline(sx,top_wall,sx,bottom_wall, (pl.x+vx*dist_x)%1*2, 34, 0, 2/(bottom_wall-top_wall))
     --line(sx,sy1-1,sx,sy, last_dir*1+5)
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
44445444440054445556755755655555705667705666770566605666666666664444f444444f4444000000000000000000000000000000000000000000000000
45444444450054455556777555565555605666605666660566605566666666664444f444444f4444000000000000000000000000000000000000000000000000
4444444444005444555766666667577550555550555555055550555555555555ffffffffffffffff000000000000000000000000000000000000000000000000
444444454400544477766555556776670000000000000000000000000000000044f444444f444444000000000000000000000000000000000000000000000000
445444444400545466667555556665766677056667705677666666660566666644f444444f444444000000000000000000000000000000000000000000000000
4444444444005444555655555556555566660566666056666666666605566666ffffffffffffffff000000000000000000000000000000000000000000000000
55555555550055555556757555667775555505555550555555555555055555554444f444444f4444000000000000000000000000000000000000000000000000
00000000000000007666777766666677000000000000000000000000000000004444f444444f4444000000000000000000000000000000000000000000000000
0000000000000000665666666555566670566770566677056660566666666666ffffffffffffffff000000000000000000000000000000000000000000000000
444440054444444455557565555556556056666056666605666055666666666644f444444f444444000000000000000000000000000000000000000000000000
444540054444444475555567575756755055555055555505555055555555555544f444444f444444000000000000000000000000000000000000000000000000
5444400544444544777557677555567700000000000000000000000000000000ffffffffffffffff000000000000000000000000000000000000000000000000
44444005445444446666666667756666667705666770567766666666056666664444f444444f4444000000000000000000000000000000000000000000000000
44544005444444545556555566666555606000606060506066666666055666664444f444444f4444000000000000000000000000000000000000000000000000
4444400545444444755675555566575500000000000000005555555505555555f0000f000f00ff0f000000000000000000000000000000000000000000000000
55555005555555557766575755677577000000000000000000000000000000000044040004040440000000000000000000000000000000000000000000000000
99995999990059990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
95999999950059950000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
99999999990059990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
99999995990059990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
99599999990059590000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
99999999990059990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55555555550055550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
99999005999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
99959005999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
59999005999995990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
99999005995999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
99599005999999590000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
99999005959999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55555005555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04142434000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05152535000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06162434000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07172535000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f01010101010f01010101010101010101010f01010101010101010101010f01010101010101010101010f00000000000000000000000f00000000000000000f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f01010101010f01010101010101010101010f01010101010101010101010f01010101010101010101010f00040404000000000000000f00070700000707000f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f01010101010f01010101010101010101010f01010101010101010101010f01010101010101010101010f00040404000000040404000f00070700000707000f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f01010101010f01010101010101010101010f01010101010101010101010f01010101010101010101010f00000000000000040404000f0000000f0f0000000f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f01010101010f01010101010101010101010f01010101010101010101010f01010101010101010101010f00000000000000000000000f0000000f0f0000000f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f01010101010f01010101010f01010101010f01010101010f00000000000f00000000000f00000000000f00040400000f00000000000f0000000f0f0000000f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f01010101010f01010101010f01010101010f00000000000f00000000000f00000000000f02000000000f00040400000f00000000000f0000000f0f0007000f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f01010101010f00000100000f00000000000f00010101000f00010100000f00000000000f02000000000f00000000000f00000000000f0707070f0f0007000f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f01010101010f00000100000f00000000000f00010101000f00010100000f00000000000f00000000000f00000000000f00060606000f0707070f0f0000000f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f00000000000f00000000000f00010101000f00000000000f00000000000f00030303000f00000000000f00020200000f00060606000f0707070f0f0000000f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f00000000000f00000000000f00010101000f00010101000f00000000000f00030303000f05000000000f00020200000f00060606000f0000000f0f0000000f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f01010101010f00000100000f00010101000f00010101000f00000000000f00030303000f05000000000f00000000000f00000000000f0000000f0f0007000f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f01010101010f00000100000f00000000000f00000000000f00000101000f00000000000f00000000000f00000000000f00000000000f0000000f0f0007000f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f01010101010f01010101010f00000000000f00010101000f00000101000f00000000000f00000000000f00020200000f00000000000f0000000f0f0000000f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f01010101010f01010101010f01010101010f00010101000f00000000000f00000000000f00000000000f00020200000f00000000000f0707070f0f0000000f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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

