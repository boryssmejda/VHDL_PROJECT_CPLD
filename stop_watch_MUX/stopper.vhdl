library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

package output_data_type is
	type Display_Value is array (0 to 3) of std_logic_vector(7 downto 0);
	type Current_Digit is array (0 to 3) of integer range 0 to 9;
end package output_data_type;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use work.output_data_type.all;


entity stop_watch is
 port( 
	clk : in std_logic := '0';
	outValue: inout Display_Value := ("00000011", "00000011", "00000011", "00000011");
	select_display: out std_logic_vector(7 downto 0) := "00001110"
	);
end entity stop_watch;


architecture rtl of stop_watch is

	constant MaxNumber 		: integer := 9;
	constant ClockFrequency : integer := 9600;
	constant nr_displays 	: integer := 4;
	constant one_hundredth_of_second : integer  := ClockFrequency / 100;

	procedure IncrementWrap(variable binary_number 	: inout integer;
							signal output_number	: out std_logic_vector(7 downto 0);
							constant wrapValue		: in integer;
							constant enable			: in boolean;
							variable wrapped		: out boolean) is
	begin
		
		if enable = true then
		
			binary_number := binary_number + 1;
			if binary_number = (wrapValue + 1) then
				binary_number 	:= 0;
				wrapped 		:= true;
			else
				wrapped := false;
			end if;
		
		end if;
		
		case binary_number is
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
	
	end procedure IncrementWrap;
	
	
	procedure reset_stop_watch_if_neccessary(variable output_value	: inout Current_Digit;
											 variable wrapped		: out boolean) is
	begin 
	
		if(output_value(3) = 9 and output_value(2) = 9 and output_value(1) = 9 and output_value(0) = 0) then
			output_value(3) := 0;
			output_value(2) := 0;
			output_value(1) := 0;
			output_value(0) := 0;
			wrapped := true;
		end if;
	
	end procedure reset_stop_watch_if_neccessary;
	
	
	procedure turn_on_display(	constant display_number: in integer;
								signal sel_disp: out std_logic_vector) is
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
	
begin
	-- a is 7, dot is 0
	stop_watch: process(clk) is
		
		variable current_digit		: Current_Digit 		:= (0,0,0,0);
		variable wrapped			: boolean 				:= false;
		variable current_display	: integer range 0 to 3 	:= 0;	
		variable counter			: integer range 0 to (one_hundredth_of_second - 1) := 0;
		
	begin
	 
		if clk'event and clk = '1' then
			
			if current_display = 3 then
				current_display := 0;
			else
				current_display := (current_display + 1);
			end if;
			
			turn_on_display(current_display, select_display);
			
			if counter = one_hundredth_of_second - 1 then 
			
				IncrementWrap(current_digit(0), outValue(0), MaxNumber, true, wrapped);	
				IncrementWrap(current_digit(1), outValue(1), MaxNumber, wrapped, wrapped);
				IncrementWrap(current_digit(2), outValue(2), MaxNumber, wrapped, wrapped);
				IncrementWrap(current_digit(3), outValue(3), MaxNumber, wrapped, wrapped);
			
				reset_stop_watch_if_neccessary(current_digit, wrapped);
				
				counter := 0;
			else
				counter := counter + 1;
			end if;
		
		end if;
	
	end process stop_watch;

end rtl;
