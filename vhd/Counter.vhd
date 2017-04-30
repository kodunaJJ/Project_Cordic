---------------------------COUNTER.vhd--------------------------

-- SIMPLE COUNTER WITH COUNT ENABLE INPUT AND SYNCHRONOUS RESET
-- WHEN AT MAX COUNT VALUE STARTS AGAIN

----------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity Counter is

  generic (
    P : positive;                       -- dimension
    N : natural);                       -- decimal max count value

  port (
    Clk          : in  std_logic;
    Reset        : in  std_logic;
    Count_enable : in  std_logic;
    Count_out    : out std_logic_vector(P-1 downto 0));

end entity Counter;

architecture A of Counter is
  signal count : unsigned(Count_out'range);
begin  -- architecture A

  Count_out <= std_logic_vector(count);

  P_counter : process(Clk)
  begin

    if (Clk = '1' and Clk'event) then
      if Reset = '1' then
        Count <= to_unsigned(0, Count'length);
      elsif Count_enable = '1' then
        if Count = N-1 then
          Count <= to_unsigned(0, Count'length);
        else
          count <= count + 1;
        end if;
      end if;
    end if;
  end process P_counter;

end architecture A;
