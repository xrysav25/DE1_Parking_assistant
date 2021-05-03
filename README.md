# DE1_Parking_assistant

### Team members

Šimon Roubal, Michaela Ryšavá, Ondřej Ryšavý, Tomáš Rotrekl

[Link to GitHub project folder](https://github.com/xrysav25/DE1_Parking_assistant)

### Project objectives

The objective of the project within the subject Digital electronics was to create a parking assistant. 
We used these components. Arty A7 board to conotrol all other parts, led bargraph to signalize the distance,
piezo buzzer with PWM modulation for sound signalization, HC-SR04 ultrasonic sensor to measure distance. 
The sensor measures a distance from 2 cm to 4 m, but for our purpose we used only measurements up to 1m.
The codes, testbenches and simulations are created in Vivado. Models and designes of boards are created in Autodesk EAGLE.
|![parking assistant](https://github.com/xrysav25/DE1_Parking_assistant/blob/main/Images/Parking%20assistant.png)|
|:--:|
|*Illustration image of parking assistant[1]*|

## Hardware description
### Arty A7
The Arty A7, formerly known as the Arty, is a ready-to-use development platform designed around the Artix-7™ Field Programmable Gate Array (FPGA) from Xilinx. It was designed specifically for use as a MicroBlaze Soft Processing System. When used in this context, the Arty A7 becomes the most flexible processing platform you could hope to add to your collection, capable of adapting to whatever your project requires. Unlike other Single Board Computers, the Arty A7 isn't bound to a single set of processing peripherals: One moment it's a communication powerhouse chock-full of UARTs, SPIs, IICs, and an Ethernet MAC, and the next it's a meticulous timekeeper with a dozen 32-bit timers.[2]
|![arty](https://reference.digilentinc.com/_media/reference/programmable-logic/arty/arty-0.png)|
|:--:| 
|*Arty A7 board[3]*|
### Ultrasonic distance sensor HC-SR04
To measure the distance, we work with the ultrasonic sensor HC-DR04
|![sensor](https://github.com/xrysav25/DE1_Parking_assistant/blob/main/Images/sensor.jpg)|
|:--:| 
|*Sensor HC-SR04[4]*|

The sensor expects a 10us long pulse, based on which it sends a sequence of ultrasonic pulses and registers their reflection. The sensor returns an echo pulse of a width corresponding to the distance of the object from the sensor.
Conversion relation: echo pulse length / 58 = distance in cm

The sensor works at a voltage of 5V, so it is not powered from the board but has its own power supply.

#### Adaptor board
Board was designed in Autodesk EAGLE.
|![model of board sensor](https://github.com/xrysav25/DE1_Parking_assistant/blob/main/Images/Adapter_HC-SR04_model.png)|
|:--:| 
|*Model of designed board (note that due to the nonexistance of models for female headers, male ones are used insted)*|
|![board sensor](https://github.com/xrysav25/DE1_Parking_assistant/blob/main/Images/Adapter_HC-SR04_board.png)|
|*Board design*|
|![schematic sensor](https://github.com/xrysav25/DE1_Parking_assistant/blob/main/Images/Adapter_HC-SR04_schematic.png)|
|*Board schematic*|

### LED bargaph module
For LED visualization we have chosem bargraph with 10 LEDs and segments with diferent colors, as can be seen below.
|![bargaph](https://github.com/xrysav25/DE1_Parking_assistant/blob/main/Images/Bargaph%20example.png)|
|:--:| 
|*Example of used bargraph[5]*|

Its first segment is blue which will represent ON/OFF state indication. Other segments represent actual distance ranging from green to red. For the actual bargraph we have designed small module board, that will conect to Arty board through 2 Pmod connectors.

|![model of board LEDs](https://github.com/xrysav25/DE1_Parking_assistant/blob/main/Images/Module%20model.png)|
|:--:| 
|*Model of designed board*|

Board is fitted with bargraph itself, liminig resistors and 2 pinheader blocks. Board was designed in Autodesk EAGLE.

|![board LEDs](https://github.com/xrysav25/DE1_Parking_assistant/blob/main/Images/Module%20board.png)|
|:--:| 
|*Board design*|
|![schematic LEDs](https://github.com/xrysav25/DE1_Parking_assistant/blob/main/Images/Module%20schematic.png)|
|*Board schematic*|

### Piezzo buzzer
For sound feadback we decided to use active piezzo buzzer witch can worl on 3.3V logic values on Arty board.
|![buzzer](https://github.com/xrysav25/DE1_Parking_assistant/blob/main/Images/Piezzo.png)|
|:--:| 
|*Piezzo buzzer[6]*|
#### Adaptor board
Board was designed in Autodesk EAGLE.
|![model of board piezzo](https://github.com/xrysav25/DE1_Parking_assistant/blob/main/Images/Piezo_daptor_model.png)|
|:--:| 
|*Model of designed board (note that due to the nonexistance of models for female headers, male ones are used insted)*|
|![board piezzo](https://github.com/xrysav25/DE1_Parking_assistant/blob/main/Images/piezzo_board_fixed.png)|
|*Board design*|
|![schematic piezzo](https://github.com/xrysav25/DE1_Parking_assistant/blob/main/Images/piezzo_sch_fixed.png)|
|*Board schematic*|
## VHDL modules description and simulations
### Ultrasonic distance sensor HC-SR04
The sensor control is divided into two blocks.
The ```sensor_driver``` module directly controls the HC-SR04 sensor, emits an appropriately long pulse and calculates the response.
The ```sensor_logic``` module controls when the pulse is sent to the sensor and processes the returned distance, which it converts to 10 levels, which are then implemented in other modules by sound and light.
#### Code for sensor_driver module
```vhdl
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
```
#### Testbech
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.math_real.all;

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
        s_echo <= '1'; wait for 580 us; s_echo <= '0';
        wait until (s_puls = '1');
        wait for 1160 us; --20cm
        s_echo <= '1'; wait for 1160 us; s_echo <= '0';
        wait until (s_puls = '1');
        wait for 3190 us; --55cm
        s_echo <= '1'; wait for 3190 us; s_echo <= '0';
        wait until (s_puls = '1');
        wait for 116 us; --2cm
        s_echo <= '1'; wait for 116 us; s_echo <= '0';
        wait until (s_puls = '1');
        wait for 5800 us; --100cm
        s_echo <= '1'; wait for 5800 us; s_echo <= '0';
        wait until (s_puls = '1');
        wait for 8700 us; --150cm
        s_echo <= '1'; wait for 8700 us; s_echo <= '0';
        wait until (s_puls = '1');
        wait for 3994 us; --68cm
        s_echo <= '1'; wait for 3994 us; s_echo <= '0';
        wait until (s_puls = '1');
        wait for 696 us; --12cm
        s_echo <= '1'; wait for 696 us; s_echo <= '0';
        wait until (s_puls = '1');
        wait for 5684 us; --98cm
        s_echo <= '1'; wait for 5684 us; s_echo <= '0';
        wait until (s_puls = '1');
        wait for 4582 us; --79cm
        s_echo <= '1'; wait for 4582 us; s_echo <= '0';
        
        wait;
    end process p_echo;
end testbench;
```
#### Code for sensor_logic module
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

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
```
#### Testbech
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

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
```
#### Simulation Waveforms:
![simulation sensor_driver](https://github.com/xrysav25/DE1_Parking_assistant/blob/main/Images/sensor_driver.PNG)
![simulation sensor_logic](https://github.com/xrysav25/DE1_Parking_assistant/blob/main/Images/sensor_logic.PNG)

### LED bargaph module
LED module takes 2 inputs and has 1 output. One of the inputs is enable signal, which determines if module can function or not. Second input is distance level represented by 4-bit std logic vecotor. Output is 10-bit std logic vector for bargraph itself.
Architecture is represented by single ```p_led_driver``` combiational process with both inputs in its sensitivity list. First it checks, if enable signal is ON or OFF. If enable is OFF, it will switch off all the LEDs and if it is ON it will continue to determine value of distance level and will light up the LEDs accordingly.
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
![simulation LEDs](https://github.com/xrysav25/DE1_Parking_assistant/blob/main/Images/LEDs%20simul.png)
### PWM modulation module for piezo
PWM module takes 3 inputs and has one output. One of the inputs is enable signal, which determines if module can function or not. Second input is distance level represented by 4-bit std logic vecotor. Third output is 100HZ clock signal. Output is PWM modulated weveform for the buzzer.
Architecture is represented by ```p_clk100```,```piezzo_driver```  sequentinal processes . Firts process assures clock. Second is PWM modulation itself. First it checks enable input and its enabled, then it determines distance level and starts appropriate counter with correct pulse widht.

#### Code for module
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity piezzo_driver is
    Port ( 
    CLK100HZ             : in   std_logic;
    en_i                 : in   std_logic;
    distance_i           : in   std_logic_vector(4 - 1 downto 0);
    
    piezzo_o             : out  std_logic
    );
end piezzo_driver;

architecture Behavioral of piezzo_driver is

signal s_counter        : natural :=0;
signal s_counter_clk100 : natural;
signal clk100           : std_logic;
signal s_piezzo         : std_logic;

begin
    p_clk100: process (CLK100HZ)
    begin
        if rising_edge(CLK100HZ) then
            if (s_counter_clk100 >= 10) then
                s_counter_clk100 <=  0;
                clk100           <= '1';
            else
                s_counter_clk100 <= s_counter_clk100 + 1;
                clk100           <= '0';
            end if;
        end if;
    end process p_clk100;
    
    p_piezzo_driver : process(clk100)
    begin
            if (en_i = '1')then
                case distance_i is
                    -- 0-10cm
                    when "0000" =>
                        piezzo_o <= '1';
                    -- 10-20cm
                    when "0001" =>
                    if rising_edge(clk100)then
                        if (s_counter >= 1) then
                            s_counter <= 0;       
                            piezzo_o  <= '1'; 
                        else
                            s_counter <= s_counter + 1;
                            piezzo_o  <= '0';
                        end if;
                    end if;
                    -- 20-30cm
                    when "0010" =>
                    if rising_edge(clk100)then
                        if (s_counter >= 2) then
                            s_counter <= 0;       
                            piezzo_o  <= '1'; 
                        else
                            s_counter <= s_counter + 1;
                            piezzo_o  <= '0';
                        end if;
                    end if;
                    -- 30-40cm
                    when "0011" =>
                    if rising_edge(clk100)then
                        if (s_counter >= 3) then
                            s_counter <= 0;       
                            piezzo_o  <= '1'; 
                        else
                            s_counter <= s_counter + 1;
                            piezzo_o  <= '0';
                        end if;
                    end if;
                    -- 40-50cm
                    when "0100" =>
                    if rising_edge(clk100)then
                        if (s_counter >= 4) then
                            s_counter <= 0;       
                            piezzo_o  <= '1'; 
                        else
                            s_counter <= s_counter + 1;
                            piezzo_o  <= '0';
                        end if;
                    end if;
                    -- 50-60cm
                    when "0101" =>
                    if rising_edge(clk100)then
                        if (s_counter >= 5) then
                            s_counter <= 0;       
                            piezzo_o  <= '1'; 
                        else
                            s_counter <= s_counter + 1;
                            piezzo_o  <= '0';
                        end if;
                    end if;
                    -- 60-70cm
                    when "0110" =>
                    if rising_edge(clk100)then
                        if (s_counter >= 6) then
                            s_counter <= 0;       
                            piezzo_o  <= '1'; 
                        else
                            s_counter <= s_counter + 1;
                            piezzo_o  <= '0';
                        end if;
                    end if;
                    -- 70-80cm
                    when "0111" =>
                    if rising_edge(clk100)then
                        if (s_counter >= 7) then
                            s_counter <= 0;       
                            piezzo_o  <= '1'; 
                        else
                            s_counter <= s_counter + 1;
                            piezzo_o  <= '0';
                        end if;
                    end if;
                    -- 80-90cm
                    when "1000" =>
                    if rising_edge(clk100)then
                        if (s_counter >= 8) then
                            s_counter <= 0;       
                            piezzo_o  <= '1'; 
                        else
                            s_counter <= s_counter + 1;
                            piezzo_o  <= '0';
                        end if;
                    end if;
                    -- >90cm
                    when others =>
                        piezzo_o <= '0';
                end case;
            else
                piezzo_o <= '0';
            end if;
    end process p_piezzo_driver;    
end Behavioral;
```
#### Testbech for LED module
```vhdl
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
```
#### Simulation Waveforms:
![simulation PWM](https://github.com/xrysav25/DE1_Parking_assistant/blob/main/Images/PWM_large.png)
![simulation PWM detail](https://github.com/xrysav25/DE1_Parking_assistant/blob/main/Images/PWM_detail.png)

## TOP module description and simulations
Top module contains all above modules. It connects them together with hardware components.

### Top module code 

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity top is
    Port (CLK100MHZ : in STD_LOGIC;                 -- clock signal
          sw : in       std_logic_vector(1-1 downto 0);   -- enable switch 
          ja : inout         std_logic_vector(8-1 downto 0);    -- input and output of sensor
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
           
           triger    => ja(0),     -- output  to   sensor
           echo      => ja(4)      -- input   from sensor              
        );     

        ja(1) <= '0'; --disable ja pins 2,3,4,8,9,10 
        ja(2) <= '0';
        ja(3) <= '0';
        ja(5) <= '0';
        ja(6) <= '0';
        ja(7) <= '0';

        ja(4) <= 'Z';  --set ja4 to input
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
            CLK100HZ  => CLK100MHZ,     -- still wip
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
```
### Top module Testbench
```vhdl


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
```

|![schema](https://github.com/xrysav25/DE1_Parking_assistant/blob/main/Images/schema.png)|
|:--:| 
|*Top modul schema*|

|![top](https://github.com/xrysav25/DE1_Parking_assistant/blob/top/Images/top.png)|
|:--:| 
|*Top modul schema v2*|


## Video

*Write your text here*


## References

   1. Parking sensor illustration. In: proxel.com [online]. [cit. 2021-04-29]. Avalible at: https://bit.ly/3e0bhO8
   2. Arty A7 board description. In: digilentinc.com [online]. [cit. 2021-04-20]. Avalible at: https://bit.ly/3dwthiU
   3. Arty A7 board. In: digilentinc.com [online]. [cit. 2021-04-20]. Avalible at: https://bit.ly/3vb75kt
   4. HC-SR04 sensor. In: Amazon.com [online]. [cit. 2021-04-27]. Avalible at: https://amzn.to/3dVaez2
   5. Example bargraph picture. In: Amazon.com [online]. [cit. 2021-04-13]. Avalible at: https://amzn.to/3mHVJ4c
   6. Active piezzo buzzer. In: conrad.cz [online]. [cit. 2021-04-27]. Avalible at: https://bit.ly/3vlYYkX

