// ============================================================
//  VızVızBot  -  Şasi v5 (plaka + ayrı braketler)
//  v2: motor kablosu delikleri fiş geçecek şekilde oval yuva yapıldı
//  v3: sarhoş teker insert yerine kendi civatalarıyla boydan boya
//      delikli; delikler daire boyunca yay şeklinde uzatıldı (ayar payı)
//  v4: VızVızBot yazısı; tablaya değen kenarda pah (fil ayağına karşı);
//      yatay vida delikleri damla şeklinde (desteksiz temiz baskı);
//      destek üçgenleri kalınlaştırıldı
//  v5: braketler AYRI parça, yan yatırılarak basılır (katmanlar yükü
//      taşıyacak yönde -> çok daha güçlü). Duvar 3 -> 5 mm, motor deliğinin
//      altı kapalı halka, tam boy destek üçgeni, 6 mm flanş.
//      Braket plakaya 2 adet M3x10 vida + ısıl insert ile bağlanır.
//      Sarhoş teker delikleri 2.4 -> 3.0 mm ve merkeze doğru da uzatıldı
//      (cıvatalar 90 derece dik geçmiyordu).
//
//  Kullanım: Aşağıdaki "parca" satırını değiştir, F6 -> F7 ile STL al.
//    "montaj"      : sadece önizleme
//    "plaka"       : plaka + sarhoş teker yükselticisi (baskı yönünde)
//    "braketler"   : 2 braket (sağ + sol), yan yatırılmış baskı yönünde
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
pah          = 0.6;     // tablaya değen kenardaki pah (fil ayağı önlemi)
// ---------- v5 BRAKET ----------
b_duvar      = 5;       // braket duvar kalınlığı (v4: 3)
b_alt        = 5;       // braket alt kenarının yerden yüksekliği (motor deliği altı kapalı)
b_flans      = 6;       // plakaya oturan flanş kalınlığı (insert için)
b_flans_derin = 15;     // flanşın içeri uzunluğu
b_bag_x      = 18;      // plaka-braket vidalarının x konumu (±)
b_bag_y      = 38;      // plaka-braket vidalarının y konumu (ULN kartından uzak)
insert_delik = 3.7;     // M3 ısıl insert deliği (insert dış çapı 4.0 mm)

// ---------- SARHOŞ TEKER ----------
caster_yuk   = 28.7;    // montaj yüzeyinden bilyenin altına
caster_cap   = 27.5;
caster_ucgen = 15.7;    // delik merkezleri arası (eşkenar üçgen)
caster_x     = -45;     // robotun arkasında
caster_flans = 1.6;     // sarhoş tekerin montaj flanşı kalınlığı
caster_vida  = 2.0;     // sarhoş teker delik çapı (ölçülen)
caster_bosluk = 1.0;    // v5: 0.4 -> 1.0 (delik 3.0 mm; uzun kanalda cıvata dik geçsin)
caster_radyal = 0.6;    // v5: delikler merkeze doğru da ±0.6 mm uzatıldı
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
// Yatay delik için damla profili, sivri ucu robotun +X yönüne bakar
// (braket yan yatırılınca +X baskıda YUKARI olur). "kes" verilirse uç düzlenir.
module damla_x(r, kes = 0) {
  intersection() {
    hull() {
      circle(r = r, $fn = 48);
      polygon([[r * 0.7071, -r * 0.7071], [r * 1.4142, 0], [r * 0.7071, r * 0.7071]]);
    }
    if (kes > 0) translate([-r - 1, -r - 1]) square([2 * r + 1 + kes, 2 * r + 2]);
    else translate([-r - 1, -r - 1]) square([3 * r, 2 * r + 2]);
  }
}

// Y ekseni boyunca delik (2B profil: x = robot X, y = robot Z)
module y_delik(x, z, y0, y1, r, kes = 0) {
  translate([x, y1, z]) rotate([90, 0, 0]) linear_extrude(y1 - y0) damla_x(r, kes);
}

// Sağ braket (y > 0). Motor gövdesi dışarıdan delikten içeri geçer, kulaklar
// dış yüze M3 vida + somunla. Flanş plakanın altına oturur, plakadan
// geçen M3 vida flanştaki ısıl insert'e girer.
module braket() {
  yd = sasi_y / 2;            // dış yüz
  yi = yd - b_duvar;          // iç yüz
  r_m = motor_cap / 2 + tol;  // motor deliği yarıçapı
  difference() {
    union() {
      // duvar
      translate([-braket_gen / 2, yi, b_alt]) cube([braket_gen, b_duvar, plaka_alt - b_alt]);
      // flanş
      translate([-braket_gen / 2, yi - b_flans_derin, plaka_alt - b_flans])
        cube([braket_gen, b_flans_derin + 0.01, b_flans]);
      // tam boy destek üçgeni
      translate([-braket_gen / 2, 0, 0]) rotate([90, 0, 90]) linear_extrude(braket_gen)
        polygon([[yi + 0.01, plaka_alt - b_flans + 0.01], [yi - 5, plaka_alt - b_flans + 0.01],
                 [yi + 0.01, plaka_alt - b_flans - 10]]);
    }
    // motor gövdesi deliği (duvardan) ve gövde boşluğu (flanş/destek altında)
    y_delik(0, motor_z, yi - 0.01, yd + 1, r_m, 0.5);
    y_delik(0, motor_z, yi - b_flans_derin - 5, yi + 0.02, r_m + 0.5, 0.5);
    // kulak vida delikleri
    for (sx = [-1, 1]) y_delik(sx * kulak_aralik / 2, motor_z, yi - 1, yd + 1, vida_delik / 2);
    // plaka bağlantısı: ısıl insert delikleri (flanş boyunca)
    for (sx = [-1, 1])
      translate([sx * b_bag_x, b_bag_y, plaka_alt - b_flans - 0.01])
        linear_extrude(b_flans + 1) damla_x(insert_delik / 2);
  }
}

// Baskı yönü: robotun +X yönü yukarı (L profili tablada). Desteksiz.
module braketler_baski() {
  // sağ braket
  translate([0, -14, braket_gen / 2]) rotate([0, -90, 0])
    translate([0, -40, 0]) braket();
  // sol braket (ayna)
  translate([0, 14, braket_gen / 2]) rotate([0, -90, 0])
    translate([0, 40, 0]) mirror([0, 1, 0]) braket();
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
  d   = caster_vida + caster_bosluk;     // delik genişliği (v5: 3.0 mm)
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

    // braket bağlantı delikleri
    for (sx = [-1, 1], sy = [-1, 1])
      translate([sx * b_bag_x, sy * b_bag_y, plaka_alt - 1])
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
        text("VızVızBot v5", size = 6, halign = "center", valign = "center");
  }
}

// ============================================================
//  BİRLEŞTİRMELER
// ============================================================
module plaka_tum() {
  difference() {
    union() { plaka(); caster_ara(); }
    caster_delikleri();
  }
}

module sasi() {
  plaka_tum();
  braket();
  mirror([0, 1, 0]) braket();
}

// Baskı yönü: plakanın üst yüzü tablada, yükseltici yukarı bakar. Desteksiz.
module plaka_baski() {
  translate([0, 0, plaka_alt + sasi_z]) rotate([180, 0, 0]) plaka_tum();
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
if      (parca == "plaka")     plaka_baski();
else if (parca == "braketler") braketler_baski();
else                           montaj();
