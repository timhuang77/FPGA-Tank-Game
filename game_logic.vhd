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
		bullet_A_fired_out, bullet_B_fired_out : out std_logic := '0';
		bullet_A_display, bullet_B_display : out std_logic;

		--Score keeping
		score_A_out, score_B_out : out integer

	);
end entity game_logic;



architecture behavioral of game_logic is
	--types

	--constants
	constant bullet_speed : integer := 15;
	signal speed_A_updated, speed_B_updated : std_logic := '0';
	signal collision_count_A, collision_count_B : integer := 0;
	signal tank_A_pos, tank_B_pos : position;
	signal tank_A_speed, tank_B_speed : integer := 5;
	-- signal tank_A_dir, tank_B_dir : std_logic := '0';
		--left: 0
		--right: 1
	signal bullet_A_fired, bullet_B_fired : std_logic;
	signal bullet_A_pos, bullet_B_pos : position;
	signal score_A, score_B : integer := 0;
	signal bullet_A_display_signal, bullet_B_display_signal : std_logic;

	begin


	--Process for UDPATING TANK SPEED
	speed_update : process(clk, rst) is
		variable speed_A_temp, speed_B_temp : integer := DEFAULT_TANK_SPEED;
		variable speed_A_updated, speed_B_updated : std_logic := '0';
		variable speed_A_incremented, speed_B_incremented : std_logic := '0';
		variable counter, counter2 : integer := 0;
		variable max_A_speed_flag, max_B_speed_flag : std_logic := '0';
	begin
		if (rst = '1') then
			speed_A_updated := '0';
			speed_B_updated := '0';
			max_A_speed_flag := '0';
			max_B_speed_flag := '0';
			speed_A_temp := DEFAULT_TANK_SPEED;
			speed_B_temp := DEFAULT_TANK_SPEED;
			counter := 0;
			counter2 := 0;
			speed_A_incremented := '0';
			speed_B_incremented := '0';
		elsif (rising_edge(clk)) then
			--check only every other cycle
			if (global_write_enable = '1') then
				speed_A_temp := tank_A_speed_in;
				speed_B_temp := tank_B_speed_in;
				
				if(speed_A_incremented = '1') then
					counter := counter + 1;
					if (counter = 10) then
						counter := 0;
						speed_A_incremented := '0';
					end if;
				elsif (player_A_speed = '1' and speed_A_incremented = '0') then --read state
--					if (speed_A_temp > 3*DEFAULT_TANK_SPEED) then
					if (max_A_speed_flag = '1') then
						speed_A_temp := DEFAULT_TANK_SPEED;
						speed_A_updated := '1';
						speed_A_incremented := '1';
						max_A_speed_flag := '0';
					else
						speed_A_temp := speed_A_temp + DEFAULT_TANK_SPEED;
						speed_A_updated := '1';
						speed_A_incremented := '1';
					end if;
				end if;
				
				if(speed_B_incremented = '1') then
					counter2 := counter2 + 1;
					if (counter2 = 10) then
						counter2 := 0;
						speed_B_incremented := '0';
					end if;
				elsif (player_B_speed = '1' and speed_B_incremented = '0') then --read state
