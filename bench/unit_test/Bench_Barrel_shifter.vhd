library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
library lib_VHDL;
use lib_VHDL.Barrel_shifter;

entity test_Barrel_shifer is
end test_Barrel_shifer;

architecture test of test_Barrel_shifer is
  component Barrel_shifter is
    port (
      Shifter_in  : in  std_logic_vector(15 downto 0);
      Shift_count : in  std_logic_vector(3 downto 0);
      Shifter_out : out std_logic_vector(15 downto 0));
  end component;

  signal Sig_Shifter_in  : signed(15 downto 0);
  signal Sig_Shifter_out : signed(15 downto 0);
  signal Sig_Shift_count : unsigned(3 downto 0);

  signal Sig_Shifter_ins  : std_logic_vector(15 downto 0);
  signal Sig_Shifter_outs : std_logic_vector(15 downto 0);
  signal Sig_Shift_counts : std_logic_vector(3 downto 0);

  constant delay_400 : time := 400 ns;
  constant delay_10  : time := 10 ns;
  constant delay_5   : time := 5 ns;
  constant delay_2   : time := 2 ns;
  constant delay_1   : time := 1 ns;

begin
  Barr_Shigter : Barrel_shifter
    port map (
      Shifter_in  => Sig_Shifter_ins,
      Shift_count => Sig_Shift_counts,
      Shifter_out => Sig_Shifter_outs
      );
  Sig_Shifter_ins  <= std_logic_vector(Sig_Shifter_in);
  Sig_Shift_counts <= std_logic_vector(Sig_Shift_count);
  Sig_Shifter_out  <= signed(Sig_Shifter_outs);

  process
  begin
    Sig_Shifter_in  <= "1111111111111111";
    Sig_Shift_count <= to_unsigned(0, 4);
    wait for delay_5;
    assert Sig_Shifter_out = "1111111111111111" report "Shifter_count egal 0 et Buff_Out ne change rien" severity note;

    Sig_Shifter_in  <= "1111111111111111";
    Sig_Shift_count <= to_unsigned(1, 4);
    wait for delay_5;
    assert Sig_Shifter_out = "0111111111111111" report "Shifter_count egal 1" severity note;

    Sig_Shifter_in  <= "1111111111111111";
    Sig_Shift_count <= to_unsigned(2, 4);
    wait for delay_5;
    assert Sig_Shifter_out = "0011111111111111" report "Shifter_count egal 2" severity note;

    Sig_Shifter_in  <= "1111111111111111";
    Sig_Shift_count <= to_unsigned(3, 4);
    wait for delay_5;
    assert Sig_Shifter_out = "0001111111111111" report "Shifter_count egal 3" severity note;

    Sig_Shifter_in  <= "1111111111111111";
    Sig_Shift_count <= to_unsigned(4, 4);
    wait for delay_5;
    assert Sig_Shifter_out = "0000111111111111" report "Shifter_count egal 4" severity note;

    Sig_Shifter_in  <= "1111111111111111";
    Sig_Shift_count <= to_unsigned(5, 4);
    wait for delay_5;
    assert Sig_Shifter_out = "0000011111111111" report "Shifter_count egal 5" severity note;
    Sig_Shifter_in  <= "1111111111111111";
    Sig_Shift_count <= to_unsigned(15, 4);
    wait for delay_5;
    assert Sig_Shifter_out = "0000000000000001" report "Shifter_count egal 15" severity note;
    
    Sig_Shifter_in  <= "1111111111111111";
    Sig_Shift_count <= to_unsigned(16, 4);
    wait for delay_5;
    assert Sig_Shifter_out = "0000000000000000" report "Shifter_count egal 16" severity note;
    wait for delay_5;
    assert false report " FIN DE LA SIMULATION" severity failure;
  end process;
end test;

