library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.game_components.all;
use work.tank_functions.all;

entity boundary_detection is
	port(
		clk : in std_logic;
		off_screen_flag : out std_logic;
		obj_width : in integer;
		obj_height : in integer;
		obj_pos_x : in integer;
		obj_pos_y : in integer
	);
end entity boundary_detection;

architecture behavioral of boundary_detection is

	
begin
	process(clk) begin
		if (obj_pos_x + obj_width/2 < 639 and 
			obj_pos_x - obj_width/2 > 0 and
			obj_pos_y + obj_height/2 < 479 and
			obj_pos_y - obj_height/2 > 0) then
			off_screen_flag <= '0';
		else 
			off_screen_flag <= '1'; 
		end if;
	end process;
	
architecture behavioral;