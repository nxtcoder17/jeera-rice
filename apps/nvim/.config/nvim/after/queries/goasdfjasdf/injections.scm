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


; --- when declaring a variable
; var activity_log_table_schema = /*sql*/ `
; CREATE TABLE IF not exists activity_log (
;   id   BLOB  PRIMARY KEY,
;   peer text NOT NULL,
;   timestamp INTEGER NOT NULL,
; 	sql_query text NOT NULL
; );
; `
; ---
(var_declaration
  (var_spec
    name: (identifier)
    (comment) @comment
    value: (
      expression_list
      (raw_string_literal
        (raw_string_literal_content) @injection.content
      )
    ) 
  )

  (#eq? @comment "/*sql*/")
  (#set! injection.include-children)
  (#offset! @injection.content 0 0 0 0)
  (#set! injection.language "sql")
)

; --- in situations like
; Function(/*sql*/ `
; SELECT timestamp from activity_log
; ORDER BY timestamp DESC 
; LIMIT 1;
; `)
; ---
(
  (call_expression
    function: (identifier)
    arguments: (
      argument_list
      (comment) @comment
      (raw_string_literal
        (raw_string_literal_content) @injection.content
      )
    )
  )
  (#eq? @comment "/*sql*/")
  (#set! injection.include-children)
  (#offset! @injection.content 0 0 0 0)
  (#set! injection.language "sql")
)
