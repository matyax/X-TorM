f;Fichero de ejemplo del formato unificado de temas en español, UTE
;Los siguientes eventos y ficheros raw deben pasar los siguientes comodines
;segun el caso que se considere:
;
;    &address:Direccion                              &nick:Nick que dispara un evento              &tarnick:Nick objetivo de un evento
;    &banmask:Máscara en un ban            &msg:Mensaje de cualquier evento             &origen:Ventana en que surge el evento
; 
;  Los eventos raw se pasarán en la forma $ute.display(raw318,$1-), siendo corregidos a traves del formato del remoto auxiliar ute.tem
;
#setupute off
[Tema]
Carpeta=TEMAS\
RutaDLL=TEMAS\
#setupute end

;El siguiente alias se encarga de ejecutar los multiechos que puede haber para cada evento
alias mecho {
  var %toks $numtok($2,7), %i 0
  while ( %i < %toks ) {
    inc %i
    echo $1 $tok7($2, [ %i ]  )
  }
}

;El siguiente alias indica la ventana en la que se debe mostrar un evento.
;Posibles ventanas: Origen,@nombreventana,status,ocultar,activa
alias donde {
  var %d $hget(uted,$+(Donde.,$1))
  if ( %d = Origen ) return -t $iif($window($2),$2)
  if ( %d = Ocultar ) return -t $$9000
  if ( @ isin %d ) return -t %d
  if ( %d = Status ) return -ts
  if ( %d = Activa ) return -ta
  if ( %d  = tema ) {
    if ( $hgeT(ute,$+(Donde.,$1)) ) {
      var %w $ifmatch 
      if ( %w = Origen ) return -t $iif($window($2),$2)
      if ( %w = Ocultar ) return -t $$9000
      if ( @ isin %w  ) return -t %w
      if ( %w = Status ) return -ts
      if ( %w = Activa ) return -ta
    }
    else return -t $iif($window($2),$2)
  }
}

;Eventos básicos: TEXT,ACTION,NOTICE,CTCP
ON ^*:TEXT:*:#: {
  var %origen $+(&origen:,$chan), %nick $+(&nick:,$nick), %msg $+(&msg:,$remove($1-,$chr(7))), %address $+(&address:,$address), %prefijo $+(&prefijo:,$iif($nick isop $chan,@,$iif($nick isvo $chan,+))), %target $+(&target:,$target)
  $mecho($donde(Textocanal,$chan), $ute.display(TextoCanal,$+(%origen,$chr(7),%nick,$chr(7),%msg,$chr(7),%address,$chr(7),%prefijo,$chr(7),%target,$chr(7),%script)))
  haltdef
}

ON ^*:TEXT:*:?: {
  var %origen $+(&origen:,$nick), %nick $+(&nick:,$nick), %msg $+(&msg:,$remove($1-,$chr(7))), %address $+(&address:,$address)
  $mecho($donde(Textoprivado,$nick), $ute.display(Textoprivado,$+(%origen,$chr(7),%nick,$chr(7),%msg,$chr(7),%address,$chr(7),%script)))
  haltdef
}

ON ^*:ACTION:*:#: {
  var %origen $+(&origen:,$chan), %nick $+(&nick:,$nick), %msg $+(&msg:,$remove($1-,$chr(7))), %address $+(&address:,$address), %prefijo $+(&prefijo:,$iif($nick isop $chan,@,$iif($nick isvo $chan,+))), %target $+(&target:,$target)
  $mecho($donde(Accioncanal,$chan), $ute.display(AccionCanal,$+(%origen,$chr(7),%nick,$chr(7),%msg,$chr(7),%address,$chr(7),%prefijo,$chr(7),%target,$chr(7),%script)))
  haltdef
}

ON ^*:ACTION:*:?: {
  var %origen $+(&origen:,$nick), %nick $+(&nick:,$nick), %msg $+(&msg:,$remove($1-,$chr(7))), %address $+(&address:,$address)
  $mecho($donde(Accionprivado,$nick), $ute.display(Accionprivado,$+(%origen,$chr(7),%nick,$chr(7),%msg,$chr(7),%address,$chr(7),%script)))
  haltdef
}

