Module ur References
==============================================================================

The following are the references for ur.



Types
=====


Audience
---------------------------------------------------------

.. code:: nim

    Audience* = enum
      ops,
      admin,
      user,
      public


*source line: 370*

Permission level for news of the event.

ops
  only seen by those with server/system maintainer clearance

admin
  only seen by end-users with admin clearance (and ops)

user
  only seen by regular users (and admin and ops)

public
  the whole world (no restrictions)


DisplayClass
---------------------------------------------------------

.. code:: nim

    DisplayClass* = enum
      info,
      success,
      warning,
      danger


*source line: 352*

Judgement of the type of event.

info
    neutral (but ok if forced to judge)

success
    ok

warning
    ok; but with reservations

danger
    not ok


UR_universal
---------------------------------------------------------

.. code:: nim

    UR_universal* = ref object of RootObj
      value_type*: string
      events*: seq[URevent]
      detail*: Table[string, string]    # dormant nil unless macro_UR_detail is used


*source line: 396*

This is the parent object that all ``UR_<type>`` objects inherit.

NOTE: while the ``detail`` property is on all ``UR_<type>`` objects, the
reference remains ``nil`` if ``wrap_UR`` is used rather than
``wrap_UR_detail``.


URevent
---------------------------------------------------------

.. code:: nim

    URevent* = ref object of RootObj
      msg*: string                      # defaults to ""
      level*: Level                     # defaults to lvlAll
      class*: DisplayClass              # defaults to info
      audience*: Audience    # defaults to ops


*source line: 390*

The details of a single event.






Procs and Methods
=================


`$`
---------------------------------------------------------

.. code:: nim

    method `$`*(ur: UR_universal): string =

*source line: 636*

Creates a readable string of the events in the UR. This function is meant for simple debugging.


`last_audience=`
---------------------------------------------------------

.. code:: nim

    method `last_audience=`*(ur: UR_universal, audience: Audience) =

*source line: 539*

Sets the last event's audience
Only works if an event has been created already; otherwise you will see a KeyError


`last_class=`
---------------------------------------------------------

.. code:: nim

    method `last_class=`*(ur: UR_universal, class: DisplayClass) =

*source line: 525*

Sets the last event's class
only works if an event has been created already; otherwise you will see a KeyError


`last_level=`
---------------------------------------------------------

.. code:: nim

    method `last_level=`*(ur: UR_universal, level: Level) =

*source line: 511*

Sets the last event's level
only works if an event has been created already; otherwise you will see a KeyError


`last_msg=`
---------------------------------------------------------

.. code:: nim

    method `last_msg=`*(ur: UR_universal, msg: string) =

*source line: 554*

Sets the last event's msg
Only works if an event has been created already; otherwise you will see a KeyError


all_msgs
---------------------------------------------------------

.. code:: nim

    method all_msgs*(ur: UR_universal): seq[string] =

*source line: 629*

Returns all the messsages


danger_msgs
---------------------------------------------------------

.. code:: nim

    method danger_msgs*(ur: UR_universal): seq[string] =

*source line: 621*

Returns a sequence of messsages marked with a class of ``danger``


has_danger
---------------------------------------------------------

.. code:: nim

    method has_danger*(ur: UR_universal): bool =

*source line: 588*

Returns true if there are any events with the ``danger`` class


has_info
---------------------------------------------------------

.. code:: nim

    method has_info*(ur: UR_universal): bool =

*source line: 561*

Returns true if there are any events with the ``info`` class


has_success
---------------------------------------------------------

.. code:: nim

    method has_success*(ur: UR_universal): bool =

*source line: 570*

Returns true if there are any events with the ``success`` class


has_value
---------------------------------------------------------

.. code:: nim

    method has_value*(ur: UR_universal): bool =

*source line: 489*

Determines whether a value has been set
Three conditions are checked:

  1. Are any events created from a ".set_X" method? If not, then returns false
  2. Do any of the events have a class of "danger"? If so, then returns false
  3. Does the .value of the object appear to be nil or the "default" value; if so, then returns false

Otherwise true is returned.

Note: Condition #3 is not universal due to the differing nature of types in Nim.


has_warning
---------------------------------------------------------

.. code:: nim

    method has_warning*(ur: UR_universal): bool =

*source line: 579*

Returns true if there are any events with the ``warning`` class


info_msgs
---------------------------------------------------------

.. code:: nim

    method info_msgs*(ur: UR_universal): seq[string] =

*source line: 597*

Returns a sequence of messsages marked with a class of ``info``


last_audience
---------------------------------------------------------

