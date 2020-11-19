;; Die ersten drei Zeilen dieser Datei wurden von DrRacket eingefügt. Sie enthalten Metadaten
;; über die Sprachebene dieser Datei in einer Form, die DrRacket verarbeiten kann.
#reader(lib "vanilla-reader.rkt" "deinprogramm" "sdp")((modname rev) (read-case-sensitive #f) (teachpacks ()) (deinprogramm-settings #(#f write repeating-decimal #f #t none explicit #f ())))
; Liste umdrehen
(: rev ((list-of %a) -> (list-of %a)))

(check-expect (rev (list 1 2 3))
              (list 3 2 1))

(define rev
  (lambda (list)
    (cond
      ((empty? list) empty)
      ((cons? list)
       ; konkretes Beispiel: list = (list 1 2 3)
       ; (first list) = 1
       ; (rest list) = (list 2 3)
       ; (rev (rest list)) = (list 3 2)
       (rev (rest list))
       (first list)))))

; Zwei Listen aneinanderhängen
(: list-append ((list-of %a) (list-of %a) -> (list-of %a)))

(check-expect (list-append (list 1 2 3) (list 4 5 6))
              (list 1 2 3 4 5 6))




