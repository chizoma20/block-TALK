;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Block Talk Smart Contract
;; ------------------------------------------------------------
;; Author: Your Name
;; Description:
;;   A simple on-chain message board where users can create,
;;   read, and delete posts. Each post is tied to the sender's
;;   principal and stored permanently (unless deleted by author).
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ------------------------------------------------------------
;; DATA DEFINITIONS
;; ------------------------------------------------------------

;; Track the total number of posts
(define-data-var post-count uint u0)

;; Store posts in a map:
;; key   -> { id: uint }
;; value -> { sender: principal, text: (string-utf8 200), block: uint }
(define-map posts
  { id: uint }
  {
    sender: principal,
    text: (string-utf8 200),
    block: uint
  }
)

;; ------------------------------------------------------------
;; PUBLIC FUNCTIONS
;; ------------------------------------------------------------

;; Create a new post
(define-public (create-post (text (string-utf8 200)))
  (begin
    ;; Ensure text is not empty
    (if (is-eq (len text) u0)
        (err u400) ;; bad request: empty text
        (let (
              (next-id (+ u1 (var-get post-count)))
              (sender tx-sender)
              (current-block stacks-block-height) ;; <CHANGE> Removed non-ASCII emoji from comment
             )
          ;; Store the post
          (map-set posts
            { id: next-id }
            {
              sender: sender,
              text: text,
              block: current-block
            })

          ;; Increment the post counter
          (var-set post-count next-id)

          ;; Return the new post ID
          (ok next-id)
        )
    )
  )
)

;; ------------------------------------------------------------
;; READ-ONLY FUNCTIONS
;; ------------------------------------------------------------

;; Retrieve a post by its ID
(define-read-only (get-post (id uint))
  (map-get? posts { id: id })
)

;; Get the total number of posts ever created
(define-read-only (get-total-posts)
  (ok (var-get post-count))
)

;; ------------------------------------------------------------
;; ADMIN / USER CONTROL
;; ------------------------------------------------------------

;; Delete a post (only allowed by its author)
(define-public (delete-post (id uint))
  (let ((post (map-get? posts { id: id })))
    (match post
      post-data
        (if (is-eq (get sender post-data) tx-sender)
            (begin
              (map-delete posts { id: id })
              (ok true)
            )
            (err u403)) ;; forbidden
      (err u404) ;; not found
    )
  )
)

;; ------------------------------------------------------------
;; UTILITY FUNCTIONS
;; ------------------------------------------------------------

;; Check whether a post exists
(define-read-only (exists? (id uint))
  (is-some (map-get? posts { id: id }))
)

;; ------------------------------------------------------------
;; END OF CONTRACT
;; ------------------------------------------------------------