ON ^*:NOTICE:*:#: {
  var %origen $+(&origen:,$chan), %nick $+(&nick:,$nick), %msg $+(&msg:,$remove($1-,$chr(7))), %address $+(&address:,$address), %prefijo $+(&prefijo:,$iif($nick isop $chan,@,$iif($nick isvo $chan,+))), %target $+(&target:,$target)
  $mecho($donde(noticecanal,$chan), $ute.display(noticeCanal,$+(%origen,$chr(7),%nick,$chr(7),%msg,$chr(7),%address,$chr(7),%prefijo,$chr(7),%target,$chr(7),%script)))
  haltdef
}

ON ^*:NOTICE:*:?: {
  var %origen $+(&origen:,$nick), %nick $+(&nick:,$nick), %msg $+(&msg:,$remove($1-,$chr(7))), %address $+(&address:,$address)
  $mecho($donde(noticeprivado,$nick), $ute.display(noticeprivado,$+(%origen,$chr(7),%nick,$chr(7),%msg,$chr(7),%address,$chr(7),%script)))
  haltdef
}
ON ^*:SNOTICE:*: {
  var %origen $+(&origen:,$nick), %nick $+(&nick:,$nick), %msg $+(&msg:,$remove($1-,$chr(7))), %address $+(&address:,$address)
  $mecho($donde(snotice,$nick), $ute.display(snotice,$+(%origen,$chr(7),%nick,$chr(7),%msg,$chr(7),%address,$chr(7),%script)))
  haltdef
}

CTCP ^*:*:#: {
  var %origen $+(&origen:,$chan), %nick $+(&nick:,$nick), %msg $+(&msg:,$remove($1-,$chr(7))), %address $+(&address:,$address), %prefijo $+(&prefijo:,$iif($nick isop $chan,@,$iif($nick isvo $chan,+))), %target $+(&target:,$target)
  $mecho($donde(ctcpcanal,$chan), $ute.display(ctcpcanal,$+(%origen,$chr(7),%nick,$chr(7),%msg,$chr(7),%address,$chr(7),%prefijo,$chr(7),%target,$chr(7),%script)))
  haltdef
}
CTCP ^*:*:?: {
  var %origen $+(&origen:,$nick), %nick $+(&nick:,$nick), %msg $+(&msg:,$remove($1-,$chr(7))), %address $+(&address:,$address),   %target $+(&target:,$target)
  $mecho($donde(ctcpprivado,$nick), $ute.display(ctcpprivado,$+(%origen,$chr(7),%nick,$chr(7),%msg,$chr(7),%address,$chr(7),%target,$chr(7),%script)))
  haltdef
}

