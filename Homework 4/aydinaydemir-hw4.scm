(define main-procedure
(lambda (tripleList)
(if (or (null? tripleList) (not (list? tripleList)))
(error "ERROR305: the input should be a list full of triples")
(if (check-triple? tripleList)
(sort-area (filter-pythagorean (filter-triangle
(sort-all-triples tripleList))))
(error "ERROR305: the input should be a list full of triples")
)
)
)
)


(define check-sides?
  (lambda (inTriple)
    (if (not (list? inTriple))
        #f
        (let ((first (car inTriple))
              (second (cadr inTriple))
              (third (caddr inTriple)))
          (and (number? first)
               (number? second)
               (number? third)
               (> first 0)
               (> second 0)
               (> third 0))))))





(define check-length?
  (lambda (inTriple count)
    (and (list? inTriple) (eq? (length inTriple) count))
  )
)


(define check-triple?
  (lambda (tripleList)
    (if (null? tripleList)
        #t
        (and (check-length? (car tripleList) 3)
             (check-sides? (car tripleList))
             (check-triple? (cdr tripleList))))))



(define sort-triple
  (lambda (inTriple)
    (let ((first (car inTriple))
          (second (cadr inTriple))
          (third (caddr inTriple)))
    (cond   ((and (<= first second) (<= second third)) (list first second third))
            ((and (<= first third) (<= third second)) (list first third second))
            ((and (<= second first) (<= first third)) (list second first third))
            ((and (<= second third) (<= third first)) (list second third first))
            ((and (<= third first) (<= first second)) (list third first second))
            ((and (<= third second) (<= second first)) (list third second first)) 
    )
  ))
)

(define sort-all-triples
  (lambda (tripleList)
    (cond 
      ((null? tripleList) '()) ; this line is the test case for an empty list
      (else (cons (sort-triple (car tripleList)) (sort-all-triples (cdr tripleList))))
    )
  )
)


(define triangle?
  (lambda (triple)
    (let ((first (car triple))
          (second (cadr triple))
          (third (caddr triple)))
      (and (> (+ first second) third)
           (> (+ second third) first)
           (> (+ first third) second)))))




(define filter-triangle
  (lambda (tripleList)
    (cond
      ((null? tripleList) '()) 
      ((triangle? (car tripleList)) 
       (cons (car tripleList) (filter-triangle (cdr tripleList)))) 
      (else (filter-triangle (cdr tripleList))) 
    )
  )
)

(define pythagorean-triangle?
  (lambda (triple)
    (let ((first (car triple))
          (second (cadr triple))
          (third (caddr triple)))
      (eq? (+ (* first first) (* second second)) (* third third))
    )
  )
)


(define filter-pythagorean
(lambda (tripleList)
    (cond
      ((null? tripleList) '()) 
      ((pythagorean-triangle? (car tripleList)) 
       (cons (car tripleList) (filter-pythagorean (cdr tripleList)))) 
      (else (filter-pythagorean (cdr tripleList))) 
    )

)
)

(define get-area
  (lambda (triple)
    (let ((base (car triple))
          (height (cadr triple)))
      (* 0.5 (* base height)))))



(define insert-area
  (lambda (triple tripleList)
    (if (null? tripleList)
        (list triple)
        (if (< (get-area triple) (get-area (car tripleList)))
            (cons triple tripleList)
            (cons (car tripleList) (insert-area triple (cdr tripleList)))))))

(define sort-area
  (lambda (tripleList)
    (if (null? tripleList)
        '()
        (insert-area (car tripleList) (sort-area (cdr tripleList))))))