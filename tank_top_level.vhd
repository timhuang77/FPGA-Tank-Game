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
		 LCD_RS, LCD_E, LCD_ON, RESET_LED, SEC_LED : out std_logic;
		 LCD_RW : buffer std_logic;
		 DATA_BUS : inout std_logic_vector(7 DOWNTO 0);
		
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
	signal reset : std_logic;
	
	--Tank A signals
	signal tank_A_we, show_tank_A, bullet_fired_A : std_logic;
	signal tank_A_pos_x_write, tank_A_pos_y_write : integer;
	signal global_write_enable : std_logic := '0';
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
	reset <= not reset_n;
	
	
	
	
	alt_cycle : process(clk, reset) is begin
		if (global_write_enable = '0') then
			global_write_enable <= '1';
		else
			global_write_enable <= '0';
		end if;
	end process;
	
	
	
	
	--Port maps: connecting components
	tank_A : tank
		generic map(
			obj_width => 20,
			obj_height => 10,
			pos_x_init => 319,
			pos_y_init => 440
		)
		port map(
			clk => clk,
			rst => reset,
			we => tank_A_we,
			show_tank => show_tank_A, 
			bullet_fired => bullet_fired_A,
			pos_x_in => tank_A_pos_x_write,
			pos_y_in => tank_A_pos_y_write,
			pos_x_out => tank_A_pos_x_read,
			pos_y_out => tank_A_pos_y_read
		);
		
	
	some_other <= input_signal
	
	process(clk)
		
	begin
		
	end process;
	
	display_handler_comp : display_handler port map(
		
	);
	
end architecture behavioral;