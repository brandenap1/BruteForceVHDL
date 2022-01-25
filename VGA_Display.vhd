----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/06/2022 09:13:07 PM
-- Design Name: 
-- Module Name: VGA_Display - VGADisplay_Arch
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
use IEEE.STD_Logic_Unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGA_Display is
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
end VGA_Display;

architecture VGADisplay_Arch of VGA_Display is
--Constant Declarations
    constant HSync_Start    : integer := 48;
    constant HSync_End      : integer := 160;
    constant HActive_Start  : integer := 176;

    constant VSync_Start    : integer := 0;
    constant VSync_End      : integer := 4;
    constant VActive_End    : integer := 480;
    
    constant line           : integer := 800;
    constant screen         : integer := 1066;
    
--Signal Declarations
    signal Pixel_Strobe    : std_logic;
    signal Blank,Active    : std_logic;
    signal EndScreen       : std_logic;
    signal Animate         : std_logic;
    signal XPos            : std_logic_vector(9 downto 0);
    signal YPos            : std_logic_vector(8 downto 0);
    signal Sprite_Count    : integer;
    signal Count_temp      : std_logic_vector(27 downto 0);
    signal Sprite_EN       : std_logic;
    signal Count_EN        : std_logic;

    type State_Type is (Menu,Count5,Count4,Count3,Count2,Count1,CountGo,
                        Idle,PunchPlayer,PunchCpu,GameOver);
    signal current_state,next_state     : State_Type;
    
    signal VGA_Idle        : std_logic_vector(11 downto 0);
    signal VGA_Menu        : std_logic_vector(11 downto 0);
    signal VGA_Count5      : std_logic_vector(11 downto 0);
    signal VGA_Count4      : std_logic_vector(11 downto 0);
    signal VGA_Count3      : std_logic_vector(11 downto 0);
    signal VGA_Count2      : std_logic_vector(11 downto 0);
    signal VGA_Count1      : std_logic_vector(11 downto 0);
    signal VGA_CountGo     : std_logic_vector(11 downto 0);
    signal VGA_PlayerPunch : std_logic_vector(11 downto 0);
    signal VGA_CPUPunch    : std_logic_vector(11 downto 0);
    signal VGA_GameOver    : std_logic_vector(11 downto 0);
--    signal VGA_Paused      : std_logic_vector(11 downto 0);

    signal Pause1          : std_logic_vector(11 downto 0);
    signal Pause2          : std_logic_vector(11 downto 0);
    signal Pause3          : std_logic_vector(11 downto 0);
    signal Pause4          : std_logic_vector(11 downto 0);
    signal Pause5          : std_logic_vector(11 downto 0);
    signal Pause6          : std_logic_vector(11 downto 0);
    signal Pause7          : std_logic_vector(11 downto 0);
    signal Pause8          : std_logic_vector(11 downto 0);
    signal Pause9          : std_logic_vector(11 downto 0);
    signal Pause10         : std_logic_vector(11 downto 0);
    
    signal Title1          : std_logic_vector(11 downto 0);
    signal Title2          : std_logic_vector(11 downto 0);
    signal Title3          : std_logic_vector(11 downto 0);
    signal Title4          : std_logic_vector(11 downto 0);
    signal Title5          : std_logic_vector(11 downto 0);
    signal Title6          : std_logic_vector(11 downto 0);
    signal Title7          : std_logic_vector(11 downto 0);
    signal Title8          : std_logic_vector(11 downto 0);
    signal Title9          : std_logic_vector(11 downto 0);
    signal Title10         : std_logic_vector(11 downto 0);
    signal Title11         : std_logic_vector(11 downto 0);
    signal Title12         : std_logic_vector(11 downto 0);
    signal Title13         : std_logic_vector(11 downto 0);
    signal Title14         : std_logic_vector(11 downto 0);
    signal Title15         : std_logic_vector(11 downto 0);
    signal Title16         : std_logic_vector(11 downto 0);
    signal Title17         : std_logic_vector(11 downto 0);
    signal Title18         : std_logic_vector(11 downto 0);
    signal Title19         : std_logic_vector(11 downto 0);
    signal Title20         : std_logic_vector(11 downto 0);
    signal Title21         : std_logic_vector(11 downto 0);
    signal Title22         : std_logic_vector(11 downto 0);
    signal Title23         : std_logic_vector(11 downto 0);
    signal Title24         : std_logic_vector(11 downto 0);
    signal Title25         : std_logic_vector(11 downto 0);
    signal Title26         : std_logic_vector(11 downto 0);

    signal GameOver1       : std_logic_vector(11 downto 0); 
    signal GameOver2       : std_logic_vector(11 downto 0);
    signal GameOver3       : std_logic_vector(11 downto 0);
    signal GameOver4       : std_logic_vector(11 downto 0);  
    signal GameOver5       : std_logic_vector(11 downto 0); 
    signal GameOver6       : std_logic_vector(11 downto 0);
    signal GameOver7       : std_logic_vector(11 downto 0);
    signal GameOver8       : std_logic_vector(11 downto 0);
    signal GameOver9       : std_logic_vector(11 downto 0); 
    signal GameOver10      : std_logic_vector(11 downto 0);
    signal GameOver11      : std_logic_vector(11 downto 0);
    signal GameOver12      : std_logic_vector(11 downto 0);  
    signal GameOver13      : std_logic_vector(11 downto 0); 
    signal GameOver14      : std_logic_vector(11 downto 0);
    signal GameOver15      : std_logic_vector(11 downto 0);
    signal GameOver16      : std_logic_vector(11 downto 0);
    signal GameOver17      : std_logic_vector(11 downto 0);
    signal GameOver18      : std_logic_vector(11 downto 0);
    signal GameOver19      : std_logic_vector(11 downto 0);
    signal GameOver20      : std_logic_vector(11 downto 0); 
    signal GameOver21      : std_logic_vector(11 downto 0);
    signal GameOver22      : std_logic_vector(11 downto 0);
    signal GameOver23      : std_logic_vector(11 downto 0);  
    signal GameOver24      : std_logic_vector(11 downto 0); 
    signal GameOver25      : std_logic_vector(11 downto 0);
    signal GameOver26      : std_logic_vector(11 downto 0);
    signal GameOver27      : std_logic_vector(11 downto 0);
    signal GameOver28      : std_logic_vector(11 downto 0);
    
    signal Count5_line1          : std_logic_vector(11 downto 0);
    signal Count5_line2          : std_logic_vector(11 downto 0);
    signal Count5_line3          : std_logic_vector(11 downto 0);
    signal Count5_line4          : std_logic_vector(11 downto 0); 
    signal Count5_line5          : std_logic_vector(11 downto 0);
    signal Count5_line6          : std_logic_vector(11 downto 0); 
 
    signal Count4_line1          : std_logic_vector(11 downto 0);
    signal Count4_line2          : std_logic_vector(11 downto 0);
    signal Count4_line3          : std_logic_vector(11 downto 0);
    signal Count4_line4          : std_logic_vector(11 downto 0); 
    signal Count4_line5          : std_logic_vector(11 downto 0);
    signal Count4_line6          : std_logic_vector(11 downto 0);
    
    signal Count3_line1          : std_logic_vector(11 downto 0);
    signal Count3_line2          : std_logic_vector(11 downto 0);
    signal Count3_line3          : std_logic_vector(11 downto 0);
    signal Count3_line4          : std_logic_vector(11 downto 0); 
    signal Count3_line5          : std_logic_vector(11 downto 0);
    signal Count3_line6          : std_logic_vector(11 downto 0);     
    
    signal Count2_line1          : std_logic_vector(11 downto 0);
    signal Count2_line2          : std_logic_vector(11 downto 0);
    signal Count2_line3          : std_logic_vector(11 downto 0);
    signal Count2_line4          : std_logic_vector(11 downto 0); 
    signal Count2_line5          : std_logic_vector(11 downto 0);
    signal Count2_line6          : std_logic_vector(11 downto 0); 
    
    signal Count1_line1          : std_logic_vector(11 downto 0);
    signal Count1_line2          : std_logic_vector(11 downto 0);
    signal Count1_line3          : std_logic_vector(11 downto 0);
    signal Count1_line4          : std_logic_vector(11 downto 0); 
    signal Count1_line5          : std_logic_vector(11 downto 0);
    signal Count1_line6          : std_logic_vector(11 downto 0); 
    
    signal CountGo_line1          : std_logic_vector(11 downto 0);
    signal CountGo_line2          : std_logic_vector(11 downto 0);
    signal CountGo_line3          : std_logic_vector(11 downto 0);
    signal CountGo_line4          : std_logic_vector(11 downto 0); 
    signal CountGo_line5          : std_logic_vector(11 downto 0);
    signal CountGo_line6          : std_logic_vector(11 downto 0); 
    signal CountGo_line7          : std_logic_vector(11 downto 0);
    signal CountGo_line8          : std_logic_vector(11 downto 0);
    signal CountGo_line9          : std_logic_vector(11 downto 0);
    signal CountGo_line10          : std_logic_vector(11 downto 0); 
    signal CountGo_line11          : std_logic_vector(11 downto 0);
    signal CountGo_line12          : std_logic_vector(11 downto 0);
    
     
    signal CPU_Health_Bar1      : std_logic_vector(11 downto 0);
    signal CPU_Health_Bar2      : std_logic_vector(11 downto 0);
    signal CPU_Health_Bar3      : std_logic_vector(11 downto 0);
    signal CPU_Health_Bar4      : std_logic_vector(11 downto 0);
    signal CPU_Health_Bar5      : std_logic_vector(11 downto 0);
    signal CPU_Health_Bar6      : std_logic_vector(11 downto 0);
    signal CPU_Health_Bar7      : std_logic_vector(11 downto 0);
    signal CPU_Health_Bar8      : std_logic_vector(11 downto 0);
    signal CPU_Health_Bar9      : std_logic_vector(11 downto 0);
    signal CPU_Health_Bar10     : std_logic_vector(11 downto 0);
    signal CPU_Health_Bar11     : std_logic_vector(11 downto 0);
    signal CPU_Health_Bar12     : std_logic_vector(11 downto 0);

    signal Player_Health_Bar1   : std_logic_vector(11 downto 0);
    signal Player_Health_Bar2   : std_logic_vector(11 downto 0);
    signal Player_Health_Bar3   : std_logic_vector(11 downto 0);
    signal Player_Health_Bar4   : std_logic_vector(11 downto 0);
    signal Player_Health_Bar5   : std_logic_vector(11 downto 0);
    signal Player_Health_Bar6   : std_logic_vector(11 downto 0);
    signal Player_Health_Bar7   : std_logic_vector(11 downto 0);
    signal Player_Health_Bar8   : std_logic_vector(11 downto 0);
    signal Player_Health_Bar9   : std_logic_vector(11 downto 0);
    signal Player_Health_Bar10  : std_logic_vector(11 downto 0);
    signal Player_Health_Bar11  : std_logic_vector(11 downto 0);
    signal Player_Health_Bar12  : std_logic_vector(11 downto 0);
    
    signal CPU_Punch1      : std_logic_vector(11 downto 0);
    signal CPU_Punch2      : std_logic_vector(11 downto 0);
    signal CPU_Punch3      : std_logic_vector(11 downto 0);
    signal CPU_Punch4      : std_logic_vector(11 downto 0); 
    signal CPU_Punch5      : std_logic_vector(11 downto 0);
    signal CPU_Punch6      : std_logic_vector(11 downto 0);
    signal CPU_Punch7      : std_logic_vector(11 downto 0);
    signal CPU_Punch8      : std_logic_vector(11 downto 0);
    signal CPU_Punch9      : std_logic_vector(11 downto 0);
    signal CPU_Punch10     : std_logic_vector(11 downto 0);
    signal CPU_Punch11     : std_logic_vector(11 downto 0);
    signal CPU_Punch12     : std_logic_vector(11 downto 0);
    signal CPU_Punch13     : std_logic_vector(11 downto 0);
    signal CPU_Punch14     : std_logic_vector(11 downto 0);
    signal CPU_Punch15     : std_logic_vector(11 downto 0); 
    
    signal CPU_Idle1       : std_logic_vector(11 downto 0);
    signal CPU_Idle2       : std_logic_vector(11 downto 0);
    signal CPU_Idle3       : std_logic_vector(11 downto 0);
    signal CPU_Idle4       : std_logic_vector(11 downto 0);
    signal CPU_Idle5       : std_logic_vector(11 downto 0);
    signal CPU_Idle6       : std_logic_vector(11 downto 0);
    signal CPU_Idle7       : std_logic_vector(11 downto 0);
    signal CPU_Idle8       : std_logic_vector(11 downto 0);
    signal CPU_Idle9       : std_logic_vector(11 downto 0);
    signal CPU_Idle10      : std_logic_vector(11 downto 0);
    signal CPU_Idle11      : std_logic_vector(11 downto 0);
    signal CPU_Idle12      : std_logic_vector(11 downto 0);
    signal CPU_Idle13      : std_logic_vector(11 downto 0);
    signal CPU_Idle14      : std_logic_vector(11 downto 0);
    signal CPU_Idle15      : std_logic_vector(11 downto 0);  
    
    signal Player_Punch1      : std_logic_vector(11 downto 0);
    signal Player_Punch2      : std_logic_vector(11 downto 0);
    signal Player_Punch3      : std_logic_vector(11 downto 0);
    signal Player_Punch4      : std_logic_vector(11 downto 0); 
    signal Player_Punch5      : std_logic_vector(11 downto 0);
    signal Player_Punch6      : std_logic_vector(11 downto 0);
    signal Player_Punch7      : std_logic_vector(11 downto 0);
    signal Player_Punch8      : std_logic_vector(11 downto 0);
    signal Player_Punch9      : std_logic_vector(11 downto 0);
    signal Player_Punch10     : std_logic_vector(11 downto 0);
    signal Player_Punch11     : std_logic_vector(11 downto 0);
    signal Player_Punch12     : std_logic_vector(11 downto 0); 
    signal Player_Punch13     : std_logic_vector(11 downto 0);
    signal Player_Punch14     : std_logic_vector(11 downto 0);
    signal Player_Punch15     : std_logic_vector(11 downto 0);    
    
    signal Player_Idle1       : std_logic_vector(11 downto 0);
    signal Player_Idle2       : std_logic_vector(11 downto 0);
    signal Player_Idle3       : std_logic_vector(11 downto 0);
    signal Player_Idle4       : std_logic_vector(11 downto 0);
    signal Player_Idle5       : std_logic_vector(11 downto 0);
    signal Player_Idle6       : std_logic_vector(11 downto 0);
    signal Player_Idle7       : std_logic_vector(11 downto 0);
    signal Player_Idle8       : std_logic_vector(11 downto 0);
    signal Player_Idle9       : std_logic_vector(11 downto 0);
    signal Player_Idle10      : std_logic_vector(11 downto 0);
    signal Player_Idle11      : std_logic_vector(11 downto 0);
    signal Player_Idle12      : std_logic_vector(11 downto 0);
    signal Player_Idle13      : std_logic_vector(11 downto 0);
    signal Player_Idle14      : std_logic_vector(11 downto 0);
    signal Player_Idle15      : std_logic_vector(11 downto 0);
        
    -- Boxing Ring
    signal Ground       : std_logic_vector(11 downto 0);
    signal Left_Post    : std_logic_vector(11 downto 0);
    signal Right_Post   : std_logic_vector(11 downto 0);
    signal Top_Rope     : std_logic_vector(11 downto 0);
    signal Middle_Rope  : std_logic_vector(11 downto 0);
    signal Bottom_Rope  : std_logic_vector(11 downto 0);
