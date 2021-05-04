library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity led_driver is
    Port ( 
    en_i                 : in   std_logic;
    distance_i           : in   std_logic_vector(4 - 1 downto 0);
    
    leds_o               : out  std_logic_vector(10 - 1 downto 0)
    );
end led_driver;

architecture Behavioral of led_driver is

begin
    p_led_driver : process(distance_i, en_i)
    begin
        if (en_i = '1')then
            case distance_i is
                -- 0-10cm
                when "0000" =>
                    leds_o  <= "1111111111";
                -- 10-20cm
                when "0001" =>
                    leds_o  <= "1111111110";
                -- 20-30cm
                when "0010" =>
                    leds_o  <= "1111111100";
                -- 30-40cm
                when "0011" =>
                    leds_o  <= "1111111000";
                -- 40-50cm
                when "0100" =>
                    leds_o  <= "1111110000";
                -- 50-60cm
                when "0101" =>
                    leds_o  <= "1111100000";
                -- 60-70cm
                when "0110" =>
                    leds_o  <= "1111000000";
                -- 70-80cm
                when "0111" =>
                    leds_o  <= "1110000000";
                -- 80-90cm
                when "1000" =>
                    leds_o  <= "1100000000";
                -- >90cm
                when others =>
                    leds_o  <= "1000000000";
            end case;
        else
            leds_o  <= "0000000000";
        end if;
    end process p_led_driver;    
end Behavioral;