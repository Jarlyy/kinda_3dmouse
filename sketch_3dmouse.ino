void setup() {
  Serial.begin(115200);
  // Настройка пинов для более точного чтения
  analogReference(DEFAULT);
}

void loop() {
  // Чтение осей с фильтрацией шумов
  int lx = filteredRead(A0);
  int ly = filteredRead(A1);
  int rx = filteredRead(A2);
  int ry = filteredRead(A3);

  // Формат: LX,LY,RX,RY\n
  Serial.print(lx); Serial.print(",");
  Serial.print(ly); Serial.print(",");
  Serial.print(rx); Serial.print(",");
  Serial.print(ry); Serial.println(",");

  delay(8); // Оптимальная задержка
}

// Функция для сглаживания значений
int filteredRead(int pin) {
  int sum = 0;
  for (int i = 0; i < 3; i++) {
    sum += analogRead(pin);
    delay(1);
  }
  return sum / 3;
}