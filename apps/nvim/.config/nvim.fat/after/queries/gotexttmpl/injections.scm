; inherits: gotmpl

; (
;   (text) @injection.content
;   (#set! injection.language "yaml")
; )

((text) @injection.content
 (#set! injection.language "yaml")
 (#set! injection.combined))

; inherits gotmpl

; (text) @yaml
;
; ((text) @injection.content
;  (#set! injection.language "html")
;  (#set! injection.combined))
;
; ((text) @injection.content
;  (#set! injection.language "javascript")
;  (#set! injection.combined))
