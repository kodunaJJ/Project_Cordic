-------------------------------Constant_reg.vhd-----------------------------------------

library ieee;
use ieee.std_logic_1164.all;


entity Constant_reg is
  generic (
    N : positive);
  port (
    Constant_in  : in  std_logic_vector(N-1 downto 0);
    Clk      : in  std_logic;
    Reset    : in  std_logic;
    Reg_out : out std_logic_vector(N-1 downto 0));

end entity Constant_reg;

architecture A of Constant_reg is

begin  -- architecture A

  P_reg : process (Clk)
  begin  -- process P_buff
    if(Clk = '1' and Clk'event) then
      if Reset = '1' then
        Reg_out <= (others => '0');
      else
        Reg_out <= Constant_in;
      end if;
    end if;
  end process P_reg;
end architecture A;
