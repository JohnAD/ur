.. raw:: html

   <div id="documentId" class="document">

.. raw:: html

   <div class="container">

.. raw:: html

   <div class="row">

.. raw:: html

   <div class="three columns">

.. raw:: html

   <div id="global-links">

.. raw:: html

   </div>

.. raw:: html

   <div id="searchInput">

Search:

.. raw:: html

   </div>

.. raw:: html

   <div>

Group by: Section Type

.. raw:: html

   </div>

-  `Imports <#6>`__

-  `Types <#7>`__

   -  `DisplayClass <#DisplayClass>`__
   -  `Audience <#Audience>`__
   -  `URevent <#URevent>`__
   -  `UR\_universal <#UR_universal>`__
   -  `UR\_string <#UR_string>`__
   -  `UR\_int <#UR_int>`__
   -  `UR\_float <#UR_float>`__
   -  `UR\_bool <#UR_bool>`__

-  `Methods <#14>`__

   -  `okUR\_universal <#ok.e,UR_universal>`__
   -  `has\_valueUR\_universal <#has_value.e,UR_universal>`__
   -  `levelUR\_universal <#level.e,UR_universal>`__
   -  `level=UR\_universal <#level=.e,UR_universal,Level>`__
   -  `classUR\_universal <#class.e,UR_universal>`__
   -  `class=UR\_universal <#class=.e,UR_universal,DisplayClass>`__
   -  `audienceUR\_universal <#audience.e,UR_universal>`__
   -  `audience=UR\_universal <#audience=.e,UR_universal,Audience>`__
   -  `msgUR\_universal <#msg.e,UR_universal>`__
   -  `msg=UR\_universal <#msg=.e,UR_universal,string>`__
   -  `\`$\`UR\_universal <#$.e,UR_universal>`__
   -  `set\_successUR\_universal <#set_success.e,UR_universal,string>`__
   -  `set\_expected\_successUR\_universal <#set_expected_success.e,UR_universal,string>`__
   -  `set\_failureUR\_universal <#set_failure.e,UR_universal,string>`__
   -  `set\_expected\_failureUR\_universal <#set_expected_failure.e,UR_universal,string>`__
   -  `set\_internal\_bugUR\_universal <#set_internal_bug.e,UR_universal,string>`__
   -  `set\_critical\_internal\_bugUR\_universal <#set_critical_internal_bug.e,UR_universal,string>`__
   -  `set\_note\_to\_publicUR\_universal <#set_note_to_public.e,UR_universal,string>`__
   -  `set\_note\_to\_userUR\_universal <#set_note_to_user.e,UR_universal,string>`__
   -  `set\_note\_to\_adminUR\_universal <#set_note_to_admin.e,UR_universal,string>`__
   -  `set\_note\_to\_opsUR\_universal <#set_note_to_ops.e,UR_universal,string>`__
   -  `set\_warningUR\_universal <#set_warning.e,UR_universal,string>`__
   -  `set\_debugUR\_universal <#set_debug.e,UR_universal,string>`__

-  `Macros <#17>`__

   -  `wrap\_UR <#wrap_UR.m,typed>`__
   -  `wrap\_UR\_detail <#wrap_UR_detail.m,typed>`__

.. raw:: html

   </div>

.. raw:: html

   <div id="content" class="nine columns">

.. raw:: html

   <div id="tocRoot">

.. raw:: html

   </div>

.. raw:: html

   <div id="6" class="section">

.. rubric:: `Imports <#6>`__
   :name: imports

`macros <macros.html>`__, `logging <logging.html>`__,
`strutils <strutils.html>`__, `tables <tables.html>`__

.. raw:: html

   </div>

.. raw:: html

   <div id="7" class="section">

.. rubric:: `Types <#7>`__
   :name: types

` <>`__
::

    DisplayClass = enum
      info, success, warning, danger

` <>`__
::

    Audience = enum
      ops, admin, user, public

` <>`__
::

    URevent = ref object of RootObj
      msg*: string
      level*: Level
      class*: DisplayClass
      audience*: Audience

The details of a single event.
` <>`__
::

    UR_universal = ref object of RootObj
      value_type*: string
      events*: seq[URevent]
      detail*: Table[string, string]

This is the parent object that all ``UR_<type>`` objects inherit.

NOTE: while the ``detail`` property is on all ``UR_<type>`` object, the
reference is ``nil`` if ``wrap_UR`` is used rather than
``wrap_UR_detail``.

` <>`__
::

    UR_string = ref object of UR_universal
      value*: string

` <>`__
::

    UR_int = ref object of UR_universal
      value*: int

` <>`__
::

    UR_float = ref object of UR_universal
      value*: float

` <>`__
::

    UR_bool = ref object of UR_universal
      value*: bool

.. raw:: html

   </div>

.. raw:: html

   <div id="14" class="section">

.. rubric:: `Methods <#14>`__
   :name: methods

` <>`__
::

    method ok(ur: UR_universal): bool {.base, raises: [], tags: [].}

Determines whether evertink is okay, or if there are any errors If ok
returns false, then there is no expectation of a value being set. If
'ok' returns true, then there IS an expectation of a set value.
` <>`__
::

    method has_value(ur: UR_universal): bool {.raises: [], tags: [].}

