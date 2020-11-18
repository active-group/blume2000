;; Die ersten drei Zeilen dieser Datei wurden von DrRacket eingefügt. Sie enthalten Metadaten
;; über die Sprachebene dieser Datei in einer Form, die DrRacket verarbeiten kann.
#reader(lib "beginner-reader.rkt" "deinprogramm" "sdp")((modname animals) (read-case-sensitive #f) (teachpacks ()) (deinprogramm-settings #(#f write repeating-decimal #f #t none explicit #f ())))
; Lebendigkeit ist eins der folgenden:
; - tot
; - lebendig
(define liveness
  (signature (enum "dead" "alive")))

(define kg
  (signature
   natural))

; Ein Gürteltier hat folgende Eigenschaften:
; - tot oder lebendig
; - Gewicht
; zusammengesetzte Daten
(define-record armadillo
  make-armadillo
  (armadillo-liveness liveness)
  (armadillo-weight kg))
