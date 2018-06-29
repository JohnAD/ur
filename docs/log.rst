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

-  `Procs <#12>`__

   -  `setURLogFormat <#setURLogFormat,proc>`__

-  `Methods <#14>`__

   -  `sendLog <#sendLog.e,UR_universal>`__

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

`logging <logging.html>`__, `strutils <strutils.html>`__,
`tables <tables.html>`__, `ur <ur.html>`__

.. raw:: html

   </div>

.. raw:: html

   <div id="12" class="section">

.. rubric:: `Procs <#12>`__
   :name: procs

` <>`__
::

    proc setURLogFormat(formatting_procedure: proc)

Have the supplied procedure formated the string used by sendLog

The supplied procedure must have parameters in the form of:

    (event: UREvent, detail: Table[string, string]): string

.. raw:: html

   </div>

.. raw:: html

   <div id="14" class="section">

.. rubric:: `Methods <#14>`__
   :name: methods

` <>`__
::

    method sendLog(ur: UR_universal) {.base, raises: [ValueError, Exception],
                                    tags: [TimeEffect, WriteIOEffect, ReadIOEffect].}

Sends all events to the Nim 'logging' module.

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

Made with Nim. Generated: 2018-06-29 17:50:57 UTC

.. raw:: html

   </div>

.. raw:: html

   </div>

.. raw:: html

   </div>

.. raw:: html

   </div>
