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


; Uhrzeit besteht aus/hat folgende Eigenschaften:
; - Stunde
; - Minute
; zusammengesetzte Daten
(define hour
  (signature
   (combined natural
             (predicate
              (lambda (n)
                (and (>= n 0)
                     (< n 24)))))))
   

(define-record time
  make-time ; Konstruktor
  (time-hour hour) ; Selektor
  (time-minute natural))

(: make-time (hour natural -> time))
(: time-hour (time -> hour))
(: time-minute (time -> natural))
   
(define time1 (make-time 12 24)) ; 12:24 Uhr

; Minuten seit Mitternacht
(: msm (time -> natural))

(check-expect (msm (make-time 0 0)) 0)
(check-expect (msm time1) (+ (* 12 60) 24))

(define msm
  (lambda (time)
    (+ (* (time-hour time) 60)
       (time-minute time))))

; Uhrzeit berechnen aus Minuten seit Mitternacht
(: msm->time (natural -> time))

(check-expect (msm->time 0) (make-time 0 0))
(check-expect (msm->time (+ (* 12 60) 24))
              time1)

(define msm->time
  (lambda (msm)
    (make-time (quotient msm 60)
               (remainder msm 60))))

; Brüche:
; 1. Datendefinition + zugehöriger Code
; 2. Funktion, um 2 Brüche zu addieren
; 3. Funktion, um Bruch zu kürzen

; Ein Bruch besteht aus:
; - Zähler
; - Nenner
(define-record bruch
  mach-bruch
  (zähler integer)
  (nenner natural))

(: mach-bruch (integer natural -> bruch))
(: zähler (bruch -> integer))
(: nenner (bruch -> natural))

(define bruch1 (mach-bruch 3 4)) ; drei viertel
(define bruch2 (mach-bruch 2 3)) ; zwei drittel

; 2 Brüche addieren
(: bruch-plus (bruch bruch -> bruch))

(check-expect (bruch-plus bruch1 bruch2)
              (mach-bruch 17 12))

(define bruch-plus
  (lambda (bruch1 bruch2)
    (mach-bruch
     (+ (* (zähler bruch1) (nenner bruch2))
        (* (zähler bruch2) (nenner bruch1)))
     (* (nenner bruch1)
        (nenner bruch2)))))
    
; Bruch kürzen
(: kürzen (bruch -> bruch))

(check-expect (kürzen (mach-bruch 21 14))
              (mach-bruch 3 2))

(define kürzen
  (lambda (bruch)
    (define teiler (gcd (zähler bruch) (nenner bruch)))
    (mach-bruch (/ (zähler bruch) teiler)
                (/ (nenner bruch) teiler))))
