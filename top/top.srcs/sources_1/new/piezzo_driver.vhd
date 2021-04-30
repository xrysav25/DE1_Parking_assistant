library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity piezzo_driver is
    Port ( 
    CLK100HZ             : in   std_logic;
    en_i                 : in   std_logic;
    distance_i           : in   std_logic_vector(4 - 1 downto 0);
    
    piezzo_o             : out  std_logic
    );
end piezzo_driver;

architecture Behavioral of piezzo_driver is

signal s_counter        : natural :=0;
signal s_counter_clk100 : natural;
signal clk100           : std_logic;
signal s_piezzo         : std_logic;

begin
    p_clk100: process (CLK100HZ)
    begin
        if rising_edge(CLK100HZ) then
            if (s_counter_clk100 >= 10) then
                s_counter_clk100 <=  0;
                clk100           <= '1';
            else
                s_counter_clk100 <= s_counter_clk100 + 1;
                clk100           <= '0';
            end if;
        end if;
    end process p_clk100;
    
    p_piezzo_driver : process(clk100)
    begin
            if (en_i = '1')then
                case distance_i is
                    -- 0-10cm
                    when "0000" =>
                        piezzo_o <= '1';
                    -- 10-20cm
                    when "0001" =>
                    if rising_edge(clk100)then
                        if (s_counter >= 1) then
                            s_counter <= 0;       
                            piezzo_o  <= '1'; 
                        else
                            s_counter <= s_counter + 1;
                            piezzo_o  <= '0';
                        end if;
                    end if;
                    -- 20-30cm
                    when "0010" =>
                    if rising_edge(clk100)then
                        if (s_counter >= 2) then
                            s_counter <= 0;       
                            piezzo_o  <= '1'; 
                        else
                            s_counter <= s_counter + 1;
                            piezzo_o  <= '0';
                        end if;
                    end if;
                    -- 30-40cm
                    when "0011" =>
                    if rising_edge(clk100)then
                        if (s_counter >= 3) then
                            s_counter <= 0;       
                            piezzo_o  <= '1'; 
                        else
                            s_counter <= s_counter + 1;
                            piezzo_o  <= '0';
                        end if;
                    end if;
                    -- 40-50cm
                    when "0100" =>
                    if rising_edge(clk100)then
                        if (s_counter >= 4) then
                            s_counter <= 0;       
                            piezzo_o  <= '1'; 
                        else
                            s_counter <= s_counter + 1;
                            piezzo_o  <= '0';
                        end if;
                    end if;
                    -- 50-60cm
                    when "0101" =>
                    if rising_edge(clk100)then
                        if (s_counter >= 5) then
                            s_counter <= 0;       
                            piezzo_o  <= '1'; 
                        else
                            s_counter <= s_counter + 1;
                            piezzo_o  <= '0';
                        end if;
                    end if;
                    -- 60-70cm
                    when "0110" =>
                    if rising_edge(clk100)then
                        if (s_counter >= 6) then
                            s_counter <= 0;       
                            piezzo_o  <= '1'; 
                        else
                            s_counter <= s_counter + 1;
                            piezzo_o  <= '0';
                        end if;
                    end if;
                    -- 70-80cm
                    when "0111" =>
                    if rising_edge(clk100)then
                        if (s_counter >= 7) then
                            s_counter <= 0;       
                            piezzo_o  <= '1'; 
                        else
                            s_counter <= s_counter + 1;
                            piezzo_o  <= '0';
                        end if;
                    end if;
                    -- 80-90cm
                    when "1000" =>
                    if rising_edge(clk100)then
                        if (s_counter >= 8) then
                            s_counter <= 0;       
                            piezzo_o  <= '1'; 
                        else
                            s_counter <= s_counter + 1;
                            piezzo_o  <= '0';
                        end if;
                    end if;
                    -- >90cm
                    when others =>
                        piezzo_o <= '0';
                end case;
            else
                piezzo_o <= '0';
            end if;
    end process p_piezzo_driver;    
end Behavioral;