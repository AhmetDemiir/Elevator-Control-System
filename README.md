# 🏢 Asansör Kontrol Sistemi (VHDL)

![VHDL](https://img.shields.io/badge/VHDL-000000?style=for-the-badge&logo=verilog&logoColor=white)
![ModelSim](https://img.shields.io/badge/ModelSim-00599C?style=for-the-badge)

Bu proje, donanım tanımlama dili olan **VHDL** kullanılarak 4 katlı bir bina için tasarlanmış bir asansör kontrol sistemidir. Sistem temel olarak **FSM (Sonlu Durum Makinesi - Finite State Machine)** mantığına dayanmaktadır ve ardışık (sequential) devre tasarım prensiplerini içerir.

## 🚀 Özellikler
- 4 farklı kat için çağrı (call) ve hedef belirleme mekanizması.
- FSM tabanlı durum kontrolü.
- Saat sinyali (Clock) ile senkron zamanlama yönetimi.
- Kapı açılma/kapanma ve katlar arası geçiş gecikmelerinin modellenmesi.

## 🧠 FSM (Sonlu Durum Makinesi) Yapısı
Asansörün hareket mantığı aşağıdaki temel durumlardan (states) oluşur:
1. **IDLE:** Asansörün hareketsiz şekilde beklediği başlangıç durumu.
2. **MOVING_UP:** Hedef kat mevcut kattan yüksekse asansörün yukarı çıkma durumu.
3. **MOVING_DOWN:** Hedef kat mevcut kattan düşükse asansörün aşağı inme durumu.
4. **DOORS_OPEN:** İstenilen kata ulaşıldığında kapıların açılma ve bekleme durumu.

## 🛠️ Nasıl Çalıştırılır?
1. Bu repoyu bilgisayarınıza klonlayın:
   ```bash
   git clone [https://github.com/AhmetDemiir/Elevator-Control-System.git](https://github.com/AhmetDemiir/Elevator-Control-System.git)
