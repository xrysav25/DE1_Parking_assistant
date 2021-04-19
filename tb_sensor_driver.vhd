----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.04.2021 22:24:38
-- Design Name: 
-- Module Name: tb_sensor_driver - testbench
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
use ieee.math_real.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_sensor_driver is
--  Port ( );
end tb_sensor_driver;

architecture testbench of tb_sensor_driver is
    constant c_CLK_100MHZ_PERIOD : time    := 10 ns;
    
    --Local signals
    signal s_clk : std_logic;
    signal s_puls : std_logic;
    signal s_echo : std_logic;
    signal s_triger : std_logic;
    signal s_time_o : natural;
   
    
begin
    uut_sensor_driver : entity work.sensor_driver
    port map(
            CLK100MHZ   => s_clk,
            puls => s_puls,
            echo  => s_echo,
            triger => s_triger,
            time_o => s_time_o
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
    
    p_puls : process
    begin
        s_puls <= '1'; wait for 50 ns;
        s_puls <= '0'; wait for (500 ms - 50 ns);
        s_puls <= '1'; wait for 50 ns;
        s_puls <= '0'; wait for (500 ms - 50 ns);
        s_puls <= '1'; wait for 50 ns;
        s_puls <= '0'; wait for (500 ms - 50 ns);
        s_puls <= '1'; wait for 50 ns;
        s_puls <= '0'; wait for (500 ms - 50 ns);
--        s_puls <= '1'; wait for 10 ns;
--        s_puls <= '0'; wait for (500 ms - 10 ns);
--        s_puls <= '1'; wait for 10 ns;
--        s_puls <= '0'; wait for (500 ms - 10 ns);
--        s_puls <= '1'; wait for 10 ns;
--        s_puls <= '0'; wait for (500 ms - 10 ns);
--        s_puls <= '1'; wait for 10 ns;
--        s_puls <= '0'; wait for (500 ms - 10 ns);
--        s_puls <= '1'; wait for 10 ns;
--        s_puls <= '0'; wait for (500 ms - 10 ns);
--        s_puls <= '1'; wait for 10 ns;
--        s_puls <= '0'; wait for (500 ms - 10 ns);
        wait;
    end process p_puls;
    
    p_echo : process
    variable seed1, seed2: positive;               -- seed values for random generator
    variable rand: real;   -- random real-number value in range 0 to 1.0  
    variable range_of_rand : real := 600000.0;    -- the range of random values created will be 0 to +1000.
    begin
        wait until (s_puls = '1');
        wait for 580 us; --10cm
        s_echo <= '1'; wait for 10us; s_echo <= '0';
        wait until (s_puls = '1');
        wait for 1160 us; --20cm
        s_echo <= '1'; wait for 10us; s_echo <= '0';
        wait until (s_puls = '1');
        wait for 3190 us; --55cm
        s_echo <= '1'; wait for 10us; s_echo <= '0';
        wait until (s_puls = '1');
        wait for 116 us; --2cm
        s_echo <= '1'; wait for 10us; s_echo <= '0';
        wait until (s_puls = '1');
        wait for 5800 us; --100cm
        s_echo <= '1'; wait for 10us; s_echo <= '0';
        wait until (s_puls = '1');
        wait for 8700 us; --150cm
        s_echo <= '1'; wait for 10us; s_echo <= '0';
        wait until (s_puls = '1');
        wait for 3994 us; --68cm
        s_echo <= '1'; wait for 10us; s_echo <= '0';
        wait until (s_puls = '1');
        wait for 696 us; --12cm
        s_echo <= '1'; wait for 10us; s_echo <= '0';
        wait until (s_puls = '1');
        wait for 5684 us; --98cm
        s_echo <= '1'; wait for 10us; s_echo <= '0';
        wait until (s_puls = '1');
        wait for 4582 us; --79cm
        s_echo <= '1'; wait for 10us; s_echo <= '0';
        
        wait;
    end process p_echo;
end testbench;
