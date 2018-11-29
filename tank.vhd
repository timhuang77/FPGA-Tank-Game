library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.game_components.all;
use work.tank_functions.all;

entity tank is
	generic(
		obj_width : integer;
		obj_height : integer;
		pos_x_init : integer;
		pos_y_init : integer
	);
	port(
		clk : in std_logic;
		pos_x_in, pos_y_in, speed_in : in integer;
		pos_x_out, pos_y_out, speed_out : out integer;
	);
	
--entity description
	--Generic parameters : object width, height, x and y positions
	--Function: Stores attributes such as position (x,y) and speed
	--			
end entity tank;

architecture behavioral of tank is
	signal curr_x : integer;
	signal curr_y : integer;

begin
	
	process(clk)
		
	begin
		
	end process;
	
end architecture behavioral;