;Eventos de modos, RAWMODE,OP,DEOP,VOICE,DEVOICE,HELP,DEHELP,SERVEROP,SERVERDEOP,USERMODE
ON ^*:RAWMODE:#: {
  if ( $ute.info(rawmode) = Si ) {
    var %origen $+(&origen:,$chan), %nick $+(&nick:,$nick), %modos $+(&modos:,$remove($1-,$chr(7))), %address $+(&address:,$address), %prefijo $+(&prefijo:,$iif($nick isop $chan,@,$iif($nick isvo $chan,+))), %target $+(&target:,$target)
    if ( $nick != $me  )     $mecho($donde(rawmode,$chan), $ute.modos(rawmode,$+(%origen,$chr(7),%nick,$chr(7),%modos,$chr(7),%address,$chr(7),%prefijo,$chr(7),%target,$chr(7),%script)))
    else   $mecho($donde(rawmodepropio,$chan), $ute.modos(rawmodepropio,$+(%origen,$chr(7),%nick,$chr(7),%modos,$chr(7),%address,$chr(7),%prefijo,$chr(7),%target,$chr(7),%script)))
    haltdef
  }
}
ON ^*:OP:#: {
  if ( $ute.info(rawmode) = No ) {
    var %origen $+(&origen:,$chan), %nick $+(&nick:,$nick), %modos $+(&modos:,$remove(+o,$chr(7))), %address $+(&address:,$address), %tarnick $+(&nick:,$opnick), %prefijo $+(&prefijo:,$iif($nick isop $chan,@,$iif($nick isvo $chan,+))), %target $+(&target:,$target)
    if ( $nick != $me )    $mecho($donde(op,$chan), $ute.modos(op,$+(%origen,$chr(7),%nick,$chr(7),%modos,$chr(7),%address,$chr(7),%tarnick,$chr(7),%prefijo,$chr(7),%target,$chr(7),%script)))
    else  $mecho($donde(oppropio,$chan), $ute.modos(oppropio,$+(%origen,$chr(7),%nick,$chr(7),%modos,$chr(7),%address,$chr(7),%tarnick,$chr(7),%prefijo,$chr(7),%target,$chr(7),%script)))
    haltdef
  }
}
ON ^*:DEOP:#: {
  if ( $ute.info(rawmode) = No ) {
    var %origen $+(&origen:,$chan), %nick $+(&nick:,$nick), %modos $+(&modos:,$remove(-o,$chr(7))), %address $+(&address:,$address), %tarnick $+(&nick:,$opnick) , %prefijo $+(&prefijo:,$iif($nick isop $chan,@,$iif($nick isvo $chan,+))), %target $+(&target:,$target)
    if ( $nick != $me ) $mecho($donde(deop,$chan), $ute.modos(deop,$+(%origen,$chr(7),%nick,$chr(7),%modos,$chr(7),%address,$chr(7),%tarnick,$chr(7),%prefijo,$chr(7),%target,$chr(7),%script)))
    else $mecho($donde(deoppropio,$chan), $ute.modos(deoppropio,$+(%origen,$chr(7),%nick,$chr(7),%modos,$chr(7),%address,$chr(7),%tarnick,$chr(7),%prefijo,$chr(7),%target,$chr(7),%script)))
    haltdef
  }
}
ON ^*:VOICE:#: {
  if ( $ute.info(rawmode) = No ) {
    var %origen $+(&origen:,$chan), %nick $+(&nick:,$nick), %modos $+(&modos:,$remove(+v,$chr(7))), %address $+(&address:,$address), %tarnick $+(&nick:,$vnick), %prefijo $+(&prefijo:,$iif($nick isop $chan,@,$iif($nick isvo $chan,+))), %target $+(&target:,$target)
    $mecho($donde(voice,$chan), $ute.modos(voice,$+(%origen,$chr(7),%nick,$chr(7),%modos,$chr(7),%address,$chr(7),%tarnick,$chr(7),%prefijo,$chr(7),%target,$chr(7),%script)))
    haltdef
  }
}
ON ^*:DEVOICE:#: {
  if ( $ute.info(rawmode) = No ) {
    var %origen $+(&origen:,$chan), %nick $+(&nick:,$nick), %modos $+(&modos:,$remove(-v,$chr(7))), %address $+(&address:,$address), %tarnick $+(&nick:,$vnick), %prefijo $+(&prefijo:,$iif($nick isop $chan,@,$iif($nick isvo $chan,+))), %target $+(&target:,$target)
    $mecho($donde(devoice,$chan), $ute.modos(devoice,$+(%origen,$chr(7),%nick,$chr(7),%modos,$chr(7),%address,$chr(7),%tarnick,$chr(7),%prefijo,$chr(7),%target,$chr(7),%script)))
    haltdef
  }
}
ON ^*:HELP:#: {
  if ( $ute.info(rawmode) = No ) {
    var %origen $+(&origen:,$chan), %nick $+(&nick:,$nick), %modos $+(&modos:,$remove(+h,$chr(7))), %address $+(&address:,$address), %tarnick $+(&nick:,$hnick), %prefijo $+(&prefijo:,$iif($nick isop $chan,@,$iif($nick isvo $chan,+))), %target $+(&target:,$target)
    $mecho($donde(help,$chan), $ute.modos(help,$+(%origen,$chr(7),%nick,$chr(7),%modos,$chr(7),%address,$chr(7),%tarnick,$chr(7),%prefijo,$chr(7),%target,$chr(7),%script)))
    haltdef
  }
}
ON ^*:DEHELP:#: {
  if ( $ute.info(rawmode) = No ) {
    var %origen $+(&origen:,$chan), %nick $+(&nick:,$nick), %modos $+(&modos:,$remove(-h,$chr(7))), %address $+(&address:,$address), %tarnick $+(&nick:,$hnick), %prefijo $+(&prefijo:,$iif($nick isop $chan,@,$iif($nick isvo $chan,+))), %target $+(&target:,$target)
    $mecho($donde(dehelp,$chan), $ute.modos(dehelp,$+(%origen,$chr(7),%nick,$chr(7),%modos,$chr(7),%address,$chr(7),%tarnick,$chr(7),%prefijo,$chr(7),%target,$chr(7),%script)))
    haltdef
  }
}
ON ^*:SERVEROP:#: {
  if ( $ute.info(rawmode) = No ) {
    var %origen $+(&origen:,$chan), %nick $+(&nick:,$nick), %modos $+(&modos:,$remove(+o,$chr(7))), %address $+(&address:,$address), %tarnick $+(&nick:,$opnick), %target $+(&target:,$target)
    $mecho($donde(serverop,$chan), $ute.modos(serverop,$+(%origen,$chr(7),%nick,$chr(7),%modos,$chr(7),%address,$chr(7),%tarnick,$chr(7),%target,$chr(7),%script)))
    haltdef
  }
}
ON ^*:SERVERDEOP:#: {
  if ( $ute.info(rawmode) = No ) {
    var %origen $+(&origen:,$chan), %nick $+(&nick:,$nick), %modos $+(&modos:,$remove(-o,$chr(7))), %address $+(&address:,$address), %tarnick $+(&nick:,$opnick), %target $+(&target:,$target) 
    $mecho($donde(serverdeop,$chan), $ute.modos(serverdeop,$+(%origen,$chr(7),%nick,$chr(7),%modos,$chr(7),%address,$chr(7),%tarnick,$chr(7),%target,$chr(7),%script)))
    haltdef
  }
}
ON ^*:USERMODE: {
  var %origen $+(&origen:,$active), %nick $+(&nick:,$me), %modos $+(&modos:,$remove($1-,$chr(7))), %address $+(&address:,$address)
  $mecho($donde(usermode,$chan), $ute.modos(usermode,$+(%origen,$chr(7),%nick,$chr(7),%modos,$chr(7),%address,$chr(7),%script)))
  haltdef
}

