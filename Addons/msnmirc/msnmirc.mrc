;;;DIALOGS

dialog msnmirc {
  title $msnreadini(main,dtitle)
  icon $msnmirc.icon, index
  size -1 -1 136 170
  option dbu
  list 1, 0 31 136 139, size
  combo 2, 3 15 130 84, size
  box "", 3, 0 0 136 30
  text "", 4, 4 6 128 7
  menu "MsnMirc", 100
  item "", 110, 100
  item "", 111, 100
  item break, 150, 100
  item "", 120, 100
  item "", 121, 100
  item break, 151, 100
  item "", 130, 100
  menu "?", 200
  item "", 210, 200
  item "", 211, 200
  button "", 50, 0 0 0 0
}

dialog msncon {
  title $msnreadini(conn,dtitle)
  icon $msnmirc.icon, index
  size -1 -1 116 29
  option dbu
  text "", 1, 15 3 101 25
  button "", 2, 43 28 37 10
  button "", 3, 79 28 37 10, cancel
  icon 4, 0 0 9 9, $msn.conn.icon
}

dialog msn.file.accept {
  title $msnreadini(fileaccept,dtitle)
  icon $msnmirc.icon, index
  size -1 -1 166 80
  option dbu
  box "", 1, 2 2 162 76
  button "", 2, 46 63 37 10, ok
  button "", 3, 83 63 37 10, cancel
  text "", 4, 6 54 154 8, center
  text "", 5, 6 11 48 8
  text "", 6, 6 30 48 8
  text "", 7, 54 11 107 16
  text "", 8, 54 30 107 8
  text "", 9, 6 43 48 8
  text "", 10, 54 43 107 8
}

dialog msnconv {
  title $msnreadini(conversation,dtitle)
  icon $msnmirc.icon, index
  size -1 -1 238 153
  option dbu
  tab "Tab 1", 8, -5 -21 248 232
  tab "Tab 2", 9
  tab "Tab 3", 10
  list 1, 1 2 179 10
  list 19, 195 2 50 10
  box "", 2, -4 12 250 4
  button "", 5, 196 142 30 10, tab 8 default
  button "i", 6, 227 142 10 10, tab 8
  button "x", 7, 227 142 10 10, tab 8 hide
  box "", 3, 1 16 236 125, tab 8
  edit "", 4, 1 142 194 10, tab 8 autohs limit 300
  text "", 13, 3 19 230 8, tab 9
  list 11, 1 30 236 122, tab 9 size
  box "", 12, 1 153 236 23, tab 8
  list 14, 1 18 236 123, tab 10 size
  button "", 15, 199 142 37 10, tab 10
  icon 101, 2 157 9 9, $msn.emoticons(1),0, tab 8 noborder
  icon 102, 11 157 9 9, $msn.emoticons(2),0, tab 8 noborder
  icon 103, 20 157 9 9, $msn.emoticons(3),0, tab 8 noborder
  icon 104, 29 157 9 9, $msn.emoticons(4),0, tab 8 noborder
  icon 105, 38 157 9 9, $msn.emoticons(5),0, tab 8 noborder
  icon 106, 47 157 9 9, $msn.emoticons(6),0, tab 8 noborder
  icon 107, 56 157 9 9, $msn.emoticons(7),0, tab 8 noborder
  icon 108, 65 157 9 9, $msn.emoticons(8),0, tab 8 noborder
  icon 109, 74 157 9 9, $msn.emoticons(9),0, tab 8 noborder
  icon 110, 83 157 9 9, $msn.emoticons(10),0, tab 8 noborder
  icon 111, 92 157 9 9, $msn.emoticons(11),0, tab 8 noborder
  icon 112, 101 157 9 9, $msn.emoticons(12),0, tab 8 noborder
  icon 113, 110 157 9 9, $msn.emoticons(13),0, tab 8 noborder
  icon 114, 119 157 9 9, $msn.emoticons(14),0, tab 8 noborder
  icon 115, 128 157 9 9, $msn.emoticons(15),0, tab 8 noborder
  icon 116, 137 157 9 9, $msn.emoticons(16),0, tab 8 noborder
  icon 117, 146 157 9 9, $msn.emoticons(17),0, tab 8 noborder
  icon 118, 155 157 9 9, $msn.emoticons(18),0, tab 8 noborder
  icon 119, 164 157 9 9, $msn.emoticons(19),0, tab 8 noborder
  icon 120, 173 157 9 9, $msn.emoticons(20),0, tab 8 noborder
  icon 121, 182 157 9 9, $msn.emoticons(21),0, tab 8 noborder
  icon 122, 191 157 9 9, $msn.emoticons(22),0, tab 8 noborder
  icon 123, 200 157 9 9, $msn.emoticons(23),0, tab 8 noborder
  icon 124, 209 157 9 9, $msn.emoticons(24),0, tab 8 noborder
  icon 151, 218 157 9 9, $msn.emoticons(51),0, tab 8 noborder
  icon 152, 227 157 9 9, $msn.emoticons(52),0, tab 8 noborder
  icon 125, 2 166 9 9, $msn.emoticons(25),0, tab 8 noborder
  icon 126, 11 166 9 9, $msn.emoticons(26),0, tab 8 noborder
  icon 127, 20 166 9 9, $msn.emoticons(27),0, tab 8 noborder
  icon 128, 29 166 9 9, $msn.emoticons(28),0, tab 8 noborder
  icon 129, 38 166 9 9, $msn.emoticons(29),0, tab 8 noborder
  icon 130, 47 166 9 9, $msn.emoticons(30),0, tab 8 noborder
  icon 131, 56 166 9 9, $msn.emoticons(31),0, tab 8 noborder
  icon 132, 65 166 9 9, $msn.emoticons(32),0, tab 8 noborder
  icon 133, 74 166 9 9, $msn.emoticons(33),0, tab 8 noborder
  icon 134, 83 166 9 9, $msn.emoticons(34),0, tab 8 noborder
  icon 135, 92 166 9 9, $msn.emoticons(35),0, tab 8 noborder
  icon 136, 101 166 9 9, $msn.emoticons(36),0, tab 8 noborder
  icon 137, 110 166 9 9, $msn.emoticons(37),0, tab 8 noborder
  icon 138, 119 166 9 9, $msn.emoticons(38),0, tab 8 noborder
  icon 139, 128 166 9 9, $msn.emoticons(39),0, tab 8 noborder
  icon 140, 137 166 9 9, $msn.emoticons(40),0, tab 8 noborder
  icon 141, 146 166 9 9, $msn.emoticons(41),0, tab 8 noborder
  icon 142, 155 166 9 9, $msn.emoticons(42),0, tab 8 noborder
  icon 143, 164 166 9 9, $msn.emoticons(43),0, tab 8 noborder
  icon 144, 173 166 9 9, $msn.emoticons(44),0, tab 8 noborder
  icon 145, 182 166 9 9, $msn.emoticons(45),0, tab 8 noborder
  icon 146, 191 166 9 9, $msn.emoticons(46),0, tab 8 noborder
  icon 147, 200 166 9 9, $msn.emoticons(47),0, tab 8 noborder
  icon 148, 209 166 9 9, $msn.emoticons(48),0, tab 8 noborder
  icon 149, 218 166 9 9, $msn.emoticons(49),0, tab 8 noborder
  icon 150, 227 166 9 9, $msn.emoticons(50),0, tab 8 noborder
}

dialog msnconf {
  title $msnreadini(configs,dtitle)
  icon $msnmirc.icon, index
  size -1 -1 208 161
  option dbu
  box "", 1, -1 12 211 4
  list 2, 1 2 206 10, size
  button "", 50, 134 151 37 10, ok
  button "", 51, 171 151 37 10, cancel
  tab "", 3, -17 -21 229 202
  text "", 6, 2 18 205 15, tab 3 center
  check "", 7, 10 41 190 10, tab 3 
  check "", 8, 10 51 190 10, tab 3 
  check "", 9, 10 61 190 10, tab 3 
  check "", 17, 10 71 190 10, tab 3 
  box "", 10, 3 92 202 33, tab 3
  radio "", 11, 10 101 186 10, group tab 3 
  radio "", 12, 10 111 186 10, tab 3 
  text "", 13, 3 132 102 8, tab 3 right
  combo 14, 107 130 64 50, tab 3 size drop
  text "", 15, 10 83 147 8, tab 3 right
  edit "", 16, 158 82 25 10, tab 3
  tab "", 4
  text "", 18, 2 18 205 15, tab 4 center
  check "", 19, 10 41 190 10, tab 4 
  check "", 20, 10 51 190 10, tab 4 
  check "", 21, 10 61 190 10, tab 4 
  check "", 22, 10 71 190 10, tab 4 
  check "", 30, 10 81 190 10, tab 4 
  box "", 23, 3 92 202 33, tab 4
  radio "", 24, 10 101 188 10, group tab 4 
  check "", 25, 10 131 59 10, tab 4 
  edit "", 26, 70 131 125 10, tab 4 autohs disable
  button "?", 27, 195 131 10 10, tab 4
  radio "", 28, 10 111 188 10, tab 4 
  box "", 29, -1 145 211 4
}

