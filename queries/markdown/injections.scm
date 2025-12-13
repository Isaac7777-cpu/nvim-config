; extends

;; Basic: fenced code blocks like ```python
(fenced_code_block
  (info_string
    (language) @injection.language)
  (code_fence_content) @injection.content)
