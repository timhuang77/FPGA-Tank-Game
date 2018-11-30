library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.tank_const.all;

package tank_functions is

	function slv_to_uint(input : in std_logic_vector)
		return integer;

	function int_to_slv(input, size : in integer)
		return std_logic_vector;

	function collision_detection(tank_pos, bullet_pos : in position) return std_logic;

end package tank_functions;

	

package body tank_functions is

	function slv_to_uint(input : in std_logic_vector)
		return integer is

		variable retval : integer;
		begin
		retval := to_integer(unsigned(input));

		return retval;
	end function slv_to_uint;



	function int_to_slv(input, size : in integer)
		return std_logic_vector is

		variable retvec : std_logic_vector(size - 1 downto 0);
		begin
		retvec := std_logic_vector(to_unsigned(input, size));

		return retvec;
	end function int_to_slv;



	function collision_detection(tank_pos, bullet_pos : in position) return std_logic is

		variable collision_flag : std_logic := 0;
		variable top_collision : std_logic := 0;
		variable bottom_collision : std_logic := 0;
		variable left_collision : std_logic := 0;
		variable right_collision : std_logic := 0;

		begin
			if (bullet_pos(1) + BULLET_HEIGHT/2 > tank_pos(1) - TANK_HEIGHT/2) then
				top_collision = '1';
			end if;
			if (bullet_pos(1) - BULLET_HEIGHT/2 < tank_pos(1) + TANK_HEIGHT/2) then
				bottom_collision = '1';
			end if;
			if (bullet_pos(0) + BULLET_WIDTH/2 > tank_pos(0) - TANK_WIDTH/2) then
				left_collision = '1';
			end if;
			if (bullet_pos(0) - BULLET_WIDTH/2 < tank_pos(0) + TANK_WIDTH/2) then
				right_collision = '1';
			end if;

			if ((top_collision or bottom_collision) and (left_collision or right_collision)) then
				collision_flag = '1';
			end if;
			
			return collision_flag;

	end function collision_detection;

end package body tank_functions;
