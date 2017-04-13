library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library modelsim_lib;
use modelsim_lib.util.all;

library lib_VHDL;
use lib_VHDL.Button_event_detect;

entity test_Button_event is

end test_Button_event;



architecture test of test_Button_event is
  component Button_event_detect
    port(
      Clk : in std_logic;
      reset : in std_logic;
      Button_in  : in  std_logic;
      Button_out : out std_logic
      );
  end component;
  signal Sig_Button     : std_logic;
  signal Sig_button_out : std_logic;
  signal Sig_reset : std_logic;
  signal Sig_Clk : std_logic := '0';
  
begin

  test : Button_event_detect
    port map(
      Clk => Sig_Clk,
reset => Sig_reset,
      Button_in  => Sig_Button,
      Button_out => Sig_button_out
      );
  
Sig_Clk <= not Sig_Clk after 5 ns;
  process
  begin

    Sig_Button <= '0', '1' after 20 ns, '0' after 40 ns;
    Sig_reset <= '1', '0' after 10 ns;

    wait for 100 ns;
    assert false report " FIN DE LA SIMULATION" severity failure;
  end process;
end architecture;
