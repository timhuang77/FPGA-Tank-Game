LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ps2 is
	port( 	keyboard_clk, keyboard_data, clock_50MHz ,
			reset : in std_logic;--, read : in std_logic;
			
			--LED's 
			--LED_out : out std_logic_vector(7*8 - 1 downto 0);
			--8 LED's, 6 bits each
			--
			
			scan_code : out std_logic_vector( 7 downto 0 );
			scan_readyo : out std_logic;
			hist3 : out std_logic_vector(7 downto 0);
			hist2 : out std_logic_vector(7 downto 0);
			hist1 : out std_logic_vector(7 downto 0);
			hist0 : out std_logic_vector(7 downto 0)
		);
end entity ps2;


architecture structural of ps2 is

component keyboard IS
	PORT( 	keyboard_clk, keyboard_data, clock_50MHz ,
			reset, read : IN STD_LOGIC;
			scan_code : OUT STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			scan_ready : OUT STD_LOGIC);
end component keyboard;

component oneshot is
port(
	pulse_out : out std_logic;
	trigger_in : in std_logic; 
	clk: in std_logic );
end component oneshot;

component leddcd is
	port(
		 data_in : in std_logic_vector(3 downto 0);
		 segments_out : out std_logic_vector(6 downto 0)
		);
end component leddcd;

signal scan2 : std_logic;
signal scan_code2 : std_logic_vector( 7 downto 0 );
signal history3 : std_logic_vector(7 downto 0);
signal history2 : std_logic_vector(7 downto 0);
signal history1 : std_logic_vector(7 downto 0);
signal history0 : std_logic_vector(7 downto 0);

type hist_array is array (0 to 3) of std_logic_vector(7 downto 0);
signal hists : hist_array;

signal read : std_logic;

begin

u1: keyboard port map(	
				keyboard_clk => keyboard_clk,
				keyboard_data => keyboard_data,
				clock_50MHz => clock_50MHz,
				reset => reset,
				read => read,
				scan_code => scan_code2,
				scan_ready => scan2
			);

pulser: oneshot port map(
   pulse_out => read,
   trigger_in => scan2,
   clk => clock_50MHz
			);

scan_readyo <= scan2;
scan_code <= scan_code2;

hist0<=history0;
hist1<=history1;
hist2<=history2;
hist3<=history3;

a1 : process(scan2)
begin
	if(rising_edge(scan2)) then
	history3 <= history2;
	history2 <= history1;
	history1 <= history0;
	history0 <= scan_code2;
	end if;
end process a1;

hists(0) <= history0;
hists(1) <= history1;
hists(2) <= history2;
hists(3) <= history3;
--generate_LED_per_hist : for i in 0 to 3 generate
--	map_LED_1 : leddcd port map(
--		hists(i)(3 downto 0),
--		LED_out(i*14 + 6 downto i*14 + 0)
--	);
--	map_LED_2 : leddcd port map(
--		hists(i)(7 downto 4),
--		LED_out(i*14 + 13 downto i*14 + 7)
--	);
--end generate generate_LED_per_hist;


end architecture structural;