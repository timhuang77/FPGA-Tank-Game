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
	end component VGA_top_level;
	
	component tank is
		generic(
			pos_x_init : integer;
			pos_y_init : integer
		);
		port(
			clk, rst, we : in std_logic;
			pos_in : in position;
			pos_out : out position;
			speed_in : in integer;
			speed_out : out integer
		);
		
	--entity description
		--Generic parameters : object width, height, x and y positions
		--Function: Stores attributes such as position (x,y), bullet_fired
		--			
	end component tank;
	
	component bullet is
		generic(
			default_pos_x : integer;
			default_pos_y : integer
		);
		port(
			clk, rst, we : in std_logic;
			pos_in : in position;
			pos_out : out position;
			bullet_fired_in : in std_logic;
			bullet_fired_out : out std_logic
		);

	--entity description:
	  --Generic parameters: object width, object height, x position, y position
	  --Function: Stores the x and y position
	end component bullet;
	
	component game_logic is
		port(
			clk, rst, global_write_enable : in std_logic;
			
			--Player A inputs
			player_A_speed, player_A_fire : in std_logic;
			
			--Player B inputs
			player_B_speed, player_B_fire : in std_logic;
			
			--Tank attribute inputs
			tank_A_pos_in, tank_B_pos_in : in position;
			tank_A_speed_in, tank_B_speed_in : in integer;
			
			--Bullet attribute inputs
			bullet_A_pos_in, bullet_B_pos_in : in position;
			bullet_A_fired_in, bullet_B_fired_in : in std_logic;	
			
			--Tank attribute outputs
			tank_A_pos_out, tank_B_pos_out : out position;
			tank_A_speed_out, tank_B_speed_out : out integer;
			tank_A_display, tank_B_display : out std_logic;
			
			--Bullet attribute outputs
			bullet_A_pos_out, bullet_B_pos_out : out position;
			bullet_A_fired_out, bullet_B_fired_out : out std_logic;
			bullet_A_display, bullet_B_display : out std_logic;
			
			--Score keeping
			score_A_out, score_B_out : out integer

		);
	end component game_logic;


end package game_components;

package body game_components is
end package body game_components;