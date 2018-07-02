## A Universal Return (UR) is an object that allows the programmer to
## return either a value or a sequence of messages (or both) from a
## procedure. This could, of course, be done by hand using tuple or other
## options, but the goal of this package is two-fold:
## 
## 1. Make it easy (and predictable) to create such "dynamic" returns.
## 2. Make it possible to integrate such a system with other libraries.
## 
## **Table of Contents**
## 
## * `A Simple Example <#a-simple-example>`__
## * `Library Example <#library-example>`__
## * `The UR Object <#the-ur-object>`__
## * `Bonus: Adding Detail <#bonus-adding-detail>`__
## * `More Information <#more-information>`__
## 
## A Simple Example
## ----------------
## 
## The following is a very simple example of UR.
## 
## First, we are going to import the library and "wrap" the type of element
## we want to return.
## 
## .. code:: nim
## 
##     import ur
## 
## 
##     type
##       Vector = tuple[x: int, y: int]
## 
## 
##     wrap_UR(Vector)
## 
## The ``wrap_UR`` macro creates a ``UR_Vector`` object with large set of
## useful methods.
## 
## (Don't worry, with conditional compiling, Nim should later remove the
## methods you don't use.)
## 
## Now, we use the new object for returning a flexible result:
## 
## .. code:: nim
## 
##     import ur
## 
## 
##     type
##       Vector = tuple[x: float, y: float]
## 
## 
##     wrap_UR(Vector)
## 
##     proc reduceXByNumber(v: Vector, denominator: float): UR_Vector =
##       result = newUR_Vector()  # this procedure was generated by 'wrap_UR'
##       if denominator == 0.0:
##         result.set_failure("You can't divide by zero; Ever")
##         return
##       if denominator == 0.0:
##         result.set_failure("Negative denominators are not allowed")
##         return
##       if denominator < 0.1:
##         result.set_warning("That is an awefully small denominator")
##       newVector = v
##       newVector.x = newVector.x / denominator
##       result.value = newVector
##       result.set_expected_success("Vector x reduced")
## 
## 
##     # Now lets use it.
## 
##     var a = Vector(4.0, 3.2)
## 
##     var response = reduceXByNumber(a, 2.0)
##     if response.ok:
##       echo "my new x is " & $response.value.x
## 
##     # should display:
##     #
##     # > my new x is 2.0
## 
## 
##     response = reduceXByNumber(a, 0.0)
##     if not response.ok:
##       echo "error messages: " & $response
## 
##     # should display:
##     #
##     # error messages:
##     #...... TODO
## 
##     response = reduceXByNumber(a, 0.0001)
##     if response.ok:
##       echo "my new x is " & $response.value.x
##     if response.has_warnings:
##       echo "my warnings are " & $response.warnings
## 
##     # should display:
##     #
##     #.....TODO
## 
##     #
## 
## Library Example
## ---------------
## 
## Internally, UR has one library already integrated: Nim's standard
## ``logging`` module. You can use it by importing 'ur/log'.
## 
## For example:
## 
## .. code:: nim
## 
##     import
##       strutils,
##       logging
## 
##     import
##       ur,
##       ur/log
## 
## 
##     var L = newFileLogger("test.log", fmtStr = verboseFmtStr)
##     addHandler(L)
## 
## 
##     type
##       Vector = tuple[x: float, y: float]
## 
## 
##     wrap_UR(Vector)
## 
##     proc example(v: Vector): UR_Vector:
##       result = newUR_Vector()
##       result.value = v
##       result.value.x = result.value.x + 1.0
##       result.set_expected_success("x incremented by 1.0")
## 
##     var a = Vector(x: 9.3, y: 3.0)
## 
##     var response = a.example()
## 
##     echo "message: $1, x: $2".format(response.msg, response.value.x)
## 
##     response.sendLog()  # this sends the event(s) to logging
## 
## Now "test.log" will have an entry similar to this:
## 
## .. code:: log
## 
##     D, [2018-06-29T12:34:42] -- app: success; user; x incremented by 1.0
## 
## All filtering for ``sendLog`` is done by ``logging``; and that library
## strictly looks at the ``level`` attribute.
## 
## The UR Object
## -------------
## 
## UR is all about the automatically generate UR\_\ *object* objects. The
## objects are defined internally as:
## 
## .. code:: nim
## 
##     type
## 
##       URevent*
##         msg*: string                     
##         level*: Level                    
##         class*: DisplayClass             
##         audience*: Audience 
## 
##       UR_<type>
##         events*: seq[URevent]
##         value*: <type>
## 
## So, essentially, there is a list of events (messages) and the value
## being returned.
## 
## Each event has a message and three very distinct attributes.
## 
## level
## ~~~~~
## 
## The ``level`` is the degree of distribution for the message.
## 
## It answers the question: *How Important is This?*
## 
## The available levels:
## 
## -  ``lvlAll``
## -  ``lvlDebug``
## -  ``lvlInfo``
## -  ``lvlNotice``
## -  ``lvlWarn``
## -  ``lvlError``
## -  ``lvlFatal``
## -  ``lvlNone``
## 
## The ``level`` definitions are set by the ``logging`` standard library
## that is part of Nim. See: https://nim-lang.org/docs/logging.html
## 
## NOTE: the names of the levels are somewhat misleading. Using a level of
## ``lvlError`` does NOT mean that an error has occured. It means *"if I'm
## filtering a log for mostly errors, this message should show up in that
## log"*.
## 
## For judging the character of the event, use the ``class``.
## 
## class
## ~~~~~
## 
## The ``class`` is the judgement of the event.
## 
## it answers the question: *Is this a good or bad event?*
## 
## Only four classes are possible:
## 
## -  ``info`` - a neutral message adding extra information
## -  ``success`` - everything worked
## -  ``warning`` - everything worked, but something is suspicious
## -  ``danger`` - failure/error/bug
## 
## The ``class`` definitions are from the Boostrap CSS project. See:
## https://getbootstrap.com
## 
## audience
## ~~~~~~~~
## 
## The ``audience`` is, not surpisingly, the intended audience for any
## message about the event.
## 
## In a traditional 'logger' or SYSLOG system, the intended audience is
## strictly ``ops``. UR allows for further targets; useful when UR is
## integrated with web apps or other development frameworks.
## 
## It answers the question: *Who is permitted to see This?*
## 
## The possible audiences are:
## 
## -  ``ops`` - IT staff, developers, software agents
## -  ``admin`` - users with admin clearance
## -  ``user`` - regular end users / registered members
## -  ``public`` - the whole world (no restrictions)
## 
## Each audience permission is more restrictive than the previous. So,
## ``ops`` can see all events. But ``admin`` can only see ``admin``,
## ``user`` and ``public`` events. And so on.
## 
## Combining the attributes together.
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## 
## The attributes are meant to be combined when making decisions.
## 
## For example, an event with an ``audience`` of ``user`` but a ``level``
## of ``lvlDebug`` probably won't be shown to the end user. Essentially,
## they have permission to see the message, but won't because harrasing an
## end user with debug messages is not a friendly thing to do.
## 
## Bonus: Adding Detail
## --------------------
## 
## There is also wrapper called ``wrap_UR_detail`` that adds a table of
## strings to a UR called ``detail``. The purpose of this is to allow more
## sophisticated logging and handling of events. Of course, adding such
## support also increases the overhead of UR; so please take that into
## consideration.
## 
## Building on the earlier example for logging:
## 
## .. code:: nim
## 
##     import
##       strutils,
##       logging
## 
##     import
##       ur,
##       ur/log
## 
##     var L = newFileLogger("test.log", fmtStr = verboseFmtStr)
##     addHandler(L)
## 
## 
##     type
##       Vector = tuple[x: float, y: float]
## 
## 
##     wrap_UR_detail(Vector)
## 
##     proc example(v: Vector, category: string): UR_Vector:
##       result = newUR_Vector()
##       result.value = v
##       result.value.x = result.value.x + 1.0
##       result.set_expected_success("x incremented by 1.0")
##       result.detail["category"] = category
## 
##     var a = Vector(x: 9.3, y: 3.0)
## 
##     var response = a.example("project abc")
## 
##     echo "message: $1, category: $2".format(response.msg, response.detail["category"])
## 
## To use the detail in the context of ``ur/log``, there is a procedure
## called ``setURLogFormat``. It is expecting a pointer to a procedure.
## That procedure *must* have the following parameters:
## 
## .. code:: nim
## 
##     (event: UREvent, detail: Table[string, string]): string
## 
## So, for example:
## 
## .. code:: nim
## 
##     var L = newFileLogger("test.log", fmtStr = verboseFmtStr)
##     addHandler(L)
## 
##     proc my_example_format(event: UREvent, detail: Table[string, string]): string =
##       var category = "unknown"
##       if detail.hasKey("category"):
##         category = detail["category"]
##       result = "[$1] [$2] $3".format(event.class, category, event.msg)
## 
##     setURLogFormat(my_example_format)
## 
## Now, the entry in "test.log" will look like:
## 
## .. code:: log
## 
##     D, [2018-06-29T12:34:42] -- app: [success] [project abc] x incremented by 1.0
## 
## NOTE: the ``setURLLogFormat`` procedure also works with the simpler
## ``wrap_UR``. The ``detail`` table will simply be empty.
## 
## More Information
## ----------------
## 
## Additional references and articles:
## 
## -  `module documentation: ur <docs/index-ref.rst>`__

