library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.game_components.all;
use WORK.tank_functions.all;

entity display_handler is
	port(
		clk : in std_logic;
		pixel_query_x : in integer;
		pixel_query_y : in integer;
		pixel_color : out std_logic_vector(2 downto 0)
	);
end entity display_handler;

architecture behavioral of display_handler is
--components
--types
--signals
signal color_out : std_logic_vector(2 downto 0);
signal color_in : std_logic_vector(2 downto 0);
signal pixel_raddr : std_logic_vector(19 downto 0);
signal pixel_waddr : std_logic_vector(19 downto 0);
signal colorram_we : std_logic;


begin
	color_ram : bram port map(color_out, color_in, pixel_raddr, pixel_waddr, colorram_we, clk);
	process(clk)
		variable pixel_x : integer;
		variable pixel_y : integer;
	begin
		if (rising_edge(clk)) then
			pixel_waddr <= int_to_slv(pixel_x + (pixel_y * 640), pixel_waddr'Length);
			if (pixel_x >= 200 and pixel_x < 400 and pixel_y >= 120 and pixel_y < 360) then
				color_in <= "100";
			else
				color_in <= "000";
			end if;
			
			pixel_x := pixel_x + 1;
			pixel_x := pixel_x mod 639;
			pixel_y := pixel_y + 1;
			pixel_y := pixel_y mod 479;
		end if;
	end process;
	
	-- pixel_color <= color_out;
	pixel_color <= "110";
	
end architecture behavioral;