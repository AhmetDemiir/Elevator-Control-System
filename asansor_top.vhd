LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY asansor_top IS
    PORT (
        clk                 : IN  STD_LOGIC;
        reset               : IN  STD_LOGIC;
        
        -- G?R??LER
        kabin_istekleri_in  : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
        dis_cagrilar_in     : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); -- D?? butonlar [yukar?(4..1), a?a??(4..1)]
        mevcut_kat_in       : IN  STD_LOGIC_VECTOR(3 DOWNTO 0); -- "0001", "0010", "0100", "1000"
        kapi_kapali_sensor_in: IN  STD_LOGIC;
        asiri_yuk_sensor_in : IN  STD_LOGIC;
        acil_durum_in       : IN  STD_LOGIC;

        -- ÇIKI?LAR
        motor_yon_out       : OUT STD_LOGIC;
        motor_aktif_out     : OUT STD_LOGIC;
        kapi_kontrol_out    : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        kat_gostergesi_out  : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END ENTITY asansor_top;

ARCHITECTURE Structural OF asansor_top IS
    -- Zamanlama Sabitleri (50MHz saat için)
    CONSTANT KAPI_ACIK_SURESI : UNSIGNED(27 DOWNTO 0) := to_unsigned(20, 28);
    CONSTANT KAPI_ACMA_KAPAMA_SURESI : UNSIGNED(27 DOWNTO 0) := to_unsigned(20, 28);

    -- Modüller aras? sinyaller
    SIGNAL s_istek_var          : STD_LOGIC;
    SIGNAL s_hedef_kat          : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL s_zamanlayici_bitti  : STD_LOGIC;
    SIGNAL s_zamanlayici_baslat : STD_LOGIC;
    SIGNAL s_istek_tamamlandi   : STD_LOGIC;
    
BEGIN
    
    -- ?stek Yöneticisi modülünü ba?la
    istek_yoneticisi_inst : ENTITY work.istek_yoneticisi
    PORT MAP (
        clk               => clk,
        reset             => reset,
        kabin_istekleri   => kabin_istekleri_in,
        dis_cagrilar      => dis_cagrilar_in,
        istek_tamamlandi  => s_istek_tamamlandi,
        istek_var         => s_istek_var,
        hedef_kat         => s_hedef_kat
    );
    
    -- Ana FSM modülünü ba?la
    fsm_inst : ENTITY work.asansor_kontrol_fsm
    PORT MAP (
        clk                => clk,
        reset              => reset,
        istek_var          => s_istek_var,
        hedef_kat          => s_hedef_kat,
        mevcut_kat         => mevcut_kat_in,
        kapi_kapali_sensor => kapi_kapali_sensor_in,
        asiri_yuk_sensor   => asiri_yuk_sensor_in,
        acil_durum         => acil_durum_in,
        zamanlayici_bitti  => s_zamanlayici_bitti,
        motor_yon          => motor_yon_out,
        motor_aktif        => motor_aktif_out,
        kapi_kontrol       => kapi_kontrol_out,
        zamanlayici_baslat => s_zamanlayici_baslat,
        istek_tamamlandi   => s_istek_tamamlandi
    );

    -- Zamanlay?c? modülünü ba?la
    zamanlayici_inst : ENTITY work.zamanlayici
    GENERIC MAP (
        COUNTER_WIDTH => 28
    )
    PORT MAP (
        clk          => clk,
        reset        => reset,
        start        => s_zamanlayici_baslat,
        sayim_hedefi => KAPI_ACIK_SURESI,
        bitti        => s_zamanlayici_bitti
    );
    
    -- Kat göstergesini direkt mevcut kata ba?la
    kat_gostergesi_out <= mevcut_kat_in;
    
END ARCHITECTURE Structural;
