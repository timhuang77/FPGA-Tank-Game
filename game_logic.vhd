library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.game_components.all;
use work.tank_functions.all;
use work.tank_const.all;

entity game_logic is
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
end entity game_logic;



architecture behavioral of game_logic is
	--types
	
	--constants
	constant bullet_speed : integer := 15;
	signal speed_A_updated, speed_B_updated : std_logic;
	signal collision_count_A, collision_count_B : integer := 0;
	signal tank_A_pos, tank_B_pos : position;
	signal tank_A_speed, tank_B_speed : integer := 10;
	signal tank_A_dir, tank_B_dir : std_logic := '0';
		--left: 0
		--right: 1
	signal bullet_A_fired, bullet_B_fired : std_logic;
	signal bullet_A_pos, bullet_B_pos : position;
	signal score_A, score_B : integer := 0;
	
	begin

	
	--Process for UDPATING TANK SPEED
	speed_update : process(clk, rst) is
	begin
		if (rising_edge(clk)) then
			--check only every other cycles
			if (global_write_enable = '0') then
				tank_A_speed <= tank_A_speed_in;
				tank_B_speed <= tank_B_speed_in;
			else
				if (player_A_speed = '1' and speed_A_updated = '0') then
					if (tank_A_speed = 30) then
						tank_A_speed <= 10;
						speed_A_updated <= '1';
					else 
						tank_A_speed <= tank_A_speed + 10;
						speed_A_updated <= '1';
					end if;
				elsif (player_A_speed = '0' and speed_A_updated = '1') then
					--could place a counter here to delay flag unset even more
					speed_A_updated <= '0';
				end if;
				
				if (player_B_speed = '1' and speed_B_updated = '0') then
					if (tank_B_speed = 30) then
						tank_B_speed <= 10;
						speed_B_updated <= '1';
					else 
						tank_B_speed <= tank_B_speed + 10;
						speed_B_updated <= '1';
					end if;
				elsif (player_B_speed = '0' and speed_B_updated = '1') then
					--could place a counter here to delay flag unset even more
					speed_B_updated <= '0';
				end if;
			end if;


		end if;
	end process;
	
	
	
	--Process for UDPATING TANK POSITION
	tank_update : process(clk, rst) is
		variable tank_A_pos_temp, tank_B_pos_temp : integer;
	begin 
		if (rising_edge(clk)) then
			if (global_write_enable = '0') then --read state
				--tank A
				tank_A_pos_temp := tank_A_pos_in(0);
				if (tank_A_dir = '1') then --update position based on direction
					-- go further right
					tank_A_pos(0) <= tank_A_pos_temp + tank_A_speed;
				else
					-- go further left
					tank_A_pos(0) <= tank_A_pos_temp - tank_A_speed;
				end if;
				
				--tank B
				tank_B_pos_temp := tank_B_pos_in(0);
				if (tank_B_dir = '1') then --update position based on direction
					-- go further right
					tank_B_pos(0) <= tank_B_pos_temp + tank_B_speed;
				else
					-- go further left
					tank_B_pos(0) <= tank_B_pos_temp - tank_B_speed;
				end if;			
				
				tank_A_pos(1) <= tank_A_pos_in(1);
				tank_B_pos(1) <= tank_B_pos_in(1);
			else 								--write state
				--tank A
				if ((tank_A_pos(0) - TANK_WIDTH/2) >= TANK_WIDTH_BUFFER and (tank_A_pos(0) + TANK_WIDTH/2) < (679 - TANK_WIDTH_BUFFER)) then  
					--tank within bounds
					tank_A_pos_out(0) <= tank_A_pos(0);
				else
					--tank out of bounds
					if ((tank_A_pos(0) + TANK_WIDTH/2) > (679 - TANK_WIDTH_BUFFER)) then --position beyond right bound
						tank_A_pos_out(0) <= 679 - TANK_WIDTH_BUFFER - TANK_WIDTH/2;
					else --position beneath left bound
						tank_A_pos_out(0) <= 0 + TANK_WIDTH_BUFFER + TANK_WIDTH/2;
					end if;
				end if; 
				
				--tank B
				if ((tank_B_pos(0) - TANK_WIDTH/2) >= TANK_WIDTH_BUFFER and (tank_B_pos(0) + TANK_WIDTH/2) < (679 - TANK_WIDTH_BUFFER)) then  
					--tank within bounds
					tank_B_pos_out(0) <= tank_B_pos(0);
				else
					--tank out of bounds
					if ((tank_B_pos(0) + TANK_WIDTH/2) > (679 - TANK_WIDTH_BUFFER)) then --position beyond right bound
						tank_B_pos_out(0) <= 679 - TANK_WIDTH_BUFFER - TANK_WIDTH/2;
					else --position beneath left bound
						tank_B_pos_out(0) <= 0 + TANK_WIDTH_BUFFER + TANK_WIDTH/2;
					end if;
				end if; 

				tank_A_pos_out(1) <= tank_A_pos(1); --fixed vertical value
				tank_B_pos_out(1) <= tank_B_pos(1); --fixed vertical value
			end if;

		end if;
	end process;
	
	
	--Process for UPDATING BULLET POSITION
	bullet_update : process(clk, rst) is
		variable bullet_A_temp, bullet_B_tmep : integer;
	begin
		if (rising_edge(clk)) then
			if (global_write_enable = '0') then --read state
				bullet_A_fired <= bullet_A_fired_in;
				bullet_A_pos(1) <= bullet_A_pos_in(1) + bullet_speed; --bullet A travels downwards
				bullet_B_fired <= bullet_B_fired_in;
				bullet_B_pos(1) <= bullet_B_pos_in(1) - bullet_speed; --bullet B travels upwards
			
				bullet_A_pos(0) <= bullet_A_pos_in(0);
				bullet_B_pos(0) <= bullet_B_pos_in(0);
			else --write state
				if (collision_detection(tank_B_pos, bullet_A_pos) = '1') then
					-- collision detected, bullet A hit tank B
					score_A <= score_A + 1;
					--don't show bullet	
					bullet_A_display <= '0';
				elsif ((bullet_A_pos(1) + BULLET_HEIGHT/2) >= 679) then
					-- bullet out of bounds, don't show bullet
					--unset bullet fired flag
					bullet_A_fired_out <= '0';
					bullet_A_display <= '0';
				elsif (bullet_A_fired = '0' and player_A_fire = '1') then
					--player first fires bullet
					bullet_A_pos_out <= tank_A_pos;
					bullet_A_display <= '1';
					bullet_A_fired_out <= '1';
				elsif (bullet_A_fired = '1') then
					bullet_A_pos_out <= bullet_A_pos;
					bullet_A_display <= '1';
					bullet_A_fired_out <= '1';
				end if;
				
				if (collision_detection(tank_A_pos, bullet_B_pos) = '1') then
					-- collision detected, bullet A hit tank B
					score_B <= score_B + 1;
					--don't show bullet	
					bullet_B_display <= '0';
				elsif ((bullet_B_pos(1) + BULLET_HEIGHT/2) >= 679) then
					-- bullet out of bounds, don't show bullet
					--unset bullet fired flag
					bullet_B_fired_out <= '0';
					bullet_B_display <= '0';
				elsif (bullet_B_fired = '0' and player_B_fire = '1') then
					--player first fires bullet
					bullet_B_pos_out <= tank_A_pos;
					bullet_B_display <= '1';
					bullet_B_fired_out <= '1';
				elsif (bullet_B_fired = '1') then
					bullet_B_pos_out <= bullet_B_pos;
					bullet_B_display <= '1';
					bullet_B_fired_out <= '1';
				end if;
				
			end if;
		end if;
	end process;
	
	game_score_update : process(clk, rst) is 
	begin
		if (rst = '1') then
			score_A_out <= 0;
			score_B_out <= 0;
		elsif (rising_edge(clk)) then
			if (score_A >= MAX_SCORE) then
				tank_B_display <= '0';
			elsif (score_B >= MAX_SCORE) then
				tank_A_display <= '0';
			else
				tank_A_display <= '1';
				tank_B_display <= '1';
			end if;
			score_A_out <= score_A;
			score_B_out <= score_B;
			
		end if;
	end process;

end architecture behavioral;