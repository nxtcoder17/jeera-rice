; extends

(
  (text) @injection.content
  (#set! injection.language "yaml")
)

; (
;  (text)+ @yamlComment (#eq? @yamlComment "#")
;  (text)+  @readmeComment (#match? @readmeComment "--")
; ) @comment
