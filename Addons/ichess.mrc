alias ichessversion { return 2.077 }
alias ichess {
  if ($1 && $1 != $me 1) {
    .sockclose listenichess*
    .socklisten listenichess $+ $1 $iif($2,$2,221)
    .echo -a 10* Sent iChess-request to $1 $+ ...
    .ctcp $1 ICHESS $ip $iif($2,$2,221)
    .timer 1 60 .sockclose listenichess $+ $1
  }
  else {
    .inc %chesssocks
    %actboard = $+(@Chess_@_,%chesssocks,_,%chesssocks)
    .inichess
    .chess_send IAM $hget(ichess $+ %actboard,me) $hget(ichess $+ %actboard,ownrating)
    .hadd ichess $+ %actboard host 0
  }
}

alias ichessjoin {
  if ($0 == 2) {
    .inc %chesssocks
    .sockopen $+(@Chess,_,$1,_,%chesssocks,_,%chesssocks) $1-
  }
  else {
    .echo -a 4You must specify a host and a port, i.e.: /ichessjoin 214.193.11.176 223
  }
}

dialog ichessaccept {
  title "Accept iChess request"
  size -1 -1 200 100

  text "", 1, 5 10 180 50, center
  button "OK", 2, 20 60 75 30, ok
  button "Cancel", 3, 105 60 75 30, cancel
  text "", 4, 1 1 1 1
}

on *:dialog:icaccept*:sclick:2: {
  var %icrn = $right($dname,-8)
  .inc %chesssocks
  .sockopen $+(@Chess,_,%icrn,_,%chesssocks,_,%chesssocks) $did($dname,4)
  .ctcp %icrn ICHESSACCEPT
  .dialog -x $dname
}

on *:dialog:icaccept*:sclick:3: {
  var %icrn = $right($dname,-8)
  .ctcp %icrn ICHESSDECLINE
  .dialog -x $dname
}

on *:dialog:icaccept*:close:0: {
  .dialog -c $dname
}

ctcp *:ichess:?: {
  .dialog -mvo icaccept $+ $nick ichessaccept
  .did -ra icaccept $+ $nick 1 Accept incoming iChess-request from $nick $+ ?
  .did -ra icaccept $+ $nick 4 $2-
  .dialog -t icaccept $+ $nick iChess with $nick
  haltdef
  halt
}
ctcp *:ichessinvite:?: {
  .dialog -mvo icaccept $+ $nick ichessaccept
  .did -ra icaccept $+ $nick 1 Accept incoming iChess-invitation from $nick $+ ?
  .did -ra icaccept $+ $nick 4 $2-
  .dialog -t icaccept $+ $nick iChess with $nick
  haltdef
  halt
}
ctcp *:ichessaccept:?: { .echo -a 9* $nick accepted the iChess-invitation. | if ($sock(listenichess $+ $nick)) { .timerichessaccwait 1 15 .echo -a 4* no incoming iChess-connection after 15 seconds, try a different port or try letting $nick be the host. } | haltdef | halt }
ctcp *:ichessdecline:?: { .echo -a 4* $nick declined the iChess-invitation. | .sockclose listenichess $+ $nick | haltdef | halt }

on *:socklisten:listenichess*: {
  .timerichessaccwait off
  .inc %chesssocks
  var %sname = $+(@Chess,_,$right($sockname,-12),_,%chesssocks,_,%chesssocks)
  %actboard = $deltok(%sname,-1,$asc(_))
  .inichess
  .sockaccept %sname
  .chess_send IAM $hget(ichess $+ %actboard,me) $hget(ichess $+ %actboard,ownrating)
  .hadd ichess $+ %actboard host 1
  .sockclose $sockname
  .addtochesschat 9** Connection established.
  .addtochesschat 7* Your rating: $hget(ichess $+ %actboard,ownrating)
}

