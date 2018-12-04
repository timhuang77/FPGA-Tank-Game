library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.game_components.all;
use work.tank_functions.all;
use work.tank_const.all;

entity tank_top_level_tb is
end entity tank_top_level_tb;

architecture testbench of tank_top_level_tb is
	component tank_top_level is
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
			
			--VGA 
			VGA_RED, VGA_GREEN, VGA_BLUE : out std_logic_vector(7 downto 0); 
			HORIZ_SYNC, VERT_SYNC, VGA_BLANK, VGA_CLK : out std_logic;
			
			player_speed, player_fire : in std_logic
		);
	end component tank_top_level;
	
	signal clk, reset, reset_n : std_logic := '0';
	signal player_speed, player_fire : std_logic := '0';
begin
	reset_n <= not reset;
	dut : tank_top_level port map(
			clk => clk,
			reset_n => reset_n,
			player_speed => player_speed,
			player_fire => player_fire
		);
	
	tb : process is begin
		--cycle 0
			reset <= '1';
			player_speed <= '0';
			clk <= not clk; wait for 400ns;
			clk <= not clk; wait for 400ns;
		--cycle 1
			-- player_fire <= '1';
			-- player_fire <= '1';
			reset <= '0';
			for i in 0 to 3 loop
				clk <= not clk; wait for 400ns;
			end loop;
		--cycle 2 through 9
			for i in 0 to 33 loop
				clk <= not clk; wait for 400ns;
			end loop;
		--cycle 10
			-- player_speed <= '1';
			player_fire <= '1';
			for i in 0 to 2000 loop
				clk <= not clk; wait for 400ns;
			end loop;
			wait;		
	end process;
	
end architecture testbench;