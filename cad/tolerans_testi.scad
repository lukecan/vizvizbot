// ============================================================
//  28BYJ-48 Mil Oturma Testi
//  4 farklı toleranslı göbek üretir.
//  Soldan sağa: 0.1 / 0.2 / 0.3 / 0.4 mm
//  Kenardaki çentik sayısı = sıra numarası (1 çentik = 0.1, 4 çentik = 0.4)
// ============================================================

mil_cap     = 5;     // milin çapı (mm)
mil_duz     = 3;     // milin iki düz yüzü arasındaki mesafe (mm)
goebek_cap  = 12;    // göbeğin dış çapı (mm)
goebek_boy  = 6;     // göbeğin yüksekliği (mm)
toleranslar = [0.1, 0.2, 0.3, 0.4];

$fn = 60;

// D şeklindeki mil kesiti (iki yanı düz)
module mil_delik(t) {
  intersection() {
    circle(d = mil_cap + t);
    square([mil_duz + t, mil_cap + 2], center = true);
  }
}

// Tanıma çentikleri
module centikler(adet) {
  for (k = [0 : adet - 1])
    rotate([0, 0, 90 + k * 20])
      translate([goebek_cap / 2, 0, goebek_boy - 1])
        cube([1.6, 1.2, 2.2], center = true);
}

for (i = [0 : len(toleranslar) - 1])
  translate([i * (goebek_cap + 4), 0, 0])
    difference() {
      cylinder(d = goebek_cap, h = goebek_boy);
      translate([0, 0, -1])
        linear_extrude(goebek_boy + 2) mil_delik(toleranslar[i]);
      centikler(i + 1);
    }
