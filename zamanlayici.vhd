LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY zamanlayici IS
    GENERIC (
        COUNTER_WIDTH : INTEGER := 28 -- 50MHz saat ile ~5 saniye sayabilir
    );
    PORT (
        clk         : IN  STD_LOGIC;
        reset       : IN  STD_LOGIC;
        start       : IN  STD_LOGIC;
        sayim_hedefi: IN  UNSIGNED(COUNTER_WIDTH-1 DOWNTO 0); 
        bitti       : OUT STD_LOGIC
    );
END ENTITY zamanlayici;

ARCHITECTURE Behavioral OF zamanlayici IS
    SIGNAL sayac_degeri : UNSIGNED(COUNTER_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL calisiyor    : STD_LOGIC := '0';
BEGIN

    PROCESS(clk, reset)
    BEGIN
        IF (reset = '1') THEN
            sayac_degeri <= (OTHERS => '0');
            calisiyor    <= '0';
            bitti        <= '0';
        ELSIF (rising_edge(clk)) THEN
            bitti <= '0';

            IF (start = '1' AND calisiyor = '0') THEN
                calisiyor <= '1';
                sayac_degeri <= (OTHERS => '0');
            ELSIF (calisiyor = '1') THEN
                IF (sayac_degeri < sayim_hedefi) THEN
                    sayac_degeri <= sayac_degeri + 1;
                ELSE
                    bitti     <= '1';
                    calisiyor <= '0';
                END IF;
            END IF;
        END IF;
    END PROCESS;

END ARCHITECTURE Behavioral;
