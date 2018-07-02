Module ur References
==============================================================================

The following are the references for ur.



Types
-----


.. code:: nim

    Audience* = enum
      ops,
      admin,
      user,
      public


source line: 361

ops    = server/system maintainer clearance
admin  = users with admin clearance
user   = regular users (not public)
public = the whole world (no restrictions)


.. code:: nim

    DisplayClass* = enum
      info,
      success,
      warning,
      danger


source line: 352

info    = neutral (but ok if forced to judge)
success =
warning = ok; but with reservations
danger  = not ok


.. code:: nim

    UR_universal* = ref object of RootObj
      value_type*: string
      events*: seq[URevent]
      detail*: Table[string, string]    # dormant nil unless macro_UR_detail is used


source line: 378

This is the parent object that all ``UR_<type>`` objects inherit.

NOTE: while the ``detail`` property is on all ``UR_<type>`` objects, the
reference remains ``nil`` if ``wrap_UR`` is used rather than
``wrap_UR_detail``.


.. code:: nim

    URevent* = ref object of RootObj
      msg*: string                      # defaults to ""
      level*: Level                     # defaults to lvlAll
      class*: DisplayClass              # defaults to info
      audience*: Audience    # defaults to ops


source line: 372

The details of a single event.






Procs
-----


.. code:: nim

    method `$`*(ur: UR_universal): string =

source line: 618

Creates a readable string of the events in the UR. This function is meant for simple debugging.


.. code:: nim

    method `last_audience=`*(ur: UR_universal, audience: Audience) =

source line: 521

Sets the last event's audience
Only works if an event has been created already; otherwise you will see a KeyError


.. code:: nim

    method `last_class=`*(ur: UR_universal, class: DisplayClass) =

source line: 507

Sets the last event's class
only works if an event has been created already; otherwise you will see a KeyError


.. code:: nim

    method `last_level=`*(ur: UR_universal, level: Level) =

source line: 493

Sets the last event's level
only works if an event has been created already; otherwise you will see a KeyError


.. code:: nim

    method `last_msg=`*(ur: UR_universal, msg: string) =

source line: 536

Sets the last event's msg
Only works if an event has been created already; otherwise you will see a KeyError


.. code:: nim

    method all_msgs*(ur: UR_universal): seq[string] =

source line: 611

Returns all the messsages


.. code:: nim

    method danger_msgs*(ur: UR_universal): seq[string] =

source line: 603

Returns a sequence of messsages marked with a class of ``danger``


.. code:: nim

    method has_danger*(ur: UR_universal): bool =

source line: 570

Returns true if there are any events with the ``danger`` class


.. code:: nim

    method has_info*(ur: UR_universal): bool =

source line: 543

Returns true if there are any events with the ``info`` class


.. code:: nim

    method has_success*(ur: UR_universal): bool =

source line: 552

Returns true if there are any events with the ``success`` class


.. code:: nim

    method has_value*(ur: UR_universal): bool =

source line: 471

Determines whether a value has been set
Three conditions are checked:

  1. Are any events created from a ".set_X" method? If not, then returns false
  2. Do any of the events have a class of "danger"? If so, then returns false
  3. Does the .value of the object appear to be nil or the "default" value; if so, then returns false

Otherwise true is returned.

Note: Condition #3 is not universal due to the differing nature of types in Nim.


.. code:: nim

    method has_warning*(ur: UR_universal): bool =

source line: 561

Returns true if there are any events with the ``warning`` class


.. code:: nim

    method info_msgs*(ur: UR_universal): seq[string] =

source line: 579

Returns a sequence of messsages marked with a class of ``info``


.. code:: nim

    method last_audience*(ur: UR_universal): Audience =

source line: 513

Gets the last event's audience


.. code:: nim

    method last_class*(ur: UR_universal): DisplayClass =

source line: 499

Gets the last event's display class


.. code:: nim

    method last_level*(ur: UR_universal): Level =

source line: 485

Gets the last event's logging level


.. code:: nim

    method last_msg*(ur: UR_universal): string =

source line: 527

Gets the last event's msg


.. code:: nim

    method ok*(ur: UR_universal): bool {.base.} =

source line: 457

Determines whether evertink is okay, or if there are any errors
If ``ok`` returns ``false``, then there is no expectation of a value being set.
If ``ok`` returns ``true``, then there IS an expectation of a set value.


.. code:: nim

    method set_critical_internal_bug*(ur: UR_universal, msg: string, level=lvlFatal, class=danger, audience=ops): void =

source line: 684

Declares a failure that not only should not have happened but implies a severe problem, such as a security breach. Should be
logged for top-priority analysis.


.. code:: nim

    method set_debug*(ur: UR_universal, msg: string, level=lvlDebug, class=info, audience=ops): void =

source line: 740

Declares information only useful when debugging. Only seen by IT or developers.


.. code:: nim

    method set_expected_failure*(ur: UR_universal, msg: string, level=lvlDebug, class=danger, audience=user): void =

source line: 664

Declares an expected run-of-the-mill failure. Not worth logging. See defaults.


.. code:: nim

    method set_expected_success*(ur: UR_universal, msg: string, level=lvlDebug, class=success, audience=user): void =

source line: 643

Declares a successful but typical event. See defaults.
Set the .value after declaring this.


.. code:: nim

    method set_failure*(ur: UR_universal, msg: string, level=lvlNotice, class=danger, audience=user): void =

source line: 654

Declares a unexpected failure. But not a bug. See defaults.


.. code:: nim

    method set_internal_bug*(ur: UR_universal, msg: string, level=lvlError, class=danger, audience=ops): void =

source line: 674

Declares a failure that should not have happened; aka "a bug". Should be logged for a developer to fix.


.. code:: nim

    method set_note_to_admin*(ur: UR_universal, msg: string, level=lvlNotice, class=info, audience=admin): void =

source line: 712

Declares information that would be of interest to a user or member with admin rights


.. code:: nim

    method set_note_to_ops*(ur: UR_universal, msg: string, level=lvlNotice, class=info, audience=ops): void =

source line: 721

Declares information that would be of interest to IT or developers


.. code:: nim

    method set_note_to_public*(ur: UR_universal, msg: string, level=lvlNotice, class=info, audience=public): void =

source line: 694

Declares public information that would be of interest to the entire world


.. code:: nim

    method set_note_to_user*(ur: UR_universal, msg: string, level=lvlNotice, class=info, audience=user): void =

source line: 703

Declares information that would be of interest to a user or member


.. code:: nim

    method set_success*(ur: UR_universal, msg: string, level=lvlNotice, class=success, audience=user): void =

source line: 632

Declares a successful event of note. See defaults.
Set the .value after declaring this.


.. code:: nim

    method set_warning*(ur: UR_universal, msg: string, level=lvlNotice, class=warning, audience=user): void =

source line: 730

Declares full success, but something seems odd; warrenting a warning.
Recommend setting audience level to something appropriate.


.. code:: nim

    method success_msgs*(ur: UR_universal): seq[string] =

source line: 587

Returns a sequence of messsages marked with a class of ``success``


.. code:: nim

    method warning_msgs*(ur: UR_universal): seq[string] =

source line: 595

Returns a sequence of messsages marked with a class of ``warning``



