library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.game_components.all;
use WORK.tank_functions.all;

entity display_handler is
	port(
		reset, clk, rw : in std_logic;
			--rw = 0 (read)
			--rw = 1 (write)
		pixel_x : in integer;
		pixel_y : in integer;
		pixel_color : out std_logic_vector(2 downto 0)
	);
end entity display_handler;

architecture behavioral of display_handler is
--components
--types
--signals
signal color_out : std_logic_vector(7 downto 0);
signal color_in : std_logic_vector(7 downto 0);
-- signal color_out : std_logic
-- signal color_in : std_logic;
signal pixel_raddr : std_logic_vector(18 downto 0);
signal pixel_waddr : std_logic_vector(18 downto 0);
signal colorram_we : std_logic;

begin
	color_ram : bram port map(
		q => color_out, 
		d => color_in, 
		raddr => pixel_raddr, 
		waddr => pixel_waddr, 
		we => colorram_we, 
		clk => clk
		);

		
	process(clk, reset)
	begin
		-- colorram_we <= '0';
		if ( reset = '1' ) then
			pixel_x <= 0;
			pixel_y <= 0;
			pixel_waddr <= (others => '0');
			--pixel_raddr <= (others => '0');
			colorram_we <= '0';
		elsif (rising_edge(clk)) then
			rea <= '1';
			pixel_x <= (pixel_x + 1) mod 640;
			pixel_y <= (pixel_y + 1) mod 480;
			if (pixel_x >= 0 and pixel_x < 400 and pixel_y >= 0 and pixel_y < 360) then
				--colorram_we <= '1';
				color_in <= "00000100";
			else
				--colorram_we <= '1';
				color_in <= "00000000";
			end if;
			

			pixel_color <= color_out(2 downto 0);
			
			if (rw = '1') then	--to write to display_handler
				pixel_waddr <= int_to_slv(pixel_x + (pixel_y * 640), pixel_waddr'Length);
			else 
				pixel_raddr <= int_to_slv(pixel_x + (pixel_y * 640), pixel_raddr'Length);
			end if;
		end if;
	end process;
	
	pixel_raddr <= int_to_slv(pixel_query_x + (pixel_query_y * 640), pixel_raddr'Length);
	
end architecture behavioral;