--Component Declarations
    component VGA_Controller
    Port (Clock,Reset       : in std_logic;
          Pixel_Strobe      : in std_logic;
          HSync,VSync       : out std_logic;
          Blank,Active      : out std_logic;
          EndScreen         : out std_logic;
          Animate           : out std_logic;
          XPos              : out std_logic_vector(9 downto 0);
          YPos              : out std_logic_vector(8 downto 0));
    end component;
begin

-- Instantiation
    CONTROLLER : VGA_Controller port map(Clock,Reset,Pixel_Strobe,HSync,VSync,
                                         Blank,Active,EndScreen,Animate,XPos,YPos);
-- Sprite FSM

    process(Clock, Reset)
    begin
        if(Reset='1') then
            Sprite_Count <= 0;
        elsif(rising_edge(Clock)) then
            if(Move = "0001" OR Move = "0010") then
                Count_EN <= '1';
            elsif(Count_EN = '1') then
                if(Count_temp >= x"0FFFFFF") then
                    Sprite_Count <= 0;
                    Count_EN <= '0';
                else
                    Sprite_Count <= Sprite_Count + 1;
                end if;
            end if;
            Count_temp <= std_logic_vector(to_unsigned(Sprite_Count,28));
        end if;
    end process;
    
    Sprite_EN <= '0' when (Count_temp = x"0FFFFFF")  else '1';
    MEMORY : process(Clock,Reset)
    begin
        if(Reset = '1') then
            current_state <= Menu;
        elsif(rising_edge(Clock)) then
            current_state <= next_state;
        end if;
    end process;
    
    NXT_STATE : process(current_state,Sprite_Count)
    begin
        case(current_state) is
            when Menu           => if(Sec = "00000101") then
                                       next_state <= Count5;
                                   else
                                       next_state <= Menu;
                                   end if;
            when Count5         => if(Sec = "00000100") then
                                       next_state <= Count4;
                                   else
                                       next_state <= Count5;
                                   end if;
            when Count4         => if(Sec = "00000011") then
                                       next_state <= Count3;
                                   else
                                       next_state <= Count4;
                                   end if;
            when Count3         => if(Sec = "00000010") then
                                       next_state <= Count2;
                                   else
                                       next_state <= Count3;
                                   end if;
            when Count2         => if(Sec = "00000001") then
                                       next_state <= Count1;
                                   else
                                       next_state <= Count2;
                                   end if;  
            when Count1         => if(Sec = "00000000") then
                                       next_state <= CountGo;
                                   else
                                       next_state <= Count1;
                                   end if;    
            when CountGo        => if(Sec = "00011110") then 
                                       next_state <= Idle; 
                                   else
                                       next_state <= CountGo;
                                   end if;                                                                                                                    
            when Idle           => if(Pause = '0') then
                                       if(Press_En = '0' OR CPU_Health >= 100) then 
                                           next_state <= GameOver;
                                       else  
                                           if(Move = "0001") then
                                               next_state <= PunchPlayer;
                                           elsif(Move = "0010") then
                                               next_state <= PunchCPU;
                                           else
                                               next_state <= Idle;
                                           end if;
                                       end if;
                                   elsif(Pause = '1') then
                                       next_state <= Idle;
                                   end if;
            when PunchPlayer    => if(Pause = '0') then
                                       if(Sprite_EN = '1') then
                                           next_state <= PunchPlayer;
                                       elsif(Sprite_EN = '0') then
                                           next_state <= Idle;
                                       end if;
                                   elsif(Pause = '1') then
                                       next_state <= Idle;
                                   end if;
            when PunchCPU       => if(Pause = '0') then
                                       if(Sprite_EN = '1') then
                                           next_state <= PunchCPU;
                                       elsif(Sprite_EN = '0') then
                                           next_state <= Idle;
                                       end if;  
                                   elsif(Pause = '1') then
                                       next_state <= Idle;
                                   end if;
            when GameOver       => if(Move = "0011") then
                                       next_state <= Menu;
                                   else
                                       next_state <= GameOver;
                                   end if;                                       
            when others         => next_state <= Idle;                               
        end case;                
    end process;
    
    OUTPUT : process(current_state) 
    begin
        case(current_state) is
            when Idle           => VGA <= VGA_Idle;
            when Menu           => VGA <= VGA_Menu;
            when Count5         => VGA <= VGA_Count5;
            when Count4         => VGA <= VGA_Count4;
            when Count3         => VGA <= VGA_Count3;
            when Count2         => VGA <= VGA_Count2;
            when Count1         => VGA <= VGA_Count1;
            when CountGo        => VGA <= VGA_CountGo;
            when PunchPlayer    => VGA <= VGA_PlayerPunch;
            when PunchCPU       => VGA <= VGA_CPUPunch;
            when GameOver       => VGA <= VGA_GameOver;
            when others         => VGA <= VGA_Idle;
        end case;
    end process;
-- Pixel Strobe Logic
    PXL : process(Clock,Reset)
        variable count             : unsigned(15 downto 0);
        variable strobe_temp       : unsigned(16 downto 0);
    begin
        if(rising_edge(Clock)) then
            strobe_temp := ('0' & count) + ('0' & x"4000");
            count := strobe_temp(15 downto 0);
            pixel_strobe <= strobe_temp(16);
        end if;
    end process;  
---- Boxing Ring Display
    Ground      <= x"FFF" when ((XPos >= 0) AND (YPOS >= 450)) else
                   x"000";
--    Left_Post   <= x"F00" when ((XPos <= 10) AND (YPOS >= 290)) else
--                   x"000";  
--    Right_Post  <= x"00F" when ((XPos <= 600) AND (YPOS >= 290)) else
--                   x"000";  
--    Top_Rope    <= x"FFF" when ((XPos > 10 AND XPos < 600) AND (YPOS >= 300 AND YPOS <= 310)) else
--                   x"000";   
--    Middle_Rope <= x"FFF" when ((XPos > 10 AND XPos < 600) AND (YPOS >= 350 AND YPOS <= 360)) else
--                   x"000"; 
--    Bottom_Rope <= x"FFF" when ((XPos > 10 AND XPos < 600) AND (YPOS >= 400 AND YPOS <= 410)) else
--                   x"000"; 
-- CPU Health Bar (X : 330- 350) (Y : 200-210)
-- Five
    Count5_line1 <= x"FF0" when((Xpos >= 270 AND XPos < 280) AND (YPOS >= 110 AND YPOS < 160)) else
                    x"FF0" when((Xpos >= 270 AND XPos < 280) AND (YPOS >= 180 AND YPOS < 200)) else
                    x"000";
    Count5_line2 <= x"FF0" when((Xpos >= 280 AND XPos < 290) AND (YPOS >= 110 AND YPOS < 160)) else
                    x"FF0" when((Xpos >= 280 AND XPos < 290) AND (YPOS >= 180 AND YPOS < 200)) else
                    x"000";
    Count5_line3 <= x"FF0" when((Xpos >= 290 AND XPos < 300) AND (YPOS >= 110 AND YPOS < 120)) else
                    x"FF0" when((Xpos >= 290 AND XPos < 300) AND (YPOS >= 140 AND YPOS < 160)) else
                    x"FF0" when((Xpos >= 290 AND XPos < 300) AND (YPOS >= 180 AND YPOS < 200)) else
                    x"000";  
    Count5_line4 <= x"FF0" when((Xpos >= 300 AND XPos < 310) AND (YPOS >= 110 AND YPOS < 120)) else
                    x"FF0" when((Xpos >= 300 AND XPos < 310) AND (YPOS >= 140 AND YPOS < 160)) else
                    x"FF0" when((Xpos >= 300 AND XPos < 310) AND (YPOS >= 180 AND YPOS < 200)) else
                    x"000";              
    Count5_line5 <= x"FF0" when((Xpos >= 310 AND XPos < 320) AND (YPOS >= 110 AND YPOS < 120)) else
                    x"FF0" when((Xpos >= 310 AND XPos < 320) AND (YPOS >= 140 AND YPOS < 200)) else
                    x"000";  
    Count5_line6 <= x"FF0" when((Xpos >= 320 AND XPos < 330) AND (YPOS >= 110 AND YPOS < 120)) else
                    x"FF0" when((Xpos >= 320 AND XPos < 330) AND (YPOS >= 140 AND YPOS < 200)) else
                    x"000";     
-- Four
    Count4_line1 <= x"0FF" when((Xpos >= 270 AND XPos < 280) AND (YPOS >= 100 AND YPOS < 160)) else
                    x"000";
    Count4_line2 <= x"0FF" when((Xpos >= 280 AND XPos < 290) AND (YPOS >= 100 AND YPOS < 160)) else
                    x"000";
    Count4_line3 <= x"0FF" when((Xpos >= 290 AND XPos < 300) AND (YPOS >= 140 AND YPOS < 160)) else
                    x"000";  
    Count4_line4 <= x"0FF" when((Xpos >= 300 AND XPos < 310) AND (YPOS >= 140 AND YPOS < 160)) else
                    x"000";             
    Count4_line5 <= x"0FF" when((Xpos >= 310 AND XPos < 320) AND (YPOS >= 100 AND YPOS < 200)) else
                    x"000";  
    Count4_line6 <= x"0FF" when((Xpos >= 320 AND XPos < 330) AND (YPOS >= 100 AND YPOS < 200)) else
                    x"000";             
-- Three
    Count3_line1 <= x"FF0" when((Xpos >= 270 AND XPos < 280) AND (YPOS >= 100 AND YPOS < 120)) else
                    x"FF0" when((Xpos >= 270 AND XPos < 280) AND (YPOS >= 180 AND YPOS < 200)) else
                    x"000";
    Count3_line2 <= x"FF0" when((Xpos >= 280 AND XPos < 290) AND (YPOS >= 100 AND YPOS < 120)) else
                    x"FF0" when((Xpos >= 280 AND XPos < 290) AND (YPOS >= 140 AND YPOS < 160)) else
                    x"FF0" when((Xpos >= 280 AND XPos < 290) AND (YPOS >= 180 AND YPOS < 200)) else
                    x"000";
    Count3_line3 <= x"FF0" when((Xpos >= 290 AND XPos < 300) AND (YPOS >= 100 AND YPOS < 120)) else
                    x"FF0" when((Xpos >= 290 AND XPos < 300) AND (YPOS >= 140 AND YPOS < 160)) else
                    x"FF0" when((Xpos >= 290 AND XPos < 300) AND (YPOS >= 180 AND YPOS < 200)) else
                    x"000";  
    Count3_line4 <= x"FF0" when((Xpos >= 300 AND XPos < 310) AND (YPOS >= 100 AND YPOS < 120)) else
                    x"FF0" when((Xpos >= 300 AND XPos < 310) AND (YPOS >= 140 AND YPOS < 160)) else
                    x"FF0" when((Xpos >= 300 AND XPos < 310) AND (YPOS >= 180 AND YPOS < 200)) else
                    x"000";              
    Count3_line5 <= x"FF0" when((Xpos >= 310 AND XPos < 320) AND (YPOS >= 100 AND YPOS < 200)) else
                    x"000";  
    Count3_line6 <= x"FF0" when((Xpos >= 320 AND XPos < 330) AND (YPOS >= 100 AND YPOS < 200)) else
                    x"000";       
