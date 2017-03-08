library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity shift_register is
  port(clk, reset : in std_logic;
	shift_in : in std_logic;
	shift_out : out std_logic);
end shift_register;

architecture A of shift_register is
 signal reg :std_logic_vector(2 downto 0);

begin
  P_shift_register : process (clk)
  begin
    if (clk'event and clk = '1') then
	if reset = '1' then
	 reg <= (others => '0');
	else
		for i in 0 to 1 loop
			shift_out(i) <= shift_out(i);
		end loop
        for i in 2 to 14 loop 
            shift_out(i+1) <= shift_out(i); 
        end loop; 
			shift_out(2) <= '0';
       end if;
    end if;
  end process P_shift_register;
        shift_out <= reg(2);
end A;