dialog msnaddu {
  title $msnreadini(other,dtitle1)
  icon $msnmirc.icon, index
  size -1 -1 142 33
  option dbu
  button "", 1, 105 23 37 10, cancel
  button "", 2, 68 23 37 10, ok
  text "", 3, 1 2 139 8
  edit "", 4, 2 12 138 10, autohs
}

dialog msnnick {
  title $msnreadini(other,dtitle2)
  icon $msnmirc.icon, index
  size -1 -1 142 33
  option dbu
  edit "", 4, 2 12 138 10, autohs limit 128
  button "", 1, 105 23 37 10, cancel
  button "", 2, 68 23 37 10, ok
  text "", 3, 1 2 139 8
}

dialog msnlogin {
  title $msnreadini(login,dtitle)
  icon $msnmirc.icon, index
  size -1 -1 142 53
  option dbu
  edit "", 5, 2 12 138 10, autohs
  text "", 3, 1 4 139 8
  edit "", 6, 2 32 138 10, autohs pass
  text "", 4, 1 24 139 8
  button "", 1, 105 43 37 10, cancel
  button "", 2, 68 43 37 10, ok
}

dialog msnabout {
  title $msnreadini(about,dtitle)
  icon $msnmirc.icon, index
  size -1 -1 176 142
  option dbu
  icon 1, 1 89 174 52, $msnmirc.logo,0
  text "", 2, 10 12 64 8, right
  text "", 3, 77 12 97 8
  text "", 4, 10 22 64 8, right
  text "", 5, 77 22 97 8
  text "", 6, 10 32 64 8, right
  text "", 7, 77 32 97 8
  text "", 8, 10 42 64 8, right
  text "", 9, 77 42 97 8
  text "", 10, 10 52 64 8, right
  text "", 11, 77 52 97 8
  text "", 12, 10 72 64 8, right
  text "", 13, 77 72 97 8
}

;;;DIALOG EVENTS

on *:dialog:msnabout:init:*:{
  did -a $dname 2 $msnreadini(about,version)
  did -a $dname 3 %msn.version
  did -a $dname 4 $msnreadini(about,released)
  did -a $dname 5 %msn.released
  did -a $dname 6 $msnreadini(about,coded1)
  did -a $dname 7 $msnreadini(about,coded2)
  did -a $dname 8 $msnreadini(about,email1)
  did -a $dname 9 $msnreadini(about,email2)
  did -a $dname 10 $msnreadini(about,website1)
  did -a $dname 11 $msnreadini(about,website2)
  did -a $dname 12 $msnreadini(about,translated1)
  did -a $dname 13 $msnreadini(about,translated2)
}

on *:dialog:msnnick:init:*:{
  msnmdxi
  msnmdx SetBorderStyle $dname 1,2 staticedge
  did -a $dname 1 $msnreadini(other,cancel)
  did -a $dname 2 $msnreadini(other,ok)
  did -a $dname 3 $msnreadini(other,text2)
  if ($dialog(msnmirc)) { did -a $dname 4 $did(msnmirc,4) }
}
on *:dialog:msnnick:sclick:*:{
  if ($did == 2) && ($did(4)) { msn.nick $did(4) }
}
on *:dialog:msnaddu:init:*:{
  msnmdxi
  msnmdx SetBorderStyle $dname 1,2 staticedge
  did -a $dname 1 $msnreadini(other,cancel)
  did -a $dname 2 $msnreadini(other,ok)
  did -a $dname 3 $msnreadini(other,text1)
}
on *:dialog:msnaddu:sclick:*:{
  if ($did == 2) && ($did(4)) { msn.gestion add $did(4) }
}
on *:dialog:msnlogin:init:*:{
  msnmdxi
  msnmdx SetBorderStyle $dname 1,2 staticedge
  did -a $dname 1 $msnreadini(login,cancel)
  did -a $dname 2 $msnreadini(login,ok)
  did -a $dname 3 $msnreadini(login,user)
  did -a $dname 4 $msnreadini(login,pass)
  did -a $dname 5 %msn.user
  did -a $dname 6 %msn.pass
}
on *:dialog:msnlogin:sclick:*:{
  if ($did == 2) && (*@*.* iswm $did(5)) && ($did(6)) {
    set %msn.user $did(5)
    set %msn.pass $did(6)
    msn.connect1
  }
}

on *:dialog:msnconf:init:*:{
  msnmdxi
  msnmdx SetBorderStyle $dname 50,51,27 staticedge
  msnmdx SetBorderStyle $dname 2
  msnmdx SetControlMDX 2 toolbar list nodivider flat wrap > $msnbars
  did -i $dname 2 1 bmpsize 16 16
  did -i $dname 2 1 setimage icon small $+($remove($scriptdir,$mircdir),icons\convlist.ico)
  did -i $dname 2 1 setimage icon small $+($remove($scriptdir,$mircdir),icons\invite.ico)
  did -a $dname 2 +agcx 1 $msnreadini(configs,tab1)
  did -a $dname 2 +agc 2 $msnreadini(configs,tab2)
  did -a $dname 50 $msnreadini(configs,but1)
  did -a $dname 51 $msnreadini(configs,but2)
  did -a $dname 6 $msnreadini(configs,text1)
  did -a $dname 7 $msnreadini(configs,status)
  if (%msn.constatus == offline) { did -c $dname 7 }
  did -a $dname 8 $msnreadini(configs,exp)
  if (%msn.expand == yes) { did -c $dname 8 }
  did -a $dname 9 $msnreadini(configs,sound)
  if (%msn.sounds == yes) { did -c $dname 9 }
  did -a $dname 11 $msnreadini(configs,rclick)
  did -a $dname 12 $msnreadini(configs,slclick)
  if (%msn.menu == rclick) { did -c $dname 11 }
  else { did -c $dname 12 }
  did -a $dname 13 $msnreadini(configs,lang)
  did -a $dname 14 Deutsche
  did -a $dname 14 English
  did -a $dname 14 Espanol
  did -a $dname 14 Français
  did -a $dname 14 Italiano
  did -a $dname 14 Portuguesa
  if (%msn.lang == msnen.ini) { did -c $dname 14 2 }
  elseif (%msn.lang == msnes.ini) { did -c $dname 14 3 }
  elseif (%msn.lang == msnfr.ini) { did -c $dname 14 4 }
  elseif (%msn.lang == msnit.ini) { did -c $dname 14 5 }
  elseif (%msn.lang == msnde.ini) { did -c $dname 14 1 }
  elseif (%msn.lang == msnpo.ini) { did -c $dname 14 6 }
  did -a $dname 15 $msnreadini(configs,conlap)
  did -a $dname 16 %msn.conlap
  did -a $dname 17 $msnreadini(configs,condesign)
  if (%msn.condesign == 3d) { did -c $dname 17 }
  did -a $dname 18 $msnreadini(configs,text2)
  did -a $dname 19 $msnreadini(configs,bold)
  if (%msn.msgbold == yes) { did -c $dname 19 }
  did -a $dname 20 $msnreadini(configs,crlf)
  if (%msn.conv.cr == yes) { did -c $dname 20 }
  did -a $dname 21 $msnreadini(configs,logs)
  if (%msn.logs == yes) { did -c $dname 21 }
  did -a $dname 22 $msnreadini(configs,min)
  if (%msn.convstatus == min) { did -c $dname 22 }
  did -a $dname 30 $msnreadini(configs,away)
  if (%msn.away == yes) { did -c $dname 30 }
  did -a $dname 24 $msnreadini(configs,email)
  did -a $dname 28 $msnreadini(configs,nick)
  if (%msn.convers.show == nick) { did -c $dname 28 }
  else { did -c $dname 24 }
  did -a $dname 25 $msnreadini(configs,theme)
  if (%msn.conv.head == perso) {
    did -c $dname 25
    did -e $dname 26
  }
  did -a $dname 26 %msn.conv.thperso
}
on *:dialog:msnconf:sclick:*:{
  if ($did == 50) {
    if ($did(7).state == 1) { set %msn.constatus offline }
    else { set %msn.constatus online }
    if ($did(8).state == 1) { set %msn.expand yes }
    else { set %msn.expand no }
    if ($did(9).state == 1) { set %msn.sounds yes }
    else { set %msn.sounds no }
    if ($did(11).state == 1) { set %msn.menu rclick }
    else { set %msn.menu slclick }
    if ($did(14).sel == 2) { set %msn.lang msnen.ini }
    elseif ($did(14).sel == 3) { set %msn.lang msnes.ini }
    elseif ($did(14).sel == 4) { set %msn.lang msnfr.ini }
    elseif ($did(14).sel == 5) { set %msn.lang msnit.ini }
    elseif ($did(14).sel == 1) { set %msn.lang msnde.ini }
    elseif ($did(14).sel == 6) { set %msn.lang msnpo.ini }
    else { set %msn.lang msnen.ini }
    if ($did(16)) { set %msn.conlap $did(16) }
    else { set %msn.conlap 3 }
    if ($did(17).state == 1) { set %msn.condesign 3d }
    else { set %msn.condesign 2d }
    if ($did(19).state == 1) { set %msn.msgbold yes }
    else { set %msn.msgbold no }
    if ($did(20).state == 1) { set %msn.conv.cr yes }
    else { set %msn.conv.cr no }
    if ($did(21).state == 1) { set %msn.logs yes }
    else { set %msn.logs no }
    if ($did(22).state == 1) { set %msn.convstatus min }
    else { set %msn.convstatus max }
    if ($did(30).state == 1) { set %msn.away yes }
    else { set %msn.away no }
    if ($did(28).state == 1) { set %msn.convers.show nick }
    else { set %msn.convers.show email }
    if ($did(25).state == 1) { set %msn.conv.head perso }
    else { set %msn.conv.head default }
    if ($did(26)) { set %msn.conv.thperso $did(26) }
    else { set %msn.conv.thperso <time> - <b><nick></b> : <br> }
  }
  elseif ($did == 25) {
    if ($did(25).state == 1) { did -e $dname 26 }
    else { did -b $dname 26 }
  }
  elseif ($did == 2) {
    did -f $dname $calc($did(2).sel + 1)
  }
  elseif ($did == 27) { msn.help tags }
}

