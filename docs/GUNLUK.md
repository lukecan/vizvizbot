# Geliştirme Günlüğü

Neyi neden değiştirdik, nerede takıldık. Sürümler eskiden yeniye sıralı. Eski kaynak dosyalar `cad/arsiv/` klasöründe.

---

## 0. Başlangıç: tolerans testi

Teker motor miline (28BYJ-48, 5 mm, iki yanı düz "D" mil) oturmalı. Doğru boşluğu tahmin etmek yerine **4 farklı toleransla küçük göbekler** bastık: 0.1 / 0.2 / 0.3 / 0.4 mm (`cad/tolerans_testi.scad`).

**Sonuç:** 0.3 mm. Projenin geri kalanında bütün geçmeli parçalar bu değerle çizildi.

---

## Şasi v1 → v2: Motor fişi delikten geçmedi

v1'de motor kablolarının plakadan geçmesi için yuvarlak delikler vardı. Kablonun ucundaki beyaz 5 pinli fiş (**14.8 × 5.5 mm**) bu deliklerden geçmedi.

İlk ölçümde bir karışıklık oldu: ölçülen değer sürücü kartındaki **yuvanın** değil, motordan çıkan **fişin** ölçüsüydü. Sonuç aynı kaldı: fişin geçmesi gerekiyor.

**v2:** Oval kablo yuvaları (17.8 × 8.5 mm, fişin her yanında 3 mm pay). Isıl insert delikleri, ölçülen 4.0 mm dış çapa göre 3.7 mm yapıldı.

---

## Şasi v3: Sarhoş teker kendi cıvatalarıyla

Sarhoş tekerin (ball caster) montaj delikleri 2 mm çıktı. Yanında kendi cıvataları (27 mm) ve somunları geldi, ayrıca insert gerekmiyordu.

- İlk önerim **plakaya somun cebi açmak ve cıvataları kısaltmaktı**. Reddedildi, isabetli bir şekilde: "Tam oturmazsa diye delikler daire boyunca biraz uzasın."
- **v3:** Delikler boydan boya açıldı ve sarhoş tekerin merkezi etrafında **±10° yay şeklinde** uzatıldı. Teker hafifçe döndürülerek hizalanabiliyor.

---

## Yazıcı sorunu, 1. bölüm: "Extruder temperature too low"

v2 şasi sorunsuz basıldı. v3 baskısı ortasında **nozül sıcaklığı düştü** hatasıyla durdu. Denediklerimiz:

| Deneme | Sonuç |
|---|---|
| Termistör kablosunu yazıcı ısınmışken oynatmak | Değişiklik yok |
| Parça fanını %100'de çalıştırmak | Sıcaklık sabit |
| PID otomatik ayarı (`tools/PID_AYAR_NOZUL.gcode`) | Yapıldı |
| v2 ve v3 G-code'larını karşılaştırmak | Sıcaklık ve fan komutları **aynı** |
| PID'den sonra yanlışlıkla v2'yi tekrar basmak | **Sorunsuz bitti** |
| v3'ü tekrar basmak | **Yine durdu** |

Bu tablo "dosyada bir sorun var" diye bağırıyor gibiydi. Değilmiş, aşağıya bakın.

---

## Şasi v4: "Olası bütün hataların önüne geç"

- Alt yüzdeki yazı **ARI BOT → VızVızBot** oldu.
- Tablaya değen kenara **0.6 mm pah** eklendi. Fil ayağı denen ilk katman taşmasına karşı.
- Yatay vida delikleri **damla şeklinde** yapıldı, böylece destek olmadan temiz basılıyor.
- Destek üçgenleri 3 mm'den 4 mm'ye kalınlaştı.

Bu sürümde STL'i **Claude bilgisayardaki Cura'yı kendisi kullanarak** dilimledi: 3 duvar, brim, fan %80. Ardından CR Touch'ın her baskıda tablayı ölçmesi için başlangıç G-code'una `G29` eklendi.

---

## Yazıcı sorunu, 2. bölüm: Veriye bakmak

v4 de **1.1 mm yükseklikte** durdu. G-code satır satır analiz edildi:

| Yükseklik | Ne basılıyor | Akış |
|---|---|---|
| 0–1.0 mm | Taban katmanları, 20–25 mm/s | ~2 mm³/s |
| 1.0 mm+ | Dolgu, 50 mm/s | ~4 mm³/s |

