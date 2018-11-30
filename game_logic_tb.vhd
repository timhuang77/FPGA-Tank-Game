library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.game_logic;
use work.tank_functions.all;
use work.tank_const.all;

entity game_logic_tb is
end entity game_logic_tb;

architecture behavioral_test_bench of game_logic_tb is
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
	
	signal clk, rst, global_write_enable :std_logic;
	signal player_A_speed, player_A_fire :std_logic := '0';
	signal player_B_speed, player_B_fire :std_logic := '0';
	signal tank_A_pos_in, tank_B_pos_in :position;
	signal tank_A_speed_in, tank_B_speed_in :integer;
	signal tank_A_pos_out, tank_B_pos_out :position;
	signal tank_A_speed_out, tank_B_speed_out :integer;
	signal tank_A_display, tank_B_display :std_logic;
	signal bullet_A_pos_in, bullet_B_pos_in :position;
	signal bullet_A_fired_in, bullet_B_fired_in :std_logic;
	signal bullet_A_pos_out, bullet_B_pos_out :position;
	signal bullet_A_fired_out, bullet_B_fired_out :std_logic;
	signal bullet_A_display, bullet_B_display :std_logic;
	signal score_A_out, score_B_out :integer := 0;
	
	
	--testbench signals
	signal cycle : integer := 0;
	
	begin
		dut : game_logic port map (
			clk => clk, rst => rst,
			global_write_enable => global_write_enable,
			player_A_speed => player_A_speed,
			player_A_fire => player_A_fire,
			player_B_speed => player_B_speed,
			player_B_fire => player_B_fire,
			tank_A_pos_in => tank_A_pos_in,
			tank_B_pos_in => tank_B_pos_in,
			tank_A_speed_in => tank_A_speed_in,
			tank_B_speed_in => tank_B_speed_in,
			tank_A_display => tank_A_display,
			tank_B_display => tank_B_display,
			bullet_A_pos_in => bullet_A_pos_in,
			bullet_B_pos_in => bullet_B_pos_in,
			bullet_A_fired_in => bullet_A_fired_in,
			bullet_B_fired_in => bullet_B_fired_in,
			tank_A_pos_out => tank_A_pos_out,
			tank_B_pos_out => tank_B_pos_out,
			tank_A_speed_out => tank_A_speed_out,
			tank_B_speed_out => tank_B_speed_out,
			bullet_A_pos_out => bullet_A_pos_out,
			bullet_B_pos_out => bullet_B_pos_out,
			bullet_A_fired_out => bullet_A_fired_out,
			bullet_B_fired_out => bullet_B_fired_out,
			bullet_A_display => bullet_A_display,
			bullet_B_display => bullet_B_display,
			score_A_out => score_A_out,
			score_B_out => score_B_out
		);
		
	clk <= not clk after 50 ns;
	
	testbench : process(clk) is begin
		if(rising_edge(clk)) then
			case cycle is
				when 0 => 
					rst <= '1';
					global_write_enable <= '0';
					tank_A_pos_in(0) <= 320;
					tank_A_pos_in(1) <= 20;
					tank_B_pos_in(0) <= 320;
					tank_B_pos_in(1) <= 400;
					player_A_fire <= '1';
				when 1 =>
					rst <= '0';
					global_write_enable <= '1';
				when 2 =>
					global_write_enable <= '0';
				when 3 =>
					global_write_enable <= '1';
				when 4 =>
					global_write_enable <= '0';
				when 5 =>
					global_write_enable <= '1';
				when 6 =>
				when others => wait;
			cycle <= cycle + 1;
		end if;
	end process;
		
		
		
		
		
		
		
		
end architecture behavioral_test_bench;