library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.game_components.all;
use work.tank_functions.all;

entity tank_top_level is
	port(
		--Basic control signals
		clk, reset_n : in std_logic;
		
		--LCD
		 LCD_RS, LCD_E, LCD_ON, RESET_LED, SEC_LED		: OUT	STD_LOGIC;
		 LCD_RW						: BUFFER STD_LOGIC;
		 DATA_BUS				: INOUT	STD_LOGIC_VECTOR(7 DOWNTO 0));
		
		--Keyboard inputs
		keyboard_clk, keyboard_data, kb_read : in std_logic;
		kb_scan_code : out std_logic_vector( 7 DOWNTO 0 );
		kb_scan_ready : out std_logic;
		
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