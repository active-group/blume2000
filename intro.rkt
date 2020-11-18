;; Die ersten drei Zeilen dieser Datei wurden von DrRacket eingefügt. Sie enthalten Metadaten
;; über die Sprachebene dieser Datei in einer Form, die DrRacket verarbeiten kann.
#reader(lib "beginner-reader.rkt" "deinprogramm" "sdp")((modname intro) (read-case-sensitive #f) (teachpacks ((lib "image.rkt" "teachpack" "deinprogramm" "sdp"))) (deinprogramm-settings #(#f write repeating-decimal #f #t none explicit #f ((lib "image.rkt" "teachpack" "deinprogramm" "sdp")))))
; Schulung Blume 2000
(define s1 (star 50 "solid" "green"))
(define c1 (circle 50 "outline" "gold"))
(define sq1 (square 100 "solid" "blue"))

(define o1 (overlay s1 c1)) ; Kombinator
(define b1 (beside s1 c1))
(define a1 (above s1 c1))

;(overlay (beside s1 c1) (above s1 c1))
;(overlay (beside c1 sq1) (above c1 sq1))

; Kurzbeschreibung
; Muster aus zwei Bildern zusammensetzen
; Signatur-Deklaration
(: pattern (image image -> image))

; Beispiele/Tests
(check-expect (pattern c1 s1)
              (overlay
               (beside c1 s1)
               (above c1 s1)))

; Definition
(define pattern
  (lambda (image1 image2)
    (define b (beside image1 image2))
    (overlay b
             (above image1 image2))))
 
;(pattern c1 sq1)

; Datenanalyse
; Datendefinition
; Ein Haustier ist eins der folgenden:
; - Hund
; - Katze
; - Schlange
; Fallunterscheidung
; speziell: Aufzählung
(define pet
  (signature
   (enum "dog" "cat" "snake")))

; Ist Haustier niedlich?
(: cute? (pet -> boolean))

(check-expect (cute? "dog") #f)
(check-expect (cute? "cat") #t)
(check-expect (cute? "snake") #f)

; Gerüst
#;(define cute?
  (lambda (pet)
    ...))

; Schablone
#;(define cute?
  (lambda (pet)
    (cond ; Verzweigung / Conditional
      ; jeder Zweig: (Bedingung Antwort)
      ; ein Zweig pro Fall
      ((string=? pet "dog") ...)
      ((string=? pet "cat") ...)
      ((string=? pet "snake") ...)
      )))

(define cute?
  (lambda (pet)
    (cond ; Verzweigung / Conditional
      ; jeder Zweig: (Bedingung Antwort)
      ; ein Zweig pro Fall
      ((string=? pet "dog") #f)
      ((string=? pet "cat") #t)
      ((string=? pet "snake") #f))))

; (cute? "parrot")

