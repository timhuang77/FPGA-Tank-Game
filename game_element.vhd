library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.game_components.all;
use work.tank_functions.all;

entity game_object is
	generic(
		width : integer;
		height : integer
	);
	port(
		clk : in std_logic;
		x_pos : out integer;
		y_pos : out integer;
	);
end entity game_object;

architecture behavioral of game_object is

	signal curr_x : integer;
	signal curr_y : integer;

begin
	
	process(clk)
		
	begin
		
	end process;
	
end architecture behavioral;