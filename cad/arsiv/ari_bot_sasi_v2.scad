// ============================================================
//  ARI BOT  -  Şasi v2 + Teker
//  v2: motor kablosu delikleri fiş geçecek şekilde oval yuva yapıldı
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
braket_kalin = 3;
braket_gen   = 50;
vida_delik   = 3.4;     // M3 geçiş deliği

// ---------- SARHOŞ TEKER ----------
caster_yuk   = 28.7;    // montaj yüzeyinden bilyenin altına
caster_cap   = 27.5;
caster_ucgen = 15.7;    // delik merkezleri arası (eşkenar üçgen)
caster_x     = -45;     // robotun arkasında
insert_delik = 3.7;     // M3 ısıl insert deliği (insert dış çapı 4.0 mm ölçüldü)
insert_derin = 6;

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

// ============================================================
//  YARDIMCI ŞEKİLLER
// ============================================================
module yuvarlak_kare(x, y, z, r) {
  hull() for (i = [-1, 1], j = [-1, 1])
    translate([i * (x / 2 - r), j * (y / 2 - r), 0]) cylinder(r = r, h = z);
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
      // dikey duvar
      translate([-braket_gen / 2, yi, motor_z - 7])
        cube([braket_gen, braket_kalin, plaka_alt - (motor_z - 7) + 0.01]);
      // destek üçgenleri
      for (sx = [-1, 1])
        translate([sx * (braket_gen / 2 - 1.5) - 1.5, 0, 0])
          rotate([90, 0, 90]) linear_extrude(3)
            polygon([[yi, plaka_alt], [yi - 10, plaka_alt], [yi, plaka_alt - 12]]);
    }
    // motor gövdesi geçiş deliği
    translate([0, sasi_y / 2 + 1, motor_z]) rotate([90, 0, 0])
      cylinder(d = motor_cap + 2 * tol, h = braket_kalin + 2);
    // kulak vida delikleri
    for (sx = [-1, 1])
      translate([sx * kulak_aralik / 2, sasi_y / 2 + 1, motor_z]) rotate([90, 0, 0])
        cylinder(d = vida_delik, h = braket_kalin + 2);
  }
}

// ============================================================
//  SARHOŞ TEKER YÜKSELTİCİSİ
// ============================================================
// Vidalar alttan, sarhoş tekerin flanşından geçip bu parçadaki
// ısıl insert'lere girer. Plakanın üstünde hiçbir vida çıkmaz.
module caster_ara() {
  translate([caster_x, 0, caster_yuk])
    difference() {
      cylinder(d = caster_cap, h = ara_yuk + 0.01);
      for (a = [0, 120, 240])
        rotate([0, 0, a]) translate([caster_ucgen / sqrt(3), 0, -1])
          cylinder(d = insert_delik, h = insert_derin + 1);
    }
}

// ============================================================
//  PLAKA
// ============================================================
module plaka() {
  difference() {
    translate([0, 0, plaka_alt]) yuvarlak_kare(sasi_x, sasi_y, sasi_z, kose_r);

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
        text("ARI BOT v2", size = 5, halign = "center", valign = "center");
  }
}

// ============================================================
//  BİRLEŞTİRMELER
// ============================================================
module sasi() {
  plaka();
  braket();
  mirror([0, 1, 0]) braket();
  caster_ara();
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
