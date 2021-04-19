----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.04.2021 20:55:10
-- Design Name: 
-- Module Name: sensor_driver - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sensor_driver is
    Port ( CLK100MHZ : in STD_LOGIC;
           puls : in STD_LOGIC;
           echo : in STD_LOGIC;
           triger : out STD_LOGIC;
           time_o : out natural);
end sensor_driver;

architecture Behavioral of sensor_driver is
    signal s_cnt_local : natural;
    signal s_time : natural;
    signal local_reset : std_logic;
    signal s_time_o : natural;
begin
    sensor_puls: process (CLK100MHZ, puls)
    begin
              
        if rising_edge(CLK100MHZ) then        -- Synchronous process
            if (puls = '1') then
                local_reset <= '1';
            end if;  
            if (local_reset = '1') then       -- High active reset
                s_cnt_local <= 0;       -- Clear local counter
                triger      <= '1';     -- Genetate puls
                local_reset <= '0';       -- finish event
            elsif (s_cnt_local >= (1000 - 1)) then   --1000 clk = 10us
                --s_cnt_local <= 0;       -- Clear local counter
                triger      <= '0';     -- end pulse
            else
                s_cnt_local <= s_cnt_local + 1;
                --triger        <= '1';
            end if;
        end if;
        
    end process sensor_puls;
    
    echo_count: process (CLK100MHZ, echo)
    begin
        if rising_edge(CLK100MHZ) then        -- Synchronous process

            if (puls = '1') then       -- High active reset
                s_time <= 0;       -- Clear local counter
                s_time_o <= 1;
                time_o <= s_time_o;
            -- Test number of clock periods
            elsif (echo = '1') then
                time_o <= s_time_o;
            elsif (s_time >= 5800-1) then
                s_time_o <= s_time_o + 1;
                --time_o <= s_time_o;
                s_time <= 0; 
            else 
                s_time <= s_time + 1;
            end if;
        end if;
        
    end process echo_count;
end Behavioral;