-- Two
    Count2_line1 <= x"0FF" when((Xpos >= 270 AND XPos < 280) AND (YPOS >= 100 AND YPOS < 120)) else
                    x"0FF" when((Xpos >= 270 AND XPos < 280) AND (YPOS >= 170 AND YPOS < 200)) else
                    x"000";
    Count2_line2 <= x"0FF" when((Xpos >= 280 AND XPos < 290) AND (YPOS >= 100 AND YPOS < 120)) else
                    x"0FF" when((Xpos >= 280 AND XPos < 290) AND (YPOS >= 150 AND YPOS < 200)) else
                    x"000";
    Count2_line3 <= x"0FF" when((Xpos >= 290 AND XPos < 300) AND (YPOS >= 100 AND YPOS < 120)) else
                    x"0FF" when((Xpos >= 290 AND XPos < 300) AND (YPOS >= 140 AND YPOS < 170)) else
                    x"0FF" when((Xpos >= 290 AND XPos < 300) AND (YPOS >= 180 AND YPOS < 200)) else
                    x"000";  
    Count2_line4 <= x"0FF" when((Xpos >= 300 AND XPos < 310) AND (YPOS >= 100 AND YPOS < 120)) else
                    x"0FF" when((Xpos >= 300 AND XPos < 310) AND (YPOS >= 130 AND YPOS < 160)) else
                    x"0FF" when((Xpos >= 300 AND XPos < 310) AND (YPOS >= 180 AND YPOS < 200)) else
                    x"000";             
    Count2_line5 <= x"0FF" when((Xpos >= 310 AND XPos < 320) AND (YPOS >= 100 AND YPOS < 150)) else
                    x"0FF" when((Xpos >= 310 AND XPos < 320) AND (YPOS >= 180 AND YPOS < 200)) else
                    x"000";  
    Count2_line6 <= x"0FF" when((Xpos >= 320 AND XPos < 330) AND (YPOS >= 100 AND YPOS < 140)) else
                    x"0FF" when((Xpos >= 320 AND XPos < 330) AND (YPOS >= 180 AND YPOS < 200)) else
                    x"000";
-- One
    Count1_line1 <= x"FF0" when((Xpos >= 270 AND XPos < 280) AND (YPOS >= 120 AND YPOS < 140)) else
                    x"FF0" when((Xpos >= 270 AND XPos < 280) AND (YPOS >= 180 AND YPOS < 200)) else
                    x"000";
    Count1_line2 <= x"FF0" when((Xpos >= 280 AND XPos < 290) AND (YPOS >= 110 AND YPOS < 140)) else
                    x"FF0" when((Xpos >= 280 AND XPos < 290) AND (YPOS >= 180 AND YPOS < 200)) else
                    x"000";
    Count1_line3 <= x"FF0" when((Xpos >= 290 AND XPos < 300) AND (YPOS >= 100 AND YPOS < 200)) else
                    x"000";  
    Count1_line4 <= x"FF0" when((Xpos >= 300 AND XPos < 310) AND (YPOS >= 100 AND YPOS < 200)) else
                    x"000";              
    Count1_line5 <= x"FF0" when((Xpos >= 310 AND XPos < 320) AND (YPOS >= 180 AND YPOS < 200)) else
                    x"000";  
    Count1_line6 <= x"FF0" when((Xpos >= 320 AND XPos < 330) AND (YPOS >= 200 AND YPOS < 200)) else
                    x"000"; 
-- Go
    CountGo_line1 <= x"0FF" when((Xpos >= 250 AND XPos < 260) AND (YPOS >= 100 AND YPOS < 200)) else
                     x"000";
    CountGo_line2 <= x"0FF" when((Xpos >= 260 AND XPos < 270) AND (YPOS >= 100 AND YPOS < 200)) else
                     x"000";
    CountGo_line3 <= x"0FF" when((Xpos >= 270 AND XPos < 280) AND (YPOS >= 100 AND YPOS < 120)) else
                     x"0FF" when((Xpos >= 270 AND XPos < 280) AND (YPOS >= 180 AND YPOS < 200)) else
                     x"000";  
    CountGo_line4 <= x"0FF" when((Xpos >= 280 AND XPos < 290) AND (YPOS >= 100 AND YPOS < 120)) else
                     x"0FF" when((Xpos >= 280 AND XPos < 290) AND (YPOS >= 160 AND YPOS < 200)) else
                     x"000";              
    CountGo_line5 <= x"0FF" when((Xpos >= 290 AND XPos < 300) AND (YPOS >= 100 AND YPOS < 120)) else
                     x"0FF" when((Xpos >= 290 AND XPos < 300) AND (YPOS >= 160 AND YPOS < 200)) else 
                     x"000";  
    CountGo_line6 <= x"000"; 
    CountGo_line7 <= x"0FF" when((Xpos >= 310 AND XPos < 320) AND (YPOS >= 100 AND YPOS < 200)) else
                     x"000";
    CountGo_line8 <= x"0FF" when((Xpos >= 320 AND XPos < 330) AND (YPOS >= 100 AND YPOS < 200)) else
                     x"000";
    CountGo_line9 <= x"0FF" when((Xpos >= 330 AND XPos < 340) AND (YPOS >= 100 AND YPOS < 120)) else
                     x"0FF" when((Xpos >= 330 AND XPos < 340) AND (YPOS >= 180 AND YPOS < 200)) else
                     x"000";  
    CountGo_line10 <= x"0FF" when((Xpos >= 340 AND XPos < 350) AND (YPOS >= 100 AND YPOS < 120)) else
                      x"0FF" when((Xpos >= 340 AND XPos < 350) AND (YPOS >= 180 AND YPOS < 200)) else
                      x"000";              
    CountGo_line11 <= x"0FF" when((Xpos >= 350 AND XPos < 360) AND (YPOS >= 100 AND YPOS < 200)) else
                      x"000";  
    CountGo_line12 <= x"0FF" when((Xpos >= 360 AND XPos < 370) AND (YPOS >= 100 AND YPOS < 200)) else
                      x"000"; 
-- Pause
    Pause1        <= x"0FF" when((Xpos >= 250 AND XPos < 260) AND (YPOS >= 110 AND YPOS < 190)) else
                     x"000";
    Pause2        <= x"0FF" when((Xpos >= 260 AND XPos < 270) AND (YPOS >= 100 AND YPOS < 200)) else
                     x"000";
    Pause3        <= x"0FF" when((Xpos >= 270 AND XPos < 280) AND (YPOS >= 100 AND YPOS < 130)) else
                     x"0FF" when((Xpos >= 270 AND XPos < 280) AND (YPOS >= 170 AND YPOS < 200)) else
                     x"FF0" when((Xpos >= 270 AND XPos < 280) AND (YPOS >= 130 AND YPOS < 170)) else
                     x"000";  
    Pause4        <= x"0FF" when((Xpos >= 280 AND XPos < 290) AND (YPOS >= 100 AND YPOS < 130)) else
                     x"0FF" when((Xpos >= 280 AND XPos < 290) AND (YPOS >= 170 AND YPOS < 200)) else
                     x"FF0" when((Xpos >= 280 AND XPos < 290) AND (YPOS >= 130 AND YPOS < 170)) else
                     x"000";              
    Pause5        <= x"0FF" when((Xpos >= 290 AND XPos < 300) AND (YPOS >= 100 AND YPOS < 200)) else 
                     x"000";  
    Pause6        <= x"0FF" when((Xpos >= 300 AND XPos < 310) AND (YPOS >= 100 AND YPOS < 200)) else
                     x"000"; 
    Pause7        <= x"0FF" when((Xpos >= 310 AND XPos < 320) AND (YPOS >= 100 AND YPOS < 130)) else
                     x"0FF" when((Xpos >= 310 AND XPos < 320) AND (YPOS >= 170 AND YPOS < 200)) else
                     x"FF0" when((Xpos >= 310 AND XPos < 320) AND (YPOS >= 130 AND YPOS < 170)) else
                     x"000";
    Pause8        <= x"0FF" when((Xpos >= 320 AND XPos < 330) AND (YPOS >= 100 AND YPOS < 130)) else
                     x"0FF" when((Xpos >= 320 AND XPos < 330) AND (YPOS >= 170 AND YPOS < 200)) else
                     x"FF0" when((Xpos >= 320 AND XPos < 330) AND (YPOS >= 130 AND YPOS < 170)) else
                     x"000";
    Pause9        <= x"0FF" when((Xpos >= 330 AND XPos < 340) AND (YPOS >= 100 AND YPOS < 200)) else
                     x"000";  
    Pause10       <= x"0FF" when((Xpos >= 340 AND XPos < 350) AND (YPOS >= 100 AND YPOS < 200)) else
                     x"000";                     
