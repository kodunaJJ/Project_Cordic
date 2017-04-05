library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
library lib_VHDL;
use lib_VHDL.Comparator_G;

entity test_Comparator_G is

end test_Comparator_G;

architecture test of test_Comparator_G is
  component Comparator_G
    generic (
      N : positive);

    port (A, B : in  std_logic_vector(N-1 downto 0);
          S    : out std_logic
          );
  end component;

  signal Sig_A : signed (18 downto 0);
  signal Sig_B : signed (18 downto 0);
  signal Sig_S : std_logic;

  signal Sig_As : std_logic_vector(18 downto 0);
  signal Sig_Bs : std_logic_vector(18 downto 0);

  constant delay_400 : time := 400 ns;
  constant delay_10  : time := 10 ns;
  constant delay_5   : time := 5 ns;
  constant delay_2   : time := 2 ns;
  constant delay_1   : time := 1 ns;

begin
  Comparator : Comparator_G
    generic map (
      N => 19)
    port map (
      A => Sig_As,
      B => Sig_Bs,
      S => Sig_S
      );
  Sig_As <= std_logic_vector(Sig_A);
  Sig_Bs <= std_logic_vector(Sig_B);

  process
  begin
    Sig_A <= "0001000000000000000";
    Sig_B <= "0000110010010000110";     -- pi/4
    wait for delay_5;

    Sig_A <= "0000110010010000110";
    Sig_B <= "0001000000000000000";     --inversion compare precedent
    wait for delay_5;

    Sig_A <= "0010010110110010110";     -- 3pi/4
    Sig_B <= "0011111011010100110";     -- 7pi/4
    wait for delay_5;

    Sig_B <= "0010010110110010110";     -- 3pi/4
    Sig_A <= "0011111011010100110";     -- 7pi/4
    wait for delay_5;


    wait for delay_400;
    assert false report " FIN DE LA SIMULATION" severity failure;
  end process;
end test;
