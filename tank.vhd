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
		clk, rst, we, show_tank : in std_logic;
		pos_x_in, pos_y_in: in integer;
		pos_x_out, pos_y_out : out integer
	);
	
--entity description
	--Generic parameters : object width, height, x and y positions
	--Function: Stores attributes such as position (x,y)
	--			
end entity tank;

architecture behavioral of tank is
	signal show_tank_signal : std_logic;
	signal pos_x, pos_y : integer;

begin
	process(clk, rst)
		
	begin
		if (rst = '1') then
			pos_x_out <= pos_x_init;
			pos_y_out <= pos_y_init;
		elsif (rising_edge(clk)) then
		
			if (we = '1') then --write position
				pos_x <= pos_x_in;
				pos_y <= pos_y_in;
			else 	-- read position
				pos_x_out <= pos_x;
				pos_y_out <= pos_y;
			end if;
			
		end if;
	end process;
	
end architecture behavioral;