-- Title                                                          
    Title1      <= x"000";
    Title2      <= x"FF0" when ((XPos >= 190 AND XPos < 200) AND (YPOS >= 10 AND YPOS < 90)) else
                   x"0FF" when ((XPos >= 190 AND XPos < 200) AND (YPOS >= 110 AND YPOS < 190)) else
                   x"000";
    Title3      <= x"FF0" when ((XPos >= 200 AND XPos < 210) AND (YPOS >= 10 AND YPOS < 20)) else
                   x"FF0" when ((XPos >= 200 AND XPos < 210) AND (YPOS >= 40 AND YPOS < 50)) else
                   x"FF0" when ((XPos >= 200 AND XPos < 210) AND (YPOS >= 80 AND YPOS < 90)) else
                   x"0FF" when ((XPos >= 200 AND XPos < 210) AND (YPOS >= 110 AND YPOS < 120)) else
                   x"0FF" when ((XPos >= 200 AND XPos < 210) AND (YPOS >= 140 AND YPOS < 150)) else
                   x"000";
    Title4      <= x"FF0" when ((XPos >= 210 AND XPos < 220) AND (YPOS >= 10 AND YPOS < 20)) else
                   x"FF0" when ((XPos >= 210 AND XPos < 220) AND (YPOS >= 40 AND YPOS < 50)) else
                   x"FF0" when ((XPos >= 210 AND XPos < 220) AND (YPOS >= 80 AND YPOS < 90)) else
                   x"0FF" when ((XPos >= 210 AND XPos < 220) AND (YPOS >= 110 AND YPOS < 120)) else
                   x"0FF" when ((XPos >= 210 AND XPos < 220) AND (YPOS >= 140 AND YPOS < 150)) else
                   x"000";
    Title5      <= x"FF0" when ((XPos >= 220 AND XPos < 230) AND (YPOS >= 10 AND YPOS < 40)) else
                   x"FF0" when ((XPos >= 220 AND XPos < 230) AND (YPOS >= 50 AND YPOS < 90)) else
                   x"0FF" when ((XPos >= 220 AND XPos < 230) AND (YPOS >= 110 AND YPOS < 120)) else
                   x"000";    
    Title6      <= x"000"; 
    Title7      <= x"FF0" when ((XPos >= 240 AND XPos < 250) AND (YPOS >= 10 AND YPOS < 90)) else
                   x"0FF" when ((XPos >= 240 AND XPos < 250) AND (YPOS >= 110 AND YPOS < 190)) else
                   x"000"; 
    Title8      <= x"FF0" when ((XPos >= 250 AND XPos < 260) AND (YPOS >= 10 AND YPOS < 20)) else
                   x"FF0" when ((XPos >= 250 AND XPos < 260) AND (YPOS >= 50 AND YPOS < 70)) else
                   x"0FF" when ((XPos >= 250 AND XPos < 260) AND (YPOS >= 110 AND YPOS < 120)) else
                   x"0FF" when ((XPos >= 250 AND XPos < 260) AND (YPOS >= 180 AND YPOS < 190)) else
                   x"000";    
    Title9      <= x"FF0" when ((XPos >= 260 AND XPos < 270) AND (YPOS >= 10 AND YPOS < 20)) else
                   x"FF0" when ((XPos >= 260 AND XPos < 270) AND (YPOS >= 50 AND YPOS < 70)) else
                   x"0FF" when ((XPos >= 260 AND XPos < 270) AND (YPOS >= 110 AND YPOS < 120)) else
                   x"0FF" when ((XPos >= 260 AND XPos < 270) AND (YPOS >= 180 AND YPOS < 190)) else
                   x"000";   
    Title10     <= x"FF0" when ((XPos >= 270 AND XPos < 280) AND (YPOS >= 10 AND YPOS < 50)) else
                   x"FF0" when ((XPos >= 270 AND XPos < 280) AND (YPOS >= 60 AND YPOS < 90)) else
                   x"0FF" when ((XPos >= 270 AND XPos < 280) AND (YPOS >= 110 AND YPOS < 190)) else
                   x"000";
    Title11     <= x"000";
    Title12     <= x"FF0" when ((XPos >= 290 AND XPos < 300) AND (YPOS >= 10 AND YPOS < 90)) else
                   x"0FF" when ((XPos >= 290 AND XPos < 300) AND (YPOS >= 110 AND YPOS < 190)) else
                   x"000";  
    Title13     <= x"FF0" when ((XPos >= 300 AND XPos < 310) AND (YPOS >= 80 AND YPOS < 90)) else
                   x"0FF" when ((XPos >= 300 AND XPos < 310) AND (YPOS >= 110 AND YPOS < 120)) else
                   x"0FF" when ((XPos >= 300 AND XPos < 310) AND (YPOS >= 150 AND YPOS < 170)) else
                   x"000";  
    Title14     <= x"FF0" when ((XPos >= 310 AND XPos < 320) AND (YPOS >= 80 AND YPOS < 90)) else
                   x"0FF" when ((XPos >= 310 AND XPos < 320) AND (YPOS >= 110 AND YPOS < 120)) else
                   x"0FF" when ((XPos >= 310 AND XPos < 320) AND (YPOS >= 150 AND YPOS < 170)) else
                   x"000";    
    Title15     <= x"FF0" when ((XPos >= 320 AND XPos < 330) AND (YPOS >= 10 AND YPOS < 90)) else
                   x"0FF" when ((XPos >= 320 AND XPos < 330) AND (YPOS >= 110 AND YPOS < 150)) else
                   x"0FF" when ((XPos >= 320 AND XPos < 330) AND (YPOS >= 160 AND YPOS < 190)) else
                   x"000";
    Title16     <= x"000";
    Title17     <= x"FF0" when ((XPos >= 340 AND XPos < 350) AND (YPOS >= 10 AND YPOS < 20)) else
                   x"0FF" when ((XPos >= 340 AND XPos < 350) AND (YPOS >= 110 AND YPOS < 190)) else
                   x"000"; 
    Title18     <= x"FF0" when ((XPos >= 350 AND XPos < 360) AND (YPOS >= 10 AND YPOS < 20)) else
                   x"0FF" when ((XPos >= 350 AND XPos < 360) AND (YPOS >= 110 AND YPOS < 120)) else
                   x"0FF" when ((XPos >= 350 AND XPos < 360) AND (YPOS >= 180 AND YPOS < 190)) else
                   x"000";
    Title19     <= x"FF0" when ((XPos >= 360 AND XPos < 370) AND (YPOS >= 10 AND YPOS < 90)) else
                   x"0FF" when ((XPos >= 360 AND XPos < 370) AND (YPOS >= 110 AND YPOS < 120)) else
                   x"0FF" when ((XPos >= 360 AND XPos < 370) AND (YPOS >= 180 AND YPOS < 190)) else
                   x"000";
    Title20     <= x"FF0" when ((XPos >= 370 AND XPos < 380) AND (YPOS >= 10 AND YPOS < 20)) else
                   x"0FF" when ((XPos >= 370 AND XPos < 380) AND (YPOS >= 110 AND YPOS < 120)) else
                   x"0FF" when ((XPos >= 370 AND XPos < 380) AND (YPOS >= 180 AND YPOS < 190)) else
                   x"000";
    Title21     <= x"FF0" when ((XPos >= 380 AND XPos < 390) AND (YPOS >= 10 AND YPOS < 20)) else
                   x"000";
    Title22     <= x"000";
    Title23     <= x"FF0" when ((XPos >= 400 AND XPos < 410) AND (YPOS >= 10 AND YPOS < 90)) else
                   x"0FF" when ((XPos >= 400 AND XPos < 410) AND (YPOS >= 110 AND YPOS < 190)) else
                   x"000";
    Title24     <= x"FF0" when ((XPos >= 410 AND XPos < 420) AND (YPOS >= 10 AND YPOS < 20)) else
                   x"FF0" when ((XPos >= 410 AND XPos < 420) AND (YPOS >= 45 AND YPOS < 55)) else
                   x"FF0" when ((XPos >= 410 AND XPos < 420) AND (YPOS >= 80 AND YPOS < 90)) else
                   x"0FF" when ((XPos >= 410 AND XPos < 420) AND (YPOS >= 110 AND YPOS < 120)) else
                   x"0FF" when ((XPos >= 410 AND XPos < 420) AND (YPOS >= 145 AND YPOS < 155)) else
                   x"0FF" when ((XPos >= 410 AND XPos < 420) AND (YPOS >= 180 AND YPOS < 190)) else
                   x"000";
    Title25     <= x"FF0" when ((XPos >= 420 AND XPos < 430) AND (YPOS >= 10 AND YPOS < 20)) else
                   x"FF0" when ((XPos >= 420 AND XPos < 430) AND (YPOS >= 45 AND YPOS < 55)) else
                   x"FF0" when ((XPos >= 420 AND XPos < 430) AND (YPOS >= 80 AND YPOS < 90)) else
                   x"0FF" when ((XPos >= 420 AND XPos < 430) AND (YPOS >= 110 AND YPOS < 120)) else
                   x"0FF" when ((XPos >= 420 AND XPos < 430) AND (YPOS >= 145 AND YPOS < 155)) else
                   x"0FF" when ((XPos >= 420 AND XPos < 430) AND (YPOS >= 180 AND YPOS < 190)) else
                   x"000";      
    Title26     <= x"FF0" when ((XPos >= 430 AND XPos < 440) AND (YPOS >= 10 AND YPOS < 20)) else
                   x"FF0" when ((XPos >= 430 AND XPos < 440) AND (YPOS >= 80 AND YPOS < 90)) else
                   x"0FF" when ((XPos >= 430 AND XPos < 440) AND (YPOS >= 110 AND YPOS < 120)) else
                   x"0FF" when ((XPos >= 430 AND XPos < 440) AND (YPOS >= 180 AND YPOS < 190)) else
                   x"000";
