----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/04/2022 02:15:58 PM
-- Design Name: 
-- Module Name: System_Keyboard - Behavioral
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


library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity System_Keyboard is
   port (Clock      : in    std_logic; 
         Reset      : in    std_logic;
         Clock_KB   : in    std_logic;
         Data_In    : in    std_logic; 
         Data_Out   : out   std_logic_vector (3 downto 0));
end entity;

architecture BEHAVIORAL of System_Keyboard is
--Signal Declarations
    signal b            : integer := 1;
    signal flag         : std_logic := '0';
    signal data_temp    : std_logic_vector(3 downto 0) := (others => '0');
    signal data_curr    : std_logic_vector(7 downto 0) := x"45";
    
    signal Data_Debounce : std_logic;
--Component Declaration
    component Debounce is
        generic(
counter_size  :  integer := 19); --counter size (19 bits gives 10.5ms with 50MHz clock)
        port(
Clock       : in std_logic;  --input clock
             Button      : in std_logic;  --input signal to be debounced
             Result      : out std_logic); --debounced signal
    end component;
    
begin
--    DATA : Debounce port map(Clock,Data_In,Data_Debounce);
    MEMORY : process(Clock_KB,Reset)
    begin
        if(Reset = '1') then
            b <= 1;
        elsif(falling_edge(Clock_KB)) then
            case(b) is
                when 1 => b <= b;
                when 2 => data_curr(0) <= Data_in;
                when 3 => data_curr(1) <= Data_in;
                when 4 => data_curr(2) <= Data_in;
                when 5 => data_curr(3) <= Data_in;
                when 6 => data_curr(4) <= Data_in;
                when 7 => data_curr(5) <= Data_in;
                when 8 => data_curr(6) <= Data_in;
                when 9 => data_curr(7) <= Data_in;
                when 10 => flag <= '1';
                when 11 => flag <= '0';
                when others => b <= b;
            end case;  
            
            if(b <= 10) then
                b <= b + 1;
            else
                b <= 1;
            end if;                 
        end if;
    end process;
    
    NXT : process(Clock_KB,data_curr)
    begin     
       case(data_curr) is              
           WHEN x"1C" => data_temp <= "0001"; --a
--           WHEN x"32" => ascii <= x"62"; --b
--           WHEN x"21" => ascii <= x"63"; --c
           WHEN x"23" => data_temp <= "0010"; --d
           when x"29" => data_temp <= "0011"; -- Space
--           WHEN x"24" => ascii <= x"65"; --e
--           WHEN x"2B" => ascii <= x"66"; --f
--           WHEN x"34" => ascii <= x"67"; --g
--           WHEN x"33" => ascii <= x"68"; --h
--           WHEN x"43" => ascii <= x"69"; --i
--           WHEN x"3B" => ascii <= x"6A"; --j
--           WHEN x"42" => ascii <= x"6B"; --k
--           WHEN x"4B" => ascii <= x"6C"; --l
--           WHEN x"3A" => ascii <= x"6D"; --m
--           WHEN x"31" => ascii <= x"6E"; --n
--           WHEN x"44" => ascii <= x"6F"; --o
--           WHEN x"4D" => ascii <= x"70"; --p
--           WHEN x"15" => ascii <= x"71"; --q
--           WHEN x"2D" => ascii <= x"72"; --r
--           WHEN x"1B" => ascii <= x"73"; --s
--           WHEN x"2C" => ascii <= x"74"; --t
--           WHEN x"3C" => ascii <= x"75"; --u
--           WHEN x"2A" => ascii <= x"76"; --v
--           WHEN x"1D" => ascii <= x"77"; --w
--           WHEN x"22" => ascii <= x"78"; --x
--           WHEN x"35" => ascii <= x"79"; --y
--           WHEN x"1A" => ascii <= x"7A"; --z
--           WHEN x"45" => ascii <= x"30"; --0
--           WHEN x"16" => ascii <= x"31"; --1
--           WHEN x"1E" => ascii <= x"32"; --2
--           WHEN x"26" => ascii <= x"33"; --3
--           WHEN x"25" => ascii <= x"34"; --4
--           WHEN x"2E" => ascii <= x"35"; --5
--           WHEN x"36" => ascii <= x"36"; --6
--           WHEN x"3D" => ascii <= x"37"; --7
--           WHEN x"3E" => ascii <= x"38"; --8
--           WHEN x"46" => ascii <= x"39"; --9
--           WHEN x"52" => ascii <= x"27"; --'
--           WHEN x"41" => ascii <= x"2C"; --,
--           WHEN x"4E" => ascii <= x"2D"; ---
--           WHEN x"49" => ascii <= x"2E"; --.
--           WHEN x"4A" => ascii <= x"2F"; --/
--           WHEN x"4C" => ascii <= x"3B"; --;
--           WHEN x"55" => ascii <= x"3D"; --=
--           WHEN x"54" => ascii <= x"5B"; --[
--           WHEN x"5D" => ascii <= x"5C"; --\
--           WHEN x"5B" => ascii <= x"5D"; --]
--           WHEN x"0E" => ascii <= x"60"; --`
           WHEN OTHERS => data_temp <= "0000";
       END CASE;
   end process;
   
   OUTPUT : process(data_temp)
   begin
       if(flag = '1') then
           Data_Out <= data_temp;
       else
           Data_Out <= "0000";
       end if;
   end process;
   
end BEHAVIORAL;