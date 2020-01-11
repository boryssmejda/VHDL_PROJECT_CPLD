library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.output_data_type.all;

entity stop_watchTb is
end entity;

architecture sim of stop_watchTb is

	constant ClockFrequencyHz : integer := 1000;
	constant ClockPeriod : time := 1000 ms / ClockFrequencyHz;
	
	signal i_clk     	: std_logic := '0';
    signal o_number		: std_logic_vector (7 downto 0) := "00000011";
	signal o_display	: std_logic_vector (7 downto 0) := "11111110";
	
begin 

	-- The Device Under Test(DUT)
	i_stop_watch: entity work.stop_watch(rtl)
	port map(
		i_clk			=> i_clk,
		o_number		=> o_number,
		o_display 		=> o_display
	);

	-- Process for generating clock signal
	i_clk <= not i_clk after ClockPeriod / 2;
	
	-- Testbench
	process is
	begin
		
			
			
		wait;
	end process;

end architecture sim;