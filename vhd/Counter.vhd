library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity Counter is

  generic (
    N : positive);

  port (
    Clk       : in  std_logic;
    Reset     : in  std_logic;
    Count_enable : in std_logic;
    Count_in  : in  std_logic_vector(N-1 downto 0);
    Count_out : out std_logic_vector(N-1 downto 0));

end entity Counter;

architecture A of Counter is
 signal count : integer range 0 to N-1;
begin  -- architecture A

  Count_out <= std_logic_vector(to_unsigned(count,N-1));

  P_counter : process(Clk)
  begin

    count <= to_integer(unsigned(Count_in));

    if (Clk = '1' and Clk'event) then
      if Reset = '1' then
        Count <= 0;
      elsif Count_enable = '1' then
        if Count = 15 then
          Count <= 0;
        else
          count <= count + 1;
        end if;
      end if;
    end if;
  end process P_counter;

end architecture A;