İlk teori **ısıtıcının zayıflaması** oldu: yavaş basarken yetişiyor, hız ikiye katlanınca yetişemiyor. Test: 200 → 240 °C ne kadar sürüyor? **30 saniyenin altında.** Isıtıcı sağlam, teori çürük.

Sonraki teori **kablonun hareket sırasında temas kaybetmesi** oldu. Sıcaklık 205 °C'ye çıkarılınca baskı devam etti, ama değer ara ara 198'e düşüyordu.

---

## Montaj başladı: Motorlar ve teker

v4 şasi çıktı ve sarhoş teker takıldı. Motor montajı için kritik nokta: 28BYJ-48'in mili gövdenin ortasında değil, **8 mm yukarıda**. Motor ters takılırsa kulak delikleri yine oturuyor ama teker 16 mm aşağıda kalıyor.

**Sorun:** Teker milde **kendiliğinden takılıp çıkıyordu**. 0.3 mm tolerans ilk takışta yeterliydi, birkaç kez takıp çıkarınca aşındı.

---

## Teker v2: Vidalı göbek

- Mil deliği 0.15 mm'ye daraltıldı.
- Göbeğin yanından M3 vida giriyor ve ucu milin **düz yüzüne** basıyor. Somun göbeğin içindeki üstten açık yuvada duruyor.
- **Tasarım sırasında yakalanan hata:** Vida göbeğin yanında ama tekerin jantı etrafını tamamen kapatıyor, yani **tornavida vidaya ulaşamıyor.** Janta 4.5 mm'lik bir erişim deliği açıldı, O-ring takılınca görünmüyor.

---

## Yazıcı sorunu, 3. bölüm: Sensör yalan söylüyor 🎯

Teker v2 baskısının son katmanlarında ekranda sıcaklık **bir saniyeliğine 180 °C** gösterdi, sonra geri döndü. Baskı 7.4 / 8 mm'de durdu.

**Teşhis:** Nozülün metal bloğu 1 saniyede 20 °C kaybedip geri kazanamaz. Gerçek sıcaklık düşmüyor, **ölçüm** bozuluyor. Suçlu, nozülün **termistör kablosu**: kafa hareket ettikçe kablo esniyor ve bir an temas kaybediyor. Duruşun anında kafa tablanın **sol tarafındaydı**.

Bu teşhis önceki bütün belirtileri açıklıyor: rastgele durmalar, v2'nin şans eseri bitmesi, kafa dururken kablo oynatılınca bir şey olmaması, ısıtıcının sağlam çıkması.

**Çözüm:** Anakarttaki termistör fişini kontrol etmek, gerekirse **nozül termistörünü** değiştirmek. Dikkat, tabla termistörüyle karıştırılmamalı: tablanınki 70 cm, nozülünki ~1.15 m.

---

## Teker v2'nin mil deliği girmedi, braket kırıldı

- 0.15 mm tolerans **fazla dar** çıktı, teker mile girmedi.
- Tekeri zorlarken **motor braketi kırıldı**.

**Neden kırıldı?** Şasi tek parça basılıyordu: plaka tablada, braketler dik. Braketin katmanları yatay duruyordu ve tekeri bastırırken oluşan kuvvet bu katmanları **birbirinden ayırmaya** çalıştı. 3D baskının en zayıf yönü tam olarak bu.

---

## Şasi v5 + Teker v3: "Çocuk oynayacak, olabildiğince güçlü olsun"

**Şasi v5**
- Braketler **ayrı parça** ve **yan yatırılarak** basılıyor. Katmanlar artık yükü taşıyacak yönde diziliyor.
- Duvar 3 → 5 mm. Motor deliğinin altı **kapalı halka**. Braket boyunca **tam destek üçgeni**.
- Braket plakaya 2 × M3 vida + ısıl insert ile bağlanıyor. Bir braket kırılırsa sadece onu (~40 dk) yeniden basmak yetiyor.
- **Sarhoş teker cıvataları dik geçmiyordu.** Cıvata 11 mm'lik dar bir kanaldan geçiyor ve küçük delikler baskıda daralıyor. Delikler 2.4 → 3.0 mm genişletildi ve merkeze doğru da ±0.6 mm uzatıldı.