on *:sockopen:@chess*: {
  %actboard = $deltok($sockname,-1,$asc(_))
  if ($sockerr) { .echo -a 4** couldn't connect... | halt }
  .inichess
  .chess_send IAM $hget(ichess $+ %actboard,me) $hget(ichess $+ %actboard,ownrating)
  .addtochesschat 9** Connection established.
  .addtochesschat 7* Your rating: $hget(ichess $+ %actboard,ownrating)
}

on *:sockread:@chess*: {
  %actboard = $deltok($sockname,-1,$asc(_))
  var %lineread
  .sockread %lineread
  if ($hfind(ichess $+ %actboard,banlist $+ $sock($sockname).ip,1,W)) {
    .sockwrite -n $sockname BANNED
    halt
  }
  .tokenize 32 %lineread
  if (($1 == CHAT || $1 == CHATACTION) && $hget(ichess $+ %actboard,mutemode)) {
    .sockwrite -n $sockname CHAT $hget(ichess $+ %actboard,me) 4the board is set to mute
    halt
  }
  %actchesssock = $sockname
  .chess_send $1-
  .handlechessprotocol $1-
  .unset %actchesssock
}

alias handlechessprotocol {
  if ($istok(IAM NEWGAMEREQ ACCEPT_NG DECLINE_NG MOVE LOADGAMEREQ ACCEPT_LG DECLINE_LG STARTLOAD LOADMOVE ENDLOAD UNDOREQ ACCEPT_UNDO DECLINE_UNDO QUIT RESIGN CHANGESIDESREQ ACCEPT_CHANGES DECLINE_CHANGES CHAT CHATACTION TIMELIMITREQ ACCEPT_TL DECLINE_TL DISCONNECT REMISREQ ACCEPT_RE DECLINE_RE PLAYERS KICK BANNED CONTGAMEREQ ACCEPT_CG DECLINE_CG,$1,32)) { goto $1 }
  else { .addtochesschat 4* unknown command: $1 | return }

  :IAM
  .hadd ichess $+ %actboard users $+ $2 $3-
  .addtochesschat 7** User: $2 ( $+ $3- $+ )
  .sockmark %actchesssock $2-
  return

  :NEWGAMEREQ
  .addtochesschat 7* $3 requests to start a new game with $iif($2 == $hget(ichess $+ %actboard,me),You,$2) $+ . $iif($4 == r,(Random sides),You playing $iif($4 == w,Black.,White.))
  if ($2 == $hget(ichess $+ %actboard,me)) {
    .hadd ichess $+ %actboard request $1-
    if (1 * iswm $hget(ichess $+ %actboard,beepmode)) { .beep }
  }
  return

  :ACCEPT_NG
  .addtochesschat 9* $3 accepted a new game.
  .hadd ichess $+ %actboard wplayername $iif($4 == w,$2,$3)
  .hadd ichess $+ %actboard bplayername $iif($4 == b,$2,$3)

  .hadd ichess $+ %actboard opponent $3
  .hadd ichess $+ %actboard opprating $hget(ichess $+ %actboard,users $+ $3)

  if ($2 == $hget(ichess $+ %actboard,me)) {
    .startchessgame $4
    if ($3 $4 == @RCPU b) { .cpuchessmove %actboard }
  }
  else {
    .startchessgame e
    .hadd ichess $+ %actboard turn w
  }
  return

  :DECLINE_NG
  .addtochesschat 4* $3 declined a new game.
  return

  :MOVE
  .hadd ichess $+ %actboard tradepawn $iif($5 isnum, $gettok(p n b r q, $5, 32), $5)
  .chessmove $2 $3 other $4
  if (* 1 iswm $hget(ichess $+ %actboard,beepmode)) { .beep }
  .window -g2 %actboard
  return

  :LOADGAMEREQ
  .addtochesschat 7* $3 requests to load a game and play with $iif($2 == $hget(ichess $+ %actboard,me),You,$2) $+ . Playing $iif($4 == b,Black.,White.)
  .hadd ichess $+ %actboard request $1-
  if (1 * iswm $hget(ichess $+ %actboard,beepmode)) { .beep }
  return

  :ACCEPT_LG
  .addtochesschat 9* $3 accepted to load the game.
  .hadd ichess $+ %actboard wplayername $iif($4 == w,$2,$3)
  .hadd ichess $+ %actboard bplayername $iif($4 == b,$2,$3)

  .hadd ichess $+ %actboard opponent $3
  .hadd ichess $+ %actboard opprating $hget(ichess $+ %actboard,users $+ $3)

  if ($2 == $hget(ichess $+ %actboard,me)) {
    .unset %actchesssock
    .loadgamehistory $3 $4 $hget(ichess $+ %actboard,loadgamefn)
    .hdel ichess $+ %actboard loadgamefn
  }
  if ($hget(ichess $+ %actboard,$hget(ichess $+ %actboard,turn) $+ playername) == @RCPU) { .cpuchessmove %actboard }
  return

  :DECLINE_LG
  .addtochesschat 4* $3 declined to load the game.
  return

  :STARTLOAD
  if ($2 == $hget(ichess $+ %actboard,me)) {
    .startchessgame $4
  }
  else {
    .startchessgame e
  }
  return

  :LOADMOVE
  if (*:* !iswm $2-) {
    .hadd ichess $+ %actboard wtime $2
    .hadd ichess $+ %actboard btime $3
  }
  else {
    var %blob, %hrm
    %hrm = $regsub($2-,/(\d+:) (.+)([+†]\s) (.+)/,14\1 4\2\3 14\4,%blob)
    %hrm = $regsub(%blob,/(.+) (.+)([+†])/,\1 4\2\3,%blob)
    .aline -l 14 %actboard %blob
  }
  return

  :ENDLOAD
  .loadchessgame $2
  return

  :UNDOREQ
  .addtochesschat 7* $2 requests to undo all moves after 15[ $+ $4- $+ 15].
  if ($hget(ichess $+ %actboard,owncolor) != e) {
    if (!$hget(ichess $+ %actboard,allowundo)) {
      .addtochesschat 4* You declined to undo. (auto)
      .chess_send DECLINE_UNDO $2 $hget(ichess $+ %actboard,me) auto
    }
    else {
      .hadd ichess $+ %actboard request $1-
      if (1 * iswm $hget(ichess $+ %actboard,beepmode)) { .beep }
    }
  }
  return

  :ACCEPT_UNDO
  .addtochesschat 9* $3 accepted to undo.
  .undotil $4
  return

  :DECLINE_UNDO
  .addtochesschat 4* $3 declined to undo. $iif($4 == auto, (auto))
  return

  :QUIT
  .addtochesschat 4* $2 left the board..
  return

  :RESIGN
  .chessgameover opp resign
  if (1 * iswm $hget(ichess $+ %actboard,beepmode)) { .beep }
  return

  :CHANGESIDESREQ
  .addtochesschat 7* $3 requests to change sides.
  if ($hget(ichess $+ %actboard,owncolor) != e) {
    .hadd ichess $+ %actboard request $1-
    if (1 * iswm $hget(ichess $+ %actboard,beepmode)) { .beep }
  }
  return

  :ACCEPT_CHANGES
  .addtochesschat 9* $3 accepted to change sides.
  if ($hget(ichess $+ %actboard,owncolor) != e) {
    .hadd ichess $+ %actboard owncolor $iif($hget(ichess $+ %actboard,owncolor) == w,b,w)
    .constructboard $hget(ichess $+ %actboard,owncolor)
    .buildchessboard
    .showbwturn
  }
  return

  :DECLINE_CHANGES
  .addtochesschat 4* $3 declined to change sides.
  return

  :CHAT
  .addtochesschat 11«10 $+ $2 $+ 11»15 $3-
  return

  :CHATACTION
  .addtochesschat 11* $2 10 $+ $3-
  return

  :TIMELIMITREQ
  .addtochesschat 7* $hget(ichess $+ %actboard,opponent) requests to $iif($2 == 0,turn the Timelimit off.,set a Timelimit of $formatchesstime($2) $+ .)
  .hadd ichess $+ %actboard request $1-
  if (1 * iswm $hget(ichess $+ %actboard,beepmode)) { .beep }
  return

  :ACCEPT_TL
  .addtochesschat 9* $hget(ichess $+ %actboard,opponent) accepted the timelimit.
  .hadd ichess $+ %actboard timelimit $2
  return

  :DECLINE_TL
  .addtochesschat 4* $hget(ichess $+ %actboard,opponent) declined the timelimit.
  return

  :DISCONNECT
  .addtochesschat 4** $2 disconnected.
  .hdel ichess $+ %actboard users $+ $2
  return

  :KICK
  if ($2 == $hget(ichess $+ %actboard,me)) {
    .addtochesschat 7*4 You 7were kicked by $2 ( $+ $4- $+ )
  }
  else {
    .addtochesschat 7*4 $3 7kicked by $2 ( $+ $4- $+ )
    .hdel ichess $+ %actboard users $+ $3
  }
  return

  :BANNED
  .addtochesschat 4* Your IP is banned.
  return

  :REMISREQ
  .addtochesschat 7* $3 offers a Remis.
  if ($hget(ichess $+ %actboard,owncolor) != e) {
    .hadd ichess $+ %actboard request $1-
    if (1 * iswm $hget(ichess $+ %actboard,beepmode)) { .beep }
  }
  return

  :ACCEPT_RE
  .addtochesschat 9* $3 accepts the Remis.
  .chessgameover you remis
  return

  :DECLINE_RE
  .addtochesschat 4* $3 declined the Remis.
  return

  :PLAYERS
  .hadd ichess $+ %actboard wplayername $2
  .hadd ichess $+ %actboard bplayername $3
  return

  :CONTGAMEREQ
  .addtochesschat 7* $3 requests to continue the game with $iif($2 == $hget(ichess $+ %actboard,me),You,$2) $+ . You playing $iif($4 == b,Black.,White.)
  if ($2 == $hget(ichess $+ %actboard,me)) {
    .hadd ichess $+ %actboard request $1-
    if (1 * iswm $hget(ichess $+ %actboard,beepmode)) { .beep }
  }
  return

  :ACCEPT_CG
  .addtochesschat 9* $3 accepted to continue the game.
  .hadd ichess $+ %actboard $4 $+ playername $3

  .hadd ichess $+ %actboard opponent $3
  .hadd ichess $+ %actboard opprating $hget(ichess $+ %actboard,users $+ $3)
  return

  :DECLINE_CG
  .addtochesschat 4* $3 declined to continue the game.
  return
}

alias -l chess_send {
  if (@Chess_@_* iswm %actboard && !$istok(CHAT CHATACTION MOVE UNDOTIL STARTLOAD LOADMOVE ENDLOAD,$1,32)) {
    .handlechessprotocol $1-
  }
  else if ($sock(%actboard $+ *,0)) {
    if (!%actchesssock) {
      .sockwrite -n %actboard $+ * $1-
    }
    else {
      var %i = $sock(%actboard $+ *,0)
      while (%i) {
        if ($sock(%actboard $+ *,%i) != %actchesssock) {
          .sockwrite -n $ifmatch $1-
        }
        .dec %i
      }
    }
  }
}

alias -l inichess {
  if ($hget(ichess $+ %actboard)) { .hdel -w ichess $+ %actboard * }
  else { .hmake ichess $+ %actboard 100 }

  .hadd ichess $+ %actboard allowundo $readini($scriptdir $+ ichess.ini,rules,allowundo)
  .hadd ichess $+ %actboard showvalidmoves $readini($scriptdir $+ ichess.ini,settings,showvalidmoves)
  .hadd ichess $+ %actboard showchessclock $readini($scriptdir $+ ichess.ini,settings,showchessclock)
  .hadd ichess $+ %actboard countdownontimelimit $readini($scriptdir $+ ichess.ini,settings,countdownontimelimit)
  .hadd ichess $+ %actboard allowsingleclickmoves $readini($scriptdir $+ ichess.ini,settings,allowsingleclickmoves)
  .hadd ichess $+ %actboard stripcolorsinchat $readini($scriptdir $+ ichess.ini,settings,stripcolorsinchat)
  .hadd ichess $+ %actboard openasdesktopwindow $readini($scriptdir $+ ichess.ini,settings,openasdesktopwindow)
  .hadd ichess $+ %actboard beepmode $readini($scriptdir $+ ichess.ini,settings,beepmode)
  if (!$hget(ichess $+ %actboard,beepmode)) { .hadd ichess $+ %actboard beepmode 1 1 }
  .hadd ichess $+ %actboard sortcaptures $readini($scriptdir $+ ichess.ini,settings,sortcaptures)
  if (!$hget(ichess $+ %actboard,sortcaptures)) { .hadd ichess $+ %actboard sortcaptures 1 }
  .hadd ichess $+ %actboard nostats $readini($scriptdir $+ ichess.ini,settings,nostats)

  .hadd ichess $+ %actboard ownrating $calcownCXR
  .hadd ichess $+ %actboard me $readini($scriptdir $+ ichess.ini,settings,nickname)

  if (!$hget(ichess $+ %actboard,me)) {
    .hadd ichess $+ %actboard me $me
    .writeini " $+ $scriptdir $+ ichess.ini $+ " settings nickname $me
  }

  .hadd ichess $+ %actboard pieceset $readini($scriptdir $+ ichess.ini,settings,pieceset)
  if (!$hget(ichess $+ %actboard,pieceset)) {
    .hadd ichess $+ %actboard pieceset normal
  }

  .hadd ichess $+ %actboard fieldset $readini($scriptdir $+ ichess.ini,settings,fieldset)
  if (!$hget(ichess $+ %actboard,fieldset)) {
    .hadd ichess $+ %actboard fieldset normal
  }

  .hadd ichess $+ %actboard boardbmp $readini($scriptdir $+ ichess.ini,settings,boardbmp)
  if (!$hget(ichess $+ %actboard,boardbmp)) {
    .hadd ichess $+ %actboard boardbmp none
  }

  .hadd ichess $+ %actboard boardtransp $readini($scriptdir $+ ichess.ini,settings,boardtransp)
  if (!$hget(ichess $+ %actboard,boardtransp)) {
    .hadd ichess $+ %actboard boardtransp 75
  }

  .hadd ichess $+ %actboard pieces pawn knight bishop rook queen king
  var %i = 1
  var %cpnames = pnbrqk
  while (%i <= 6) {
    .hadd ichess $+ %actboard b $+ $mid(%cpnames,%i,1) $calc((%i - 1) * 40) 0 40 40
    .hadd ichess $+ %actboard w $+ $mid(%cpnames,%i,1) $calc((%i - 1) * 40) 40 40 40
    .inc %i
  }

  .drawpic -c
  .window -epk0l13 $+ $iif($hget(ichess $+ %actboard,openasdesktopwindow),d) %actboard -1 -1 643 550
  .window -pnh @temp2 $+ %actboard 100 100 600 600

  .drawfill -r %actboard $rgb(0,0,0) $rgb(0,0,0) 1 1
  .drawfill -r @temp2 $+ %actboard $rgb(0,0,0) $rgb(0,0,0) 1 1

  .hadd ichess $+ %actboard chatfont $gettok($readini($scriptdir $+ ichess.ini,settings,chatfont),1,32)
  if (!$hget(ichess $+ %actboard,chatfont)) {
    .writeini " $+ $scriptdir $+ ichess.ini $+ " settings chatfont Arial
    .hadd ichess $+ %actboard chatfont Arial
  }

  .hadd ichess $+ %actboard chatfontsize $gettok($readini($scriptdir $+ ichess.ini,settings,chatfontsize),1,32)
  if (!$hget(ichess $+ %actboard,chatfontsize)) {
    .writeini " $+ $scriptdir $+ ichess.ini $+ " settings chatfontsize 12
    .hadd ichess $+ %actboard chatfontsize 12
  }

  .hadd ichess $+ %actboard fielddims 40
  .hadd ichess $+ %actboard fieldleft 20
  .hadd ichess $+ %actboard fieldtop 40
  .hadd ichess $+ %actboard fieldright $calc($hget(ichess $+ %actboard,fieldleft) + 8 * $hget(ichess $+ %actboard,fielddims))
  .hadd ichess $+ %actboard fieldbottom $calc($hget(ichess $+ %actboard,fieldtop) + 8 * $hget(ichess $+ %actboard,fielddims))

  .hadd ichess $+ %actboard captdx $int($calc($hget(ichess $+ %actboard,fielddims) * 2 / 3))
  .hadd ichess $+ %actboard captdy $int($calc($hget(ichess $+ %actboard,fielddims) * 2 / 3))
  .hadd ichess $+ %actboard ecaptx $calc($hget(ichess $+ %actboard,fieldright) + 15)
  .hadd ichess $+ %actboard ecapty $calc($hget(ichess $+ %actboard,fieldtop))
  .hadd ichess $+ %actboard ocaptx $calc($hget(ichess $+ %actboard,fieldright) + 15)
  .hadd ichess $+ %actboard ocapty $calc($hget(ichess $+ %actboard,fieldbottom) - $hget(ichess $+ %actboard,captdy) * 3 - 8)

  .hadd ichess $+ %actboard chatx 10
  .hadd ichess $+ %actboard chaty $calc($hget(ichess $+ %actboard,fieldbottom) + 20)
  .hadd ichess $+ %actboard chatw $calc($window(%actboard).dw - $hget(ichess $+ %actboard,chatx) - 30)
  .hadd ichess $+ %actboard chath $calc($window(%actboard).dh - $hget(ichess $+ %actboard,chaty) - 10)

  .hadd ichess $+ %actboard upx $calc($hget(ichess $+ %actboard,chatx) + $hget(ichess $+ %actboard,chatw) + 5)
  .hadd ichess $+ %actboard upy $calc($hget(ichess $+ %actboard,chaty) - 5)

  .hadd ichess $+ %actboard downx $calc($hget(ichess $+ %actboard,chatx) + $hget(ichess $+ %actboard,chatw) + 5)
  .hadd ichess $+ %actboard downy $calc($hget(ichess $+ %actboard,chaty) + $hget(ichess $+ %actboard,chath) - 15)

  .hadd ichess $+ %actboard linepointer 1

  .hadd ichess $+ %actboard piecebmp " $+ $scriptdir $+ ichess_pieces_ $+ $hget(ichess $+ %actboard,pieceset) $+ .bmp $+ "

  .hadd ichess $+ %actboard dll c:\cpp\ichess\ichess.dll
  .hadd ichess $+ %actboard dll2 c:\cpp\ichess\ichess2.dll
  .hadd ichess $+ %actboard dll $scriptdir $+ ichess.dll
  .hadd ichess $+ %actboard dll2 $scriptdir $+ ichess2.dll

  .hadd ichess $+ %actboard cpudepth 4

  .startchessgame e
}

alias -l addtochesschat {
  var %linecounter = $iif(6.03 <= $version,$hfind(ichess $+ %actboard,chatting*,0,w),$hmatch(ichess $+ %actboard,chatting*,0))
  if ($hget(ichess $+ %actboard,linepointer) >= %linecounter) { .hadd ichess $+ %actboard linepointer $calc(%linecounter + 1) }
  .inc %linecounter
  .hadd ichess $+ %actboard chatting $+ %linecounter $1-
  .showchesschat
  .window -g1 %actboard
}

alias -l showchesschat {
  .drawrect -frn %actboard $rgb(50,50,50) 1 $calc($hget(ichess $+ %actboard,chatx) - 5) $calc($hget(ichess $+ %actboard,chaty) - 5) $calc($hget(ichess $+ %actboard,chatw) + 10) $calc($hget(ichess $+ %actboard,chath) + 10)
  .drawrect -rn %actboard $rgb(150,150,150) 1 $calc($hget(ichess $+ %actboard,chatx) - 5) $calc($hget(ichess $+ %actboard,chaty) - 5) $calc($hget(ichess $+ %actboard,chatw) + 11) $calc($hget(ichess $+ %actboard,chath) + 10)

  .drawrect -frn %actboard $rgb(45,45,45) 1 $calc($hget(ichess $+ %actboard,chatx) + $hget(ichess $+ %actboard,chatw) + 5) $calc($hget(ichess $+ %actboard,chaty) - 5) 20 $calc($hget(ichess $+ %actboard,chath) + 10)
  .drawrect -rn %actboard $rgb(150,150,150) 1 $calc($hget(ichess $+ %actboard,chatx) + $hget(ichess $+ %actboard,chatw) + 5) $calc($hget(ichess $+ %actboard,chaty) - 5) 20 $calc($hget(ichess $+ %actboard,chath) + 10)

  ; up button
  .drawrect -frn %actboard $rgb(90,90,90) 1 $hget(ichess $+ %actboard,upx) $hget(ichess $+ %actboard,upy) 20 20
  .drawrect -rn %actboard $rgb(150,150,150) 1 $hget(ichess $+ %actboard,upx) $hget(ichess $+ %actboard,upy) 20 20
  .drawline -rn %actboard $rgb(180,180,180) 2 $&
    $calc($hget(ichess $+ %actboard,upx) + 5) $calc($hget(ichess $+ %actboard,upy) + 15) $&
    $calc($hget(ichess $+ %actboard,upx) + 10) $calc($hget(ichess $+ %actboard,upy) + 5) $&
    $calc($hget(ichess $+ %actboard,upx) + 15) $calc($hget(ichess $+ %actboard,upy) + 15)

  ; down button
  .drawrect -frn %actboard $rgb(90,90,90) 1 $hget(ichess $+ %actboard,downx) $hget(ichess $+ %actboard,downy) 20 20
  .drawrect -rn %actboard $rgb(150,150,150) 1 $hget(ichess $+ %actboard,downx) $hget(ichess $+ %actboard,downy) 20 20
  .drawline -rn %actboard $rgb(180,180,180) 2 $&
    $calc($hget(ichess $+ %actboard,downx) + 5) $calc($hget(ichess $+ %actboard,downy) + 5) $&
    $calc($hget(ichess $+ %actboard,downx) + 10) $calc($hget(ichess $+ %actboard,downy) + 15) $&
    $calc($hget(ichess $+ %actboard,downx) + 15) $calc($hget(ichess $+ %actboard,downy) + 5)

  var %alllines = $iif(6.03 <= $version,$hfind(ichess $+ %actboard,chatting*,0,w),$hmatch(ichess $+ %actboard,chatting*,0))
  var %linecounter = $iif($hget(ichess $+ %actboard,linepointer),$ifmatch,1)

  if (!%alllines) { %alllines = 1 }
  ; slider
  var %barlength = $calc($hget(ichess $+ %actboard,downy) - $hget(ichess $+ %actboard,upy) - 20)
  var %sliderlength = $int($calc(%barlength / %alllines))
  if (%sliderlength < 10) { %sliderlength = 10 }
  var %sliderposy = $int($calc($hget(ichess $+ %actboard,upy) + 20 + (%barlength - %sliderlength) * (%linecounter - 1) / ($iif(%alllines != 1,$ifmatch,2) - 1)))

  .drawrect -frn %actboard $rgb(80,80,120) 1 $calc($hget(ichess $+ %actboard,upx) + 1) %sliderposy 18 %sliderlength
  .drawrect -rn %actboard $rgb(10,10,50) 1 $calc($hget(ichess $+ %actboard,upx) + 1) %sliderposy 18 %sliderlength

  var %fsize = $hget(ichess $+ %actboard,chatfontsize)
  var %i = $int($calc($hget(ichess $+ %actboard,chath) / (%fsize + 2)))
  while (%i > 0) {
    var %chatline = $hget(ichess $+ %actboard,chatting $+ %linecounter)
    if ($hget(ichess $+ %actboard,stripcolorsinchat)) {
      %chatline = $strip(%chatline,c)
    }
    if (!%chatline) { goto endchatting }
    if ($wrap(%chatline,$hget(ichess $+ %actboard,chatfont),%fsize,$hget(ichess $+ %actboard,chatw),0) > 1) {
      var %chatline1 = $wrap(%chatline,$hget(ichess $+ %actboard,chatfont),%fsize,$hget(ichess $+ %actboard,chatw),1)
      var %j = $wrap($right(%chatline,$calc(0 - $len(%chatline1))),$hget(ichess $+ %actboard,chatfont),%fsize,$calc($hget(ichess $+ %actboard,chatw) - 20),0)
      while (%j) {
        .drawtext -rbpn %actboard $rgb(150,150,150) $rgb(50,50,50) $hget(ichess $+ %actboard,chatfont) %fsize $calc($hget(ichess $+ %actboard,chatx) + 20) $calc($hget(ichess $+ %actboard,chaty) + (%fsize + 2) * (%i - 1)) 15 $wrap($right(%chatline,$calc(0 - $len(%chatline1))),$hget(ichess $+ %actboard,chatfont),%fsize,$calc($hget(ichess $+ %actboard,chatw) - 20),%j)
        .dec %j
        .dec %i
        if (%i < 1) { goto endchatting }
      }
      .drawtext -rbpn %actboard $rgb(150,150,150) $rgb(50,50,50) $hget(ichess $+ %actboard,chatfont) %fsize $calc($hget(ichess $+ %actboard,chatx)) $calc($hget(ichess $+ %actboard,chaty) + (%fsize + 2) * (%i - 1)) %chatline1
    }
    else {
      .drawtext -rbpn %actboard $rgb(150,150,150) $rgb(50,50,50) $hget(ichess $+ %actboard,chatfont) %fsize $calc($hget(ichess $+ %actboard,chatx)) $calc($hget(ichess $+ %actboard,chaty) + (%fsize + 2) * (%i - 1)) %chatline
    }
    .dec %i
    .dec %linecounter
  }
  :endchatting
  .drawdot %actboard
}

alias -l showbwturn {
  var %col1, %col2
  if ($hget(ichess $+ %actboard,turn) == e) { %col1 = 1 | %col2 = 1 }
  else if ($hget(ichess $+ %actboard,owncolor) == e) {
    if ($hget(ichess $+ %actboard,turn) != $hget(ichess $+ %actboard,boardsidecolor)) { %col1 = 7 | %col2 = 1 }
    else { %col1 = 1 | %col2 = 7 }
  }
  else if ($hget(ichess $+ %actboard,turn) == $hget(ichess $+ %actboard,boardsidecolor)) { %col1 = 1 | %col2 = 9 }
  else { %col1 = 9 | %col2 = 1 }

  .drawrect -n %actboard %col1 3 $calc($hget(ichess $+ %actboard,ecaptx) - 5) $calc($hget(ichess $+ %actboard,ecapty) - 6) $calc($hget(ichess $+ %actboard,captdx) * 5 + 13) $calc($hget(ichess $+ %actboard,captdy) * 3 + 15)
  .drawrect -n %actboard %col2 3 $calc($hget(ichess $+ %actboard,ocaptx) - 5) $calc($hget(ichess $+ %actboard,ocapty) - 6) $calc($hget(ichess $+ %actboard,captdx) * 5 + 13) $calc($hget(ichess $+ %actboard,captdy) * 3 + 15)

  .drawrect -n %actboard %col1 3 $calc($hget(ichess $+ %actboard,ecaptx) - 5) $calc($hget(ichess $+ %actboard,ecapty) + $hget(ichess $+ %actboard,captdy) * 3 + 7) $calc($hget(ichess $+ %actboard,captdx) * 5 + 13) $calc($hget(ichess $+ %actboard,captdy) + 14)
  .drawrect -n %actboard %col2 3 $calc($hget(ichess $+ %actboard,ocaptx) - 5) $calc($hget(ichess $+ %actboard,ocapty) - $hget(ichess $+ %actboard,captdy) - 18) $calc($hget(ichess $+ %actboard,captdx) * 5 + 13) $calc($hget(ichess $+ %actboard,captdy) + 14)

  .drawdot %actboard
}

alias -l showcaptures {
  .drawrect -fn %actboard 5 1 $hget(ichess $+ %actboard,ecaptx) $hget(ichess $+ %actboard,ecapty) $calc($hget(ichess $+ %actboard,captdx) * 5 + 3) $calc($hget(ichess $+ %actboard,captdy) * 3 + 3)
  .drawrect -fn %actboard 5 1 $hget(ichess $+ %actboard,ocaptx) $hget(ichess $+ %actboard,ocapty) $calc($hget(ichess $+ %actboard,captdx) * 5 + 3) $calc($hget(ichess $+ %actboard,captdy) * 3 + 3)

  var %ecolor = $hget(ichess $+ %actboard,boardsidecolor)
  var %sortedps
  if ($hget(ichess $+ %actboard,sortcaptures)) {
    %sortedps = $replace($sorttok($replace($hget(ichess $+ %actboard,%ecolor $+ capt),p,1,n,2,b,3,r,4,q,5),32,nr),1,p,2,n,3,b,4,r,5,q)
  }
  else {
    %sortedps = $hget(ichess $+ %actboard,%ecolor $+ capt)
  }
  var %i = 1, %maxcaps = $numtok(%sortedps,32)
  while (%i <= %maxcaps) {
    .drawpic -csntm %actboard $rgb(0,0,255) $calc($hget(ichess $+ %actboard,ecaptx) + 2 + $hget(ichess $+ %actboard,captdx) * ((%i - 1) % 5)) $calc($hget(ichess $+ %actboard,ecapty) + 2 + $hget(ichess $+ %actboard,captdy) * $int($calc((%i - 1) / 5))) $hget(ichess $+ %actboard,captdx) $hget(ichess $+ %actboard,captdy) $hget(ichess $+ %actboard,%ecolor $+ $gettok(%sortedps,%i,32)) $hget(ichess $+ %actboard,piecebmp)
    .inc %i
  }

  %ecolor = $iif($hget(ichess $+ %actboard,boardsidecolor) == w,b,w)
  if ($hget(ichess $+ %actboard,sortcaptures)) {
    %sortedps = $replace($sorttok($replace($hget(ichess $+ %actboard,%ecolor $+ capt),p,1,n,2,b,3,r,4,q,5),32,nr),1,p,2,n,3,b,4,r,5,q)
  }
  else {
    %sortedps = $hget(ichess $+ %actboard,%ecolor $+ capt)
  }
  var %i = 1, %maxcaps = $numtok(%sortedps,32)
  while (%i <= %maxcaps) {
    .drawpic -csntm %actboard $rgb(0,0,255) $calc($hget(ichess $+ %actboard,ocaptx) + 2 + $hget(ichess $+ %actboard,captdx) * ((%i - 1) % 5)) $calc($hget(ichess $+ %actboard,ocapty) + 2 + $hget(ichess $+ %actboard,captdy) * $int($calc((%i - 1) / 5))) $hget(ichess $+ %actboard,captdx) $hget(ichess $+ %actboard,captdy) $hget(ichess $+ %actboard,%ecolor $+ $gettok(%sortedps,%i,32)) $hget(ichess $+ %actboard,piecebmp)
    .inc %i
  }

  .drawdot %actboard
}

alias showchessclock {
  if (@* !iswm $1) {
    .timer $+ $1 off
    .timer@ $+ $1 0 1 .showchessclock @ $+ $1
    halt
  }
  var %pname = $iif($hget(ichess $+ $1,boardsidecolor) == w,$iif($hget(ichess $+ $1,bplayername),$ifmatch,Black:),$iif($hget(ichess $+ $1,wplayername),$ifmatch,White:))
  var %wneeded = $width(%pname,Comic,15)
  .drawrect -fn $1 1 1 $hget(ichess $+ $1,ecaptx) $calc($hget(ichess $+ $1,ecapty) - 26) $calc($hget(ichess $+ $1,captdx) * 5 + 3) 18
  .drawtext -b $1 15 1 $int($calc($hget(ichess $+ $1,ecaptx) + ($hget(ichess $+ $1,captdx) * 5 - %wneeded) / 2)) $calc($hget(ichess $+ $1,ecapty) - 25) %pname

  %pname = $iif($hget(ichess $+ $1,boardsidecolor) == b,$iif($hget(ichess $+ $1,bplayername),$ifmatch,Black:),$iif($hget(ichess $+ $1,wplayername),$ifmatch,White:))
  %wneeded = $width(%pname,Comic,15)
  .drawrect -fn $1 1 1 $hget(ichess $+ $1,ecaptx) $calc($hget(ichess $+ $1,ocapty) - $hget(ichess $+ $1,captdy) - 39) $calc($hget(ichess $+ $1,captdx) * 5 + 3) 18
  .drawtext -b $1 15 1 $int($calc($hget(ichess $+ $1,ocaptx) + ($hget(ichess $+ $1,captdx) * 5 - %wneeded) / 2)) $calc($hget(ichess $+ $1,ocapty) - $hget(ichess $+ $1,captdy) - 38) %pname

  .drawrect -fnr $1 $rgb(60,60,60) 1 $hget(ichess $+ $1,ecaptx) $calc($hget(ichess $+ $1,ecapty) + $hget(ichess $+ $1,captdy) * 3 + 13) $calc($hget(ichess $+ $1,captdx) * 5 + 3) $calc($hget(ichess $+ $1,captdy) + 3)
  .drawrect -fnr $1 $rgb(60,60,60) 1 $hget(ichess $+ $1,ocaptx) $calc($hget(ichess $+ $1,ocapty) - $hget(ichess $+ $1,captdy) - 12) $calc($hget(ichess $+ $1,captdx) * 5 + 3) $calc($hget(ichess $+ $1,captdy) + 3)

  if ($hget(ichess $+ $1,turn) == e || !$hget(ichess $+ $1,showchessclock)) { .drawdot $1 | return }

  var %eusedtime = $hget(ichess $+ $1,$iif($hget(ichess $+ $1,boardsidecolor) == w,b,w) $+ time)
  var %ousedtime = $hget(ichess $+ $1,$hget(ichess $+ $1,boardsidecolor) $+ time)

  if ($hget(ichess $+ $1,turn) != end) {
    if ($hget(ichess $+ $1,owncolor) != e) {
      if ($hget(ichess $+ $1,owncolor) == $hget(ichess $+ $1,turn) && $hget(ichess $+ $1,owncolor) == $hget(ichess $+ $1,boardsidecolor)) {
        .inc %ousedtime $calc($ticks - $hget(ichess $+ $1,startmovetime))
      }
      else {
        .inc %eusedtime $calc($ticks - $hget(ichess $+ $1,startmovetime))
      }
    }
    else {
      if ($hget(ichess $+ $1,boardsidecolor) == $hget(ichess $+ $1,turn)) {
        .inc %ousedtime $calc($ticks - $hget(ichess $+ $1,startmovetime))
      }
      else {
        .inc %eusedtime $calc($ticks - $hget(ichess $+ $1,startmovetime))
      }
    }
  }

  %eusedtime = $int($calc(%eusedtime / 1000))
  %ousedtime = $int($calc(%ousedtime / 1000))

  var %ctimelimit = $hget(ichess $+ $1,timelimit)
  if (%ctimelimit) {
    if ($hget(ichess $+ $1,turn) != end && %eusedtime > %ctimelimit) {
      .hadd ichess $+ $1 $iif($hget(ichess $+ $1,owncolor) == w,b,w) $+ time $calc(%eusedtime * 1000)
      %actboard = $1
      .chessgameover opp timeout
    }
    else if ($hget(ichess $+ $1,turn) != end && %ousedtime > %ctimelimit) {
      .hadd ichess $+ $1 $iif($hget(ichess $+ $1,owncolor) == w,b,w) $+ time $calc(%ousedtime * 1000)
      %actboard = $1
      .chessgameover you timeout
    }

    if ($hget(ichess $+ $1,countdownontimelimit)) {
      %eusedtime = $calc(%ctimelimit - %eusedtime)
      %ousedtime = $calc(%ctimelimit - %ousedtime)
    }
  }

  if (%eusedtime < 0 ) { %eusedtime = 0 }
  if (%ousedtime < 0 ) { %ousedtime = 0 }

  var %fwidth = $calc($hget(ichess $+ $1,captdx) * 5 - 3), %fheight = $calc($hget(ichess $+ $1,captdy) - 3)
  %eusedtime = 15 $+ $base($int($calc(%eusedtime / 3600)),10,10,2) $+ 14:15 $+ $base($int($calc((%eusedtime % 3600) / 60)),10,10,2) $+ 14:15 $+ $base($calc(%eusedtime % 60),10,10,2)
  var %wneeded = $width(%eusedtime,Comic,%fheight,C)

  .drawtext -npbr $1 $rgb(60,60,60) $rgb(60,60,60) Comic %fheight $calc($hget(ichess $+ $1,ecaptx) + (%fwidth - %wneeded) / 2) $calc($hget(ichess $+ $1,ecapty) + $hget(ichess $+ $1,captdy) * 3 + 14) %eusedtime

  %eusedtime = %ousedtime
  %eusedtime = 15 $+ $base($int($calc(%eusedtime / 3600)),10,10,2) $+ 14:15 $+ $base($int($calc((%eusedtime % 3600) / 60)),10,10,2) $+ 14:15 $+ $base($calc(%eusedtime % 60),10,10,2)
  %wneeded = $width(%eusedtime,Comic,%fheight,C)

  .drawtext -npbr $1 $rgb(60,60,60) $rgb(60,60,60) Comic %fheight $calc($hget(ichess $+ $1,ecaptx) + (%fwidth - %wneeded) / 2) $calc($hget(ichess $+ $1,ocapty) - $hget(ichess $+ $1,captdy) - 10) %eusedtime

  .drawdot $1
}

alias -l startchessgame {
  while ($line(%actboard,0,1)) { .dline -l %actboard 1 }
  .aline -l 7 %actboard Start:
  .hdel -w ichess $+ %actboard *_*
  .hadd ichess $+ %actboard owncolor $1
  .hadd ichess $+ %actboard turn $iif($1 == e,e,w)
  .hadd ichess $+ %actboard lastmove 00 00
  .hdel -w ichess $+ %actboard cur*
  .hadd ichess $+ %actboard wkingpos E1
  .hadd ichess $+ %actboard bkingpos E8
  .hadd ichess $+ %actboard wmoved 000
  .hadd ichess $+ %actboard bmoved 000
  .hadd ichess $+ %actboard moves 1

  .hadd ichess $+ %actboard boardsidecolor $iif($1 == e,w,$1)

  .hdel -w ichess $+ %actboard *capt
  .hadd ichess $+ %actboard board RNBQKBNRPPPPPPPP00000000000000000000000000000000pppppppprnbqkbnr

  .constructboard $1
  .clearfieldmark
  .buildchessboard
  .showcaptures
  .titlebar %actboard $iif($1 == e,No game.,White's turn)
  .showbwturn
  .hadd ichess $+ %actboard wtime 0
  .hadd ichess $+ %actboard btime 0
  .hadd ichess $+ %actboard startmovetime $ticks
  .showchessclock %actboard
  .timer $+ %actboard 0 1 .showchessclock %actboard
  if (@Chess_@_* iswm %actboard) {
    .hadd ichess $+ %actboard owncolor $hget(ichess $+ %actboard,turn)
  }
}

alias -l buildtranspb {
  .window -phf @grrr -1 -1 $7 $8
  .drawcopy $1 $2 $3 $7 $8 @grrr 0 0
  .drawsave -b24 @grrr tmp1_ic_.bmp
  .drawcopy $4 $5 $6 $7 $8 @grrr 0 0
  .drawsave -b24 @grrr tmp2_ic_.bmp
  .window -c @grrr
  var %s = $dll($hget(ichess $+ %actboard,dll), tblit, tmp1_ic_.bmp tmp2_ic_.bmp $9)
  .drawpic $1 $2 $3 tblit.bmp
  .remove tmp1_ic_.bmp
  .remove tmp2_ic_.bmp
  .remove tblit.bmp
}

alias -l constructboard {
  var %startt = $ticks
  ; rows (1-8)
  var %j = 1
  while (%j <= 8) {
    ; columns (A-H)
    var %i = 1
    while (%i <= 8) {
      var %fiid = $fieldname(%i,%j)
      var %cbx = $iif($1 != b,$calc(%i - 1),$calc(8 - %i))
      var %cby = $iif($1 != b,$calc(8 - %j),$calc(%j - 1))
      .hadd ichess $+ %actboard coordsxy_ $+ %fiid $calc($hget(ichess $+ %actboard,fieldleft) + ($hget(ichess $+ %actboard,fielddims) - 1) * %cbx) $calc($hget(ichess $+ %actboard,fieldtop) + ($hget(ichess $+ %actboard,fielddims) - 1) * %cby)
      .hadd ichess $+ %actboard coords_ $+ $calc(%cbx + 1) $+ $calc(%cby + 1) %i $+ %j
      var %paintfield = $iif($calc((%i + %j) % 2) == 1,0,39) 
      .drawpic -csnm @temp2 $+ %actboard $hget(ichess $+ %actboard,coordsxy_ $+ %fiid) $hget(ichess $+ %actboard,fielddims) $hget(ichess $+ %actboard,fielddims) 0 %paintfield 40 40 " $+ $scriptdir $+ ichess_fields_ $+ $hget(ichess $+ %actboard,fieldset) $+ .bmp $+ "
      .inc %i
    }
    .inc %j
  }

  if ($hget(ichess $+ %actboard,boardbmp) != none) {
    .window -pnh @bptemp $+ %actboard -1 -1 500 500
    .drawpic -nsm @bptemp $+ %actboard 0 0 $calc($hget(ichess $+ %actboard,fielddims) * 8 - 7) $calc($hget(ichess $+ %actboard,fielddims) * 8 - 7) " $+ $scriptdir $+ ichess_boards_ $+ $hget(ichess $+ %actboard,boardbmp) $+ .bmp"
    .buildtranspb @temp2 $+ %actboard $hget(ichess $+ %actboard,fieldleft) $hget(ichess $+ %actboard,fieldtop) @bptemp $+ %actboard 1 1 $calc($hget(ichess $+ %actboard,fielddims) * 8 - 8) $calc($hget(ichess $+ %actboard,fielddims) * 8 - 8) $hget(ichess $+ %actboard,boardtransp)
    .window -c @bptemp $+ %actboard
  }
  .drawrect -fn %actboard 1 1 1 1 $calc($hget(ichess $+ %actboard,fieldright) + 12) $calc($hget(ichess $+ %actboard,fieldbottom) + 12)

  var %i = 1
  while (%i <= 8) {
    var %snum = $right($hget(ichess $+ %actboard,coords_ $+ 1 $+ %i),1)
    var %slet = $chr($calc($left($hget(ichess $+ %actboard,coords_ $+ %i $+ 1),1) + 64))
    .drawtext -onb %actboard 7 1 Comic 12 9 $calc($hget(ichess $+ %actboard,fieldtop) + (%i - 1 + 0.3) * ($hget(ichess $+ %actboard,fielddims) - 1)) %snum
    .drawtext -onb %actboard 7 1 Comic 12 $calc($hget(ichess $+ %actboard,fieldright) - 2) $calc($hget(ichess $+ %actboard,fieldtop) + (%i - 1 + 0.3) * ($hget(ichess $+ %actboard,fielddims) - 1)) %snum

    .drawtext -onb %actboard 7 1 Comic 12 $calc($hget(ichess $+ %actboard,fieldleft) + (%i - 1 + 0.4) * ($hget(ichess $+ %actboard,fielddims) - 1)) $calc($hget(ichess $+ %actboard,fieldtop) - 15) %slet
    .drawtext -onb %actboard 7 1 Comic 12 $calc($hget(ichess $+ %actboard,fieldleft) + (%i - 1 + 0.4) * ($hget(ichess $+ %actboard,fielddims) - 1)) $calc($hget(ichess $+ %actboard,fieldbottom) - 7) %slet

    .inc %i
  }
  ;  .echo -s $calc($ticks - %startt) ms
}

alias -l fieldname { return $chr($calc(64 + $1)) $+ $2 }

alias -l buildchessboard {
  var %startt = $ticks
  var %meh = $regex($hget(ichess $+ %actboard,board),/([KQRBNPkqrbnp0])/g)

  .drawcopy -n @temp2 $+ %actboard $hget(ichess $+ %actboard,fieldleft) $hget(ichess $+ %actboard,fieldtop) $calc($hget(ichess $+ %actboard,fielddims) * 8 - 5) $calc($hget(ichess $+ %actboard,fielddims) * 8 - 5) %actboard $hget(ichess $+ %actboard,fieldleft) $hget(ichess $+ %actboard,fieldtop)

  var %m = $numtok($hget(ichess $+ %actboard,mark1),32)
  while (%m) {
    var %markfield = $gettok($hget(ichess $+ %actboard,mark1),%m,32)
    var %markcolor = $gettok(%markfield,2,46)
    %markfield = $gettok(%markfield,1,46)
    var %paintfield = $gettok(39 78 117,%markcolor,32) $iif($calc(($asc($upper($left(%markfield,1))) + $right(%markfield,1)) % 2) == 1,0,39) 40 40
    .drawpic -csnm %actboard $hget(ichess $+ %actboard,coordsxy_ $+ %markfield) $hget(ichess $+ %actboard,fielddims) $hget(ichess $+ %actboard,fielddims) %paintfield " $+ $scriptdir $+ ichess_fields_ $+ $hget(ichess $+ %actboard,fieldset) $+ .bmp $+ "
    .dec %m
  }

  %m = $numtok($hget(ichess $+ %actboard,mark2),32)
  while (%m) {
    var %markfield = $gettok($hget(ichess $+ %actboard,mark2),%m,32)
    var %markcolor = $gettok(%markfield,2,46)
    %markfield = $gettok(%markfield,1,46)
    .drawrect -nr %actboard $gettok($rgb(0,250,0) $rgb(240,100,0) $rgb(0,100,240),%markcolor,32) 2 $hget(ichess $+ %actboard,coordsxy_ $+ %markfield) $hget(ichess $+ %actboard,fielddims) $hget(ichess $+ %actboard,fielddims)
    .dec %m
  }

  var %ff = 1
  var %j = 1
  while (%j <= 8) {
    var %i = 1
    while (%i <= 8) {
      var %fiid = $fieldname(%i,%j)
      var %piece = $regml(%ff)
      if (%piece != 0) {
        %piece = $iif($asc(%piece) & 32, b $+ %piece, w $+ %piece)
        .drawpic -csnt $+ $iif($hget(ichess $+ %actboard,fielddims) != 40,m) %actboard $rgb(0,0,255) $hget(ichess $+ %actboard,coordsxy_ $+ %fiid) $hget(ichess $+ %actboard,fielddims) $hget(ichess $+ %actboard,fielddims) $hget(ichess $+ %actboard,%piece) $hget(ichess $+ %actboard,piecebmp)
      }
      .inc %ff
      .inc %i
    }
    .inc %j
  }

  .drawdot %actboard
  ; .echo -s took: $calc($ticks - %startt) ms
}

alias -l getfieldposs { return $iif($asc($mid($hget(ichess $+ %actboard,board),$calc(($2 - 1) * 8 + $1),1)) & 32,b,w) }
alias -l getfieldpiece { return $mid($hget(ichess $+ %actboard,board),$calc(($2 - 1) * 8 + $1),1) }

alias -l validmoves {
  var %valids = $dll($hget(ichess $+ %actboard,dll),validmoves,$hget(ichess $+ %actboard,board) $1 $hget(ichess $+ %actboard,lastmove) $hget(ichess $+ %actboard,wmoved) $hget(ichess $+ %actboard,bmoved))
  return %valids
}

alias getallvalidmoves {
  var %valids = $dll($hget(ichess $+ %actboard,dll),getallvalidmoves,$hget(ichess $+ %actboard,board) $1 $hget(ichess $+ %actboard,lastmove) $hget(ichess $+ %actboard,wmoved) $hget(ichess $+ %actboard,bmoved))
  .echo -s %valids
}

alias getposrating {
  .echo -s $dll($hget(ichess $+ %actboard,dll),getposrating,$hget(ichess $+ %actboard,board) $hget(ichess $+ %actboard,turn) $hget(ichess $+ %actboard,lastmove) $hget(ichess $+ %actboard,wmoved) $hget(ichess $+ %actboard,bmoved))
}

alias -l cpuchessmove {
  %actboard = $1
  if (@Chess_@_* iswm $1) {
    .sockclose chesscpu $+ %actboard
    .timercpuchesstry $+ $1 5 5 .sockopen chesscpu $+ %actboard xor.ma.cx 80
  }
}

alias -l switchboardbackwards {
  var %outp, %hrm = $regsub($1,/(.{8})(.{8})(.{8})(.{8})(.{8})(.{8})(.{8})(.{8})/,\8\7\6\5\4\3\2\1,%outp)
  return %outp
}

on *:sockopen:chesscpu*: {
  if ($sockerr) { .echo -s 4 couldn't connect... | halt }
  var %ab = $right($sockname,-8)
  .timercpuchesstry $+ %ab off
  .sockwrite $sockname GET /getchessmove.php?whitenext= $+ $iif($hget(ichess $+ %ab,turn) == w,1,0) $+ &depth= $+ $hget(ichess $+ %ab,cpudepth) $+ &position= $+ $replace($switchboardbackwards($hget(ichess $+ %ab,board)),0,$chr(37) $+ 20) HTTP/1.0 $+ $crlf
  .sockwrite $sockname Connection: Keep-Alive $+ $crlf
  .sockwrite $sockname Host: xor.ma.cx $+ $crlf $+ $crlf
}

on *:sockread:chesscpu*: {
  var %lr
  if (!$sock($sockname).mark) {
    .sockread %lr
    if (!%lr) { .sockmark $sockname 1 }
  }
  else {
    .sockread %lr
    ;    .echo -s - %lr
    if ($regex($upper(%lr),/([A-Z][0-9])([A-Z][0-9])(.?) (.+)/)) {
      if ($regml(3)) { .hadd ichess $+ %actboard tradepawn $regml(3) }
      %actboard = $right($sockname,-8)
      .chessmove $regml(1) $regml(2) other $calc($hget(ichess $+ %actboard,$hget(ichess $+ %actboard,turn) $+ time) + $ticks - $hget(ichess $+ %actboard,startmovetime))
      if (* 1 iswm $hget(ichess $+ %actboard,beepmode)) { .beep }
      .sockclose $sockname
    }
  }
}

on *:sockclose:chesscpu*: {
  .echo -s 4socket closed..
}

alias -l dangermoves {
  var %dangers = $dll($hget(ichess $+ %actboard,dll),dangermoves,$hget(ichess $+ %actboard,board) $1)
  return %dangers
}

alias -l is_a_mate {
  return $dll($hget(ichess $+ %actboard,dll),gameover,$hget(ichess $+ %actboard,board) $1 $hget(ichess $+ %actboard,lastmove) $hget(ichess $+ %actboard,wmoved) $hget(ichess $+ %actboard,bmoved))
}

alias getattackers {
  return $dll($hget(ichess $+ %actboard,dll),getattackers,$hget(ichess $+ %actboard,board) $1)
}

alias -l showvalidmoves {
  .clearfieldmark
  var %nypos = $right($1,1),%nxpos = $calc($asc($upper($left($1,1))) - 64)
  var %clickedfcol = $getfieldposs(%nxpos,%nypos)
  .hadd ichess $+ %actboard mark2 $1 $+ . $+ $iif(%clickedfcol == $hget(ichess $+ %actboard,owncolor),1,2)
  var %vmoves = $validmoves($1)
  var %i = $numtok(%vmoves,32)
  while (%i && $hget(ichess $+ %actboard,showvalidmoves)) {
    var %actfield = $gettok(%vmoves,%i,32)
    .hadd ichess $+ %actboard mark1 $hget(ichess $+ %actboard,mark1) %actfield $+ . $+ $iif(%clickedfcol == $hget(ichess $+ %actboard,owncolor),1,2)
    .dec %i
  }
  .buildchessboard
  .hadd ichess $+ %actboard curvalidmoves %vmoves
}

alias -l showdangermoves {
  .clearfieldmark
  .hadd ichess $+ %actboard mark2 $hget(ichess $+ %actboard,mark2) $1 $+ .2
  var %nypos = $right($1,1), %nxpos = $calc($asc($upper($left($1,1))) - 64)
  var %owncolor = $getfieldposs(%nxpos,%nypos)
  var %vmoves = $dangermoves($1)
  var %i = $numtok(%vmoves,32)
  while (%i) {
    var %actfield = $gettok(%vmoves,%i,32)
    %nypos = $right(%actfield,1)
    %nxpos = $calc($asc($upper($left(%actfield,1))) - 64)
    .hadd ichess $+ %actboard mark1 $hget(ichess $+ %actboard,mark1) %actfield $+ . $+ $iif($getfieldposs(%nxpos,%nypos) == %owncolor,1,2)
    .dec %i
  }
  .buildchessboard
}

alias -l boardpos { return $calc(($2 - 1) * 8 + $1) }
alias -l _getpiece { return $mid($hget(ichess $+ %actboard,board),$boardpos($calc($asc($upper($left($1,1))) - 64),$right($1,1)),1) }
alias -l getpiece { return $mid($hget(ichess $+ %actboard,board),$boardpos($1,$2),1) }
alias -l putpiece {
  var %oldb = $hget($1,board), %pppos = $boardpos($2,$3)
  .hadd $1 board $left(%oldb,$calc(%pppos - 1)) $+ $4 $+ $right(%oldb,$calc(64 - %pppos))
}

alias -l chessmove {
  var %nypos = $right($1,1),%nxpos = $calc($asc($upper($left($1,1))) - 64)
  var %nypos2 = $right($2,1),%nxpos2 = $calc($asc($upper($left($2,1))) - 64)
  var %mehgone = $getpiece(%nxpos2,%nypos2)
  var %mehpiece = $getpiece(%nxpos,%nypos)

  ;en passant
  if (%nxpos != %nxpos2 && %nypos != %nypos2 && $getfieldpiece(%nxpos2,%nypos2) == 0 && $getfieldpiece(%nxpos,%nypos) == p && $getfieldpiece(%nxpos2,%nypos) == p) {
    %mehgone = $getpiece(%nxpos2,%nypos)
    .putpiece ichess $+ %actboard %nxpos2 %nypos 0
  }

  .hadd ichess $+ %actboard lastcapture %mehgone
  if (%mehgone != 0) {
    var %mehname = $iif($asc(%mehgone) & 32,b,w) $+ capt
    .hadd ichess $+ %actboard %mehname $hget(ichess $+ %actboard,%mehname) %mehgone
  }

  ;castling
  if (%mehpiece === K && $1 $2 == E1 G1) {
    .putpiece ichess $+ %actboard 6 1 R
    .putpiece ichess $+ %actboard 8 1 0
    .hadd ichess $+ %actboard wmoved 2 $+ $right($hget(ichess $+ %actboard,wmoved),2)
  }
  else if (%mehpiece === K && $1 $2 == E1 C1) {
    .putpiece ichess $+ %actboard 4 1 R
    .putpiece ichess $+ %actboard 1 1 0
    .hadd ichess $+ %actboard wmoved 2 $+ $right($hget(ichess $+ %actboard,wmoved),2)
  }
  else if (%mehpiece === k && $1 $2 == E8 G8) {
    .putpiece ichess $+ %actboard 6 8 r
    .putpiece ichess $+ %actboard 8 8 0
    .hadd ichess $+ %actboard bmoved 2 $+ $right($hget(ichess $+ %actboard,bmoved),2)
  }
  else if (%mehpiece === k && $1 $2 == E8 C8) {
    .putpiece ichess $+ %actboard 4 8 r
    .putpiece ichess $+ %actboard 1 8 0
    .hadd ichess $+ %actboard bmoved 2 $+ $right($hget(ichess $+ %actboard,bmoved),2)
  }

  .putpiece ichess $+ %actboard %nxpos2 %nypos2 %mehpiece
  .putpiece ichess $+ %actboard %nxpos %nypos 0

  .clearfieldmark
  var %movedcolor = $iif($asc(%mehpiece) & 32,b,w)
  var %mcol = $iif(%movedcolor == $hget(ichess $+ %actboard,owncolor),1,2)
  .hadd ichess $+ %actboard mark1 $hget(ichess $+ %actboard,mark1) $1 $+ . $+ %mcol
  .hadd ichess $+ %actboard mark2 $hget(ichess $+ %actboard,mark2) $2 $+ . $+ %mcol

  if (%mehpiece == k) {
    .hadd ichess $+ %actboard %movedcolor $+ kingpos $2
    if (0* iswm $hget(ichess $+ %actboard,%movedcolor $+ moved)) {
      .hadd ichess $+ %actboard %movedcolor $+ moved 1 $+ $right($hget(ichess $+ %actboard,%movedcolor $+ moved),2)
    }
  }
  else if (%mehpiece === R) {
    if ($2 == A1) {
      .hadd ichess $+ %actboard wmoved $left($hget(ichess $+ %actboard,wmoved),1) $+ 1 $+ $right($hget(ichess $+ %actboard,wmoved),1)
    }
    else if ($2 == H1) {
      .hadd ichess $+ %actboard wmoved $left($hget(ichess $+ %actboard,wmoved),2) $+ 1
    }
  }
  else if (%mehpiece === r) {
    if ($2 == A8) {
      .hadd ichess $+ %actboard bmoved $left($hget(ichess $+ %actboard,bmoved),1) $+ 1 $+ $right($hget(ichess $+ %actboard,bmoved),1)
    }
    else if ($2 == H8) {
      .hadd ichess $+ %actboard bmoved $left($hget(ichess $+ %actboard,bmoved),2) $+ 1
    }
  }

  .hadd ichess $+ %actboard turn $iif($hget(ichess $+ %actboard,turn) == w,b,w)
  if (@Chess_@_* iswm %actboard) {
    .hadd ichess $+ %actboard owncolor $hget(ichess $+ %actboard,turn)
  }
  if ($3 != other) {
    .hadd ichess $+ %actboard %movedcolor $+ time $calc($hget(ichess $+ %actboard,%movedcolor $+ time) + $ticks - $hget(ichess $+ %actboard,startmovetime))
  }
  else {
    .hadd ichess $+ %actboard %movedcolor $+ time $4
  }
  .hadd ichess $+ %actboard lastmove $1 $2
  .hadd ichess $+ %actboard startmovetime $ticks

  if ($hget(ichess $+ %actboard,tradepawn)) {
    var %tpp = $hget(ichess $+ %actboard,tradepawn)
    if (%tpp isnum) { %tpp = $gettok(p n b r q,%tpp,32) }
    .putpiece ichess $+ %actboard %nxpos2 %nypos2 $iif(%movedcolor == w, $upper(%tpp), $lower(%tpp))
  }

  .savechessboard

  .hadd ichess $+ %actboard moves $calc($hget(ichess $+ %actboard,moves) + 1) 

  var %attackers = $getattackers($hget(ichess $+ %actboard,$iif(%movedcolor == w,b,w) $+ kingpos)),%i = $numtok(%attackers,32)
  if (%i) {
    .hadd ichess $+ %actboard mark1 $hget(ichess $+ %actboard,mark1) $hget(ichess $+ %actboard,$iif(%movedcolor == w,b,w) $+ kingpos) $+ . $+ 2
  }

  while (%i) {
    .hadd ichess $+ %actboard mark1 $hget(ichess $+ %actboard,mark1) $gettok(%attackers,%i,32) $+ . $+ 2
    .dec %i
  }

  var %ismate = 0, %isstalemate = 0
  var %hrmf = $is_a_mate($iif(%movedcolor == w,b,w))
  if (%hrmf == checkmate) { %ismate = 1 }
  else if (%hrmf == stalemate) { %isstalemate = 1 }

  if ($hget(ichess $+ %actboard,turn) == b) {
    var %lastlline = $line(%actboard,0,1)
    var %linetoadd = %lastlline $+ : $iif(%ismate || %attackers,4) $+ $upper($1 $+ - $+ $2) $iif($hget(ichess $+ %actboard,tradepawn),$ifmatch) $iif(%ismate,†,$iif(%attackers,+))
    .aline -l 14 %actboard %linetoadd
  }
  else {
    var %lastlline = $line(%actboard,0,1)
    var %linetoadd = $line(%actboard,%lastlline,1) $chr(160) $+ $iif(%ismate || %attackers,4,14) $+ $upper($1 $+ - $+ $2) $iif($hget(ichess $+ %actboard,tradepawn),$ifmatch) $iif(%ismate,†,$iif(%attackers,+))
    .rline -l 14 %actboard %lastlline %linetoadd
  }

  .sline -l %actboard $line(%actboard,0,1)

  .buildchessboard
  .showbwturn
  if ($hget(ichess $+ %actboard,lastcapture) != 0) {
    .showcaptures
  }

  if ($3 != other) {
    .chess_send MOVE $1 $2 $hget(ichess $+ %actboard,%movedcolor $+ time) $hget(ichess $+ %actboard,tradepawn)
  }
  .hdel ichess $+ %actboard tradepawn
  .titlebar %actboard Last move: $1 - $2 $iif(%attackers,Check!) $iif($hget(ichess $+ %actboard,turn) == w,White,Black) $+ 's turn
  .hadd ichess $+ %actboard curfield meh

  if (%ismate) { .chessgameover $iif($hget(ichess $+ %actboard,turn) == $hget(ichess $+ %actboard,owncolor),you,opp) checkmate }
  else if (%isstalemate) { .chessgameover $iif($hget(ichess $+ %actboard,turn) == $hget(ichess $+ %actboard,owncolor),you,opp) stalemate }

  if (!$timer(%actboard)) { .timer $+ %actboard 0 1 .showchessclock %actboard }
  if ($hget(ichess $+ %actboard,$hget(ichess $+ %actboard,turn) $+ playername) == @RCPU) { .cpuchessmove %actboard }
}

alias -l clearfieldmark {
  .hdel ichess $+ %actboard mark1
  .hdel ichess $+ %actboard mark2
}

alias -l pawntradewindow {
  .window -pdBChfo +fL @choosepawntrade $+ %actboard 1 1 322 106
  .drawtext -o @choosepawntrade $+ %actboard 7 Comic 20 111 2 Promote:
  .drawrect -f @choosepawntrade $+ %actboard 14 0 1 25 320 105
  .drawpic -ts @choosepawntrade $+ %actboard $rgb(0,0,255) 2 25 320 80 $iif($hget(ichess $+ %actboard,owncolor) == b,40 0 160 40,40 40 160 40) $hget(ichess $+ %actboard,piecebmp)
}

menu @choosepawntrade* {
  dclick: {
    if ($mouse.x isnum 1-320 && $mouse.y isnum 23-105) {
      .hadd ichess $+ $remove($active,@choosepawntrade) tradepawn $int($calc($mouse.x / 80 + 2))
      $hget(ichess $+ $remove($active,@choosepawntrade),tradepawnmove)
      .hdel ichess $+ $remove($active,@choosepawntrade) tradepawnmove
      .close -@ $active
    }
  }
}

alias -l chessmouseactivity {
  %actboard = $1
  if ($5 == drag && $2 isnum $hget(ichess $+ %actboard,fieldleft) $+ - $+ $hget(ichess $+ %actboard,fieldright) && $3 isnum $hget(ichess $+ %actboard,fieldtop) $+ - $+ $hget(ichess $+ %actboard,fieldbottom)) {
    var %checkxp = $int($calc(1 + ($2 - $hget(ichess $+ %actboard,fieldleft)) / $hget(ichess $+ %actboard,fielddims)))
    var %checkyp = $int($calc(1 + ($3 - $hget(ichess $+ %actboard,fieldtop)) / $hget(ichess $+ %actboard,fielddims)))
    var %foundit = $hget(ichess $+ %actboard,coords_ $+ %checkxp $+ %checkyp)
    var %clickedfield = $chr($calc($left(%foundit,1) + 64)) $+ $right(%foundit,1)
    var %i = $left(%foundit,1), %j = $right(%foundit,1)
    if ($hget(ichess $+ %actboard,curfield) != %clickedfield) { .showvalidmoves %clickedfield }
    .hadd ichess $+ %actboard curfield %clickedfield
    .hadd ichess $+ %actboard curpiece $getpiece(%i,%j)

    if ($hget(ichess $+ %actboard,turn) == $hget(ichess $+ %actboard,owncolor) && $getfieldpiece(%i,%j) != 0 && $getfieldposs(%i,%j) == $hget(ichess $+ %actboard,owncolor)) {
      .hadd ichess $+ %actboard dragging 1
      .hadd ichess $+ %actboard lastmx $mouse.x
      .hadd ichess $+ %actboard lastmy $mouse.y
      var %fiid = $fieldname(%i,%j)
      var %paintfield = 0 $iif($calc((%i + %j) % 2) == 1,0,39) 40 40
      .drawcopy -csnm @temp2 $+ %actboard $hget(ichess $+ %actboard,coordsxy_ $+ %fiid) $hget(ichess $+ %actboard,fielddims) $hget(ichess $+ %actboard,fielddims) %actboard $hget(ichess $+ %actboard,coordsxy_ $+ %fiid)
      if ($wildtok($hget(ichess $+ %actboard,mark2), %fiid $+ *, 0, 32)) {
        .drawrect -nr %actboard $iif($gettok($ifmatch,2,46) == 1,$rgb(0,250,0),$rgb(240,100,0)) 2 $hget(ichess $+ %actboard,coordsxy_ $+ %fiid) $hget(ichess $+ %actboard,fielddims) $hget(ichess $+ %actboard,fielddims)
      }
      ; save original
      .drawcopy %actboard $int($calc($hget(ichess $+ %actboard,lastmx) - $hget(ichess $+ %actboard,fielddims) / 2)) $int($calc($hget(ichess $+ %actboard,lastmy) - $hget(ichess $+ %actboard,fielddims) / 2)) $calc($hget(ichess $+ %actboard,fielddims) * 2) $calc($hget(ichess $+ %actboard,fielddims) * 2) @temp2 $+ %actboard 1 450
      ; put piece
      .drawpic -csnt $+ $iif($hget(ichess $+ %actboard,fielddims) != 40,m) %actboard $rgb(0,0,255) $calc($mouse.x - $hget(ichess $+ %actboard,fielddims) / 2) $calc($hget(ichess $+ %actboard,lastmy) - $hget(ichess $+ %actboard,fielddims) / 2) $hget(ichess $+ %actboard,fielddims) $hget(ichess $+ %actboard,fielddims) $hget(ichess $+ %actboard,$getfieldposs(%i,%j) $+ $getpiece(%i,%j)) $hget(ichess $+ %actboard,piecebmp)
      .drawdot %actboard
    }
    else {
      .hadd ichess $+ %actboard dragging 0
    }
  }
  else if ($5 == drop) {
    .drawcopy -n @temp2 $+ %actboard 1 450 $calc($hget(ichess $+ %actboard,fielddims) * 2) $calc($hget(ichess $+ %actboard,fielddims) * 2) %actboard $int($calc($hget(ichess $+ %actboard,lastmx) - $hget(ichess $+ %actboard,fielddims) / 2)) $int($calc($hget(ichess $+ %actboard,lastmy) - $hget(ichess $+ %actboard,fielddims) / 2))
    if ($2 isnum $hget(ichess $+ %actboard,fieldleft) $+ - $+ $hget(ichess $+ %actboard,fieldright) && $3 isnum $hget(ichess $+ %actboard,fieldtop) $+ - $+ $hget(ichess $+ %actboard,fieldbottom)) {
      var %checkxp = $int($calc(1 + ($2 - $hget(ichess $+ %actboard,fieldleft)) / $hget(ichess $+ %actboard,fielddims)))
      var %checkyp = $int($calc(1 + ($3 - $hget(ichess $+ %actboard,fieldtop)) / $hget(ichess $+ %actboard,fielddims)))
      var %foundit = $hget(ichess $+ %actboard,coords_ $+ %checkxp $+ %checkyp)
      var %clickedfield = $chr($calc($left(%foundit,1) + 64)) $+ $right(%foundit,1)
      if ($istok($hget(ichess $+ %actboard,curvalidmoves),%clickedfield,32) && $iif($asc($hget(ichess $+ %actboard,curpiece)) & 32,b,w) == $hget(ichess $+ %actboard,turn)) {
        if (($hget(ichess $+ %actboard,curpiece) === P && *8 iswm %clickedfield) || ($hget(ichess $+ %actboard,curpiece) === p && *1 iswm %clickedfield)) {
          .hadd ichess $+ %actboard tradepawnmove .chessmove $hget(ichess $+ %actboard,curfield) %clickedfield
          .pawntradewindow
        }
        else {
          .chessmove $hget(ichess $+ %actboard,curfield) %clickedfield
        }
        .hdel ichess $+ %actboard curvalidmoves
      }
    }
    .buildchessboard
  }
  else if ($5 == single && $2 isnum $hget(ichess $+ %actboard,fieldleft) $+ - $+ $hget(ichess $+ %actboard,fieldright) && $3 isnum $hget(ichess $+ %actboard,fieldtop) $+ - $+ $hget(ichess $+ %actboard,fieldbottom)) {
    var %checkxp = $int($calc(1 + ($2 - $hget(ichess $+ %actboard,fieldleft)) / $hget(ichess $+ %actboard,fielddims)))
    var %checkyp = $int($calc(1 + ($3 - $hget(ichess $+ %actboard,fieldtop)) / $hget(ichess $+ %actboard,fielddims)))
    var %foundit = $hget(ichess $+ %actboard,coords_ $+ %checkxp $+ %checkyp)
    var %clickedfield = $chr($calc($left(%foundit,1) + 64)) $+ $right(%foundit,1)
    if ($hget(ichess $+ %actboard,curfield) == %clickedfield) { return }
    if ($hget(ichess $+ %actboard,allowsingleclickmoves) && $istok($hget(ichess $+ %actboard,curvalidmoves),%clickedfield,32) && $str($left($hget(ichess $+ %actboard,curpiece),1),2) == $hget(ichess $+ %actboard,turn) $+ $hget(ichess $+ %actboard,owncolor)) {
      if (($hget(ichess $+ %actboard,curpiece) == w1 && *8 iswm %clickedfield) || ($hget(ichess $+ %actboard,curpiece) == b1 && *1 iswm %clickedfield)) {
        .hadd ichess $+ %actboard tradepawnmove .chessmove $hget(ichess $+ %actboard,curfield) %clickedfield
        .pawntradewindow
        halt
      }
      else {
        .chessmove $hget(ichess $+ %actboard,curfield) %clickedfield
      }
      .hdel ichess $+ %actboard curvalidmoves
    }
    else if ($getfieldpiece($left(%foundit,1),$right(%foundit,1)) != 0) {
      .hadd ichess $+ %actboard curfield %clickedfield
      .hadd ichess $+ %actboard curpiece $_getpiece(%clickedfield)
      .showvalidmoves %clickedfield
    }
  }
  else if ($5 == double && $2 isnum $hget(ichess $+ %actboard,fieldleft) $+ - $+ $hget(ichess $+ %actboard,fieldright) && $3 isnum $hget(ichess $+ %actboard,fieldtop) $+ - $+ $hget(ichess $+ %actboard,fieldbottom)) {
    var %checkxp = $int($calc(1 + ($2 - $hget(ichess $+ %actboard,fieldleft)) / $hget(ichess $+ %actboard,fielddims)))
    var %checkyp = $int($calc(1 + ($3 - $hget(ichess $+ %actboard,fieldtop)) / $hget(ichess $+ %actboard,fielddims)))
    var %foundit = $hget(ichess $+ %actboard,coords_ $+ %checkxp $+ %checkyp)
    var %clickedfield = $chr($calc($left(%foundit,1) + 64)) $+ $right(%foundit,1)
    .hadd ichess $+ %actboard curfield %clickedfield
    .hadd ichess $+ %actboard curpiece $_getpiece(%clickedfield)
    .showdangermoves $chr($calc($left(%foundit,1) + 64)) $+ $right(%foundit,1)
  }
}

alias -l boardclicked {
  if ($mouse.key & 1) {
    .chessmouseactivity $1 $2 $3 $4 drag
  }
  else {
    .timersingleclick -m 1 150 .chessmouseactivity $1 $2 $3 $4 $5
  }
}

alias -l newpieceset {
  .writeini " $+ $scriptdir $+ ichess.ini $+ " settings pieceset $2
  .hadd ichess $+ $1 pieceset $2
  .hadd ichess $+ $1 piecebmp " $+ $scriptdir $+ ichess_pieces_ $+ $hget(ichess $+ $1,pieceset) $+ .bmp $+ "
  .buildchessboard
  .showcaptures
}

alias -l piecesets {
  if ($1 == begin || $1 == end) { return - }
  if ($1 <= $findfile($scriptdir,ichess_pieces_*.bmp,0)) {
    %actboard = $active
    var %psetname = $remove($nopath($findfile($scriptdir,ichess_pieces_*.bmp,$1)),ichess_pieces_,.bmp)
    return $iif($hget(ichess $+ %actboard,pieceset) == %psetname,$style(1),$style(0)) %psetname $+ : .newpieceset %actboard %psetname
  }
}

alias -l newfieldset {
  .writeini " $+ $scriptdir $+ ichess.ini $+ " settings fieldset $2
  .hadd ichess $+ $1 fieldset $2
  .constructboard
  .buildchessboard
}

alias -l fieldsets {
  if ($1 == begin || $1 == end) { return - }
  if ($1 <= $findfile($scriptdir,ichess_fields_*.bmp,0)) {
    %actboard = $active
    var %fsetname = $remove($nopath($findfile($scriptdir,ichess_fields_*.bmp,$1)),ichess_fields_,.bmp)
    return $iif($hget(ichess $+ %actboard,fieldset) == %fsetname,$style(1),$style(0)) %fsetname $+ : .newfieldset %actboard %fsetname
  }
}

alias -l newboardbitmap {
  .writeini " $+ $scriptdir $+ ichess.ini $+ " settings boardbmp $2
  .hadd ichess $+ $1 boardbmp $2
  .constructboard
  .buildchessboard
}

alias -l boardbitmaps {
  var %bfname
  if ($1 == begin || $1 == end) { return - }
  if ($calc($1 - 1) <= $findfile($scriptdir,ichess_boards_*.bmp,0)) {
    %actboard = $active
    if ($1 == 1) { %bfname = none }
    else { %bfname = $remove($nopath($findfile($scriptdir,ichess_boards_*.bmp,$calc($1 - 1))),ichess_boards_,.bmp) }
    return $iif($hget(ichess $+ %actboard,boardbmp) == %bfname,$style(1),$style(0)) %bfname $+ : .newboardbitmap %actboard %bfname
  }
}

alias -l changeboardbmptransps {
  %actboard = $1
  .writeini " $+ $scriptdir $+ ichess.ini $+ " settings boardtransp $2
  .hadd ichess $+ %actboard boardtransp $2 
  .constructboard 
  .buildchessboard 
}

alias -l boardbmptransps {
  %actboard = $active
  if ($1 == begin || $1 == end) { return - }
  if ($1 isnum 1-9) {
    return $iif($hget(ichess $+ %actboard,boardtransp) == $1 $+ 0,$style(1),$style(0)) $1 $+ 0%: .changeboardbmptransps %actboard $1 $+ 0 
  }
}

alias -l formatchesstime {
  return $asctime($calc($1 + $timezone),HH:nn:ss)
}

alias -l newchessgamemenu {
  if ($1 == begin || $1 == end) { return - }
  %actboard = $active
  if ($hfind(ichess $+ %actboard,users*,$1,w)) {
    var %onamer = $ifmatch
    return $replace($right(%onamer,-5) $hget(ichess $+ %actboard,%onamer),$chr(123),_,$chr(125),_,:,) : .requestichessgame $right(%onamer,-5) $2
  }
  else if (@Chess_@_* iswm %actboard && $1 == $calc($hfind(ichess $+ %actboard,users*,0,w) + 1)) {
    return RCPU $hget(ichess $+ %actboard,cpudepth) : .requestichessgame @RCPU $2
  }
}

alias -l requestichessgame {
  %actboard = $active
  .addtochesschat 7* You request a new game with $1 $+ . $iif($2 == white,playing White,$iif($2 == black,playing Black,Random Sides))
  if ($1 != @RCPU) {
    .chess_send NEWGAMEREQ $1 $hget(ichess $+ %actboard,me) $iif($2 == white,w w,$iif($2 == black,b b,r $iif($rand(1,100) < 51,w,b)))
  }
  else {
    .handlechessprotocol ACCEPT_NG $hget(ichess $+ %actboard,me) @RCPU $iif($2 == white,w,$iif($2 == black,b,$iif($rand(1,100) < 51,w,b)))
  }
}

alias -l loadchessgamemenu {
  if ($1 == begin || $1 == end) { return - }
  %actboard = $active
  if ($hfind(ichess $+ %actboard,users*,$1,w)) {
    var %onamer = $ifmatch
    return $replace($right(%onamer,-5) $hget(ichess $+ %actboard,%onamer),$chr(123),_,$chr(125),_,:,) : .requestloadichessgame $right(%onamer,-5) $2
  }
  else if (@Chess_@_* iswm %actboard && $1 == $calc($hfind(ichess $+ %actboard,users*,0,w) + 1)) {
    return RCPU $hget(ichess $+ %actboard,cpudepth) : .requestloadichessgame @RCPU
  }
}

alias -l requestloadichessgame {
  %actboard = $active
  if ($sfile($scriptdir $+ ichess_save\*.txt,Load Game..,Load)) {
    var %lfn = " $+ $ifmatch $+ "
    if (!$exists(%lfn)) { halt }
    var %side = $iif($?!="You play White?",w,b)
    .hadd ichess $+ %actboard loadgamefn %lfn
    .addtochesschat 7* You request to load a game and play with $1 $+ .
    if ($1 != @RCPU) {
      .chess_send LOADGAMEREQ $1 $hget(ichess $+ %actboard,me) %side
    }
    else {
      .handlechessprotocol ACCEPT_LG $hget(ichess $+ %actboard,me) @RCPU %side
    }
  }
}

alias -l continuechessgamemenu {
  if ($1 == begin || $1 == end) { return - }
  %actboard = $active
  if ($hfind(ichess $+ %actboard,users*,$1,w)) {
    var %onamer = $ifmatch
    return $replace($right(%onamer,-5) $hget(ichess $+ %actboard,%onamer),$chr(123),_,$chr(125),_,:,) : .requestichesscontinue $right(%onamer,-5)
  }
}

alias -l requestichesscontinue {
  .addtochesschat 7* You request to continue the game with $1 $+ .
  .chess_send CONTGAMEREQ $1 $hget(ichess $+ %actboard,me) $iif($hget(ichess $+ %actboard,owncolor) == b,w,b)
}

alias -l hostnickmenu {
  if ($1 == begin || $1 == end) { return - }
  %actboard = $active
  if ($sock(%actboard $+ *,$1)) {
    var %onamer = $ifmatch
    return $replace($sock(%onamer).mark,$chr(123),_,$chr(125),_,:,) : .chess $+ $2 $+ nick %onamer %actboard
  }
}

alias -l hostunbanmenu {
  if ($1 == begin || $1 == end) { return - }
  %actboard = $active
  if ($hfind(ichess $+ %actboard,banlist*,$1,w)) {
    var %blentry = $right($ifmatch,-7)
    return %blentry : .hdel ichess $+ %actboard banlist $+ %blentry
  }
}

alias -l chesskicknick {
  if ($?="Kick reason?") {
    %actboard = $2
    var %kreason = $ifmatch, %knick = $gettok($sock($1).mark,1,32)
    if (%knick) {
      .chess_send KICK $hget(ichess $+ %actboard,me) %knick %kreason
      .addtochesschat 7* You kicked4 %knick 7( $+ %kreason $+ )
      .hdel ichess $+ %actboard users $+ %knick
      .sockclose $1
    }
  }
}

alias -l chessbannick {
  %actboard = $2
  if ($input(Enter the IP-mask to be banned:,e,Ban,$sock($1).ip)) {
    var %bmask = $ifmatch
    if (%bmask) {
      .addtochesschat 7* You banned4 %bmask
      .hadd ichess $+ %actboard banlist $+ %bmask 1
    }
  }
}

menu @chess* {
  mouse: {
    %actboard = $active
    if ($hget(ichess $+ %actboard,dragging) && ($abs($calc($mouse.x - $hget(ichess $+ %actboard,lastmx))) > 5 || $abs($calc($mouse.y - $hget(ichess $+ %actboard,lastmy))) > 5)) {
      var %piece = $_getpiece($hget(ichess $+ %actboard,curfield))
      %piece = $iif($asc(%piece) & 32, b, w) $+ %piece
      ; restore:
      .drawcopy -n @temp2 $+ %actboard 1 450 $calc($hget(ichess $+ %actboard,fielddims) * 2) $calc($hget(ichess $+ %actboard,fielddims) * 2) %actboard $int($calc($hget(ichess $+ %actboard,lastmx) - $hget(ichess $+ %actboard,fielddims) / 2)) $int($calc($hget(ichess $+ %actboard,lastmy) - $hget(ichess $+ %actboard,fielddims) / 2))
      ; movepiece:
      .drawcopy %actboard $int($calc($mouse.x - $hget(ichess $+ %actboard,fielddims) / 2)) $int($calc($mouse.y - $hget(ichess $+ %actboard,fielddims) / 2)) $calc($hget(ichess $+ %actboard,fielddims) * 2) $calc($hget(ichess $+ %actboard,fielddims) * 2) @temp2 $+ %actboard 1 450
      .drawpic -csnt $+ $iif($hget(ichess $+ %actboard,fielddims) != 40,m) %actboard $rgb(0,0,255) $calc($mouse.x - $hget(ichess $+ %actboard,fielddims) / 2) $calc($mouse.y - $hget(ichess $+ %actboard,fielddims) / 2) $hget(ichess $+ %actboard,fielddims) $hget(ichess $+ %actboard,fielddims) $hget(ichess $+ %actboard,%piece) $hget(ichess $+ %actboard,piecebmp)
      .hadd ichess $+ %actboard lastmx $mouse.x
      .hadd ichess $+ %actboard lastmy $mouse.y
      .drawdot %actboard
    }
    else if ($mouse.key & 1) {
      var %mx = $mouse.x, %my = $mouse.y
      if (%my isnum $calc($hget(ichess $+ %actboard,upy) + 20) $+ - $+ $calc($hget(ichess $+ %actboard,downy) - 1) && %mx isnum $calc($hget(ichess $+ %actboard,upx) + 1) $+ - $+ $calc($hget(ichess $+ %actboard,upx) + 19)) {
        var %alllines = $iif(6.03 <= $version,$hfind(ichess $+ %actboard,chatting*,0,w),$hmatch(ichess $+ %actboard,chatting*,0))
        if (%alllines == 0) { %alllines = 1 }
        var %barlength = $calc($hget(ichess $+ %actboard,downy) - $hget(ichess $+ %actboard,upy) - 20)
        var %sliderlength = $iif($calc($calc(%barlength / %alllines)) < 10,10,$ifmatch)
        var %linepointer = $round($calc((%alllines - 1) * (%my - $hget(ichess $+ %actboard,upy) - 20 - %sliderlength / 2) / (%barlength - %sliderlength) + 1),0)
        if (%linepointer < 1) { %linepointer = 1 }
        else if (%linepointer > %alllines) { %linepointer = %alllines }
        .hadd ichess $+ %actboard linepointer %linepointer
        .showchesschat
      }
    }
  }
  drop: {
    if ($hget(ichess $+ %actboard,dragging)) {
      .hadd ichess $+ $active dragging 0
      .chessmouseactivity $active $mouse.x $mouse.y $mouse.key drop
    }
  }
  sclick: {
    %actboard = $active
    if ($mouse.x isnum $hget(ichess $+ %actboard,upx) $+ - $+ $calc($hget(ichess $+ %actboard,upx) + 20) && $mouse.y isnum $hget(ichess $+ %actboard,upy) $+ - $+ $calc($hget(ichess $+ %actboard,upy) + 20)) {
      .hadd ichess $+ %actboard linepointer $calc($hget(ichess $+ %actboard,linepointer) - 1)
      if ($hget(ichess $+ %actboard,linepointer) < 1) {
        .hadd ichess $+ %actboard linepointer 1
      }
      .showchesschat
    }
    else if ($mouse.x isnum $hget(ichess $+ %actboard,downx) $+ - $+ $calc($hget(ichess $+ %actboard,downx) + 20) && $mouse.y isnum $hget(ichess $+ %actboard,downy) $+ - $+ $calc($hget(ichess $+ %actboard,downy) + 20)) {
      .hadd ichess $+ %actboard linepointer $calc($hget(ichess $+ %actboard,linepointer) + 1) 

      if ($iif(6.03 <= $version,$hfind(ichess $+ %actboard,chatting*,0,w),$hmatch(ichess $+ %actboard,chatting*,0)) < $hget(ichess $+ %actboard,linepointer)) {
        .hadd ichess $+ %actboard linepointer $ifmatch
      }
      .showchesschat
    }
    else {
      .timer -m 1 150 .boardclicked $active $mouse.x $mouse.y $mouse.key single
    }
  }
  dclick: {
    if (!$mouse.lb) {
      .timersingleclick off
      .chessmouseactivity $active $mouse.x $mouse.y $mouse.key double
    }
    else {
      %actboard = $active
      if ($hget(ichess $+ %actboard,owncolor) != e) {
        var %selline = $strip($sline($active,1))
        if (Start:* !iswm %selline && *: * iswm %selline && $hget(ichess $+ %actboard,allowundo)) {
          var %move_n = $calc($gettok(%selline,1,$asc(:)) * 2 - $iif($hget(ichess $+ %actboard,owncolor) == b,1,0))
          var %lastvmove = $iif($hget(ichess $+ %actboard,owncolor) == w,%selline,$gettok(%selline,1,160))
          if (%move_n < $hget(ichess $+ %actboard,moves)) {
            .addtochesschat 7* You request to undo all moves after 15[ $+ %lastvmove $+ 15].
            .chess_send UNDOREQ $hget(ichess $+ %actboard,me) %move_n %lastvmove
          }
        }
      }
    }
  }
  $iif(e* iswm $hget(ichess $+ $active,turn),$style(2),$style(0)) ECO: {
    %actboard = $active
    var %j = 2, %ml = $line($active,0,1)
    var %moveseq
    while (%j <= %ml) {
      var %al = $gettok($strip($line($active,%j,1)),2-,32)
      %moveseq = %moveseq $gettok($gettok(%al,1,160),1,32) $gettok($gettok(%al,2,160),1,32)
      .inc %j
    }
    .getopenings $lower($remove(%moveseq,$chr(160),$chr(32),+,-))
  }
  Game:
  .New:
  ..White:
  ...$submenu($newchessgamemenu($1,white))
  ..Black:
  ...$submenu($newchessgamemenu($1,black))
  ..Random:
  ...$submenu($newchessgamemenu($1,rand))
  .Save: {
    var %scfilename = " $+ $sfile($scriptdir $+ ichess_save\*.txt,Save Game As..,Save) $+ "
    if (!%scfilename) { halt }
    .remove %scfilename
    var %i = 2, %maxl = $line($active,0,1)
    while (%i <= %maxl) {
      var %historyline = $strip($line($active,%i,1))
      if (*:* iswm %historyline) {
        .write %scfilename %historyline
      }
      .inc %i
    }
    .write %scfilename $hget(ichess $+ %actboard,wtime) $hget(ichess $+ %actboard,btime)
  }
  .Load:
  ...$submenu($loadchessgamemenu($1))
  . $iif($hget(ichess $+ %actboard,owncolor) == e,$style(2),$style(0)) Change sides: {
    %actboard = $active
    .addtochesschat 7* You request to change sides.
    .chess_send CHANGESIDESREQ * $hget(ichess $+ %actboard,me)
  }
  . $iif($hget(ichess $+ $active,owncolor) == e,$style(2),$style(0)) Continue:
  ...$submenu($continuechessgamemenu($1))

  $iif(!$hget(ichess $+ $active,host),$style(2),$style(0)) Host: 
  . $iif($hget(ichess $+ $active,mutemode),$style(1),$style(0)) Mute: {
    .hadd ichess $+ $active mutemode $iif($hget(ichess $+ $active,mutemode),0,1)
    .addtochesschat 7* You set mute-mode $iif($hget(ichess $+ $active,mutemode),on.,off.)
  }
  .Invite: {
    if ($?="Nick name? (and port, if needed)") {
      .tokenize 32 $ifmatch
      %actboard = $active
      var %port = $iif($2,$2,222)
      if (!$hget(ichess $+ %actboard,serverup)) {
        .sockclose ichess_wl $+ %actboard
        if ($portfree(%port)) {
          .socklisten ichess_wl $+ %actboard %port
          .ctcp $1 ICHESSINVITE $ip %port
          .addtochesschat 7* Invited $1
        }
        else {
          .addtochesschat 4** The port %port is in use, pick different one...
        }
      }
      else {
        .ctcp $1 ICHESSINVITE $ip $hget(ichess $+ %actboard,serverup)
        .addtochesschat 7* Invited $1
      }
    }
  }
  .Kick:
  ..$submenu($hostnickmenu($1,kick))
  .Ban: 
  ..$submenu($hostnickmenu($1,ban))
  . $iif(!$hfind(ichess $+ $active,banlist*,1,w),$style(2),$style(0)) Unban:
  ..$submenu($hostunbanmenu($1))
  .Run server $iif($hget(ichess $+ $active,serverup), $chr(40) $+ active on $ifmatch $+ $chr(41)) $+ : { %actboard = $active | .runichessserver }
  .$iif(!$hget(ichess $+ $active,serverup),$style(2),$style(0)) Stop server: { .hdel ichess $+ $active serverup | .sockclose ichess_wl $+ $active }

  Rules:
  . $iif($hget(ichess $+ $active,allowundo),$style(1),$style(0)) Allow Undo: .hadd ichess $+ $active allowundo $iif($hget(ichess $+ $active,allowundo),0,1) | .writeini " $+ $scriptdir $+ ichess.ini $+ " rules allowundo $hget(ichess $+ $active,allowundo)
  .Timelimit:
  .. $iif($hget(ichess $+ $active,timelimit),$style(0),$style(1)) Off: if ($hget(ichess $+ $active,timelimit) != 0) { .addtochesschat 8* You request to turn the Timelimit off. | .chess_send TIMELIMITREQ 0 }
  .. $iif($hget(ichess $+ $active,timelimit),$style(1),$style(0)) On $iif($ifmatch,( $+ $formatchesstime($hget(ichess $+ $active,timelimit)) $+ )) $+ : if ($?="Timelimit:") { var %wantedtl = $calc($gettok($ifmatch,-1,58) + $gettok($ifmatch,-2,58) * 60 + $gettok($ifmatch,-3,58) * 3600) | .addtochesschat 8* You request a Timelimit of7 $formatchesstime(%wantedtl) $+ 8. | .chess_send TIMELIMITREQ %wantedtl }
  Settings:
  . $iif($hget(ichess $+ $active,allowsingleclickmoves),$style(1),$style(0)) Allow Single-Click-Moves: .hadd ichess $+ $active allowsingleclickmoves $iif($hget(ichess $+ $active,allowsingleclickmoves),0,1) | .writeini " $+ $scriptdir $+ ichess.ini $+ " settings allowsingleclickmoves $hget(ichess $+ $active,allowsingleclickmoves)
  . $iif($hget(ichess $+ $active,showvalidmoves),$style(1),$style(0)) Show valid moves: .hadd ichess $+ $active showvalidmoves $iif($hget(ichess $+ $active,showvalidmoves),0,1) | .writeini " $+ $scriptdir $+ ichess.ini $+ " settings showvalidmoves $hget(ichess $+ $active,showvalidmoves)
  . $iif($hget(ichess $+ $active,stripcolorsinchat),$style(1),$style(0)) Strip colors in chat: .hadd ichess $+ $active stripcolorsinchat $iif($hget(ichess $+ $active,stripcolorsinchat),0,1) | .writeini " $+ $scriptdir $+ ichess.ini $+ " settings stripcolorsinchat $hget(ichess $+ $active,stripcolorsinchat)
  . $iif($hget(ichess $+ $active,showchessclock),$style(1),$style(0)) Show chess clocks: .hadd ichess $+ $active showchessclock $iif($hget(ichess $+ $active,showchessclock),0,1) | .writeini " $+ $scriptdir $+ ichess.ini $+ " settings showchessclock $hget(ichess $+ $active,showchessclock)
  . $iif(!$hget(ichess $+ $active,showchessclock),$style(2),$iif($hget(ichess $+ $active,countdownontimelimit),$style(1),$style(0))) Show Clock as Countdown: .hadd ichess $+ $active countdownontimelimit $iif($hget(ichess $+ $active,countdownontimelimit),0,1) | .writeini " $+ $scriptdir $+ ichess.ini $+ " settings countdownontimelimit $hget(ichess $+ $active,countdownontimelimit)
  . $iif($hget(ichess $+ $active,sortcaptures),$style(1),$style(0)) Sort captured pieces: .hadd ichess $+ $active sortcaptures $iif($hget(ichess $+ $active,sortcaptures),0,1) | .writeini " $+ $scriptdir $+ ichess.ini $+ " settings sortcaptures $hget(ichess $+ $active,sortcaptures) | .showcaptures
  .-
  .Beeping:
  .. $iif($hget(ichess $+ $active,beepmode) == 1 1,$style(1),$style(0)) Always: .hadd ichess $+ $active beepmode 1 1 | .writeini " $+ $scriptdir $+ ichess.ini $+ " settings beepmode $hget(ichess $+ $active,beepmode)
  .. $iif($hget(ichess $+ $active,beepmode) == 1 0,$style(1),$style(0)) Only events: .hadd ichess $+ $active beepmode 1 0 | .writeini " $+ $scriptdir $+ ichess.ini $+ " settings beepmode $hget(ichess $+ $active,beepmode)
  .. $iif($hget(ichess $+ $active,beepmode) == 0 1,$style(1),$style(0)) Only moves: .hadd ichess $+ $active beepmode 0 1 | .writeini " $+ $scriptdir $+ ichess.ini $+ " settings beepmode $hget(ichess $+ $active,beepmode)
  .. $iif($hget(ichess $+ $active,beepmode) == 0 0,$style(1),$style(0)) Never: .hadd ichess $+ $active beepmode 0 0 | .writeini " $+ $scriptdir $+ ichess.ini $+ " settings beepmode $hget(ichess $+ $active,beepmode)

  .CPU-strength:
  .. $iif($hget(ichess $+ $active,cpudepth) == 1,$style(1),$style(0)) 1 Move: .hadd ichess $+ $active cpudepth 1
  .. $iif($hget(ichess $+ $active,cpudepth) == 2,$style(1),$style(0)) 2 Moves: .hadd ichess $+ $active cpudepth 2
  .. $iif($hget(ichess $+ $active,cpudepth) == 3,$style(1),$style(0)) 3 Moves: .hadd ichess $+ $active cpudepth 3
  .. $iif($hget(ichess $+ $active,cpudepth) == 4,$style(1),$style(0)) 4 Moves: .hadd ichess $+ $active cpudepth 4
  .. $iif($hget(ichess $+ $active,cpudepth) == 5,$style(1),$style(0)) 5 Moves: .hadd ichess $+ $active cpudepth 5

  . $iif($hget(ichess $+ $active,openasdesktopwindow),$style(1),$style(0)) Open as Desktopwindow: .hadd ichess $+ $active openasdesktopwindow $iif($hget(ichess $+ $active,openasdesktopwindow),0,1) | .writeini " $+ $scriptdir $+ ichess.ini $+ " settings openasdesktopwindow $hget(ichess $+ $active,openasdesktopwindow)
  . $iif($hget(ichess $+ $active,nostats),$style(1),$style(0)) No stats: .hadd ichess $+ $active nostats $iif($hget(ichess $+ $active,nostats),0,1) | .writeini " $+ $scriptdir $+ ichess.ini $+ " settings nostats $hget(ichess $+ $active,nostats)
  .-
  .Update: .updateichess
  .Pieceset
  ..$submenu($piecesets($1))
  .Fieldset
  ..$submenu($fieldsets($1))
  .Boardbitmap
  ..$submenu($boardbitmaps($1))
  .Boardbitmap-dominance
  ..$submenu($boardbmptransps($1))
  -
  ; Go back to...
  $iif($mouse.lb,$iif($hget(ichess $+ $active,allowundo),$style(0),$style(2)) Go back to..) : {
    %actboard = $active
    var %selline = $strip($sline($active,1))
    if (Start:* !iswm %selline && *:* iswm %selline && $hget(ichess $+ %actboard,allowundo)) {
      var %move_n = $calc($gettok(%selline,1,$asc(:)) * 2 - $iif($hget(ichess $+ %actboard,owncolor) == b,1,0))
      var %lastvmove = $iif($hget(ichess $+ %actboard,owncolor) == w,%selline,$gettok(%selline,1,160))
      if (%move_n < $hget(ichess $+ %actboard,moves)) {
        .addtochesschat 7* You request to undo all moves after 15[ $+ %lastvmove $+ 15].
        .chess_send UNDOREQ $hget(ichess $+ %actboard,me) %move_n %lastvmove
      }
    }
  }
  $iif(e* iswm $hget(ichess $+ $active,turn),$style(2),$style(0)) Resign: {
    if (!$?!="Are you sure you want to resign?") { halt }
    %actboard = $active
    .chess_send RESIGN
    .chessgameover you resign
  }
  $iif(e* iswm $hget(ichess $+ $active,turn),$style(2),$style(0)) Offer Remis/Draw: {
    if (!$?!="Are you sure you want to offer a Remis?") { halt }
    %actboard = $active
    .addtochesschat 7* You offer a Remis.
    .chess_send REMISREQ * $hget(ichess $+ %actboard,me)
  }

  $iif($mouse.y < $hget(ichess $+ $active,chaty),$style(2),$style(0)) Open in Notepad $+ :
  .Keep controlcodes : .openchesschat $active
  .Strip controlcodes : .openchesschat $active 1
}

alias -l openchesschat {
  %actboard = $1
  var %i = 1
  .remove " $+ $scriptdir $+ tempchesschat.txt $+ "
  while ($hget(ichess $+ %actboard,chatting $+ %i)) {
    var %linetoadd = $ifmatch
    .write " $+ $scriptdir $+ tempchesschat.txt $+ " $iif($2,$strip(%linetoadd),%linetoadd)
    .inc %i
  }
  .run notepad " $+ $scriptdir $+ tempchesschat.txt $+ "
}

on *:close:@chess*: {
  %actboard = $target
  .timer $+ %actboard off
  .close -@ @temp2 $+ %actboard

  .chess_send QUIT $hget(ichess $+ %actboard,me)
  .sockclose %actboard $+ *
  .sockclose ichess_wl $+ %actboard
  if ($hget(ichess $+ %actboard)) { .hfree ichess $+ %actboard }
}

on *:sockclose:@chess*: {
  %actboard = $deltok($sockname,-1,$asc(_))
  var %dnick = $gettok($sock($sockname).mark,1,32)
  .addtochesschat 4** %dnick disconnected.
  .chess_send DISCONNECT %dnick
  .hdel ichess $+ %actboard users $+ %dnick
}

alias -l loadchessgame {
  var %i = 2, %maxmoves = $line(%actboard,0,1)

  while (%i <= %maxmoves) {
    var %readline = $strip($line(%actboard,%i,1))
    var %movedcolor
    var %rmoves = $gettok(%readline,2-,32)
    var %j = $numtok(%rmoves,160)

    while (%j) {
      if ($numtok(%rmoves,160) == 1) {
        .tokenize 32 $replace(%rmoves,-,$chr(32))
      }
      else {
        .tokenize 32 $replace($deltok(%rmoves,%j,160),-,$chr(32))
      }

      var %nypos = $right($1,1),%nxpos = $calc($asc($upper($left($1,1))) - 64)
      var %nypos2 = $right($2,1),%nxpos2 = $calc($asc($upper($left($2,1))) - 64)
      var %mehgone = $getpiece(%nxpos2,%nypos2)
      var %mehpiece = $getpiece(%nxpos,%nypos)

      ;en passant
      if (%nxpos != %nxpos2 && %nypos != %nypos2 && $getfieldpiece(%nxpos2,%nypos2) == 0 && $getfieldpiece(%nxpos,%nypos) == p && $getfieldpiece(%nxpos2,%nypos) == p) {
        %mehgone = $getpiece(%nxpos2,%nypos)
        .putpiece ichess $+ %actboard %nxpos2 %nypos 0
      }

      .hadd ichess $+ %actboard lastcapture %mehgone
      if (%mehgone != 0) {
        var %mehname = $iif($asc(%mehgone) & 32,b,w) $+ capt
        .hadd ichess $+ %actboard %mehname $hget(ichess $+ %actboard,%mehname) %mehgone
      }

      ;castling
      if (%mehpiece === K && $1 $2 == E1 G1) {
        .putpiece ichess $+ %actboard 6 1 R
        .putpiece ichess $+ %actboard 8 1 0
        .hadd ichess $+ %actboard wmoved 2 $+ $right($hget(ichess $+ %actboard,wmoved),2)
      }
      else if (%mehpiece === K && $1 $2 == E1 C1) {
        .putpiece ichess $+ %actboard 4 1 R
        .putpiece ichess $+ %actboard 1 1 0
        .hadd ichess $+ %actboard wmoved 2 $+ $right($hget(ichess $+ %actboard,wmoved),2)
      }
      else if (%mehpiece === k && $1 $2 == E8 G8) {
        .putpiece ichess $+ %actboard 6 8 r
        .putpiece ichess $+ %actboard 8 8 0
        .hadd ichess $+ %actboard bmoved 2 $+ $right($hget(ichess $+ %actboard,bmoved),2)
      }
      else if (%mehpiece === k && $1 $2 == E8 C8) {
        .putpiece ichess $+ %actboard 4 8 r
        .putpiece ichess $+ %actboard 1 8 0
        .hadd ichess $+ %actboard bmoved 2 $+ $right($hget(ichess $+ %actboard,bmoved),2)
      }

      .putpiece ichess $+ %actboard %nxpos2 %nypos2 %mehpiece
      .putpiece ichess $+ %actboard %nxpos %nypos 0

      .clearfieldmark
      var %movedcolor = $iif($asc(%mehpiece) & 32,b,w)
      var %mcol = $iif(%movedcolor == $hget(ichess $+ %actboard,owncolor),1,2)
      .hadd ichess $+ %actboard mark1 $hget(ichess $+ %actboard,mark1) $1 $+ . $+ %mcol
      .hadd ichess $+ %actboard mark2 $hget(ichess $+ %actboard,mark2) $2 $+ . $+ %mcol

      if (%mehpiece == k) {
        .hadd ichess $+ %actboard %movedcolor $+ kingpos $2
        if (0* iswm $hget(ichess $+ %actboard,%movedcolor $+ moved)) {
          .hadd ichess $+ %actboard %movedcolor $+ moved 1 $+ $right($hget(ichess $+ %actboard,%movedcolor $+ moved),2)
        }
      }
      else if (%mehpiece === R) {
        if ($2 == A1) {
          .hadd ichess $+ %actboard wmoved $left($hget(ichess $+ %actboard,wmoved),1) $+ 1 $+ $right($hget(ichess $+ %actboard,wmoved),1)
        }
        else if ($2 == H1) {
          .hadd ichess $+ %actboard wmoved $left($hget(ichess $+ %actboard,wmoved),2) $+ 1
        }
      }
      else if (%mehpiece === r) {
        if ($2 == A8) {
          .hadd ichess $+ %actboard bmoved $left($hget(ichess $+ %actboard,bmoved),1) $+ 1 $+ $right($hget(ichess $+ %actboard,bmoved),1)
        }
        else if ($2 == H8) {
          .hadd ichess $+ %actboard bmoved $left($hget(ichess $+ %actboard,bmoved),2) $+ 1
        }
      }

      .hadd ichess $+ %actboard turn $iif($hget(ichess $+ %actboard,turn) != b,b,w)

      .hadd ichess $+ %actboard %movedcolor $+ time $calc($hget(ichess $+ %actboard,%movedcolor $+ time) + $ticks - $hget(ichess $+ %actboard,startmovetime))
      .hadd ichess $+ %actboard lastmove $1 $2
      .hadd ichess $+ %actboard startmovetime $ticks

      if ($istok(n b r q,$3,32)) {
        .putpiece ichess $+ %actboard %nxpos2 %nypos2 $iif(%movedcolor == w, $upper($3), $lower($3))
      }
      else if ($3 isnum) {
        .putpiece ichess $+ %actboard %nxpos2 %nypos2 $iif(%movedcolor == w, $upper($gettok(n b r q,$3,32)), $lower($gettok(n b r q,$3,32)))
      }

      .savechessboard

      .hadd ichess $+ %actboard moves $calc($hget(ichess $+ %actboard,moves) + 1) 

      .dec %j
    }
    .inc %i
  }

  .sline -l %actboard $line(%actboard,0,1)

  if (e* !iswm $hget(ichess $+ %actboard,turn)) {
    var %attackers = $getattackers($hget(ichess $+ %actboard,$hget(ichess $+ %actboard,turn) $+ kingpos)),%ii = $numtok(%attackers,32)
    if (%ii) { .hadd ichess $+ %actboard mark1 $hget(ichess $+ %actboard,mark1) $hget(ichess $+ %actboard,$hget(ichess $+ %actboard,turn) $+ kingpos) $+ . $+ 2 }

    while (%ii) {
      .hadd ichess $+ %actboard mark1 $hget(ichess $+ %actboard,mark1) $gettok(%attackers,%ii,32) $+ . $+ 2
      .dec %ii
    }

    var %ismate = 0, %isstalemate = 0
    var %hrmf = $is_a_mate($hget(ichess $+ %actboard,turn))
    if (%hrmf == checkmate) { %ismate = 1 }
    else if (%hrmf == stalemate) { %isstalemate = 1 }
  }
  .buildchessboard
  .showbwturn
  .showcaptures

  .titlebar %actboard Last move: $1 - $2 $iif(%attackers,Check!) $iif($hget(ichess $+ %actboard,turn) == w,White,Black) $+ 's turn
  .hadd ichess $+ %actboard curfield meh
  if (%ismate) { .chessgameover $iif($hget(ichess $+ %actboard,turn) == $hget(ichess $+ %actboard,owncolor),you,opp) checkmate 1 }
  else if (%isstalemate) { .chessgameover $iif($hget(ichess $+ %actboard,turn) == $hget(ichess $+ %actboard,owncolor),you,opp) stalemate 1 }
}

alias -l loadgamehistory {
  .chess_send STARTLOAD $1 $hget(ichess $+ %actboard,me) $iif($2 == w,b,w)
  .startchessgame $2

  var %i = 1, %maxmoves = $lines($3-)
  while (%i <= %maxmoves) {
    var %readline = $read($3-,%i)
    if (%readline) {
      if (*:* !iswm %readline) {
        .hadd ichess $+ %actboard wtime $gettok(%readline,1,32)
        .hadd ichess $+ %actboard btime $gettok(%readline,2,32)
      }
      else {
        var %blob, %hrm
        %hrm = $regsub(%readline,/(\d+:) (.+)([+†]\s) (.+)/,14\1 4\2\3 14\4,%blob)
        %hrm = $regsub(%blob,/(.+) (.+)([+†])/,\1 4\2\3,%blob)
        .aline -l 14 %actboard %blob
      }
      .chess_send LOADMOVE %readline
    }
    .inc %i
  }
  .chess_send ENDLOAD
  .loadchessgame
}

alias -l undotil {
  while ($line(%actboard,0,1) > $int($calc(($1 + 1) / 2 + 1))) { .dline -l %actboard $int($calc(($1 + 1) / 2 + 2)) }
  if ($calc($1 % 2) == 1) {
    var %repline = $gettok($line(%actboard,$line(%actboard,0,1),1),1,160)
    .rline -l 14 %actboard $line(%actboard,0,1) %repline
  }

  .hadd ichess $+ %actboard board $hget(ichess $+ %actboard,board_ $+ $1)
  .hadd ichess $+ %actboard wcapt $hget(ichess $+ %actboard,wcapt_ $+ $1)
  .hadd ichess $+ %actboard wmoved $hget(ichess $+ %actboard,wmoved_ $+ $1)
  .hadd ichess $+ %actboard wtime $hget(ichess $+ %actboard,wtime_ $+ $1)
  .hadd ichess $+ %actboard wkingpos $hget(ichess $+ %actboard,wkingpos_ $+ $1)

  .hadd ichess $+ %actboard bcapt $hget(ichess $+ %actboard,bcapt_ $+ $1)
  .hadd ichess $+ %actboard bmoved $hget(ichess $+ %actboard,bmoved_ $+ $1)
  .hadd ichess $+ %actboard btime $hget(ichess $+ %actboard,btime_ $+ $1)
  .hadd ichess $+ %actboard bkingpos $hget(ichess $+ %actboard,bkingpos_ $+ $1)

  .hadd ichess $+ %actboard lastmove $hget(ichess $+ %actboard,lastmove_ $+ $1)

  .hadd ichess $+ %actboard mark1 $hget(ichess $+ %actboard,mark1_ $+ $1)
  .hadd ichess $+ %actboard mark2 $hget(ichess $+ %actboard,mark2_ $+ $1)

  .hadd ichess $+ %actboard turn $iif($calc($1 % 2) == 0,w,b)

  .hadd ichess $+ %actboard moves $calc($1 + 1)

  .showbwturn
  .showcaptures
  .buildchessboard
  .titlebar %actboard Last move: $gettok($hget(ichess $+ %actboard,lastmove),1,32) - $gettok($hget(ichess $+ %actboard,lastmove),2,32) $iif($hget(ichess $+ %actboard,turn) == w,White,Black) $+ 's turn
  .hadd ichess $+ %actboard startmovetime $ticks
  if ($hget(ichess $+ %actboard,$hget(ichess $+ %actboard,turn) $+ playername) == @RCPU) { .cpuchessmove %actboard }
}

on *:input:@chess*: {
  %actboard = $target
  if (/me == $1) {
    .addtochesschat 4* $hget(ichess $+ %actboard,me) 7 $+ $2-
    .chess_send CHATACTION $hget(ichess $+ %actboard,me) $2-
  }
  else if (/clear == $1) {
    .hdel -w ichess $+ %actboard chatting*
    .showchesschat
  }
  else if (/invite == $1 && $2) {
    var %port = $iif($3,$3,222)
    if ($hget(ichess $+ %actboard,host)) {
      if (!$hget(ichess $+ %actboard,serverup)) {
        .sockclose ichess_wl $+ %actboard
        if ($portfree(%port)) {
          .socklisten ichess_wl $+ %actboard %port
          .ctcp $2 ICHESSINVITE $ip %port
          .addtochesschat 7* Invited $2
        }
        else {
          .addtochesschat 4** The port %port is in use, pick different one...
        }
      }
      else {
        .ctcp $2 ICHESSINVITE $ip $hget(ichess $+ %actboard,serverup)
        .addtochesschat 7* Invited $2
      }
    }
    else {
      .addtochesschat 4** You are not host of this board.
    }
  }
  else if (/who == $1) {
    var %ii = $hfind(ichess $+ %actboard,users*,0,w), %outp = $hget(ichess $+ %actboard,me) $hget(ichess $+ %actboard,ownrating)
    while (%ii) {
      var %tt = $hfind(ichess $+ %actboard,users*,%ii,w)
      %outp = $right(%tt,-5) $hget(ichess $+ %actboard,%tt) $+ , %outp
      .dec %ii
    }
    .addtochesschat 7** Users: %outp
  }
  else if (/* iswm $1-) { $1- | halt }
  else if ($hget(ichess $+ %actboard,request) && ($1- == yes || $1- == ok || $1- == no)) {
    var %accepted = $iif($1 == ok || $1 == yes,1)
    .tokenize 32 $hget(ichess $+ %actboard,request)
    .hdel ichess $+ %actboard request
    goto $1

    :NEWGAMEREQ
    if (%accepted) {
      .addtochesschat 9* You accepted a new game.
      .chess_send ACCEPT_NG $3 $hget(ichess $+ %actboard,me) $5
      .hadd ichess $+ %actboard wplayername $iif($5 == b,$2,$3)
      .hadd ichess $+ %actboard bplayername $iif($5 == w,$2,$3)

      .hadd ichess $+ %actboard opponent $3
      .hadd ichess $+ %actboard opprating $hget(ichess $+ %actboard,users $+ $3)

      .startchessgame $iif($5 == w,b,w)
    }
    else {
      .addtochesschat 4* You declined a new game.
      .chess_send DECLINE_NG $3 $hget(ichess $+ %actboard,me) $5
    }
    halt

    :LOADGAMEREQ
    if (%accepted) {
      .addtochesschat 9* You accepted to load the game.
      .hadd ichess $+ %actboard wplayername $iif($4 == b,$2,$3)
      .hadd ichess $+ %actboard bplayername $iif($4 == w,$2,$3)

      .hadd ichess $+ %actboard opponent $3
      .hadd ichess $+ %actboard opprating $hget(ichess $+ %actboard,users $+ $3)

      .chess_send ACCEPT_LG $3 $hget(ichess $+ %actboard,me) $4
    }
    else {
      .addtochesschat 4* You declined to load the game.
      .chess_send DECLINE_LG $3 $hget(ichess $+ %actboard,me)
    }
    halt

    :UNDOREQ
    if (%accepted) {
      .addtochesschat 9* You accepted to undo.
      .chess_send ACCEPT_UNDO $2 $hget(ichess $+ %actboard,me) $3
      .undotil $3
    }
    else {
      .addtochesschat 4* You declined to undo.
      .chess_send DECLINE_UNDO $2 $hget(ichess $+ %actboard,me)
    }
    halt

    :CHANGESIDESREQ
    if (%accepted) {
      .addtochesschat 9* You accepted to change sides.
      .chess_send ACCEPT_CHANGES $3 $hget(ichess $+ %actboard,me)
      .hadd ichess $+ %actboard wplayername $iif($hget(ichess $+ %actboard,owncolor) == b,$hget(ichess $+ %actboard,me),$3)
      .hadd ichess $+ %actboard bplayername $iif($hget(ichess $+ %actboard,owncolor) == w,$hget(ichess $+ %actboard,me),$3)
      .chess_send PLAYERS $hget(ichess $+ %actboard,wplayername) $hget(ichess $+ %actboard,bplayername)
      .hadd ichess $+ %actboard owncolor $iif($hget(ichess $+ %actboard,owncolor) == w,b,w)
      .constructboard $hget(ichess $+ %actboard,owncolor)
      .buildchessboard
      .showbwturn
    }
    else {
      .addtochesschat 4* You declined to change sides.
      .chess_send DECLINE_CHANGES $3 $hget(ichess $+ %actboard,me)
    }
    halt

    :TIMELIMITREQ
    if (%accepted) {
      .addtochesschat 9* You accepted the timelimit.
      .chess_send ACCEPT_TL $2
      .hadd ichess $+ %actboard timelimit $2
    }
    else {
      .addtochesschat 4* You declined a timelimit.
      .chess_send DECLINE_TL $2
    }
    halt

    :REMISREQ
    if (%accepted) {
      .addtochesschat 9* You accepted the Remis.
      .chess_send ACCEPT_RE $3 $hget(ichess $+ %actboard,me)
      .chessgameover you remis
    }
    else {
      .addtochesschat 4* You declined the Remis.
      .chess_send DECLINE_RE $3 $hget(ichess $+ %actboard,me)
    }
    halt

    :CONTGAMEREQ
    if (%accepted) {
      .addtochesschat 9* You accepted to continue game.
      .chess_send ACCEPT_CG $3 $hget(ichess $+ %actboard,me) $4
      .hadd ichess $+ %actboard $4 $+ playername $2
      .hadd ichess $+ %actboard opponent $3
      .hadd ichess $+ %actboard opprating $hget(ichess $+ %actboard,users $+ $3)
      .hadd ichess $+ %actboard owncolor $4
      .hadd ichess $+ %actboard boardsidecolor $4
      .constructboard $4
      .buildchessboard
      .showbwturn
      .showcaptures
    }
    else {
      .addtochesschat 4* You declined to continue the game.
      .chess_send DECLINE_CG $3 $hget(ichess $+ %actboard,me)
    }
    halt
  }
  else {
    .addtochesschat 0(7 $+ $hget(ichess $+ %actboard,me) $+ 0)15 $1-
    .chess_send CHAT $hget(ichess $+ %actboard,me) $1-
  }
  halt
}

alias -l savechessboard {
  var %state_N = $hget(ichess $+ %actboard,moves)
  .hadd ichess $+ %actboard board_ $+ %state_N $hget(ichess $+ %actboard,board)
  .hadd ichess $+ %actboard wcapt_ $+ %state_N $hget(ichess $+ %actboard,wcapt)
  .hadd ichess $+ %actboard wmoved_ $+ %state_N $hget(ichess $+ %actboard,wmoved)
  .hadd ichess $+ %actboard wtime_ $+ %state_N $hget(ichess $+ %actboard,wtime)
  .hadd ichess $+ %actboard wkingpos_ $+ %state_N $hget(ichess $+ %actboard,wkingpos)

  .hadd ichess $+ %actboard bcapt_ $+ %state_N $hget(ichess $+ %actboard,bcapt)
  .hadd ichess $+ %actboard bmoved_ $+ %state_N $hget(ichess $+ %actboard,bmoved)
  .hadd ichess $+ %actboard btime_ $+ %state_N $hget(ichess $+ %actboard,btime)
  .hadd ichess $+ %actboard bkingpos_ $+ %state_N $hget(ichess $+ %actboard,bkingpos)

  .hadd ichess $+ %actboard lastmove_ $+ %state_N $hget(ichess $+ %actboard,lastmove)

  .hadd ichess $+ %actboard mark1_ $+ %state_N $hget(ichess $+ %actboard,mark1)
  .hadd ichess $+ %actboard mark2_ $+ %state_N $hget(ichess $+ %actboard,mark2)
}

alias -l chessgameover {
  if ($hget(ichess $+ %actboard,owncolor) == e) { return }
  var %owncolor = $iif($hget(ichess $+ %actboard,owncolor) == w,White,Black)
  var %oppcolor = $iif($hget(ichess $+ %actboard,owncolor) == b,White,Black)
  var %tcolor = $iif($1 == you,4,9)
  var %endreason

  .hadd ichess $+ %actboard turn end

  if ($2 == resign) {
    .addtochesschat %tcolor $+ * $iif($1 == you,%owncolor,%oppcolor) resigns. $iif($1 == opp,%owncolor,%oppcolor) wins.
    .addtochesschat %tcolor $+ * You $iif($1 == opp,win.,lose.)
    .titlebar %actboard Resign! $iif($1 == opp,%owncolor,%oppcolor) wins!
    %endreason = *
  }
  else if ($2 == checkmate) {
    var %lastlline = $line(%actboard,0,1)
    var %linetoadd = †
    if († !isin $line(%actboard,%lastlline,1)) { 
    .rline -l 4 %actboard %lastlline $line(%actboard,%lastlline,1) %linetoadd }
    .addtochesschat %tcolor $+ * $iif($1 == you,%owncolor,%oppcolor) is checkmate. $iif($1 == opp,%owncolor,%oppcolor) wins.
    .addtochesschat %tcolor $+ * You $iif($1 == opp,win.,lose.)
    .titlebar %actboard Checkmate! $iif($1 == opp,%owncolor,%oppcolor) wins!
    %endreason = †
  }
  else if ($2 == stalemate) {
    var %lastlline = $line(%actboard,0,1)
    var %linetoadd = ‡
    if (‡ !isin $line(%actboard,%lastlline,1)) { .rline -l 4 %actboard %lastlline $line(%actboard,%lastlline,1) %linetoadd }
    .addtochesschat 7* $iif($1 == you,%owncolor,%oppcolor) is stalemate.
    .addtochesschat 7* Draw.
    .titlebar %actboard Stalemate! Draw.
    %endreason = ‡ 
  }
  else if ($2 == timeout) {
    .addtochesschat %tcolor $+ * $iif($1 == you,%owncolor,%oppcolor) runs out of time.
    .addtochesschat %tcolor $+ * You $iif($1 == opp,win.,lose.)
    .titlebar %actboard Timeout! $iif($1 == opp,%owncolor,%oppcolor) wins!
    %endreason = t
  }
  else if ($2 == remis) {
    var %lastlline = $line(%actboard,0,1)
    var %linetoadd = -
    if (- !isin $line(%actboard,%lastlline,1)) { .rline -l 4 %actboard %lastlline $line(%actboard,%lastlline,1) %linetoadd }
    .addtochesschat 7* Remis in agreement.
    .titlebar %actboard Draw.
    %endreason = -
  }

  .showbwturn
  var %statstring
  if (1 * iswm $hget(ichess $+ %actboard,beepmode)) { .beep | .beep }
  if (@Chess_@_* !iswm %actboard) {
    %statstring = $calc($hget(ichess $+ %actboard,timelimit) + 0) $hget(ichess $+ %actboard,wtime) $hget(ichess $+ %actboard,btime) $hget(ichess $+ %actboard,moves) $iif($2 == remis,*,$iif($2 == stalemate,$lower($left($iif($1 == you,%owncolor,%oppcolor),1)),$lower($left($iif($1 == opp,%owncolor,%oppcolor),1)))) $iif($2 == stalemate || $2 == remis,*,$iif($1 == you,l,w)) %endreason $ctime
    if (!$3) { .write " $+ $scriptdir $+ record.stat $+ " $hget(ichess $+ %actboard,opponent) $hget(ichess $+ %actboard,opprating) %statstring }
    .hadd ichess $+ %actboard ownrating $calcownCXR
    .chess_send IAM $hget(ichess $+ %actboard,me) $hget(ichess $+ %actboard,ownrating)
    .addtochesschat 7* Your new rating: $hget(ichess $+ %actboard,ownrating)
    if (!$hget(ichess $+ %actboard,nostat)) {
      .sockclose ichessstats $+ %actboard
      .hadd ichess $+ %actboard statstring $hget(ichess $+ %actboard,wplayername) $hget(ichess $+ %actboard,bplayername) $iif($hget(ichess $+ %actboard,owncolor) == w,$hget(ichess $+ %actboard,ownrating) $hget(ichess $+ %actboard,opprating),$hget(ichess $+ %actboard,opprating) $hget(ichess $+ %actboard,ownrating)) $replace($deltok(%statstring,6,32),†,+,‡,++) $gmt
      .timertrycon $+ ichessstats $+ %actboard 5 10 .sockopen ichessstats $+ %actboard xor.ma.cx 2121
    }
  }
}

on *:sockopen:ichessstats*: {
  if ($sockerr) { halt }
  .timertrycon $+ $sockname off
  .sockwrite $sockname $hget(ichess $+ $right($sockname,-11),statstring) $+ $crlf
  .hdel ichess $+ %actboard statstring
}

alias updateichess {
  .close -@ @updateichess
  .sockclose updichess
  .sockopen updichess ichess.cjb.net 2107
}

on *:sockopen:updichess: {
  if ($sockerr) { .echo -a 4* couldn't connect.. | halt }
  .sockmark $sockname vercheck
}

on *:sockread:updichess: {
  if ($sock($sockname).mark == vercheck) {
    var %lr
    .sockread %lr
    if (ichess: * iswm %lr) {
      if ($gettok(%lr,2,32) > $ichessversion) {
        var %or = $hget(ichess $+ %actboard,ownrating), %me = $hget(ichess $+ %actboard,me)
        if (!%or || !%me ) {
          %or = $calcownCXR
          %me = $readini($scriptdir $+ ichess.ini,settings,nickname)
        }
        if (!%me) {
          %me = $me
        }
        .sockwrite -n $sockname getfile ichess/ichess.mrc . $+ %me . $+ %or . $+ $me . $+ $server

        .window -pdBChfo +fL @updateichess 1 1 300 70
        .drawrect -f @updateichess 1 0 0 0 300 70
        .drawtext -o @updateichess 7 Comic 20 90 2 Downloading...
        .drawrect -f @updateichess 1 0 10 32 277 30
        .drawrect @updateichess 0 0 10 32 277 30
        .remove " $+ $scriptdir $+ tempupd.dat $+ "
        .sockmark $sockname bleah
      }
      else {
        var %or = $hget(ichess $+ %actboard,ownrating), %me = $hget(ichess $+ %actboard,me)
        if (!%or || !%me ) {
          %or = $calcownCXR
          %me = $readini($scriptdir $+ ichess.ini,settings,nickname)
        }
        if (!%me) {
          %me = $me
        }
        .sockwrite -n $sockname iC_ok $ichessversion . $+ %me . $+ %or . $+ $me . $+ $server
        .echo -a 9No update needed. $ichessversion is the still latest.
        .sockclose $sockname
      }
    }
  }
  else if (* go !iswm $sock($sockname).mark) {
    var %lr
    .sockread %lr
    .tokenize 32 %lr
    if ($1 == Content-Length:) {
      .sockmark $sockname $2
    }
    else if (!%lr) {
      .sockmark $sockname $sock($sockname).mark go
    }
  }
  else {
    .sockread &data
    while ($sockbr) {
      .bwrite " $+ $scriptdir $+ tempupd.dat $+ " -1 -1 &data
      var %percdone = $calc($file($scriptdir $+ tempupd.dat).size / $gettok($sock($sockname).mark,1,32))
      .drawrect -f @updateichess 12 0 10 32 $calc(%percdone * 277) 30
      .drawrect @updateichess 0 0 10 32 277 30
      .sockread &data
    }
  }
}

on *:sockclose:updichess: {
  if ($sock($sockname).mark != vercheck) {
    .drawrect -f @updateichess 1 0 0 0 300 70
    .drawtext -o @updateichess 7 Comic 20 90 2 Extracting...
    .drawrect -f @updateichess 12 0 10 32 277 30
    .drawrect @updateichess 0 0 10 32 277 30

    .close -@ @updateichess
    .copy -o " $+ $scriptdir $+ tempupd.dat $+ " " $+ $scriptdir $+ ichess.mrc $+ "
    .remove " $+ $scriptdir $+ tempupd.dat $+ "
    .echo -a 9* iChess updated successfully.
    .timer 1 0 .reload -rs " $+ $scriptdir $+ ichess.mrc $+ "
  }
}

on *:load: {
  .echo -a 9* iChess v $+ $ichessversion installed successfully.
}

alias calcnewCXR {
  var %resadd = $iif($3 == *,0,$iif($3 == w,1,-1))
  var %toadd, %ratstate
  if (*:R iswm $1 && *:R iswm $2) {
    %toadd = $int($calc(%resadd * 21 + ($gettok($2,1,58) - $gettok($1,1,58)) / 25))
    %ratstate = R
  }
  else if (*:P* iswm $1 && *:P* iswm $2) {
    %toadd = $int($calc(%resadd * 21 + ($gettok($2,1,58) - $gettok($1,1,58)) / 25))
    %ratstate = $calc($right($gettok($1,2,58),-1) + 1)
    if (%ratstate >= 15) { %ratstate = R }
    else { %ratstate = P $+ %ratstate }
  }
  else if (*:R iswm $1 && *:P* iswm $2) {
    %toadd = $int($calc(%resadd * 6 + ($gettok($2,1,58) - $gettok($1,1,58)) / 100))
    %ratstate = R
  }
  else if (*:P* iswm $1 && *:R iswm $2) {
    %toadd = $int($calc(%resadd * 80 + $gettok($2,1,58) / 5 - $gettok($1,1,58) / 5))
    %ratstate = $calc($right($gettok($1,2,58),-1) + 3)
    if (%ratstate >= 15) { %ratstate = R }
    else { %ratstate = P $+ %ratstate }
  }

  if (%toadd > 41) { %toadd = 41 }
  if (%toadd < -41) { %toadd = -41 }
  if ($3 == w && %toadd < 2) { %toadd = 2 }
  if ($3 == l && %toadd > -2) { %toadd = -2 }

  return $calc($gettok($1,1,58) + %toadd) $+ : $+ %ratstate
}

alias -l calcownCXR {
  var %ownrating = 1200:P0
  if (!$exists($scriptdir $+ record.stat)) { goto end }
  .window -h @temp
  var %matchstr = $1, %startm = $calc($len(%matchstr) + 1)
  .filter -fwcg " $+ $scriptdir $+ record.stat $+ " @temp
  var %i = 1, %maxlines = $filtered
  while (%i <= %maxlines) {
    var %rln = $line(@temp,%i)
    if ($numtok(%rln,32) == 11) {
      var %newrating = $calcnewCXR(%ownrating,$gettok(%rln,2,32),$gettok(%rln,9,32))
      ; .echo -s %ownrating :: $gettok(%rln,2,32) :: $gettok(%rln,9,32) == %newrating
      %ownrating = %newrating
    }
    .inc %i
  }
  .close -@ @temp
  :end
  return %ownrating
}

dialog openings {
  title "ECO"
  size -1 -1 300 317

  text "Matching ECO-entries:", 1, 5 5 300 20
  list 2, 5 25 290 200, sort vsbar
  text "", 5, 5 220 290 35
  text "", 3, 5 250 290 40
  text "", 4, 5 300 290 12
  button "", 6, 1 1 1 1, ok
}

on *:dialog:*-ECOs-*:init:0: {
  var %matchstr = $gettok($dname,-1,$asc(-))
  .window -h @temp $+ $dname

  .filter -fw " $+ $scriptdir $+ ECO.txt $+ " @temp $+ $dname *: %matchstr $+ *
  var %i = $filtered
  .did -a $dname 1 $filtered Matching ECO-entries:
  while (%i) {
    var %al = $line(@temp $+ $dname,%i)
    .did -a $dname 2 $gettok(%al,1,32) $gettok(%al,2,64)
    .dec %i
  }
}

on *:dialog:*-ECOs-*:close:0: {
  .close -@ @temp $+ $dname
}

on *:dialog:*-ECOs-*:sclick:2: {
  var %sl = $line(@temp $+ $dname,$fline(@temp $+ $dname,*@ $gettok($did($dname,2).seltext,2-,32) @*,1))
  var %nextm = $mid($gettok($gettok(%sl,1,64),2-,32),$calc($len($gettok($dname,-1,$asc(-))) + 1),4)
  %sl = $gettok(%sl,3,64)
  .did -a $dname 5 Opening: $gettok($did($dname,2).seltext,2-,32)
  .did -a $dname 3 %sl
  .did -a $dname 4 Next move: $iif(%nextm,$upper($left(%nextm,2) $+ - $+ $right(%nextm,2)))
  %actboard = $deltok($dname,-2-,$asc(-))
  .clearfieldmark
  if (%nextm) {
    .hadd ichess $+ %actboard mark2 $hget(ichess $+ %actboard,mark2) $left(%nextm,2) $+ .3
    .hadd ichess $+ %actboard mark1 $hget(ichess $+ %actboard,mark1) $right(%nextm,2) $+ .3
    .buildchessboard
  }
}

alias -l getopenings {
  .dialog -mvo %actboard $+ -ECOs- $+ $1 openings
}

alias showchessstats {
  .window -h @temp
  var %matchstr = /((?i) $+ $replace($lower($1-),$chr(32),|(?i)) $+ .).*/, %startm = $calc($len(%matchstr) + 1)
  .filter -fwcg " $+ $scriptdir $+ record.stat $+ " @temp %matchstr
  var %i = 1, %maxlines = $filtered
  if ($hget(cstats)) { .hdel -w cstats * }
  else { .hmake cstats }
  while (%i <= %maxlines) {
    var %rln = $line(@temp,%i), %res = $gettok(%rln,9,32)

    .hadd cstats %res $calc($hget(cstats,%res) + 1)
    .hadd cstats %res $+ $gettok(%rln,10,32) $calc($hget(cstats,%res $+ $gettok(%rln,10,32)) + 1)

    if (%res == w) {
      if ($hget(cstats,streak) <= 0) { .hadd cstats streak 1 }
      else { .hadd cstats streak $calc($hget(cstats,streak) + 1) }
    }
    else if (%res == l) {
      if ($hget(cstats,streak) >= 0) { .hadd cstats streak -1 }
      else { .hadd cstats streak $calc($hget(cstats,streak) - 1) }
    }
    else { .hadd cstats streak 0 }
    .inc %i
  }
  .close -@ @temp
  if (!$1) {
    return rating: $calcownCXR $+ , games: $calc($hget(cstats,w) + $hget(cstats,l) + $hget(cstats,*)) $+ , won: $calc($hget(cstats,w) + 0) ( $+ $calc($hget(cstats,w†) + 0) $+ † $calc($hget(cstats,w*) + 0) $+ *), lost: $calc($hget(cstats,l) + 0) ( $+ $calc($hget(cstats,l†) + 0) $+ † $calc($hget(cstats,l*) + 0) $+ *), draw: $calc($hget(cstats,*) + 0) :: streak: $calc($hget(cstats,streak) + 0)
  }
  else {
    return Games vs. ( $+ $1- $+ ): games: $calc($hget(cstats,w) + $hget(cstats,l) + $hget(cstats,*)) $+ , won: $calc($hget(cstats,w) + 0) ( $+ $calc($hget(cstats,w†) + 0) $+ † $calc($hget(cstats,w*) + 0) $+ *), lost: $calc($hget(cstats,l) + 0) ( $+ $calc($hget(cstats,l†) + 0) $+ † $calc($hget(cstats,l*) + 0) $+ *), draw: $calc($hget(cstats,*) + 0) :: streak: $calc($hget(cstats,streak) + 0)
  }
}

on *:socklisten:ichess_wl*: {
  .timerichessaccwait off
  %actboard = $right($sockname,-9)
  .inc %chesssocks
  var %nsock = $+(%actboard,_,%chesssocks)
  .sockaccept %nsock
  if ($hfind(ichess $+ %actboard,banlist $+ $sock(%nsock).ip,1,W)) {
    .sockwrite -n %nsock BANNED 
    .timer 1 1 .sockclose %nsock
    halt
  }
  .sockwrite -n %nsock IAM $hget(ichess $+ %actboard,me) $hget(ichess $+ %actboard,ownrating)
  var %i = $sock(%actboard $+ *,0)
  while (%i) {
    var %actsock = $sock(%actboard $+ *,%i)
    if (%actsock != %nsock) {
      .sockwrite -n %nsock IAM $sock(%actsock).mark
    }
    .dec %i
  }

  .sockwrite -n %nsock PLAYERS $hget(ichess $+ %actboard,wplayername) $hget(ichess $+ %actboard,bplayername)
  .sockwrite -n %nsock STARTLOAD e
  var %i = 2, %maxmoves = $line(%actboard,0,1)
  while (%i <= %maxmoves) {
    .sockwrite -n %nsock LOADMOVE $strip($line(%actboard,%i,1))
    .inc %i
  }
  .sockwrite -n %nsock LOADMOVE $calc($hget(ichess $+ %actboard,wtime) + $iif($hget(ichess $+ %actboard,turn) == w,$ticks - $hget(ichess $+ %actboard,startmovetime))) $calc($hget(ichess $+ %actboard,btime) + $iif($hget(ichess $+ %actboard,turn) == b,$ticks - $hget(ichess $+ %actboard,startmovetime)))
  .sockwrite -n %nsock ENDLOAD
  if (!$hget(ichess $+ %actboard,serverup)) { .sockclose $sockname }
}

on *:exit: {
  .sockwrite -n Chess* QUIT $hget(ichess $+ %actboard,me)
}

alias runichessserver {
  if ($?="Port?") {
    var %port = $ifmatch
    if ($portfree(%port)) {
      .hadd ichess $+ %actboard serverup %port
      .sockclose ichess_wl $+ %actboard
      .socklisten ichess_wl $+ %actboard $hget(ichess $+ %actboard,serverup)
    }
    else {
      .addtochesschat 4** The port %port is in use, pick different one...
    }
  }
}

alias grrrr {
  var %i = 1, %maxl = $lines(ichess/record.stat)
  var %cxr = 1200:P0
  while (%i <= %maxl) {
    var %rl = $read(ichess/record.stat,%i), %hrm
    var %cxr_ = $calcnewCXR(%cxr,$gettok(%rl,2,32),$gettok(%rl,9,32))
    if ($gettok(%rl,3,32) == w) {
      %hrm = $regsub(%rl,/(.+) (.+) (.+) (.+) (.+) (.+) (.+) (.+) (.+) (.+) (.+)/,Oliver \1 %cxr \2 \4 \5 \6 \7 \8 \10 \11,%rl)
    }
    else {
      %hrm = $regsub(%rl,/(.+) (.+) (.+) (.+) (.+) (.+) (.+) (.+) (.+) (.+) (.+)/,\1 Oliver \2 %cxr \4 \5 \6 \7 \8 \10 \11,%rl)
    }
    .write blaaah.txt $ip $+ : $replace(%rl,†,+,‡,++) $calc($gettok(%rl,-1,32) - 3600)
    %cxr = %cxr_
    .inc %i
  }
}

; 2003, Oliver|Alfihar|xOliRu
