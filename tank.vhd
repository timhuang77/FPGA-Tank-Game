library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.game_components.all;
use work.tank_functions.all;
use work.tank_const.all;

entity tank is
	generic(
		pos_x_init : integer;
		pos_y_init : integer
	);
	port(
		clk, rst, we : in std_logic;
		pos_in : in position;
		pos_out : out position
	);
	
--entity description
	--Generic parameters : object width, height, x and y positions
	--Function: Stores attributes such as position (x,y), bullet_fired
	--			
end entity tank;

architecture behavioral of tank is
	signal curr_pos : position;

begin
	process(clk, rst)
		
	begin
		if (rst = '1') then
			pos_out(0) <= pos_x_init;
			pos_out(1) <= pos_y_init;
			
		elsif (rising_edge(clk)) then
		
			if (we = '1') then --write to tank
				curr_pos <= pos_in;
				
			else 	-- read from tank
				pos_out <= curr_pos;
			end if;
			
		end if;
	end process;
	
end architecture behavioral;