**Teker v3**
- Dolu disk yerine **5 kol**. %35 daha az malzeme, daha kısa baskı.
- Mil deliği tekrar 0.3 mm. Tekerin sıkı durmasını artık vida sağlıyor, delik sadece rahat girmeli.
- Kollar vida yönüne denk gelmiyor, böylece tornavida rahatça vidaya ulaşıyor.

---

## Baskıdan önce son kontrol

- **Çakışma kontrolü:** Braketler ve plaka bilgisayarda bir araya getirilip çakışma testi yapıldı. Braket flanşının **ULN2003 kartının alttan gelen vida başlarına** çarptığı fark edildi. Flanşın ortası, kenarları 45° olacak şekilde açıldı. Bu açı sayesinde yan yatık baskıda destek gerekmiyor. Yeniden yapılan testte motor gövdesi, sarhoş teker yükselticisi ve vida başlarıyla hiçbir çakışma kalmadı.
- **Destek tartışması:** Cura braketlerde kırmızı alanlar gösterince destek eklemek cazip geldi. Kırmızı alanlar damla şeklindeki deliklerin tepeleri ve ~11 mm'lik köprülerdi, yani destek gerekmiyordu. "Everywhere" desteği delikleri dolduracağı için kaldırıldı.
- **Termistör:** Anakarttaki TH0 fişi çıkarılıp kontrol edildi: yanık, eğik uç ya da gevşeklik yok. Geriye kablonun içinde, hareketle açılıp kapanan bir kopukluk ihtimali kalıyor. Baskı boyunca sıcaklık izlenecek.
- **Tek tabla:** Plaka + 2 braket + 2 teker birlikte dilimlendi (4 duvar, %40 dolgu, brim 5 mm, G29). Sonuç ~9 saat, 69 g. G-code satır satır kontrol edildi: sıcaklıklar, G29, destek yok, fan %80, parçalar tablanın sınırları içinde.

---

## Tek tabla baskısı ve braket v7

**Sonuç:** Plaka, 2 braket ve 2 teker, 9 saatlik tek baskıda **hatasız** çıktı. Katmanlar düzgün.

**v5 braketin sorunu:** Motoru takmaya gelince ortaya çıktı. Braketi güçlendirmek için duvarın iç yüzüne boydan boya bir destek üçgeni eklemiştim. Motor kulak vidalarının **somunları** tam bu üçgene çarpıyordu, yaklaşık 1–1.5 mm. Bilgisayardaki çakışma kontrolünde vida başlarını, motoru ve plakayı test etmiştim, ama kulak somunlarını unutmuşum.

**v6 (kullanılmadı):** İlk refleks, somunların arkasına cep açmak oldu. Mert'in cevabı net: "Bu da olmamış. İlk braketlerin U yapısı gayet iyiydi, tam daire kapatmana gerek yok, boyutu da kusursuzdu. Sadece onu güçlendir."

**v7:** v4'ün geometrisine geri dönüldü:
- **Aynı kalanlar:** U şekli (motor deliğinin altı açık), 50 mm genişlik, aynı alt kenar, dış yüz aynı yerde.
- **Güçlendirmeler:** yan yatık baskı, duvar 3 → 4 mm (içeri doğru), plakaya oturan 6 mm flanş + 2 insert, iç köşede boydan boya 5 mm pah. Pah somunların **üstünde** bitiyor.
- **Çakışma kontrolü** bu sefer somun + pul (Ø7.2 × 3 mm) dahil yapıldı: temiz.
- **Baskı:** 4 duvar, %40 **Gyroid** dolgu (darbeye dayanıklı), brim, destek yok. 1 sa 43 dk.

**Ders:** Çalışan bir şeyi "güçlendirirken" onu baştan tasarlamak yerine **iyi olan kısmını koruyup** üstüne eklemek. Ve çakışma kontrolüne montajdaki **her** parçayı katmak, somunları da.

---

## Braket maratonu: v8 → v11

Braket bu projede en çok tekrarlanan parça oldu. Her sürüm bir şey öğretti.

