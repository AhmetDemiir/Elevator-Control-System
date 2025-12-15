LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY asansor_kontrol_fsm IS
    PORT (
        clk               : IN  STD_LOGIC;
        reset             : IN  STD_LOGIC;
        istek_var         : IN  STD_LOGIC;
        hedef_kat         : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
        mevcut_kat        : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
        kapi_kapali_sensor: IN  STD_LOGIC;
        asiri_yuk_sensor  : IN  STD_LOGIC;
        acil_durum        : IN  STD_LOGIC;
        zamanlayici_bitti : IN  STD_LOGIC;
        
        motor_yon         : OUT STD_LOGIC;
        motor_aktif       : OUT STD_LOGIC;
        kapi_kontrol      : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        zamanlayici_baslat: OUT STD_LOGIC;
        istek_tamamlandi  : OUT STD_LOGIC
    );
END ENTITY asansor_kontrol_fsm;

ARCHITECTURE Behavioral OF asansor_kontrol_fsm IS
    TYPE state_type IS (S_IDLE, S_KAPI_KAPAT, S_YUKARI_CIK, S_ASAGI_IN, S_KATTA_DUR, S_KAPI_AC, S_ACIL_DURUM);
    SIGNAL current_state, next_state : state_type;
BEGIN
    -- 1. PROCESS: Durum Güncelleme (Sequential)
    seq_process: PROCESS(clk, reset)
    BEGIN
        IF (reset = '1') THEN
            current_state <= S_IDLE;
        ELSIF (rising_edge(clk)) THEN
            current_state <= next_state;
        END IF;
    END PROCESS;
    
    -- 2. PROCESS: Mant?k (Combinational)
    comb_process: PROCESS(current_state, istek_var, hedef_kat, mevcut_kat, kapi_kapali_sensor, asiri_yuk_sensor, acil_durum, zamanlayici_bitti)
    BEGIN
        motor_yon          <= '0';
        motor_aktif        <= '0';
        kapi_kontrol       <= "00"; 
        zamanlayici_baslat <= '0';
        istek_tamamlandi   <= '0';
        next_state         <= current_state;

        CASE current_state IS
            WHEN S_IDLE =>
                IF (istek_var = '1') THEN
                    IF (hedef_kat = mevcut_kat) THEN
                        next_state <= S_KAPI_AC;
                    ELSE
                        next_state <= S_KAPI_KAPAT;
                    END IF;
                ELSE
                    next_state <= S_IDLE;
                END IF;
            
            WHEN S_KAPI_KAPAT =>
                kapi_kontrol <= "10"; -- Kap? Kapat Komutu
                
                IF (asiri_yuk_sensor = '1') THEN
                    next_state <= S_KAPI_AC;
                ELSIF (kapi_kapali_sensor = '1') THEN
                    IF (unsigned(hedef_kat) > unsigned(mevcut_kat)) THEN
                        next_state <= S_YUKARI_CIK;
                    ELSIF (unsigned(hedef_kat) < unsigned(mevcut_kat)) THEN
                        next_state <= S_ASAGI_IN;
                    ELSE
                        next_state <= S_KATTA_DUR;
                    END IF;
                ELSE
                    next_state <= S_KAPI_KAPAT;
                END IF;

            WHEN S_YUKARI_CIK =>
                motor_yon   <= '1'; -- Yukar?
                motor_aktif <= '1';
                IF (mevcut_kat = hedef_kat) THEN
                    next_state <= S_KATTA_DUR;
                ELSE
                    next_state <= S_YUKARI_CIK;
                END IF;
                
            WHEN S_ASAGI_IN =>
                motor_yon   <= '0'; -- A?a??
                motor_aktif <= '1';
                IF (mevcut_kat = hedef_kat) THEN
                    next_state <= S_KATTA_DUR;
                ELSE
                    next_state <= S_ASAGI_IN;
                END IF;
                
            WHEN S_KATTA_DUR =>
                motor_aktif      <= '0';
                istek_tamamlandi <= '1'; -- ?ste?i kuyruktan sildir
                next_state       <= S_KAPI_AC;
                
            WHEN S_KAPI_AC =>
                kapi_kontrol <= "01"; -- Kap? Aç
                zamanlayici_baslat <= '1';
                
                IF (zamanlayici_bitti = '1') THEN
                    IF (istek_var = '1') THEN
                        next_state <= S_KAPI_KAPAT;
                    ELSE
                        next_state <= S_IDLE;
                    END IF;
                ELSE
                    next_state <= S_KAPI_AC;
                END IF;
                
            WHEN S_ACIL_DURUM =>
                motor_aktif <= '0';
                IF (acil_durum = '0') THEN -- Acil durum butonu b?rak?l?rsa
                     next_state <= S_IDLE;
                ELSE
                     next_state <= S_ACIL_DURUM;
                END IF;
                
            WHEN OTHERS =>
                next_state <= S_IDLE;
        
        END CASE;
        
        -- Acil durum her an araya girebilir
        IF (acil_durum = '1') THEN
            next_state <= S_ACIL_DURUM;
        END IF;

    END PROCESS comb_process;
    
END ARCHITECTURE Behavioral;
