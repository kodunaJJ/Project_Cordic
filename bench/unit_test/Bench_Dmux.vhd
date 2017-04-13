library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
library lib_VHDL;
use lib_VHDL.Dmux1x3;

entity test_Dmux1x3 is

end test_Dmux1x3;

architecture test of test_Dmux1x3 is

  component Dmux1x3
  generic (
    N : positive
    );
  port(
    Input : in  std_logic_vector(N-1 downto 0);
    Sel   : in  std_logic_vector(1 downto 0);
    Out1  : out std_logic_vector(N-1 downto 0);
    Out2  : out std_logic_vector(N-1 downto 0);
    Out3  : out std_logic_vector(N-1 downto 0)
    );

  end component;

  signal Sig_input : std_logic_vector(7 downto 0);
  signal Sig_sel : std_logic_vector(1 downto 0);
  signal Sig_out1 :  std_logic_vector(7 downto 0);
  signal Sig_out2 :  std_logic_vector(7 downto 0);
  signal Sig_out3 :  std_logic_vector(7 downto 0);

  constant delay_1 : time := 1 ns;


begin

  Dmux1x3_test : Dmux1x3
    generic map (
      N => 8 )
    port map (
    Input => Sig_input,
    Sel   => Sig_sel,
    Out1  => Sig_out1,
    Out2  => Sig_out2,
    Out3  => Sig_out3
    );


  process
  begin

    Sig_input <= "00000011";
    Sig_sel <= "00";
    wait for 10*delay_1;

    Sig_input <= "00001100";
    Sig_sel <= "01";
    wait for 10*delay_1;

    Sig_input <= "00110000";
    Sig_sel <= "10";
    wait for 10*delay_1;

    Sig_input <= "11000000";
    Sig_sel <= "11";
    wait for 10*delay_1;
        assert false report " FIN DE LA SIMULATION" severity failure;

  end process;
end architecture;

