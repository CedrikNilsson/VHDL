----------------------------------------------------------------------------------
-- Company: University of Strathclyde
-- Engineer: Cedrik Nilsson
-- 
-- Create Date: 19.03.2024 19:29:22
-- Design Name: 
-- Module Name: trying_prime_count_again - Behavioral
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

-- The C ports were used to test the code on the FPGA
entity count_case is
    Port ( btnu : in STD_LOGIC;
           btnd : in STD_LOGIC;
           btnc : in STD_LOGIC;
           --C0 : in STD_LOGIC; 
--           C1 : in STD_LOGIC;
--           C2 : in STD_LOGIC;
--           C3 : in STD_LOGIC;
--           C4 : in STD_LOGIC;
--           C5 : in STD_LOGIc;
--           C6 : in STD_LOGIC;
--           C7 : in STD_LOGIC;
--           C8 : in STD_LOGIC;
           clk : in STD_LOGIC;
           Seg : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0) :="1101");

end count_case;

architecture Behavioral of count_case is
-- signals D are for what the bcd digit is
-- seg_c is the clock for the digit refresh rate
-- an is the anode selector
-- var was added as a flip flop for the anode selection code
signal D : STD_LOGIC_VECTOR (3 downto 0);
signal D0 : STD_LOGIC_VECTOR (3 downto 0);
signal D1 : STD_LOGIC_VECTOR (3 downto 0);
signal count : integer;
--signal count : STD_LOGIC_VECTOR (4 downto 0);
signal seg_c : STD_LOGIC;
signal seg_count : integer;
signal var : STD_LOGIC;




    -- Signals for 50MHz clk divider
    signal clk_divide_count1 : integer; 
--    signal counter1 : integer ;  -- Counter is 5 bits to accommodate up to 25
    signal slow_clk1 : std_logic;
--    signal plz_clk : std_logic := '0';
    signal btnu_toggle : std_logic := '0';
    signal btnu_debounce: std_logic;
    signal btnd_debounce: std_logic;


begin

    -- Generates a slower clk

process(clk, clk_divide_count1) 
    begin
        if rising_edge(clk) then
                if clk_divide_count1 = 50000000 then   -- 50MHz clock counting to 5 million, therefore slow clock will have period of 1s [(1/(50*10^6))*(50*10^6) = 1]
                    clk_divide_count1 <= 0;   -- Reset clock divider
                    slow_clk1 <= '1';    
                    end if;                            -- Pulse slow_clk for one clock period
                if clk_divide_count1 < 50000000 then
                    clk_divide_count1 <= clk_divide_count1 + 1 ;    -- Increment clk_divide_count
                end if;
                if clk_divide_count1 = 25000000 then
                    slow_clk1 <= '0';
                end if;
            end if;
            
    end process; 
   

process(btnu, btnd, btnu_toggle, btnu_debounce, btnd_debounce)
begin
    if btnu_debounce = '0' then
        if btnu = '1' then
            btnu_debounce <= '1';
        end if;
    end if;
    if btnu_debounce = '1' then
        if btnu = '0' then -- to only toggle btnu_toggle when the button is let go
            btnu_toggle <= '0';
            btnu_debounce <= '0';
        end if;
    end if;
    
        if btnd_debounce = '0' then
        if btnd = '1' then
            btnd_debounce <= '1';
        end if;
    end if;
    
    if btnd_debounce = '1' then
        if btnd = '0' then -- to only toggle btnu_toggle when the button is let go
            btnd_debounce <= '0';
            btnu_toggle <= '1';
        end if;
    end if;
    end process;


-- counter
process (slow_clk1, count)
begin
    if rising_edge(slow_clk1) then
    -- up counter
    if btnu_toggle = '0' then
        if count < 24 then
            -- Increment the output counter every 1s 
            count <= count + 1;
         end if;
         if count = 24 then
            count <= 0;
         end if;   
    end if;

    
    --down counter
    if btnu_toggle = '1' then
        if count > 0 then
            -- Decrement the output counter every 1s 
            count <= count - 1;
         end if;
         if count = 0 then
            count <= 24;
         end if;   
    end if;        
