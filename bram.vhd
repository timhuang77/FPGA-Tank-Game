library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.tank_functions.all;

entity bram is
	generic (
		constant RAM_size : integer := 307200
	);
	port (
		q : out std_logic_vector(7 downto 0);	-- 24-bit color
		d : in std_logic_vector(7 downto 0);
		-- q : out std_logic;
		-- d : in std_logic;
		raddr : in std_logic_vector(18 downto 0);	--19-bit address
		waddr : in std_logic_vector(18 downto 0);
		we : in std_logic;
		clk : in std_logic
	);
end entity bram;

architecture rtl of bram is 
	--type mem_type is array (0 to RAM_size - 1) of std_logic;
	type mem_type is array (0 to RAM_size - 1) of std_logic_vector(7 downto 0);
	
	signal mem : mem_type;
	signal rd_addr : std_logic_vector(18 downto 0);

	--signal color_depth : row;
begin
	q <= mem(to_integer(unsigned(rd_addr)));
	
	process(clk) begin
		if rising_edge(clk) then
			if (we = '1') then
				mem(to_integer(unsigned(waddr))) <= d;
			end if;
			rd_addr <= raddr;
		end if;
		
	end process;
	
end rtl;