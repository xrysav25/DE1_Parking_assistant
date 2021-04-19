----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.04.2021 23:40:47
-- Design Name: 
-- Module Name: sensor - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sensor is
    Port ( CLK100MHZ : in STD_LOGIC;
           en_i : in STD_LOGIC;
           sens_i : in natural;
           sens_o : out STD_LOGIC;
           levels_o : out std_logic_vector(4 - 1 downto 0));
end sensor;

architecture Behavioral of sensor is
    signal clk : std_logic;
    signal s_cnt_local : natural;
begin
    
    --Creating freqency for distanc measuring
    --clk rising edge 0.5s
    p_clk: process (CLK100MHZ)
    begin
        if rising_edge(CLK100MHZ) then        -- Synchronous process
            if (s_cnt_local >= (50000000 - 1)) then
                s_cnt_local <= 0;       -- Clear local counter
                clk        <= '1';     -- Generate clock enable pulse

            else
                s_cnt_local <= s_cnt_local + 1;
                clk        <= '0';
            end if;
        end if;
    end process p_clk;
    
    --Clutch implementation. Sensor works only with activated clutch - en_i=1
    p_eneable: process (clk, en_i)
    begin
        if (en_i = '1') then
            if rising_edge(clk) then
                sens_o <= '1'; --pulz
            elsif falling_edge(clk) then
                sens_o <= '0';
            end if;
        end if;    
    end process p_eneable;
    
    --clasification of levels for other components.
    --parking assistant detect 10 levels of 10cm
    p_logic: process (sens_i)
    begin
        if (sens_i < 2) then
            report "Too close!";
        elsif ((sens_i) <= 10) then
            levels_o <= "0000";
        elsif ((sens_i) <= 20) then
            levels_o <= "0001";
        elsif ((sens_i) <= 30) then
            levels_o <= "0010";
        elsif ((sens_i) <= 40) then
            levels_o <= "0011";
        elsif ((sens_i) <= 50) then
            levels_o <= "0100";
        elsif ((sens_i) <= 60) then
            levels_o <= "0101";
        elsif ((sens_i) <= 70) then
            levels_o <= "0110";
        elsif ((sens_i) <= 80) then
            levels_o <= "0111";
        elsif ((sens_i) <= 90) then
            levels_o <= "1000";
        elsif ((sens_i) <= 100) then
            levels_o <= "1001";
        else
            report "Too far";    
        end if;
    end process p_logic;

end Behavioral;