-- Game Over
    GameOver1      <= x"FF0" when ((XPos >= 170 AND XPos < 180) AND (YPOS >= 10 AND YPOS < 100)) else
                      x"0FF" when ((XPos >= 170 AND XPos < 180) AND (YPOS >= 110 AND YPOS < 190)) else
                      x"000";
    GameOver2      <= x"FF0" when ((XPos >= 180 AND XPos < 190) AND (YPOS >= 10 AND YPOS < 100)) else
                      x"0FF" when ((XPos >= 180 AND XPos < 190) AND (YPOS >= 110 AND YPOS < 190)) else
                      x"000";
    GameOver3      <= x"FF0" when ((XPos >= 190 AND XPos < 200) AND (YPOS >= 10 AND YPOS < 30)) else
                      x"FF0" when ((XPos >= 190 AND XPos < 200) AND (YPOS >= 80 AND YPOS < 100)) else
                      x"0FF" when ((XPos >= 190 AND XPos < 200) AND (YPOS >= 110 AND YPOS < 130)) else
                      x"0FF" when ((XPos >= 190 AND XPos < 200) AND (YPOS >= 170 AND YPOS < 190)) else
                      x"000";
    GameOver4      <= x"FF0" when ((XPos >= 200 AND XPos < 210) AND (YPOS >= 10 AND YPOS < 30)) else
                      x"FF0" when ((XPos >= 200 AND XPos < 210) AND (YPOS >= 50 AND YPOS < 70)) else
                      x"FF0" when ((XPos >= 200 AND XPos < 210) AND (YPOS >= 80 AND YPOS < 100)) else
                      x"0FF" when ((XPos >= 200 AND XPos < 210) AND (YPOS >= 110 AND YPOS < 130)) else
                      x"0FF" when ((XPos >= 200 AND XPos < 210) AND (YPOS >= 170 AND YPOS < 190)) else
                      x"000";
    GameOver5      <= x"FF0" when ((XPos >= 210 AND XPos < 220) AND (YPOS >= 10 AND YPOS < 30)) else
                      x"FF0" when ((XPos >= 210 AND XPos < 220) AND (YPOS >= 50 AND YPOS < 100)) else
                      x"0FF" when ((XPos >= 210 AND XPos < 220) AND (YPOS >= 110 AND YPOS < 190)) else
                      x"000";
    GameOver6      <= x"FF0" when ((XPos >= 220 AND XPos < 230) AND (YPOS >= 10 AND YPOS < 30)) else
                      x"FF0" when ((XPos >= 220 AND XPos < 230) AND (YPOS >= 50 AND YPOS < 100)) else
                      x"0FF" when ((XPos >= 220 AND XPos < 230) AND (YPOS >= 110 AND YPOS < 190)) else
                      x"000";    
    GameOver7      <= x"000"; 
    GameOver8      <= x"FF0" when ((XPos >= 240 AND XPos < 250) AND (YPOS >= 10 AND YPOS < 100)) else
                      x"0FF" when ((XPos >= 240 AND XPos < 250) AND (YPOS >= 110 AND YPOS < 180)) else
                      x"000"; 
    GameOver9      <= x"FF0" when ((XPos >= 250 AND XPos < 260) AND (YPOS >= 10 AND YPOS < 100)) else
                      x"0FF" when ((XPos >= 250 AND XPos < 260) AND (YPOS >= 110 AND YPOS < 190)) else
                      x"000";    
    GameOver10     <= x"FF0" when ((XPos >= 260 AND XPos < 270) AND (YPOS >= 10 AND YPOS < 30)) else
                      x"FF0" when ((XPos >= 260 AND XPos < 270) AND (YPOS >= 60 AND YPOS < 80)) else
                      x"0FF" when ((XPos >= 260 AND XPos < 270) AND (YPOS >= 170 AND YPOS < 190)) else
                      x"000";   
    GameOver11     <= x"FF0" when ((XPos >= 270 AND XPos < 280) AND (YPOS >= 10 AND YPOS < 30)) else
                      x"FF0" when ((XPos >= 270 AND XPos < 280) AND (YPOS >= 60 AND YPOS < 80)) else
                      x"0FF" when ((XPos >= 270 AND XPos < 280) AND (YPOS >= 170 AND YPOS < 190)) else
                      x"000";
    GameOver12     <= x"FF0" when ((XPos >= 280 AND XPos < 290) AND (YPOS >= 10 AND YPOS < 100)) else
                      x"0FF" when ((XPos >= 280 AND XPos < 290) AND (YPOS >= 110 AND YPOS < 190)) else
                      x"000";
    GameOver13     <= x"FF0" when ((XPos >= 290 AND XPos < 300) AND (YPOS >= 10 AND YPOS < 100)) else
                      x"0FF" when ((XPos >= 290 AND XPos < 300) AND (YPOS >= 110 AND YPOS < 180)) else
                      x"000";  
    GameOver14     <= x"000";  
    GameOver15     <= x"FF0" when ((XPos >= 310 AND XPos < 320) AND (YPOS >= 10 AND YPOS < 100)) else
                      x"0FF" when ((XPos >= 310 AND XPos < 320) AND (YPOS >= 110 AND YPOS < 190)) else
                      x"000";    
    GameOver16     <= x"FF0" when ((XPos >= 320 AND XPos < 330) AND (YPOS >= 10 AND YPOS < 100)) else
                      x"0FF" when ((XPos >= 320 AND XPos < 330) AND (YPOS >= 110 AND YPOS < 190)) else
                      x"000";
    GameOver17     <= x"FF0" when ((XPos >= 330 AND XPos < 340) AND (YPOS >= 10 AND YPOS < 70)) else
                      x"0FF" when ((XPos >= 330 AND XPos < 340) AND (YPOS >= 110 AND YPOS < 130)) else
                      x"0FF" when ((XPos >= 330 AND XPos < 340) AND (YPOS >= 140 AND YPOS < 160)) else
                      x"0FF" when ((XPos >= 330 AND XPos < 340) AND (YPOS >= 170 AND YPOS < 190)) else
                      x"000";
    GameOver18     <= x"FF0" when ((XPos >= 340 AND XPos < 350) AND (YPOS >= 20 AND YPOS < 80)) else
                      x"0FF" when ((XPos >= 340 AND XPos < 350) AND (YPOS >= 110 AND YPOS < 130)) else
                      x"0FF" when ((XPos >= 340 AND XPos < 350) AND (YPOS >= 140 AND YPOS < 160)) else
                      x"0FF" when ((XPos >= 340 AND XPos < 350) AND (YPOS >= 170 AND YPOS < 190)) else
                      x"000"; 
    GameOver19     <= x"FF0" when ((XPos >= 350 AND XPos < 360) AND (YPOS >= 10 AND YPOS < 70)) else
                      x"0FF" when ((XPos >= 350 AND XPos < 360) AND (YPOS >= 110 AND YPOS < 130)) else
                      x"0FF" when ((XPos >= 350 AND XPos < 360) AND (YPOS >= 140 AND YPOS < 160)) else
                      x"0FF" when ((XPos >= 350 AND XPos < 360) AND (YPOS >= 170 AND YPOS < 190)) else
                      x"000";
    GameOver20     <= x"FF0" when ((XPos >= 360 AND XPos < 370) AND (YPOS >= 10 AND YPOS < 100)) else
                      x"0FF" when ((XPos >= 360 AND XPos < 370) AND (YPOS >= 110 AND YPOS < 130)) else
                      x"0FF" when ((XPos >= 360 AND XPos < 370) AND (YPOS >= 170 AND YPOS < 190)) else
                      x"000";
    GameOver21     <= x"FF0" when ((XPos >= 370 AND XPos < 380) AND (YPOS >= 10 AND YPOS < 100)) else
                      x"000";
    GameOver22     <= x"000";

    GameOver23     <= x"FF0" when ((XPos >= 390 AND XPos < 400) AND (YPOS >= 10 AND YPOS < 100)) else
                      x"0FF" when ((XPos >= 390 AND XPos < 400) AND (YPOS >= 110 AND YPOS < 190)) else
                      x"000";
    GameOver24     <= x"FF0" when ((XPos >= 400 AND XPos < 410) AND (YPOS >= 10 AND YPOS < 100)) else
                      x"0FF" when ((XPos >= 400 AND XPos < 410) AND (YPOS >= 110 AND YPOS < 190)) else
                      x"000";
    GameOver25     <= x"FF0" when ((XPos >= 410 AND XPos < 420) AND (YPOS >= 10 AND YPOS < 30)) else
                      x"FF0" when ((XPos >= 410 AND XPos < 420) AND (YPOS >= 45 AND YPOS < 65)) else
                      x"FF0" when ((XPos >= 410 AND XPos < 420) AND (YPOS >= 80 AND YPOS < 100)) else
                      x"0FF" when ((XPos >= 410 AND XPos < 420) AND (YPOS >= 110 AND YPOS < 130)) else
                      x"0FF" when ((XPos >= 410 AND XPos < 420) AND (YPOS >= 140 AND YPOS < 160)) else
                      x"000";      
    GameOver26     <= x"FF0" when ((XPos >= 420 AND XPos < 430) AND (YPOS >= 10 AND YPOS < 30)) else
                      x"FF0" when ((XPos >= 420 AND XPos < 430) AND (YPOS >= 45 AND YPOS < 65)) else
                      x"FF0" when ((XPos >= 420 AND XPos < 430) AND (YPOS >= 80 AND YPOS < 100)) else
                      x"0FF" when ((XPos >= 420 AND XPos < 430) AND (YPOS >= 110 AND YPOS < 130)) else
                      x"0FF" when ((XPos >= 420 AND XPos < 430) AND (YPOS >= 140 AND YPOS < 180)) else
                      x"000"; 
    GameOver27     <= x"FF0" when ((XPos >= 430 AND XPos < 440) AND (YPOS >= 10 AND YPOS < 30)) else
                      x"FF0" when ((XPos >= 430 AND XPos < 440) AND (YPOS >= 45 AND YPOS < 65)) else
                      x"FF0" when ((XPos >= 430 AND XPos < 440) AND (YPOS >= 80 AND YPOS < 100)) else
                      x"0FF" when ((XPos >= 430 AND XPos < 440) AND (YPOS >= 110 AND YPOS < 160)) else
                      x"0FF" when ((XPos >= 430 AND XPos < 440) AND (YPOS >= 170 AND YPOS < 190)) else
                      x"000"; 
    GameOver28     <= x"FF0" when ((XPos >= 440 AND XPos < 450) AND (YPOS >= 10 AND YPOS < 30)) else
                      x"FF0" when ((XPos >= 440 AND XPos < 450) AND (YPOS >= 80 AND YPOS < 100)) else
                      x"0FF" when ((XPos >= 440 AND XPos < 450) AND (YPOS >= 110 AND YPOS < 160)) else
                      x"0FF" when ((XPos >= 440 AND XPos < 450) AND (YPOS >= 180 AND YPOS < 190)) else
                      x"000";                                                        
    Player_Health_Bar1    <= x"FF0" when ((XPos >= 160 AND XPos < 170) AND (YPOS >= 210 AND YPOS < 220)) else
                              x"000";
    Player_Health_Bar2    <= x"FF0" when ((XPos >= 170 AND XPos < 180) AND (YPOS >= 200 AND YPOS < 210)) else
                              x"0FF" when ((XPos >= 170 AND XPos < 180) AND (YPOS >= 210 AND YPOS < 220)) else
                              x"FF0" when ((XPos >= 170 AND XPos < 180) AND (YPOS >= 220 AND YPOS < 230)) else
                              x"000";
    Player_Health_Bar3    <= x"FF0" when ((XPos >= 180 AND XPos < 190) AND (YPOS >= 200 AND YPOS < 210)) else
                              x"0FF" when ((XPos >= 180 AND XPos < 190) AND (YPOS >= 210 AND YPOS < 220)) else
                              x"FF0" when ((XPos >= 180 AND XPos < 190) AND (YPOS >= 220 AND YPOS < 230)) else
                              x"000";
    Player_Health_Bar4    <= x"FF0" when ((XPos >= 190 AND XPos < 200) AND (YPOS >= 200 AND YPOS < 210)) else
                              x"0FF" when ((XPos >= 190 AND XPos < 200) AND (YPOS >= 210 AND YPOS < 220)) else
                              x"FF0" when ((XPos >= 190 AND XPos < 200) AND (YPOS >= 220 AND YPOS < 230)) else
                              x"000";
    Player_Health_Bar5    <= x"FF0" when ((XPos >= 200 AND XPos < 210) AND (YPOS >= 200 AND YPOS < 210)) else
                              x"0FF" when ((XPos >= 200 AND XPos < 210) AND (YPOS >= 210 AND YPOS < 220)) else
                              x"FF0" when ((XPos >= 200 AND XPos < 210) AND (YPOS >= 220 AND YPOS < 230)) else
                              x"000";
    Player_Health_Bar6    <= x"FF0" when ((XPos >= 210 AND XPos < 220) AND (YPOS >= 200 AND YPOS < 210)) else
                              x"0FF" when ((XPos >= 210 AND XPos < 220) AND (YPOS >= 210 AND YPOS < 220)) else
                              x"FF0" when ((XPos >= 210 AND XPos < 220) AND (YPOS >= 220 AND YPOS < 230)) else
                              x"000";
    Player_Health_Bar7    <= x"FF0" when ((XPos >= 220 AND XPos < 230) AND (YPOS >= 200 AND YPOS < 210)) else
                              x"0FF" when ((XPos >= 220 AND XPos < 230) AND (YPOS >= 210 AND YPOS < 220)) else
                              x"FF0" when ((XPos >= 220 AND XPos < 230) AND (YPOS >= 220 AND YPOS < 230)) else
                              x"000";
    Player_Health_Bar8    <= x"FF0" when ((XPos >= 230 AND XPos < 240) AND (YPOS >= 200 AND YPOS < 210)) else
                              x"0FF" when ((XPos >= 230 AND XPos < 240) AND (YPOS >= 210 AND YPOS < 220)) else
                              x"FF0" when ((XPos >= 230 AND XPos < 240) AND (YPOS >= 220 AND YPOS < 230)) else
                              x"000";
    Player_Health_Bar9    <= x"FF0" when ((XPos >= 240 AND XPos < 250) AND (YPOS >= 200 AND YPOS < 210)) else
                              x"0FF" when ((XPos >= 240 AND XPos < 250) AND (YPOS >= 210 AND YPOS < 220)) else
                              x"FF0" when ((XPos >= 240 AND XPos < 250) AND (YPOS >= 220 AND YPOS < 230)) else
                              x"000";
    Player_Health_Bar10   <= x"FF0" when ((XPos >= 250 AND XPos < 260) AND (YPOS >= 200 AND YPOS < 210)) else
                              x"0FF" when ((XPos >= 250 AND XPos < 260) AND (YPOS >= 210 AND YPOS < 220)) else
                              x"FF0" when ((XPos >= 250 AND XPos < 260) AND (YPOS >= 220 AND YPOS < 230)) else
                              x"000";
    Player_Health_Bar11   <= x"FF0" when ((XPos >= 260 AND XPos < 270) AND (YPOS >= 200 AND YPOS < 210)) else
                              x"0FF" when ((XPos >= 260 AND XPos < 270) AND (YPOS >= 210 AND YPOS < 220)) else
                              x"FF0" when ((XPos >= 260 AND XPos < 270) AND (YPOS >= 220 AND YPOS < 230)) else
                              x"000";
    Player_Health_Bar12   <= x"FF0" when ((XPos >= 270 AND XPos < 280) AND (YPOS >= 210 AND YPOS < 220)) else
                             x"000";
-- CPU Health Bar
    CPU_Health_Bar1    <= x"FF0" when ((XPos >= 340 AND XPos < 350) AND (YPOS >= 210 AND YPOS < 220)) else
                          x"000";
    CPU_Health_Bar2    <= x"FF0" when ((XPos >= 350 AND XPos < 360) AND (YPOS >= 200 AND YPOS < 210)) else
                          x"0FF" when ((XPos >= 350 AND XPos < 360) AND (YPOS >= 210 AND YPOS < 220)) else
                          x"FF0" when ((XPos >= 350 AND XPos < 360) AND (YPOS >= 220 AND YPOS < 230)) else
                          x"000";
    CPU_Health_Bar3    <= x"FF0" when ((XPos >= 360 AND XPos < 370) AND (YPOS >= 200 AND YPOS < 210)) else
                          x"0FF" when ((XPos >= 360 AND XPos < 370) AND (YPOS >= 210 AND YPOS < 220)) else
                          x"FF0" when ((XPos >= 360 AND XPos < 370) AND (YPOS >= 220 AND YPOS < 230)) else
                          x"000";
    CPU_Health_Bar4    <= x"FF0" when ((XPos >= 370 AND XPos < 380) AND (YPOS >= 200 AND YPOS < 210)) else
                          x"0FF" when ((XPos >= 370 AND XPos < 380) AND (YPOS >= 210 AND YPOS < 220)) else
                          x"FF0" when ((XPos >= 370 AND XPos < 380) AND (YPOS >= 220 AND YPOS < 230)) else
                          x"000";
    CPU_Health_Bar5    <= x"FF0" when ((XPos >= 380 AND XPos < 390) AND (YPOS >= 200 AND YPOS < 210)) else
                          x"0FF" when ((XPos >= 380 AND XPos < 390) AND (YPOS >= 210 AND YPOS < 220)) else
                          x"FF0" when ((XPos >= 380 AND XPos < 390) AND (YPOS >= 220 AND YPOS < 230)) else
                          x"000";
    CPU_Health_Bar6    <= x"FF0" when ((XPos >= 390 AND XPos < 400) AND (YPOS >= 200 AND YPOS < 210)) else
                          x"0FF" when ((XPos >= 390 AND XPos < 400) AND (YPOS >= 210 AND YPOS < 220)) else
                          x"FF0" when ((XPos >= 390 AND XPos < 400) AND (YPOS >= 220 AND YPOS < 230)) else
                          x"000";
    CPU_Health_Bar7    <= x"FF0" when ((XPos >= 400 AND XPos < 410) AND (YPOS >= 200 AND YPOS < 210)) else
                          x"0FF" when ((XPos >= 400 AND XPos < 410) AND (YPOS >= 210 AND YPOS < 220)) else
                          x"FF0" when ((XPos >= 400 AND XPos < 410) AND (YPOS >= 220 AND YPOS < 230)) else
                          x"000";
    CPU_Health_Bar8    <= x"FF0" when ((XPos >= 410 AND XPos < 420) AND (YPOS >= 200 AND YPOS < 210)) else
                          x"0FF" when ((XPos >= 410 AND XPos < 420) AND (YPOS >= 210 AND YPOS < 220)) else
                          x"FF0" when ((XPos >= 410 AND XPos < 420) AND (YPOS >= 220 AND YPOS < 230)) else
                          x"000";
    CPU_Health_Bar9    <= x"FF0" when ((XPos >= 420 AND XPos < 430) AND (YPOS >= 200 AND YPOS < 210)) else
                          x"0FF" when ((XPos >= 420 AND XPos < 430) AND (YPOS >= 210 AND YPOS < 220)) else
                          x"FF0" when ((XPos >= 420 AND XPos < 430) AND (YPOS >= 220 AND YPOS < 230)) else
                          x"000";
    CPU_Health_Bar10   <= x"FF0" when ((XPos >= 430 AND XPos < 440) AND (YPOS >= 200 AND YPOS < 210)) else
                          x"0FF" when ((XPos >= 430 AND XPos < 440) AND (YPOS >= 210 AND YPOS < 220)) else
                          x"FF0" when ((XPos >= 430 AND XPos < 440) AND (YPOS >= 220 AND YPOS < 230)) else
                          x"000";
    CPU_Health_Bar11   <= x"FF0" when ((XPos >= 440 AND XPos < 450) AND (YPOS >= 200 AND YPOS < 210)) else
                          x"0FF" when ((XPos >= 440 AND XPos < 450) AND (YPOS >= 210 AND YPOS < 220)) else
                          x"FF0" when ((XPos >= 440 AND XPos < 450) AND (YPOS >= 220 AND YPOS < 230)) else
                          x"000";
    CPU_Health_Bar12   <= x"FF0" when ((XPos >= 450 AND XPos < 460) AND (YPOS >= 210 AND YPOS < 220)) else
                          x"000";
                          