--					if (speed_B_temp >= 3*DEFAULT_TANK_SPEED) then
					if (max_B_speed_flag = '1') then
						speed_B_temp := DEFAULT_TANK_SPEED;
						speed_B_updated := '1';
						speed_B_incremented := '1';
						max_B_speed_flag := '0';
					else
						speed_B_temp := speed_B_temp + DEFAULT_TANK_SPEED;
						speed_B_updated := '1';
						speed_B_incremented := '1';
					end if;
				end if;
			else								--write state

				tank_A_speed_out <= speed_A_temp;
				if (speed_A_temp = 3*DEFAULT_TANK_SPEED) then
					max_A_speed_flag := '1';
				end if;
				tank_B_speed_out <= speed_B_temp;
				if (speed_B_temp = 3*DEFAULT_TANK_SPEED) then
					max_B_speed_flag := '1';
				end if;

			end if;
			if (player_A_speed = '0') then
				speed_A_updated := '0';
			end if;
			if (player_B_speed = '0') then
				speed_B_updated := '0';
			end if;

		end if;
	end process;



	--Process for UDPATING TANK POSITION
	tank_update : process(clk, rst) is
		variable tank_A_pos_temp, tank_B_pos_temp : integer;
		variable tank_A_dir, tank_B_dir, tank_A_dir_flag, tank_B_dir_flag: std_logic := '0';
	begin
		-- if (rst = '1') then
			-- tank_A_pos(0) <= TANK_A_INIT_POS_X;
			-- tank_A_pos(1) <= TANK_A_INIT_POS_Y;
		-- els
		if (rising_edge(clk)) then
			if (global_write_enable = '1') then --read state
				--tank A
				tank_A_pos_temp := tank_A_pos_in(0);
				if (tank_A_dir = '1') then --update position based on direction
					-- go further right
					tank_A_pos(0) <= tank_A_pos_temp + tank_A_speed_in;
				else
					-- go further left
					tank_A_pos(0) <= tank_A_pos_temp - tank_A_speed_in;
				end if;

				--tank B
				tank_B_pos_temp := tank_B_pos_in(0);
				if (tank_B_dir = '1') then --update position based on direction
					-- go further right
					tank_B_pos(0) <= tank_B_pos_temp + tank_B_speed_in;
				else
					-- go further left
					tank_B_pos(0) <= tank_B_pos_temp - tank_B_speed_in;
				end if;

				tank_A_pos(1) <= tank_A_pos_in(1);
				tank_B_pos(1) <= tank_B_pos_in(1);
				tank_A_dir_flag := '0';
				tank_B_dir_flag := '0';
			else 								--write state
				--tank A
				if (((tank_A_pos(0) - TANK_WIDTH/2) >= TANK_WIDTH_BUFFER) and ((tank_A_pos(0) + TANK_WIDTH/2) < (col_size - 1 - TANK_WIDTH_BUFFER))) then
					--tank within bounds
					tank_A_pos_out(0) <= tank_A_pos(0);
					-- tank_A_pos_out(0) <= 800; --for debugging

				else
					--tank out of bounds
					if (tank_A_dir_flag = '0') then
						tank_A_dir := not tank_A_dir;
						tank_A_dir_flag := '1';
					else
						tank_A_dir_flag := '1';
					end if;

					if ((tank_A_pos(0) + TANK_WIDTH/2) > (col_size - 1 - TANK_WIDTH_BUFFER)) then --position beyond right bound
						tank_A_pos_out(0) <= col_size - 1 - TANK_WIDTH_BUFFER - TANK_WIDTH/2;
						-- tank_A_pos_out(0) <= 800; --for debugging

					else --position beneath left bound
						tank_A_pos_out(0) <= 0 + TANK_WIDTH_BUFFER + TANK_WIDTH/2;
						-- tank_A_pos_out(0) <= 800; --for debugging
					end if;
				end if;

				--tank B
				if ((tank_B_pos(0) - TANK_WIDTH/2) >= TANK_WIDTH_BUFFER and (tank_B_pos(0) + TANK_WIDTH/2) <= (col_size - 1 - TANK_WIDTH_BUFFER)) then
					--tank within bounds
					tank_B_pos_out(0) <= tank_B_pos(0);
				else
					--tank out of bounds
					if (tank_B_dir_flag = '0') then
						tank_B_dir := not tank_B_dir;
						tank_B_dir_flag := '1';
					else
						tank_B_dir_flag := '1';
					end if;

					if ((tank_B_pos(0) + TANK_WIDTH/2) > (col_size - 1 - TANK_WIDTH_BUFFER)) then --position beyond right bound
						tank_B_pos_out(0) <= col_size - 1 - TANK_WIDTH_BUFFER - TANK_WIDTH/2;
					else --position beneath left bound
						tank_B_pos_out(0) <= 0 + TANK_WIDTH_BUFFER + TANK_WIDTH/2;
					end if;
				end if;
				-- tank_A_pos_out(0) <= 900;
				-- tank_A_pos_out(1) <= 800; --for debugging
				tank_A_pos_out(1) <= tank_A_pos(1); --fixed vertical value
				tank_B_pos_out(1) <= tank_B_pos(1); --fixed vertical value
			end if;

		end if;
	end process;
	
