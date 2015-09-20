;The Ninja v0.000001 Alpha
;Por DukeNukem (irc.brasnet.org)

on *:LOAD:ninja

alias nreset {
  .remove ninja\map.map
  bset &a 1 1 1 0 0 2 2
  bwrite ninja\map.map -1 -1 &a
  btrunc ninja\map.map 1806
}
alias -l nf return $nd(map.map)
alias -l nn return $nd(ninja.bmp)
alias -l np return $nd(tiles.bmp)
alias -l nd return $+(",$scriptdir,$1-,")
alias ninja-ed {
  window -pkdhafBC +tn @NE 0 0 480 320
  window -phfB +d @NE_BG 0 0 480 320
  window -phfB +d @NE_MG 0 0 480 320
  window -phfB +d @NE_FG 0 0 480 320
  window -pkdhafBC +tn @NE_Tiles 0 0 256 256
  drawpic @NE_Tiles 0 0 $np
  drawrect -rf @ne_bg 16711935 1 0 0 480 320
  drawrect -rf @ne_mg 16711935 1 0 0 480 320
  drawrect -rf @ne_fg 16711935 1 0 0 480 320
  set %NE.layer BG
  set %NE.tile 3
  set %NE.layers 1 1 1
  set %ne.x 0
  set %ne.y 0
  bread $nf 0 6 &t
  tokenize 32 $bvar(&t,1,6)
  set %ne.w $1
  set %ne.h $2
  set %ne.sx $calc($3 * 30 + $5)
  set %ne.sy $calc($4 * 20 + $6)
  titlebar @NE_Tiles - %ne.tile
  ne-draw
}
on *:CLOSE:@ne:{
  window -c @ne_bg
  window -c @ne_mg
  window -c @ne_fg
  titlebar
  window -c @ne_tiles
  unset %ne.*
}
alias -l ne-draw {
  var %p = $calc(%ne.x * 1800 + %ne.y * 1800 * %ne.w + 6)
  bread $nf %p 1800 &a
  var %x -1
  drawrect -rf @ne_bg 16711935 1 0 0 480 320
  drawrect -rf @ne_mg 16711935 1 0 0 480 320
  drawrect -rf @ne_fg 16711935 1 0 0 480 320
  while (%x < 600) {
    inc %x
    var %b = $bvar(&a,$calc(%x * 3 + 1),1)
    var %m = $bvar(&a,$calc(%x * 3 + 2),1)
    var %f = $bvar(&a,$calc(%x * 3 + 3),1)
    drawpic -c @ne_bg $calc((%x % 30) * 16) $calc($int($calc(%x / 30)) * 16) $calc((%b % 16) * 16) $calc($int($calc(%b / 16)) * 16) 16 16 $np
    drawpic -c @ne_mg $calc((%x % 30) * 16) $calc($int($calc(%x / 30)) * 16) $calc((%m % 16) * 16) $calc($int($calc(%m / 16)) * 16) 16 16 $np
    drawpic -c @ne_fg $calc((%x % 30) * 16) $calc($int($calc(%x / 30)) * 16) $calc((%f % 16) * 16) $calc($int($calc(%f / 16)) * 16) 16 16 $np
    titlebar @ne - Loading room %ne.x $+ , $+ %ne.y - $base($int($calc(%x * 100 / 600)),10,10,3) $+ % ( $+ $str(|,$int($calc(%x / 60))) $+ $str(-,$calc(10 - $int($calc(%x / 60)))) $+ )
  }
  ne-copy
}
alias -l ne-copy {
  if ($1 = bg) { drawcopy @ne_bg 0 0 480 320 @ne 0 0 | return }
  if ($1 = mg) { drawcopy @ne_mg 0 0 480 320 @ne 0 0 | return }
  if ($1 = fg) { drawcopy @ne_fg 0 0 480 320 @ne 0 0 | return }
  titlebar @ne - Room: %ne.x $+ , $+ %ne.y ( $+ %ne.w $+ , $+ %ne.h $+ ) - Layers: %ne.layers - Editing: %ne.layer
  tokenize 32 %ne.layers
  drawrect -rfn @ne 16711935 1 0 0 480 320
  if ($1) { drawcopy -n @ne_bg 0 0 480 320 @ne 0 0 }
  if ($2) { drawcopy -n $+ $iif($count(%ne.layers,1) > 1,t) @ne_mg $iif($count(%ne.layers,1) > 1,16711935) 0 0 480 320 @ne 0 0 }
  if ($3) { drawcopy -n $+ $iif($count(%ne.layers,1) > 1,t) @ne_fg $iif($count(%ne.layers,1) > 1,16711935) 0 0 480 320 @ne 0 0 }
  drawdot @ne
}
menu @ne {
  sclick:{
    var %x = $int($calc($mouse.x / 16))
    var %y = $int($calc($mouse.y / 16))
    drawpic -c @ne_ $+ %ne.layer $calc(%x * 16) $calc(%y * 16) $calc((%ne.tile % 16) * 16) $calc($int($calc(%ne.tile / 16)) * 16) 16 16 $np
    bset &a 1 %ne.tile
    bwrite $nf $calc((%ne.x + %ne.y * %ne.w) * 1800 + (%x + %y * 30) * 3 + $replace(%ne.layer,bg,0,mg,1,fg,2) + 6) 1 &a
    ne-copy
  }
  mouse:{
    var %x = $int($calc($mouse.x / 16))
    var %y = $int($calc($mouse.y / 16))
    titlebar - $calc((%ne.x + %ne.y * %ne.w) * 1800 + (%x + %y * 30) * 3 + $replace(%ne.layer,bg,0,mg,1,fg,2) + 6)
    if ($mouse.key & 1) {
      drawpic -c @ne_ $+ %ne.layer $calc(%x * 16) $calc(%y * 16) $calc((%ne.tile % 16) * 16) $calc($int($calc(%ne.tile / 16)) * 16) 16 16 $np
      bset &a 1 %ne.tile
      bwrite $nf $calc((%ne.x + %ne.y * %ne.w) * 1800 + (%x + %y * 30) * 3 + $replace(%ne.layer,bg,0,mg,1,fg,2) + 6) 1 &a
      ne-copy
    }
  }
  Goto Room:{
    var %x = $?="X"
    var %y = $?="Y"
    if ($inrect(%x,%y,0,0,%se.w,%se.h)) {
      set %se.x %x
      set %se.y %y
      ne-draw
    }
  }
  Fill
  .BG:{
    var %x -1
    var %y 0
    while (%y < 20) {
      inc %x
      if (%x = 30) { inc %y | var %x 0 }
      if (%y = 20) { goto e }
      drawpic -c @ne_bg $calc(%x * 16) $calc(%y * 16) $calc((%ne.tile % 16) * 16) $calc($int($calc(%ne.tile / 16)) * 16) 16 16 $np
      bset &a 1 %ne.tile
      bwrite $nf $calc((%ne.x + %ne.y * %ne.w) * 1800 + (%x + %y * 30) * 3 + 0 + 6) 1 &a
      ne-copy bg
      titlebar @NE - Filling: $int($calc((%x + %y * 30) * 100 / 600)) $+ %
      :e
    }
    ne-copy
  }
  .MG:{
    var %x -1
    var %y 0
    while (%y < 20) {
      inc %x
      if (%x = 30) { inc %y | var %x 0 }
      if (%y = 20) { goto e }
      drawpic -c @ne_mg $calc(%x * 16) $calc(%y * 16) $calc((%ne.tile % 16) * 16) $calc($int($calc(%ne.tile / 16)) * 16) 16 16 $np
      bset &a 1 %ne.tile
      bwrite $nf $calc((%ne.x + %ne.y * %ne.w) * 1800 + (%x + %y * 30) * 3 + 1 + 6) 1 &a
      ne-copy mg
      titlebar @NE - Filling: $int($calc((%x + %y * 30) * 100 / 600)) $+ %
      :e
    }
    ne-copy
  }
  .FG:{
    var %x -1
    var %y 0
    while (%y < 20) {
      inc %x
      if (%x = 30) { inc %y | var %x 0 }
      if (%y = 20) { goto e }
      drawpic -c @ne_fg $calc(%x * 16) $calc(%y * 16) $calc((%ne.tile % 16) * 16) $calc($int($calc(%ne.tile / 16)) * 16) 16 16 $np
      bset &a 1 %ne.tile
      bwrite $nf $calc((%ne.x + %ne.y * %ne.w) * 1800 + (%x + %y * 30) * 3 + 2 + 6) 1 &a
      ne-copy fg
      titlebar @NE - Filling: $int($calc((%x + %y * 30) * 100 / 600)) $+ %
      :e
    }
    ne-copy
  }
}
menu @ne_tiles {
  sclick:{
    var %x = $int($calc($mouse.x / 16))
    var %y = $int($calc($mouse.y / 16))
    set %ne.tile $calc(%x + %y * 16)
    titlebar @NE_Tiles - %ne.tile
  }
}
on *:keydown:@ne:*:{
  echo -a $keyval
  if ($keyval = 49) { set %ne.layers $puttok(%ne.layers,$iif($gettok(%ne.layers,1,32),0,1),1,32) | ne-copy }
  if ($keyval = 50) { set %ne.layers $puttok(%ne.layers,$iif($gettok(%ne.layers,2,32),0,1),2,32) | ne-copy }
  if ($keyval = 51) { set %ne.layers $puttok(%ne.layers,$iif($gettok(%ne.layers,3,32),0,1),3,32) | ne-copy }

  if ($keyval = 81) { set %ne.layer BG | ne-copy }
  if ($keyval = 87) { set %ne.layer MG | ne-copy }
  if ($keyval = 69) { set %ne.layer FG | ne-copy }

  if ($keyval = 37) && (%ne.x > 0) { dec %ne.x | ne-draw }
  if ($keyval = 38) && (%ne.y > 0) { dec %ne.y | ne-draw }
  if ($keyval = 39) && (%ne.x < %ne.w) { inc %ne.x | ne-draw }
  if ($keyval = 40) && (%ne.y > %ne.h) { inc %ne.y | ne-draw }
}
alias tileed {
  window -pkef +tn @Tile 0 0 64 64
  set %tile 0
  ted
}
alias -l ted drawpic -cs @Tile 0 0 64 64 $calc(%tile % 16 * 16) $calc($int($calc(%tile / 16)) * 16) 16 16 $np
on *:INPUT:@Tile:writeini $nd(tiles.ini) tiles %tile $1- | inc %tile | ted
alias ninja {
  if ($window(@Ninja)) { halt }
  window -pkfdhaBC +tn @Ninja 0 0 240 160
  window -phf +d @NinjaBG 0 0 480 320
  window -phf +d @NinjaFG 0 0 480 320
  window -phf +d @NinjaClip1 0 0 480 320
  window -phf +d @NinjaClip2 0 0 480 320
  loadmap 0 0
  set %Ninja.x 32
  set %ninja.h 0
  set %Ninja.y 48
  set %Ninja.d 0
  set %Ninja.sy 0
  set %Ninja.m 0
  set %Ninja.f 1
  .timerNinja -ho 0 50 ninja-do
}

