// ============================================================
//  VızVızBot  -  Şasi v8 (tek parça, v4 braket ölçüleri, güçlendirilmiş)
//  v2: motor kablosu delikleri fiş geçecek şekilde oval yuva yapıldı
//  v3: sarhoş teker insert yerine kendi civatalarıyla boydan boya
//      delikli; delikler daire boyunca yay şeklinde uzatıldı (ayar payı)
//  v4: VızVızBot yazısı; tablaya değen kenarda pah (fil ayağına karşı);
//      yatay vida delikleri damla şeklinde (desteksiz temiz baskı);
//      destek üçgenleri kalınlaştırıldı
//  v8: v4'e dönüş: braketler plakayla TEK PARÇA (motor deliğinin üstü plakayla
//      kapalı kemer, altı açık U). Dış ölçüler v4 ile birebir aynı.
//      Güçlendirme (hepsi içeri doğru, dış ölçüyü değiştirmez):
//        - braket duvarı 3 -> 5 mm
//        - uç destek üçgenleri 4 mm -> 6 mm kalın, 10x12 -> 14x20 mm
//        - plaka-duvar birleşiminde boydan boya 4 mm pah
//      Sarhoş teker delikleri v5'teki gibi 3.0 mm + merkeze doğru ±0.6 mm.
//
//  Kullanım: Aşağıdaki "parca" satırını değiştir, F6 -> F7 ile STL al.
//    "montaj"      : sadece önizleme (motor ve tekerlerle birlikte görünüm)
//    "braket_test" : bir motor braketi + plaka şeridi (hızlı oturma testi)
//    "teker"       : 1 teker (2 adet basılacak)
//    "sasi"        : tüm şasi (baskı yönünde, ters çevrilmiş halde)
// ============================================================

parca = "montaj";

$fn = 80;
tol = 0.3;              // tolerans testinden gelen değer

// ---------- MOTOR (28BYJ-48) ----------
motor_cap    = 27.9;    // gövde çapı (mavi kapak hariç)
motor_boy    = 19;      // gövde derinliği
kulak_aralik = 35;      // kulak delik MERKEZLERİ arası ((31 + 39.1) / 2)
mil_ofset    = 8;       // milin gövde merkezine uzaklığı (standart 8 mm)
mil_cap      = 5;
mil_duz      = 3;       // milin iki düz yüzü arası
mil_boy      = 10;      // KULAK YÜZEYİNDEN mil ucuna kadar  -> ÖLÇ VE DÜZELT!
mil_cikinti  = 1.5;     // mil dibindeki yuvarlak çıkıntının yüksekliği

// ---------- TEKER ----------
teker_cap   = 58;       // plastik gövde çapı; O-ring ile ~60 mm olur
teker_en    = 8;
oring_kalin = 3;        // O-ring kesit kalınlığı
oring_derin = 2;        // oluk derinliği
disk_kalin  = 3;
gobek_cap   = 12;

// ---------- ŞASİ ----------
sasi_x       = 120;     // boy (ileri-geri)
sasi_y       = 100;     // en
sasi_z       = 3;       // plaka kalınlığı
kose_r       = 8;
braket_kalin = 5;       // v8: 3 -> 5 (dış yüz aynı yerde, kalınlık içeri)
braket_gen   = 50;
vida_delik   = 3.4;     // M3 geçiş deliği
pah          = 0.6;     // tablaya değen kenardaki pah (fil ayağı önlemi)
destek_kalin = 6;       // v8: uç destek üçgeni kalınlığı (v4: 4)
destek_y     = 14;      // v8: üçgenin içeri uzunluğu (v4: 10)
destek_z     = 20;      // v8: üçgenin aşağı uzunluğu (v4: 12)
kose_pah     = 4;       // v8: plaka-duvar iç köşe pahı