on *:dialog:msnmirc:init:*:{
  msnmdxi
  msnmdx SetDialog $dname style border title sysmenu minbox
  msnmdx SetControlMDX $dname 50 positioner size minbox > $msndlg
  msnmdx SetControlMDX 1 treeview > $msnviews
  did -i $dname 1 1 iconsize normal small
  did -i $dname 1 1 seticon normal 0 0, $+ $scriptdiricons\groups1.ico
  did -i $dname 1 1 seticon normal 0 0, $+ $scriptdiricons\groups2.ico
  did -i $dname 1 1 seticon normal 0 0, $+ $scriptdiricons\1.ico
  did -i $dname 1 1 seticon normal 0 0, $+ $scriptdiricons\2.ico
  did -i $dname 1 1 seticon normal 0 0, $+ $scriptdiricons\3.ico
  did -i $dname 1 1 seticon normal 0 0, $+ $scriptdiricons\4.ico
  did -i $dname 1 1 seticon normal 0 0, $+ $scriptdiricons\5.ico
  did -i $dname 1 1 seticon normal 0 0, $+ $scriptdiricons\6.ico
  msnmdx SetControlMDX 2 ComboBoxEx drop > $msnviews
  did -i $dname 2 1 iconsize small
  did -i $dname 2 1 seticon 0 0, $+ $scriptdiricons\1.ico
  did -i $dname 2 1 seticon 0 0, $+ $scriptdiricons\2.ico
  did -i $dname 2 1 seticon 0 0, $+ $scriptdiricons\3.ico
  did -i $dname 2 1 seticon 0 0, $+ $scriptdiricons\4.ico
  did -i $dname 2 1 seticon 0 0, $+ $scriptdiricons\5.ico
  did -a $dname 2 1 1 0 0 $msnreadini(status,NLN)
  did -a $dname 2 2 2 0 0 $msnreadini(status,AWY)
  did -a $dname 2 4 4 0 0 $msnreadini(status,BSY)
  did -a $dname 2 2 2 0 0 $msnreadini(status,BRB)
  did -a $dname 2 2 2 0 0 $msnreadini(status,LUN)
  did -a $dname 2 3 3 0 0 $msnreadini(status,PHN)
  did -a $dname 2 5 5 0 0 $msnreadini(status,HDN)
  did -o $dname 110 $msnreadini(main,configs)
  did -o $dname 111 $msnreadini(main,logs)
  did -o $dname 120 $msnreadini(main,nickchg)
  did -o $dname 121 $msnreadini(main,addu)
  did -o $dname 130 $msnreadini(main,disconnect)
  did -o $dname 210 $msnreadini(main,help)
  did -o $dname 211 $msnreadini(main,about)
}
on *:dialog:msnmirc:menu:*:{
  if ($did == 110) { dialog -md msnconf msnconf }
  elseif ($did == 111) { run $+(",$scriptdirlogs,") }
  elseif ($did == 120) { dialog -md msnnick msnnick }
  elseif ($did == 121) { dialog -md msnaddu msnaddu }
  elseif ($did == 130) {
    dialog -x msnmirc
    sockclose msn.*
  }
  elseif ($did == 210) { msn.help }
  elseif ($did == 211) {
    if ($dialog(msnabout)) { dialog -x msnabout }
    dialog -md msnabout msnabout
  }
}
on *:dialog:msnmirc:sclick:*:{
  if ($did == 1) {
    var %a = $did(1,1)
    if ($gettok(%a,1,32) == rclick) { var %a = rclick select mouse $gettok(%a,3-,32) }
    tokenize 32 %a
    if (%msn.menu == $1) && ($0 == 5) && ($3 == mouse) {
      did -i msnmirc 1 1 cb root
      did -i msnmirc 1 1 cb $4
      var %a = $did(1,$5).text
      if ($gettok(%a,2,32) != 7) && ($gettok(%a,2,32) != 8) {
        msn.popup create $gettok($gettok(%a,2,9),1,13) 1 1
      }
      elseif ($gettok(%a,2,32) == 7) {
        msn.popup create $gettok($gettok(%a,2,9),1,13) 0 1
      }
      elseif ($gettok(%a,2,32) == 8) {
        msn.popup create $gettok($gettok(%a,2,9),1,13) 0 0
      }
    }
  }
  elseif ($did == 50) && ($gettok($did(50),1,32) == sizing) {
    tokenize 32 $did(50)
    msnmdx MoveControl $dname 1 * * $dialog(msnmirc).cw $calc($dialog(msnmirc).ch - 62)
    msnmdx MoveControl $dname 3 * * $calc($dialog(msnmirc).cw) *
    msnmdx MoveControl $dname 2 * * $calc($dialog(msnmirc).cw - 12) *
    msnmdx MoveControl $dname 4 * * $calc($dialog(msnmirc).cw - 17) *
  }
  elseif ($did == 2) {
    if ($did(2).sel == 2) { msn.status NLN }
    elseif ($did(2).sel == 3) { msn.status AWY }
    elseif ($did(2).sel == 4) { msn.status BSY }
    elseif ($did(2).sel == 5) { msn.status BRB }
    elseif ($did(2).sel == 6) { msn.status LUN }
    elseif ($did(2).sel == 7) { msn.status PHN }
    elseif ($did(2).sel == 8) { msn.status HDN }
  }
}
on *:dialog:msnmirc:close:*:{
  sockclose msn.log2
}

on *:dialog:msnconv*:init:*:{
  did -a $dname 5 $msnreadini(conversation,sendbut)
  did -a $dname 13 $msnreadini(conversation,convlist)
  did -a $dname 15 $msnreadini(conversation,invite)
  msnmdxi
  msnmdx SetFont 4 12 400 Tahoma
  msnmdx SetFont 6,7 20 400 Webdings
  msnmdx SetBorderStyle $dname 1,19
  msnmdx SetBorderStyle $dname 5,6,7,15 staticedge
  msnmdx SetControlMDX 1 toolbar list nodivider flat wrap > $msnbars
  did -i $dname 1 1 bmpsize 16 16
  did -i $dname 1 1 setimage icon small $+($remove($scriptdir,$mircdir),icons\disc.ico)
  did -i $dname 1 1 setimage icon small $+($remove($scriptdir,$mircdir),icons\convlist.ico)
  did -i $dname 1 1 setimage icon small $+($remove($scriptdir,$mircdir),icons\invite.ico)
  did -a $dname 1 +agcx 1 $msnreadini(conversation,tab1)
  did -a $dname 1 +agc 2 $msnreadini(conversation,tab2)
  did -a $dname 1 +agc 3 $msnreadini(conversation,tab3)
  msnmdx SetControlMDX 19 toolbar list nodivider flat wrap > $msnbars
  did -i $dname 19 1 bmpsize 16 16
  did -i $dname 19 1 setimage icon small $+($remove($scriptdir,$mircdir),icons\print.ico)
  did -a $dname 19 +a 1 $msnreadini(conversation,print)
  msnmdx SetControlMDX $dname 11 ListView report rowselect single infotip > $msnviews
  did -i $dname 11 1 headerdims 300 165
  did -i $dname 11 1 headertext $msnreadini(conversation,listv1) $chr(9) $msnreadini(conversation,listv2)
  msnmdx SetControlMDX $dname 14 ListView report rowselect single infotip showsel > $msnviews
  did -i $dname 14 1 headerdims 300 165
  did -i $dname 14 1 headertext $msnreadini(conversation,listv1) $chr(9) $msnreadini(conversation,listv2)
  did -f $dname 4
}

