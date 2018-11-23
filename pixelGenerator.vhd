library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
-- use WORK.display_handler.all;

entity pixelGenerator is
	port(
			clk, ROM_clk, rst_n, video_on, eof 				: in std_logic;
			pixel_row, pixel_column						    : in std_logic_vector(9 downto 0);
			red_out, green_out, blue_out					: out std_logic_vector(7 downto 0)
		);
end entity pixelGenerator;

architecture behavioral of pixelGenerator is

constant color_red 	 	 : std_logic_vector(2 downto 0) := "000";
constant color_green	 : std_logic_vector(2 downto 0) := "001";
constant color_blue 	 : std_logic_vector(2 downto 0) := "010";
constant color_yellow 	 : std_logic_vector(2 downto 0) := "011";
constant color_magenta 	 : std_logic_vector(2 downto 0) := "100";
constant color_cyan 	 : std_logic_vector(2 downto 0) := "101";
constant color_black 	 : std_logic_vector(2 downto 0) := "110";
constant color_white	 : std_logic_vector(2 downto 0) := "111";
	
component display_handler is
	port(
		clk : in std_logic;
		pixel_query_x : in integer;
		pixel_query_y : in integer;
		pixel_color : out std_logic_vector(2 downto 0)
	);
end component display_handler;

signal colorAddress : std_logic_vector (2 downto 0);
signal color        : std_logic_vector (2 downto 0);

signal pixel_row_int, pixel_column_int : integer;

begin

--------------------------------------------------------------------------------------------
	
	-- red_out <= color(23 downto 16);
	-- green_out <= color(15 downto 8);
	-- blue_out <= color(7 downto 0);
	
	repeat_bits : for i in 0 to 7 generate
		red_out(i) <= color(2);
		green_out(i) <= color(1);
		blue_out(i) <= color(0);
	end generate;

	pixel_row_int <= to_integer(unsigned(pixel_row));
	pixel_column_int <= to_integer(unsigned(pixel_column));
	
--------------------------------------------------------------------------------------------	
	
	-- colors : colorROM
		-- port map(colorAddress, ROM_clk, color);

--------------------------------------------------------------------------------------------	
	display_handler_instance : display_handler port map(clk, pixel_column_int, pixel_row_int, color);
	
	-- pixelDraw : process(clk, rst_n) is
	
	-- begin
			
		-- if (rising_edge(clk)) then
			
		-- end if;
		
	-- end process pixelDraw;	

--------------------------------------------------------------------------------------------
	
end architecture behavioral;		