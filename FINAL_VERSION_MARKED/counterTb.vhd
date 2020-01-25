library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stop_watchTb is
end entity;

architecture sim of stop_watchTb is

	constant ClockFrequencyHz 	: integer 	:= 9600;
	constant ClockPeriod 		: time 		:= 1000 ms / ClockFrequencyHz;
	
	signal Clk     			: std_logic := '0';
    signal s_number			: std_logic_vector(3 downto 0);
	signal select_display	: std_logic_vector(7 downto 0);
	signal s_reset			: std_logic := '0';
	signal s_enable			: std_logic := '1';
	
begin 

	-- The Device Under Test(DUT)
	i_stop_watch: entity work.stop_watch(rtl)
	port map(
		i_clk		=> Clk,
		i_enable	=> s_enable,
		i_reset 	=> s_reset,
		o_number	=> s_number,
		o_display 	=> select_display
	);

	-- Process for generating clock signal
	Clk <= not Clk after ClockPeriod / 2;
	
	-- Testbench
	process is
	begin
		
		s_enable <= '1';
		wait for 5100 ms;
		s_enable <= '0';
		wait for 1000 ms;
		s_enable <= '1';
		s_reset <= '1';
		wait for 1200 ms;
		s_reset <= '0';
		
		
			
			
		wait;
	end process;

end architecture sim;