;Otros eventos relacionados, NICK,JOIN,PART,QUIT,KICK con formato de mensaje o encuadrados logicamente juntos
ON ^*:JOIN:#: {
  var %origen $+(&origen:,$chan), %nick $+(&nick:,$nick),  %address $+(&address:,$address)
  if ( $nick != $me )  $mecho($donde(join,$chan), $ute.display(join,$+(%origen,$chr(7),%nick,$chr(7),%msg,$chr(7),%address,$chr(7),%script)))
  else  $mecho($donde(joinpropio,$chan), $ute.display(joinpropio,$+(%origen,$chr(7),%nick,$chr(7),%msg,$chr(7),%address,$chr(7),%script)))

  haltdef
}
ON ^*:PART:#: {
  var %origen $+(&origen:,$chan), %nick $+(&nick:,$nick), %msg $+(&msg:,$remove($1-,$chr(7))), %address $+(&address:,$address), %prefijo $+(&prefijo:,$iif($nick isop $chan,@,$iif($nick isvo $chan,+))), %target $+(&target:,$target)
  if ( $nick != $me )   $mecho($donde(part,$chan), $ute.display(part,$+(%origen,$chr(7),%nick,$chr(7),%msg,$chr(7),%address,$chr(7),%prefijo,$chr(7),%target,$chr(7),%script)))
  else $mecho($donde(partpropio,$chan), $ute.display(partpropio,$+(%origen,$chr(7),%nick,$chr(7),%msg,$chr(7),%address,$chr(7),%prefijo,$chr(7),%target,$chr(7),%script)))
  haltdef
}
ON ^*:NICK: {
  var %nick $+(&nick:,$nick), %tarnick $+(&tarnick:,$newnick) , %address $+(&address:,$address), %prefijo $+(&prefijo:,$iif($nick isop $chan,@,$iif($nick isvo $chan,+)))
  var %c $comchan($newnick,0), %i 0
  while ( %i < %c ) { inc %i | if ( $nick != $me )  $mecho($donde(cambiodenick,$comchan($newnick,%i)), $ute.display(cambiodenick,$+(%origen,$chr(7),%nick,$chr(7),%tarnick,$chr(7),%address,$chr(7),%prefijo,$chr(7),%target))) | else $mecho($donde(cambiodenickpropio,$comchan($newnick,%i)), $ute.display(cambiodenickpropio,$+(%origen,$chr(7),%nick,$chr(7),%tarnick,$chr(7),%address,$chr(7),%prefijo,$chr(7),%target,$chr(7),%script)))   }
  haltdef
}
ON ^*:QUIT: {
  var %origen $+(&origen:,$chan), %nick $+(&nick:,$nick), %msg $+(&msg:,$remove($1-,$chr(7))), %address $+(&address:,$address), %prefijo $+(&prefijo:,$iif($nick isop $chan,@,$iif($nick isvo $chan,+))), %target $+(&target:,$target)
  var %c $comchan($nick,0), %i 0
  while ( %i < %c ) { inc %i |
    if ( $nick != $me )  $mecho($donde(quit,$comchan($nick,%i)), $ute.display(quit,$+(%origen,$chr(7),%nick,$chr(7),%msg,$chr(7),%address,$chr(7),%prefijo,$chr(7),%target) ) ) 
  else $mecho($donde(quitpropio,$comchan($nick,%i)), $ute.display(quitpropio,$+(%origen,$chr(7),%nick,$chr(7),%msg,$chr(7),%address,$chr(7),%prefijo,$chr(7),%target,$chr(7),%script)))  }
  haltdef
}
ON ^*:KICK:#: {
  haltdef
  var %origen $+(&origen:,$chan), %nick $+(&nick:,$nick), %address $+(&address:,$address), %tarnick $+(&tarnick:,$knick), %msg $+(&msg:,$remove($1-,$chr(7))), %prefijo $+(&prefijo:,$iif($nick isop $chan,@,$iif($nick isvo $chan,+))), %target $+(&target:,$target)
  if ( $knick != $me )   $mecho($donde(kick,$chan), $ute.display(kick,$+(%origen,$chr(7),%nick,$chr(7),%msg,$chr(7),%address,$chr(7),%tarnick,$chr(7),%prefijo,$chr(7),%target,$chr(7),%script)))
  else $mecho($donde(kickpropio,$chan), $ute.display(kickpropio,$+(%origen,$chr(7),%nick,$chr(7),%msg,$chr(7),%address,$chr(7),%tarnick,$chr(7),%prefijo,$chr(7),%target,$chr(7),%script)))
}

