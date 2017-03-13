library IEEE;
use IEEE.std_logic_1164.all;

library lib_VHDL;
use lib_VHDL.Clock_divider;

entity test_Clock_divider is
  
end entity test_Clock_divider;

architecture test of test_Clock_divider is

 -- architecture test

  component Clock_divider is
    port (
      Reset   : in  std_logic;
      Clk     : in  std_logic;
      Clk_out : out std_logic);
  end component Clock_divider;

  signal Sig_clk : std_logic := '0';
  signal Sig_clk_out : std_logic;
  signal Sig_Reset : std_logic := '1';

  constant Clk_freq : time := 5 ns;

  begin

    Clk_div: Clock_divider
      port map (
        Reset   => Sig_Reset,
        Clk     => Sig_clk,
        Clk_out => Sig_clk_out);

        Sig_clk <= not Sig_clk after Clk_freq;    

    process
    begin
Sig_Reset <= '0' after 2*Clk_freq;
      wait for 10*Clk_freq;
      assert false report " FIN DE LA SIMULATION" severity failure;

    end process;

end architecture test;
