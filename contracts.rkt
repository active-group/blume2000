;; Die ersten drei Zeilen dieser Datei wurden von DrRacket eingefügt. Sie enthalten Metadaten
;; über die Sprachebene dieser Datei in einer Form, die DrRacket verarbeiten kann.
#reader(lib "vanilla-reader.rkt" "deinprogramm" "sdp")((modname contracts) (read-case-sensitive #f) (teachpacks ()) (deinprogramm-settings #(#f write repeating-decimal #f #t none explicit #f ())))
; Financial contracts / Finanzderivate

; Voraussetzung:
; Menge/Typ/Signatur T
; Operation
; (: op (T T -> T))
; Beispiele: Zahlen, +
; Zahlen, *
; Bilder, overlay

; Assoziativität
; a + (b + c) = (a + b) + c
; a * (b * c) = (a * b) * c
; (overlay a (overlay b c)) = (overlay (overlay a b) c)

; Halbgruppe: Menge, binäre Operation, Assoziativität

; Halbgruppe + neutrales Element: Monoid

