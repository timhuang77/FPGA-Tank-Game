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

		--LCD
		 LCD_RS, LCD_E, LCD_ON, RESET_LED, SEC_LED : out std_logic;
		 LCD_RW : buffer std_logic;
		 DATA_BUS : inout std_logic_vector(7 DOWNTO 0);

		--Keyboard inputs
		keyboard_clk, keyboard_data, clock_50MHZ : in std_logic;


		--VGA
		VGA_RED, VGA_GREEN, VGA_BLUE : out std_logic_vector(7 downto 0);
		HORIZ_SYNC, VERT_SYNC, VGA_BLANK, VGA_CLK : out std_logic;
		
		--Score
		segments_out_A, segments_out_B : out std_logic_vector(6 downto 0)

	--	B_fire_pb_n, A_fire_pb_n : in std_logic
	);
end entity tank_top_level;

architecture structural of tank_top_level is
	signal reset : std_logic := '0';
	signal global_write_enable : std_logic := '0';
	signal global_read_enable : std_logic;
	signal A_fire_pb, B_fire_pb : std_logic;

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

	signal bullet_fired_signal : std_logic;

	signal cycle : integer := 0;

	--Signals for 25 fps clock
	signal clock_divided	: std_logic := '0';

	--Keyboard input
	signal hist3, hist2, hist1, hist0 :  std_logic_vector(7 downto 0);
	signal kb_scan_code :  std_logic_vector(7 DOWNTO 0);
	signal kb_scan_ready : std_logic;
	signal hist210 : std_logic_vector(23 downto 0) := (others => '0');
	signal bullet_A_fixed : position;
	signal bullet_B_fixed : position;
	signal debug_flag_A, debug_flag_B : std_logic := '0';
	signal keyboard_counter : integer := 0;
	signal score_A_signal_slv : std_logic_vector(3 downto 0);
	signal score_B_signal_slv : std_logic_vector(3 downto 0);
	signal segments_out_signal_A : std_logic_vector(6 downto 0);
	signal segments_out_signal_B : std_logic_vector(6 downto 0);
	
	signal LCD_RS_signal : std_logic;
	signal LCD_E_signal : std_logic;
	signal LCD_ON_signal : std_logic;
	signal RESET_LED_signal : std_logic;
	signal SEC_LED_signal : std_logic;
	signal LCD_RW_signal : std_logic;						
	signal DATA_BUS_signal 	: std_logic_vector(7 downto 0);
	signal input_reader_signal : std_logic;			
	signal no_winner_signal : std_logic;	

begin
--	bullet_A_fixed(0) <= 300;
--	bullet_A_fixed(1) <= 120;
--	bullet_B_fixed(0) <= 250;
--	bullet_B_fixed(1) <= 290;

	score_A_signal_slv <= std_logic_vector(to_unsigned(score_A_signal, 4));
	score_B_signal_slv <= std_logic_vector(to_unsigned(score_B_signal, 4));
	
	segments_out_A <= segments_out_signal_A;
	segments_out_B <= segments_out_signal_B;
	
	no_winner_signal <= '1' when ((score_A_signal < MAX_SCORE) and (score_B_signal < MAX_SCORE)) else
								'0';
								
	input_reader_signal <= '1' when (score_A_signal >= MAX_SCORE) else
									'0';
									
	LCD_RS <= LCD_RS_signal; 
	LCD_E <= LCD_E_signal;
	LCD_ON <= LCD_ON_signal;
	RESET_LED <= RESET_LED_signal;
	SEC_LED <= SEC_LED_signal;
	LCD_RW <= LCD_RW_signal;
	DATA_BUS <= DATA_BUS_signal;

