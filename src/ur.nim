# universal return
#

import
  macros,
  logging,
  strutils,
  tables


# 'Level'
# answers: how serious is the message?
#    Despite names like 'warn', it is not a description
#    of positive/negative result; or of distribution.
#    It is a treshhold of log priority.
#
#  lvlAll,                     ## all levels active
#  lvlDebug,                   ## debug level (and any above) active
#  lvlInfo,                    ## info level (and any above) active
#  lvlNotice,                  ## info notice (and any above) active
#  lvlWarn,                    ## warn level (and any above) active
#  lvlError,                   ## error level (and any above) active
#  lvlFatal,                   ## fatal level (and any above) active
#  lvlNone        

## UR: Universal Return objects

export Level

# DisplayClasses are based, somewhat, on Bootstrap CSS
#  https://getbootstrap.com

type
  # answers: how should it be interpreted or judged?
  #   when info, success, or warning, then 'value' should be set
  #   otherwise 'value' is not set.
  DisplayClass* = enum
    info,      # neutral (buy ok if forced to judge)
    success,   # ok
    warning,   # ok; but with reservations
    danger     # not ok
  # answers: who should be allowed see this?
  #   This also answer privacy questions.
  # To prevent confusion, this DOES NOT ANSWER:
  #   "who do we want to see it?"
  # it answers:
  #   "who is permitted to see it?"
  #
  # So for example, if you are okay with a 'user' see a message, but
  # you don't want to bother them with the trivia of actually seeing it,
  # then set: audience=user and level=lvlDebug
  Audience* = enum
    ops,          # server/system maintainer clearance
    admin,        # users with admin clearance
    user,         # regular users
    public        # the whole world (no restrictions)

type
  URevent* = ref object of RootObj
    ## The details of a single event.
    msg*: string                      # defaults to ""
    level*: Level                     # defaults to lvlAll
    class*: DisplayClass              # defaults to info
    audience*: Audience    # defaults to ops
  UR_universal* = ref object of RootObj
    ## This is the parent object that all ``UR_<type>`` objects inherit.
    ## 
    ## NOTE: while the ``detail`` property is on all ``UR_<type>`` object, the
    ## reference is ``nil`` if ``wrap_UR`` is used rather than ``wrap_UR_detail``.
    value_type*: string
    events*: seq[URevent]
    detail*: Table[string, string]    # dormant nil unless macro_UR_detail is used


proc newURevent(): URevent =
  result = URevent()
  result.msg = ""


proc create_UR_string(val_type: string, use_detail: bool): string {.compileTime.} =
  ## create the macro string
  result = ""
  result.add("type\n")
  result.add("  UR_$1* = ref object of UR_universal\n".format(val_type))
  result.add("    value*: $1\n".format(val_type))
  result.add("\n")
  result.add("proc has_value(self: UR_$1): bool {.used.} =\n".format(val_type))
  result.add("  if len(self.events) == 0:\n")
  result.add("    return false\n")
  result.add("  else:\n")
  result.add("    for event in self.events:\n")
  result.add("      if event.class == danger:\n")
  result.add("        return false\n")
  case val_type:
  of "string":
    result.add("  if self.value.isNil:\n")
    result.add("    return false\n")
  of "int", "int64", "int32", "float", "float32", "float64", "bool":
    discard
  else:
    result.add("  var EMPTYEQUIV = $1()\n".format(val_type))
    result.add("  if self.value==EMPTYEQUIV:\n")
    result.add("    return false\n")
  result.add("  return true\n")
  result.add("\n")
  result.add("proc newUR_$1(): UR_$1 = \n".format(val_type))
  result.add("  result = UR_$1()\n".format(val_type))
  result.add("  result.value_type = \"$1\"\n".format(val_type))
  result.add("  result.events = @[]\n")
  if use_detail:
    result.add("  result.detail = initTable[string, string]()\n")
  result.add("\n")


macro wrap_UR*(n: typed): typed =
  var s: string = ""
  #echo treeRepr n
  let val_type = $n
  #
  # define the object type
  #
  s.add(create_UR_string(val_type, false))
  #
  # generate code
  #
  parseStmt s


macro wrap_UR_detail*(n: typed): typed =
  var s: string = ""
  #echo treeRepr n
  let val_type = $n
  #
  # define the object type
  #
  s.add(create_UR_string(val_type, true))
  #
  # generate code
  #
  parseStmt s


