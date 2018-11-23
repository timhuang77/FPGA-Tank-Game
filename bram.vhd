library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.tank_functions.all;

entity bram is
	generic (
		constant RAM_size : integer := 307200
	);
	port (
		q : out std_logic_vector(2 downto 0);	-- 24-bit color
		d : in std_logic_vector(2 downto 0);
		raddr : in std_logic_vector(19 downto 0);	--19-bit address
		waddr : in std_logic_vector(19 downto 0);
		we : in std_logic;
		clk : in std_logic
	);
end entity bram;

architecture rtl of bram is 
	type mem_type is array (0 to RAM_size - 1) of std_logic_vector(19 downto 0);
	
	signal mem : mem_type;
	signal rd_addr : std_logic_vector;
	
begin
	
	q <= mem(slv_to_uint(rd_addr));
	
	process(clk) begin
		if rising_edge(clk) then
			if (we = '1') then
				mem(slv_to_uint(waddr)) <= d;
			end if;
		end if;
		
	end process;
	
end rtl;