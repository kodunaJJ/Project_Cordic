library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Comparator_G is
  generic (
    N : positive);

  port (A, B : in  std_logic_vector(N-1 downto 0);
        S    : out std_logic
        );
end Comparator_G;

architecture A of Comparator_G is

  signal A_u : unsigned(N-1 downto 0);
  signal B_u : unsigned(N-1 downto 0);

begin
  A_u <= unsigned(A);
  B_u <= unsigned(B);
  
  --if (A_u >= B_u) then
  --  S <= '1';
  --else
  --  S <= '0';
  --end if;
    S <= '1' when (A_u > B_u) else '0';
  
end architecture;
