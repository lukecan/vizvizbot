// ============================================================
//  VızVızBot - İlk Sürüş ve Kalibrasyon Testi
//  Butonsuz. Açınca 3 sn bekler, sonra:
//    1 kare ileri  -> bip -> 90 derece sağa -> bip -> 1 kare ileri -> melodi
//  Ölçtüklerine göre ADIM_KARE ve ADIM_DONUS'u değiştir, tekrar yükle.
//  Pinler Bee-Bot koduyla aynı.
// ============================================================

const byte SOL_MOTOR[4] = {4, 5, 6, 7};    // ULN2003 #1 IN1..IN4
const byte SAG_MOTOR[4] = {8, 9, 10, 11};  // ULN2003 #2 IN1..IN4
const byte BUZZER = A3;                    // + ucu 220 ohm üzerinden

// ---------- KALİBRASYON ----------
int ADIM_KARE  = 3268;   // 15 cm için yarım adım (60 mm teker)
int ADIM_DONUS = 1910;   // 90 derece için (teker arası ~112 mm)
const int ADIM_BEKLE = 1200;  // mikrosaniye; küçüldükçe hızlanır

// Motorlardan biri ters dönüyorsa ilgili değeri -1 yap
const int SOL_YON = -1;   // ters motor montajı (v11): ileri için -1
const int SAG_YON = 1;

const byte SIRA[8][4] = {
  {1,0,0,0}, {1,1,0,0}, {0,1,0,0}, {0,1,1,0},
  {0,0,1,0}, {0,0,1,1}, {0,0,0,1}, {1,0,0,1}
};
int solFaz = 0, sagFaz = 0;

void setup() {
  for (byte i = 0; i < 4; i++) {
    pinMode(SOL_MOTOR[i], OUTPUT);
    pinMode(SAG_MOTOR[i], OUTPUT);
  }
  pinMode(BUZZER, OUTPUT);

  tone(BUZZER, 800, 100);
  delay(3000);                 // robotu yere koyman için süre

  ileri(ADIM_KARE);   bip();
  sagaDon(ADIM_DONUS); bip();
  ileri(ADIM_KARE);

  bobinleriKapat();
  int notalar[] = {784, 659, 784, 1047};
  for (int n : notalar) { tone(BUZZER, n, 150); delay(180); }
}

void loop() {}   // bir kez çalışır; tekrar için Nano'nun reset tuşuna bas

void ileri(int adim)   { hareket(adim,  SOL_YON,  SAG_YON); }
void sagaDon(int adim) { hareket(adim,  SOL_YON, -SAG_YON); }

void hareket(int adim, int solYon, int sagYon) {
  for (int i = 0; i < adim; i++) {
    solFaz = (solFaz + solYon + 8) % 8;
    sagFaz = (sagFaz + sagYon + 8) % 8;
    for (byte j = 0; j < 4; j++) {
      digitalWrite(SOL_MOTOR[j], SIRA[solFaz][j]);
      digitalWrite(SAG_MOTOR[j], SIRA[sagFaz][j]);
    }
    delayMicroseconds(ADIM_BEKLE);
  }
}

void bobinleriKapat() {
  for (byte j = 0; j < 4; j++) {
    digitalWrite(SOL_MOTOR[j], LOW);
    digitalWrite(SAG_MOTOR[j], LOW);
  }
}

void bip() { tone(BUZZER, 1500, 80); delay(400); }
