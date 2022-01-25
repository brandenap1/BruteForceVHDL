----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/29/2021 01:22:37 PM
-- Design Name: 
-- Module Name: Attack_State - AttackState_Arch
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Attack_State is
  Port (Clock,Reset     : in std_logic;
        is_Player       : in std_logic;
        EN_Out          : in std_logic;
        Attack_Type     : in std_logic_vector(3 downto 0);
        CPU_Health      : out std_logic_vector(6 downto 0));
end Attack_State;

architecture AttackState_Arch of Attack_State is
--constant declarations
    --Attack States
--    constant No_Damage        : std_logic_vector(3 downto 0) := "0000";
--    constant Light_Normal     : std_logic_vector(3 downto 0) := "0001";
--    constant Light_Critical   : std_logic_vector(3 downto 0) := "0010";    
--    constant Heavy_Normal     : std_logic_vector(3 downto 0) := "0011";
--    constant Heavy_Critical   : std_logic_vector(3 downto 0) := "0100";
--    constant Miss             : std_logic_vector(3 downto 0) := "0101";
    constant No_Damage        : integer := 0;
    constant Light_Normal     : integer := 1; 
    constant Light_Critical   : integer := 2;    
    constant Heavy_Normal     : integer := 3;
    constant Heavy_Critical   : integer := 4;
    constant Miss             : integer := 5;
    --Attack Type
    constant Standby    : std_logic_vector(3 downto 0) := "0000";
    constant Light      : std_logic_vector(3 downto 0) := "0001";
    constant Heavy      : std_logic_vector(3 downto 0) := "0010";
--signal declarations
    
    signal random_done  : std_logic_vector(7 downto 0);
    signal feedback     : std_logic;
    signal CPU_Health_temp  : integer := 0;
--    signal Attack_temp  : integer;
    
    type State_Type is (Start,Choose,Attack);
    signal current_state,next_state : State_Type;
    
begin
    
    MEMORY_STATE : process(Clock,Reset)
    begin
        if(Reset = '0') then
            current_state <= Start;
            random_done <= "00000000";
        elsif(rising_edge(Clock)) then
            current_state <= next_state;
            random_done <= random_done(6 downto 0) & feedback;
        end if;
    end process;
    
    CPU_Health <= std_logic_vector(to_unsigned(CPU_Health_temp,7));
    NXT_STATE : process(current_state) 
    begin
        case(current_state) is
            when Start => next_state <= Choose;
            when Choose => next_state <= Attack;
            when Attack => next_state <= Start;
            when others => next_state <= Start;
        end case;
    end process;
    
    OUTPUT : process(current_state)
    begin
        case(current_state) is
            when Start =>  CPU_Health_temp <= CPU_Health_temp + No_Damage; 
            when Choose =>  CPU_Health_temp <= CPU_Health_temp + No_Damage;
            when Attack =>  if(EN_Out = '1') then
                                if(is_Player = '1') then
                                   if(Attack_Type = Standby) then
                                        CPU_Health_temp <= CPU_Health_temp + No_Damage;
                                   elsif(Attack_Type = Light) then
                                       if((random_done >= "00000000") and (random_done <= "10110011")) then --Light_Normal Attack Odds (0-179 or (70%))
                                           CPU_Health_temp <= CPU_Health_temp + Light_Normal;
                                       elsif((random_done >= "10110100") and (random_done <= "11110111")) then --Light_Critical Attack Odds (180-231 or (20%))
                                           CPU_Health_temp <= CPU_Health_temp + Light_Critical;
                                       elsif((random_done >= "11111000") and (random_done <= "11111111")) then --Missed Attack Odds (231-255 (10%))
                                           CPU_Health_temp <= CPU_Health_temp + Miss; 
                                       else
                                            CPU_Health_temp <= CPU_Health_temp + No_Damage;
                                       end if;                                     
                                   elsif(Attack_Type = Heavy) then
                                       if((random_done >= "00000000") and (random_done <= "10011001")) then --Heavy_Normal Attack Odds (0-153 or (60%))
                                           CPU_Health_temp <= CPU_Health_temp + Heavy_Normal;
                                       elsif((random_done >= "11111000") and (random_done <= "10110100")) then --Light_Critical Attack Odds (154-180 or (10%))
                                           CPU_Health_temp <= CPU_Health_temp + Heavy_Critical;
                                       elsif((random_done >= "10110101") and (random_done <= "11111111")) then --Missed Attack Odds (181-255 or (30%))
                                           CPU_Health_temp <= CPU_Health_temp + Miss; 
                                       else
                                           CPU_Health_temp <= CPU_Health_temp + No_Damage;
                                       end if;  
                                   else
                                       CPU_Health_temp <= CPU_Health_temp + Miss;
                                   end if;
                               end if; 
                               if(CPU_Health_temp >= 100) then
                                   CPU_Health_temp <= 0;
                               end if;                              
--                           elsif(is_Player = '0') then
--                               if(Attack_Type = Standby) then
--                                    CPU_Health_temp <= CPU_Health_temp - No_Damage;
--                               elsif(Attack_Type = Light) then
--                                   if((random_done >= "00000000") and (random_done <= "10110011")) then --Light_Normal Attack Odds (0-179 or (70%))
--                                       CPU_Health_temp <= CPU_Health_temp - Light_Normal;
--                                   elsif((random_done >= "10110100") and (random_done <= "11110111")) then --Light_Critical Attack Odds (180-231 or (20%))
--                                       CPU_Health_temp <= CPU_Health_temp - Light_Critical;
--                                   elsif((random_done >= "11111000") and (random_done <= "11111111")) then --Missed Attack Odds (231-255 (10%))
--                                       CPU_Health_temp <= CPU_Health_temp - Miss; 
--                                   else
--                                        CPU_Health_temp <= CPU_Health_temp - No_Damage;
--                                   end if;                                     
--                               elsif(Attack_Type = Heavy) then
--                                   if((random_done >= "00000000") and (random_done <= "10011001")) then --Heavy_Normal Attack Odds (0-153 or (60%))
--                                       CPU_Health_temp <= CPU_Health_temp - Heavy_Normal;
--                                   elsif((random_done >= "11111000") and (random_done <= "10110100")) then --Heavy_Critical Attack Odds (154-180 or (10%))
--                                       CPU_Health_temp <= CPU_Health_temp - Heavy_Critical;
--                                   elsif((random_done >= "10110101") and (random_done <= "11111111")) then --Missed Attack Odds (181-255 or (30%))
--                                       CPU_Health_temp <= CPU_Health_temp - Miss; 
--                                   else
--                                        CPU_Health_temp <= CPU_Health_temp - No_Damage;
--                                   end if;  
--                               else
--                                    CPU_Health_temp <= CPU_Health_temp - Miss;
--                               end if;
--                           else
--                               CPU_Health_temp <= CPU_Health_temp - No_Damage; 
                            
                           end if;                           
            when others => CPU_Health_temp <= CPU_Health_temp + Miss;
        end case;
    end process;
    
    feedback <= not(random_done(7) xor random_done(6));
end AttackState_Arch;
