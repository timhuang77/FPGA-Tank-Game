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
		pos_out : out position;
		speed_in : in integer;
		speed_out : out integer
	);
	
--entity description
	--Generic parameters : object width, height, x and y positions
	--Function: Stores attributes such as position (x,y), bullet_fired
	--			
end entity tank;

architecture behavioral of tank is
	signal curr_pos : position;
	signal curr_speed : integer;
begin
	process(clk, rst)
		
	begin
		if (rst = '1') then
			curr_pos(0) <= pos_x_init;
			curr_pos(1) <= pos_y_init;
			curr_speed <= TANK_INIT_SPEED;
		elsif (rising_edge(clk)) then
		
			if (we = '1') then --read inputs
				curr_pos <= pos_in;
				curr_speed <= speed_in;
			else 	-- write to outputs
				pos_out <= curr_pos;
				speed_out <= curr_speed;
			end if;
			
		end if;	
	end process;
	
end architecture behavioral;