// ============================================================
//  VızVızBot - Teker v3 (kollu jant + vidalı göbek)
//  v3: dolu disk yerine 5 kol (daha hızlı baskı, daha az filament)
//      mil deliği toleransı 0.15 -> 0.3 (v2'de mil girmedi; tutuşu vida sağlıyor)
//  v2'nin v1'den farkı:
//   - D şekilli mil deliği daha dar (tolerans 0.3 -> 0.15)
//   - Göbeğe yandan M3 vida girer, ucu milin DÜZ yüzüne basar
//   - M3 somun göbeğin içindeki yuvaya üstten düşürülür (desteksiz)
//
//   - Jantta tornavida/alyan erişim deliği (O-ring takılınca gizlenir)
//
//  Montaj: somunu yuvaya at -> M3x10 vidayı içeriden birkaç tur çevirip
//  somuna başlat (ucu mil deliğine taşmasın) -> tekeri mile tak (milin düz
//  yüzü vidaya baksın) -> janttaki delikten sık -> en son O-ring'i tak.
//
//  "parca": "teker" (1 adet), "iki_teker" (tablaya 2 adet), "kesit" (önizleme)
// ============================================================

parca = "iki_teker";
$fn = 96;

// ---------- MOTOR MİLİ (28BYJ-48) ----------
mil_cap     = 5;
mil_duz     = 3;      // iki düz yüz arası
mil_boy     = 10;     // kulak yüzeyinden mil ucuna
mil_cikinti = 1.5;    // mil dibindeki yuvarlak çıkıntı
mil_tol     = 0.3;    // v2'de 0.15 çok dardı; sıkılığı vida sağlar

// ---------- TEKER ----------
teker_cap   = 58;     // O-ring ile ~60 mm
teker_en    = 8;
oring_derin = 2;
disk_kalin  = 3;
gobek_cap   = 18;     // v1: 12 (vida + somun için büyütüldü)
kol_sayi    = 5;
kol_en      = 5;
kol_acilar  = [for (i = [0 : kol_sayi - 1]) 36 + i * 360 / kol_sayi];  // vida yönünde (+X) kol yok

// ---------- VİDA / SOMUN (M3) ----------
vida_delik  = 3.4;
somun_ak    = 5.5;    // somun karşılıklı düz kenarlar arası (standart M3)
somun_kal   = 2.4;    // somun kalınlığı (standart M3)
somun_bosluk = 0.4;
bas_cap     = 6.5;    // vida başı boşluğu
erisim_delik = 4.5;   // jantta tornavida erişim deliği

// ---------- HESAPLANAN ----------
gobek_h = mil_boy - mil_cikinti - 0.5;   // 8 mm, motora 0.5 mm boşluk
vida_z  = 5;                              // vida ekseni yüksekliği (milin düz kısmında)
somun_r = (mil_cap / 2 + 1) + (somun_kal + somun_bosluk) / 2;  // somun yuvası merkezi

echo(str("Gobek yuksekligi: ", gobek_h, " mm"));
echo(str("Vida ucu - mil duz yuzu mesafesi (gobek yuzeyinden): ",
         gobek_cap / 2 - mil_duz / 2, " mm  -> M3x10 kullan"));

module d_mil(t, h) {
  linear_extrude(h) intersection() {
    circle(d = mil_cap + t);
    square([mil_duz + t, mil_cap + 2], center = true);
  }
}

// yatay delik için damla profili (sivri ucu baskıda yukarı bakar)
module damla(r) {
  hull() {
    circle(r = r, $fn = 32);
    polygon([[-r * 0.7071, r * 0.7071], [r * 0.7071, r * 0.7071], [0, r * 1.4142]]);
  }
}

module teker() {
  Ro  = teker_cap / 2;
  Ri  = Ro - 4;
  oz1 = teker_en / 2 - 2;
  difference() {
    union() {
      rotate_extrude() polygon([
        [Ri, 0], [Ro, 0], [Ro, oz1],
        [Ro - oring_derin, oz1],
        [Ro - oring_derin, oz1 + 2],
        [Ro, oz1 + 2 + oring_derin],
        [Ro, teker_en], [Ri, teker_en]
      ]);
      // kollar (göbekten janta)
      for (a = kol_acilar) rotate([0, 0, a])
        translate([0, -kol_en / 2, 0]) cube([Ri + 0.5, kol_en, disk_kalin]);
      cylinder(d = gobek_cap, h = gobek_h);
    }
    // D şekilli mil deliği (düz yüzler X eksenine dik -> vida X yönünden basar)
    translate([0, 0, -1]) d_mil(mil_tol, gobek_h + 2);

    // yatay vida deliği: göbek yüzeyinden mile kadar (+X yönü)
    translate([0, 0, vida_z]) rotate([0, 90, 0])
      linear_extrude(gobek_cap) rotate([0, 0, 90]) damla(vida_delik / 2);

    // somun yuvası: üstten açık, somun dik durur
    translate([somun_r - (somun_kal + somun_bosluk) / 2,
               -(somun_ak + somun_bosluk) / 2,
               vida_z - (somun_ak / cos(30)) / 2 - 0.3])
      cube([somun_kal + somun_bosluk, somun_ak + somun_bosluk, gobek_h]);

    // jantta erişim deliği: tornavida / alyan anahtarı vidaya buradan ulaşır
    translate([0, 0, vida_z]) rotate([0, 90, 0])
      translate([0, 0, Ri - 1]) linear_extrude(Ro - Ri + 2)
        rotate([0, 0, 90]) damla(erisim_delik / 2);

  }
}


if (parca == "teker") teker();
else if (parca == "kesit")
  difference() { teker(); translate([-50, 0, -1]) cube([100, 50, 20]); }
else {
  teker();
  translate([teker_cap + 6, 0, 0]) teker();
}