// ---------- SARHOŞ TEKER ----------
caster_yuk   = 28.7;    // montaj yüzeyinden bilyenin altına
caster_cap   = 27.5;
caster_ucgen = 15.7;    // delik merkezleri arası (eşkenar üçgen)
caster_x     = -45;     // robotun arkasında
caster_flans = 1.6;     // sarhoş tekerin montaj flanşı kalınlığı
caster_vida  = 2.0;     // sarhoş teker delik çapı (ölçülen)
caster_bosluk = 1.0;    // v8: delik 3.0 mm (v5'teki düzeltme)
caster_radyal = 0.6;    // v8: merkeze doğru ±0.6 mm ayar payı
civata_boy   = 27;      // sarhoş teker civatasının boyu (ölçülen)
somun_anahtar = 4.6;    // somunun karşılıklı düz kenarları arası (ölçülen)
somun_kalin  = 1.5;     // somun kalınlığı (ölçülen)
yay_aci      = 10;      // deliklerin daire boyunca sağa ve sola uzama açısı (derece)

// ---------- MOTOR FİŞİ ----------
fis_en      = 14.8;     // beyaz 5 pinli fişin geniş kenarı
fis_kalin   = 5.5;      // dar kenarı

// ---------- ULN2003 YERLEŞİMİ ----------
uln_x        = 34.6;
uln_y        = 31.6;
uln_delik_x  = 29.8;    // delik MERKEZLERİ arası (uzun kenar)
uln_delik_y  = 27.1;    // delik MERKEZLERİ arası (kısa kenar)
uln_merkez_x = 20.3;

// ---------- HESAPLANAN DEĞERLER (dokunma) ----------
teker_dis  = teker_cap + 2 * (oring_kalin - oring_derin);  // ~60 mm
mil_yerden = teker_dis / 2;                                 // mil yerden yüksekliği
motor_z    = mil_yerden - mil_ofset;                        // motor gövde merkezi
plaka_alt  = motor_z + motor_cap / 2 + 1;                   // plakanın alt yüzü
ara_yuk    = plaka_alt - caster_yuk;                        // sarhoş teker yükseltici

echo(str("Plaka alt yuksekligi: ", plaka_alt, " mm"));
echo(str("Sarhos teker yukseltici: ", ara_yuk, " mm"));
echo(str("Teker dis capi: ", teker_dis, " mm"));

// civata + somun hesabı
caster_yigin = caster_flans + ara_yuk + sasi_z;   // flanş altından plaka üstüne
echo(str("Civata yigini: ", caster_yigin, " mm  |  civatanin plaka ustunden cikintisi: ",
         civata_boy - caster_yigin, " mm"));
echo(str("Yay deliklerin toplam uzunlugu: ",
         2 * PI * (caster_ucgen / sqrt(3)) * (2 * yay_aci) / 360 + caster_vida + caster_bosluk, " mm"));

// ============================================================
//  YARDIMCI ŞEKİLLER
// ============================================================
module yuvarlak_kare(x, y, z, r) {
  hull() for (i = [-1, 1], j = [-1, 1])
    translate([i * (x / 2 - r), j * (y / 2 - r), 0]) cylinder(r = r, h = z);
}

// Damla şeklinde delik: baskı yönünde yukarı bakan sivri ucu sayesinde
// yatay delikler desteksiz ve sarkmadan basılır. (model -z = baskıda yukarı)
module damla(r) {
  hull() {
    circle(r = r, $fn = 32);
    polygon([[-r * 0.7071, -r * 0.7071], [r * 0.7071, -r * 0.7071], [0, -r * 1.4142]]);
  }
}

module d_mil(t, h) {
  linear_extrude(h) intersection() {
    circle(d = mil_cap + t);
    square([mil_duz + t, mil_cap + 2], center = true);
  }
}