on *:CLOSE:@Ninja:{
  close -@ @Ninja*
  unset %Ninja.*
  .timerNinja off
}
alias loadmap {
  var %rx $$1
  var %ry $$2
  bread $nf 6 1800 &map
  var %x -1
  ;drawrect -rf @NinjaBG 0 1 0 0 480 320
  while (%x < 600) {
    inc %x
    var %bg = $bvar(&map,$calc(%x * 3 + 1),1)
    var %mg = $bvar(&map,$calc(%x * 3 + 2),1)
    var %fg = $bvar(&map,$calc(%x * 3 + 3),1)
    drawpic -ct @NinjaBG 16711935 $calc(%x % 30 * 16) $calc($int($calc(%x / 30)) * 16) $calc(%bg * 16) 0 16 16 $np
    drawpic -ct @NinjaBG 16711935 $calc(%x % 30 * 16) $calc($int($calc(%x / 30)) * 16) $calc(%mg * 16) 0 16 16 $np
    drawpic -c @NinjaFG $calc(%x % 30 * 16) $calc($int($calc(%x / 30)) * 16) $calc(%fg * 16) 0 16 16 $np
    drawpic -c @NinjaClip1 $calc(%x % 30 * 16) $calc($int($calc(%x / 30)) * 16) $calc(%mg * 16) 16 16 16 $np
    drawpic -c @NinjaClip2 $calc(%x % 30 * 16) $calc($int($calc(%x / 30)) * 16) $calc(%fg * 16) 32 16 16 $np
    titlebar @Ninja - $int($calc(%x * 100 / 600)) $+ %
  }
  drawcopy -t @NinjaFG 16711935 0 0 480 320 @NinjaBG 0 0
}
on *:KEYDOWN:@Ninja:*:{
  ;echo -s $keyval
  if (!$keyrpt) {
    tokenize 32 $keyval
    if ($1 = 16) {
      if (%ninja.h) && (%ninja.ud = u) {
        set %Ninja.a 0
        set %Ninja.mu 1
        return
      }
      if (%ninja.f = 0) { set %Ninja.f 1 | dec %ninja.y 2 | set %Ninja.sy -6 }
    }
    if ($1 = 17) && (!%ninja.att) { set %Ninja.att $iif(%ninja.ud = u,2,1) | set %ninja.a 0 }
    if ($1 = 37) { set %Ninja.d 1 | set %Ninja.m 1 | return }
    if ($1 = 39) { set %Ninja.d 0 | set %Ninja.m 1 | return }
    if ($1 = 38) { set %Ninja.ud u | return }
    if ($1 = 40) { set %Ninja.ud d | return }
  }
}
on *:KEYUP:@Ninja:*:{
  tokenize 32 $keyval
  if ($1 = 37) && (%Ninja.d = 1) { set %Ninja.m 0 | return }
  if ($1 = 39) && (%Ninja.d = 0) { set %Ninja.m 0 | return }
  if ($1 = 38) && (%ninja.ud = u) { set %Ninja.ud - | return }
  if ($1 = 40) && (%ninja.ud = d) { set %Ninja.ud - | return }
}
alias -l ninja-do {
  if ($active = @Ninja) && ($appactive) {
    var %ticks = $ticks
    var %sx = $int($calc(%ninja.x - 120))
    var %sy = $int($calc(%ninja.y - 80))
    if (%sx < 0) { var %sx 0 }
    if (%sx > 240) { var %sx 240 }
    if (%sy < 0) { var %sy 0 }
    if (%sy > 160) { var %sy 160 }
    inc %Ninja.a
    if (%Ninja.a > 119) { dec %Ninja.a 120 }
    var %na $iif(%ninja.ud = d,crouch,stand)
    if (%ninja.h) { var %na hold | set %ninja.m 0 | set %ninja.f 0 }
    if (%ninja.att) {
      var %na = $iif(%ninja.h,h,$iif(%ninja.f,a,$iif(%ninja.ud = d,d,s))) $+ - $+ $gettok(sword magic,%ninja.att,32)
      goto a
    }
    if (%Ninja.m) && (!%ninja.att) { var %na = $iif(%ninja.ud = d,crawl,run) }
    if (%ninja.f) { var %na $iif(%ninja.ud = u,hair,air) }
    if (%ninja.mu) { var %na goup }
    :a
    var %nx = $na(%na,%Ninja.a,1)
    var %ny = $na(%na,%Ninja.a,0)
    if (%nx = 0) && (%ninja.att) { set %ninja.att 0 }
    if (%nx = 0) && (%ninja.mu) {
      set %ninja.mu 0
      set %nx 0
      set %ny 0
      set %Ninja.h 0
      set %Ninja.f 0
      set %Ninja.ud -
      set %Ninja.y $calc($int($calc(%Ninja.y / 16 + 1)) * 16)
    }
    if (%ninja.mu) { dec %ninja.y 8 | set %Ninja.ud - }
    :clips
    var %ninja.c.u = $replace($getdot(@NinjaClip1,%ninja.x,$calc(%Ninja.y - 17)),16776960,65280)
    var %ninja.c.d = $replace($getdot(@NinjaClip1,%ninja.x,$calc(%Ninja.y + 16)),16776960,65280)
    var %ninja.c.r = $replace($getdot(@NinjaClip1,$calc(%ninja.x + 10),$calc(%Ninja.y + 8)),16776960,65280)
    var %ninja.c.l = $replace($getdot(@NinjaClip1,$calc(%ninja.x - 10),$calc(%Ninja.y + 8)),16776960,65280)
    var %ninja.c.w = $getdot(@NinjaClip2,%ninja.x,%Ninja.y)
    if (%ninja.x < 16) { set %Ninja.x 464 }
    if (%ninja.x > 464) { set %Ninja.x 16 }
    if (%ninja.c.w) && (%ninja.sy < -3.5) { set %ninja.sy -3.5 }
    inc %Ninja.x $calc(%Ninja.m * $iif(%Ninja.c.w,0.5,1) * $iif($iif(%ninja.d,%ninja.c.l,%ninja.c.r),0,1) * $iif(%ninja.f,1,$iif(%ninja.att,0,1)) * 5 * $iif(%ninja.ud = d,0.5,1) * $iif(%Ninja.d,-1,1))
    inc %Ninja.sy $calc($iif(%Ninja.c.w,0.2,0.4) * %Ninja.f * $iif(%ninja.c.d,0,1))
    if (%Ninja.sy > $iif(%Ninja.c.w,3.5,7)) { set %Ninja.sy $iif(%Ninja.c.w,3.5,7) }
    inc %Ninja.y $calc(%Ninja.sy * %Ninja.f * $iif(%ninja.c.d,0,1))
    set %Ninja.f $iif(%ninja.c.d,0,1)
    if (%ninja.c.u = 255) { set %Ninja.sy 1 | inc %ninja.y }
    if (%ninja.c.u = 65280) && (%ninja.ud = u) && (%ninja.f = 1) {
      set %Ninja.sy 0
      set %Ninja.h 1
      set %Ninja.f 0
      set %ninja.y $calc($int($calc(%ninja.y / 16)) * 16)
    }
    if (%ninja.c.d) { set %ninja.y $calc($int($calc(%ninja.y / 16)) * 16) | set %Ninja.sy 0 }
    :draw
    drawcopy -n @NinjaBG %sx %sy 240 160 @Ninja 0 0
    drawpic -ctn @Ninja 16711935 $calc(%Ninja.x - 32 - %sx) $calc(%Ninja.y - 16 - %sy) $calc(%nx * 64) $calc(%ninja.d * 128 + %ny * 32) 64 32 $nn
    drawcopy -tn @NinjaFG 16711935 $calc($int(%ninja.x) - 32) $calc($int(%ninja.y) - 16) 64 32 @Ninja $calc($int(%ninja.x) - %sx - 32) $calc($int(%ninja.y) - %sy - 16)
    drawdot @Ninja
    titlebar @Ninja - $base($int($calc(1000 / ($ticks - %ticks))),10,10,3)
  }
}
alias -l na {
  if ($$1 = goup) { return $gettok($iif($$3,4 3 2 0,3 3 3 3),$calc(($$2 / 2) % 4 + 1),32) }

  if ($$1 = hold) { return $gettok($iif($$3,1 1 1 1,3 3 3 3),$calc(($$2 / 1) % 4 + 1),32) }
  if ($$1 = hair) { return $gettok($iif($$3,0 0 0 0,3 3 3 3),$calc(($$2 / 1) % 4 + 1),32) }
  if ($$1 = air) { return $gettok($iif($$3,0 0 1 1,2 2 2 2),$calc(($$2 / 3) % 4 + 1),32) }
  if ($$1 = stand) { return $gettok($iif($$3,0 0 1 1,0 0 0 0),$calc(($$2 / 3) % 4 + 1),32) }
  if ($$1 = crouch) { return $gettok($iif($$3,0 0 1 1,1 1 1 1),$calc(($$2 / 3) % 4 + 1),32) }
  if ($$1 = run) { return $gettok($iif($$3,2 3 4 5,0 0 0 0),$calc(($$2 / 3) % 4 + 1),32) }
  if ($$1 = crawl) { return $gettok($iif($$3,2 3 4 5,1 1 1 1),$calc(($$2 / 4) % 4 + 1),32) }
  if ($$1 = s-sword) { return $gettok($iif($$3,7 9 10 0,0 0 0 0),$calc(($$2 / 2) % 4 + 1),32) }
  if ($$1 = d-sword) { return $gettok($iif($$3,7 9 10 0,1 1 1 1),$calc(($$2 / 2) % 4 + 1),32) }
  if ($$1 = a-sword) { return $gettok($iif($$3,7 9 10 0,2 2 2 2),$calc(($$2 / 2) % 4 + 1),32) }
  if ($$1 = h-sword) { return $gettok($iif($$3,7 9 10 0,3 3 3 3),$calc(($$2 / 2) % 4 + 1),32) }

  if ($$1 = s-magic) { return $gettok($iif($$3,7 8 8 0,0 0 0 0),$calc(($$2 / 2) % 4 + 1),32) }
  if ($$1 = a-magic) { return $gettok($iif($$3,7 8 8 0,2 2 2 2),$calc(($$2 / 2) % 4 + 1),32) }
  if ($$1 = h-magic) { return $gettok($iif($$3,7 8 8 0,3 3 3 3),$calc(($$2 / 2) % 4 + 1),32) }
}
