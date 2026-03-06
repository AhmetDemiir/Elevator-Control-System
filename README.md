# 🏢 Asansör Kontrol Sistemi (VHDL)

<p align="left">
  <img src="https://img.shields.io/badge/VHDL-000000?style=for-the-badge&logo=verilog&logoColor=white" alt="VHDL" />
  <img src="https://img.shields.io/badge/ModelSim-00599C?style=for-the-badge" alt="ModelSim" />
  <img src="https://img.shields.io/badge/FPGA-FFB81C?style=for-the-badge&logo=intel&logoColor=black" alt="FPGA" />
</p>

## 📋 Proje Özeti
Bu proje, donanım tanımlama dili olan **VHDL** kullanılarak 4 katlı bir bina için tasarlanmış bir asansör kontrol sistemidir. Sistem temel olarak **FSM (Sonlu Durum Makinesi)** mantığına dayanmaktadır ve ardışık (sequential) devre tasarımı prensiplerini içerir.

## 🎯 Özellikler
- ✅ **4 Katlı Sistem:** 4 farklı kat için çağrı ve hedef belirleme mekanizması.
- ✅ **FSM Modellemesi:** Asansörün hareket mantığının durum makineleri ile kontrolü.
- ✅ **Zamanlama Yönetimi:** Saat sinyali (Clock) ile senkron zamanlama ve katlar arası geçiş gecikmelerinin modellenmesi.

## 🧠 FSM (Sonlu Durum Makinesi) Yapısı
Asansörün çalışma mantığı aşağıdaki temel durumlardan (states) oluşur:
1. **IDLE (Bekleme):** Asansörün hareketsiz şekilde çağrı beklediği durum.
2. **MOVING_UP (Yukarı Çıkma):** Hedef kat mevcut kattan yüksekse devreye giren durum.
3. **MOVING_DOWN (Aşağı İnme):** Hedef kat mevcut kattan düşükse devreye giren durum.
4. **DOORS_OPEN (Kapı Açık):** İstenilen kata ulaşıldığında kapıların açılma ve bekleme durumu.

## 🚀 Kurulum ve Simülasyon
1. Bu repoyu bilgisayarınıza klonlayın:
   ```bash
   git clone [https://github.com/AhmetDemiir/Elevator-Control-System.git](https://github.com/AhmetDemiir/Elevator-Control-System.git)
2. Proje dosyalarını .vhd uzantılı olarak ModelSim, Quartus veya Vivado gibi bir simülasyon programında açın.

3. Derleme (Compile) işlemini gerçekleştirin.

4. Testbench dosyası üzerinden sinyalleri Waveform ekranında simüle ederek asansörün katlar arası geçişini gözlemleyebilirsiniz.
