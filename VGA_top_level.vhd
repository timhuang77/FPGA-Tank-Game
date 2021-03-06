library IEEE;

use IEEE.std_logic_1164.all;
use work.game_components.all;
use work.tank_const.all;
use work.pixelGenerator;


entity VGA_top_level is
	port(
			CLOCK_50 										: in std_logic;
			RESET_N											: in std_logic;

			--tank inputs
			tank_A_pos : in position;
			tank_B_pos : in position;
			tank_A_display, tank_B_display : in std_logic;
			
			--bullet inputs
			bullet_A_pos : in position;
			bullet_B_pos : in position;
			bullet_A_display, bullet_B_display : in std_logic;
			
			--VGA 
			VGA_RED, VGA_GREEN, VGA_BLUE 					: out std_logic_vector(7 downto 0); 
			HORIZ_SYNC, VERT_SYNC, VGA_BLANK, VGA_CLK		: out std_logic

		);
end entity VGA_top_level;

architecture structural of VGA_top_level is

component pixelGenerator is
	port(
			clk, ROM_clk, rst_n, video_on, eof 				: in std_logic;
			pixel_row, pixel_column						    : in std_logic_vector(9 downto 0);
			
			--tank inputs
			tank_A_pos : in position;
			tank_B_pos : in position;
			tank_A_display, tank_B_display : in std_logic;
			
			--bullet inputs
			bullet_A_pos : in position;
			bullet_B_pos : in position;
			bullet_A_display, bullet_B_display : in std_logic;
			
			red_out, green_out, blue_out					: out std_logic_vector(7 downto 0)
		);
end component pixelGenerator;

component VGA_SYNC is
	port(
			clock_50Mhz										: in std_logic;
			horiz_sync_out, vert_sync_out, 
			video_on, pixel_clock, eof						: out std_logic;												
			pixel_row, pixel_column						    : out std_logic_vector(9 downto 0)
		);
end component VGA_SYNC;

--Signals for VGA sync
signal pixel_row_int 										: std_logic_vector(9 downto 0);
signal pixel_column_int 									: std_logic_vector(9 downto 0);
signal video_on_int											: std_logic;
signal VGA_clk_int											: std_logic;
signal eof														: std_logic;

-- signal tank_A_pos_temp, tank_B_pos_temp, bullet_A_pos_temp, bullet_B_pos_temp : position;
-- signal tank_A_display_temp, tank_B_display_temp, bullet_A_display_temp, bullet_B_display_temp : std_logic;


begin
	-- tank_A_pos_temp <= tank_A_pos;
	-- tank_B_pos_temp <= tank_B_pos;
	-- tank_A_display_temp <= tank_A_display;
	-- tank_B_display_temp <= tank_B_display;
	-- bullet_A_pos_temp <= bullet_A_pos;
	-- bullet_B_pos_temp <= bullet_B_pos;
	-- bullet_A_display_temp <= bullet_A_display;
	-- bullet_B_display_temp <= bullet_B_display;
--------------------------------------------------------------------------------------------

	videoGen : pixelGenerator
		port map(
			clk => CLOCK_50, 
			ROM_clk => VGA_clk_int,
			rst_n => RESET_N,
			video_on => video_on_int,
			eof => eof,
			pixel_row => pixel_row_int,
			pixel_column => pixel_column_int,
			tank_A_pos => tank_A_pos,
			tank_B_pos => tank_B_pos,
			tank_A_display => tank_A_display,
			tank_B_display => tank_B_display,
			bullet_A_pos => bullet_A_pos,
			bullet_B_pos => bullet_B_pos,
			bullet_A_display => bullet_A_display,
			bullet_B_display => bullet_B_display,
			red_out => VGA_RED,
			green_out => VGA_GREEN,
			blue_out => VGA_BLUE
		);

--------------------------------------------------------------------------------------------
--This section should not be modified in your design.  This section handles the VGA timing signals
--and outputs the current row and column.  You will need to redesign the pixelGenerator to choose
--the color value to output based on the current position.

	videoSync : VGA_SYNC
		port map(CLOCK_50, HORIZ_SYNC, VERT_SYNC, video_on_int, VGA_clk_int, eof, pixel_row_int, pixel_column_int);

	VGA_BLANK <= video_on_int;

	VGA_CLK <= VGA_clk_int;

--------------------------------------------------------------------------------------------	

end architecture structural;