library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.game_components.all;
use work.tank_functions.all;

entity bullet is
  generic(
		obj_width : integer;
		obj_height : integer;
		pos_x_init : integer;
		pos_y_init : integer
	);
	port(
		clk, rst, we : in std_logic;
		pos_x_in, pos_y_in : in integer;
		pos_x_out, pos_y_out : in integer;
    bullet_fired : inout std_logic
	);

--entity description:
  --Generic parameters: object width, object height, x position, y position
  --Function: Stores the x and y position
end entity bullet;

architecture behavioral of bullet is

  signal bullet_fired_signal, bullet_on_screen_signal : std_logic;
  signal pos_x, pos_y : integer;

begin
  process(clk, rst)

  begin

    if (rst = '1') then
      pos_x_out <= pos_x_init;
      pos_y_out <= pos_y_init;
    elsif (rising_edge(clk)) then

      if (we = '1') then
        if (bullet_fired = '1') then
          pos_x <= pos_x_in;
          pos_y <= pos_y_in;
          bullet_fired_signal <= bullet_fired;
        end if;
      else
        pos_x_out <= pos_x;
				pos_y_out <= pos_y;
        bullet_fired <= bullet_fired_signal;
      end if;
    end if;

  end process;

end architecture behavioral;
