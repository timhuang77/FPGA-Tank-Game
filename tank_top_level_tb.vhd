library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.game_components.all;
use work.tank_functions.all;
use work.tank_const.all;

entity tank_top_level_tb is
end entity tank_top_level_tb;

architecture testbench of tank_top_level_tb is
	component tank_top_level is
		port(
			clk, reset_n : in std_logic;
			player_speed, player_fire : in std_logic
		);
	end component tank_top_level;
	
	signal clk, reset, reset_n : std_logic := '0';
	signal player_speed, player_fire : std_logic := '0';
begin
	reset_n <= not reset;
	dut : tank_top_level port map(
			clk => clk,
			reset_n => reset_n,
			player_speed => player_speed,
			player_fire => player_fire
		);
	
	tb : process is begin
		--cycle 0
			reset <= '1';
			player_speed <= '0';
			clk <= not clk; wait for 20 ns;
			clk <= not clk; wait for 20 ns;
		--cycle 1
			-- player_fire <= '1';
			-- player_fire <= '1';
			reset <= '0';
			for i in 0 to 3 loop
				clk <= not clk; wait for 20 ns;
			end loop;
		--cycle 2 through 9
			for i in 0 to 33 loop
				clk <= not clk; wait for 20 ns;
			end loop;
		--cycle 10
			-- player_speed <= '1';
			for i in 0 to 2000 loop
				clk <= not clk; wait for 20 ns;
			end loop;
			wait;		
	end process;
	
end architecture testbench;