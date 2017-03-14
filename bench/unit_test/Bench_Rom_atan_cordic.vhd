library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
library lib_VHDL;
use lib_VHDL.Rom_atan_cordic;

entity test_Rom_atan_cordic is

end test_Rom_atan_cordic;

architecture test of test_Rom_atan_cordic is
  component Rom_atan_cordic
    port(Rom_Address : in  std_logic_vector(3 downto 0);
         Rom_out     : out std_logic_vector(15 downto 0));
  end component Rom_atan_cordic;


  signal Sig_Rom_Address : unsigned (3 downto 0);
  signal Sig_Rom_out     : unsigned (15 downto 0);

  signal Sig_Rom_Address_S : std_logic_vector(3 downto 0);
  signal Sig_Rom_outs      : std_logic_vector (15 downto 0);

  constant delay_400 : time := 400 ns;
  constant delay_10 : time := 10 ns;
  constant delay_5  : time := 5 ns;
  constant delay_2  : time := 2 ns;
  constant delay_1  : time := 1 ns;

begin
  rom : Rom_atan_cordic
    port map (
      Rom_Address => Sig_Rom_Address_S,
      Rom_out     => Sig_Rom_outs);
  Sig_Rom_Address_S <= std_logic_vector(Sig_Rom_Address);
  Sig_Rom_out       <= unsigned(Sig_Rom_outs);

  process
  begin
    Sig_Rom_Address <= to_unsigned(0, 4);
    wait for delay_5;
    assert Sig_Rom_out = "0110010010000111" report "premiere adresse de rom" severity note;

    Sig_Rom_Address <= to_unsigned(1, 4);
    wait for delay_5;
    assert Sig_Rom_out = "0011101101011000" report "deuxieme adresse de rom" severity note;

    Sig_Rom_Address <= to_unsigned(2, 4);
    wait for delay_5;
    assert Sig_Rom_out =  "0001111101011011" report "troisieme adresse de rom" severity note;

    
    Sig_Rom_Address <= to_unsigned(3, 4);
    wait for delay_5;
    assert Sig_Rom_out =  "0000111111101010" report "quartrieme adresse de rom" severity note;

    
    Sig_Rom_Address <= to_unsigned(13, 4);
    wait for delay_5;
    assert Sig_Rom_out =   "0000000000000011" report "quartorzieme adresse de rom" severity note;

    
    Sig_Rom_Address <= to_unsigned(14, 4);
    wait for delay_5;
    assert Sig_Rom_out =  "0000000000000001" report "quinzieme adresse de rom" severity note;

    
    Sig_Rom_Address <= to_unsigned(15, 4);
    wait for delay_5;
    assert Sig_Rom_out =  "0000000000000000" report "seizieme adresse de rom" severity note;

    wait for delay_400;
    assert false report " FIN DE LA SIMULATION" severity failure;

  end process;


end test;
