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
signal pixel_row_int, pixel_column_int : integer;
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
	
	process(clock_divided) is begin
--
--		for i in 0 to (row_size - 1) loop
--			for j in 0 to (col_size - 1) loop
--				color_ram(i)(j) <= (others => '0');
--			end loop;
--		end loop;
		
		if (pixel_row_int > (tank_A_pos(1) - TANK_HEIGHT/2)) then
			if ((pixel_column_int > (tank_A_pos(0) - TANK_WIDTH/2)) and (pixel_column_int < (tank_A_pos(0) + (TANK_WIDTH/2)))) then
				color_out <= red;
			else
				color_out <= black;
			end if;
		elsif (pixel_row_int < (tank_B_pos(1) + TANK_HEIGHT/2)) then
			if ((pixel_column_int > (tank_B_pos(0) - TANK_WIDTH/2)) and (pixel_column_int < (tank_B_pos(0) + (TANK_WIDTH/2)))) then
				color_out <= blue;
			else
				color_out <= black;
			end if;
		else
				color_out <= black;
		end if;
		--Tank display
--		tank_A_pixel_gen : 
--		for i in (tank_A_pos(1) - TANK_HEIGHT/2) to (tank_A_pos(1) + TANK_HEIGHT/2) loop
--			tank_A_pixel_gen_innerloop : 
--			for j in (tank_A_pos(0) - TANK_WIDTH/2) to (tank_A_pos(0) + TANK_WIDTH/2) loop
--				if (i >= 0 and i < 480) and (j >= 0 and j < 640) then
--					color_ram(i)(j) <= red and tank_A_display_2bit;
--				end if;
--			end loop tank_A_pixel_gen_innerloop;
--		end loop tank_A_pixel_gen;
--		
--		tank_B_pixel_gen : 
--		for i in (tank_B_pos(1) - TANK_HEIGHT/2) to (tank_B_pos(1) + TANK_HEIGHT/2) loop
--			tank_B_pixel_gen_innerloop : 
--			for j in (tank_B_pos(0) - TANK_WIDTH/2) to (tank_B_pos(0) + TANK_WIDTH/2) loop
--				if (i >= 0 and i < 480) and (j >= 0 and j < 640) then
--					color_ram(i)(j) <= blue and tank_B_display_2bit;
--				end if;
--			end loop tank_B_pixel_gen_innerloop;
--		end loop tank_B_pixel_gen;
--		
		--Bullet display
		-- bullet_A_pixel_gen : 
		-- for i in (tank_B_pos(1) - TANK_HEIGHT/2) to (tank_B_pos(1) + TANK_HEIGHT/2) generate
			-- for j in (tank_B_pos(0) - TANK_WIDTH/2) to (tank_B_pos(0) + TANK_WIDTH/2) generate
				-- color_ram(i)(j) <= x"FF" and tank_B_display_2bit;
			-- end generate;
		-- end generate;
		

	
	end process;
	
	pixel_row_int <= to_integer(unsigned(pixel_row));
	pixel_column_int <= to_integer(unsigned(pixel_column));
	
	--color_out <= color_ram(pixel_row_int)(pixel_column_int);
	
	red_out <=	x"FF" when color_out = red else x"00";
	green_out <= x"FF" when color_out = green else x"00";
	blue_out <= x"FF" when color_out = blue else x"00";
				
	-- -- colors : colorROM
		-- -- port map(colorAddress, ROM_clk, color);
	-- reset <= not rst_n;
-- --------------------------------------------------------------------------------------------	
	-- display_handler_instance : display_handler port map(reset, clk, pixel_column_int, pixel_row_int, color);
	
	-- -- pixelDraw : process(clk, rst_n) is
	
	-- -- begin
			
		-- -- if (rising_edge(clk)) then
			
		-- -- end if;
		
	-- -- end process pixelDraw;	

-- --------------------------------------------------------------------------------------------
	
end architecture behavioral;		