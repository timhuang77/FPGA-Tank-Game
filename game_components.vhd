library IEEE;
use IEEE.std_logic_1164.all;

package game_components is 
	type position is array(0 to 1) of integer;

	component bram is
		generic (
			constant RAM_size : integer := 307200
		);
		port (
			q : out std_logic_vector(7 downto 0);	-- 24-bit color
			d : in std_logic_vector(7 downto 0);
			-- q : out std_logic;
			-- d : in std_logic;
			raddr : in std_logic_vector(19 downto 0);	--19-bit address
			waddr : in std_logic_vector(19 downto 0);
			we : in std_logic;
			clk : in std_logic
		);
	end component bram;
	
	component VGA_top_level is
		port(
				CLOCK_50 										: in std_logic;
				RESET_N											: in std_logic;
		
				--VGA 
				VGA_RED, VGA_GREEN, VGA_BLUE 					: out std_logic_vector(7 downto 0); 
				HORIZ_SYNC, VERT_SYNC, VGA_BLANK, VGA_CLK		: out std_logic

			);
	end component VGA_top_level;
	
	component tank is
		generic(
			pos_x_init : integer;
			pos_y_init : integer
		);
		port(
			clk, rst, we : in std_logic;
			pos_in : in position;
			pos_out : out position
		);
		
	--entity description
		--Generic parameters : object width, height, x and y positions
		--Function: Stores attributes such as position (x,y), bullet_fired
		--			
	end component tank;
	
	component bullet is
		generic(
			pos_x_init : integer;
			pos_y_init : integer
		);
		port(
			clk, rst, we : in std_logic;
			pos_in : in position;
			pos_out : out position;
			bullet_fired : inout std_logic
		);

	--entity description:
	  --Generic parameters: object width, object height, x position, y position
	  --Function: Stores the x and y position
	end component bullet;
	
	


end package game_components;

package body game_components is
end package body game_components;