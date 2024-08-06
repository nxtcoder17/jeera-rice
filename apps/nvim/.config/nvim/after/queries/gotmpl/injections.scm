; extends

; (
;   (text) @injection.content
;   (#set! injection.language "yaml")
; )

; inherits html_tags

(text) @yaml

((text) @injection.content
 (#set! injection.language "html")
 (#set! injection.combined))

((text) @injection.content
 (#set! injection.language "javascript")
 (#set! injection.combined))
