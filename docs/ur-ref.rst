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


*source line: 385*

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


*source line: 367*

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


*source line: 411*

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


*source line: 405*

    The details of a single event.






Procs and Methods
=================


`$`
---------------------------------------------------------

.. code:: nim

    method `$`*(ur: UR_universal): string =

*source line: 707*

    Creates a readable string of the events in the UR. This function is meant for simple debugging.


`last_audience=`
---------------------------------------------------------

.. code:: nim

    method `last_audience=`*(ur: UR_universal, audience: Audience) =

*source line: 610*

    Sets the last event's audience
    Only works if an event has been created already; otherwise you will see a KeyError


`last_class=`
---------------------------------------------------------

.. code:: nim

    method `last_class=`*(ur: UR_universal, class: DisplayClass) =

*source line: 596*

    Sets the last event's class
    only works if an event has been created already; otherwise you will see a KeyError


`last_level=`
---------------------------------------------------------

.. code:: nim

    method `last_level=`*(ur: UR_universal, level: Level) =

*source line: 582*

    Sets the last event's level
    only works if an event has been created already; otherwise you will see a KeyError


`last_msg=`
---------------------------------------------------------

.. code:: nim

    method `last_msg=`*(ur: UR_universal, msg: string) =

*source line: 625*

    Sets the last event's msg
    Only works if an event has been created already; otherwise you will see a KeyError


all_msgs
---------------------------------------------------------

.. code:: nim

    method all_msgs*(ur: UR_universal): seq[string] =

*source line: 700*

    Returns all the messsages


danger_msgs
---------------------------------------------------------

.. code:: nim

    method danger_msgs*(ur: UR_universal): seq[string] =

*source line: 692*

    Returns a sequence of messsages marked with a class of ``danger``


has_danger
---------------------------------------------------------

.. code:: nim

    method has_danger*(ur: UR_universal): bool =

*source line: 659*

    Returns true if there are any events with the ``danger`` class


has_info
---------------------------------------------------------

.. code:: nim

    method has_info*(ur: UR_universal): bool =

*source line: 632*

    Returns true if there are any events with the ``info`` class


has_success
---------------------------------------------------------

.. code:: nim

    method has_success*(ur: UR_universal): bool =

*source line: 641*

    Returns true if there are any events with the ``success`` class


has_value
---------------------------------------------------------

.. code:: nim

    method has_value*(ur: UR_universal): bool =

*source line: 560*

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

*source line: 650*

    Returns true if there are any events with the ``warning`` class


info_msgs
---------------------------------------------------------

.. code:: nim

    method info_msgs*(ur: UR_universal): seq[string] =

*source line: 668*

    Returns a sequence of messsages marked with a class of ``info``


last_audience
---------------------------------------------------------

.. code:: nim

    method last_audience*(ur: UR_universal): Audience =

*source line: 602*

    Gets the last event's audience


last_class
---------------------------------------------------------

.. code:: nim

    method last_class*(ur: UR_universal): DisplayClass =

*source line: 588*

    Gets the last event's display class


last_level
---------------------------------------------------------

.. code:: nim

    method last_level*(ur: UR_universal): Level =

*source line: 574*

    Gets the last event's logging level


last_msg
---------------------------------------------------------

.. code:: nim

    method last_msg*(ur: UR_universal): string =

*source line: 616*

    Gets the last event's msg


newUR_<type>
---------------------------------------------------------

.. code:: nim

    proc newUR_<type>*(): UR_<type> =

*source line: 467*

    Create a new instance of UR_<type>. Where <type> is the data type passed
    into the ``wrap_UR`` or ``wrap_UR_detail`` macro.


ok
---------------------------------------------------------

.. code:: nim

    method ok*(ur: UR_universal): bool {.base.} =

*source line: 546*

    Determines whether evertink is okay, or if there are any errors
    If ``ok`` returns ``false``, then there is no expectation of a value being set.
    If ``ok`` returns ``true``, then there IS an expectation of a set value.


success_msgs
---------------------------------------------------------

.. code:: nim

    method success_msgs*(ur: UR_universal): seq[string] =

*source line: 676*

    Returns a sequence of messsages marked with a class of ``success``


