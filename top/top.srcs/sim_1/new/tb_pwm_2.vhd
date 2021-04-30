library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_pwm_2 is

end tb_pwm_2;

architecture Behavioral of tb_pwm_2 is
    constant clk_period     : time :=10ms;
    -- Local signals
    signal s_clk100         : std_logic;
    signal s_en             : std_logic;
    signal s_distance       : std_logic_vector(4 - 1 downto 0);
    
    signal s_pwm            : std_logic;
    
begin
    
    uut_piezzo_driver : entity work.piezzo_driver
        port map(
            CLK100HZ      => s_clk100,
            en_i          => s_en,
            distance_i    => s_distance,
            
            piezzo_o      => s_pwm
        );
    p_clk_gen100 : process
    begin
        while now < 46000 ms loop         
            s_clk100 <= '0';
            wait for clk_period / 2;
            s_clk100 <= '1';
            wait for clk_period / 2;
        end loop;
        wait;
    end process p_clk_gen100;
    p_stimulus : process
    begin
        -- Report a note at the begining of stimulus process
        report "Stimulus process started" severity note;
        s_en       <= '1';
        -- <90cm
        s_distance <= "1001";
        wait for 2000ms;
        -- 80-90cm
        s_distance <= "1000";
        wait for 2000ms;
        -- 70-80cm
        s_distance <= "0111";
        wait for 2000ms;
        -- 60-70cm
        s_distance <= "0110";
        wait for 2000ms;
        -- 50-60cm
        s_distance <= "0101";
        wait for 2000ms;
        -- 40-50cm
        s_distance <= "0100";
        wait for 2000ms;
        -- 30-40cm
        s_distance <= "0011";
        wait for 2000ms;
        -- 20-30cm
        s_distance <= "0010";
        wait for 2000ms;
        -- 10-20cm
        s_distance <= "0001";
        wait for 2000ms;
        -- 0-10cm
        s_distance <= "0000";
        wait for 2000ms;
        -- 10-20cm
        s_distance <= "0001";
        wait for 2000ms;
        -- 20-30cm
        s_distance <= "0010";
        wait for 2000ms;
        -- 30-40cm
        s_distance <= "0011";
        wait for 2000ms;
        -- 40-50cm
        s_distance <= "0100";
        wait for 2000ms;
        -- 50-60cm
        s_distance <= "0101";
        wait for 2000ms;
        -- 60-70cm
        s_distance <= "0110";
        wait for 2000ms;
        -- 70-80cm
        s_distance <= "0111";
        wait for 2000ms;
        -- 80-90cm
        s_distance <= "1000";
        wait for 2000ms;
        -- >90cm
        s_distance <= "1001";
        wait for 2000ms;
        s_en       <= '0';
        -- <90cm
        s_distance <= "1000";
        wait for 2000ms;
        -- 80-90cm
        s_distance <= "0111";
        wait for 2000ms;
        -- 70-80cm
        s_distance <= "0110";
        -- Report a note at the end of stimulus process
        report "Stimulus process finished" severity note;
        wait;
    end process p_stimulus;
end Behavioral;