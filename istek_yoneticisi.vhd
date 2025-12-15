LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY istek_yoneticisi IS
    PORT (
        clk               : IN  STD_LOGIC;
        reset             : IN  STD_LOGIC;
        kabin_istekleri   : IN  STD_LOGIC_VECTOR(3 DOWNTO 0); -- ?ç butonlar [4,3,2,1]
        dis_cagrilar      : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); -- D?? butonlar [yukar?(4..1), a?a??(4..1)]
        istek_tamamlandi  : IN  STD_LOGIC; -- FSM hedef kata ula?t???nda bunu '1' yapar
        istek_var         : OUT STD_LOGIC; -- Kuyrukta bekleyen istek varsa '1'
        hedef_kat         : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END ENTITY istek_yoneticisi;

ARCHITECTURE Behavioral OF istek_yoneticisi IS
    -- 4 derinli?inde bir FCFS kuyru?u (FIFO)
    TYPE fifo_type IS ARRAY (0 TO 3) OF STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL fifo_queue   : fifo_type := (OTHERS => (OTHERS => '0'));
    SIGNAL write_ptr    : INTEGER RANGE 0 TO 3 := 0;
    SIGNAL read_ptr     : INTEGER RANGE 0 TO 3 := 0;
    SIGNAL fifo_count   : INTEGER RANGE 0 TO 4 := 0;
    
    SIGNAL yeni_istek_var   : STD_LOGIC;
    SIGNAL yeni_istek_kat   : STD_LOGIC_VECTOR(3 DOWNTO 0);
    
BEGIN
    PROCESS(kabin_istekleri, dis_cagrilar)
    BEGIN
        yeni_istek_var <= '0';
        yeni_istek_kat <= "0000";

        IF kabin_istekleri(0) = '1' THEN yeni_istek_kat <= "0001"; yeni_istek_var <= '1';
        ELSIF kabin_istekleri(1) = '1' THEN yeni_istek_kat <= "0010"; yeni_istek_var <= '1';
        ELSIF kabin_istekleri(2) = '1' THEN yeni_istek_kat <= "0100"; yeni_istek_var <= '1';
        ELSIF kabin_istekleri(3) = '1' THEN yeni_istek_kat <= "1000"; yeni_istek_var <= '1';

        ELSIF dis_cagrilar(0) = '1' OR dis_cagrilar(4) = '1' THEN yeni_istek_kat <= "0001"; yeni_istek_var <= '1';
        ELSIF dis_cagrilar(1) = '1' OR dis_cagrilar(5) = '1' THEN yeni_istek_kat <= "0010"; yeni_istek_var <= '1';
        ELSIF dis_cagrilar(2) = '1' OR dis_cagrilar(6) = '1' THEN yeni_istek_kat <= "0100"; yeni_istek_var <= '1';
        ELSIF dis_cagrilar(3) = '1' OR dis_cagrilar(7) = '1' THEN yeni_istek_kat <= "1000"; yeni_istek_var <= '1';
        END IF;
    END PROCESS;

    -- FIFO (kuyruk) yönetimi
    PROCESS(clk, reset)
    BEGIN
        IF (reset = '1') THEN
            fifo_queue <= (OTHERS => (OTHERS => '0'));
            write_ptr  <= 0;
            read_ptr   <= 0;
            fifo_count <= 0;
        ELSIF (rising_edge(clk)) THEN
            -- Kuyru?a yeni istek ekleme
            IF (yeni_istek_var = '1' AND fifo_count < 4) THEN
                fifo_queue(write_ptr) <= yeni_istek_kat;
                write_ptr <= (write_ptr + 1) MOD 4;
                fifo_count <= fifo_count + 1;
            END IF;
            
            -- Kuyruktan istek ç?karma (FSM i?ini bitirdi?inde)
            IF (istek_tamamlandi = '1' AND fifo_count > 0) THEN
                read_ptr <= (read_ptr + 1) MOD 4;
                fifo_count <= fifo_count - 1;
            END IF;
        END IF;
    END PROCESS;

    istek_var <= '1' WHEN fifo_count > 0 ELSE '0';
    hedef_kat <= fifo_queue(read_ptr);

END ARCHITECTURE Behavioral;
