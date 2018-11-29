library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.game_components.all;
use work.tank_functions.all;

entity tank is
	generic(
		obj_width : integer;
		obj_height : integer;
		x_pos_init : integer;
		y_pos_init : integer
	);
	port(
		clk : in std_logic;
		x_pos : inout integer;
		y_pos : inout integer;
		speed : inout integer
	);
	
--entity description
	--Generic parameters : object width, height, x and y positions
	--Function: Stores in a new x and y position to be updated
end entity tank;

architecture behavioral of tank is
	signal curr_x : integer;
	signal curr_y : integer;

begin
	
	process(clk)
		
	begin
		
	end process;
	
end architecture behavioral;