-- CPU Player Punching
   CPU_Punch1      <= x"000";
   CPU_Punch2      <= x"488" when ((XPos >= 310 AND XPos < 320) AND (YPOS >= 350 AND YPOS < 360)) else
                       x"377" when ((XPos >= 310 AND XPos < 320) AND (YPOS >= 360 AND YPOS < 370)) else 
                       x"000";
   CPU_Punch3      <= x"488" when ((XPos >= 320 AND XPos < 330) AND (YPOS >= 350 AND YPOS < 370)) else 
                       x"000";
   CPU_Punch4      <= x"377" when ((XPos >= 330 AND XPos < 340) AND (YPOS >= 360 AND YPOS < 370)) else 
                       x"000";
   CPU_Punch5      <= x"377" when ((XPos >= 340 AND XPos < 350) AND (YPOS >= 360 AND YPOS < 370)) else 
                       x"000";
   CPU_Punch6      <= x"488" when ((XPos >= 350 AND XPos < 360) AND (YPOS >= 320 AND YPOS < 340)) else
                       x"377" when ((XPos >= 350 AND XPos < 360) AND (YPOS >= 360 AND YPOS < 370)) else 
                       x"488" when ((XPos >= 350 AND XPos < 360) AND (YPOS >= 370 AND YPOS < 380)) else   
                       x"000";
   CPU_Punch7      <= x"488" when ((XPos >= 360 AND XPos < 370) AND (YPOS >= 300 AND YPOS < 320)) else
                       x"B22" when ((XPos >= 360 AND XPos < 370) AND (YPOS >= 320 AND YPOS < 330)) else 
                       x"488" when ((XPos >= 360 AND XPos < 370) AND (YPOS >= 330 AND YPOS < 350)) else
                       x"377" when ((XPos >= 360 AND XPos < 370) AND (YPOS >= 360 AND YPOS < 390)) else
                       x"488" when ((XPos >= 360 AND XPos < 370) AND (YPOS >= 410 AND YPOS < 420)) else
                       x"266" when ((XPos >= 360 AND XPos < 370) AND (YPOS >= 440 AND YPOS < 450)) else  
                       x"000";
   CPU_Punch8      <= x"377" when ((XPos >= 370 AND XPos < 380) AND (YPOS >= 300 AND YPOS < 320)) else
                       x"D44" when ((XPos >= 370 AND XPos < 380) AND (YPOS >= 320 AND YPOS < 330)) else
                       x"488" when ((XPos >= 370 AND XPos < 380) AND (YPOS >= 330 AND YPOS < 360)) else
                       x"377" when ((XPos >= 370 AND XPos < 380) AND (YPOS >= 360 AND YPOS < 370)) else 
                       x"488" when ((XPos >= 370 AND XPos < 380) AND (YPOS >= 370 AND YPOS < 380)) else
                       x"488" when ((XPos >= 370 AND XPos < 380) AND (YPOS >= 400 AND YPOS < 420)) else
                       x"488" when ((XPos >= 370 AND XPos < 380) AND (YPOS >= 420 AND YPOS < 430)) else
                       x"266" when ((XPos >= 370 AND XPos < 380) AND (YPOS >= 430 AND YPOS < 450)) else
                       x"000";   
    CPU_Punch9     <= x"377" when ((XPos >= 380 AND XPos < 390) AND (YPOS >= 300 AND YPOS < 340)) else
                       x"488" when ((XPos >= 380 AND XPos < 390) AND (YPOS >= 340 AND YPOS < 400)) else
                       x"377" when ((XPos >= 380 AND XPos < 390) AND (YPOS >= 400 AND YPOS < 410)) else
                       x"D44" when ((XPos >= 380 AND XPos < 390) AND (YPOS >= 410 AND YPOS < 430)) else
                       x"266" when ((XPos >= 380 AND XPos < 390) AND (YPOS >= 430 AND YPOS < 450)) else
                       x"000";  
    CPU_Punch10    <= x"266" when ((XPos >= 390 AND XPos < 400) AND (YPOS >= 310 AND YPOS < 320)) else
                       x"377" when ((XPos >= 390 AND XPos < 400) AND (YPOS >= 320 AND YPOS < 340)) else
                       x"488" when ((XPos >= 390 AND XPos < 400) AND (YPOS >= 340 AND YPOS < 370)) else 
                       x"377" when ((XPos >= 390 AND XPos < 400) AND (YPOS >= 370 AND YPOS < 400)) else
                       x"C33" when ((XPos >= 390 AND XPos < 400) AND (YPOS >= 400 AND YPOS < 430)) else
                       x"000"; 
    CPU_Punch11    <= x"266" when ((XPos >= 400 AND XPos < 410) AND (YPOS >= 340 AND YPOS < 350)) else 
                       x"377" when ((XPos >= 400 AND XPos < 410) AND (YPOS >= 350 AND YPOS < 400)) else
                       x"C33" when ((XPos >= 400 AND XPos < 410) AND (YPOS >= 400 AND YPOS < 420)) else
                       x"000";
    CPU_Punch12    <= x"377" when ((XPos >= 410 AND XPos < 420) AND (YPOS >= 350 AND YPOS < 390)) else
                       x"B22" when ((XPos >= 410 AND XPos < 420) AND (YPOS >= 390 AND YPOS < 410)) else
                       x"C33" when ((XPos >= 410 AND XPos < 420) AND (YPOS >= 410 AND YPOS < 420)) else
                       x"D44" when ((XPos >= 410 AND XPos < 420) AND (YPOS >= 420 AND YPOS < 430)) else 
                       x"266" when ((XPos >= 410 AND XPos < 420) AND (YPOS >= 430 AND YPOS < 450)) else
                       x"000";
    CPU_Punch13    <= x"266" when ((XPos >= 420 AND XPos < 430) AND (YPOS >= 350 AND YPOS < 390)) else 
                       x"B22" when ((XPos >= 420 AND XPos < 430) AND (YPOS >= 390 AND YPOS < 430)) else
                       x"266" when ((XPos >= 420 AND XPos < 430) AND (YPOS >= 430 AND YPOS < 450)) else 
                       x"000";
    CPU_Punch14    <= x"B22" when ((XPos >= 430 AND XPos < 440) AND (YPOS >= 390 AND YPOS < 430)) else  
                       x"000";
    CPU_Punch15    <= x"000";

-- CPU Player Idle
   CPU_Idle1      <= x"000";
   CPU_Idle2      <= x"000";
   CPU_Idle3      <= x"000";
   CPU_Idle4      <= x"488" when ((XPos >= 330 AND XPos < 340) AND (YPOS >= 390 AND YPOS < 410)) else 
                     x"000";
   CPU_Idle5      <= x"377" when ((XPos >= 340 AND XPos < 350) AND (YPOS >= 390 AND YPOS < 400)) else 
                     x"488" when ((XPos >= 340 AND XPos < 350) AND (YPOS >= 400 AND YPOS < 410)) else
                     x"000";
   CPU_Idle6      <= x"488" when ((XPos >= 350 AND XPos < 360) AND (YPOS >= 320 AND YPOS < 340)) else
                       x"488" when ((XPos >= 350 AND XPos < 360) AND (YPOS >= 370 AND YPOS < 380)) else 
                       x"377" when ((XPos >= 350 AND XPos < 360) AND (YPOS >= 380 AND YPOS < 400)) else   
                       x"000";
   CPU_Idle7      <= x"488" when ((XPos >= 360 AND XPos < 370) AND (YPOS >= 300 AND YPOS < 320)) else
                       x"B22" when ((XPos >= 360 AND XPos < 370) AND (YPOS >= 320 AND YPOS < 330)) else 
                       x"488" when ((XPos >= 360 AND XPos < 370) AND (YPOS >= 330 AND YPOS < 350)) else
                       x"377" when ((XPos >= 360 AND XPos < 370) AND (YPOS >= 360 AND YPOS < 390)) else
                       x"488" when ((XPos >= 360 AND XPos < 370) AND (YPOS >= 410 AND YPOS < 420)) else
                       x"266" when ((XPos >= 360 AND XPos < 370) AND (YPOS >= 440 AND YPOS < 450)) else  
                       x"000";
   CPU_Idle8      <= x"377" when ((XPos >= 370 AND XPos < 380) AND (YPOS >= 300 AND YPOS < 320)) else
                       x"D44" when ((XPos >= 370 AND XPos < 380) AND (YPOS >= 320 AND YPOS < 330)) else
                       x"488" when ((XPos >= 370 AND XPos < 380) AND (YPOS >= 330 AND YPOS < 360)) else
                       x"377" when ((XPos >= 370 AND XPos < 380) AND (YPOS >= 360 AND YPOS < 370)) else 
                       x"488" when ((XPos >= 370 AND XPos < 380) AND (YPOS >= 370 AND YPOS < 380)) else
                       x"488" when ((XPos >= 370 AND XPos < 380) AND (YPOS >= 400 AND YPOS < 420)) else
                       x"488" when ((XPos >= 370 AND XPos < 380) AND (YPOS >= 420 AND YPOS < 430)) else
                       x"266" when ((XPos >= 370 AND XPos < 380) AND (YPOS >= 430 AND YPOS < 450)) else
                       x"000";   
    CPU_Idle9     <= x"377" when ((XPos >= 380 AND XPos < 390) AND (YPOS >= 300 AND YPOS < 340)) else
                       x"488" when ((XPos >= 380 AND XPos < 390) AND (YPOS >= 340 AND YPOS < 400)) else
                       x"377" when ((XPos >= 380 AND XPos < 390) AND (YPOS >= 400 AND YPOS < 410)) else
                       x"D44" when ((XPos >= 380 AND XPos < 390) AND (YPOS >= 410 AND YPOS < 430)) else
                       x"266" when ((XPos >= 380 AND XPos < 390) AND (YPOS >= 430 AND YPOS < 450)) else
                       x"000";  
    CPU_Idle10    <= x"266" when ((XPos >= 390 AND XPos < 400) AND (YPOS >= 310 AND YPOS < 320)) else
                       x"377" when ((XPos >= 390 AND XPos < 400) AND (YPOS >= 320 AND YPOS < 340)) else
                       x"488" when ((XPos >= 390 AND XPos < 400) AND (YPOS >= 340 AND YPOS < 370)) else 
                       x"377" when ((XPos >= 390 AND XPos < 400) AND (YPOS >= 370 AND YPOS < 400)) else
                       x"C33" when ((XPos >= 390 AND XPos < 400) AND (YPOS >= 400 AND YPOS < 430)) else
                       x"000"; 
    CPU_Idle11    <= x"266" when ((XPos >= 400 AND XPos < 410) AND (YPOS >= 340 AND YPOS < 350)) else 
                       x"377" when ((XPos >= 400 AND XPos < 410) AND (YPOS >= 350 AND YPOS < 400)) else
                       x"C33" when ((XPos >= 400 AND XPos < 410) AND (YPOS >= 400 AND YPOS < 420)) else
                       x"000";
    CPU_Idle12    <= x"377" when ((XPos >= 410 AND XPos < 420) AND (YPOS >= 350 AND YPOS < 390)) else
                       x"B22" when ((XPos >= 410 AND XPos < 420) AND (YPOS >= 390 AND YPOS < 410)) else
                       x"C33" when ((XPos >= 410 AND XPos < 420) AND (YPOS >= 410 AND YPOS < 420)) else
                       x"D44" when ((XPos >= 410 AND XPos < 420) AND (YPOS >= 420 AND YPOS < 430)) else 
                       x"266" when ((XPos >= 410 AND XPos < 420) AND (YPOS >= 430 AND YPOS < 450)) else
                       x"000";
    CPU_Idle13    <= x"266" when ((XPos >= 420 AND XPos < 430) AND (YPOS >= 350 AND YPOS < 390)) else 
                       x"B22" when ((XPos >= 420 AND XPos < 430) AND (YPOS >= 390 AND YPOS < 430)) else
                       x"266" when ((XPos >= 420 AND XPos < 430) AND (YPOS >= 430 AND YPOS < 450)) else 
                       x"000";
    CPU_Idle14    <= x"B22" when ((XPos >= 430 AND XPos < 440) AND (YPOS >= 390 AND YPOS < 430)) else  
                       x"000";
    CPU_Idle15    <= x"000";

