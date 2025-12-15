LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY tb_asansor IS
END ENTITY tb_asansor;

ARCHITECTURE test OF tb_asansor IS
    -- Clock period
    CONSTANT CLK_PERIOD : TIME := 20 ns;

    -- Sinyalleri tan?mla
    SIGNAL tb_clk                 : STD_LOGIC := '0';
    SIGNAL tb_reset               : STD_LOGIC;
    SIGNAL tb_kabin_istekleri_in  : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
    SIGNAL tb_dis_cagrilar_in     : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL tb_mevcut_kat_in       : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0001"; -- Ba?lang?ç 1. kat
    SIGNAL tb_kapi_kapali_sensor_in: STD_LOGIC := '0';
    SIGNAL tb_asiri_yuk_sensor_in : STD_LOGIC := '0';
    SIGNAL tb_acil_durum_in       : STD_LOGIC := '0';
    SIGNAL tb_motor_yon_out       : STD_LOGIC;
    SIGNAL tb_motor_aktif_out     : STD_LOGIC;
    SIGNAL tb_kapi_kontrol_out    : STD_LOGIC_VECTOR(1 DOWNTO 0);

BEGIN
    -- Test edilecek üniteyi (DUT) ba?la
    uut: ENTITY work.asansor_top
    PORT MAP (
        clk                   => tb_clk,
        reset                 => tb_reset,
        kabin_istekleri_in    => tb_kabin_istekleri_in,
        dis_cagrilar_in       => tb_dis_cagrilar_in,
        mevcut_kat_in         => tb_mevcut_kat_in,
        kapi_kapali_sensor_in => tb_kapi_kapali_sensor_in,
        asiri_yuk_sensor_in   => tb_asiri_yuk_sensor_in,
        acil_durum_in         => tb_acil_durum_in,
        motor_yon_out         => tb_motor_yon_out,
        motor_aktif_out       => tb_motor_aktif_out,
        kapi_kontrol_out      => tb_kapi_kontrol_out,
        kat_gostergesi_out    => OPEN -- Testbench'te bu ç?k??? kullanm?yoruz
    );

    -- Clock sinyali üretimi
    tb_clk <= NOT tb_clk AFTER CLK_PERIOD / 2;
    
    -- Asansör hareketi simülasyonu
    PROCESS(tb_clk)
    BEGIN
        IF rising_edge(tb_clk) THEN
            IF tb_motor_aktif_out = '1' THEN
            END IF;
        END IF;
    END PROCESS;

    -- Test senaryolar?
    stimulus_proc: PROCESS
    BEGIN
        -- 1. Ba?latma ve Reset
        tb_reset <= '1';
        WAIT FOR 100 ns;
        tb_reset <= '0';
        WAIT FOR 100 ns;

        -- Senaryo 1: Zemin kattan 3. kata ça?r?
        REPORT "SENARYO 1: 1. kattan 3. kata cagri" SEVERITY NOTE;
        tb_kabin_istekleri_in <= "0100"; -- 3. kat butonu
        WAIT FOR CLK_PERIOD;
        tb_kabin_istekleri_in <= "0000";
        
        -- Kap?n?n kapanmas?n? bekle (Kap? "kapat" komutu "10")
        WAIT UNTIL tb_kapi_kontrol_out = "10";
        WAIT FOR 100 ns;
        tb_kapi_kapali_sensor_in <= '1'; -- Kap? kapand?
        
        -- Motorun çal??mas?n? bekle
        WAIT UNTIL tb_motor_aktif_out = '1';
        REPORT "Motor calisti, 3. kata gidiliyor." SEVERITY NOTE;
        
        -- Katlar? manuel olarak güncelle (simülasyon için)
        WAIT FOR 200 ns; -- Hemen 2. kata gelsin
        tb_mevcut_kat_in <= "0010"; 
        WAIT FOR 200 ns; -- Hemen 3. kata gelsin
        tb_mevcut_kat_in <= "0100";
        
        -- Hedefe ula??ld?, motorun durmas?n? ve kap?n?n aç?lmas?n? bekle
        WAIT UNTIL tb_motor_aktif_out = '0';
        REPORT "3. kata ulasildi. Motor durdu." SEVERITY NOTE;
        WAIT UNTIL tb_kapi_kontrol_out = "01";
        REPORT "Kapi aciliyor." SEVERITY NOTE;
        tb_kapi_kapali_sensor_in <= '0'; -- Kap? art?k kapal? de?il
        
        -- Kap?n?n 3 saniye aç?k kal?p kapanmas?n? bekle
        WAIT FOR 500 ns;
        
        -- Senaryo 2: A??r? yük testi
        REPORT "SENARYO 2: Asiri yuk testi" SEVERITY NOTE;
        tb_kabin_istekleri_in <= "1000"; -- 4. kata istek
        WAIT FOR CLK_PERIOD;
        tb_kabin_istekleri_in <= "0000";
        
        -- Kap?n?n kapanmas?n? bekle
        WAIT UNTIL tb_kapi_kontrol_out = "10";
        REPORT "Kapi kapaniyor, asiri yuk veriliyor." SEVERITY NOTE;
        tb_asiri_yuk_sensor_in <= '1';
        
        WAIT FOR 100 ns;
        -- FSM'in kap?y? tekrar açmas?n? ("01") kontrol et
        
        REPORT "Test tamamlandi." SEVERITY NOTE;
        WAIT;
    END PROCESS;

END ARCHITECTURE test;
