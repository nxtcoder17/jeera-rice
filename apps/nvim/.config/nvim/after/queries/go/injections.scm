; extends
;
; (
;   (comment) @injection.content
;   (#set! injection.language "markdown")
; )

(
  (block
    (short_var_declaration 
      (comment) @comment
      right: (expression_list) @injection.content
      (#eq? @comment "/*gotmpl*/")
      (#set! injection.include-children)
      (#offset! @injection.content 0 0 0 0)
      (#set! injection.language "gotmpl")
    )
  ) 
)

(
  (comment) @comment
  (literal_element
    (raw_string_literal) @injection.content
    (#eq? @comment "/*gotmpl*/")
    (#set! injection.include-children)
    (#offset! @injection.content 0 0 0 0)
    (#set! injection.language "gotmpl")
  ) 
)
