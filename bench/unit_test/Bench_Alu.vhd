library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
library lib_VHDL;
use lib_VHDL.Alu;


entity test_Alu is

end test_Alu;

architecture test of test_Alu is
  component Alu
    generic (
      N : positive);
    port (
      A, B : in  std_logic_vector(15 downto 0);
      Cmd  : in  std_logic;
      S    : out std_logic_vector(15 downto 0));
  end component Alu;
----------------------------------------------------------------------------------
-----signal
  signal Sig_A, Sig_B, Sig_S    : signed (15 downto 0);
  signal Sig_Cmd                : std_logic;
  signal Sig_As, Sig_Bs, Sig_Ss : std_logic_vector(15 downto 0);

  
  constant delay_400 : time := 400 ns;
  constant delay_10 : time := 10 ns;
  constant delay_5  : time := 5 ns;
  constant delay_2  : time := 2 ns;
  constant delay_1  : time := 1 ns;
begin
  Alu1 : Alu
    generic map (
      N => 16)
    port map (
      A   => Sig_As,
      B   => Sig_Bs,
      Cmd => Sig_Cmd,
      S   => Sig_Ss);
  Sig_As <= std_logic_vector(Sig_A);
  Sig_Bs <= std_logic_vector(Sig_B);
  Sig_S  <= signed(Sig_Ss);
  process
  begin
    Sig_A   <= to_signed(10, 16);
    Sig_B   <= to_signed(15, 16);
    Sig_Cmd <= '0';                     -- add
    wait for delay_5;
    assert sig_S = 25 report "ALU test addition sig_out positive" severity note;

    Sig_A   <= to_signed(10, 16);
    Sig_B   <= to_signed(15, 16);
    Sig_Cmd <= '1';                     -- minus
    wait for delay_5;
    assert sig_S = -5 report "ALU test soustraction sig_out negative" severity note;

    Sig_A   <= to_signed(30, 16);
    Sig_B   <= to_signed(12, 16);
    Sig_Cmd <= '1';                     -- minus
    wait for delay_5;
    assert sig_S = 18 report "ALU test soustraction sig_out positive " severity note;

    Sig_A   <= to_signed(10, 16);
    Sig_B   <= to_signed(-15, 16);
    Sig_Cmd <= '0';                     -- add
    wait for delay_5;
    assert sig_S = -5 report "ALU test addition sig_out negative" severity note;

    Sig_A   <= to_signed(-12, 16);
    Sig_B   <= to_signed(-18, 16);
    Sig_Cmd <= '0';                     -- add
    wait for delay_5;
    assert sig_S = -30 report "ALU test addition sig_out negative" severity note;

    Sig_A   <= to_signed(13, 16);
    Sig_B   <= to_signed(-23, 16);
    Sig_Cmd <= '1';                     -- minus
    wait for delay_5;
    assert sig_S = 36 report "ALU test soustraction sig_out positive" severity note;

    wait for delay_400;
    assert false report " FIN DE LA SIMULATION" severity failure;
  end process;
end test;
