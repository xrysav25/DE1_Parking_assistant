library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_led_driver is

end tb_led_driver;

architecture Behavioral of tb_led_driver is

    -- Local signals
    signal s_en             : std_logic;
    signal s_distance       : std_logic_vector(4 - 1 downto 0);
    
    signal s_leds           : std_logic_vector(10 - 1 downto 0);
    
begin
    
    uut_led_driver : entity work.led_driver
        port map(
            en_i          => s_en,
            distance_i    => s_distance,
            
            leds_o        => s_leds
        );

    p_stimulus : process
    begin
        -- Report a note at the begining of stimulus process
        report "Stimulus process started" severity note;
        s_en       <= '1';
        -- <90cm
        s_distance <= "1001";
        wait for 100ns;
        -- 80-90cm
        s_distance <= "1000";
        wait for 100ns;
        -- 70-80cm
        s_distance <= "0111";
        wait for 100ns;
        -- 60-70cm
        s_distance <= "0110";
        wait for 100ns;
        -- 50-60cm
        s_distance <= "0101";
        wait for 100ns;
        -- 40-50cm
        s_distance <= "0100";
        wait for 100ns;
        -- 30-40cm
        s_distance <= "0011";
        wait for 100ns;
        -- 20-30cm
        s_distance <= "0010";
        wait for 100ns;
        -- 10-20cm
        s_distance <= "0001";
        wait for 100ns;
        -- 0-10cm
        s_distance <= "0000";
        wait for 100ns;
        -- Enable OFF
        s_en       <= '0';
        -- <90cm
        s_distance <= "1001";
        wait for 100ns;
        -- 80-90cm
        s_distance <= "1000";
        wait for 100ns;
        -- 70-80cm
        s_distance <= "0111";
        wait for 100ns;
        -- Report a note at the end of stimulus process
        report "Stimulus process finished" severity note;
        wait;
    end process p_stimulus;
end Behavioral;