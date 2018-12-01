library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.game_components.all;
use work.tank_functions.all;
use work.tank_const.all;

entity tank_top_level is
	port(
		--Basic control signals
		clk, reset_n : in std_logic;
		
		-- --LCD
		 -- LCD_RS, LCD_E, LCD_ON, RESET_LED, SEC_LED : out std_logic;
		 -- LCD_RW : buffer std_logic;
		 -- DATA_BUS : inout std_logic_vector(7 DOWNTO 0);
		
		-- --Keyboard inputs
		-- keyboard_clk, keyboard_data, kb_read : in std_logic;
		-- kb_scan_code : out std_logic_vector( 7 DOWNTO 0 );
		-- kb_scan_ready : out std_logic;
		
		-- --VGA 
		-- VGA_RED, VGA_GREEN, VGA_BLUE : out std_logic_vector(7 downto 0); 
		-- HORIZ_SYNC, VERT_SYNC, VGA_BLANK, VGA_CLK : out std_logic
		
		player_speed, player_fire : in std_logic
	);
end entity tank_top_level;

architecture structural of tank_top_level is
	signal reset : std_logic := '0';
	signal global_write_enable : std_logic := '0';
	signal global_read_enable : std_logic;

	--Player A signals
	signal tank_A_pos_inout, tank_A_pos_outin, bullet_A_pos_inout, bullet_A_pos_outin : position;
	signal tank_A_speed_inout, tank_A_speed_outin : integer;
	signal player_A_speed, player_A_fire, tank_A_display_flag, bullet_A_fired_inout, bullet_A_fired_outin, bullet_A_display_flag : std_logic;
	signal score_A_signal : integer;

	--Player B signals
	signal tank_B_pos_inout, tank_B_pos_outin, bullet_B_pos_inout, bullet_B_pos_outin : position;
	signal tank_B_speed_inout, tank_B_speed_outin : integer;
	signal player_B_speed, player_B_fire, tank_B_display_flag, bullet_B_fired_inout, bullet_B_fired_outin, bullet_B_display_flag : std_logic;
	signal score_B_signal : integer;
	
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
	global_read_enable <= not global_write_enable;
	
	--Port maps: connecting components
	logic_component : game_logic
		port map(
			clk => clk,
			rst => reset,
			global_write_enable => global_read_enable,

			--Player A
			player_A_speed => player_A_speed,
			player_A_fire => player_A_fire,
			tank_A_pos_in => tank_A_pos_inout,
			tank_A_pos_out => tank_A_pos_outin,
			tank_A_speed_in => tank_A_speed_inout,
			tank_A_speed_out => tank_A_speed_outin,
			tank_A_display => tank_A_display_flag,
			bullet_A_pos_in => bullet_A_pos_inout,
			bullet_A_pos_out => bullet_A_pos_outin,
			bullet_A_fired_in => bullet_A_fired_inout,
			bullet_A_fired_out => bullet_A_fired_outin,
			bullet_A_display => bullet_A_display_flag,
			score_A_out => score_A_signal,
			
			--Player B
			player_B_speed => player_B_speed,
			player_B_fire => player_B_fire,
			tank_B_pos_in => tank_B_pos_inout,
			tank_B_pos_out => tank_B_pos_outin,
			tank_B_speed_in => tank_B_speed_inout,
			tank_B_speed_out => tank_B_speed_outin,
			tank_B_display => tank_B_display_flag,
			bullet_B_pos_in => bullet_B_pos_inout,
			bullet_B_pos_out => bullet_B_pos_outin,
			bullet_B_fired_in => bullet_B_fired_inout,
			bullet_B_fired_out => bullet_B_fired_outin,
			bullet_B_display => bullet_B_display_flag,
			score_B_out => score_B_signal			
		);
	
	tank_A : tank
		generic map (
			pos_x_init => TANK_A_INIT_POS_X,
			pos_y_init => TANK_A_INIT_POS_Y
		)
		port map(
			clk => clk,
			rst => reset,
			we => global_write_enable,
			pos_in => tank_A_pos_outin,
			pos_out => tank_A_pos_inout,
			speed_in => tank_A_speed_outin,
			speed_out => tank_A_speed_inout
		);
	
	-- bullet_A : bullet
		-- port map(
			-- clk => clk,
			-- rst => reset,
			-- we => global_write_enable,
			-- pos_in => bullet_A_pos_outin,
			-- pos_out => bullet_A_pos_inout
			-- bullet_fired => 
		-- );


	-- );
	
end architecture structural;