--	--Timer to make sure bullet hit only counts once
--	process(clk, rst, score_A_incremented)
--	variable counter : integer := 0;
--	begin
--		if (rising_edge(clk)) then
--			if (score_A_incremented = '1' and counter < 25000000) then
--				counter := counter + 1;
--			else
--				score_A_incremented <= '0';
--				counter := 0;
--			end if;
--		end if;
--	end process;


	--Process for UPDATING BULLET POSITION
	bullet_A_display <= bullet_A_display_signal;
	bullet_B_display <= bullet_B_display_signal;
	
	bullet_update : process(clk, rst) is
	variable score_A_incremented : std_logic := '0';
	variable counter : integer := 0;
	variable score_B_incremented : std_logic := '0';
	variable counter2 : integer := 0;
	begin
		if (rst = '1') then
			score_A <= 0;
			score_B <= 0;
			score_A_incremented := '0';
			score_B_incremented := '0';
			counter := 0;
			counter2 := 0;
			bullet_A_display_signal <= '0';
			bullet_B_display_signal <= '0';
			bullet_A_fired_out <= '0';
			bullet_B_fired_out <= '0';
		elsif (rising_edge(clk)) then
			if (global_write_enable = '1') then --read state
				bullet_A_fired <= bullet_A_fired_in;
				bullet_A_pos(1) <= bullet_A_pos_in(1) - bullet_speed; --bullet A travels upwards
				bullet_B_fired <= bullet_B_fired_in;
				bullet_B_pos(1) <= bullet_B_pos_in(1) + bullet_speed; --bullet B travels downwards

				bullet_A_pos(0) <= bullet_A_pos_in(0);
				bullet_B_pos(0) <= bullet_B_pos_in(0);
			else 								--write state
				--if (collision_detection(tank_B_pos, bullet_A_pos) = '0') then
				if (score_A_incremented = '1') then
						counter := counter + 1;
						bullet_A_display_signal <= '0';
						bullet_A_pos_out <= tank_A_pos;
						bullet_A_fired_out <= '0';
						if (counter = 30) then
							score_A_incremented := '0';
							counter := 0;
						end if;
				elsif((bullet_A_pos(1) - BULLET_HEIGHT/2 < tank_B_pos(1) + TANK_HEIGHT/2) 
				and (bullet_A_pos(1) + BULLET_HEIGHT/2 > tank_B_pos(1) - TANK_HEIGHT/2)
				and (bullet_A_pos(0) - BULLET_WIDTH/2 < tank_B_pos(0) + TANK_WIDTH/2)
				and (bullet_A_pos(0) + BULLET_WIDTH/2 > tank_B_pos(0) - TANK_WIDTH/2)
				and (score_A_incremented = '0')) then
					-- collision detected, bullet A hit tank B
					score_A <= score_A + 1;
					--don't show bullet
					bullet_A_display_signal <= '0';
--					bullet_A_fired_out <= '0';
					bullet_A_fired <= '0';
					score_A_incremented := '1';
					bullet_A_pos_out <= tank_A_pos;
				elsif (bullet_A_fired = '1' and ((bullet_A_pos(1) + BULLET_HEIGHT/2 + 1) <= 0)) then
					-- bullet out of bounds, reset conditions
					--unset bullet fired flag
					bullet_A_fired_out <= '0';
					bullet_A_display_signal <= '0';
					bullet_A_fired <= '0';
					bullet_A_pos_out <= tank_A_pos;
				elsif (bullet_A_fired = '0' and player_A_fire = '1') then
					--player first fires bullet
					bullet_A_pos_out <= tank_A_pos;
					bullet_A_display_signal <= '1';
					bullet_A_fired_out <= '1';
				elsif (bullet_A_fired = '1') then
					--bullet already fired
					bullet_A_pos_out <= bullet_A_pos;
					bullet_A_display_signal <= '1';
					bullet_A_fired_out <= '1';
				end if;

				--if (collision_detection(tank_A_pos, bullet_B_pos) = '0') then
				if (score_B_incremented = '1') then
						counter2 := counter2 + 1;
						bullet_B_display_signal <= '0';
						bullet_B_pos_out <= tank_B_pos;
						bullet_B_fired_out <= '0';
						if (counter2 = 30) then
							score_B_incremented := '0';
							counter2 := 0;
						end if;
				elsif((bullet_B_pos(1) - BULLET_HEIGHT/2 < tank_A_pos(1) + TANK_HEIGHT/2) 
				and (bullet_B_pos(1) + BULLET_HEIGHT/2 > tank_A_pos(1) - TANK_HEIGHT/2)
				and (bullet_B_pos(0) - BULLET_WIDTH/2 < tank_A_pos(0) + TANK_WIDTH/2)
				and (bullet_B_pos(0) + BULLET_WIDTH/2 > tank_A_pos(0) - TANK_WIDTH/2)
				and (score_B_incremented = '0')) then
					-- collision detected, bullet B hit tank A
					score_B <= score_B + 1;
					--don't show bullet
					bullet_B_display_signal <= '0';
--					bullet_B_fired_out <= '0';
					bullet_B_fired <= '0';
					score_B_incremented := '1';
					bullet_B_pos_out <= tank_B_pos;
				elsif (bullet_B_fired = '1' and ((bullet_B_pos(1) + BULLET_HEIGHT/2) >= (row_size - 1))) then
					-- bullet out of bounds, reset conditions
					--unset bullet fired flag
					bullet_B_fired_out <= '0';
					bullet_B_display_signal <= '0';
					bullet_B_fired <= '0';
					bullet_B_pos_out <= tank_B_pos;
				elsif (bullet_B_fired = '0' and player_B_fire = '1') then
					--player first fires bullet
					bullet_B_pos_out <= tank_B_pos;
					bullet_B_display_signal <= '1';
					bullet_B_fired_out <= '1';
				elsif (bullet_B_fired = '1') then
					bullet_B_pos_out <= bullet_B_pos;
					bullet_B_display_signal <= '1';
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
