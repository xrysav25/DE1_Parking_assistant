

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
   
    --s_ja(4) <= '1';
    --wait for 580 us; s_ja(4) <= '0';
        
        wait for 580 us; --10cm
        s_ja(4) <= '1';
        wait for 580 us;
        s_ja(4) <= '0';
        
        wait for 1160 us; --20cm
        s_ja(4) <= '1'; 
        wait for 1160 us; 
        s_ja(4) <= '0';
        
        wait for 3190 us; --55cm
        s_ja(4) <= '1'; 
        wait for 3190 us; 
        s_ja(4) <= '0';
        
        wait for 116 us; --2cm
        s_ja(4) <= '1'; 
        wait for 116 us; 
        s_ja(4) <= '0';
        
        wait for 5800 us; --100cm
        s_ja(4) <= '1'; 
        wait for 5800 us; 
        s_ja(4) <= '0';
       
        wait for 8700 us; --150cm
        s_ja(4) <= '1'; 
        wait for 8700 us; 
        s_ja(4) <= '0';
        
        wait for 3994 us; --68cm
        s_ja(4) <= '1'; 
        wait for 3994 us; 
        s_ja(4) <= '0';
        
        wait for 696 us; --12cm
        s_ja(4) <= '1'; 
        wait for 696 us; 
        s_ja(4) <= '0';
        
        wait for 5684 us; --98cm
        s_ja(4) <= '1'; 
        wait for 5684 us; 
        s_ja(4) <= '0';
        
        wait for 4582 us; --79cm
        s_ja(4) <= '1'; 
        wait for 4582 us; 
        s_ja(4) <= '0';
        
   
      
   
     wait;       
    end process p_stimulus;

end Behavioral;
