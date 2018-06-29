import
  logging,
  strutils,
  tables

import
  ur


proc default_format(event: UREvent, detail: Table[string, string]): string =
  result = "$1; $2; $3".format($event.class, $event.audience, event.msg)


var
  UR_universal_log_formatter* = default_format

proc setURLogFormat*(formatting_procedure: proc) =
  ## Have the supplied procedure formated the string used by sendLog
  ## 
  ## The supplied procedure must have parameters in the form of:
  ## 
  ##   (event: UREvent, detail: Table[string, string]): string
  UR_universal_log_formatter = formatting_procedure

method sendLog*(ur: UR_universal) {.base.} =
  ## Sends all events to the Nim 'logging' module.
  for event in ur.events:
    var log_msg = UR_universal_log_formatter(event, ur.detail)
    log(level=event.level, logmsg)

