;;; sonic-pi.el --- A Emacs client for SonicPi
;; Version: 0.1.0
;; Package-Requires: ((cl-lib "0.5") (osc "0.1") (emacs "24"))
;; Keywords: SonicPi, Ruby

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;; This file is not part of GNU Emacs.

;;; Commentary:

;;; Usage:

;; M-x sonic-pi-jack-in

;;; Code:

(defgroup sonic-pi nil
  "A client for interacting with the SonicPi Server."
  :prefix "sonic-pi-"
  :group 'applications
  :link '(url-link :tag "Github" "https://github.com/repl-electric/sonic-pi.el")
  :link '(emacs-commentary-link :tag "Commentary" "Sonic Pi for Emacs"))

(require 'sonic-pi-mode)
(require 'sonic-pi-osc)

(defcustom sonic-pi-path
  "/Users/josephwilk/Workspace/josephwilk/ruby/sonic-pi"
  "Path to install of sonicpi"
  :type 'string
  :group 'sonic-pi)

(defvar sonic-pi-server-bin "app/server/bin/sonic-pi-server.rb")

(defun sonic-pi--ruby-present-p ()
  "Check ruby is on the executable path"
  (executable-find "ruby"))

(defun sonic-pi--sonic-pi-server-present-p ()
  "Check sonic-pi server is executable"
  (file-exists-p (sonic-pi-server)))

(defun sonic-pi-server () (format "%s/%s" sonic-pi-path sonic-pi-server-bin))

;;;###Autoload
(defun sonic-pi-jack-in (&optional prompt-project)
  "Boot and connect to the SonicPi Server"
  (interactive)
  (cond
   ((not (sonic-pi--ruby-present-p)) (message "Could not find a ruby (1.9.3+) executable to run SonicPi"))
   ((not (sonic-pi--ruby-present-p)) (message (format "Could not find a sonic-pi server in: %s" (sonic-pi-server))))
   (t
    (let* ((cmd (sonic-pi-server)))
      (start-file-process-shell-command
       "sonic-pi-server"
       "sonic-pi-sonic-pi-boom"
       cmd)
      (sonic-pi-connect)))))

;;;###autoload
(defun sonic-pi-connect (&optional prompt-project)
  "Connect to SonicPi Server"
  (interactive)
  (sonic-pi-osc-connect))

;;;###autoload
(eval-after-load 'ruby-mode
  '(progn
     (define-key ruby-mode-map (kbd "C-c M-j") 'sonic-pi-jack-in)
     (define-key ruby-mode-map (kbd "C-c M-c") 'sonic-pi-connect)))

(provide 'sonic-pi)

;;; sonic-pi.el ends here