warning_msgs
---------------------------------------------------------

.. code:: nim

    method warning_msgs*(ur: UR_universal): seq[string] =

*source line: 684*

    Returns a sequence of messsages marked with a class of ``warning``


set_critical_internal_bug
---------------------------------------------------------

.. code:: nim

    method set_critical_internal_bug*(ur: UR_universal, msg: string, level=lvlFatal, class=danger, audience=ops): void =

*source line: 778*

    Declares a failure that not only should not have happened but implies a severe problem, such as a security breach. Should be
    logged for top-priority analysis.


set_debug
---------------------------------------------------------

.. code:: nim

    method set_debug*(ur: UR_universal, msg: string, level=lvlDebug, class=info, audience=ops): void =

*source line: 840*

    Declares information only useful when debugging. Only seen by IT or developers.


set_expected_failure
---------------------------------------------------------

.. code:: nim

    method set_expected_failure*(ur: UR_universal, msg: string, level=lvlDebug, class=danger, audience=user): void =

*source line: 756*

    Declares an expected run-of-the-mill failure. Not worth logging. See defaults.


set_expected_success
---------------------------------------------------------

.. code:: nim

    method set_expected_success*(ur: UR_universal, msg: string, level=lvlDebug, class=success, audience=user): void =

*source line: 733*

    Declares a successful but typical event. See defaults.
    Set the .value after declaring this.


set_failure
---------------------------------------------------------

.. code:: nim

    method set_failure*(ur: UR_universal, msg: string, level=lvlNotice, class=danger, audience=user): void =

*source line: 745*

    Declares a unexpected failure. But not a bug. See defaults.


set_internal_bug
---------------------------------------------------------

.. code:: nim

    method set_internal_bug*(ur: UR_universal, msg: string, level=lvlError, class=danger, audience=ops): void =

*source line: 767*

    Declares a failure that should not have happened; aka "a bug". Should be logged for a developer to fix.


set_note_to_admin
---------------------------------------------------------

.. code:: nim

    method set_note_to_admin*(ur: UR_universal, msg: string, level=lvlNotice, class=info, audience=admin): void =

*source line: 809*

    Declares information that would be of interest to a user or member with admin rights


set_note_to_ops
---------------------------------------------------------

.. code:: nim

    method set_note_to_ops*(ur: UR_universal, msg: string, level=lvlNotice, class=info, audience=ops): void =

*source line: 819*

    Declares information that would be of interest to IT or developers


set_note_to_public
---------------------------------------------------------

.. code:: nim

    method set_note_to_public*(ur: UR_universal, msg: string, level=lvlNotice, class=info, audience=public): void =

*source line: 789*

    Declares public information that would be of interest to the entire world


set_note_to_user
---------------------------------------------------------

.. code:: nim

    method set_note_to_user*(ur: UR_universal, msg: string, level=lvlNotice, class=info, audience=user): void =

*source line: 799*

    Declares information that would be of interest to a user or member


set_success
---------------------------------------------------------

.. code:: nim

    method set_success*(ur: UR_universal, msg: string, level=lvlNotice, class=success, audience=user): void =

*source line: 721*

    Declares a successful event of note. See defaults.
    Set the .value after declaring this.


set_warning
---------------------------------------------------------

.. code:: nim

    method set_warning*(ur: UR_universal, msg: string, level=lvlNotice, class=warning, audience=user): void =

*source line: 829*

    Declares full success, but something seems odd; warrenting a warning.
    Recommend setting audience level to something appropriate.




Macros
======


wrap_UR
---------------------------------------------------------

.. code:: nim

    macro wrap_UR*(n: typed): typed =

*source line: 488*

    Create a **UR_<n>** model and attending methods at compile-time. See main documentation.


wrap_UR_detail
---------------------------------------------------------

.. code:: nim

    macro wrap_UR_detail*(n: typed): typed =

*source line: 517*

    Create a **UR_<n>** model, including ``detail``, and attending methods, at compile-time. See main documentation.



See also
========

- `General Documentation for ur <ur.rst>`__
- `Reference for module ur <ur-ref.rst>`__
- `Reference for module ur/log <ur-log-ref.rst>`__
