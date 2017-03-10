library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
library lib_VHDL;
use lib_VHDL.Alu;


entity test_Alu is

end test_Alu;

architecture test of test_Alu is
  component Alu

    port (
      A, B : in  std_logic_vector(15 downto 0);  --vrai ou pas
      Cmd  : in  std_logic;
      S    : out std_logic_vector(15 downto 0));
  end component Alu;
----------------------------------------------------------------------------------
-----signal
  signal Sig_A, Sig_B, Sig_S    : signed (15 downto 0);
  signal Sig_Cmd                : std_logic;
  signal Sig_As, Sig_Bs, Sig_Ss : std_logic_vector(15 downto 0);
  signal Sig_Cmds               : std_logic;
  constant delay_10             : time := 10 ns;
  constant delay_5              : time := 5 ns;
  constant delay_2              : time := 2 ns;
  constant delay_1              : time := 1 ns;
begin
  Alu1 : Alu

  port map (
    A   => Sig_As,
    B   => Sig_Bs,
    Cmd => Sig_Cmds,
    S   => Sig_Ss);
  Sig_As   <= std_logic_vector(Sig_A);
  Sig_Bs   <= std_logic_vector(Sig_B);
  Sig_Cmds <= Sig_Cmd;
  Sig_S    <= signed(Sig_Ss);
  process
  begin
    Sig_A   <= to_signed(10, 16);
    Sig_B   <= to_signed(15, 16);
    Sig_Cmd <= '0';                              -- add

    wait for delay_5;
    assert sig_S = 25 report "ALU test sig_out add" severity note;
  end process;
end test;
