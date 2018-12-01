library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.game_components.all;
use work.tank_functions.all;

entity bullet is
  generic(
		pos_x_init : integer;
		pos_y_init : integer
	);
	port(
		clk, rst, we : in std_logic;
		pos_in : in position;
		pos_out : out position;
		bullet_fired : inout std_logic
	);

--entity description:
  --Generic parameters: object width, object height, x position, y position
  --Function: Stores the x and y position
end entity bullet;

architecture behavioral of bullet is

  signal bullet_fired_signal, bullet_on_screen_signal : std_logic;
  signal curr_pos : position;

begin
  process(clk, rst)

  begin

    if (rst = '1') then
      pos_out(0) <= pos_x_init;
      pos_out(1) <= pos_y_init;
    elsif (rising_edge(clk)) then

      if (we = '1') then
        if (bullet_fired = '1') then
          curr_pos <= pos_in;
          bullet_fired_signal <= bullet_fired;
        end if;
      else
        pos_out <= curr_pos;
        bullet_fired <= bullet_fired_signal;
      end if;
    end if;

  end process;

end architecture behavioral;
