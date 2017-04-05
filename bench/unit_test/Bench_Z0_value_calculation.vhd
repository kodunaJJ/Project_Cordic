library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
library lib_VHDL;
use lib_VHDL.Z0_value_calculation;

entity test_Z0_value_calculation is
end test_Z0_value_calculation;

architecture test of test_Z0_value_calculation is
  component Z0_value_calculation
    generic (
      N : positive);
    port (Clk      : in  std_logic;
          Reset    : in  std_logic;
          Z_in_mod : in  std_logic_vector(N-1 downto 0);
          Data_sel : in  std_logic_vector(3 downto 0);
          Buff_OE  : in  std_logic;
          Z_conv   : out std_logic_vector (N-4 downto 0));
  end component;

  signal Sig_Clk      : std_logic;
  signal Sig_Reset    : std_logic;
  signal Sig_Z_in_mod : std_logic_vector(18 downto 0);
  signal Sig_Buff_OE  : std_logic;
  signal Sig_Data_sel : std_logic_vector(3 downto 0);
  signal Sig_Z_conv       : std_logic_vector(15 downto 0);


  constant delay_400 : time := 400 ns;
  constant delay_60  : time := 60 ns;
  constant delay_10  : time := 10 ns;
  constant delay_5   : time := 5 ns;
  constant delay_2   : time := 2 ns;
  constant delay_1   : time := 1 ns;

begin
  Calculation : Z0_value_calculation
    generic map (
      N => 19)
    port map (
      Clk      => Sig_Clk,
      Reset    => Sig_Reset,
      Z_in_mod => Sig_Z_in_mod,
      Data_sel => Sig_Data_sel,
      Buff_OE  => Sig_Buff_OE,
      Z_conv   => Sig_Z_conv);


  process
  begin
    Sig_Data_sel <= "0000";                --pi/2
    Sig_Buff_OE <= '1';
    Sig_Z_in_mod <= "0000000000000000000"  ;
    wait for delay_60;
    Sig_Data_sel <= "0001";
    Sig_Buff_OE  <= '1';
    Sig_Z_in_mod <= "0001100100100001110"; --pi/2

    wait for delay_60;
    Sig_Data_sel <= "0011";
    Sig_Buff_OE  <= '1';
    Sig_Z_in_mod <= "0011001001000011110"; --pi


    wait for delay_60;
    Sig_Data_sel <= "0111";
    Sig_Buff_OE  <= '1';
    Sig_Z_in_mod <= "0100101101100101110"; --3pi/2

    wait for delay_60;
    Sig_Data_sel <= "1111";
    Sig_Buff_OE  <= '1';
    Sig_Z_in_mod <= "0110010010000111110"; --2pi

     wait for delay_60;
    Sig_Data_sel <= "1111";
    Sig_Buff_OE  <= '0';
    Sig_Z_in_mod <= "0100101101100101110";

     wait for delay_60;
    Sig_Data_sel <= "0111";
    Sig_Buff_OE  <= '0';
    Sig_Z_in_mod <= "0100101101100101110";

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
    wait for delay_10;
    Sig_Clk <= '1';
    wait for delay_10;

  end process;

end test;
