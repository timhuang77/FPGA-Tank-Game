library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.game_components.all;
use work.tank_functions.all;

entity tank_top_level is
	port(
		clk, reset_n : in std_logic;
		--Keyboard inputs
		--
		
		--VGA 
		VGA_RED, VGA_GREEN, VGA_BLUE 					: out std_logic_vector(7 downto 0); 
		HORIZ_SYNC, VERT_SYNC, VGA_BLANK, VGA_CLK		: out std_logic
	);
end entity tank_top_level;

architecture behavioral of tank_top_level is
	
begin
	--port map VGA
	--port map keyboard
	--port map LCD
	--port map game_object (tank A)
	--port map game_object (bullet A)
	--port map game_object (tank B)
	--port map game_object (bullet B)
	--port map game_logic
		--updates game_object (position, speed)
	
	
	process(clk)
		
	begin
		
	end process;
	
	display_handler_comp : display_handler port map(
		
	);
	
end architecture behavioral;