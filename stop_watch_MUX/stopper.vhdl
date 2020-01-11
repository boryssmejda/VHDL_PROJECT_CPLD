library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

package output_data_type is
	--type Display_Value is array (0 to 3) of std_logic_vector(7 downto 0);
	type Current_Digit is array (3 downto 0) of integer;
end package output_data_type;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use work.output_data_type.all;


entity stop_watch is
 port( 
	i_clk 		: in std_logic := '0';
	o_number 	: out std_logic_vector(7 downto 0) := "00000011";
	o_display	: out std_logic_vector(7 downto 0) := "11111110");
end entity stop_watch;


architecture rtl of stop_watch is

	constant c_MaxNumber 				: integer := 9;
	constant c_ClockFrequency 			: integer := 9600;
	constant c_NrDisplays 				: integer := 4;
	constant c_oneHundredthOfSecond 	: integer := c_ClockFrequency / 100;
	constant c_freqDiv 					: integer := 1;
	
	signal s_selDisp 			: std_logic_vector(7 downto 0) 	:= "11111110";
	signal s_currentDisplay		: integer  						:= 0;
	
	signal s_current_digit		: Current_Digit 				:= (0,0,0,0);
	signal s_numberToDisplay	: std_logic_vector(7 downto 0)  := "00000011";
	
	
	procedure incrementWrap(signal binary_number 	: inout integer;
									constant wrapValue		: in integer;
									constant enable			: in boolean;
									variable wrapped		: out boolean) is
		begin
			
			if enable = true then
			
				if binary_number = wrapValue then
					binary_number 	<= 0;
					wrapped 		:= true;
				else
					binary_number <= binary_number + 1;
					wrapped := false;
				end if;
			
			end if;
	end procedure incrementWrap;
	
	
	procedure reset_stop_watch_if_neccessary(signal output_value	: inout Current_Digit;
											 variable wrapped		: out boolean) is
		begin 
		
			if(output_value(3) = 9 and output_value(2) = 9 and output_value(1) = 9 and output_value(0) = 0) then
				output_value(3) <= 0;
				output_value(2) <= 0;
				output_value(1) <= 0;
				output_value(0) <= 0;
				wrapped := true;
			end if;
	
	end procedure reset_stop_watch_if_neccessary;
	
	
	procedure turn_on_display(constant display_number: in integer;
								signal sel_disp: out std_logic_vector(7 downto 0)) is
		begin
		
			case display_number is
				when 0 => 
					sel_disp <= "11111110";
				when 1 => 
					sel_disp <= "11111101";
				when 2 => 
					sel_disp <= "11111011";
				when 3 => 
					sel_disp <= "11110111";
				when others =>
					sel_disp <= "11111110";
			end case;
	
	end procedure turn_on_display;
	

	procedure display_number(	constant number: in integer;
								signal output_number: out std_logic_vector(7 downto 0)) is
		begin

			case number is
				when 0 =>
					output_number <= "00000011"; -- 0x03 
				when 1 =>
					output_number <= "10011111"; -- 0x9F
				when 2 =>
					output_number <= "00100101"; -- 0x25
				when 3 =>
					output_number <= "00001101"; -- 0x0D
				when 4 =>
					output_number <= "10011001"; -- 0x99
				when 5 =>
					output_number <= "01001001"; -- 0x49
				when 6 =>
					output_number <= "01000001"; -- 0x41
				when 7 =>
					output_number <= "00011111"; -- 0x1F
				when 8 =>
					output_number <= "00000001"; -- 0x01
				when 9 =>
					output_number <= "00001001"; -- 0x09
				when others =>
					output_number <= "00000011";
			end case;	

		end procedure;

begin
	-- a is 7, dot is 0
	stop_watch: process(i_clk) is
		
		variable wrapped_v			: boolean 				:= false;
		variable enable_v			: boolean				:= false;
		variable counter_v 			: integer  				:= 0;
		
	begin
	 
		if rising_edge(i_clk) then

			--Managing current display
			if s_currentDisplay = c_NrDisplays - 1 then
				s_currentDisplay <= 0;
			else
				s_currentDisplay <= (s_currentDisplay + 1);
			end if;
			
			turn_on_display(s_currentDisplay, s_selDisp);
			--=============================================================
			
			--divide clock frequency
			if counter_v = c_oneHundredthOfSecond - 1 then
				counter_v := 0;
				enable_v  := true;
			else
				counter_v := counter_v + 1;
				enable_v  := false;
			end if;
			
			
			--update numbers
			incrementWrap(s_current_digit(0), c_MaxNumber, enable_v, wrapped_v);
			incrementWrap(s_current_digit(1), c_MaxNumber, wrapped_v, wrapped_v);
			incrementWrap(s_current_digit(2), c_MaxNumber, wrapped_v, wrapped_v);
			incrementWrap(s_current_digit(3), c_MaxNumber, wrapped_v, wrapped_v);
			
			reset_stop_watch_if_neccessary(s_current_digit, wrapped_v);
			
			-- Put number on the display
			display_number(s_current_digit(s_currentDisplay), s_numberToDisplay);
		
		end if;
	
	end process stop_watch;
	
	o_display 	<= s_selDisp;
	o_number 	<= s_numberToDisplay;
		

end rtl;
