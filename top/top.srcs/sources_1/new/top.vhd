library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity top is
    Port (CLK100MHZ : in STD_LOGIC;                 -- clock signal
          sw : in       std_logic_vector(1-1 downto 0);   -- enable switch 
--          ja : inout    std_logic_vector(8-1 downto 0);    -- input and output of sensor
          ja0 : out    std_logic;
          ja4 : in    std_logic;
          jb : out      std_logic_vector(8-1 downto 0);    -- output to LED bargraph
          jc : out      std_logic_vector(8-1 downto 0);    -- output to LED bargraph
          jd : out      std_logic_vector(8-1 downto 0)     -- output to piezzo buzzer
    );
end top;

architecture Behavioral of top is
        signal s_puls : std_logic;                            -- internal signal from sensor logic to sensor driver
        signal s_counttim : natural;                          -- internal signal from sensor driver to sensor logic 
        signal s_logiclvl : std_logic_vector(4 - 1 downto 0); -- internal signal representing distance of object 
        
    
begin
    --------------------------------------------------------------------
    -- Instance (copy) of sensor entity
    sens_logic : entity work.sensor
        port map(
           CLK100MHZ => CLK100MHZ,  -- clock signal
           en_i      => sw(0),      -- enable switch
           
           sens_i    => s_counttim, -- input  from sensor driver
           sens_o    => s_puls,     -- output to   sensor driver
           
           levels_o  => s_logiclvl  -- distance output for signalization
        );        

    --------------------------------------------------------------------
    -- Instance (copy) of sensor_driver entity
    sens_driver : entity work.sensor_driver
        port map(
           CLK100MHZ => CLK100MHZ, --clock signal
           
           puls      => s_puls,    -- input  from sensor logic   
           time_o    => s_counttim,-- outout to   sensor logic
           
           triger    => ja0,     -- output  to   sensor
           echo      => ja4      -- input   from sensor              
        );     

--        ja(1) <= '0'; --disable ja pins 2,3,4,8,9,10 
--        ja(2) <= '0';
--        ja(3) <= '0';
--        ja(5) <= '0';
--        ja(6) <= '0';
--        ja(7) <= '0';

--        ja(4) <= 'Z';  --set ja4 to input?
    --------------------------------------------------------------------
    -- Instance (copy) of led_driver entity
    led_driver : entity work.led_driver
        port map(
           en_i         =>  sw(0),      --enable switch     
           distance_i   =>  s_logiclvl, --distance from sensor    
           leds_o(9)    =>  jb(4),  --led 1  pin jb7    J17   -far object only 1 led is active 
           leds_o(8)    =>  jb(0),  --led 2  pin jb1    E15
           leds_o(7)    =>  jb(5),  --led 3  pin jb8    J18
           leds_o(6)    =>  jb(1),  --led 4  pin jb2    E16
           leds_o(5)    =>  jb(6),  --led 5  pin jb9    K15
           leds_o(4)    =>  jb(2),  --led 6  pin jb3    D15
           leds_o(3)    =>  jb(7),  --led 7  pin jb10   J15
           leds_o(2)    =>  jb(3),  --led 8  pin jb4    C15
           leds_o(1)    =>  jc(4),  --led 9  pin jc7    U14
           leds_o(0)    =>  jc(0)   --led 10 pin jc1    U12   -close object all leds are active  
        );     
        
        jc(1) <= '0'; --disable jc pins 2,3,4,8,9,10 
        jc(2) <= '0';
        jc(3) <= '0';
        jc(5) <= '0';
        jc(6) <= '0';
        jc(7) <= '0';
     
     
    --------------------------------------------------------------------
    -- Instance (copy) of piezzo_driver entity
    piez_driver : entity work.piezzo_driver
        port map(
            CLK100MHZ  => CLK100MHZ,     -- still wip
            en_i       => sw(0),        -- enable switch
            distance_i => s_logiclvl,   -- distance from sensor           
            piezzo_o   => jd(0)         -- output to piezzo buzzer
        );     
     
        jd(1) <= '0'; --disable jc pins 2,3,4,7,8,9,10 
        jd(2) <= '0';
        jd(3) <= '0';
        jd(4) <= '0';
        jd(5) <= '0';
        jd(6) <= '0';
        jd(7) <= '0';
     
        

end Behavioral;