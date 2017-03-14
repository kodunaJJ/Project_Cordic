library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
library lib_VHDL;
use lib_VHDL.Counter;

entity test_Counter is
end test_Counter;

architecture test of test_Counter is
  component Counter
    generic (
      P  : positive;
      N : natural);
    port (
      Clk          : in  std_logic;
      Reset        : in  std_logic;
      Count_enable : in  std_logic;
      Count_out    : out std_logic_vector(3 downto 0)); --Max = 15, compter 4 bits
  end component;

  signal Sig_Clk          : std_logic;
  signal Sig_Reset        : std_logic;
  signal Sig_Count_enable : std_logic;
  signal Sig_Count_out    : unsigned (3 downto 0);

  signal Sig_Count_outs : std_logic_vector(3 downto 0);

  constant delay_400 : time := 400 ns;
  constant delay_10  : time := 10 ns;
  constant delay_5   : time := 5 ns;
  constant delay_2   : time := 2 ns;
  constant delay_1   : time := 1 ns;

begin
  Count : Counter
    generic map (
      P => 4,
      N => 16)
    port map (
      Clk          => Sig_Clk,
      Reset        => Sig_Reset,
      Count_enable => Sig_Count_enable,
      Count_out    => Sig_Count_outs);

  Sig_Count_out <= unsigned(Sig_Count_outs);

  process
  begin
    Sig_Count_enable <= '1';
    wait for delay_10;
    Sig_Count_enable <= '0';
    wait for delay_10;
    Sig_Count_enable <= '1';
    wait;
  end process;

  process
    begin
    wait for delay_400;
    assert false report " FIN DE LA SIMULATION" severity failure;
  end process;
-- process for signal Reset
  process
  begin
    Sig_Reset <= '1';
    wait for delay_2;
    Sig_Reset <= '0';
    wait for delay_10;
    Sig_Reset <= '1';
    wait for delay_10;
    Sig_Reset <= '0';
    wait;
  end process;

  -- process for signal Clk
  process
  begin
    Sig_Clk <= '0';
    wait for delay_1;
    Sig_Clk <= '1';
    wait for delay_1;

  end process;

end test;
