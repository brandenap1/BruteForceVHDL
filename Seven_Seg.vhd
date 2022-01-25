----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/28/2021 01:23:35 PM
-- Design Name: 
-- Module Name: Seven_Seg - SevenSeg_Arch
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
--use IEEE.std_logic_unsigned.ALL;
use IEEE.numeric_std.ALL;
entity Seven_Seg is
    Port (Clock,Reset           : in std_logic;
          Sec1                  : in std_logic_vector(3 downto 0);
          Sec0                  : in std_logic_vector(3 downto 0);
          Min                   : in std_logic_vector(3 downto 0);
          En_Out                : in std_logic;
--          Led_displayed_number  : out std_logic_vector(7 downto 0);
          LED                   : out std_logic_vector(3 downto 0);-- 4 Anode signals
          Anode                 : out STD_LOGIC_VECTOR (6 downto 0));-- Cathode patterns of 7-segment display
end Seven_Seg;

architecture SevenSeg_Arch of Seven_Seg is
signal one_second_counter: STD_LOGIC_VECTOR (27 downto 0);
signal one_second_counter_temp : integer;
-- counter for generating 1-second clock enable
signal one_second_enable: std_logic;
signal EN               : std_logic;
-- one second enable for counting numbers
signal displayed_number: STD_LOGIC_VECTOR (15 downto 0);
signal displayed_number_temp : integer;
-- counting decimal number to be displayed on 4-digit 7-segment display
signal LED_BCD: STD_LOGIC_VECTOR (3 downto 0);
signal refresh_counter: STD_LOGIC_VECTOR (19 downto 0);
signal refresh_counter_temp  : integer;
-- creating 10.5ms refresh period
signal LED_activating_counter: std_logic_vector(1 downto 0);
-- the other 2-bit for creating 4 LED-activating signals
-- count         0    ->  1  ->  2  ->  3
-- activates    LED1    LED2   LED3   LED4
-- and repeat
begin
-- VHDL code for BCD to 7-segment decoder
-- Cathode patterns of the 7-segment LED display 
process(LED_BCD)
begin
    case LED_BCD is
    when "0000" => Anode        <= "0000001"; -- "0"     
    when "0001" => Anode        <= "1001111"; -- "1" 
    when "0010" => Anode        <= "0010010"; -- "2" 
    when "0011" => Anode        <= "0000110"; -- "3" 
    when "0100" => Anode        <= "1001100"; -- "4" 
    when "0101" => Anode        <= "0100100"; -- "5" 
    when "0110" => Anode        <= "0100000"; -- "6" 
    when "0111" => Anode        <= "0001111"; -- "7" 
    when "1000" => Anode        <= "0000000"; -- "8"     
    when "1001" => Anode        <= "0000100"; -- "9" 
    when "1010" => Anode        <= "0000010"; -- a
    when "1011" => Anode        <= "1100000"; -- b
    when "1100" => Anode        <= "0110001"; -- C
    when "1101" => Anode        <= "1000010"; -- d
    when "1110" => Anode        <= "0110000"; -- E
    when "1111" => Anode        <= "0111000"; -- F
    when others => Anode        <= "0000000";
    end case;
end process;
-- 7-segment display controller
-- generate refresh period of 10.5ms
process(Clock,Reset)
begin 
    if(Reset='1') then
        refresh_counter_temp <= 0;
    elsif(rising_edge(Clock)) then
        refresh_counter_temp <= refresh_counter_temp + 1;
    end if;
end process;
    refresh_counter <= std_logic_vector(to_unsigned(refresh_counter_temp,20));
    LED_activating_counter <= refresh_counter(19 downto 18);
-- 4-to-1 MUX to generate anode activating signals for 4 LEDs 
process(LED_activating_counter)
begin
    case LED_activating_counter is
    when "00" =>
        LED     <= "0111"; 
        -- activate LED1 and Deactivate LED2, LED3, LED4
        LED_BCD <= "0000";
        -- the first hex digit of the 16-bit number
    when "01" =>
        LED     <= "1011"; 
        -- activate LED2 and Deactivate LED1, LED3, LED4
        LED_BCD <= Min;
        -- the second hex digit of the 16-bit number
    when "10" =>
        LED     <= "1101"; 
        -- activate LED3 and Deactivate LED2, LED1, LED4
        LED_BCD <= Sec1 ;
        -- the third hex digit of the 16-bit number
    when "11" =>
        LED     <= "1110";
        if(Sec0 = "0110" AND EN_Out = '0') then
            LED_BCD <= "0101";
        else 
        -- activate LED4 and Deactivate LED2, LED3, LED1
            LED_BCD <= Sec0;
        end if;
        -- the fourth hex digit of the 16-bit number
    when others =>
        LED     <= "1111";
        LED_BCD <= "0000";     
    end case;
end process;
-- Counting the number to be displayed on 4-digit 7-segment Display 
-- on Basys 3 FPGA board
process(Clock, Reset)
begin
        if(Reset='1') then
            one_second_counter_temp <= 0;
        elsif(rising_edge(Clock)) then
            if(one_second_counter >=x"5F5E0FF") then
                one_second_counter_temp <= 0;
            else
                one_second_counter_temp <= one_second_counter_temp + 1;
            end if;
            one_second_counter <= std_logic_vector(to_unsigned(one_second_counter_temp,28));
        end if;
end process;
    one_second_enable <= '1' when (one_second_counter = x"5F5E0FF")  else '0';
--    process(Clock,Reset)
--    begin
--            if(Reset='1') then
--                displayed_number_temp <= 30;  
--            elsif(rising_edge(Clock)) then
--                if(one_second_enable='1') then
--                     if(displayed_number_temp = 0) then
--                         displayed_number_temp <= 30;
--                     else
--                         displayed_number_temp <= displayed_number_temp - 1;
--                     end if;
--                end if;
--            end if;
--    end process;

--    displayed_number <= std_logic_vector(to_unsigned(displayed_number_temp,16));
--    Led_displayed_number <= displayed_number(7 downto 0);
end SevenSeg_Arch;
