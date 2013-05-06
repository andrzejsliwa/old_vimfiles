--- /home/manu/fill-column-indicator.el 2012-10-24 18:19:08.151067467 +0200
+++ /home/manu/.emacs.d/fill-column-indicator.el    2012-10-25 17:59:13.525141442 +0200
@@ -83,15 +83,6 @@
 ;; Other Options
 ;; =============

-;; When `truncate-lines' is nil, the effect of drawing a fill-column rule is
-;; very odd looking. Indeed, it makes little sense to use a rule to indicate
-;; the position of the fill column in that case (the positions at which the
-;; fill column falls in the visual display space won't, in general, be
-;; collinear).  For this reason, fci-mode sets truncate-lines to t in buffers
-;; in which it is enabled and restores it to its previous value when
-;; disabled.  You can turn this feature off by setting
-;; `fci-handle-truncate-lines' to nil.
-
 ;; If `line-move-visual' is t, then vertical navigation can behave oddly in
 ;; several edge cases while fci-mode is enabled (this is due to a bug in
 ;; Emacs's C code).  Accordingly, fci-mode sets line-move-visual to nil in
@@ -293,17 +284,6 @@
   :group 'fill-column-indicator
   :type 'boolean)

-(defcustom fci-handle-truncate-lines t
-  "Whether fci-mode should set truncate-lines to t while enabled.
-If non-nil, fci-mode will set truncate-lines to t in buffers in
-which it is enabled, and restore it to its previous value when
-disabled.
-
-Leaving this option set to the default value is recommended."
-  :group 'fill-column-indicator
-  :tag "Locally set truncate-lines to t during fci-mode"
-  :type 'boolean)
-
 (defcustom fci-handle-line-move-visual (version<= "23" emacs-version)
   "Whether fci-mode should set line-move-visual to nil while enabled.
 If non-nil, fci-mode will set line-move-visual to nil in buffers
@@ -340,7 +320,6 @@
 ;; Record prior state of buffer.
 (defvar fci-saved-line-move-visual)
 (defvar fci-line-move-visual-was-buffer-local)
-(defvar fci-saved-truncate-lines)
 (defvar fci-saved-eol)
 (defvar fci-made-display-table)

@@ -366,7 +345,6 @@
 ;; the mode is disabled.
 (defconst fci-internal-vars '(fci-saved-line-move-visual
                               fci-line-move-visual-was-buffer-local
-                              fci-saved-truncate-lines
                               fci-saved-eol
                               fci-made-display-table
                               fci-display-table-processed
@@ -579,9 +557,6 @@
                 fci-saved-line-move-visual line-move-visual
                 line-move-visual nil)
         (set (make-local-variable 'line-move-visual) nil)))
-    (when fci-handle-truncate-lines
-      (setq fci-saved-truncate-lines truncate-lines
-            truncate-lines t))
     (setq fci-local-vars-set t)))

 (defun fci-make-rule-string ()
@@ -714,8 +689,7 @@
       (if fci-line-move-visual-was-buffer-local
           (setq line-move-visual fci-saved-line-move-visual)
         (kill-local-variable 'line-move-visual)))
-    (when fci-handle-truncate-lines
-      (setq truncate-lines fci-saved-truncate-lines))))
+    ))

 (defun fci-restore-display-table ()
   "Restore the buffer display table when fci-mode is disabled."
@@ -742,6 +716,12 @@
   (mapc #'(lambda (o) (if (overlay-get o 'fci) (delete-overlay o)))
         (overlays-in start end)))

+(defun fci-delete-overlays-region-win (start end win)
+  "Delete overlays displaying the fill-column rule between START and END."
+  (mapc #'(lambda (o) (if (and (overlay-get o 'fci) (equal win (overlay-get o 'fci-win)))
+                          (delete-overlay o)))
+        (overlays-in start end)))
+
 (defun fci-delete-overlays-buffer ()
   "Delete all overlays displaying the fill-column rule in the current buffer."
   (save-restriction
@@ -771,7 +751,7 @@
 ;; only if we maintained the overlay center at an early position in the
 ;; buffer.  Since other packages that use overlays typically place them while
 ;; traversing the buffer in a forward direction, that would be a bad idea.
-(defun fci-put-overlays-region (start end)
+(defun fci-put-overlays-region (start end win)
   "Place overlays displaying the fill-column rule between START and END."
   (goto-char start)
   (let (o cc)
@@ -780,6 +760,8 @@
       (setq cc (current-column)
             o (make-overlay (match-beginning 0) (match-beginning 0)))
       (overlay-put o 'fci t)
+      (overlay-put o 'fci-win win)
+      (overlay-put o 'window win)
       (cond
        ((< cc fci-limit)
         (overlay-put o 'after-string fci-pre-limit-string))
@@ -789,6 +771,17 @@
         (overlay-put o 'after-string fci-at-limit-string)))
       (goto-char (match-end 0)))))

+(defun fci-redraw-region-win (start end _ignored win)
+  "Erase and redraw the fill-column rule between START and END."
+  (save-match-data
+    (save-excursion
+      (let ((inhibit-point-motion-hooks t))
+        (goto-char end)
+        (setq end (line-beginning-position 2))
+        (fci-delete-overlays-region-win start end win)
+        (if (> (window-width win) fci-rule-column)
+            (fci-put-overlays-region start end win))))))
+
 (defun fci-redraw-region (start end _ignored)
   "Erase and redraw the fill-column rule between START and END."
   (save-match-data
@@ -796,12 +789,13 @@
       (let ((inhibit-point-motion-hooks t))
         (goto-char end)
         (setq end (line-beginning-position 2))
-        (fci-delete-overlays-region start end)
-        (fci-put-overlays-region start end)))))
+        (fci-delete-overlays-region-win start end (selected-window))
+        (if (> (window-width (selected-window)) fci-rule-column)
+            (fci-put-overlays-region start end (selected-window)))))))

 (defun fci-redraw-window (win &optional start)
   "Redraw the fill-column rule in WIN starting from START."
-  (fci-redraw-region (or start (window-start win)) (window-end win t) 'ignored))
+  (fci-redraw-region-win (or start (window-start win)) (window-end win t) 'ignored win))

 ;; This doesn't determine the strictly minimum amount by which the rule needs
 ;; to be extended, but the amount used is always sufficient, and determining
