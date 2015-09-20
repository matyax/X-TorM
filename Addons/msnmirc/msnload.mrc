on *:load:{
  set %msn.version 2.02
  set %msn.released 25/05/2004
  set %msn.constatus online
  set %msn.lang msnen.ini
  set %msn.expand yes
  set %msn.msgbold no
  set %msn.convers.show nick
  set %msn.sounds yes
  set %msn.logs yes
  set %msn.conlap 3
  set %msn.condesign 2d
  set %msn.convstatus max
  set %msn.away yes
  set %msn.conv.cr no
  set %msn.menu rclick
  set %msn.conv.head default
  set %msn.conv.thperso <time> - <b><nick></b> : <br>
  set %msn.conv.thdefault <table border="0"><tr><td><font face="Tahoma" size="1"><nobr><b><nick></b></nobr></font></td><td width="100%"><hr style="height: 1"></td><td align="right"><font face="Tahoma" size="1"><time></font></td></tr></table>
  set %msn.conv.inc 1
  set %msn.file.inc 1
  dialog -m msnloader msnloader
}

dialog msnloader {
  title "MSNMIRC 2.02 by Artwerks"
  icon $msnmirc.icon, index
  size -1 -1 176 128
  option dbu
  icon 1, 1 1 174 52, $msnmirc.logo, 0
  text "", 2, 3 57 170 9
  text "", 3, 3 66 170 9
  text "", 4, 3 75 170 9
  text "", 7, 3 84 170 9
  text "", 8, 3 93 170 9
  text "", 9, 3 102 170 9
  combo 5, 1 115 142 100, size drop
  button "Load", 6, 146 115 29 10, ok
}

on *:dialog:msnloader:init:0:{
  did -a $dname 2 Choississez un language pour l'addon
  did -a $dname 3 Please choose a language for the addon
  did -a $dname 4 Elija por favor una lengua para el addon
  did -a $dname 7 Scegli una lingua per l'addon
  did -a $dname 8 Wählen Sie bitte eine Sprache für das addon
  did -a $dname 9 Selecione a linguagem para o addon
  did -a $dname 5 Deutsche
  did -a $dname 5 English
  did -a $dname 5 Español
  did -a $dname 5 Français
  did -a $dname 5 Italiano
  did -a $dname 5 Portuguesa
  did -c $dname 5 2
}
on *:dialog:msnloader:sclick:6:{
  if ($did(5).sel == 2) {
    url -an $+(",$scriptdirhelp\msnmirc.hlp.html,")
    set %msn.lang msnen.ini
  }
  elseif ($did(5).sel == 3) {
    url -an $+(",$scriptdirhelp\msnmirc.hlp.html,")
    set %msn.lang msnes.ini
  }
  elseif ($did(5).sel == 4) {
    url -an $+(",$scriptdirhelp\msnmircfr.hlp.html,")
    set %msn.lang msnfr.ini
  }
  elseif ($did(5).sel == 5) {
    url -an $+(",$scriptdirhelp\msnmirc.hlp.html,")
    set %msn.lang msnit.ini
  }
  elseif ($did(5).sel == 1) {
    url -an $+(",$scriptdirhelp\msnmirc.hlp.html,")
    set %msn.lang msnde.ini
  }
  elseif ($did(5).sel == 6) {
    url -an $+(",$scriptdirhelp\msnmirc.hlp.html,")
    set %msn.lang msnpo.ini
  }
  else {
    url -an $+(",$scriptdirhelp\msnmirc.hlp.html,")
    set %msn.lang msnen.ini
  }
  load -rs $+(",$scriptdirmsnmirc.mrc,")
  unload -rs msnload.mrc
}

alias msnmirc.icon { return $scriptdiricons\msnmirc.ico }
alias msnmirc.logo { return $scriptdirhelp\msnmirc.png }
