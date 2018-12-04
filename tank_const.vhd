library IEEE;
use IEEE.std_logic_1164.all;

package tank_const is
	constant MAX_SCORE : integer := 5;
	constant TANK_WIDTH : integer := 50;
	constant TANK_HEIGHT : integer := 30;
	constant DEFAULT_TANK_SPEED : integer := 10;
	constant BULLET_WIDTH : integer := 4;
	constant BULLET_HEIGHT : integer := 8;
	constant TANK_WIDTH_BUFFER : integer := 5;
	constant TANK_A_INIT_POS_X : integer := 320;
	constant TANK_A_INIT_POS_Y : integer := 480 - TANK_HEIGHT;
	constant TANK_B_INIT_POS_X : integer := 320;
	constant TANK_B_INIT_POS_Y : integer := 0 + TANK_HEIGHT;
	constant TANK_INIT_SPEED : integer := 10;
	constant DIVIDE_CONSTANT : integer := 200000;
	
	
	--Screen dimensions
	constant row_size : integer := 480;
	constant col_size : integer := 640;
	
	--Keyboard scan code
	constant key_W : std_logic_vector (15 downto 0) := x"F01D";
	constant key_D : std_logic_vector (15 downto 0) := x"F023";
	constant key_5 : std_logic_vector (15 downto 0) := x"F073";
	constant key_3 : std_logic_vector (15 downto 0) := x"F07A";
	constant break_key : std_logic_vector (7 downto 0) := x"F0";
end package tank_const;