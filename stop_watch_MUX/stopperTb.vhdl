library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.output_data_type.all;

entity stop_watchTb is
end entity;

architecture sim of stop_watchTb is

	constant ClockFrequencyHz : integer := 9600;
	constant ClockPeriod : time := 1000 ms / ClockFrequencyHz;
	
	signal Clk     			: std_logic := '0';
    signal outValue			: Display_Value := ("00000011", "00000011", "00000011", "00000011");
	signal select_display	: std_logic_vector(7 downto 0) := "00001110";
	
begin 

	-- The Device Under Test(DUT)
	i_stop_watch: entity work.stop_watch(rtl)
	port map(
		clk				=> Clk,
		outValue		=> outValue,
		select_display 	=> select_display
	);

	-- Process for generating clock signal
	Clk <= not Clk after ClockPeriod / 2;
	
	-- Testbench
	process is
	begin
		
			
			
		wait;
	end process;

end architecture sim;