import
  macros,
  logging,
  strutils,
  tables

export Level

type
  DisplayClass* = enum
    ## info    = neutral (but ok if forced to judge)
    ## success = 
    ## warning = ok; but with reservations
    ## danger  = not ok
    info,
    success,
    warning,
    danger
  Audience* = enum
    ## ops    = server/system maintainer clearance
    ## admin  = users with admin clearance
    ## user   = regular users (not public)
    ## public = the whole world (no restrictions)
    ops,
    admin,
    user,
    public

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
    ## NOTE: while the ``detail`` property is on all ``UR_<type>`` objects, the
    ## reference remains ``nil`` if ``wrap_UR`` is used rather than
    ## ``wrap_UR_detail``.
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
  ## Create a UR_<n> model and attending methods at compile-time. See main documentation.
  var s: string = ""
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
  ## Create a UR_<n> model, including ``detail``,and attending methods, at compile-time. See main documentation.
  var s: string = ""
  let val_type = $n
  #
  # define the object type
  #
  s.add(create_UR_string(val_type, true))
  #
  # generate code
  #
  parseStmt s


method ok*(ur: UR_universal): bool {.base.} =
  ## Determines whether evertink is okay, or if there are any errors
  ## If ``ok`` returns ``false``, then there is no expectation of a value being set.
  ## If ``ok`` returns ``true``, then there IS an expectation of a set value.
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

