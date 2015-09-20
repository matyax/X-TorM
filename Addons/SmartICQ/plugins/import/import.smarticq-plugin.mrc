;name import contact list
;version 0.83
;author tronicer
;email tronicer@freebox.com

; ---------------------
;
; VERSION HISTORY
;
; v0.83 - 08/04/02
;
;  1. fixed small bug that caused a conflict with the fractal script.
;
; v0.82 - 17/03/02
;
;  1. added a confirmation dialog.
;
; v0.81 - 07/03/02
;
;  1. fixed so it will be compatible with smarticq v0.995
;
; v0.8 - 18/02/02
;
;  1. tweaked account finding. 
;  2. cleaned up some code.
;  3. made all dialog tables local.
;  4. added some more information.
;
; v0.7 - 16/02/02
;
;  1. re-coded the parsing method for the .DAT file. 
;     no more lost contacts or other errors!
;
; v0.4 - 16/02/02
;
; ---------------------

on *:signal:smarticq.menu:{
  if ($1 == main) { _icq.menu_additem $2 Import Contacts $cr _icq.import }
}

on *:signal:smarticq.start:{ 
  var %file = $+(",$_icq.dir,$_icq.a,\settings.ini")
  if (!$readini(%file,account,import)) {
    if ($input(Do you want to import contact list?,136,SmartICQ)) { _icq.import }
    writeini %file account import 1
  }
}

dialog -l _icq.import.search {
  title "SmartICQ - IMPORT CONTACTS"
  size -1 -1 174 70
  option dbu
  box "Status", 1, 3 4 166 50
  button "STOP", 2, 131 57 37 12, cancel
  text "Searching for contacts... 0%", 3, 8 14 124 8
  text "", 4, 8 26 153 8
  text "", 5, 8 34 154 8
  text "", 6, 8 42 155 8
}

dialog -l _icq.import.add {
  title "SmartICQ - IMPORT CONTACTS"
  size -1 -1 100 135
  option dbu
  box "Contact List", 1, 2 2 94 116
  list 2, 7 11 84 87, size extsel
  button "Close", 4, 60 121 37 12, cancel
  button "Add", 5, 20 121 37 12, disable
  text "Select those contacts you wish to add to your contact list.", 6, 9 100 81 16
  list 10, 0 0 0 0, hide
}

on *:dialog:_icq.import.add:init:*:{

}

on *:dialog:_icq.import.add:sclick:5:{
  var %c = $did($dname,2,0).sel
  while (%c) {
    var %uin = $gettok($did($dname,10,$did($dname,2,%c).sel).text,-1,32)
    ;echo -s a %uin

    var %tok = 1- $+ $calc($gettok($did($dname,10,$did($dname,2,%c).sel).text,0,32) -1)

    var %wc = $+(*,$chr(1),%uin,$chr(1),*)
    if ($fline(@smarticq-gui,%wc,1,1)) { dline -l @smarticq-gui $fline(@smarticq-gui,%wc,1,1),1) }

    writeini $+(",$_icq.dir,$_icq.a,\uin.ini") contacts %uin 1
    _icq.adduserinfo $_icq.a %uin SHOW $gettok($did($dname,10,$did($dname,2,%c).sel).text,%tok,32)
    _icq.add_cl xx %uin offline $gettok($did($dname,10,$did($dname,2,%c).sel).text,%tok,32)
    _icq.qs _icq.adduin %uin
    dec %c
  }
  _icq.drw_cl $hget(smarticq,scroll)
  var %d = $input(Contacts have been added!,68,SmartICQ)
}

dialog -l _icq.import.selacc {
  title "SmartICQ - IMPORT CONTACTS"
  size -1 -1 137 94
  option dbu
  box "Accounts", 1, 2 2 133 77
  list 2, 9 14 117 50, size
  text "Select an account and press Ok.", 3, 9 66 101 9
  button "Close", 4, 99 81 37 12, cancel
  button "Ok", 5, 59 81 37 12, disable

  list 10, 0 0 0 0, hide
}

on *:dialog:_icq.import.selacc:sclick:5:{
  ;echo -s a $gettok($did($dname,10,$did($dname,2).sel).text,2-,32)
  dialog -m _icq.import.search _icq.import.search
  .timer 1 1 _icq.import.parse $gettok($did($dname,10,$did($dname,2).sel).text,2-,32)

}

alias _icq.import {
  if ($hget(_icq.import.accounts)) { hfree _icq.import.accounts }
  hmake _icq.import.accounts 10
  var %dir = $+(",$sdir($mircdir,SmartICQ - Select Your ICQ Folder),")

  var %d = $findfile(%dir,*.idx,0, if ($gettok($nopath($1-),1,46) isnum) hadd _icq.import.accounts $gettok($nopath($1-),1,46) $+(",$1-,")  )

  dialog -m _icq.import.selacc _icq.import.selacc
  var %c = $hget(_icq.import.accounts,0).item
  while (%c) {
    did -a _icq.import.selacc 10 $hget(_icq.import.accounts,%c).item $hget(_icq.import.accounts,$hget(_icq.import.accounts,%c).item)
    did -a _icq.import.selacc 2 $hget(_icq.import.accounts,%c).item
    dec %c
  }
  if ($did(_icq.import.selacc,2).lines) { did -e _icq.import.selacc 5 }
  if (!$did(_icq.import.selacc,2).lines) { did -ra _icq.import.selacc 3 No ICQ .DAT File(s) Found }
  hfree _icq.import.accounts

}


