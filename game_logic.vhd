library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.game_components.all;
use work.tank_functions.all;

entity game_logic is
	port(
		clk, rst : in std_logic;
		
		
		
		--Tank attribute inputs
		tank_A_pos_x_in, tank_A_pos_y_in, tank_A_speed : in integer;
		tank_B_pos_x_in, tank_B_pos_y_in, tank_B_speed : in integer;
		tank_
		--Tank attribute outputs
		tank_A_pos_x_out, tank_A_pos_y_out, tank_A_speed : out integer;
		tank_B_pos_x_out, tank_B_pos_y_out, tank_B_speed : out integer;
	);
end entity game_logic;

architecture behavioral of game_logic is

	signal collision_count_A : integer := 0;
	signal collision_count_B : integer := 0;
begin
	process(clk, rst) is
	
	begin
		
	end process;
	
architecture behavioral;