end if;
 
    --reset, outside of clock       
    if btnc = '1' then
        count <= 0;
    end if;      
    -- was planning on adding a reset for the btnr toggle but the code would not work if I did    
end process;
    
    
    
    
    
-- Code for a counter that was used to test the
-- prime number output before adding the counter component.
--count(0) <= C0;
--count(1) <= C1;
--count(2) <= C2;
--count(3) <= C3;
--count(4) <= C4;



-- Multiplexer for selecting the current count and
-- outputting the prime number in bcd.
process (count)
begin
case count is
    when 0 => --2
        D0 <= "0010";
        D1 <= "1111";
    when 1 => --3
        D0 <= "0011";
        D1 <= "1111";
    when 2 => --5
        D0 <= "0101";
        D1 <= "1111";
    when 3 => --7
        D0 <= "0111";
        D1 <= "1111";
    when 4 => --11
        D0 <= "0001";
        D1 <= "0001";
    when 5 => --13
        D0 <= "0011";
        D1 <= "0001";
    when 6 => --17
        D0 <= "0111";
        D1 <= "0001";
    when 7 => --19
        D0 <= "1001";
        D1 <= "0001";
    when 8 => --23
        D0 <= "0011";
        D1 <= "0010";
    when 9 => --29
        D0 <= "1001";
        D1 <= "0010";
    when 10 => --31
        D0 <= "0001";
        D1 <= "0011";
    when 11 => --37
        D0 <= "0111";
        D1 <= "0011";
    when 12 => --41
        D0 <= "0001";
        D1 <= "0100";
    when 13 => --43
        D0 <= "0011";
        D1 <= "0100";
    when 14 => --47
        D0 <= "0111";
        D1 <= "0100";
    when 15 => --53
        D0 <= "0011";
        D1 <= "0101";
    when 16 => --59
        D0 <= "1001";
        D1 <= "0101";
    when 17 => --61
        D0 <= "0001";
        D1 <= "0110";
    when 18 => --67
        D0 <= "0111";
        D1 <= "0110";
    when 19 => --71
        D0 <= "0001";
        D1 <= "0111";
    when 20 => --73
        D0 <= "0011";
        D1 <= "0111";
    when 21 => --79
        D0 <= "1001";
        D1 <= "0111";
    when 22 => --83
        D0 <= "0011";
        D1 <= "1000";
    when 23 => --89
        D0 <= "1001";
        D1 <= "1000";
    when 24 => --97
        D0 <= "0111";
        D1 <= "1001";
    when others => 
        D0 <= "1101";
        D1 <= "1101";
    end case;
end process;

-- internal clock to set the display refresh rate to around 120Hz
process(clk)
begin
if rising_edge(clk) then
    if seg_count < 420000 then --420000 when on board, 2 on TB
        seg_count <= seg_count + 1;
        end if;
    if seg_count = 420000 then
        seg_count <= 0;
            if seg_c = '1' then
                seg_c <= '0';
            end if;
            if seg_c = '0' then
                seg_c <= '1';
            end if;
        end if;
    end if;
end process;

-- Selection of what digit to display (anode selection)
process(seg_c, var)
begin
if rising_edge(seg_c) then
    if var = '1' then
        an <= "1110";
        D <= D0;
        var <= '0';
    end if;
        if var = '0' then
        an <= "1101";
        D <= D1;
        var <= '1';
    end if;
    end if;
end process;


-- what number will be displayed
-- two cases added for error inputs and a space instead of 0s before digits
process(D)
begin
case D is
    when "0000" => Seg <= "0000001"; -- "0"     
    when "0001" => Seg <= "1001111"; -- "1" 
    when "0010" => Seg <= "0010010"; -- "2" 
    when "0011" => Seg <= "0000110"; -- "3" 
    when "0100" => Seg <= "1001100"; -- "4" 
    when "0101" => Seg <= "0100100"; -- "5" 
    when "0110" => Seg <= "0100000"; -- "6" 
    when "0111" => Seg <= "0001111"; -- "7" 
    when "1000" => Seg <= "0000000"; -- "8"     
    when "1001" => Seg <= "0000100"; -- "9"
    when "1111" => Seg <= "1111111"; -- " " 
    when others => Seg <= "1111110"; -- "-" 
    end case;
    end process;
    


end Behavioral;