wrap_UR(string)
wrap_UR(int)
wrap_UR(float)
wrap_UR(bool)


method ok*(ur: UR_universal): bool {.base.} =
  ## Determines whether evertink is okay, or if there are any errors
  ## If `ok` returns false, then there is no expectation of a value being set.
  ## If 'ok' returns true, then there IS an expectation of a set value.
  if len(ur.events) == 0:
    result = false
  else:
    result = true
    for event in ur.events:
      if event.class == danger:
        result = false
        break


method has_value*(ur: UR_universal): bool =
  ## Determines whether a value has been set
  ## Three conditions are checked:
  ## 
  ##   1. Are any events created from a ".set_X" method? If not, then returns false
  ##   2. Do any of the events have a class of "danger"? If so, then returns false
  ##   3. Does the .value of the object appear to be nil or the "default" value; if so, then returns false
  ## 
  ## Otherwise true is returned.
  ## 
  ## Note: Condition #3 is not universal due to the differing nature of types in Nim.
  false # defaults to false until an override has been made


method last_level*(ur: UR_universal): Level =
  ## Gets the last event's logging level
  if len(ur.events) == 0:
    result = lvlAll
  else:
    result = ur.events[^1].level


method `last_level=`*(ur: UR_universal, level: Level) =
  ## Sets the last event's level
  ## only works if an event has been created already; otherwise you will see a KeyError
  ur.events[^1].level = level


method last_class*(ur: UR_universal): DisplayClass =
  ## Gets the last event's display class
  if len(ur.events) == 0:
    result = info
  else:
    result = ur.events[^1].class


method `last_class=`*(ur: UR_universal, class: DisplayClass) =
  ## Sets the last event's class
  ## only works if an event has been created already; otherwise you will see a KeyError
  ur.events[^1].class = class


method last_audience*(ur: UR_universal): Audience =
  ## Gets the last event's audience
  if len(ur.events) == 0:
    result = ops
  else:
    result = ur.events[^1].audience


method `last_audience=`*(ur: UR_universal, audience: Audience) =
  ## Sets the last event's audience
  ## Only works if an event has been created already; otherwise you will see a KeyError
  ur.events[^1].audience = audience


method last_msg*(ur: UR_universal): string =
  ## Gets the last event's msg
  if len(ur.events) == 0:
    result = ""
  else:
    result = ur.events[^1].msg



method `last_msg=`*(ur: UR_universal, msg: string) =
  ## Sets the last event's msg
  ## Only works if an event has been created already; otherwise you will see a KeyError
  ur.events[^1].msg = msg



method has_info*(ur: UR_universal): bool =
  ## Returns true if there are any events with the ``info`` class
  result = false
  for event in ur.events:
    if event.class == info:
      result = true
      break


method has_success*(ur: UR_universal): bool =
  ## Returns true if there are any events with the ``success`` class
  result = false
  for event in ur.events:
    if event.class == success:
      result = true
      break


method has_warning*(ur: UR_universal): bool =
  ## Returns true if there are any events with the ``warning`` class
  result = false
  for event in ur.events:
    if event.class == warning:
      result = true
      break


method has_danger*(ur: UR_universal): bool =
  ## Returns true if there are any events with the ``danger`` class
  result = false
  for event in ur.events:
    if event.class == danger:
      result = true
      break


method info_msgs*(ur: UR_universal): seq[string] = 
  ## Returns a sequence of messsages marked with a class of ``info``
  result = @[]
  for event in ur.events:
    if event.class == info:
      result.add(event.msg)


method success_msgs*(ur: UR_universal): seq[string] = 
  ## Returns a sequence of messsages marked with a class of ``success``
  result = @[]
  for event in ur.events:
    if event.class == success:
      result.add(event.msg)


method warning_msgs*(ur: UR_universal): seq[string] = 
  ## Returns a sequence of messsages marked with a class of ``warning``
  result = @[]
  for event in ur.events:
    if event.class == warning:
      result.add(event.msg)


method danger_msgs*(ur: UR_universal): seq[string] = 
  ## Returns a sequence of messsages marked with a class of ``danger``
  result = @[]
  for event in ur.events:
    if event.class == danger:
      result.add(event.msg)