| Sürüm | Ne denendi | Sonuç |
|---|---|---|
| v7 | v4'ün U şekli, yan yatık baskı, flanş + insert | ✅ Basıldı, takıldı, çalıştı. Ama motorun **üstündeki bant 0.7 mm**, delik damla şeklinde |
| v8 | Plaka + braket tekrar **tek parça** (deliğin üstünü plaka kapatsın) | ❌ Bastığım plaka kullanılamazdı |
| v9 | Ayrı parça, ilk tasarımdaki gibi **dik baskı** → delik tam yuvarlak | Görünüş doğru, motorun üstü hâlâ ince |
| v10 | Motor braketin içinde **4 mm aşağı**, bant 0.7 → 4.7 mm, sarhoş tekere 4 mm pul | Mantık doğru, ama mavi kapak hâlâ altta |
| **v11** | Motor **ters**: mavi kapak yukarıda, mil aşağıda | ✅ **Son hali** |

### Sorunlar ve dersler

**"Halka" meselesi.** İlk tasarımda motor deliğinin üstünü **plaka** kapatıyordu (plaka ile braket tek parçaydı). Braketi ayırınca deliğin tepesinde sadece 0.7 mm kaldı ve halka gözle görülür şekilde bozuldu. Çözüm, motoru plakadan uzaklaştırıp araya gerçek malzeme koymak oldu.

**Mavi kapak yerden 4 mm'deydi.** 28BYJ-48'in mili gövdenin ortasında değil, 8 mm kaçık. Kablo kapağı da milin tam karşısında. Mil yukarıdayken kapak yere neredeyse değiyordu. Motoru ters çevirmek yerden yüksekliği **4 mm'den 24 mm'ye** çıkardı. Bedeli: şasi 24 mm yükseldi, sarhoş tekere 24 mm'lik bir yükseltici gerekti.

**Ölçüm tahminden iyidir.** Mavi kapak için önce tahmini değer girdim (merkezden 18.5 mm). Mertcan kumpasla ölçünce **16.5 mm** çıktı: tepesi 14.7 mm, gövdeyi saran tabanı 18.3 mm genişliğinde. Yuva buna göre küçüldü ve şasi 2 mm daha alçak kaldı.

**Gereksiz güçlendirme de bir kusurdur.** v11'in ilk halinde motorun altı da kapalı halkaydı. Mertcan sordu: "Gerek var mıydı?" Yoktu. Motor ters olunca yükü motorun **üstündeki** bant taşıyor. Alt kısım ilk tasarımdaki gibi açık U oldu ve braketin yerden yüksekliği 18 mm'den 31 mm'ye çıktı.

**İyi olanı koru.** v5 ve v7'de braketi baştan tasarladım ve her seferinde bir şey bozuldu: önce somunlar çarptı, sonra halka gitti. Doğru yaklaşım, ilk tasarımın ölçülerini ve şeklini koruyup sadece **güçlendirmekti**.

### v11'in son hali
- Ayrı parça, v5 plakaya 2 vida + 2 ısıl insert ile bağlanıyor
- Tam yuvarlak motor deliği + tepesinde mavi kapak yuvası
- Kapağın üstünde 6 mm'lik bant, flanş motorun üstünden kesintisiz geçiyor
- 5 mm duvar, 6 mm kalın 14×20 mm uç üçgenleri, 4 mm iç pah
- Alt kısım açık U (motor merkezinin 7 mm altında bitiyor)
- Robotun yerden yüksekliği: **24 mm** (en alçak nokta motor gövdesi)
- Çakışma kontrolü: kulak somunları + pullar, mavi kapak (takarken ve takılıyken), ULN2003 vidaları, sarhoş teker, plaka → hepsi temiz

---

## Sıradaki adımlar

- [x] Nozül termistörü: anakarttaki fiş kontrol edildi (sağlam)
- [ ] Nozül termistörü: baskı sırasında sıcaklık zıplarsa termistörü değiştir
- [x] Plaka v5 + 2 braket + 2 teker v3'ü tek tablada dilimle
- [x] Tek tabla baskısı (~9 saat): hatasız bitti
- [x] Braket v7 baskısı ve deneme montajı
- [ ] Braket v11 + sarhoş teker yükselticisi baskısı
- [ ] 3 × M2 × 40 cıvata
- [ ] Isıl insert'ler → motorlar braketlere → braketler plakaya → tekerler
- [ ] Motorlar + ULN2003 + güç devresi
- [ ] `ilk_surus_testi` ile kalibrasyon (15 cm kare, 90° dönüş)
- [ ] Buton kartı + buzzer
- [ ] Kabuk, tuş kapakları, kanatlar
- [ ] Teslimat 🐝