alias -l _icq.import.parse {

  if ($hget(_icq.import.search)) { hfree _icq.import.search  }
  hmake _icq.import.search 10

  var %dn = _icq.import.search, %file = $1-, %lala = 0

  bread %file 0 4000 &db

  var %version = $bvar(&db,17,4), %c = 226, %status = $bvar(&db,%c,4), %entry = $bvar(&db,230,4)
  var %next = $longip($replace($+($bvar(&db,237,1) $bvar(&db,236,1) $bvar(&db,235,1) $bvar(&db,234,1)),$chr(32),.))
  var %prev = $bvar(&db,238,4), %dat = $bvar(&db,242,4)

  ;echo -s ver: %version
  ; icq2000 = 18 0 0 0
  ; icq2001 = 19 0 0 0

  %c = $calc(%next +1)

  while (%next) {

    var %status = $bvar(&db,%c,4)
    var %entry = $longip($replace($+($bvar(&db,$calc(%c +7),1) $bvar(&db,$calc(%c +6),1) $bvar(&db,$calc(%c +5),1) $bvar(&db,$calc(%c +4),1)),$chr(32),.))
    var %next = $longip($replace($+($bvar(&db,$calc(%c +11),1) $bvar(&db,$calc(%c +10),1) $bvar(&db,$calc(%c +9),1) $bvar(&db,$calc(%c +8),1)),$chr(32),.))
    var %prev = $bvar(&db,$calc(%c +12),4)
    var %dat = $longip($replace($+($bvar(&db,$calc(%c +19),1) $bvar(&db,$calc(%c +18),1) $bvar(&db,$calc(%c +17),1) $bvar(&db,$calc(%c +16),1)),$chr(32),.))

    var %p = $round($calc( ( %next / $file(%file).size ) * 100 ),0)
    if (%p == $remove($gettok($did(%dn,3).text,4,32),$chr(37))) { inc %lala }
    if (%p > $remove($gettok($did(%dn,3).text,4,32),$chr(37))) { %lala = 0 | did -a %dn 3 Searching for contacts... %p $+ % }
    ;    if (%lala == 8) { did -a %dn 3 Searching for contacts... %p $+ % (working) }

    if (%entry > 2000) {
      bread $replace(%file,.idx,.dat) %dat 4000 &dat
      var %es = $longip($replace($+($bvar(&dat,4,1) $bvar(&dat,3,1) $bvar(&dat,2,1) $bvar(&dat,1,1)),$chr(32),.))

      var %sig = $_icq.dec2hex($bvar(&dat,13,1))

      ;echo -s sig %sig - %es

      if (%sig == E5) && (%es > 0) {
        ;        did -a %dn 3 Searching for uin... 

        bcopy &dat2 1 &dat 1 %es

        ; uin = 4 0 85 73 78 0 105
        ; nickname = 9 0 78 105 99 107 78 97 109 101 0 107
        ; firstname = 10 0 70 105 114 115 116 78 97 109 101 0 107
        var %hoho = 1
        var %fc = 1
        while ($bfind(&dat2, %fc,82 69 83 85 2 0 0 0)) {
          if (%hoho) { did -a %dn 3 Searching for contacts... %p $+ % (working) }
          %hoho = 0
          var %fcc = $bfind(&dat2,%fc,82 69 83 85 2 0 0 0)
          var %fuin = $bfind(&dat2, %fcc , 4 0 85 73 78 0 105)
          var %fnick = $bfind(&dat2, %fcc , 9 0 78 105 99 107 78 97 109 101 0 107)
          var %fnick.s = $_icq.le2d($bvar(&dat2,$calc(%fnick +12),2))
          var %fname = $bfind(&dat2, %fcc , 10 0 70 105 114 115 116 78 97 109 101 0 107)
          var %fname.s = $_icq.le2d($bvar(&dat2,$calc(%fname +13),2))

          ;echo -s ::: uin $bvar(&dat2,$calc(%fuin -10),50)
          ;echo -s ::: nick $bvar(&dat2,$calc(%fnick -10),50)
          ;echo -s ::: name $bvar(&dat2,$calc(%fname -10),50)


          var %.uin = $longip($replace($+($bvar(&dat2,$calc(%fuin +10),1) $bvar(&dat2,$calc(%fuin +9),1) $bvar(&dat2,$calc(%fuin +8),1) $bvar(&dat2,$calc(%fuin +7),1)),$chr(32),.))
          var %.nick = $bvar(&dat2,$calc(%fnick +14),%fnick.s).text
          ;echo -s find- %fuin 
          ;echo -s find uin - %.uin
          ;echo -s find nick - %.nick
          ;echo -s find name - $bvar(&dat2,$calc(%fname +15),%fname.s).text
          hadd _icq.import.search %.uin $iif(%.nick,%.nick,%.uin)
          %fc = $calc(%fcc +8)
        }

        if (%.uin) {
          did -a %dn 6 $did(%dn,5).text
          did -a %dn 5 $did(%dn,4).text
          did -a %dn 4 Found: %.nick %.uin
        }

      }

    }

    var %.uin 
    if (%next == $null) { 
      did -a %dn 3 Search finished. 
      dialog -x %dn
      dialog -m _icq.import.add _icq.import.add
      var %w = $hget(_icq.import.search,0).item
      while (%w) {
        did -a _icq.import.add 10 $hget(_icq.import.search,$hget(_icq.import.search,%w).item) $hget(_icq.import.search,%w).item
        did -a _icq.import.add 2 $hget(_icq.import.search,$hget(_icq.import.search,%w).item)
        did -kc _icq.import.add 2 $did(_icq.import.add,2).lines
        if ($did(_icq.import.add,2).lines == 1) { did -e _icq.import.add 5 }
        dec %w
      }
      break 
    }

    bread %file %next 1000 &db
    %c = 1

  }
}
