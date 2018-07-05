Module ur/log References
==============================================================================

The following are the references for ur/log.






Procs and Methods
=================


sendLog
---------------------------------------------------------

.. code:: nim

    method sendLog*(ur: UR_universal) {.base.} =

*source line: 25*

Sends all events to the Nim 'logging' module.


setURLogFormat
---------------------------------------------------------

.. code:: nim

    proc setURLogFormat*(formatting_procedure: proc) =

*source line: 17*

Have the supplied procedure formated the string used by sendLog

The supplied procedure must have parameters in the form of:

  (event: UREvent, detail: Table[string, string]): string



Macros
======



Table Of Contents
=================

- `General Documentation for **{{ur}}** <index.rst>`__
- `Reference for module **{{ur}}** <ur-ref.rst>`__
- `Reference for module **{{ur/log}}** <ur-log-ref.rst>`__