-- Player Punching
   Player_Punch15      <= x"000";
   Player_Punch14      <= x"884" when ((XPos >= 290 AND XPos < 300) AND (YPOS >= 350 AND YPOS < 360)) else
                       x"773" when ((XPos >= 290 AND XPos < 300) AND (YPOS >= 360 AND YPOS < 370)) else 
                       x"000";
   Player_Punch13      <= x"884" when ((XPos >= 280 AND XPos < 290) AND (YPOS >= 350 AND YPOS < 370)) else 
                       x"000";
   Player_Punch12      <= x"773" when ((XPos >= 270 AND XPos < 280) AND (YPOS >= 360 AND YPOS < 370)) else 
                       x"000";
   Player_Punch11      <= x"773" when ((XPos >= 260 AND XPos < 270) AND (YPOS >= 360 AND YPOS < 370)) else 
                       x"000";
   Player_Punch10      <= x"884" when ((XPos >= 250 AND XPos < 260) AND (YPOS >= 320 AND YPOS < 340)) else
                       x"773" when ((XPos >= 250 AND XPos < 260) AND (YPOS >= 360 AND YPOS < 370)) else 
                       x"884" when ((XPos >= 250 AND XPos < 260) AND (YPOS >= 370 AND YPOS < 380)) else   
                       x"000";
   Player_Punch9       <= x"884" when ((XPos >= 240 AND XPos < 250) AND (YPOS >= 300 AND YPOS < 320)) else
                       x"22B" when ((XPos >= 240 AND XPos < 250) AND (YPOS >= 320 AND YPOS < 330)) else 
                       x"884" when ((XPos >= 240 AND XPos < 250) AND (YPOS >= 330 AND YPOS < 350)) else
                       x"773" when ((XPos >= 240 AND XPos < 250) AND (YPOS >= 360 AND YPOS < 390)) else
                       x"884" when ((XPos >= 240 AND XPos < 250) AND (YPOS >= 410 AND YPOS < 420)) else
                       x"662" when ((XPos >= 240 AND XPos < 250) AND (YPOS >= 440 AND YPOS < 450)) else  
                       x"000";
   Player_Punch8       <= x"773" when ((XPos >= 230 AND XPos < 240) AND (YPOS >= 300 AND YPOS < 320)) else
                       x"44D" when ((XPos >= 230 AND XPos < 240) AND (YPOS >= 320 AND YPOS < 330)) else
                       x"884" when ((XPos >= 230 AND XPos < 240) AND (YPOS >= 330 AND YPOS < 360)) else
                       x"773" when ((XPos >= 230 AND XPos < 240) AND (YPOS >= 360 AND YPOS < 370)) else 
                       x"884" when ((XPos >= 230 AND XPos < 240) AND (YPOS >= 370 AND YPOS < 380)) else
                       x"884" when ((XPos >= 230 AND XPos < 240) AND (YPOS >= 400 AND YPOS < 420)) else
                       x"884" when ((XPos >= 230 AND XPos < 240) AND (YPOS >= 420 AND YPOS < 430)) else
                       x"662" when ((XPos >= 230 AND XPos < 240) AND (YPOS >= 430 AND YPOS < 450)) else
                       x"000";   
    Player_Punch7      <= x"773" when ((XPos >= 220 AND XPos < 230) AND (YPOS >= 300 AND YPOS < 340)) else
                       x"884" when ((XPos >= 220 AND XPos < 230) AND (YPOS >= 340 AND YPOS < 400)) else
                       x"773" when ((XPos >= 220 AND XPos < 230) AND (YPOS >= 400 AND YPOS < 410)) else
                       x"44D" when ((XPos >= 220 AND XPos < 230) AND (YPOS >= 410 AND YPOS < 430)) else
                       x"662" when ((XPos >= 220 AND XPos < 230) AND (YPOS >= 430 AND YPOS < 450)) else
                       x"000";  
    Player_Punch6      <= x"662" when ((XPos >= 210 AND XPos < 220) AND (YPOS >= 310 AND YPOS < 320)) else
                       x"773" when ((XPos >= 210 AND XPos < 220) AND (YPOS >= 320 AND YPOS < 340)) else
                       x"884" when ((XPos >= 210 AND XPos < 220) AND (YPOS >= 340 AND YPOS < 370)) else 
                       x"773" when ((XPos >= 210 AND XPos < 220) AND (YPOS >= 370 AND YPOS < 400)) else
                       x"33C" when ((XPos >= 210 AND XPos < 220) AND (YPOS >= 400 AND YPOS < 430)) else
                       x"000"; 
    Player_Punch5      <= x"662" when ((XPos >= 200 AND XPos < 210) AND (YPOS >= 340 AND YPOS < 350)) else 
                       x"773" when ((XPos >= 200 AND XPos < 210) AND (YPOS >= 350 AND YPOS < 400)) else
                       x"33C" when ((XPos >= 200 AND XPos < 210) AND (YPOS >= 400 AND YPOS < 420)) else
                       x"000";
    Player_Punch4      <= x"773" when ((XPos >= 190 AND XPos < 200) AND (YPOS >= 350 AND YPOS < 390)) else
                       x"22B" when ((XPos >= 190 AND XPos < 200) AND (YPOS >= 390 AND YPOS < 410)) else
                       x"33C" when ((XPos >= 190 AND XPos < 200) AND (YPOS >= 410 AND YPOS < 420)) else
                       x"44D" when ((XPos >= 190 AND XPos < 200) AND (YPOS >= 420 AND YPOS < 430)) else 
                       x"662" when ((XPos >= 190 AND XPos < 200) AND (YPOS >= 430 AND YPOS < 450)) else
                       x"000";
    Player_Punch3      <= x"662" when ((XPos >= 180 AND XPos < 190) AND (YPOS >= 350 AND YPOS < 390)) else 
                       x"22B" when ((XPos >= 180 AND XPos < 190) AND (YPOS >= 390 AND YPOS < 430)) else
                       x"662" when ((XPos >= 180 AND XPos < 190) AND (YPOS >= 430 AND YPOS < 450)) else 
                       x"000";
    Player_Punch2      <= x"22B" when ((XPos >= 170 AND XPos < 180) AND (YPOS >= 390 AND YPOS < 430)) else  
                       x"000";
    Player_Punch1      <= x"000";    

-- Player Idle
   Player_Idle15      <= x"000";
   Player_Idle14      <= x"000";
   Player_Idle13      <= x"000";
   Player_Idle12      <= x"884" when ((XPos >= 270 AND XPos < 280) AND (YPOS >= 390 AND YPOS < 410)) else 
                         x"000";
   Player_Idle11      <= x"773" when ((XPos >= 260 AND XPos < 270) AND (YPOS >= 390 AND YPOS < 400)) else 
                         x"884" when ((XPos >= 260 AND XPos < 270) AND (YPOS >= 400 AND YPOS < 410)) else
                         x"000";
   Player_Idle10      <= x"884" when ((XPos >= 250 AND XPos < 260) AND (YPOS >= 320 AND YPOS < 340)) else
                       x"884" when ((XPos >= 250 AND XPos < 260) AND (YPOS >= 370 AND YPOS < 380)) else 
                       x"773" when ((XPos >= 250 AND XPos < 260) AND (YPOS >= 380 AND YPOS < 400)) else   
                       x"000";
   Player_Idle9      <= x"884" when ((XPos >= 240 AND XPos < 250) AND (YPOS >= 300 AND YPOS < 320)) else
                       x"22B" when ((XPos >= 240 AND XPos < 250) AND (YPOS >= 320 AND YPOS < 330)) else 
                       x"884" when ((XPos >= 240 AND XPos < 250) AND (YPOS >= 330 AND YPOS < 350)) else
                       x"773" when ((XPos >= 240 AND XPos < 250) AND (YPOS >= 360 AND YPOS < 390)) else
                       x"884" when ((XPos >= 240 AND XPos < 250) AND (YPOS >= 410 AND YPOS < 420)) else
                       x"662" when ((XPos >= 240 AND XPos < 250) AND (YPOS >= 440 AND YPOS < 450)) else  
                       x"000";
   Player_Idle8      <= x"773" when ((XPos >= 230 AND XPos < 240) AND (YPOS >= 300 AND YPOS < 320)) else
                       x"44D" when ((XPos >= 230 AND XPos < 240) AND (YPOS >= 320 AND YPOS < 330)) else
                       x"884" when ((XPos >= 230 AND XPos < 240) AND (YPOS >= 330 AND YPOS < 360)) else
                       x"773" when ((XPos >= 230 AND XPos < 240) AND (YPOS >= 360 AND YPOS < 370)) else 
                       x"884" when ((XPos >= 230 AND XPos < 240) AND (YPOS >= 370 AND YPOS < 380)) else
                       x"884" when ((XPos >= 230 AND XPos < 240) AND (YPOS >= 400 AND YPOS < 420)) else
                       x"884" when ((XPos >= 230 AND XPos < 240) AND (YPOS >= 420 AND YPOS < 430)) else
                       x"662" when ((XPos >= 230 AND XPos < 240) AND (YPOS >= 430 AND YPOS < 450)) else
                       x"000";   
    Player_Idle7     <= x"773" when ((XPos >= 220 AND XPos < 230) AND (YPOS >= 300 AND YPOS < 340)) else
                       x"884" when ((XPos >= 220 AND XPos < 230) AND (YPOS >= 340 AND YPOS < 400)) else
                       x"773" when ((XPos >= 220 AND XPos < 230) AND (YPOS >= 400 AND YPOS < 410)) else
                       x"44D" when ((XPos >= 220 AND XPos < 230) AND (YPOS >= 410 AND YPOS < 430)) else
                       x"662" when ((XPos >= 220 AND XPos < 230) AND (YPOS >= 430 AND YPOS < 450)) else
                       x"000";  
    Player_Idle6    <= x"662" when ((XPos >= 210 AND XPos < 220) AND (YPOS >= 310 AND YPOS < 320)) else
                       x"773" when ((XPos >= 210 AND XPos < 220) AND (YPOS >= 320 AND YPOS < 340)) else
                       x"884" when ((XPos >= 210 AND XPos < 220) AND (YPOS >= 340 AND YPOS < 370)) else 
                       x"773" when ((XPos >= 210 AND XPos < 220) AND (YPOS >= 370 AND YPOS < 400)) else
                       x"33C" when ((XPos >= 210 AND XPos < 220) AND (YPOS >= 400 AND YPOS < 430)) else
                       x"000"; 
    Player_Idle5    <= x"662" when ((XPos >= 200 AND XPos < 210) AND (YPOS >= 340 AND YPOS < 350)) else 
                       x"773" when ((XPos >= 200 AND XPos < 210) AND (YPOS >= 350 AND YPOS < 400)) else
                       x"33C" when ((XPos >= 200 AND XPos < 210) AND (YPOS >= 400 AND YPOS < 420)) else
                       x"000";
    Player_Idle4    <= x"773" when ((XPos >= 190 AND XPos < 200) AND (YPOS >= 350 AND YPOS < 390)) else
                       x"22B" when ((XPos >= 190 AND XPos < 200) AND (YPOS >= 390 AND YPOS < 410)) else
                       x"33C" when ((XPos >= 190 AND XPos < 200) AND (YPOS >= 410 AND YPOS < 420)) else
                       x"44D" when ((XPos >= 190 AND XPos < 200) AND (YPOS >= 420 AND YPOS < 430)) else 
                       x"662" when ((XPos >= 190 AND XPos < 200) AND (YPOS >= 430 AND YPOS < 450)) else
                       x"000";
    Player_Idle3    <= x"662" when ((XPos >= 180 AND XPos < 190) AND (YPOS >= 350 AND YPOS < 390)) else 
                       x"22B" when ((XPos >= 180 AND XPos < 190) AND (YPOS >= 390 AND YPOS < 430)) else
                       x"662" when ((XPos >= 180 AND XPos < 190) AND (YPOS >= 430 AND YPOS < 450)) else 
                       x"000";
    Player_Idle2    <= x"22B" when ((XPos >= 170 AND XPos < 180) AND (YPOS >= 390 AND YPOS < 430)) else  
                       x"000";
    Player_Idle1    <= x"000";
 
