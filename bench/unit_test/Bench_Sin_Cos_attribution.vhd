library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
library lib_VHDL;
use lib_VHDL.Sin_Cos_attribution;

entity test_Sin_Cos_attribution is

end entity test_Sin_Cos_attribution;

architecture test of test_Sin_Cos_attribution is

  component Sin_Cos_attribution is
    generic (
      N : positive);
    port (Clk         : in  std_logic;
          Reset       : in  std_logic;
          X           : in  std_logic_vector(N-1 downto 0);
          Y           : in  std_logic_vector(N-1 downto 0);
          cmd         : in  std_logic_vector(3 downto 0);
          Out_reg_ena : in  std_logic;
          X_out       : out std_logic_vector(N-1 downto 0);
          Y_out       : out std_logic_vector(N-1 downto 0)
          );
  end component Sin_Cos_attribution;
  signal Sig_Clk         : std_logic;
  signal Sig_Reset       : std_logic;
  signal Sig_X           : std_logic_vector(15 downto 0);
  signal Sig_Y           : std_logic_vector(15 downto 0);
  signal Sig_cmd         : std_logic_vector(3 downto 0);
  signal Sig_Out_reg_ena : std_logic;
  signal Sig_X_out       : std_logic_vector(15 downto 0);
  signal Sig_Y_out       : std_logic_vector(15 downto 0);


  constant delay_400 : time := 400 ns;
  constant delay_10  : time := 10 ns;
  constant delay_5   : time := 5 ns;
  constant delay_2   : time := 2 ns;
  constant delay_1   : time := 1 ns;

begin
  attribution : Sin_Cos_attribution
    generic map (
      N => 16)
    port map (
      Clk         => Sig_Clk,
      Reset       => Sig_Reset,
      X           => Sig_X,
      Y           => Sig_Y,
      cmd         => Sig_cmd,
      Out_reg_ena => Sig_Out_reg_ena,
      X_out       => Sig_X_out,
      Y_out       => Sig_Y_out);


  process
  begin
    Sig_X           <= "0011111100001110";
    Sig_Y           <= "0000101100011111";
    Sig_Out_reg_ena <= '1';
    Sig_cmd         <= "0000";

    wait for 3*delay_10;

    Sig_X           <= "0011111100001110";
    Sig_Y           <= "0000101100011111";
    Sig_Out_reg_ena <= '1';
    Sig_cmd         <= "0001";

    wait for 3*delay_10;


    Sig_X           <= "0011111100001110";
    Sig_Y           <= "0000101100011111";
    Sig_Out_reg_ena <= '1';
    Sig_cmd         <= "0011";

    wait for 3*delay_10;


    Sig_X           <= "0011111100001110";
    Sig_Y           <= "0000101100011111";
    Sig_Out_reg_ena <= '1';
    Sig_cmd         <= "0111";

    wait for 3*delay_10;

    
    Sig_X           <= "0011111100001110";
    Sig_Y           <= "0000101100011111";
    Sig_Out_reg_ena <= '1';
    Sig_cmd         <= "1111";

    wait for 3*delay_10;
        


  end process;

  process
  begin
    wait for delay_400;
    assert false report " FIN DE LA SIMULATION" severity failure;
  end process;
-- process for signal Reset
  process
  begin
    Sig_Reset <= '0';
    wait for delay_10;
    Sig_Reset <= '1';
    wait for 3*delay_10;
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
