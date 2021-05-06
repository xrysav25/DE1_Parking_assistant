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

The sensor works at a voltage of 5V, so it is not powered from the board but has its own power supply. Output of the sensor is also 5V so little modification shown bellow is required to drop down the voltage to 3.3V.

|![sensor](https://github.com/xrysav25/DE1_Parking_assistant/blob/main/Images/3.3V%20mod.png)|
|:--:| 
|*Sensor modification[5]*|

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
|*Example of used bargraph[6]*|

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
|*Piezzo buzzer[7]*|
#### Adaptor board
Board was designed in Autodesk EAGLE.
|![model of board piezzo](https://github.com/xrysav25/DE1_Parking_assistant/blob/main/Images/Piezo_daptor_model.png)|
|:--:| 
|*Model of designed board (note that due to the nonexistance of models for female headers, male ones are used insted)*|
|![board piezzo](https://github.com/xrysav25/DE1_Parking_assistant/blob/main/Images/piezzo_board_fixed.png)|
|*Board design*|
|![schematic piezzo](https://github.com/xrysav25/DE1_Parking_assistant/blob/main/Images/piezzo_sch_fixed.png)|
|*Board schematic*|

### Connection to Arty A7
|![Arty A7 connection](https://github.com/xrysav25/DE1_Parking_assistant/blob/main/top/arty.png)|
|:--:| 
|*Arty A7 connection*|

## VHDL modules description and simulations
### Ultrasonic distance sensor HC-SR04
The sensor control is divided into two blocks.
The ```sensor_driver``` module directly controls the HC-SR04 sensor, emits an appropriately long pulse and calculates the response.
The ```sensor_logic``` module controls when the pulse is sent to the sensor and processes the returned distance, which it converts to 10 levels, which are then implemented in other modules by sound and light.
#### Code for sensor_driver module
https://github.com/xrysav25/DE1_Parking_assistant/blob/main/top/top.srcs/sources_1/new/sensor_driver.vhd
#### Testbech
https://github.com/xrysav25/DE1_Parking_assistant/blob/main/top/top.srcs/sim_1/new/tb_sensor_driver.vhd
#### Code for sensor_logic module
https://github.com/xrysav25/DE1_Parking_assistant/blob/main/top/top.srcs/sources_1/new/sensor_logic.vhd
#### Testbech
https://github.com/xrysav25/DE1_Parking_assistant/blob/main/top/top.srcs/sim_1/new/tb_sensor.vhd
#### Simulation Waveforms:
![simulation sensor_driver](https://github.com/xrysav25/DE1_Parking_assistant/blob/main/Images/sensor_driver.PNG)
![simulation sensor_logic](https://github.com/xrysav25/DE1_Parking_assistant/blob/main/Images/sensor_logic.PNG)

### LED bargaph module
LED module takes 2 inputs and has 1 output. One of the inputs is enable signal, which determines if module can function or not. Second input is distance level represented by 4-bit std logic vecotor. Output is 10-bit std logic vector for bargraph itself.
Architecture is represented by single ```p_led_driver``` combiational process with both inputs in its sensitivity list. First it checks, if enable signal is ON or OFF. If enable is OFF, it will switch off all the LEDs and if it is ON it will continue to determine value of distance level and will light up the LEDs accordingly.
#### Code for module
https://github.com/xrysav25/DE1_Parking_assistant/blob/main/top/top.srcs/sources_1/new/led_driver.vhd
#### Testbech for LED module
https://github.com/xrysav25/DE1_Parking_assistant/blob/main/top/top.srcs/sim_1/new/tb_led_driver.vhd
#### Simulation Waveforms:
![simulation LEDs](https://github.com/xrysav25/DE1_Parking_assistant/blob/main/Images/LEDs%20simul.png)
### PWM modulation module for piezo
PWM module takes 3 inputs and has one output. One of the inputs is enable signal, which determines if module can function or not. Second input is distance level represented by 4-bit std logic vecotor. Third output is 100HZ clock signal. Output is PWM modulated weveform for the buzzer.
Architecture is represented by ```p_clk100```,```piezzo_driver```  sequentinal processes . Firts process assures clock. Second is PWM modulation itself. First it checks enable input and its enabled, then it determines distance level and starts appropriate counter with correct pulse widht.

#### Code for module
https://github.com/xrysav25/DE1_Parking_assistant/blob/main/top/top.srcs/sources_1/new/piezzo_driver.vhd
#### Testbech for PWM module
https://github.com/xrysav25/DE1_Parking_assistant/blob/main/top/top.srcs/sim_1/new/tb_pwm_2.vhd
#### Simulation Waveforms:
![simulation PWM](https://github.com/xrysav25/DE1_Parking_assistant/blob/main/Images/PWM_large.png)
![simulation PWM detail](https://github.com/xrysav25/DE1_Parking_assistant/blob/main/Images/PWM_detail.png)

## TOP module description and simulations
Top module contains all above modules. It connects them together with hardware components.

### Top module code 
https://github.com/xrysav25/DE1_Parking_assistant/blob/main/top/top.srcs/sources_1/new/top.vhd
### Top module Testbench
https://github.com/xrysav25/DE1_Parking_assistant/blob/main/top/top.srcs/sim_1/new/tb_top.vhd



|![top](https://github.com/xrysav25/DE1_Parking_assistant/blob/top/Images/top.png)|
|:--:| 
|*Top modul schema*|


## Video

[https://youtu.be/qpVUHS5KM3g](https://youtu.be/qpVUHS5KM3g)

## References

   1. Parking sensor illustration. In: proxel.com [online]. [cit. 2021-04-29]. Avalible at: https://bit.ly/3e0bhO8
   2. Arty A7 board description. In: digilentinc.com [online]. [cit. 2021-04-20]. Avalible at: https://bit.ly/3dwthiU
   3. Arty A7 board. In: digilentinc.com [online]. [cit. 2021-04-20]. Avalible at: https://bit.ly/3vb75kt
   4. HC-SR04 sensor. In: Amazon.com [online]. [cit. 2021-04-27]. Avalible at: https://amzn.to/3dVaez2
   5. HC-SR04 sensor mod. In: instructables.com [online]. [cit. 2021-05-04]. Avalible at: https://bit.ly/3eVAvw6
   6. Example bargraph picture. In: Amazon.com [online]. [cit. 2021-04-13]. Avalible at: https://amzn.to/3mHVJ4c
   7. Active piezzo buzzer. In: conrad.cz [online]. [cit. 2021-04-27]. Avalible at: https://bit.ly/3vlYYkX

