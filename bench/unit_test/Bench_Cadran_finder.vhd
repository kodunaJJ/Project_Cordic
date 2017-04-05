library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
library lib_VHDL;
use lib_VHDL.Cadran_finder;

entity test_Cadran_finder is
end test_Cadran_finder;

architecture test of test_Cadran_finder is
  component Cadran_finder
    generic (
      N : positive);
    port (
      Z_in_mod   : in  std_logic_vector(N-1 downto 0);
      Data_sel   : out std_logic_vector(3 downto 0);
      XY_out_cmd : out std_logic_vector (3 downto 0));
  end component;

  signal Sig_Z_in_mods   : std_logic_vector(18 downto 0);
  signal Sig_Z_in_mod    : signed (18 downto 0);
  signal Sig_Data_sels   : std_logic_vector(3 downto 0);
  signal Sig_XY_out_cmds : std_logic_vector(3 downto 0);
  signal Sig_XY_out_cmd  : unsigned(3 downto 0);
  signal Sig_Data_sel    : unsigned (3 downto 0);


  constant delay_400 : time := 400 ns;
  constant delay_10  : time := 10 ns;
  constant delay_5   : time := 5 ns;
  constant delay_2   : time := 2 ns;
  constant delay_1   : time := 1 ns;

begin
  finder : Cadran_finder
    generic map (
      N => 19)
    port map (
      Z_in_mod   => Sig_Z_in_mods,
      Data_sel   => Sig_Data_sels,
      XY_out_cmd => Sig_XY_out_cmds);

  Sig_Z_in_mods <= std_logic_vector(Sig_Z_in_mod);
  Sig_Data_sels <= std_logic_vector(Sig_Data_sel);
  Sig_XY_out_cmd <= unsigned(Sig_XY_out_cmds);
  process
  begin
    Sig_Z_in_mod <= "0000110010010000110";  -- pi/4
    wait for delay_10;

    Sig_Z_in_mod <= "0010010110110010110";  -- 3pi/4
    wait for delay_10;

    Sig_Z_in_mod <= "0011111011010100110";  --5pi/4
    wait for delay_10;

    Sig_Z_in_mod <= "0101011111110110110";  -- 7pi/4
    wait for delay_10;
  end process;

  process
  begin
    wait for delay_400;
    assert false report " FIN DE LA SIMULATION" severity failure;
  end process;
-- process for signal Reset
  --process
  --begin
  --  Sig_Reset <= '1';
  --  wait for delay_2;
  --  Sig_Reset <= '0';
  --  wait for delay_10;
  --  Sig_Reset <= '1';
  --  wait for delay_10;
  --  Sig_Reset <= '0';
  --  wait;
  --end process;

  -- process for signal Clk
  --process
  --begin
  --  Sig_Clk <= '0';
  --  wait for delay_10;
  --  Sig_Clk <= '1';
  --  wait for delay_10;

  --end process;

end test;
