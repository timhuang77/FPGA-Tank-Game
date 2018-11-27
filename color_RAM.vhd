library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity color_RAM is
	generic(
		color_depth_bits, col_size, row_size : integer
	);
	port(
		clk, we: in std_logic;
		row_in, col_in : in integer;
		row_out, col_out : in integer;
		color_in : in std_logic_vector(color_depth_bits - 1 downto 0);
		color_out : out std_logic_vector(color_depth_bits - 1 downto 0)
	);
end entity color_RAM;

architecture two_d_array of color_RAM is
	type col is array (0 to col_size - 1) of std_logic_vector(color_depth_bits - 1 downto 0);
	type row is array (0 to row_size - 1) of col;
	
	signal color_depth : row;
begin
	color_out <= color_depth(row_out)(col_out);
	process(clk) begin
		if (rising_edge(clk)) then
			if (we = '1') then
				color_depth(row_in)(col_in) <= color_in;
			end if;
		end if;
	end process;
	

end architecture two_d_array;