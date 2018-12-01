library IEEE;
use IEEE.std_logic_1164.all;

package tank_const is
	constant MAX_SCORE : integer := 5;
	constant TANK_WIDTH : integer := 20;
	constant TANK_HEIGHT : integer := 30;
	constant BULLET_WIDTH : integer := 4;
	constant BULLET_HEIGHT : integer := 8;
	constant TANK_WIDTH_BUFFER : integer := 5;
	constant TANK_A_INIT_POS_X : integer := 320;
	constant TANK_A_INIT_POS_Y : integer := 639 - TANK_HEIGHT;
	constant TANK_B_INIT_POS_X : integer := 320;
	constant TANK_B_INIT_POS_Y : integer := 0 + TANK_HEIGHT;
	
	
end package tank_const;