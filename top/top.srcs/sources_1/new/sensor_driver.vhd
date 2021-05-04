library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

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
        --creating 10us puls for sensor      
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
        

        if rising_edge(echo) then       -- High active reset
            s_time <= 0;       -- Clear local counter
            s_time_o <= 0;
            time_o <= 0;
        -- Test number of clock periods
        elsif falling_edge(echo) then
            time_o <= s_time_o;
        end if;
        
        if rising_edge(CLK100MHZ) then        -- Synchronous process
            if (s_time >= 5800-1) then
                s_time_o <= s_time_o + 1;
                --time_o <= s_time_o;
                s_time <= 0; 
            else 
                s_time <= s_time + 1;
            end if;
        end if;
    end process echo_count;
end Behavioral;