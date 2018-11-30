library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package tank_functions is

function slv_to_uint(input : in std_logic_vector)
	return integer;

function int_to_slv(input, size : in integer)
	return std_logic_vector;

function collision_detection(tank_height, tank_width, tank_pos_x, tank_pos_y : in integer;
															bullet_height, bullet_width, bullet_pos_x, bullet_pos_y : in integer)
	return std_logic;

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



	function collision_detection(tank_height, tank_width, tank_pos_x, tank_pos_y : in integer;
																bullet_height, bullet_width, bullet_pos_x, bullet_pos_y : in integer)
		return std_logic is

		variable collision_flag : std_logic := 0;
		variable top_collision : std_logic := 0;
		variable bottom_collision : std_logic := 0;
		variable left_collision : std_logic := 0;
		variable right_collision : std_logic := 0;

		begin
			if (bullet_pos_y + bullet_height/2 > tank_pos_y - tank_height/2) then
				top_collision = '1';
			end if;
			if (bullet_pos_y - bullet_height/2 < tank_pos_y + tank_height/2) then
				bottom_collision = '1';
			end if;
			if (bullet_pos_x + bullet_width/2 > tank_pos_x - tank_width/2) then
				left_collision = '1';
			end if;
			if (bullet_pos_x - bullet_width/2 < tank_pos_x + tank_width/2) then
				right_collision = '1';
			end if;

			if ((top_collision or bottom_collision) and (left_collision or right_collision)) then
				collision_flag = '1';
			end if;

	end function collision_detection;

end package body tank_functions;