ON ^*:NOTIFY: {
  var %nick $+(&nick:,$nick), %address $+(&address:,$address), %msg $+(&msg:,$remove($notify($nick).note,$chr(7)))
  $mecho($donde(notify,Status), $ute.display(notify,$+(%nick,$chr(7),%msg,$chr(7),%address,$chr(7),%script)))
  haltdef
}
ON ^*:UNOTIFY: {
  var %nick $+(&nick:,$nick), %address $+(&address:,$address), %msg $+(&msg:,$remove($notify($nick).note,$chr(7)))
  $mecho($donde(notify,Status), $ute.display(unotify,$+(%nick,$chr(7),%msg,$chr(7),%address,$chr(7),%script)))
  haltdef
}


;raws de whois
raw 311:*: $mecho($donde(rawswhois,$2),$ute.display(raw311,$1-)) | haltdef
raw 319:*: $mecho($donde(rawswhois,$2),$ute.display(raw319,$1-)) | haltdef
raw 312:*: $mecho($donde(rawswhois,$2),$ute.display(raw312,$1-)) | haltdef
raw 301:*: $mecho($donde(rawswhois,$2),$ute.display(raw301,$1-)) | haltdef
raw 317:*: $mecho($donde(rawswhois,$2),$ute.display(raw317,$1-)) | haltdef
raw 307:*: $mecho($donde(rawswhois,$2),$ute.display(raw307,$1-)) | haltdef
raw 378:*: $mecho($donde(rawswhois,$2),$ute.display(raw378,$1-)) | haltdef
raw 313:*: $mecho($donde(rawswhois,$2),$ute.display(raw313,$1-)) | haltdef
raw 318:*: $mecho($donde(rawswhois,$2),$ute.display(raw318,$1-)) | haltdef

