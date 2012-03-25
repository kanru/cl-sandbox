;;; Eval-bot loader

(flet ((probe-load (path &optional (default (user-homedir-pathname)))
         (let ((path (merge-pathnames path default)))
           (when (probe-file path) (load path))))
       (funcallstr (string &rest args)
         (apply (read-from-string string) args)))
  (or (probe-load #p"quicklisp/setup.lisp")
      (probe-load #p".quicklisp/setup.lisp")
      (let ((url "http://beta.quicklisp.org/quicklisp.lisp")
            (init (nth-value 1 (progn
                                 (require :sb-posix)
                                 (funcallstr "sb-posix:mkstemp"
                                             "/tmp/quicklisp-XXXXXX")))))
        (unwind-protect
             (progn
               (sb-ext:run-program "wget" (list "-O" init "--" url)
                                   :search t :output t)
               (when (probe-load init)
                 (funcallstr "quicklisp-quickstart:install")))
          (delete-file init)))))

(ql:quickload '("bordeaux-threads" "trivial-irc" "alexandria"
                "split-sequence" "swank"))

(load "sandbox-impl.lisp")
(load "sandbox-pkg.lisp")
(load "clhs-url.lisp")
(load "eval-bot.lisp")

(in-package #:eval-bot)

(defparameter *freenode*
  (make-client :server "irc.freenode.net"
               :nickname "clbot"
               :username "clbot"
               :realname "Common Lisp bot"
               :listen-targets nil
               :auto-join nil))

(handler-case (swank:create-server :port 50000 :dont-close t)
  (sb-bsd-sockets:address-in-use-error ()
    (format t "~&Swank port already in use. Exiting.~%")
    (sb-ext:quit :unix-status 1)))