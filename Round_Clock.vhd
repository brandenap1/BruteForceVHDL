----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/26/2021 11:27:47 PM
-- Design Name: 
-- Module Name: Round_Clock - Round_Clock_Arch
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
use IEEE.numeric_std.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Round_Clock is
  Port (Clock,Reset   : in std_logic;
        Press         : in std_logic; --Enable
        Pause         : in std_logic;
--        Sec_in        : in std_logic_vector(5 downto 0);
--        Min_in        : in std_logic_vector(3 downto 0);
        EN_Out        : out std_logic;
        Press_EN      : out std_logic;
        Round_Start   : out std_logic;
        Sec           : out std_logic_vector(7 downto 0);
        Min           : out std_logic_vector(3 downto 0));
end Round_Clock;

architecture Round_Clock_Arch of Round_Clock is
--signal declarations
    type State_Type is (Start,Count1,Count2);
    signal current_state,next_state     : State_Type;
    signal Sec_Count                    :  integer;
    signal Sec_int                      :  integer;
    signal Min_int                      :  integer;
    signal one_second_counter           : std_logic_vector(27 downto 0);
    signal one_second_enable            : std_logic;
    signal Count_Start                  : std_logic;
    signal EN                           : std_logic;
    signal Press_EN_temp                : std_logic;
begin

    process(Clock, Reset)
    begin
        if(Reset='1') then
            Sec_Count <= 0;
        elsif(rising_edge(Clock)) then
            if(Pause = '0') then
                if(one_second_counter >= x"5F5E0FF") then
                    Sec_Count <= 0;
                else
                    Sec_Count <= Sec_Count + 1;
                end if;
            else
                Sec_Count <= Sec_Count;
            end if;
            one_second_counter <= std_logic_vector(to_unsigned(Sec_Count,28));
        end if;
    end process;
    
    one_second_enable <= '1' when (one_second_counter = x"5F5E0FF")  else '0';
    
    Memory_State : process(Clock,Reset,one_second_enable,EN) 
    begin
        if(Reset = '1') then
            current_state <= Start;
            Sec_int <= 6;
            Min_int <= 0;
            EN <= '0';
            Press_En_temp <= '0';
        elsif(rising_edge(Clock)) then
            current_state <= next_state;
            if(Press = '1') then
                Press_EN_temp <= '1';
            end if;
            if(one_second_enable = '1') then
                if(Press_EN_temp = '1') then
                    if(EN = '0') then
                        if(Sec_int = 0) then
                            Sec_int <= 30;
                            Min_int <= 1;
                            EN <= '1';
                        else
                            Sec_int <= Sec_int - 1;
                        end if;
                    elsif(EN = '1') then
                        if(Sec_int = 0) then
                            if(Min_int = 0) then
                                Sec_int <= 6;
                                Min_int <= 0; 
                                EN <= '0';
                                Press_En_temp <= '0';
                            else  
                                Sec_int <= 59;
                                Min_int <= Min_int - 1;
                            end if;
                        else
                            Sec_int <= Sec_int - 1;
                        end if;
                    end if;
                end if;
            end if;
        end if;  
    end process;
    Press_EN <= Press_EN_temp;
    EN_Out <= EN;
    NXT_STATE : process(current_state,Sec_int,Min_int,Press_En_temp)
    begin
        case(current_state) is
            when Start => if(Press_EN_temp = '1') then
                              next_state <= Count1;
                          else
                              next_state <= Start;
                          end if;
            when Count1 => if(Sec_int = 0) then
                               next_state <= Count2;
                           else
                               next_state <= Count1;
                           end if;
            when Count2 => if(Sec_int = 0) then
                               if(Min_int = 0) then
                                   next_state <= Start;
                               end if;
                           else
                               next_state <= Count2;
                           end if; 
            when others => next_state <= Start;    
        end case;
    end process;
    
    OUTPUT : process(current_state,Sec_int,Min_int)
    begin
        case(current_state) is
        when Start => Min <= std_logic_vector(to_unsigned(Min_int,4));
                      Sec <= std_logic_vector(to_unsigned(Sec_int,8));  
                      Round_Start <= '0';
        when Count1 => Min <= std_logic_vector(to_unsigned(Min_int,4));
                      Sec <= std_logic_vector(to_unsigned(Sec_int,8));
                      Round_Start <= '1'; 
        when Count2 => Min <= std_logic_vector(to_unsigned(Min_int,4));
                      Sec <= std_logic_vector(to_unsigned(Sec_int,8)); 
                      Round_Start <= '1';
        when others => Min <= std_logic_vector(to_unsigned(Min_int,4));
                      Sec <= std_logic_vector(to_unsigned(Sec_int,8));   
                      Round_Start <= '0';                                                       
        end case;
    end process;  
                                                             
end Round_Clock_Arch;
