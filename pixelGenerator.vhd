library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.game_components.all;
use work.tank_const.all;

entity pixelGenerator is
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
end entity pixelGenerator;

architecture behavioral of pixelGenerator is

type col is array (0 to col_size - 1) of std_logic_vector(1 downto 0);
type row is array (0 to row_size - 1) of col;
signal color_ram : row;

constant red : std_logic_vector(1 downto 0) := "11";
constant green : std_logic_vector(1 downto 0) := "10";
constant blue : std_logic_vector(1 downto 0) := "01";
constant black : std_logic_vector(1 downto 0) := "00";

signal colorAddress : std_logic_vector (2 downto 0);
signal color        : std_logic_vector (2 downto 0);
signal reset		: std_logic;

signal color_out : std_logic_vector (1 downto 0);
signal pixel_row_int, pixel_column_int : integer := 0;
signal tank_A_display_2bit, tank_B_display_2bit : std_logic_vector(1 downto 0);
signal bullet_A_display_2bit, bullet_B_display_2bit : std_logic_vector(1 downto 0);

signal clock_divided : std_logic := '0';

begin
	extend_bits_display_flags : for i in 0 to 1 generate	--repeats 2 bits
		tank_A_display_2bit(i) <= tank_A_display;
		tank_B_display_2bit(i) <= tank_B_display;
		-- bullet_A_display <= bullet
	end generate;
	
	process(clk, reset)
		variable counter : integer := 0;
	begin
		if (rising_edge(clk)) then
			if (counter = DIVIDE_CONSTANT) then
				clock_divided <= not clock_divided;
				counter := 0;
			elsif (rst_n = '0') then
				clock_divided <= clk;
			else
				counter := counter + 1;
			end if;
		end if;
	end process;
	
	process(clock_divided) is 
		variable color_out_temp : std_logic_vector(1 downto 0);
	begin

		if (pixel_row_int > (tank_A_pos(1) - TANK_HEIGHT/2)) then
			if ((pixel_column_int > (tank_A_pos(0) - TANK_WIDTH/2)) and (pixel_column_int < (tank_A_pos(0) + (TANK_WIDTH/2)))) then
				color_out_temp := red;
			else
				color_out_temp := black;
			end if;
		elsif (pixel_row_int < (tank_B_pos(1) + TANK_HEIGHT/2)) then
			if ((pixel_column_int > (tank_B_pos(0) - TANK_WIDTH/2)) and (pixel_column_int < (tank_B_pos(0) + (TANK_WIDTH/2)))) then
				color_out_temp := blue;
			else
				color_out_temp := black;
			end if;
		elsif ((bullet_B_pos(0) - BULLET_WIDTH) < pixel_column_int and pixel_column_int < (bullet_B_pos(0) + BULLET_WIDTH) and
				(bullet_B_pos(1) - BULLET_HEIGHT) < pixel_row_int and pixel_row_int < (bullet_B_pos(1) + BULLET_HEIGHT) and 
				bullet_B_display = '1') then
				color_out_temp := green;
		elsif ((bullet_A_pos(0) - BULLET_WIDTH) < pixel_column_int and pixel_column_int < (bullet_A_pos(0) + BULLET_WIDTH) and
				(bullet_A_pos(1) - BULLET_HEIGHT) < pixel_row_int and pixel_row_int < (bullet_A_pos(1) + BULLET_HEIGHT) and
				bullet_A_display = '1') then
				color_out_temp := green;
		else
			color_out_temp := black;
		end if;
		
		color_out <= color_out_temp;
		
	
	end process;
	
	pixel_row_int <= to_integer(unsigned(pixel_row));
	pixel_column_int <= to_integer(unsigned(pixel_column));
	
	red_out <=	x"FF" when color_out = red else x"00";
	green_out <= x"FF" when color_out = green else x"00";
	blue_out <= x"FF" when color_out = blue else x"00";
				
end architecture behavioral;		