# universal return
#

import
  macros,
  logging


# 'Level'
# answers: how serious is the message?
#    Despite names like 'warn', it is not a description
#    of positive/negative result; or of distribution.
#    It is a treshhold of log priority.
#
export Level

# DisplayClasses are based, somewhat, on Bootstrap CSS
#  https://getbootstrap.com

type
  # answers: how should it be interpreted or judged?
  #   when info, success, or warning, then 'value' should be set
  #   otherwise 'value' is not set.
  DisplayClass* = enum
    info,      # ok
    success,   # ok
    warning,   # ok; but with reservations
    danger,    # not okay
    bug        # not okay; systemically it should never happen
  # answers: who should see this?
  #   This also answer privacy questions.
  #   when set to nobody, then the 'msg' is probably not set.
  #   otherwise, 'msg' should be set.
  DisplayAudience* = enum
    nobody,       # don't store anything
    ops,          # server/system maintainer clearance
    admin,        # users with admin clearance
    user,         # regular users
    public        # the whole world (no restrictions)

type
  UR_universal* = ref object of RootObj
    value_type*: string
    msg*: string             # defaults to ""
    level*: Level            # defaults to lvlAll
    class*: DisplayClass     # defaults to info
    aud*: DisplayAudience    # defaults to nobody


proc create_UR_string*(val_type: string): string =
  ## create the macro string. can be called by external macros.
  result = ""
  result.add("type\n")
  result.add("  UR_" & val_type & "* = ref object of UR_universal\n")
  result.add("    value*: " & val_type & "\n")
  result.add("\n")
  result.add("proc newUR_" & val_type & "(): UR_" & val_type & " = \n")
  result.add("  result = UR_" & val_type & "()\n")
  result.add("  result.value_type = \"" & val_type & "\"\n")
  result.add("  result.msg = \"\"\n")
  result.add("\n")

macro create_UR*(n: typed): typed =
  var s: string = ""
  echo treeRepr n
  let val_type = $n
  #
  # define the object type
  #
  s.add(create_UR_string(val_type))
  #
  # generate code
  #
  parseStmt s


create_UR(string)
create_UR(int)
create_UR(float)
create_UR(bool)

method ok*(ur: UR_universal): bool {.base.} =
  case ur.class:
  of info, success, warning:
    result = true
  else:
    result = false

method has_value*(ur: UR_universal): bool =
  case ur.class:
  of info, success, warning:
    result = true
  else:
    result = false

# ######################################
#
#  COMMON RESPONSES
#
# ######################################

method set_success*(ur: var UR_universal, msg: string, level=lvlNotice, class=success, aud = user): void =
  echo "here"
  ur.msg = msg
  ur.level = level
  ur.class = class
  ur.aud = aud