// ============================================================
//  TEKER
// ============================================================
// Baskı yönünde: dış yüz tablada, göbek yukarı bakar. Desteksiz basılır.
module teker_baski() {
  Ro      = teker_cap / 2;
  Ri      = Ro - 4;
  gobek_h = mil_boy - mil_cikinti - 0.5;
  oz1     = teker_en / 2 - 2;   // oluk tabanı
  difference() {
    union() {
      // jant + O-ring oluğu (üst kenarı 45 derece pahlı)
      rotate_extrude() polygon([
        [Ri, 0], [Ro, 0], [Ro, oz1],
        [Ro - oring_derin, oz1],
        [Ro - oring_derin, oz1 + 2],
        [Ro, oz1 + 2 + oring_derin],
        [Ro, teker_en], [Ri, teker_en]
      ]);
      cylinder(r = Ri + 0.5, h = disk_kalin);   // disk
      cylinder(d = gobek_cap, h = gobek_h);     // göbek
    }
    translate([0, 0, -1]) d_mil(tol, gobek_h + 2);  // D şekilli mil deliği
  }
}

// Montaj görünümü için: z=0 kulak yüzeyi, mil +z yönünde
module teker_lokal() {
  translate([0, 0, mil_boy]) mirror([0, 0, 1]) teker_baski();
}

// ============================================================
//  MOTOR BRAKETİ
// ============================================================
// Motor gövdesi dışarıdan delikten içeri geçer, kulaklar braketin dış
// yüzüne M3 vida + somunla tutturulur. Mil dışarı bakar, teker takılır.
module braket() {
  yi = sasi_y / 2 - braket_kalin;
  difference() {
    union() {
      // dikey duvar (v4 ile aynı yükseklik ve genişlik; kalınlık içeri doğru arttı)
      translate([-braket_gen / 2, yi, motor_z - 7])
        cube([braket_gen, braket_kalin, plaka_alt - (motor_z - 7) + 0.01]);
      // uç destek üçgenleri (braketin iki ucunda, kulak somunlarının dışında; 2 mm içeride taşar)
      for (sx = [-1, 1])
        translate([sx * (braket_gen / 2 + 2.5 - destek_kalin / 2) - destek_kalin / 2, 0, 0])  // x: 21.5..27.5, kulak somunlarının dışında
          rotate([90, 0, 90]) linear_extrude(destek_kalin)
            polygon([[yi + 0.01, plaka_alt + 0.01], [yi - destek_y, plaka_alt + 0.01],
                     [yi + 0.01, plaka_alt - destek_z]]);
      // plaka-duvar iç köşesinde boydan boya pah
      translate([-braket_gen / 2, 0, 0]) rotate([90, 0, 90]) linear_extrude(braket_gen)
        polygon([[yi + 0.01, plaka_alt + 0.01], [yi - kose_pah, plaka_alt + 0.01],
                 [yi + 0.01, plaka_alt - kose_pah]]);
    }
    // motor gövdesi geçiş deliği (yuvarlak) ve gövdenin içerideki boşluğu
    translate([0, sasi_y / 2 + 1, motor_z]) rotate([90, 0, 0])
      cylinder(d = motor_cap + 2 * tol, h = braket_kalin + 2);
    translate([0, yi + 0.01, motor_z]) rotate([90, 0, 0])
      cylinder(d = motor_cap + 2 * tol + 1, h = motor_boy);
    // kulak vida delikleri
    for (sx = [-1, 1])
      translate([sx * kulak_aralik / 2, sasi_y / 2 + 1, motor_z]) rotate([90, 0, 0])
        linear_extrude(braket_kalin + 2) damla(vida_delik / 2);
  }
}

// ============================================================
//  SARHOŞ TEKER YÜKSELTİCİSİ
// ============================================================
// Vidalar alttan, sarhoş tekerin flanşından geçip bu parçadaki
// ısıl insert'lere girer. Plakanın üstünde hiçbir vida çıkmaz.
module caster_ara() {
  translate([caster_x, 0, caster_yuk])
    cylinder(d = caster_cap, h = ara_yuk + 0.01);
}

