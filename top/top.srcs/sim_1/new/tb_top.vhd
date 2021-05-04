library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_top is
    
end tb_top;

architecture Behavioral of tb_top is
       constant c_CLK100MHZ : time    := 10 ns;
       
       signal s_clk :  STD_LOGIC;
       signal s_sw  : std_logic_vector(1-1 downto 0);
       signal s_ja  : std_logic_vector(8-1 downto 0);
       signal s_jb  : std_logic_vector(8-1 downto 0); 
       signal s_jc  : std_logic_vector(8-1 downto 0); 
       signal s_jd  : std_logic_vector(8-1 downto 0); 


begin
    uut_top : entity work.top
        port map(
            CLK100MHZ    => s_clk,
            sw           => s_sw,
            ja           => s_ja,
            jb           => s_jb, 
            jc           => s_jc,
            jd           => s_jd 
             
         );
    
    p_clk_gen : process
    begin
        while now < 10000 ms loop         -- 75 periods of 100MHz clock
            s_clk <= '0';
            wait for c_CLK100MHZ / 2;
            s_clk <= '1';
            wait for c_CLK100MHZ / 2;
        end loop;
        wait;                           -- Process is suspended forever
    end process p_clk_gen;
    
    
    
    
    
    
    
    p_stimulus : process
    begin
    s_sw(0) <= '1';
   
    
      
   
     wait;       
    end process p_stimulus;

end Behavioral;