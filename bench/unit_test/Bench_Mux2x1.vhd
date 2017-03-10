library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
library lib_VHDL;
use lib_VHDL.Mux2x1;

entity test_Mux2x1 is

end test_Mux2x1;

architecture test of test_Mux2x1 is
  component Mux2x1
    port (In1, In2 : in  std_logic_vector(15 downto 0);
          Sel      : in  std_logic;
          Mux_out  : out std_logic_vector (15 downto 0));
  end component;

  signal Sig_In1 : signed (15 downto 0);
  signal Sig_In2 : signed (15 downto 0);
  signal Sig_Sel : std_logic;
  signal Sig_Mux_out : signed (15 downto 0);

  signal Sig_In1s     : std_logic_vector(15 downto 0);
  signal Sig_In2s     : std_logic_vector(15 downto 0);
  signal Sig_Mux_outs : std_logic_vector(15 downto 0);

 constant delay_10             : time := 10 ns;
  constant delay_5              : time := 5 ns;
  constant delay_2              : time := 2 ns;
  constant delay_1              : time := 1 ns;

begin
  Mux : Mux2x1
    port map (
      In1     => Sig_In1s,
      In2     => Sig_In2s,
      Sel     => Sig_Sel,
      Mux_out => Sig_Mux_outs
      );
  Sig_In1s    <= std_logic_vector(Sig_In1);
  Sig_In2s    <= std_logic_vector(Sig_In2);
  Sig_Mux_out <= signed(Sig_Mux_outs);

  process
  begin
    Sig_In1 <= to_signed(10, 16);
    Sig_In2 <= to_signed(20, 16);
    Sig_Sel <= '1';
    wait for delay_5;
    assert Sig_Mux_out = 20 report "Sel egal 1, Mux_out vaut In2 egal 20" severity note;

    Sig_In1 <= to_signed(10, 16);
    Sig_In2 <= to_signed(20, 16);
    Sig_Sel <= '0';
    wait for delay_5;
    assert Sig_Mux_out = 20 report "Sel egal 0, Mux_out vaut In2 egal 10" severity note;

    Sig_In1 <= to_signed(-10, 16);
    Sig_In2 <= to_signed(-20, 16);
    Sig_Sel <= '0';
    wait for delay_5;
    assert Sig_Mux_out = 20 report "Sel egal 0 Mux_out vaut In2 egal -20" severity note;

    Sig_In1 <= to_signed(0, 16);
    Sig_In2 <= to_signed(20, 16);
    Sig_Sel <= '1';
    wait for delay_5;
    assert Sig_Mux_out = 20 report "Sel egal 1, Mux_out vaut In2 egal 0" severity note;

    wait for delay_5;
    assert false report " FIN DE LA SIMULATION" severity failure;
  end process;
end test;