method all_msgs*(ur: UR_universal): seq[string] = 
  ## Returns all the messsages
  result = @[]
  for event in ur.events:
    result.add(event.msg)


method `$`*(ur: UR_universal): string =
  ## Creates a readable string of the events in the UR. This function is meant for simple debugging.
  result = "UR events:"
  for event in ur.events:
    result.add("  (class: $1, msg: $2)\n".format($event.class, event.msg))


# ######################################
#
#  COMMON RESPONSES
#
# ######################################


method set_success*(ur: UR_universal, msg: string, level=lvlNotice, class=success, audience=user): void =
  ## Declares a successful event of note. See defaults.
  ## Set the .value after declaring this.
  var event = URevent()
  event.msg = msg
  event.level = level
  event.class = class
  event.audience = audience
  ur.events.add(event)


method set_expected_success*(ur: UR_universal, msg: string, level=lvlDebug, class=success, audience=user): void =
  ## Declares a successful but typical event. See defaults.
  ## Set the .value after declaring this.
  var event = URevent()
  event.msg = msg
  event.level = level
  event.class = class
  event.audience = audience
  ur.events.add(event)


method set_failure*(ur: UR_universal, msg: string, level=lvlNotice, class=danger, audience=user): void =
  ## Declares a unexpected failure. But not a bug. See defaults.
  var event = URevent()
  event.msg = msg
  event.level = level
  event.class = class
  event.audience = audience
  ur.events.add(event)


method set_expected_failure*(ur: UR_universal, msg: string, level=lvlDebug, class=danger, audience=user): void =
  ## Declares an expected run-of-the-mill failure. Not worth logging. See defaults.
  var event = URevent()
  event.msg = msg
  event.level = level
  event.class = class
  event.audience = audience
  ur.events.add(event)


method set_internal_bug*(ur: UR_universal, msg: string, level=lvlError, class=danger, audience=ops): void =
  ## Declares a failure that should not have happened; aka "a bug". Should be logged for a developer to fix.
  var event = URevent()
  event.msg = msg
  event.level = level
  event.class = class
  event.audience = audience
  ur.events.add(event)


method set_critical_internal_bug*(ur: UR_universal, msg: string, level=lvlFatal, class=danger, audience=ops): void =
  ## Declares a failure that not only should not have happened but implies a severe problem, such as a security breach. Should be
  ## logged for top-priority analysis.
  var event = URevent()
  event.msg = msg
  event.level = level
  event.class = class
  event.audience = audience
  ur.events.add(event)

method set_note_to_public*(ur: UR_universal, msg: string, level=lvlNotice, class=info, audience=public): void =
  ## Declares public information that would be of interest to the entire world
  var event = URevent()
  event.msg = msg
  event.level = level
  event.class = class
  event.audience = audience
  ur.events.add(event)

method set_note_to_user*(ur: UR_universal, msg: string, level=lvlNotice, class=info, audience=user): void =
  ## Declares information that would be of interest to a user or member
  var event = URevent()
  event.msg = msg
  event.level = level
  event.class = class
  event.audience = audience
  ur.events.add(event)

method set_note_to_admin*(ur: UR_universal, msg: string, level=lvlNotice, class=info, audience=admin): void =
  ## Declares information that would be of interest to a user or member with admin rights
  var event = URevent()
  event.msg = msg
  event.level = level
  event.class = class
  event.audience = audience
  ur.events.add(event)

method set_note_to_ops*(ur: UR_universal, msg: string, level=lvlNotice, class=info, audience=ops): void =
  ## Declares information that would be of interest to IT or developers
  var event = URevent()
  event.msg = msg
  event.level = level
  event.class = class
  event.audience = audience
  ur.events.add(event)

method set_warning*(ur: UR_universal, msg: string, level=lvlNotice, class=warning, audience=user): void =
  ## Declares full success, but something seems odd; warrenting a warning.
  ## Recommend setting audience level to something appropriate.
  var event = URevent()
  event.msg = msg
  event.level = level
  event.class = class
  event.audience = audience
  ur.events.add(event)

method set_debug*(ur: UR_universal, msg: string, level=lvlDebug, class=info, audience=ops): void =
  ## Declares information only useful when debugging. Only seen by IT or developers.
  var event = URevent()
  event.msg = msg
  event.level = level
  event.class = class
  event.audience = audience
  ur.events.add(event)