.. code:: nim

    method last_audience*(ur: UR_universal): Audience =

*source line: 531*

Gets the last event's audience


last_class
---------------------------------------------------------

.. code:: nim

    method last_class*(ur: UR_universal): DisplayClass =

*source line: 517*

Gets the last event's display class


last_level
---------------------------------------------------------

.. code:: nim

    method last_level*(ur: UR_universal): Level =

*source line: 503*

Gets the last event's logging level


last_msg
---------------------------------------------------------

.. code:: nim

    method last_msg*(ur: UR_universal): string =

*source line: 545*

Gets the last event's msg


ok
---------------------------------------------------------

.. code:: nim

    method ok*(ur: UR_universal): bool {.base.} =

*source line: 475*

Determines whether evertink is okay, or if there are any errors
If ``ok`` returns ``false``, then there is no expectation of a value being set.
If ``ok`` returns ``true``, then there IS an expectation of a set value.


set_critical_internal_bug
---------------------------------------------------------

.. code:: nim

    method set_critical_internal_bug*(ur: UR_universal, msg: string, level=lvlFatal, class=danger, audience=ops): void =

*source line: 702*

Declares a failure that not only should not have happened but implies a severe problem, such as a security breach. Should be
logged for top-priority analysis.


set_debug
---------------------------------------------------------

.. code:: nim

    method set_debug*(ur: UR_universal, msg: string, level=lvlDebug, class=info, audience=ops): void =

*source line: 758*

Declares information only useful when debugging. Only seen by IT or developers.


set_expected_failure
---------------------------------------------------------

.. code:: nim

    method set_expected_failure*(ur: UR_universal, msg: string, level=lvlDebug, class=danger, audience=user): void =

*source line: 682*

Declares an expected run-of-the-mill failure. Not worth logging. See defaults.


set_expected_success
---------------------------------------------------------

.. code:: nim

    method set_expected_success*(ur: UR_universal, msg: string, level=lvlDebug, class=success, audience=user): void =

*source line: 661*

Declares a successful but typical event. See defaults.
Set the .value after declaring this.


set_failure
---------------------------------------------------------

.. code:: nim

    method set_failure*(ur: UR_universal, msg: string, level=lvlNotice, class=danger, audience=user): void =

*source line: 672*

Declares a unexpected failure. But not a bug. See defaults.


set_internal_bug
---------------------------------------------------------

.. code:: nim

    method set_internal_bug*(ur: UR_universal, msg: string, level=lvlError, class=danger, audience=ops): void =

*source line: 692*

Declares a failure that should not have happened; aka "a bug". Should be logged for a developer to fix.


set_note_to_admin
---------------------------------------------------------

.. code:: nim

    method set_note_to_admin*(ur: UR_universal, msg: string, level=lvlNotice, class=info, audience=admin): void =

*source line: 730*

Declares information that would be of interest to a user or member with admin rights


set_note_to_ops
---------------------------------------------------------

.. code:: nim

    method set_note_to_ops*(ur: UR_universal, msg: string, level=lvlNotice, class=info, audience=ops): void =

*source line: 739*

Declares information that would be of interest to IT or developers


set_note_to_public
---------------------------------------------------------

.. code:: nim

    method set_note_to_public*(ur: UR_universal, msg: string, level=lvlNotice, class=info, audience=public): void =

*source line: 712*

Declares public information that would be of interest to the entire world


set_note_to_user
---------------------------------------------------------

.. code:: nim

    method set_note_to_user*(ur: UR_universal, msg: string, level=lvlNotice, class=info, audience=user): void =

*source line: 721*

Declares information that would be of interest to a user or member


set_success
---------------------------------------------------------

.. code:: nim

    method set_success*(ur: UR_universal, msg: string, level=lvlNotice, class=success, audience=user): void =

*source line: 650*

Declares a successful event of note. See defaults.
Set the .value after declaring this.


set_warning
---------------------------------------------------------

.. code:: nim

    method set_warning*(ur: UR_universal, msg: string, level=lvlNotice, class=warning, audience=user): void =

*source line: 748*

Declares full success, but something seems odd; warrenting a warning.
Recommend setting audience level to something appropriate.


success_msgs
---------------------------------------------------------

.. code:: nim

    method success_msgs*(ur: UR_universal): seq[string] =

*source line: 605*

Returns a sequence of messsages marked with a class of ``success``


warning_msgs
---------------------------------------------------------

.. code:: nim

    method warning_msgs*(ur: UR_universal): seq[string] =

*source line: 613*

Returns a sequence of messsages marked with a class of ``warning``



