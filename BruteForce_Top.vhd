----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/28/2021 12:55:36 PM
-- Design Name: 
-- Module Name: BruteForce_Top - Top_Arch
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

entity BruteForce_Top is
  Port (Clock,Reset         : in std_logic;
        Clock_KB            : in std_logic;
        Data                : in std_logic;
        Press               : in std_logic;
        Pause               : in std_logic;
        HSync,VSync         : out std_logic;
        VGA                 : out std_logic_vector(11 downto 0);
--        VGA_Green           : out std_logic_vector(3 downto 0);
--        VGA_Blue            : out std_logic_vector(3 downto 0);
        LED_Out             : out std_logic_vector(3 downto 0);
        Anode_Active        : out std_logic_vector(6 downto 0));
end BruteForce_Top;

architecture Top_Arch of BruteForce_Top is

------Round_Clock---------------------------------------------------

----Signal Declarations
    signal Sec_temp         : std_logic_vector(7 downto 0);
--    signal Sec_full_temp    : std_logic_vector(7 downto 0);
    signal Min_temp         : std_logic_vector(3 downto 0);
    signal Round_Start      : std_logic;
    signal EN_Out           : std_logic;   
    signal Press_EN         : std_logic;       
----Component Declaration
    component Round_Clock is
    port(Clock,Reset        : in std_logic;
         Press              : in std_logic;
         Pause              : in std_logic;
--         Sec_in             : in std_logic_vector(5 downto 0);
--         Min_in             : in std_logic_vector(3 downto 0);
         EN_Out             : out std_logic;
         Press_EN           : out std_logic;
         Round_Start        : out std_logic;
         Sec                : out std_logic_vector(7 downto 0);
         Min                : out std_logic_vector(3 downto 0)); 
    end component;



----Binary_BCD-------------------------------------------------------
----Signal Declarations
--    signal bin_temp         : std_logic_vector(7 downto 0);
--    signal ones_temp        : std_logic_vector(3 downto 0) := "0001";
--    signal tens_temp        : std_logic_vector(3 downto 0) := "0111";
    signal hundreds_temp    : std_logic_vector(3 downto 0);
----Component Declaration   
    component Binary_BCD
        port (bin       : in  std_logic_vector (7 downto 0);
              ones      : out std_logic_vector (3 downto 0);
              tens      : out std_logic_vector (3 downto 0);
              hundreds  : out std_logic_vector (3 downto 0));
    end component;



--Seven_Seg-------------------------------------------------------------------
--Signal Declarations
    signal Sec1_temp,Sec0_temp  : std_logic_vector(3 downto 0) := "0001";
--Component Declaration
    component Seven_Seg
        Port(Clock,Reset            : in std_logic;
             Sec1                   : in std_logic_vector(3 downto 0);
             Sec0                   : in std_logic_vector(3 downto 0);
             Min                    : in std_logic_vector(3 downto 0);
             EN_Out                 : in std_logic;
--             Led_displayed_number   : out std_logic_vector(7 downto 0);
             LED                    : out std_logic_vector(3 downto 0); --Active low 
             Anode                  : out std_logic_vector(6 downto 0));
    end component;



--Keyboard--------------------------------------------------------------------
--Signal Declarations
    signal PS2_Move     : std_logic_vector(3 downto 0);
    signal State_Out    : std_logic_vector(3 downto 0);
--Component Declaration
    component System_Keyboard
        port(Clock      : in    std_logic; 
             Reset      : in    std_logic;
             Clock_KB   : in    std_logic;
             Data_In    : in    std_logic; 
             Data_Out   : out   std_logic_vector (3 downto 0));
    end component;



--Attack_State-----------------------------------------------------------------------------------------------------------
--Constant Declarations
    constant Player1    : std_logic := '1';
--Signal Declarations
    signal CPU_Health   : std_logic_vector(6 downto 0);
--Component Declaration
    component Attack_State
      Port (Clock,Reset     : in std_logic;
            is_Player       : in std_logic;
            EN_Out          : in std_logic;
            Attack_Type     : in std_logic_vector(3 downto 0);
            CPU_Health      : out std_logic_vector(6 downto 0));
    end component;

--VGA_Display----------------------------------------------------------------
--Component Declaration
    component VGA_Display
        Port (Clock,Reset       : in std_logic;
              Pause             : in std_logic;
              CPU_Health        : in std_logic_vector(6 downto 0);
              Sec               : in std_logic_vector(7 downto 0);
              Min               : in std_logic_vector(3 downto 0);
              EN_Out            : in std_logic;
              Press_EN          : in std_logic;
              Round_Start       : in std_logic;
              Move              : in std_logic_vector(3 downto 0);
              HSync,VSync       : out std_logic;
              VGA               : out std_logic_vector(11 downto 0));
    end component;
    
begin

    
    TIMER : Round_Clock port map(Clock,Reset,Press,Pause,EN_Out,Press_EN,Round_Start,Sec_temp,Min_temp);
    
    BIN_2_BCD : Binary_BCD port map(Sec_Temp,Sec0_temp,
                                    Sec1_Temp,hundreds_temp);
    
    SEG : Seven_Seg port map(Clock,Reset,Sec1_temp,Sec0_temp,
                             Min_temp,EN_Out,LED_Out,Anode_Active);
    
    PS2 : System_Keyboard port map(Clock,Reset,Clock_KB,Data,State_Out);
    
    STATE : Attack_State port map(Clock,Reset,Player1,EN_Out,State_Out,CPU_Health);
    DRAW : VGA_Display port map(Clock,Reset,Pause,CPU_Health,Sec_temp,Min_temp,EN_Out,Press_EN,Round_Start,State_Out,HSync,VSync,VGA);
    
end architecture;