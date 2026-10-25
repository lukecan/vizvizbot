// ============================================================
//  VızVızBot  -  Kabuk v1  (şasi plakasıyla aynı taban ölçüsü: 120 x 100)
//
//  "parca" satırını değiştir, F6 -> F7 ile STL al:
//    "montaj"   : sadece önizleme (kabuk + tuş kapakları + kanatlar)
//    "kabuk"    : arı gövdesi (dik basılır, içine TABLADAN DESTEK gerekir)
//    "kapaklar" : 6 tuş kapağı (flanş tablada, desteksiz)
//    "kanatlar" : 2 kanat (düz, desteksiz)
//
//  Yön: +X robotun önü (gözler), +Y robotun solu.
// ============================================================

parca = "montaj";

$fn = 64;
tol = 0.3;                 // tolerans testinden gelen değer

// ---------- GÖVDE ----------
taban_x   = 120;           // şasi plakasıyla aynı
taban_y   = 100;
kose_r    = 8;
duvar     = 2.4;
dik_yuk   = 18;            // kenarlardaki dik duvar yüksekliği
kubbe_yuk = 30;            // kubbenin dik duvar üstündeki yarı yüksekliği
ust_z     = 43;            // düz tepe yüksekliği (plaka üstünden)

// ---------- ŞASİYE BAĞLANTI ----------
kose_delik_x = 52;         // şasideki köşe delikleriyle aynı
kose_delik_y = 42;
insert_delik = 3.7;        // M3 ısıl insert deliği (insert dış çapı 4.0 mm)
insert_derin = 6;

// ---------- TUŞLAR ----------
buton_boy   = 12;          // 6x6 tach butonun toplam yüksekliği
aralik      = 14;          // tuşlar arası mesafe
kapak       = 10;          // kare tuş kapağı
flans       = 13;          // kapağın içerideki tutucu kenarı
flans_kalin = 1.5;
cikinti     = 3;           // kapağın kabuktan dışarı çıkan kısmı

// [x, y, sembol açısı, sembol]
butonlar = [
  [ aralik,       0,   0, "ok"  ],   // ileri
  [-aralik,       0, 180, "ok"  ],   // geri
  [      0,  aralik,  90, "ok"  ],   // sola
  [      0, -aralik, -90, "ok"  ],   // sağa
  [      0,       0,   0, "go"  ],   // GO
  [-aralik, -aralik,   0, "sil" ]    // sil
];

// buton kartını tutan direkler (kart ~60x60 mm, delikler bu noktalarda)
kart_direkleri = [[26, 0], [-26, 0], [0, 26], [0, -26]];

// ---------- HESAPLANAN (dokunma) ----------
ic_tavan = ust_z - duvar;              // iç tavan
buton_uc = ic_tavan - flans_kalin;     // butonun basma ucu buraya gelir
kart_ust = buton_uc - buton_boy;       // buton kartının üst yüzü

echo(str("Buton karti ust yuzu (plakadan): ", kart_ust, " mm"));
echo(str("Kart direkleri arasi: ", 52, " mm (kartta delik merkezleri)"));

// ============================================================
//  YARDIMCILAR
// ============================================================
module yuv2d(x, y, r) {
  offset(r = r) square([x - 2 * r, y - 2 * r], center = true);
}

// o: içeri doğru ofset (0 = dış yüzey)
module govde(o) {
  z0 = (o == 0) ? 0 : -1;
  intersection() {
    hull() {
      translate([0, 0, z0])
        linear_extrude(dik_yuk - z0)
          yuv2d(taban_x - 2 * o, taban_y - 2 * o, max(kose_r - o, 0.5));
      translate([0, 0, dik_yuk])
        scale([taban_x / 2 - o, taban_y / 2 - o, kubbe_yuk - o])
          sphere(r = 1, $fn = 96);
    }
    translate([-100, -100, z0]) cube([200, 200, ust_z - o - z0]);
  }
}

module sembol(tip) {
  if (tip == "ok")
    polygon([[4, 0], [0, 3.6], [0, 1.3], [-4, 1.3], [-4, -1.3], [0, -1.3], [0, -3.6]]);
  else if (tip == "go")
    difference() { circle(r = 3.6); circle(r = 2.1); }
  else if (tip == "sil")
    rotate(45) { square([9, 2.4], center = true); square([2.4, 9], center = true); }
}

// ============================================================
//  KABUK
// ============================================================
module gozler() {
  for (sy = [-1, 1]) translate([52, sy * 16, 26]) sphere(r = 8);
}

