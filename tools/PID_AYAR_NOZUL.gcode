; ============================================================
;  Ender 3 V2 - Nozül PID otomatik ayarı
;  Kartın köküne kopyala, yazıcıda "Print" ile seç.
;  ~5-8 dakika sürer: nozül 8 kez ısınıp soğur, ekranda baskı
;  ilerlemiyor gibi görünür, bu normaldir. Başında bekle.
; ============================================================
M106 S255          ; parça soğutma fanını tam güçte aç (baskıdaki gerçek koşul)
M303 E0 S200 C8 U1 ; nozülü 200°C'de 8 tur test et ve sonucu uygula
M500               ; ayarı kalıcı belleğe kaydet
M107               ; fanı kapat
M104 S0            ; nozül ısıtıcısını kapat
M117 PID ayari tamam