-- VGA Sprites--    VGA_Paused       <= Ground OR 
--                        Pause1 OR Pause2 OR Pause3 OR Pause4 OR Pause5 OR
--                        Pause6 OR Pause7 OR Pause8 OR Pause9 OR Pause10 OR
--                        CPU_Idle1 OR CPU_Idle2 OR CPU_Idle3 OR CPU_Idle4 OR
--                        CPU_Idle5 OR CPU_Idle6 OR CPU_Idle7 OR CPU_Idle8 OR
--                        CPU_Idle9 OR CPU_Idle10 OR CPU_Idle11 OR CPU_Idle12 OR
--                        CPU_Idle13 OR CPU_Idle14 OR CPU_Idle15 OR
--                        Player_Idle1 OR Player_Idle2 OR Player_Idle3 OR Player_Idle4 OR
--                        Player_Idle5 OR Player_Idle6 OR Player_Idle7 OR Player_Idle8 OR
--                        Player_Idle9 OR Player_Idle10 OR Player_Idle11 OR Player_Idle12 OR
--                        Player_Idle13 OR Player_Idle14 OR Player_Idle15;

    VGA_GameOver     <= Ground OR
                        GameOver1 OR GameOver2 OR GameOver3 OR GameOver4 OR GameOver5 OR GameOver6 OR
                        GameOver7 OR GameOver8 OR GameOver9 OR GameOver10 OR GameOver11 OR GameOver12 OR
                        GameOver13 OR GameOver14 OR GameOver15 OR GameOver16 OR GameOver17 OR GameOver18 OR
                        GameOver19 OR GameOver20 OR GameOver21 OR GameOver22 OR GameOver23 OR GameOver24 OR
                        GameOver25 OR GameOver26 OR GameOver27 OR GameOver28 OR
                        CPU_Idle1 OR CPU_Idle2 OR CPU_Idle3 OR CPU_Idle4 OR
                        CPU_Idle5 OR CPU_Idle6 OR CPU_Idle7 OR CPU_Idle8 OR
                        CPU_Idle9 OR CPU_Idle10 OR CPU_Idle11 OR CPU_Idle12 OR
                        CPU_Idle13 OR CPU_Idle14 OR CPU_Idle15 OR
                        Player_Idle1 OR Player_Idle2 OR Player_Idle3 OR Player_Idle4 OR
                        Player_Idle5 OR Player_Idle6 OR Player_Idle7 OR Player_Idle8 OR
                        Player_Idle9 OR Player_Idle10 OR Player_Idle11 OR Player_Idle12 OR
                        Player_Idle13 OR Player_Idle14 OR Player_Idle15;  
    VGA_Menu         <= Ground OR
                        Title1 OR Title2 OR Title3 OR Title4 OR Title5 OR Title6 OR Title7 OR
                        Title8 OR Title9 OR Title10 OR Title11 OR Title12 OR Title13 OR Title14 OR
                        Title15 OR Title16 OR Title17 OR Title18 OR Title19 OR Title20 OR Title21 OR
                        Title22 OR Title23 OR Title24 OR Title25 OR Title26 OR 
                        CPU_Idle1 OR CPU_Idle2 OR CPU_Idle3 OR CPU_Idle4 OR
                        CPU_Idle5 OR CPU_Idle6 OR CPU_Idle7 OR CPU_Idle8 OR
                        CPU_Idle9 OR CPU_Idle10 OR CPU_Idle11 OR CPU_Idle12 OR
                        CPU_Idle13 OR CPU_Idle14 OR CPU_Idle15 OR
                        Player_Idle1 OR Player_Idle2 OR Player_Idle3 OR Player_Idle4 OR
                        Player_Idle5 OR Player_Idle6 OR Player_Idle7 OR Player_Idle8 OR
                        Player_Idle9 OR Player_Idle10 OR Player_Idle11 OR Player_Idle12 OR
                        Player_Idle13 OR Player_Idle14 OR Player_Idle15; 
    VGA_Count5       <= Ground OR
                        Count5_line1 OR Count5_line2 OR Count5_line3 OR
                        Count5_line4 OR Count5_line5 OR Count5_line6 OR
                        CPU_Idle1 OR CPU_Idle2 OR CPU_Idle3 OR CPU_Idle4 OR
                        CPU_Idle5 OR CPU_Idle6 OR CPU_Idle7 OR CPU_Idle8 OR
                        CPU_Idle9 OR CPU_Idle10 OR CPU_Idle11 OR CPU_Idle12 OR
                        CPU_Idle13 OR CPU_Idle14 OR CPU_Idle15 OR
                        Player_Idle1 OR Player_Idle2 OR Player_Idle3 OR Player_Idle4 OR
                        Player_Idle5 OR Player_Idle6 OR Player_Idle7 OR Player_Idle8 OR
                        Player_Idle9 OR Player_Idle10 OR Player_Idle11 OR Player_Idle12 OR
                        Player_Idle13 OR Player_Idle14 OR Player_Idle15;  
    VGA_Count4       <= Ground OR
                        Count4_line1 OR Count4_line2 OR Count4_line3 OR
                        Count4_line4 OR Count4_line5 OR Count4_line6 OR
                        CPU_Idle1 OR CPU_Idle2 OR CPU_Idle3 OR CPU_Idle4 OR
                        CPU_Idle5 OR CPU_Idle6 OR CPU_Idle7 OR CPU_Idle8 OR
                        CPU_Idle9 OR CPU_Idle10 OR CPU_Idle11 OR CPU_Idle12 OR
                        CPU_Idle13 OR CPU_Idle14 OR CPU_Idle15 OR
                        Player_Idle1 OR Player_Idle2 OR Player_Idle3 OR Player_Idle4 OR
                        Player_Idle5 OR Player_Idle6 OR Player_Idle7 OR Player_Idle8 OR
                        Player_Idle9 OR Player_Idle10 OR Player_Idle11 OR Player_Idle12 OR
                        Player_Idle13 OR Player_Idle14 OR Player_Idle15;
    VGA_Count3       <= Ground OR
                        Count3_line1 OR Count3_line2 OR Count3_line3 OR
                        Count3_line4 OR Count3_line5 OR Count3_line6 OR
                        CPU_Idle1 OR CPU_Idle2 OR CPU_Idle3 OR CPU_Idle4 OR
                        CPU_Idle5 OR CPU_Idle6 OR CPU_Idle7 OR CPU_Idle8 OR
                        CPU_Idle9 OR CPU_Idle10 OR CPU_Idle11 OR CPU_Idle12 OR
                        CPU_Idle13 OR CPU_Idle14 OR CPU_Idle15 OR
                        Player_Idle1 OR Player_Idle2 OR Player_Idle3 OR Player_Idle4 OR
                        Player_Idle5 OR Player_Idle6 OR Player_Idle7 OR Player_Idle8 OR
                        Player_Idle9 OR Player_Idle10 OR Player_Idle11 OR Player_Idle12 OR
                        Player_Idle13 OR Player_Idle14 OR Player_Idle15;
    VGA_Count2       <= Ground OR
                        Count2_line1 OR Count2_line2 OR Count2_line3 OR
                        Count2_line4 OR Count2_line5 OR Count2_line6 OR
                        CPU_Idle1 OR CPU_Idle2 OR CPU_Idle3 OR CPU_Idle4 OR
                        CPU_Idle5 OR CPU_Idle6 OR CPU_Idle7 OR CPU_Idle8 OR
                        CPU_Idle9 OR CPU_Idle10 OR CPU_Idle11 OR CPU_Idle12 OR
                        CPU_Idle13 OR CPU_Idle14 OR CPU_Idle15 OR
                        Player_Idle1 OR Player_Idle2 OR Player_Idle3 OR Player_Idle4 OR
                        Player_Idle5 OR Player_Idle6 OR Player_Idle7 OR Player_Idle8 OR
                        Player_Idle9 OR Player_Idle10 OR Player_Idle11 OR Player_Idle12 OR
                        Player_Idle13 OR Player_Idle14 OR Player_Idle15;
    VGA_Count1       <= Ground OR
                        Count1_line1 OR Count1_line2 OR Count1_line3 OR
                        Count1_line4 OR Count1_line5 OR Count1_line6 OR
                        CPU_Idle1 OR CPU_Idle2 OR CPU_Idle3 OR CPU_Idle4 OR
                        CPU_Idle5 OR CPU_Idle6 OR CPU_Idle7 OR CPU_Idle8 OR
                        CPU_Idle9 OR CPU_Idle10 OR CPU_Idle11 OR CPU_Idle12 OR
                        CPU_Idle13 OR CPU_Idle14 OR CPU_Idle15 OR
                        Player_Idle1 OR Player_Idle2 OR Player_Idle3 OR Player_Idle4 OR
                        Player_Idle5 OR Player_Idle6 OR Player_Idle7 OR Player_Idle8 OR
                        Player_Idle9 OR Player_Idle10 OR Player_Idle11 OR Player_Idle12 OR
                        Player_Idle13 OR Player_Idle14 OR Player_Idle15; 
    VGA_CountGo       <= Ground OR
                        CountGo_line1 OR CountGo_line2 OR CountGo_line3 OR
                        CountGo_line4 OR CountGo_line5 OR CountGo_line6 OR
                        CountGo_line7 OR CountGo_line8 OR CountGo_line9 OR
                        CountGo_line10 OR CountGo_line11 OR CountGo_line12 OR
                        CPU_Idle1 OR CPU_Idle2 OR CPU_Idle3 OR CPU_Idle4 OR
                        CPU_Idle5 OR CPU_Idle6 OR CPU_Idle7 OR CPU_Idle8 OR
                        CPU_Idle9 OR CPU_Idle10 OR CPU_Idle11 OR CPU_Idle12 OR
                        CPU_Idle13 OR CPU_Idle14 OR CPU_Idle15 OR
                        Player_Idle1 OR Player_Idle2 OR Player_Idle3 OR Player_Idle4 OR
                        Player_Idle5 OR Player_Idle6 OR Player_Idle7 OR Player_Idle8 OR
                        Player_Idle9 OR Player_Idle10 OR Player_Idle11 OR Player_Idle12 OR
                        Player_Idle13 OR Player_Idle14 OR Player_Idle15;                                                                                                                                                                    
    VGA_Idle         <= Ground OR
                        Player_Health_Bar1 OR Player_Health_Bar2 OR Player_Health_Bar3 OR
                        Player_Health_Bar4 OR Player_Health_Bar5 OR Player_Health_Bar6 OR
                        Player_Health_Bar7 OR Player_Health_Bar8 OR Player_Health_Bar9 OR
                        Player_Health_Bar10 OR Player_Health_Bar11 OR Player_Health_Bar12 OR   
                        CPU_Health_Bar1 OR CPU_Health_Bar2 OR CPU_Health_Bar3 OR
                        CPU_Health_Bar4 OR CPU_Health_Bar5 OR CPU_Health_Bar6 OR
                        CPU_Health_Bar7 OR CPU_Health_Bar8 OR CPU_Health_Bar9 OR
                        CPU_Health_Bar10 OR CPU_Health_Bar11 OR CPU_Health_Bar12 OR
                        CPU_Idle1 OR CPU_Idle2 OR CPU_Idle3 OR CPU_Idle4 OR
                        CPU_Idle5 OR CPU_Idle6 OR CPU_Idle7 OR CPU_Idle8 OR
                        CPU_Idle9 OR CPU_Idle10 OR CPU_Idle11 OR CPU_Idle12 OR
                        CPU_Idle13 OR CPU_Idle14 OR CPU_Idle15 OR
                        Player_Idle1 OR Player_Idle2 OR Player_Idle3 OR Player_Idle4 OR
                        Player_Idle5 OR Player_Idle6 OR Player_Idle7 OR Player_Idle8 OR
                        Player_Idle9 OR Player_Idle10 OR Player_Idle11 OR Player_Idle12 OR
                        Player_Idle13 OR Player_Idle14 OR Player_Idle15;
    VGA_PlayerPunch  <= Ground OR
                        Player_Health_Bar1 OR Player_Health_Bar2 OR Player_Health_Bar3 OR
                        Player_Health_Bar4 OR Player_Health_Bar5 OR Player_Health_Bar6 OR
                        Player_Health_Bar7 OR Player_Health_Bar8 OR Player_Health_Bar9 OR
                        Player_Health_Bar10 OR Player_Health_Bar11 OR Player_Health_Bar12 OR
                        CPU_Health_Bar1 OR CPU_Health_Bar2 OR CPU_Health_Bar3 OR
                        CPU_Health_Bar4 OR CPU_Health_Bar5 OR CPU_Health_Bar6 OR
                        CPU_Health_Bar7 OR CPU_Health_Bar8 OR CPU_Health_Bar9 OR
                        CPU_Health_Bar10 OR CPU_Health_Bar11 OR CPU_Health_Bar12 OR
                        CPU_Idle1 OR CPU_Idle2 OR CPU_Idle3 OR CPU_Idle4 OR
                        CPU_Idle5 OR CPU_Idle6 OR CPU_Idle7 OR CPU_Idle8 OR
                        CPU_Idle9 OR CPU_Idle10 OR CPU_Idle11 OR CPU_Idle12 OR
                        CPU_Idle13 OR CPU_Idle14 OR CPU_Idle15 OR
                        Player_Punch1 OR Player_Punch2 OR Player_Punch3 OR Player_Punch4 OR
                        Player_Punch5 OR Player_Punch6 OR Player_Punch7 OR Player_Punch8 OR
                        Player_Punch9 OR Player_Punch10 OR Player_Punch11 OR Player_Punch12 OR
                        Player_Punch13 OR Player_Punch14 OR Player_Punch15;
    VGA_CPUPunch     <= Ground OR 
                        Player_Health_Bar1 OR Player_Health_Bar2 OR Player_Health_Bar3 OR
                        Player_Health_Bar4 OR Player_Health_Bar5 OR Player_Health_Bar6 OR
                        Player_Health_Bar7 OR Player_Health_Bar8 OR Player_Health_Bar9 OR
                        Player_Health_Bar10 OR Player_Health_Bar11 OR Player_Health_Bar12 OR
                        CPU_Health_Bar1 OR CPU_Health_Bar2 OR CPU_Health_Bar3 OR
                        CPU_Health_Bar4 OR CPU_Health_Bar5 OR CPU_Health_Bar6 OR
                        CPU_Health_Bar7 OR CPU_Health_Bar8 OR CPU_Health_Bar9 OR
                        CPU_Health_Bar10 OR CPU_Health_Bar11 OR CPU_Health_Bar12 OR       
                        CPU_Punch1 OR CPU_Punch2 OR CPU_Punch3 OR CPU_Punch4 OR
                        CPU_Punch5 OR CPU_Punch6 OR CPU_Punch7 OR CPU_Punch8 OR
                        CPU_Punch9 OR CPU_Punch10 OR CPU_Punch11 OR CPU_Punch12 OR
                        CPU_Punch13 OR CPU_Punch14 OR CPU_Punch15 OR
                        Player_Idle1 OR Player_Idle2 OR Player_Idle3 OR Player_Idle4 OR
                        Player_Idle5 OR Player_Idle6 OR Player_Idle7 OR Player_Idle8 OR
                        Player_Idle9 OR Player_Idle10 OR Player_Idle11 OR Player_Idle12 OR
                        Player_Idle13 OR Player_Idle14 OR Player_Idle15;    
end VGADisplay_Arch;