raw 301:*: $mecho($donde(otrosraws,$2),$ute.display(raw301,$1-)) | haltdef

;raws de whowas
raw 314:*: $mecho($donde(rawswhowas,$2),$ute.display(raw314,$1-)) | haltdef
raw 369:*: $mecho($donde(rawswhowas,$2),$ute.display(raw369,$1-)) | haltdef
raw 406:*: $mecho($donde(rawswhowas,$2),$ute.display(raw406,$1-)) | haltdef

;raws de who
raw 352:*: $mecho($donde(rawswho,$active),$ute.display(raw352,$1-)) | haltdef
raw 315:*: $mecho($donde(rawswho,$active),$ute.display(raw315,$1-)) | haltdef


;raws de errores
raw 401:*: $mecho($donde(rawserrores,$active),$ute.display(raw401,$1-)) | haltdef
raw 402:*: $mecho($donde(rawserrores,$active),$ute.display(raw402,$1-)) | haltdef
raw 403:*: $mecho($donde(rawserrores,$active),$ute.display(raw403,$1-)) | haltdef
raw 404:*: $mecho($donde(rawserrores,$active),$ute.display(raw404,$1-)) | haltdef
raw 405:*: $mecho($donde(rawserrores,$active),$ute.display(raw405,$1-)) | haltdef
raw 406:*: $mecho($donde(rawserrores,$active),$ute.display(raw406,$1-)) | haltdef
raw 422:*: $mecho($donde(rawserrores,$active),$ute.display(raw422,$1-)) | haltdef
raw 431:*: $mecho($donde(rawserrores,$active),$ute.display(raw431,$1-)) | haltdef
raw 432:*: $mecho($donde(rawserrores,$active),$ute.display(raw432,$1-)) | haltdef
raw 433:*: $mecho($donde(rawserrores,$active),$ute.display(raw433,$1-)) | haltdef
raw 436:*: $mecho($donde(rawserrores,$active),$ute.display(raw436,$1-)) | haltdef
raw 437:*: $mecho($donde(rawserrores,$active),$ute.display(raw437,$1-)) | haltdef
raw 438:*: $mecho($donde(rawserrores,$active),$ute.display(raw438,$1-)) | haltdef
raw 441:*: $mecho($donde(rawserrores,$active),$ute.display(raw441,$1-)) | haltdef
raw 442:*: $mecho($donde(rawserrores,$active),$ute.display(raw442,$1-)) | haltdef
raw 443:*: $mecho($donde(rawserrores,$active),$ute.display(raw443,$1-)) | haltdef
raw 465:*: $mecho($donde(rawserrores,$active),$ute.display(raw465,$1-)) | haltdef
raw 471:*: $mecho($donde(rawserrores,$active),$ute.display(raw471,$1-)) | haltdef
raw 472:*: $mecho($donde(rawserrores,$active),$ute.display(raw472,$1-)) | haltdef
raw 473:*: $mecho($donde(rawserrores,$active),$ute.display(raw473,$1-)) | haltdef
raw 474:*: $mecho($donde(rawserrores,$active),$ute.display(raw474,$1-)) | haltdef
raw 475:*: $mecho($donde(rawserrores,$active),$ute.display(raw475,$1-)) | haltdef
raw 478:*: $mecho($donde(rawserrores,$active),$ute.display(raw478,$1-)) | haltdef
raw 481:*: $mecho($donde(rawserrores,$active),$ute.display(raw481,$1-)) | haltdef
raw 482:*: $mecho($donde(rawserrores,$active),$ute.display(raw482,$1-)) | haltdef
raw 501:*: $mecho($donde(rawserrores,$active),$ute.display(raw502,$1-)) | haltdef
raw 502:*: $mecho($donde(rawserrores,$active),$ute.display(raw502,$1-)) | haltdef


; Evento on start principal. Se encarga de cargar el tema uted por defecto en cada ejecucion.
ON *:START: {
  hmake uted 100
  if ( ( $readini($script,tema,carpeta) )  &&   ($isfile($ifmatch $+ uted.hsh)) ) hload -b uted $readini($script,tema,carpeta) $+ uted.hsh 
  else { 
    var %d $sdir($scriptdir,Seleccione la carpeta en la que se encuentra uted.hsh)
    writeini $script Tema Carpeta %d
  }
  if (( $ute.info(rutaute) )  && $isfile($ute.info(rutaute))) {
    hmake ute 100
    hload -b ute $ifmatch 
    ute.ejecuta start
  }
}