--	if ((score_A_signal >= MAX_SCORE) or (score_B_signal >= MAX_SCORE)) then
--		no_winner_signal <= '0';
--	else
--		no_winner_signal <= '1';
--	end if;
--	
--	if (score_A_signal >= MAX_SCORE) then
--		input_reader_signal <= '1';
--	else
--		input_reader_signal <= '0';
--	end if;

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
--	A_fire_pb <= not A_fire_pb_n;
--	B_fire_pb <= not B_fire_pb_n;

	alt_cycle : process(clock_divided, reset) is begin
		if (reset = '1') then
			global_write_enable <= '0';
			cycle <= 0;
		elsif (rising_edge(clock_divided) and (cycle /= 3)) then
			cycle <= cycle + 1;
			-- if (cycle = 2) then

		elsif (rising_edge(clock_divided) and (cycle = 3)) then
			global_write_enable <= not global_write_enable;
			cycle <= 0;
		end if;
	end process;

	global_read_enable <= not global_write_enable;

	process(clk, reset)
		variable counter : integer := 0;
	begin
		if (rising_edge(clk)) then
			if (counter = DIVIDE_CONSTANT) then

				clock_divided <= not clock_divided;
				counter := 0;
			else
				counter := counter + 1;
			end if;
		end if;
	end process;


	--hist210 <= hist2 & hist1 & hist0;
	keyboard_process: process(clk, reset) is begin
			if ((to_integer(unsigned(hist0)) = 29) and (to_integer(unsigned(hist1)) /= 240)) then
			--if (to_integer(unsigned(hist0)) = 226) then
				player_A_fire <= '1';
			elsif ((to_integer(unsigned(hist0)) = 35) and (to_integer(unsigned(hist1)) /= 240)) then
				player_A_speed <= '1';
			elsif ((to_integer(unsigned(hist0)) = 115) and (to_integer(unsigned(hist1)) /= 240)) then
				player_B_fire <= '1';
			elsif ((to_integer(unsigned(hist0)) = 122) and (to_integer(unsigned(hist1)) /= 240)) then
				player_B_speed <= '1';
			else
				player_A_fire <= '0';
				player_A_speed <= '0';
				player_B_fire <= '0';
				player_B_speed <= '0';
			end if;
	end process;

	VGA_component : VGA_top_level
		port map(
			CLOCK_50 => clk,
			RESET_N => reset_n,
			tank_A_pos => tank_A_pos_outin,
			tank_B_pos => tank_B_pos_outin,
			tank_A_display => tank_A_display_flag,
			tank_B_display => tank_B_display_flag,
			-- tank_A_display => debug_flag_A,
			-- tank_B_display => debug_flag_B,
			bullet_A_pos => bullet_A_pos_outin,
			bullet_B_pos => bullet_B_pos_outin,
			-- bullet_A_pos => bullet_A_fixed,
			-- bullet_B_pos => bullet_B_fixed,
			bullet_A_display => bullet_A_display_flag,
			bullet_B_display => bullet_B_display_flag,
			-- bullet_A_display => '1',
			-- bullet_B_display => '1',
			VGA_RED => VGA_RED,
			VGA_GREEN => VGA_GREEN,
			VGA_BLUE => VGA_BLUE,
			HORIZ_SYNC => HORIZ_SYNC,
			VERT_SYNC => VERT_SYNC,
			VGA_BLANK => VGA_BLANK,
			VGA_CLK => VGA_CLK
		);

	Keyboard : ps2
		port map(
		keyboard_clk => keyboard_clk,
		keyboard_data => keyboard_data,
		clock_50MHz => clk,
		reset => reset_n,
		scan_code => kb_scan_code,
		scan_readyo => kb_scan_ready,
		hist3 => hist3,
		hist2 => hist2,
		hist1 => hist1,
		hist0 => hist0
		);

	--Port maps: connecting components
	logic_component : game_logic
		port map(
			clk => clock_divided,
			rst => reset,
			global_write_enable => global_read_enable,

			--Player A
			player_A_speed => player_A_speed,
			player_A_fire => player_A_fire,
			--player_A_fire => A_fire_pb,
			tank_A_pos_in => tank_A_pos_inout,
			tank_A_pos_out => tank_A_pos_outin,
			tank_A_speed_in => tank_A_speed_inout,
			tank_A_speed_out => tank_A_speed_outin,
			tank_A_display => tank_A_display_flag,
			bullet_A_pos_in => bullet_A_pos_inout,
			bullet_A_pos_out => bullet_A_pos_outin,
			-- bullet_A_fired_in => '1',
			bullet_A_fired_in => bullet_A_fired_inout,
			bullet_A_fired_out => bullet_A_fired_outin,
			bullet_A_display => bullet_A_display_flag,
			score_A_out => score_A_signal,

			--Player B
			player_B_speed => player_B_speed,
			player_B_fire => player_B_fire,
			--player_B_fire => B_fire_pb,
			tank_B_pos_in => tank_B_pos_inout,
			tank_B_pos_out => tank_B_pos_outin,
			tank_B_speed_in => tank_B_speed_inout,
			tank_B_speed_out => tank_B_speed_outin,
			tank_B_display => tank_B_display_flag,
			bullet_B_pos_in => bullet_B_pos_inout,
			bullet_B_pos_out => bullet_B_pos_outin,
			-- bullet_B_fired_in => '1',
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
			clk => clock_divided,
			rst => reset,
			we => global_write_enable,
			pos_in => tank_A_pos_outin,
			pos_out => tank_A_pos_inout,
			speed_in => tank_A_speed_outin,
			speed_out => tank_A_speed_inout
		);

	tank_B : tank
		generic map (
			pos_x_init => TANK_B_INIT_POS_X,
			pos_y_init => TANK_B_INIT_POS_Y
		)
		port map(
			clk => clock_divided,
			rst => reset,
			we => global_write_enable,
			pos_in => tank_B_pos_outin,
			pos_out => tank_B_pos_inout,
			speed_in => tank_B_speed_outin,
			speed_out => tank_B_speed_inout
		);

	bullet_A : bullet
		generic map(
			default_pos_x => TANK_A_INIT_POS_X,
			default_pos_y => TANK_A_INIT_POS_Y
		)
		port map(
			clk => clock_divided,
			rst => reset,
			we => global_write_enable,
			pos_in => bullet_A_pos_outin,
			pos_out => bullet_A_pos_inout,
			bullet_fired_in => bullet_A_fired_outin,
			bullet_fired_out => bullet_A_fired_inout
		);

	bullet_B : bullet
		generic map(
			default_pos_x => TANK_B_INIT_POS_X,
			default_pos_y => TANK_B_INIT_POS_Y
		)
		port map(
			clk => clock_divided,
			rst => reset,
			we => global_write_enable,
			pos_in => bullet_B_pos_outin,
			pos_out => bullet_B_pos_inout,
			bullet_fired_in => bullet_B_fired_outin,
			bullet_fired_out => bullet_B_fired_inout
		);
		
	score_decoder_A : leddcd 
		port map(
			data_in => score_A_signal_slv,
			segments_out => segments_out_signal_A
		);
		
	score_decoder_B : leddcd 
		port map(
			data_in => score_B_signal_slv,
			segments_out => segments_out_signal_B
		);

	lcd_message : de2lcd
		port map(
			reset => reset_n,
			clk_50Mhz => clk,
		   LCD_RS => LCD_RS_signal,
			LCD_E => LCD_E_signal,
			LCD_ON => LCD_ON_signal,
			RESET_LED => RESET_LED_signal,
			SEC_LED => SEC_LED_signal,
			LCD_RW => LCD_RW_signal,						
			DATA_BUS	=> DATA_BUS_signal,			
			input_reader => input_reader_signal,			
			no_winner => no_winner_signal	
		);

end architecture structural;
