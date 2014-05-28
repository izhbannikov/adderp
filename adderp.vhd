----------------------------------------------------------------------------------
-- VHDL implementation of 32-bit pipelined adder.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity adderp is
	generic (width  : integer := 31; -- Total bit width
				width1 : integer := 15; -- Bit width of LSBs
				width2 : integer := 16); -- Bit width of MSBs
	port (x,y : in std_logic_vector(width-1 downto 0); -- Inputs
			sum : out std_logic_vector(width-1 downto 0); -- Result
			LSBs_Carry : out std_logic; -- Carry-out
			clk : in std_logic);
end adderp;

architecture Behavioral of adderp is

	signal l1, l2, s1 : std_logic_vector(width1-1 downto 0); -- LSBs of inputs
	signal r1 : std_logic_vector(width1 downto 0); -- LSBs of inputs
	signal l3, l4, r2, s2 : std_logic_vector(width2-1 downto 0); -- MSB of inputs

begin

	process -- Split in MSBs and LSBs and store in registers
	begin
		wait until clk = '1';
		-- Split LSBs from input x, y
		l1 <= x(width1-1 downto 0);
		l2 <= y(width1-1 downto 0);
		-- Split MSBs from input x, y
		l3 <= x(width-1 downto width1);
		l4 <= y(width-1 downto width1);
		------- First stage of the adder --------
		r1 <= ('0' & l1) + ('0' & l2);
		r2 <= l3 + l4;
		----- Second stage of the adder ---------
		s1 <= r1(width1-1 downto 0);
		--- Add result von MSBs (x+y) and carry from LSBs
		s2 <= r1(width1) + r2;
	end process;
	
	LSBs_Carry <= r1(width1); -- Add a test signal
	
	-- Build a single output with width = width1 + width2
	sum <= s2 & s1; -- Connect to output pins

end Behavioral;