Determines whether a value has been set Three conditions are checked:

    #. Are any events created from a ".set\_X" method? If not, then
       returns false
    #. Do any of the events have a class of "danger"? If so, then
       returns false
    #. Does the .value of the object appear to be nil or the "default"
       value; if so, then returns false

Otherwise true is returned.

Note: Condition #3 is not universal due to the differing nature of types
in Nim.

` <>`__
::

    method level(ur: UR_universal): Level {.raises: [], tags: [].}

Gets the last event's logging level
` <>`__
::

    method level=(ur: UR_universal; level: Level) {.raises: [], tags: [].}

Sets the last event's level only works if an event has been created
already; otherwise you will see a KeyError
` <>`__
::

    method class(ur: UR_universal): DisplayClass {.raises: [], tags: [].}

Gets the last event's display class
` <>`__
::

    method class=(ur: UR_universal; class: DisplayClass) {.raises: [], tags: [].}

Sets the last event's class only works if an event has been created
already; otherwise you will see a KeyError
` <>`__
::

    method audience(ur: UR_universal): Audience {.raises: [], tags: [].}

Gets the last event's audience
` <>`__
::

    method audience=(ur: UR_universal; audience: Audience) {.raises: [], tags: [].}

Sets the last event's audience Only works if an event has been created
already; otherwise you will see a KeyError
` <>`__
::

    method msg(ur: UR_universal): string {.raises: [], tags: [].}

Gets the last event's msg
` <>`__
::

    method msg=(ur: UR_universal; msg: string) {.raises: [], tags: [].}

Sets the last event's msg Only works if an event has been created
already; otherwise you will see a KeyError
` <>`__
::

    method `$`(ur: UR_universal): string {.raises: [ValueError], tags: [].}

Creates a readable string of the events in the UR. This function is
meant for simple debugging.
` <>`__
::

    method set_success(ur: UR_universal; msg: string; level = lvlNotice; class = success;
                      audience = user): void {.raises: [], tags: [].}

Declares a successful event of note. See defaults. Set the .value after
declaring this.
` <>`__
::

    method set_expected_success(ur: UR_universal; msg: string; level = lvlDebug;
                               class = success; audience = user): void {.raises: [], tags: [].}

Declares a successful but typical event. See defaults. Set the .value
after declaring this.
` <>`__
::

    method set_failure(ur: UR_universal; msg: string; level = lvlNotice; class = danger;
                      audience = user): void {.raises: [], tags: [].}

Declares a unexpected failure. But not a bug. See defaults.
` <>`__
::

    method set_expected_failure(ur: UR_universal; msg: string; level = lvlDebug;
                               class = danger; audience = user): void {.raises: [], tags: [].}

Declares an expected run-of-the-mill failure. Not worth logging. See
defaults.
` <>`__
::

    method set_internal_bug(ur: UR_universal; msg: string; level = lvlError; class = danger;
                           audience = ops): void {.raises: [], tags: [].}

Declares a failure that should not have happened; aka "a bug". Should be
logged for a developer to fix.
` <>`__
::

    method set_critical_internal_bug(ur: UR_universal; msg: string; level = lvlFatal;
                                    class = danger; audience = ops): void {.raises: [],
        tags: [].}

Declares a failure that not only should not have happened but implies a
severe problem, such as a security breach. Should be logged for
top-priority analysis.
` <>`__
::

    method set_note_to_public(ur: UR_universal; msg: string; level = lvlNotice;
                             class = info; audience = public): void {.raises: [], tags: [].}

Declares public information that would be of interest to the entire
world
` <>`__
::

    method set_note_to_user(ur: UR_universal; msg: string; level = lvlNotice; class = info;
                           audience = user): void {.raises: [], tags: [].}

Declares information that would be of interest to a user or member
` <>`__
::

    method set_note_to_admin(ur: UR_universal; msg: string; level = lvlNotice; class = info;
                            audience = admin): void {.raises: [], tags: [].}

Declares information that would be of interest to a user or member with
admin rights
` <>`__
::

    method set_note_to_ops(ur: UR_universal; msg: string; level = lvlNotice; class = info;
                          audience = ops): void {.raises: [], tags: [].}

Declares information that would be of interest to IT or developers
` <>`__
::

    method set_warning(ur: UR_universal; msg: string; level = lvlNotice; class = warning;
                      audience = user): void {.raises: [], tags: [].}

Declares full success, but something seems odd; warrenting a warning.
Recommend setting audience level to something appropriate.
` <>`__
::

    method set_debug(ur: UR_universal; msg: string; level = lvlDebug; class = info;
                    audience = ops): void {.raises: [], tags: [].}

Declares information only useful when debugging. Only seen by IT or
developers.

.. raw:: html

   </div>

.. raw:: html

   <div id="17" class="section">

.. rubric:: `Macros <#17>`__
   :name: macros

` <>`__
::

    macro wrap_UR(n: typed): typed

` <>`__
::

    macro wrap_UR_detail(n: typed): typed

.. raw:: html

   </div>

.. raw:: html

   </div>

.. raw:: html

   </div>

.. raw:: html

   <div class="row">

.. raw:: html

   <div class="twelve-columns footer">

Made with Nim. Generated: 2018-06-29 17:50:56 UTC

.. raw:: html

   </div>

.. raw:: html

   </div>

.. raw:: html

   </div>

.. raw:: html

   </div>
