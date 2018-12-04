library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.game_components.all;
use work.tank_functions.all;

entity bullet is
	generic(
		default_pos_x : integer;
		default_pos_y : integer
	);
	port(
		clk, rst, we : in std_logic;
		pos_in : in position;
		pos_out : out position;
		bullet_fired_in : in std_logic;
		bullet_fired_out : out std_logic
	);

--entity description:
  --Generic parameters: object width, object height, x position, y position
  --Function: Stores the x and y position
end entity bullet;

architecture behavioral of bullet is

  signal bullet_fired_signal : std_logic;
  signal curr_pos : position;

begin
  process(clk, rst)

  begin

    if (rst = '1') then
    curr_pos(0) <= default_pos_x;
	  curr_pos(1) <= default_pos_y;
	  bullet_fired_signal <= '0';
    elsif (rising_edge(clk)) then

      if (we = '1') then
        if (bullet_fired_in = '1') then
          curr_pos <= pos_in;
        end if;
		  bullet_fired_signal <= bullet_fired_in;
			-- bullet_fired_signal <= '0';
      else
        pos_out <= curr_pos;
        bullet_fired_out <= bullet_fired_signal;
      end if;
    end if;

  end process;

end architecture behavioral;
