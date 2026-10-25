// ============================================================
//  Garage Riff - Buzzer Demo (orijinal beste)
//  Hızlı sekizlik notalar, tekrar eden kök notalar,
//  oktav sıçramaları: 2000'ler garage rock havası.
//  Kart üzerindeki LED (D13) her notada yanıp söner.
// ============================================================

const byte BUZZER = 3;     // buzzer + ucu -> 220 ohm direnç -> D3
const byte LED    = 13;    // Nano'nun üstündeki dahili LED

const int TEMPO = 160;                 // BPM: hızlandırmak için artır
const int SEKIZLIK = 60000 / TEMPO / 2; // bir sekizlik notanın süresi (ms)

// Notalar (Hz)
#define E3 165
#define G3 196
#define A3 220
#define B3 247
#define D4 294
#define E4 330
#define FS4 370
#define G4 392
#define A4 440
#define B4 494
#define D5 587
#define E5 659
#define R  0     // sus

// Her nota bir sekizlik sürer. Uzun nota için aynı notayı tekrar yaz.
// --- A bölümü: kök notada koşturan bas hissi ---
const int bolumA[] = {
  E4, E4, E4, E4, E4, E4, G4, A4,
  E4, E4, E4, E4, D4, D4, B3, D4,
  E4, E4, E4, E4, E4, E4, G4, A4,
  B4, A4, G4, E4, D4, E4, R,  R
};

// --- B bölümü: oktav sıçramalı "nakarat" ---
const int bolumB[] = {
  A3, A4, A3, A4, G3, G4, G3, G4,
  E3, E4, E3, E4, D4, E4, G4, A4,
  A3, A4, A3, A4, G3, G4, B3, B4,
  E5, D5, B4, A4, G4, FS4, E4, R
};

void setup() {
  pinMode(BUZZER, OUTPUT);
  pinMode(LED, OUTPUT);
}

void loop() {
  cal(bolumA, sizeof(bolumA) / sizeof(int));
  cal(bolumA, sizeof(bolumA) / sizeof(int));
  cal(bolumB, sizeof(bolumB) / sizeof(int));
  cal(bolumA, sizeof(bolumA) / sizeof(int));
  delay(1500);   // tekrar başlamadan önce kısa mola
}

void cal(const int notalar[], int adet) {
  for (int i = 0; i < adet; i++) {
    int n = notalar[i];
    if (n == R) {
      noTone(BUZZER);
      digitalWrite(LED, LOW);
      delay(SEKIZLIK);
      continue;
    }
    // Notayı %80 uzunlukta çal, araya minik boşluk bırak:
    // gitardaki "palm mute" gibi kesik, tok bir his verir.
    tone(BUZZER, n, SEKIZLIK * 0.8);
    digitalWrite(LED, HIGH);
    delay(SEKIZLIK * 0.8);
    digitalWrite(LED, LOW);
    delay(SEKIZLIK * 0.2);
  }
}
