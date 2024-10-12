; extends
;
; (
;   (comment) @injection.content
;   (#set! injection.language "markdown")
; )

(
  (block_mapping_pair
    ; key: (flow_node) @_expr (#eq? @_expr "query")
    value: (block_node
              (block_scalar
                (comment) @comment
              ) @injection.content 
              (#eq? @comment "#graphql")
              (#set! injection.include-children)
              (#offset! @injection.content 0 0 0 0)
              (#set! injection.language "graphql")
          )
  )
)

(
  (block_mapping_pair
    ; key: (flow_node) @_expr (#eq? @_expr "query")
    value: (block_node
              (block_scalar
                (comment) @comment
              ) @injection.content 

              (#eq? @comment "#javascript")
              (#set! injection.include-children)
              (#offset! @injection.content 0 0 0 0)
              (#set! injection.language "javascript")
          )
  )
)
