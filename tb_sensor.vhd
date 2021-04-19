----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.04.2021 22:24:38
-- Design Name: 
-- Module Name: tb_sensor - testbench
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

entity tb_sensor is
--  Port ( );
end tb_sensor;

architecture testbench of tb_sensor is
    constant c_CLK_100MHZ_PERIOD : time    := 10 ns;
    
    signal s_clk : std_logic;
    signal s_en : std_logic;
    signal s_sens_i : natural;
    signal s_sens_o : std_logic;
    signal s_levels : std_logic_vector(4 - 1 downto 0);
    
begin
    uut_sensor : entity work.sensor
    port map(
            CLK100MHZ   => s_clk,
            en_i => s_en,
            sens_i  => s_sens_i,
            sens_o => s_sens_o,
            levels_o => s_levels
        );

    p_clk_gen : process
    begin
        while now < 2000000000 ns loop         -- 75 periods of 100MHz clock
            s_clk <= '0';
            wait for c_CLK_100MHZ_PERIOD / 2;
            s_clk <= '1';
            wait for c_CLK_100MHZ_PERIOD / 2;
        end loop;
        wait;                           -- Process is suspended forever
    end process p_clk_gen;
    
    p_en : process
    begin
        s_en <= '1'; wait for 1100 ms;
        s_en <= '0'; wait;
    end process p_en;
    
    p_logic : process
    begin
        wait until (s_sens_o = '1');
        s_sens_i <= 10;
        wait until (s_sens_o = '1');
        s_sens_i <= 58;
        wait until (s_sens_o = '1');
        s_sens_i <= 2;
        wait until (s_sens_o = '1');
        s_sens_i <= 150;
        wait until (s_sens_o = '1');
        s_sens_i <= 45;
        wait until (s_sens_o = '1');
        s_sens_i <= 31;
    end process p_logic;
end testbench;
