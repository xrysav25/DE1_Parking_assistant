# DE1_Parking_assistant

### Team members

Šimon Roubal, Michaela Ryšavá, Ondřej Ryšavý, Tomáš Rotrekl

[Link to GitHub project folder](https://github.com/xrysav25/DE1_Parking_assistant)

### Project objectives

Write your text here.


## Hardware description

### LED bargaph module

For LED visualization we have chosem bargraph with 10 LEDs and segments with diferent colors, as can be seen below.
|![bargaph](https://github.com/Simon-Roubal/DE1_Parking_assistant/blob/main/Images/Bargaph%20example.png)|
|:--:| 
|*Example of used bargraph[1]*|

Its first segment is blue which will represent ON/OFF state indication. Other segments represent actual distance ranging from green to red. For the actual bargraph we have designed small module board, that will conect to Arty board through 2 Pmod connectors.

|![model of board](https://github.com/Simon-Roubal/DE1_Parking_assistant/blob/main/Images/Module%20model.png)|
|:--:| 
|*Model of designed board*|

Board is fitted with bargraph itself, liminig resistors and 2 pinheader blocks. Board was designed in Autodesk EAGLE.

|![board LEDs](https://github.com/Simon-Roubal/DE1_Parking_assistant/blob/main/Images/Module%20board.png)|
|:--:| 
|*Board design*|
|![schematic LEDs](https://github.com/Simon-Roubal/DE1_Parking_assistant/blob/main/Images/Module%20schematic.png)|
|*Board schematic*|
## VHDL modules description and simulations

### LED bargaph module
LED module takes 2 inputs and has 1 output. One of the inputs is enable signal, which determines if module can function or not. Second input is distance level represented by 4-bit std logic vecotr. Output is 10-bit std logic vector for bargraph itself.
Architecture is represented by by single ```p_led_driver``` combiational process with both inputs in its sensitivity list. First it checks, if enable signal is ON or OFF. If enable is OFF, it will switch off all the LEDs and if it is ON it will continue to determine value of distance level and will light up the LEDs accordingly.
#### Code for module
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity led_driver is
    Port ( 
    en_i                 : in   std_logic;
    distance_i           : in   std_logic_vector(4 - 1 downto 0);
    
    leds_o               : out  std_logic_vector(10 - 1 downto 0)
    );
end led_driver;

architecture Behavioral of led_driver is

begin
    p_led_driver : process(distance_i, en_i)
    begin
        if (en_i = '1')then
            case distance_i is
                -- 0-10cm
                when "0000" =>
                    leds_o  <= "1111111111";
                -- 10-20cm
                when "0001" =>
                    leds_o  <= "1111111110";
                -- 20-30cm
                when "0010" =>
                    leds_o  <= "1111111100";
                -- 30-40cm
                when "0011" =>
                    leds_o  <= "1111111000";
                -- 40-50cm
                when "0100" =>
                    leds_o  <= "1111110000";
                -- 50-60cm
                when "0101" =>
                    leds_o  <= "1111100000";
                -- 60-70cm
                when "0110" =>
                    leds_o  <= "1111000000";
                -- 70-80cm
                when "0111" =>
                    leds_o  <= "1110000000";
                -- 80-90cm
                when "1000" =>
                    leds_o  <= "1100000000";
                -- >90cm
                when others =>
                    leds_o  <= "1000000000";
            end case;
        else
            leds_o  <= "0000000000";
        end if;
    end process p_led_driver;    
end Behavioral;
```
#### Testbech for LED module
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_led_driver is

end tb_led_driver;

architecture Behavioral of tb_led_driver is

    -- Local signals
    signal s_en             : std_logic;
    signal s_distance       : std_logic_vector(4 - 1 downto 0);
    
    signal s_leds           : std_logic_vector(10 - 1 downto 0);
    
begin
    
    uut_led_driver : entity work.led_driver
        port map(
            en_i          => s_en,
            distance_i    => s_distance,
            
            leds_o        => s_leds
        );

    p_stimulus : process
    begin
        -- Report a note at the begining of stimulus process
        report "Stimulus process started" severity note;
        s_en       <= '1';
        -- <90cm
        s_distance <= "1001";
        wait for 100ns;
        -- 80-90cm
        s_distance <= "1000";
        wait for 100ns;
        -- 70-80cm
        s_distance <= "0111";
        wait for 100ns;
        -- 60-70cm
        s_distance <= "0110";
        wait for 100ns;
        -- 50-60cm
        s_distance <= "0101";
        wait for 100ns;
        -- 40-50cm
        s_distance <= "0100";
        wait for 100ns;
        -- 30-40cm
        s_distance <= "0011";
        wait for 100ns;
        -- 20-30cm
        s_distance <= "0010";
        wait for 100ns;
        -- 10-20cm
        s_distance <= "0001";
        wait for 100ns;
        -- 0-10cm
        s_distance <= "0000";
        wait for 100ns;
        -- Enable OFF
        s_en       <= '0';
        -- <90cm
        s_distance <= "1001";
        wait for 100ns;
        -- 80-90cm
        s_distance <= "1000";
        wait for 100ns;
        -- 70-80cm
        s_distance <= "0111";
        wait for 100ns;
        -- Report a note at the end of stimulus process
        report "Stimulus process finished" severity note;
        wait;
    end process p_stimulus;
end Behavioral;
```
#### Simulation Waveforms:
![simulation LEDs](https://github.com/Simon-Roubal/DE1_Parking_assistant/blob/main/Images/LEDs%20simul.png)
## TOP module description and simulations

Write your text here.


## Video

*Write your text here*


## References

   1. Example bargraph picture. In: Amazon.com [online]. [cit. 2021-04-13]. Avalible at: https://amzn.to/3mHVJ4c