on *:dialog:msnconv*:sclick:*:{
  if ($did == 6) { did -h $dname 6 | did -v $dname 7 | dialog -bs $dname -1 -1 238 177 }
  elseif ($did == 7) { did -h $dname 7 | did -v $dname 6 | dialog -bs $dname -1 -1 238 153 }
  elseif ($did == 1) {
    did -f $dname $calc($did(1).sel + 6)
    if ($calc($did(1).sel + 6) == 10) { msn.tree invite $dname }
    else { did -r $dname 14 }
  }
  elseif ($did == 5) {
    if ($did(4)) {
      msn.msg send $dname $did(4)
      msn.html msg.from $dname $iif(%msn.convers.show == email,%msn.user,$did(msnmirc,4))
      msn.html msg.end $dname $did(4)
      did -r $dname 4
    }
  }
  elseif ($did == 19) {
    var %hwnd = $dll($scriptdirdll\nHTMLn.dll,item,$dialog( $+ $dname $+ ).hwnd id:3)
    var %r = $dll($scriptdirdll\nHTMLn.dll,select,%hwnd)
    var %s = $dll($scriptdirdll\nHTMLn.dll,print,$+($scriptdirlogs\,$dname,.html))
  }
  elseif ($did == 15) && ($did(11,2)) && ($sock($dname)) { msn.conv invite $dname $gettok($did(14,$did(14).sel),-1,32) }
  elseif ($did == 101) { did -a $dname 4 $+(:,$chr(41)) }
  elseif ($did == 102) { did -a $dname 4 :D }
  elseif ($did == 103) { did -a $dname 4 $+(;,$chr(41)) }
  elseif ($did == 104) { did -a $dname 4 :O }
  elseif ($did == 105) { did -a $dname 4 :P }
  elseif ($did == 106) { did -a $dname 4 $+($chr(40),h,$chr(41)) }
  elseif ($did == 107) { did -a $dname 4 :@ }
  elseif ($did == 108) { did -a $dname 4 :$ }
  elseif ($did == 109) { did -a $dname 4 :S }
  elseif ($did == 110) { did -a $dname 4 $+(:,$chr(40)) }
  elseif ($did == 111) { did -a $dname 4 $+(:',$chr(40)) }
  elseif ($did == 112) { did -a $dname 4 $+(:,$chr(124)) }
  elseif ($did == 113) { did -a $dname 4 $+($chr(40),6,$chr(41)) }
  elseif ($did == 114) { did -a $dname 4 $+($chr(40),a,$chr(41)) }
  elseif ($did == 115) { did -a $dname 4 $+($chr(40),l,$chr(41)) }
  elseif ($did == 116) { did -a $dname 4 $+($chr(40),u,$chr(41)) }
  elseif ($did == 117) { did -a $dname 4 $+($chr(40),m,$chr(41)) }
  elseif ($did == 118) { did -a $dname 4 $+($chr(40),@,$chr(41)) }
  elseif ($did == 119) { did -a $dname 4 $+($chr(40),&,$chr(41)) }
  elseif ($did == 120) { did -a $dname 4 $+($chr(40),s,$chr(41)) }
  elseif ($did == 121) { did -a $dname 4 $+($chr(40),*,$chr(41)) }
  elseif ($did == 122) { did -a $dname 4 $+($chr(40),~,$chr(41)) }
  elseif ($did == 123) { did -a $dname 4 $+($chr(40),e,$chr(41)) }
  elseif ($did == 124) { did -a $dname 4 $+($chr(40),8,$chr(41)) }
  elseif ($did == 125) { did -a $dname 4 $+($chr(40),f,$chr(41)) }
  elseif ($did == 126) { did -a $dname 4 $+($chr(40),w,$chr(41)) }
  elseif ($did == 127) { did -a $dname 4 $+($chr(40),o,$chr(41)) }
  elseif ($did == 128) { did -a $dname 4 $+($chr(40),k,$chr(41)) }
  elseif ($did == 129) { did -a $dname 4 $+($chr(40),g,$chr(41)) }
  elseif ($did == 130) { did -a $dname 4 $+($chr(40),^,$chr(41)) }
  elseif ($did == 131) { did -a $dname 4 $+($chr(40),p,$chr(41)) }
  elseif ($did == 132) { did -a $dname 4 $+($chr(40),i,$chr(41)) }
  elseif ($did == 133) { did -a $dname 4 $+($chr(40),c,$chr(41)) }
  elseif ($did == 134) { did -a $dname 4 $+($chr(40),t,$chr(41)) }
  elseif ($did == 135) { did -a $dname 4 $+($chr(40),$chr(123),$chr(41)) }
  elseif ($did == 136) { did -a $dname 4 $+($chr(40),$chr(125),$chr(41)) }
  elseif ($did == 137) { did -a $dname 4 $+($chr(40),b,$chr(41)) }
  elseif ($did == 138) { did -a $dname 4 $+($chr(40),d,$chr(41)) }
  elseif ($did == 139) { did -a $dname 4 $+($chr(40),z,$chr(41)) }
  elseif ($did == 140) { did -a $dname 4 $+($chr(40),x,$chr(41)) }
  elseif ($did == 141) { did -a $dname 4 $+($chr(40),y,$chr(41)) }
  elseif ($did == 142) { did -a $dname 4 $+($chr(40),n,$chr(41)) }
  elseif ($did == 143) { did -a $dname 4 :[ }
  elseif ($did == 144) { did -a $dname 4 $+($chr(40),pi,$chr(41)) }
  elseif ($did == 145) { did -a $dname 4 $+($chr(40),%,$chr(41)) }
  elseif ($did == 146) { did -a $dname 4 $+($chr(40),$chr(35),$chr(41)) }
  elseif ($did == 147) { did -a $dname 4 $+($chr(40),r,$chr(41)) }
  elseif ($did == 148) { did -a $dname 4 $+($chr(40),ip,$chr(41)) }
  elseif ($did == 149) { did -a $dname 4 $+($chr(40),mp,$chr(41)) }
  elseif ($did == 150) { did -a $dname 4 $+($chr(40),ap,$chr(41)) }
  elseif ($did == 151) { did -a $dname 4 $+($chr(40),co,$chr(41)) }
  elseif ($did == 152) { did -a $dname 4 $+($chr(40),au,$chr(41)) }
}

on *:dialog:msnconv.*:close:*:{
  msn.conv disable.edit $dname
  if ($sock($dname)) { sockwrite -n $dname OUT }
  if (%msn.logs == no) { .remove $+(",$scriptdirlogs\,$dname,.html,") }
  sockclose $dname
}

on *:dialog:msn.file.*:init:0:{
  did -a $dname 2 $msnreadini(fileaccept,yes)
  did -a $dname 3 $msnreadini(fileaccept,no)
  did -a $dname 4 $msnreadini(fileaccept,accept)
  did -a $dname 5 $msnreadini(fileaccept,filename)
  did -a $dname 6 $msnreadini(fileaccept,filesize)
  did -a $dname 7 $eval($+(%,msn.filename.,$gettok($dname,3,46)),2)
  did -a $dname 8 $round($calc($eval($+(%,msn.filesize.,$gettok($dname,3,46)),2) / 1024),1) $msnreadini(fileaccept,kb)
  did -a $dname 9 $msnreadini(fileaccept,sender)
  did -a $dname 10 $eval($+(%,msn.filesender.,$gettok($dname,3,46)),2)
}
on *:dialog:msn.file.*:sclick:*:{
  if ($did == 2) { msn.file.accept accepted $gettok($dname,3,46) $gettok($dname,4-,46) }
  elseif ($did == 3) { msn.file.accept declined $gettok($dname,3,46) $gettok($dname,4-,46) }
}

on *:dialog:msncon.*:init:0:{
  msnmdxi
  msnmdx SetBorderStyle $dname 2,3 staticedge
  did -a $dname 2 $msnreadini(conn,2)
  did -a $dname 3 $msnreadini(conn,3)
  msnmdx SetDialog $dname style $iif(%msn.condesign == 2d,border,dlgframe)
}
on *:dialog:msncon.*:sclick:*:{
  if ($did == 2) { msn.conv init $gettok($dname,2-,46) }
  elseif ($did == 3) { .timermsn. $+ $gettok($dname,2-,46) off }
}


;;;ALIASES

alias msn.connect1 {
  sockclose msn.log1
  sockopen msn.log1 messenger.hotmail.com 1863
  if ($dialog(msnmirc)) { dialog -c msnmirc msnmirc }
  dialog -md msnmirc msnmirc
}
alias msn.connect2 {
  sockclose msn.log2
  sockopen msn.log2 %msn.server2
}
alias msnmirc.icon { return $scriptdiricons\msnmirc.ico }
alias msnmirc.logo { return $scriptdirhelp\msnmirc.png }

alias msn.conv {
  if ($1 == init) && ($2) && ($sock(msn.log2)) {
    inc %msn.conv.inc
    set -u30 $+(%,msnconv.user.,%msn.conv.inc) $2
    set -u30 $+(%,msnconv.status.,%msn.conv.inc) inv
    sockwrite -n msn.log2 XFR %msn.conv.inc SB
  }
  elseif ($1 == connect) && ($0 == 5) && ($sock(msn.log2)) {
    set -u30 $+(%,msncki.,$5) $4
    sockclose $+(msnconv.,$5)
    sockopen $+(msnconv.,$5) $2 $3
  }
  elseif ($1 == ansconnect) && ($0 == 5) && ($sock(msn.log2)) {
    inc %msn.conv.inc
    set -u30 $+(%,msncki.,%msn.conv.inc) $4
    set -u30 $+(%,msnsesid.,%msn.conv.inc) $5
    sockclose $+(msnconv.,%msn.conv.inc)
    sockopen $+(msnconv.,%msn.conv.inc) $2 $3
  }
  elseif ($1 == loginv) && ($sock($2)) { sockwrite -n $2 USR 1 %msn.user $eval($+(%,msncki.,$gettok($2,-1,46)),2) }
  elseif ($1 == logans) && ($sock($2)) { sockwrite -n $2 ANS 1 %msn.user $eval($+(%,msncki.,$gettok($2,-1,46)),2) $eval($+(%,msnsesid.,$gettok($2,-1,46)),2) }
  elseif ($1 == disable.edit) {
    if ($dialog($2)) {
      did -rm $2 4
      did -b $2 5
    }
  }
  elseif ($1 == invite) && ($sock($2)) { sockwrite -n $2 CAL 15 $3 }
}

alias msnaddu {
  if (!$dialog(msnaddu)) { dialog -md msnaddu msnaddu }
}
alias msn.emoticons { return $+($scriptdir,emoticons\,$1,.bmp) }
alias msn.conn.icon { return $remove($scriptdir,$mircdir) $+ icons\conn.bmp }
alias msnmdxf { return $+(",$scriptdirdll\mdx.dll,") }
alias msnmdx { dll $msnmdxf $1- }
alias msnmdxi {
  msnmdx SetMircVersion $version
  msnmdx MarkDialog $dname
}
alias msnviews { return $scriptdirdll\views.mdx }
alias msnbars { return $scriptdirdll\bars.mdx }
alias msndlg { return $scriptdirdll\dialog.mdx }
alias msn.tree {
  if ($dialog(msnmirc)) {
    if ($1 == add) {
      did -i msnmirc 1 1 cb root $calc($2 + 2) 1
      did -a msnmirc 1 +c $msnreadini(icons,FLN) $msn.replace($4) $+ $chr(9) $3 $crlf $msnreadini(status,STATUS) $+ : $msnreadini(status,FLN)
    }
    elseif ($1 == replace) {
      did -i msnmirc 1 1 cb root
      var %a = $did(msnmirc,1).lines, %b = 2
      while (%b <= %a) {
        did -i msnmirc 1 1 cb %b
        var %c = $did(msnmirc,1).lines, %d = 2
        while (%d <= %c) {
          if ($+(*,$2,*) iswm $did(msnmirc,1,%d).text) {
            if ($3 == BL) {
              did -a msnmirc 1 +c $msnreadini(icons,$3) $gettok($gettok($did(msnmirc,1,%d).text,1,9),7-,32) $+ $chr(9) $2 $crlf $msnreadini(status,STATUS) $+ : $msnreadini(status,$3)
              did -d msnmirc 1 $calc(%d + 1)
            }
            elseif ($3 == UBL) {
              did -a msnmirc 1 +c $msnreadini(icons,$3) $gettok($gettok($did(msnmirc,1,%d).text,1,9),7-,32) $+ $chr(9) $2 $crlf $msnreadini(status,STATUS) $+ : $msnreadini(status,$3)
              did -d msnmirc 1 $calc(%d + 1)
            }
            elseif ($gettok($did(msnmirc,1,%d).text,2,32) != 8) {
              if ($3 != FLN) { did -i msnmirc 1 2 $msnreadini(icons,$3) $msn.replace($4) $+ $chr(9) $2 $crlf $msnreadini(status,STATUS) $+ : $msnreadini(status,$3) }
              else { did -a msnmirc 1 +c $msnreadini(icons,$3) $gettok($gettok($did(msnmirc,1,%d).text,1,9),7-,32) $+ $chr(9) $2 $crlf $msnreadini(status,STATUS) $+ : $msnreadini(status,$3) }
              did -d msnmirc 1 $calc(%d + 1)
            }
          }
          inc %d
        }
        did -i msnmirc 1 1 cb root
        inc %b
      }
    }
    elseif ($1 == rem) {
      did -i msnmirc 1 1 cb root
      var %a = $did(msnmirc,1).lines, %b = 2
      while (%b <= %a) {
        did -i msnmirc 1 1 cb %b
        var %c = $did(msnmirc,1).lines, %d = 2
        while (%d <= %c) {
          if ($+(*,$2,*) iswm $did(msnmirc,1,%d).text) { did -d msnmirc 1 %d }
          inc %d
        }
        did -i msnmirc 1 1 cb root
        inc %b
      }
    }
    elseif ($1 == iscon) {
      did -i msnmirc 1 1 cb root
      var %a = $did(msnmirc,1).lines, %b = 2
      while (%b <= %a) {
        did -i msnmirc 1 1 cb %b
        var %c = $did(msnmirc,1).lines, %d = 2
        while (%d <= %c) {
          if ($+(*,$2,*) iswm $did(msnmirc,1,%d).text) {
            if ($gettok($did(msnmirc,1,%d).text,2,32) == 7) { msn.con $gettok($gettok($did(msnmirc,1,%d).text,2,9),1,13) }
            else { break }
          }
          inc %d
        }
        did -i msnmirc 1 1 cb root
        inc %b
      }
    }
    elseif ($1 == invite) {
      did -i msnmirc 1 1 cb root
      var %a = $did(msnmirc,1).lines, %b = 2
      while (%b <= %a) {
        did -i msnmirc 1 1 cb %b
        var %c = $did(msnmirc,1).lines, %d = 2
        while (%d <= %c) {
          if ($gettok($did(msnmirc,1,%d).text,2,32) != 7) && ($gettok($did(msnmirc,1,%d).text,2,32) != 8) { did -a $2 14 $gettok($gettok($did(msnmirc,1,%d).text,1,9),6-,32) $chr(9) $gettok($gettok($did(msnmirc,1,%d).text,2,9),1,13) }
          inc %d
        }
        did -i msnmirc 1 1 cb root
        inc %b
      }
    }
  }
}
alias msnreadini {
  .fopen msnlang $+(",$scriptdirlang\,%msn.lang,")
  if (!$fopen(msnlang)) { return }
  .fseek msnlang 0
  .fseek -w msnlang $+([,$1,])
  if (!$feof) {
    var %p = $fopen(msnlang).pos
    .fseek -n msnlang
    .fseek -w msnlang $+([,*,])
    var %n = $fopen(msnlang).pos
    .fseek msnlang %p
    .fseek -w msnlang $+($2,=*)
    if ($fopen(msnlang).pos < %n) {
      var %a = $gettok($fread(msnlang),2-,61)
      .fclose msnlang
      return %a
    }
  }
  .fclose msnlang
}
alias msn.replace { return $remove($replace($1-,$+($chr(37),20),$chr(32),Ã©,é,Ã®,î,Ã¨,è,$+(Ã,$chr(160)),à,Ã§,ç,Ãª,ê,Ã¹,ù,Ã«,ë,Ã¯,ï,Ã‰,É,Ã€,À,Ãˆ,È,Ã´,ô,Ã¢,â,Ã°,°,Ã¸,Ø,Ã±,ñ,Î¨,?,â„¢,™,â€¢,•,Ã»,û,$+(â,$chr(44),¬),€),Â) }
alias msn.convert { return $remove($replace($1-,é,Ã©,û,Ã»,è,Ã¨,î,Ã®,à,$+(Ã,$chr(160)),ç,Ã§,ê,Ãª,ù,Ã¹,ë,Ã«,ï,Ã¯,É,Ã‰,À,Ã€,È,Ãˆ,ô,Ã´,â,Ã¢,°,Ã°,Ø,Ã¸,ñ,Ã±,™,â„¢,•,â€¢,€,$+(â,$chr(44),¬)),Â) }

alias msn.popup {
  if $sock(msn.log2) {
    if ($1 == create) {
      var %a = $gettok($dll($remove($scriptdirdll\MPopup.dll,$mircdir),MPCreateMenu,msnmirc),2,32)
      var %b = $dll($remove($scriptdirdll\MPopup.dll,$mircdir),MPAddIcon,msnmirc > $shortfn($scriptdiricons\invite.ico) > 0)
      var %b = $dll($remove($scriptdirdll\MPopup.dll,$mircdir),MPAddIcon,msnmirc > $shortfn($scriptdiricons\profile.ico) > 0)
      var %b = $dll($remove($scriptdirdll\MPopup.dll,$mircdir),MPAddIcon,msnmirc > $shortfn($scriptdiricons\delete.ico) > 0)
      var %b = $dll($remove($scriptdirdll\MPopup.dll,$mircdir),MPAddIcon,msnmirc > $shortfn($scriptdiricons\6.ico) > 0)
      var %b = $dll($remove($scriptdirdll\MPopup.dll,$mircdir),MPAddIcon,msnmirc > $shortfn($scriptdiricons\1.ico) > 0)
      var %b = $dll($remove($scriptdirdll\MPopup.dll,$mircdir),MPAddIcon,msnmirc > $shortfn($scriptdiricons\add.ico) > 0)
      var %b = $dll($remove($scriptdirdll\MPopup.dll,$mircdir),MPAddItem,%a > 1 0 1 $2)
      var %b = $dll($remove($scriptdirdll\MPopup.dll,$mircdir),MPAddItem,%a > 2 0 0 -)
      if ($3 == 1) && ($did(msnmirc,2).sel != 8) {
        var %b = $dll($remove($scriptdirdll\MPopup.dll,$mircdir),MPAddItem,%a > 3 1 0 $msnreadini(popup,conversation) > msn.conv init $2)
      }
      var %b = $dll($remove($scriptdirdll\MPopup.dll,$mircdir),MPAddItem,%a > 4 2 0 $msnreadini(popup,profile) > url -an $+(http://members.msn.com/default.msnw?mem=,$2) )
      var %b = $dll($remove($scriptdirdll\MPopup.dll,$mircdir),MPAddItem,%a > 5 0 0 -)
      var %b = $dll($remove($scriptdirdll\MPopup.dll,$mircdir),MPAddItem,%a > 6 3 0 $msnreadini(popup,delete) > msn.gestion remove $2)
      if ($4 == 1) {
        var %b = $dll($remove($scriptdirdll\MPopup.dll,$mircdir),MPAddItem,%a > 7 4 0 $msnreadini(popup,block) > msn.gestion block $2)
      }
      else {
        var %b = $dll($remove($scriptdirdll\MPopup.dll,$mircdir),MPAddItem,%a > 8 5 0 $msnreadini(popup,unblock) > msn.gestion unblock $2)
      }
      var %b = $dll($remove($scriptdirdll\MPopup.dll,$mircdir),MPAddItem,%a > 9 0 0 -)
      var %b = $dll($remove($scriptdirdll\MPopup.dll,$mircdir),MPAddItem,%a > 10 6 0 $msnreadini(popup,add) > msnaddu)
      var %b = $dll($remove($scriptdirdll\MPopup.dll,$mircdir),MPopup,msnmirc > $calc($dialog(msnmirc).x + $mouse.x + 6) $calc($dialog(msnmirc).y + $mouse.y + 44))
    }
  }
}

alias msn.msg {
  if ($1 == send) && ($sock($2)) && ($3) {
    var %a = $msn.convert($3-)
    sockwrite -n $2 MSG 4 N $calc($len(%a) + 115)
    sockwrite -n $2 MIME-Version: 1.0
    sockwrite -n $2 Content-Type: text/plain; charset=UTF-8
    sockwrite -n $2 X-MMS-IM-Format: FN=Tahoma; $iif(%msn.msgbold == yes,EF=B;,EF=N;) CO=0; CS=0; PF=22
    sockwrite -n $2
    sockwrite $2 %a
  }
}
alias msn.file.accept {
  if ($1 == declined) {
    sockwrite -n $3 MSG 16 N $calc(143 + $len($eval($+(%,msn.filecookie.,$2),2)))
    sockwrite -n $3 MIME-Version: 1.0
    sockwrite -n $3 Content-Type: text/x-msmsgsinvite; charset=UTF-8
    sockwrite -n $3
    sockwrite -n $3 Invitation-Command: CANCEL
    sockwrite -n $3 Invitation-Cookie: $eval($+(%,msn.filecookie.,$2),2)
    sockwrite -n $3 Cancel-Code: REJECT
    sockwrite -n $3
  }
  elseif ($1 == accepted) {
    sockwrite -n $3 MSG 16 N $calc(175 + $len($eval($+(%,msn.filecookie.,$2),2)))
    sockwrite -n $3 MIME-Version: 1.0
    sockwrite -n $3 Content-Type: text/x-msmsgsinvite; charset=UTF-8
    sockwrite -n $3
    sockwrite -n $3 Invitation-Command: ACCEPT
    sockwrite -n $3 Invitation-Cookie: $eval($+(%,msn.filecookie.,$2),2)
    sockwrite -n $3 Launch-Application: TRUE
    sockwrite -n $3 Request-Data: IP-Address:
    sockwrite -n $3
  }
  elseif ($1 == choice) { dialog -mdo $+(msn.file.,$3,.,$2) msn.file.accept }
  elseif ($1 == connect) { sockopen $+(msn.fileget.,$2) $eval($+(%,msn.fileip.,$2),2) $eval($+(%,msn.fileport.,$2),2) }
}

alias msn.html {
  var %a = $1-2 $replace($3-,<,&lt;,>,&gt;)
  tokenize 32 %a
  if ($1 == start) {
    write -c $+(",$scriptdirlogs\,$2,.html")
    write $+(",$scriptdirlogs\,$2,.html") <html><body><a name="top"><font face="Tahoma" size="1"><center><a href="#bottom"> $+ $msnreadini(conversation,bottom) $+ </a></center>
    write $+(",$scriptdirlogs\,$2,.html") </font><a name="bottom"></body></html>
    var %hwnd = $dll($scriptdirdll\nHTMLn.dll,item,$dialog( $+ $2 $+ ).hwnd id:3)
    if (E* !iswm %hwnd) {
      var %q = $dll($scriptdirdll\nHTMLn.dll,attach,%hwnd)
    }
  }
  elseif ($1 == join) {
    write $+(-l,$lines($+(",$scriptdirlogs\,$2,.html"))) $+(",$scriptdirlogs\,$2,.html") <hr style="height: 1; color: #000000"><img src="../emoticons/17.bmp" width="19" height="19"><b> $msn.emoticonsrep($3-) $msnreadini(conversation,joi) $+ </b><hr style="height: 1; color: #000000">
    write $+(",$scriptdirlogs\,$2,.html") </font><a name="bottom"></body></html>
  }
  elseif ($1 == leave) {
    write $+(-l,$lines($+(",$scriptdirlogs\,$2,.html"))) $+(",$scriptdirlogs\,$2,.html") <hr style="height: 1; color: #000000"><img src="../icons/part.bmp" width="19" height="19"><b> $msn.emoticonsrep($3-) $msnreadini(conversation,bye) $+ </b><hr style="height: 1; color: #000000">
    write $+(",$scriptdirlogs\,$2,.html") </font><a name="bottom"></body></html>
  }
  elseif ($1 == msg.from) { write $+(-l,$lines($+(",$scriptdirlogs\,$2,.html"))) $+(",$scriptdirlogs\,$2,.html") $replace($iif(%msn.conv.head == perso,%msn.conv.thperso,%msn.conv.thdefault),<nick>,$iif($len($3-) >= 60,$+($msn.emoticonsrep($left($3-,60)),...),$msn.emoticonsrep($3-)),<time>,$time) }
  elseif ($1 == msg.multi) { write $+(",$scriptdirlogs\,$2,.html") &nbsp;&nbsp;&nbsp; $msn.emoticonsrep($3-) <br> }
  elseif ($1 == msg.end) {
    write $+(",$scriptdirlogs\,$2,.html") &nbsp;&nbsp;&nbsp; $msn.emoticonsrep($3-) $+ <br> $iif(%msn.conv.cr == yes,<br>)
    write $+(",$scriptdirlogs\,$2,.html") </font><a name="bottom"></body></html>
    if (%msn.sounds == yes) { msnwav msg }
  }
  var %hwnd = $dll($scriptdirdll\nHTMLn.dll,item,$dialog( $+ $2 $+ ).hwnd id:3)
  var %r = $dll($scriptdirdll\nHTMLn.dll,select,%hwnd)
  var %s = $dll($scriptdirdll\nHTMLn.dll,navigate,$+($scriptdirlogs\,$2,.html#bottom))
}
alias msn.emoticonsrep {
  var %a = $replace($1-,$+(:,$chr(41)),$msn.emo(1),$+(:-,$chr(41)),$msn.emo(1),:-D,$msn.emo(2),:D,$msn.emo(2),$+(;,$chr(41)),$msn.emo(3),;-,$chr(41)),$msn.emo(3))
  var %a = $replace(%a,:-O,$msn.emo(4),:o,$msn.emo(4),:-P,$msn.emo(5),:P,$msn.emo(5),$+($chr(40),h,$chr(41)),$msn.emo(6),:@,$msn.emo(7),:-@,$msn.emo(7),:$,$msn.emo(8),:-$,$msn.emo(8))
  var %a = $replace(%a,:S,$msn.emo(9),:-S,$msn.emo(9),$+(:,$chr(40)),$msn.emo(10),$+(:-,$chr(40)),$msn.emo(10),$+(:',$chr(40)),$msn.emo(11),$+(:,$chr(124)),$msn.emo(12),$+(:-,$chr(124)),$msn.emo(12))
  var %a = $replace(%a,$+($chr(40),6,$chr(41)),$msn.emo(13),$+($chr(40),a,$chr(41)),$msn.emo(14),$+($chr(40),l,$chr(41)),$msn.emo(15),$+($chr(40),u,$chr(41)),$msn.emo(16),$+($chr(40),m,$chr(41)),$msn.emo(17))
  var %a = $replace(%a,$+($chr(40),@,$chr(41)),$msn.emo(18),$+($chr(40),&,$chr(41)),$msn.emo(19),$+($chr(40),s,$chr(41)),$msn.emo(20),$+($chr(40),*,$chr(41)),$msn.emo(21),$+($chr(40),~,$chr(41)),$msn.emo(22))
  var %a = $replace(%a,$+($chr(40),e,$chr(41)),$msn.emo(23),$+($chr(40),8,$chr(41)),$msn.emo(24),$+($chr(40),f,$chr(41)),$msn.emo(25),$+($chr(40),w,$chr(41)),$msn.emo(26),$+($chr(40),o,$chr(41)),$msn.emo(27))
  var %a = $replace(%a,$+($chr(40),k,$chr(41)),$msn.emo(28),$+($chr(40),g,$chr(41)),$msn.emo(29),$+($chr(40),^,$chr(41)),$msn.emo(30),$+($chr(40),p,$chr(41)),$msn.emo(31),$+($chr(40),i,$chr(41)),$msn.emo(32))
  var %a = $replace(%a,$+($chr(40),c,$chr(41)),$msn.emo(33),$+($chr(40),t,$chr(41)),$msn.emo(34),$+($chr(40),$chr(123),$chr(41)),$msn.emo(35),$+($chr(40),$chr(125),$chr(41)),$msn.emo(36))
  var %a = $replace(%a,$+($chr(40),b,$chr(41)),$msn.emo(37),$+($chr(40),d,$chr(41)),$msn.emo(38),$+($chr(40),z,$chr(41)),$msn.emo(39),$+($chr(40),x,$chr(41)),$msn.emo(40),$+($chr(40),y,$chr(41)),$msn.emo(41))
  var %a = $replace(%a,$+($chr(40),n,$chr(41)),$msn.emo(42),:-[,$msn.emo(43),:[,$msn.emo(43),$+($chr(40),pi,$chr(41)),$msn.emo(44),$+($chr(40),%,$chr(41)),$msn.emo(45),$+($chr(40),$chr(35),$chr(41)),$msn.emo(46))
  var %a = $replace(%a,$+($chr(40),r,$chr(41)),$msn.emo(47),$+($chr(40),ip,$chr(41)),$msn.emo(48),$+($chr(40),mp,$chr(41)),$msn.emo(49),$+($chr(40),ap,$chr(41)),$msn.emo(50),$+($chr(40),co,$chr(41)),$msn.emo(51),$+($chr(40),au,$chr(41)),$msn.emo(52))
  return %a
}
alias msn.emo { return <img src="../emoticons/ $+ $1 $+ .bmp" width="19" height="19"> }
alias msn.con {
  if ($dialog($+(msncon.,$1))) { dialog -x $+(msncon.,$1) }
  dialog -mdo $+(msncon.,$1) msncon
  dialog -s $+(msncon.,$1) $calc($window(-2).x + ($window(-2).w - $dialog($+(msncon.,$1)).w) - 4) $calc($window(-2).y + ($window(-2).h - $dialog($+(msncon.,$1)).h) - 4) -1 -1
  did -a $+(msncon.,$1) 1 $1 $msnreadini(conn,text)
  if (%msn.sounds == yes) { msnwav connect }
  .timermsn. $+ $1 1 %msn.conlap dialog -c $+(msncon.,$1)
}
alias msnwav {
  if ($1 == msg) { splay $+(",$scriptdirsounds\newmsg.wav,") }
  elseif ($1 == connect) { splay $+(",$scriptdirsounds\connect.wav,") }
}
alias msn.gestion {
  if ($sock(msn.log2)) {
    if ($1 == block) {
      sockwrite -n msn.log2 REM 18 AL $2
      sockwrite -n msn.log2 ADD 19 BL $2 $2
    }
    elseif ($1 == unblock) {
      sockwrite -n msn.log2 REM 18 BL $2
      sockwrite -n msn.log2 ADD 19 AL $2 $2
    }
    elseif ($1 == remove) {
      sockwrite -n msn.log2 REM 18 FL $2
      msn.tree rem $2
    }
    elseif ($1 == add) {
      if (*@*.* iswm $2) {
        sockwrite -n msn.log2 ADD 18 AL $2 $2
        sockwrite -n msn.log2 ADD 19 FL $2 $2
        msn.tree add 1 $2 $2
      }
    }
  }
}
alias msn.nick {
  if ($sock(msn.log2)) {
    sockwrite -n msn.log2 REA 22 %msn.user $msn.convert($replace($1-,$chr(32),$+($chr(37),20)))
  }
}
alias msn.status {
  if ($sock(msn.log2)) && ($1) && $dialog(msnmirc) {
    var %a = $did(msnmirc,2).sel, %b = %msn.status
    if (!%a) {
      sockwrite -n msn.log2 CHG 6 $1
      if ($dialog(msnmirc)) {
        if ($1 == NLN) { did -c msnmirc 2 2 }
        elseif ($1 == AWY) { did -c msnmirc 2 3 }
        elseif ($1 == BSY) { did -c msnmirc 2 4 }
        elseif ($1 == BRB) { did -c msnmirc 2 5 }
        elseif ($1 == LUN) { did -c msnmirc 2 6 }
        elseif ($1 == PHN) { did -c msnmirc 2 7 }
        elseif ($1 == HDN) { did -c msnmirc 2 8 }
      }
    }
    elseif (%a == 2) { var %a = NLN }
    elseif (%a == 3) { var %a = AWY }
    elseif (%a == 4) { var %a = BSY }
    elseif (%a == 5) { var %a = BRB }
    elseif (%a == 6) { var %a = LUN }
    elseif (%a == 7) { var %a = PHN }
    elseif (%a == 8) { var %a = HDN }
    if (%a != %b) { sockwrite -n msn.log2 CHG 6 $1 }
  }
}
alias msn.unload {
  unset %msn.*
  unload -rs msnmirc.mrc
}
alias msn.help {
  if (%msn.lang == msnfr.ini) { url -an $+(",$scriptdirhelp\msnmircfr.hlp.html,$iif($1 == tags,#tags",")) }
  else { url -an $+(",$scriptdirhelp\msnmirc.hlp.html,$iif($1 == tags,#tags",")) }
}

;;;SOCKETS

on *:sockopen:msn.log1:{
  sockwrite -n $sockname VER 1 MSNP9 CVR0
}
on *:sockread:msn.log1:{
  sockread %temp
  tokenize 32 %temp
  if ($1 == VER) { sockwrite -n $sockname CVR 2 0x0409 win 5.1 i386 MSNMIRC 2.02 MSMSGS %msn.user }
  elseif ($1 == CVR) { sockwrite -n $sockname USR 3 TWN I %msn.user }
  elseif ($1 == XFR) {
    set %msn.server2 $replace($4,$chr(58),$chr(32))
    msn.connect2
  }
}

on *:sockopen:msn.log2:{
  sockwrite -n $sockname VER 1 MSNP9 CVR0
}
on *:sockread:msn.log2:{
  sockread %temp
  tokenize 32 %temp
  if ($1 == VER) { sockwrite -n $sockname CVR 2 0x0409 win 5.1 i386 MSNMIRC 2.02 MSMSGS %msn.user }
  elseif ($1 == LSG) && ($dialog(msnmirc)) { did -o msnmirc 1 $calc($2 + 2) $iif(%msn.expand == yes,+be,+b) 1 2 $msn.replace($3) }
  elseif ($1 == LST) && ($0 == 5) {
    :lst
    msn.tree add $5 $2 $3
    if ($4 == 13) || ($4 == 10) || ($4 == 12) { msn.tree replace $2 BL }
    :nolst
    sockread -f %temp
    tokenize 32 %temp
    if (!$1-) {
      if (%msn.constatus == offline) {
        msn.status HDN
        set %msn.status HDN
      }
      else {
        msn.status NLN
        set %msn.status NLN
      }
    }
    elseif ($1 == LST) && ($0 == 5) { goto lst }
    else { goto nolst }
  }
  elseif ($1 == ILN) { msn.tree replace $4 $3 $5 }
  elseif ($1 == NLN) {
    msn.tree iscon $3
    msn.tree replace $3 $2 $4
  }
  elseif ($1 == FLN) { msn.tree replace $2 $1 }
  elseif ($1 == CVR) { sockwrite -n $sockname USR 3 TWN I %msn.user }
  elseif ($1 == XFR) {
    if ($3 == SB) { msn.conv connect $replace($4,$chr(58),$chr(32)) $6 $2 }
    elseif ($3 == NS) { 
      set %msn.server2 $replace($4,$chr(58),$chr(32))
      msn.connect2
    }
  }
  elseif ($1 == USR) && ($2 == 3) && ($3 == TWN) {
    if ($gettok(%msn.user,-1,64) == hotmail.com) { set %msn.logadd loginnet.passport.com }
    elseif ($gettok(%msn.user,-1,64) == msn.com) { set %msn.logadd msnialogin.passport.com }
    else { set %msn.logadd login.passport.com }
    sockclose msn.tweenie
    sockopen msn.tweenie %msn.logadd 80
    sockmark msn.tweenie $1-
  }
  elseif ($1 == CHG) { set %msn.status $3 }
  elseif ($1 == USR) && ($2 == 4) && ($3 == OK) {
    if ($dialog(msnmirc)) { did -ra msnmirc 4 $msn.replace($replace($5,$+($chr(37),20),$chr(32))) }
    sockwrite -n $sockname SYN 1 0
  }
  elseif ($1 == REA) {
    if ($dialog(msnmirc)) { did -ra msnmirc 4 $msn.replace($replace($5,$+($chr(37),20),$chr(32))) }
  }
  elseif ($1 == ADD) {
    if ($3 == BL) { msn.tree replace $5 BL }
  }
  elseif ($1 == REM) {
    if ($3 == BL) { msn.tree replace $5 UBL }
  }
  elseif ($1 == SYN) {
    var %syn = 1
    while (%syn < $5) {
      did -a msnmirc 1
      inc %syn
    }
  }
  elseif ($1 == RNG) { msn.conv ansconnect $replace($3,$chr(58),$chr(32)) $5 $2 }
  elseif ($1 == CHL) {
    sockwrite -n $sockname QRY 10 msmsgs@msnmsgr.com 32
    sockwrite $sockname $md5($3 $+ Q1P7W2E4J9R8U3S5)
  }
}

on *:sockopen:msnconv.*:{
  if (!$sockerr) {
    if ($eval($+(%,msnconv.status.,$gettok($sockname,-1,46)),2) == inv) { msn.conv loginv $sockname }
    else { msn.conv logans $sockname }
    dialog -md $sockname msnconv
    if (%msn.convstatus == min) { dialog -i $sockname }
    msn.html start $sockname
  }
}

on *:sockread:msnconv.*:{
  sockread %temp
  tokenize 32 %temp
  if ($1 == USR) && ($3 == OK) { sockwrite -n $sockname CAL 2 $eval($+(%,msnconv.user.,$gettok($sockname,-1,46)),2) }
  elseif ($1 == ANS) && ($3 == OK) {
    if ($away == $true) && (%msn.away == yes) {
      var %msn.awaymsg = $replace($msnreadini(conversation,away),<awaytime>,$duration($awaytime),<awayreason>,$awaymsg)
      msn.msg send $sockname %msn.awaymsg
      msn.html msg.from $sockname $iif(%msn.convers.show == email,%msn.user,$did(msnmirc,4))
      msn.html msg.end $sockname %msn.awaymsg
    }
  }
  elseif ($1 == MSG) {
    var %m = $4, %n = $msn.replace($iif(%msn.convers.show == nick,$3,$2)), %o = $2
    while (%temp) {
      sockread -f %temp
      tokenize 32 %temp
      var %m = $calc(%m - $len($1-) - 2)
      if ($1 == TypingUser:) {
        dialog -t $sockname MSNMIRC - %o $msnreadini(conversation,typing)
        break
      }
      elseif ($2 == text/x-msmsgsinvite;) {
        while (%temp) {
          sockread -f %temp
          tokenize 32 %temp
          if (!$1-) {
            sockread -f %temp
            tokenize 32 %temp
          }
          elseif ($1 == Application-GUID:) {
            if ($2 != $+($chr(123),5D3E02AB-6190-11d3-BBBB-00C04F795683,$chr(125))) { break }
            else {
              inc %msn.file.inc
              set $+(%,msn.filesender.,%msn.file.inc) %o
            }
          }
          elseif ($1 == Invitation-Command:) && ($2 != INVITE) { break }
          elseif ($1 == Invitation-Cookie:) { set $+(%,msn.filecookie.,%msn.file.inc) $2- }
          elseif ($1 == Application-File:) { set $+(%,msn.filename.,%msn.file.inc) $2- }
          elseif ($1 == Application-FileSize:) {
            set $+(%,msn.filesize.,%msn.file.inc) $2-
            msn.file.accept choice $sockname %msn.file.inc
          }
          elseif ($1 == IP-Address:) { set $+(%,msn.fileip.,%msn.file.inc) $2- }
          elseif ($1 == Port:) { set $+(%,msn.fileport.,%msn.file.inc) $2- }
          elseif ($1 == AuthCookie:) {
            set $+(%,msn.filecookie.,%msn.file.inc) $2-
            msn.file.accept connect %msn.file.inc
          }
        }
      }
      elseif (!%temp) {
        msn.html msg.from $sockname %n
        dialog -t $sockname MSNMIRC - $msnreadini(conversation,rcv) %o
        :multiline
        sockread -f %temp
        tokenize 32 %temp
        var %m = $calc(%m - $len($1-))
        if (%m > 0) {
          var %m = $calc(%m - 2)
          msn.html msg.multi $sockname $msn.replace($1-)
          goto multiline
        }
        else {
          msn.html msg.end $sockname $msn.replace($1-)
          break
        }
      }
    }
  }
  elseif ($1 == JOI) {
    msn.html join $sockname $msn.replace($iif(%msn.convers.show == nick,$3,$2))
    did -a $sockname 11 $msn.replace($3) $chr(9) $2
  }
  elseif ($1 == IRO) {
    msn.html join $sockname $msn.replace($iif(%msn.convers.show == nick,$6,$5))
    did -a $sockname 11 $msn.replace($6) $chr(9) $5
  }
  elseif ($1 == BYE) {
    msn.html leave $sockname $msn.replace($iif(%msn.convers.show == nick,$gettok($gettok($did($sockname,11,$didwm($sockname,11,$+(*,$2,*),1)).text,6-,32),1,9),$2))
    did -d $sockname 11 $didwm($sockname,11,$+(*,$2,*),1)
    if (!$did($sockname,11,2)) {
      msn.conv disable.edit $sockname
      sockclose $sockname
    }
  }
  elseif ($1 == 713) || ($1 == 216) || ($1 == 217) || ($1 == 208) {
    if (!$did($sockname,11,2) && $dialog($sockname)) { dialog -c $sockname }
  }
}
on *:sockclose:msnconv.*:{ msn.conv disable.edit $sockname }

on *:sockopen:msn.fileget.*:{
  if (!$sockerr) { sockwrite -n $sockname VER MYPROTO MSNFTP }
}
on *:sockread:msn.fileget.*:{
  sockread %temp
  tokenize 32 %temp
  if ($1 == VER) { sockwrite -n $sockname USR %msn.user $eval($+(%,msn.filecookie.,$gettok($sockname,-1,46)),2) }
  elseif ($1 == FIL) {
    set $+(%,msn.filesize.,$gettok($sockname,-1,46)) $calc($2 + $int($calc($2 / 2045 + 1)) * 3)
    sockwrite -n $sockname TFR
    sockrename $sockname $+(msn.fileget2.,$gettok($sockname,-1,46))
  }
}
on *:sockread:msn.fileget2.*:{
  sockread 2048 &temp
  if ($bvar(&temp,0) > 3) { bwrite $+(",$scriptdirdownload\temp\,$eval($+(%,msn.filename.,$gettok($sockname,-1,46)),2),") -1 -1 &temp }
  if ($eval($+(%,msn.filesize.,$gettok($sockname,-1,46)),2) == $file($+(",$scriptdirdownload\temp\,$eval($+(%,msn.filename.,$gettok($sockname,-1,46)),2),")).size) {
    sockwrite -n $sockname BYE 16777989
    var %a = $eval($+(%,msn.filename.,$gettok($sockname,-1,46)),2)
    var %b = $dll($scriptdirdll\blah.dll,get,$shortfn($+($scriptdirdownload\temp\,%a)) $+($scriptdirdownload\,%a))
    .remove $+(",$scriptdirdownload\temp\,%a,")
    if (E* !iswm %b) {
      echo -a $replace($msnreadini(fileaccept,success),<file>,$+(",%a,"),<nick>,$eval($+(%,msn.filesender.,$gettok($sockname,-1,46)),2))
      run $scriptdirdownload
    }
    else { echo -a $replace($msnreadini(fileaccept,failed),<file>,$+(",%a,"),<nick>,$eval($+(%,msn.filesender.,$gettok($sockname,-1,46)),2)) }
  }
}
on *:sockclose:msn.fileget*:{
  unset $+(%msn.file*.,$gettok($sockname,-1,46))
}

on *:sockopen:msn.tweenie:{
  if (!$sockerr) {
    sockwrite -n $sockname GET /login2.srf HTTP/1.1
    sockwrite -n $sockname Authorization: Passport1.4 OrgVerb=GET $+ $chr(44) $+ OrgURL=http%3A%2F%2Fmessenger%2Emsn%2Ecom $+ $chr(44) $+ sign-in= $+ %msn.user $+ $chr(44) $+ pwd= $+ %msn.pass $+ $chr(44) $+ $gettok($sock(msn.tweenie).mark,5-,32)
    sockwrite -n $sockname Host: %msn.logadd
    sockwrite -n $sockname User-Agent: MSMSGS 
    sockwrite -n $sockname Connection: Keep-Alive 
    sockwrite -n $sockname Cache-Control: no-cache $str($crlf,2)
  }
  else { echo -a $msnreadini(error,twn) }
}
on *:sockread:msn.tweenie:{
  sockread %temp
  tokenize 32 %temp
  if ($1 == HTTP/1.1) {
    if ($2 == 200) { return }
    else {
      echo -a $msnreadini(error,auth)
      sockclose msn.log2
      if ($dialog(msnmirc)) { dialog -x msnmirc }
    }
  }
  elseif ($1 == Authentication-Info:) { sockwrite -n msn.log2 USR 4 TWN S $gettok($1-,2,39) }
}
on *:sockclose:msn.log2:{
  if ($dialog(msnmirc)) { dialog -x msnmirc }
}

;;;MENUS

menu status,menubar {
  $msnreadini(menu,dmenu)
  . $msnreadini(menu,connect) :dialog -m msnlogin msnlogin
  .-
  . $msnreadini(menu,configs) :dialog -m msnconf msnconf
  . $msnreadini(menu,help) :msn.help
  .-
  . $msnreadini(menu,about) :dialog -m msnabout msnabout
  . $msnreadini(menu,unload)
  .. $msnreadini(menu,confirm) :msn.unload
}
alias F4 {
  if (*@*.* iswm %msn.user) && (%msn.pass) { msn.connect1 }
  else { dialog -m msnlogin msnlogin }
}
