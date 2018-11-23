library IEEE;
use IEEE.std_logic_1164.all;

package game_components is 

	component bram is
		generic (
			constant RAM_size : integer := 307200
		);
		port (
			q : out std_logic_vector(23 downto 0);	-- 24-bit color
			d : in std_logic_vector(23 downto 0);
			raddr : in std_logic_vector(19 downto 0);	--19-bit address
			waddr : in std_logic_vector(19 downto 0);
			we : in std_logic;
			clk : in std_logic
		);
	end component bram;
	
end package game_components;

package body game_components is
end package body game_components;