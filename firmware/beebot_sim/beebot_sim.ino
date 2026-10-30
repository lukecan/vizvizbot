// ============================================================
//  Bee-Bot Klonu - Simülasyon Sürümü (Arduino Uno / Nano)
//  Kullanım: Ok tuşlarıyla komut gir, GO ile çalıştır.
//            SİL tuşu hafızayı temizler.
// ============================================================

// ---------- PİNLER ----------
const byte SOL_MOTOR[4] = {4, 5, 6, 7};    // ULN2003 #1 -> IN1, IN2, IN3, IN4
const byte SAG_MOTOR[4] = {8, 9, 10, 11};  // ULN2003 #2 -> IN1, IN2, IN3, IN4

const byte BTN_ILERI = 2;
const byte BTN_GERI  = 3;
const byte BTN_SOL   = 12;
const byte BTN_SAG   = A0;
const byte BTN_GO    = A1;
const byte BTN_SIL   = A2;
const byte BUZZER    = A3;

// ---------- KALİBRASYON (gerçek robotta ayarlanacak) ----------
const int ADIM_KARE  = 3268;  // 15 cm ilerlemek için yarım adım sayısı (60 mm teker)
const int ADIM_DONUS = 1910;  // 90 derece dönüş (teker arası ~112 mm); ilk_surus_testi ile kalibre et
const int ADIM_BEKLE = 1200;  // adımlar arası bekleme (mikrosaniye) -> hız

// Motor yönleri: robot ileri yerine geri gidiyorsa ikisini birden ters çevir,
// sadece bir teker ters dönüyorsa o tekerin değerini ters çevir.
const int SOL_YON = -1;   // ters motor montajı (braket v11) ile ölçüldü
const int SAG_YON = 1;

// 28BYJ-48 yarım adım (half-step) sırası
const byte SIRA[8][4] = {
  {1,0,0,0}, {1,1,0,0}, {0,1,0,0}, {0,1,1,0},
  {0,0,1,0}, {0,0,1,1}, {0,0,0,1}, {1,0,0,1}
};

// ---------- KOMUT HAFIZASI ----------
enum Komut { ILERI, GERI, SOLA, SAGA };
const byte MAKS_KOMUT = 30;
Komut komutlar[MAKS_KOMUT];
byte komutSayisi = 0;

int solFaz = 0;
int sagFaz = 0;

// ============================================================
void setup() {
  for (byte i = 0; i < 4; i++) {
    pinMode(SOL_MOTOR[i], OUTPUT);
    pinMode(SAG_MOTOR[i], OUTPUT);
  }

  // Butonlar: bir ucu pine, diğer ucu GND'ye. Dahili pull-up kullanılıyor.
  byte butonlar[] = {BTN_ILERI, BTN_GERI, BTN_SOL, BTN_SAG, BTN_GO, BTN_SIL};
  for (byte b : butonlar) pinMode(b, INPUT_PULLUP);

  pinMode(BUZZER, OUTPUT);

  Serial.begin(9600);
  Serial.println("Bee-Bot hazir! Komut gir, sonra GO'ya bas.");
  melodiBaslangic();
}

void loop() {
  if (basildi(BTN_ILERI)) komutEkle(ILERI, "ILERI");
  if (basildi(BTN_GERI))  komutEkle(GERI,  "GERI");
  if (basildi(BTN_SOL))   komutEkle(SOLA,  "SOL");
  if (basildi(BTN_SAG))   komutEkle(SAGA,  "SAG");

  if (basildi(BTN_SIL)) {
    komutSayisi = 0;
    Serial.println("Hafiza silindi.");
    tone(BUZZER, 400, 300);
  }

  if (basildi(BTN_GO)) calistir();
}

// ---------- BUTON OKUMA (basit titreşim önleme) ----------
bool basildi(byte pin) {
  if (digitalRead(pin) == LOW) {
    delay(20);
    if (digitalRead(pin) == LOW) {
      while (digitalRead(pin) == LOW) {}  // bırakılana kadar bekle
      delay(20);
      return true;
    }
  }
  return false;
}

// ---------- KOMUT EKLEME ----------
void komutEkle(Komut k, const char* ad) {
  if (komutSayisi >= MAKS_KOMUT) {
    Serial.println("Hafiza dolu!");
    tone(BUZZER, 200, 500);
    return;
  }
  komutlar[komutSayisi++] = k;
  Serial.print(komutSayisi);
  Serial.print(". komut: ");
  Serial.println(ad);
  tone(BUZZER, 1000, 80);  // her tuşta kısa "bip"
}

// ---------- KOMUTLARI ÇALIŞTIRMA ----------
void calistir() {
  if (komutSayisi == 0) {
    Serial.println("Once komut gir!");
    tone(BUZZER, 200, 300);
    return;
  }

  Serial.println("GO!");
  delay(500);

  for (byte i = 0; i < komutSayisi; i++) {
    Serial.print("Calisiyor: ");
    Serial.println(i + 1);

    // Motorlar ayna simetrik takıldığı için ileri giderken ters yönde dönerler
    switch (komutlar[i]) {
      case ILERI: hareket(ADIM_KARE,   SOL_YON,  SAG_YON); break;
      case GERI:  hareket(ADIM_KARE,  -SOL_YON, -SAG_YON); break;
      case SOLA:  hareket(ADIM_DONUS, -SOL_YON,  SAG_YON); break;
      case SAGA:  hareket(ADIM_DONUS,  SOL_YON, -SAG_YON); break;
    }

    tone(BUZZER, 1500, 60);
    delay(300);
  }

  bobinleriKapat();  // pil tasarrufu ve motor ısınmasını önleme
  Serial.println("Hedefe varildi!");
  melodiBitis();
}

// İki motoru aynı anda adım adım döndürür.
// solYon / sagYon: +1 veya -1
void hareket(int adim, int solYon, int sagYon) {
  for (int i = 0; i < adim; i++) {
    solFaz = (solFaz + solYon + 8) % 8;
    sagFaz = (sagFaz + sagYon + 8) % 8;
    fazYaz(SOL_MOTOR, solFaz);
    fazYaz(SAG_MOTOR, sagFaz);
    delayMicroseconds(ADIM_BEKLE);
  }
}

void fazYaz(const byte motor[4], int faz) {
  for (byte j = 0; j < 4; j++) {
    digitalWrite(motor[j], SIRA[faz][j]);
  }
}

void bobinleriKapat() {
  for (byte j = 0; j < 4; j++) {
    digitalWrite(SOL_MOTOR[j], LOW);
    digitalWrite(SAG_MOTOR[j], LOW);
  }
}

// ---------- SESLER ----------
void melodiBaslangic() {
  tone(BUZZER, 523, 120); delay(150);  // Do
  tone(BUZZER, 659, 120); delay(150);  // Mi
  tone(BUZZER, 784, 200); delay(250);  // Sol
}

void melodiBitis() {
  int notalar[] = {784, 659, 784, 1047};
  for (int n : notalar) {
    tone(BUZZER, n, 150);
    delay(180);
  }
}
