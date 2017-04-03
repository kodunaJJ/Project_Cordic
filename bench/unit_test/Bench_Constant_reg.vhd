library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
library lib_VHDL;
use lib_VHDL.Buff;

entity test_Constant_reg is
end test_Constant_reg;

architecture test of test_Constant_reg is
  component Constant_reg
    generic (
      N : positive);
    port (
      Constant_in  : in  std_logic_vector(N-1 downto 0);
      Clk      : in  std_logic;
      Reset    : in  std_logic;
      Reg_Out : out std_logic_vector(N-1 downto 0));
  end component;

  signal Sig_Buff_in  : signed (15 downto 0);
  signal Sig_Buff_OE  : std_logic;
  signal Sig_Clk      : std_logic;
  signal Sig_Reset    : std_logic;
  signal Sig_Buff_Out : signed (15 downto 0);

  signal Sig_Buff_inS  : std_logic_vector(15 downto 0);
  signal Sig_Buff_OutS : std_logic_vector(15 downto 0);
  
  constant delay_400 : time := 400 ns;
  constant delay_10 : time := 10 ns;
  constant delay_5  : time := 5 ns;
  constant delay_2  : time := 2 ns;
  constant delay_1  : time := 1 ns;

begin
  Reg1 : Constant_reg
    generic map (
      N => 16)
    port map(
      Constant_in => Sig_Buff_inS,
      Clk      => Sig_Clk,
      Reset    => Sig_Reset,
     Reg_Out => Sig_Buff_OutS
      );
  Sig_Buff_inS <= std_logic_vector(Sig_Buff_in);
  Sig_Buff_Out <= signed(Sig_Buff_Outs);
  process
  begin

    Sig_Buff_in <= to_signed(5, 16);
    wait for delay_5;
    assert Sig_Buff_Out = 5 report "Buff test Sig_Buff_Out egal 5" severity note;

    Sig_Buff_in <= to_signed(15, 16);
    wait for delay_5;
    assert Sig_Buff_Out = 15 report "Buff test Sig_Buff_Out egal 15" severity note;

    Sig_Buff_in <= to_signed(-15, 16);
    Sig_Buff_OE <= '1';
    wait for delay_5;
    assert Sig_Buff_Out = -15 report "Buff test Sig_Buff_Out egal -15" severity note;

    Sig_Buff_in <= to_signed(20, 16); -- Buff_Out reste valeur precedente => -15
    Sig_Buff_OE <= '0';
    wait for delay_5;
    assert Sig_Buff_Out = -15 report "Buff test Sig_Buff_Out egal -15" severity note;
    
    wait for delay_400;
    assert false report " FIN DE LA SIMULATION" severity failure;

  end process;

  -- process for signal Reset 
  process
  begin
    Sig_Reset <= '1';
    wait for delay_2;
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
