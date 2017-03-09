library IEEE;
use IEEE.std_logic_1164.all;

entity Clock_divider is

  port (
    Reset   : in  std_logic;
    Clk     : in  std_logic;
    Clk_out : out std_logic);

end entity Clock_divider;

architecture A of Clock_divider is

  signal clk_int : std_logic;

begin  -- architecture A

  Clk_out <= clk_int;

  P_clock_div : process(Clk)
  begin
    if (Clk = '1' and Clk'event) then
      if Reset = '1' then clk_int <= '0';
      else
        clk_int <= not clk_int;
      end if;
    end if;
  end process;

end architecture A;
