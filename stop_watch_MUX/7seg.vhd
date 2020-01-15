library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stop_watch is
port( 
	i_clk 			: in std_logic;
	o_number		: out std_logic_vector(3 downto 0);
	o_display		: out std_logic_vector(7 downto 0)
	);
end entity;

architecture rtl of stop_watch is

	 -- Enumerated type declaration and state signal declaration
    type t_State is (DIG_5, DIG_6, DIG_7, DIG_8);
    signal s_State : t_State;

	-- Counter for counting clock periods, 1 minute max
	constant c_ClockFreq	: integer := 9600;
	constant c_divisor 		: integer := 48;
	--constant c_ticksForMs 	: integer := c_ClockFreq/(c_divisor * 100) - 1;
	signal 	 s_Counter 		: integer range 0 to c_divisor := 0; -- 200 Hz
	
	type DIGITS is array (0 to 3) of integer range 0 to 10;
	signal s_digits : DIGITS := (1, 3, 5, 7);
	--signal s_MsCounter	: integer := 0;
	--signal s_wrapped_4	: boolean := false;
	--signal s_wrapped_3	: boolean := false;
	--signal s_wrapped_2	: boolean := false;
	
begin
	
	process(i_clk) is
	begin
	
		if rising_edge(i_clk) then
		
			s_Counter <= s_Counter + 1;
			case s_State is
			
				when DIG_5 =>
					o_display <= "11110111";
					o_number <= std_logic_vector(to_unsigned(s_digits(0), o_number'length));
					if s_Counter = c_divisor - 1 then
                            s_Counter <= 0;
                            s_State   <= DIG_6;
							
							--if s_MsCounter = 1 then
							--	s_MsCounter <= 0;
							--	
							--	if s_digits(0) = 9 then
							--		s_digits(0) <= 0;
							--		s_wrapped_4 <= true;
							--	else
							--		s_digits(0) <= s_digits(0) + 1;
							--		s_wrapped_4 <= false;
							--	end if;	
							--	
							--else
							--	s_MsCounter <= s_MsCounter + 1;
							--end if;	
							
                    end if;
				
				when DIG_6 =>
					o_display <= "11111011";
					o_number <= std_logic_vector(to_unsigned(s_digits(1), o_number'length));
					if s_Counter = c_divisor - 1 then
                            s_Counter <= 0;
                            s_State   <= DIG_7;
							
							--if s_wrapped_4 = true then
							--
							--	if s_digits(1) = 9 then
							--		s_digits(1) <= 0;
							--		s_wrapped_3 <= true;
							--	else
							--		s_digits(1) <= s_digits(1) + 1;
							--		s_wrapped_3 <= false;
							--	end if;	
							--end if;
							
							
                    end if;
				
				when DIG_7 =>
					o_display <= "11111101";
					o_number <= std_logic_vector(to_unsigned(s_digits(2), o_number'length));
					if s_Counter = c_divisor - 1 then
                            s_Counter <= 0;
                            s_State   <= DIG_8;
							
							--if s_wrapped_3 = true then
							--
							--	if s_digits(2) = 9 then
							--		s_digits(2) <= 0;
							--		s_wrapped_2 <= true;
							--	else
							--		s_digits(2) <= s_digits(2) + 1;
							--		s_wrapped_2 <= false;
							--	end if;	
							--end if;
							
                    end if;
				
				when DIG_8 =>
					o_display <= "11111110";
					o_number <= std_logic_vector(to_unsigned(s_digits(3), o_number'length));
					if s_Counter = c_divisor - 1 then
                            s_Counter <= 0;
                            s_State   <= DIG_5;
							
							--if s_wrapped_2 = true then
							--
							--	if s_digits(3) = 9 then
							--		s_digits(3) <= 0;
							--	else
							--		s_digits(3) <= s_digits(3) + 1;
							--	end if;	
							--end if;
							
                    end if;
					
			
			end case;
		
		end if;
		
		
	
	end process;
	
	
end architecture;
