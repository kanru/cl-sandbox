Isolated
========

**A isolated environment for Common Lisp code evaluation**

Introduction
------------

Common Lisp expressions are evaluated in a isolated environment
which provides a subset of Common Lisp's features. In general, many
features related to symbols, packages and operating system have been
disabled. Some standard functions and macros have been replaced with
safer versions. The isolated is implemented in packages `ISOLATED-IMPL`
and `ISOLATED-CL`. Function `isolated:read-eval-print` is the interface
for isolated code evaluation.

Variable `isolated:*env*` is the name of the isolated package used
for evaluation. Use function `isolated:reset` to reset the package.

Getting started
---------------

```lisp
CL-USER> (ql:quickload "isolated")
CL-USER> (isolated:read-eval-print "(princ-to-string '(hello world))")
=> "(HELLO WORLD)"
CL-USER> (isolated:read-eval-print "(load \"~/quicklisp.lisp\")")
;; DISABLED-FEATURE: The feature LOAD is disabled.
NIL
```

Disabled symbols
-----------------

To find the list of disabled symbols/features

```lisp
(loop :for symbol :being :the :symbol :in (find-package :isolated-cl)
      :when (get symbol :isolated-locked)
        :collect symbol)
```

The source code
---------------

GitHub repository: <https://github.com/kanru/cl-isolated>


Copyright and license
---------------------

Copyright (C) 2014, 2020 Kan-Ru Chen <<kanru@kanru.info>>  
Copyright (C) 2012-2013 Teemu Likonen <<tlikonen@iki.fi>>  

This program is free software: you can redistribute it and/or modify it
under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or (at
your option) any later version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero
General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program. If not, see
<<http://www.gnu.org/licenses/agpl.html>>.

Acknowledgment
--------------

This library was forked from Teemu Likonen's **cl-eval-bot** project.
See <https://github.com/tlikonen/cl-eval-bot> for details.
