library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stop_watch is
port( 
	i_clk 	  : in std_logic;
	i_enable  : in std_logic;
	i_reset	  : in std_logic;
	o_number  : out std_logic_vector(3 downto 0);
	o_display : out std_logic_vector(7 downto 0)
	);
end entity;

architecture rtl of stop_watch is

-- Enumerated type declaration and state signal declaration
    type t_State is (DIG_5, DIG_6, DIG_7, DIG_8);
    signal s_State : t_State;
	constant c_ClockFreq	: integer := 9600;	
	signal 	 s_Counter 		: integer := 0;	
	type DIGITS is array (1 downto 0) of integer range 0 to 10;
	signal s_digits : DIGITS;
	signal s_enable : std_logic;	
begin
	process(i_clk) is
	begin
		if rising_edge(i_clk) then						
			if s_enable = '1' then
				s_Counter <= s_Counter + 1;
			end if;	
					
			case s_State is				
				when DIG_6 =>
					o_display <= "11111011";
					o_number <= std_logic_vector(to_unsigned(s_digits(1), o_number'length));
					s_State <= DIG_7;
					
					if i_reset = '1' then
						s_digits(0) <= 0;
						s_digits(1) <= 0;
						s_Counter   <= 0;
					
					elsif s_Counter >= c_ClockFreq - 1 then
							
						s_Counter <= 0;
						s_digits(0) <= s_digits(0) + 1;
						
						if s_digits(0) = 9 then 
							
							s_digits(0) <= 0;
							s_digits(1) <= s_digits(1) + 1;
							
							if s_digits(1) = 9 then
							
								s_digits(1) <= 0;
							
							end if;
						
						end if;
							
                           
                    end if;
				
				
				when DIG_7 =>
					o_display <= "11111101";
					o_number <= std_logic_vector(to_unsigned(s_digits(0), o_number'length));
                    s_State  <= DIG_6;
                   
				
				
				when others =>
					s_Counter <= 0;
					s_State <= DIG_6;
					o_display <= "11111011";
					s_digits(0) <= 0;
					s_digits(1) <= 0;
					o_number <= std_logic_vector(to_unsigned(0, o_number'length));
					--s_enable <= '0';
				
			end case;
		
		end if;
	
	end process;
	
	process(i_enable) is
	begin
		if rising_edge(i_enable) then
			s_enable <= not s_enable;
		end if; 
	end process;


end architecture; 
