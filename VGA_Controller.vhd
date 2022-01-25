----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/06/2022 08:12:09 PM
-- Design Name: 
-- Module Name: VGA_Controller - VGAController_Arch
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGA_Controller is
    Port (Clock,Reset       : in std_logic;
          Pixel_Strobe      : in std_logic;
          HSync,VSync       : out std_logic;
          Blank,Active      : out std_logic;
          EndScreen         : out std_logic;
          Animate           : out std_logic;
          XPos              : out std_logic_vector(9 downto 0);
          YPos              : out std_logic_vector(8 downto 0));
end VGA_Controller;

architecture VGAController_Arch of VGA_Controller is
--Signal Declarations
    signal HCount,VCount        : integer;
    signal XPos_temp,YPos_temp  : integer;
    
    
--Constant Declarations
    constant HSync_Start    : integer := 16;
    constant HSync_End      : integer := HSync_Start + 96;
    constant HActive_Start  : integer := HSync_Start + HSync_End + 48;

    constant VSync_Start    : integer := 490;
    constant VSync_End      : integer := VSync_Start + 2;
    constant VActive_End    : integer := 480;
    
    constant line           : integer := 800;
    constant screen         : integer := 525;
    
begin
    COUNT_POS : process(Reset,Clock)
    begin
        if(Reset = '1') then
            HCount <= 0;
            VCount <= 0;
        elsif(rising_edge(Clock)) then  
            if(pixel_strobe = '1') then
                if(HCount = line) then
                    HCount <= 0;
                    VCount <= VCount + 1; 
                elsif(VCount = Screen) then
                    VCount <= 0;
                else
                    HCount <= HCount + 1;
                end if;
            end if;
        end if;
    end process;
    
    HSync       <= '0' when ((HCount >= HSync_Start) AND (HCount < HSync_End)) else
                   '1';
    VSync       <= '0' when ((VCount >= VSync_Start) AND (VCount < VSync_End)) else
                   '1'; 
    XPos_temp   <=  0 when (HCount < HActive_Start) else
                    HCount - HActive_Start;
    YPos_temp   <=  VActive_End - 1 when (VCount >= VActive_End) else
                    VCount;   
    Blank       <= '1' when ((HCount < HActive_Start) OR (VCount > VActive_End - 1)) else
                   '0';
    Active      <= '0' when ((HCount < HActive_Start) OR (VCount > VActive_End - 1)) else
                   '1'; 
    EndScreen   <= '1' when ((VCount = Screen - 1) AND (HCount = line)) else
                   '0';  
    Animate     <= '1' when ((VCount = VActive_End - 1) AND (HCount = line)) else
                   '0';                  
    
        
    XPos <= std_logic_vector(to_unsigned(XPos_temp,10));
    YPos <= std_logic_vector(to_unsigned(YPos_temp,9));    
    

end VGAController_Arch;