module antenler() {
  for (sy = [-1, 1]) translate([28, sy * 10, ust_z - 1]) {
    cylinder(d1 = 10, d2 = 6, h = 4);
    cylinder(d = 6, h = 14);
    translate([0, 0, 15]) sphere(d = 11);
  }
}

module kabuk() {
  difference() {
    union() {
      // kabuk duvarı
      difference() { govde(0); govde(duvar); }
      // köşe direkleri (şasiye vidalanır)
      intersection() {
        for (sx = [-1, 1], sy = [-1, 1])
          translate([sx * kose_delik_x, sy * kose_delik_y, 0]) cylinder(d = 12, h = 14);
        govde(0);
      }
      // buton kartı direkleri
      intersection() {
        for (p = kart_direkleri) translate([p[0], p[1], kart_ust]) cylinder(d = 8, h = 30);
        govde(0);
      }
      gozler();
      antenler();
    }

    // köşe direği insert delikleri (alttan)
    for (sx = [-1, 1], sy = [-1, 1])
      translate([sx * kose_delik_x, sy * kose_delik_y, -1])
        cylinder(d = insert_delik, h = insert_derin + 1);

    // buton kartı direği insert delikleri (alttan)
    for (p = kart_direkleri)
      translate([p[0], p[1], kart_ust - 1])
        cylinder(d = insert_delik, h = insert_derin + 1);

    // tuş delikleri (kare: kapak dönmesin)
    for (b = butonlar)
      translate([b[0], b[1], ust_z])
        cube([kapak + 2 * tol, kapak + 2 * tol, 10], center = true);

    // göz LED delikleri (LED içeriden takılır, 1.2 mm ince "deri" kalır)
    for (sy = [-1, 1])
      translate([36, sy * 16, 26]) rotate([0, 90, 0])
        cylinder(d = 6, h = 52 + 8 - 1.2 - 36);

    // kanat pim delikleri
    for (sy = [-1, 1]) translate([-8, sy * 32, 30]) cylinder(d = 3.4, h = 20);

    // açma/kapama anahtarı penceresi (sağ yan duvar, arkada)
    translate([-40, -taban_y / 2, 8]) cube([6, 8, 3.2], center = true);

    // boyama için çizgi olukları (arka tarafta)
    for (x0 = [-30, -44])
      intersection() {
        difference() { govde(0); govde(0.8); }
        translate([x0 - 3, -60, 3]) cube([6, 120, 60]);
      }
  }
}

// ============================================================
//  TUŞ KAPAKLARI
// ============================================================
// Baskı yönü: flanş tablada. Takılı halde flanş kabuğun içinde kalır,
// kapak dışarı düşemez (çocuk için güvenli).
module kapak_parca(aci, tip) {
  boy = flans_kalin + duvar + cikinti + 0.6;
  difference() {
    union() {
      translate([-flans / 2, -flans / 2, 0]) cube([flans, flans, flans_kalin]);
      translate([-kapak / 2, -kapak / 2, 0]) cube([kapak, kapak, boy]);
    }
    translate([0, 0, -0.01]) cylinder(d = 4, h = 0.8);          // buton sapı yuvası
    translate([0, 0, boy - 0.8]) linear_extrude(1) rotate(aci) sembol(tip);
  }
}

module kapaklar_baski() {
  for (i = [0 : len(butonlar) - 1])
    translate([(i % 3) * 18, floor(i / 3) * 18, 0])
      kapak_parca(butonlar[i][2], butonlar[i][3]);
}

// ============================================================
//  KANATLAR
// ============================================================
module kanat() {
  linear_extrude(2) hull() {
    circle(r = 4);
    translate([-14, 24]) circle(r = 11);
  }
  cylinder(d = 3, h = 2 + 5);   // pim
}

module kanatlar_baski() {
  kanat();
  translate([45, 0, 0]) mirror([1, 0, 0]) kanat();
}

// ============================================================
//  ÖNİZLEME
// ============================================================
module montaj() {
  %translate([0, 0, -3]) linear_extrude(3) yuv2d(taban_x, taban_y, kose_r);  // şasi plakası
  color("gold") kabuk();
  for (b = butonlar)
    color(b[3] == "go" ? "limegreen" : (b[3] == "sil" ? "tomato" : "deepskyblue"))
      translate([b[0], b[1], buton_uc]) kapak_parca(b[2], b[3]);
  for (sy = [-1, 1])
    color("white", 0.8) translate([-8, sy * 32, 43.5]) scale([1, sy, 1]) mirror([0, 0, 1]) kanat();
}

// ============================================================
if      (parca == "kabuk")    kabuk();
else if (parca == "kapaklar") kapaklar_baski();
else if (parca == "kanatlar") kanatlar_baski();
else                          montaj();
