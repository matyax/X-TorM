on *:load:{
  if ($version < 5.91) { echo -s SmartICQ - YOU MUST HAVE mIRC v5.91 or newer | return }
  if ($version < 6.0) { echo -s SmartICQ - Will work best with mIRC 6.0x }
  if (!$script(gui.smarticq)) { .load -rs $+(",$scriptdir,dat\gui.smarticq") }
  if (!$script(socket.smarticq)) { .load -rs $+(",$scriptdir,dat\socket.smarticq") }
  if (!$script(core.smarticq)) { .load -rs $+(",$scriptdir,dat\core.smarticq") }
  if (!$script(dlg01.smarticq)) { .load -rs $+(",$scriptdir,dat\dlg01.smarticq") }
  if (!$script(dlg02.smarticq)) { .load -rs $+(",$scriptdir,dat\dlg02.smarticq") }
  echo -s SmartICQ (c) 2001-02 tronicer
  echo -s type /icq to start it.
  .unload -rs smarticq.mrc 
}
