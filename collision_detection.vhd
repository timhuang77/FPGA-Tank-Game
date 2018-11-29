library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.game_components.all;
use work.tank_functions.all;

entity collision_detection is
	port(
		clk, rst, we : in std_logic;
		collision_flag : inout std_logic;
		collisions : inout integer;
	);
end entity collision_detection;

architecture behavioral of collision_detection is
	--component
	--types
	--signals
	signal collisions_register : integer;

begin
	process(clk, rst)
	begin
		if (rst = '1') then
			collisions_register <= 0;
		elsif (rising_edge(clk)) then
			if (we = '1') then
				if (collision_flag = '1') then 
					collisions_register <= collisions_register + 1;
				end if;

			else 
				co
			end if;
		end if;'
		
		
	end process;

architecture behavioral;