// Yükselticiden ve plakadan boydan boya geçen YAY ŞEKLİNDE delikler.
// Her delik, sarhoş tekerin merkezi etrafındaki daire boyunca sağa ve sola
// "yay_aci" kadar uzar. Delikler tam hizalanmazsa teker hafifçe döndürülerek oturtulur.
module caster_delikleri() {
  ust = plaka_alt + sasi_z;
  r   = caster_ucgen / sqrt(3);          // deliklerin merkeze uzaklığı
  d   = caster_vida + caster_bosluk;     // delik genişliği (2.4 mm)
  for (a = [0, 120, 240])
    translate([caster_x, 0, caster_yuk - 1])
      for (b = [-yay_aci : yay_aci / 4 : yay_aci - yay_aci / 4])
        hull() for (c = [b, b + yay_aci / 4])
          for (dr = [-caster_radyal, caster_radyal])
            rotate([0, 0, a + c]) translate([r + dr, 0, 0])
              cylinder(d = d, h = ust - caster_yuk + 2, $fn = 24);
}

// ============================================================
//  PLAKA
// ============================================================
module plaka() {
  difference() {
    hull() {
      translate([0, 0, plaka_alt]) yuvarlak_kare(sasi_x, sasi_y, sasi_z - pah, kose_r);
      translate([0, 0, plaka_alt + sasi_z - 0.01])
        yuvarlak_kare(sasi_x - 2 * pah, sasi_y - 2 * pah, 0.01, kose_r - pah);
    }

    // ULN2003 montaj delikleri (alttan vida, kartın altında somun = ara parça)
    for (sy = [-1, 1], dx = [-1, 1], dy = [-1, 1])
      translate([uln_merkez_x + dx * uln_delik_x / 2,
                 sy * (uln_y / 2 + 2.8) + dy * uln_delik_y / 2,
                 plaka_alt - 1])
        cylinder(d = vida_delik, h = sasi_z + 2);

    // kabuk bağlantı delikleri (köşeler)
    for (sx = [-1, 1], sy = [-1, 1])
      translate([sx * 52, sy * 42, plaka_alt - 1])
        cylinder(d = vida_delik, h = sasi_z + 2);

    // motor kablosu geçiş yuvaları (oval, fiş rahat geçsin)
    for (sy = [-1, 1])
      translate([36, sy * 40, plaka_alt - 1])
        hull() for (dx = [-1, 1])
          translate([dx * (fis_en + 3 - fis_kalin - 3) / 2, 0, 0])
            cylinder(d = fis_kalin + 3, h = sasi_z + 2);

    // alt yüzde sürüm yazısı
    translate([-5, 0, plaka_alt - 0.01])
      linear_extrude(0.61) mirror([1, 0, 0])
        text("VızVızBot v8", size = 6, halign = "center", valign = "center");
  }
}

// ============================================================
//  BİRLEŞTİRMELER
// ============================================================
module sasi() {
  difference() {
    union() {
      plaka();
      braket();
      mirror([0, 1, 0]) braket();
      caster_ara();
    }
    caster_delikleri();
  }
}

// Baskı yönü: plakanın üst yüzü tablada, braketler yukarı bakar. Desteksiz.
module sasi_baski() {
  translate([0, 0, plaka_alt + sasi_z]) rotate([180, 0, 0]) sasi();
}

module braket_test() {
  intersection() {
    sasi_baski();
    translate([-30, -sasi_y / 2 - 1, -1]) cube([60, 22, 100]);
  }
}

module montaj() {
  color("gold") sasi();
  for (s = [1, -1]) scale([1, s, 1]) {
    color("dimgray")
      translate([0, sasi_y / 2, mil_yerden]) rotate([-90, 0, 0]) teker_lokal();
    // hayalet motor (sadece görsel)
    %translate([0, sasi_y / 2, motor_z]) rotate([90, 0, 0])
      cylinder(d = motor_cap, h = motor_boy);
  }
}

// ============================================================
if      (parca == "teker")       teker_baski();
else if (parca == "braket_test") braket_test();
else if (parca == "sasi")        sasi_baski();
else                             montaj();