;Y esto salva nuestra tabla basica uted con las preferencias del usuario ^^
ON *:EXIT: {
  hsave -bo uted $readini($script,tema,carpeta)  $+ uted.hsh
  ute.ejecuta exit
}

;Esto puede ser temporal, su utilidad seria ser llamados cada vez que se cargue o descargue un tema con un signal;;;
ON *:SIGNAL:ute:  { 
  if ( $hget(ute) )  {
    ute.ejecuta descarga
    hfree ute
  }
  hmake ute 100
  hload ute $$ute.info(rutaute)
  ute.ejecuta carga
  ute.font $iif($gettok($ute.info(fuente),2,44),$gettok($ute.info(fuente),2),12)  $$gettok($ute.info(fuente),1) 
  ute.col $ute.info(Esquema, $iif($1,$1,1))
  ute.col2 $ute.info(Colores)
  hfree utemp
}


;Para los raws del watch :D
on 1:connect: { if ( !$notify(0) ) { Watch + } }




;Dialogo temas de ejemplo. No pretende ser en absoluto un estandar. De hecho se agradeceria un experto en picwins para hacer esta parte

alias temas- if ( $dialog(temas) ) dialog -v temas | else dialog -m temas temas
alias ute.dll return $readini($script,Tema,RutaDll)
alias mdx_init {
  dll $mdxdir SetMircVersion $version
  dll $mdxdir MarkDialog $1
}
alias mdx { if ( $os != 3.1 )  {
    dll $mdxdir $1-  
  } 
}
alias setmdx {
  mdx SetControlMDX $1- 
}

alias mdxdir return $scriptdir $+ mdx.dll

dialog temas {
  title "Sistema de temas [/temas]"
  size -1 -1 247 140
  option dbu
  list 1, 7 19 104 85, size
  text "Esquema", 2, 9 110 32 8, right
  text "Idioma", 3, 9 126 32 8, right
  combo 4, 46 108 65 50, size drop
  combo 5, 46 124 65 50, size drop
  text "Temas en", 6, 8 8 24 8
  text "Text Label", 7, 33 8 61 8
  button "!", 8, 97 8 13 10
  tab "Muestra", 9, 115 3 124 117
  icon 14, 119 21 81 63, $ute.dir $+ destello.jpg, tab 9
  button "Generar", 15, 206 75 25 10, tab 9
  list 16, 117 89 120 27, tab 9 size
  tab "Cargar", 10
  check "Eventos", 17, 122 37 37 10, tab 10
  text "Al cargar un tema se cargaran ...", 18, 120 25 82 8, tab 10
  check "Colores", 19, 122 51 37 10, tab 10
  check "Imagenes ", 20, 122 65 50 10, tab 10
  check "Sonidos", 21, 177 37 36 10, tab 10
  check "Fuentes", 22, 177 51 43 10, tab 10
  tab "Redireccion", 11
  list 25, 119 24 115 71, tab 11 size
  text "Mostrar todos segun", 28, 121 101 53 8, tab 11
  combo 29, 178 100 56 50, tab 11 size drop
  button "Cerrar", 26, 220 125 20 10, ok
  button "Cargar", 27, 197 125 20 10
}
ON *:Dialog:temas:init:*: {
  if ( $ute.dll )  var %p $ifmatch 
  else { 
    var %n $sdir(\,Seleccione una carpeta en la que se encuentren las dll mdx) 
    if ( %n ) var %p %ifmatch | else { echo -a ** Imposible continuar. Carpeta de mdx.dll desconocida  |  remini $script Tema Rutadll |  halt }
    if ( !$isfile(%p $+ mdx.dll) ) {  echo -a ** Imposible continuar. No se encuenta mdx.dll en la carpeta indicada  | remini $script Tema Rutadll |   halt }
  }
  mdx_init $dname
  $mdx(SetControlMDX,$dname 1 listview showsel rowselect headerdrag flatsb grid editlabels single labeltip autovs sortascending report > $ute.dll $+ views.mdx )


}
