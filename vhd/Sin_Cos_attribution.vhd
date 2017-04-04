-----------------------------Sin_Cos_attribution.vhd-----------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity Sin_Cos_attribution is
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
end Sin_Cos_attribution;

architecture A of Sin_Cos_attribution is

  component Mux2x1
    generic (
      N : positive);
    port (In1, In2 : in  std_logic_vector(N-1 downto 0);
          Sel      : in  std_logic;
          Mux_out  : out std_logic_vector (N-1 downto 0));
  end component;

  component Buff
    generic (
      N : positive);
    port(Buff_in  : in  std_logic_vector(N-1 downto 0);
         Buff_OE  : in  std_logic;
         Clk      : in  std_logic;
         Reset    : in  std_logic;
         Buff_Out : out std_logic_vector(N-1 downto 0));
  end component;

  constant ONE:   UNSIGNED(X'RANGE) := to_unsigned(0, X'length-1)&'1';

  signal Switch_cmd     : std_logic;
  signal X_sign_cmd    : std_logic;
  signal Y_sign_cmd    : std_logic;
  signal X_complement   : std_logic_vector(N-1 downto 0);
  signal Y_complement   : std_logic_vector(N-1 downto 0);
  signal Mux_comp_X_out : std_logic_vector(N-1 downto 0);
  signal Mux_comp_Y_out : std_logic_vector(N-1 downto 0);
  signal Mux_X_out      : std_logic_vector(N-1 downto 0);
  signal Mux_Y_out      : std_logic_vector(N-1 downto 0);
  


begin

  Mux_sign_X : Mux2x1
    generic map (
      N => 16)
    port map (
      In1     => X_complement,
      In2     => X,
      Sel     => X_sign_cmd,
      Mux_out => Mux_comp_X_out
      );

  Mux_sign_Y : Mux2x1
    generic map (
      N => 16)
    port map (
      In1     => Y_complement,
      In2     => Y,
      Sel     => Y_sign_cmd,
      Mux_out => Mux_comp_X_out
      );

  Mux_switch_X : Mux2x1
    generic map (
      N => 16)
    port map (
      In1     => Mux_comp_X_out,
      In2     => Mux_comp_Y_out,
      Sel     => Switch_cmd,
      Mux_out => Mux_X_out
      );

  Mux_switch_Y : Mux2x1
    generic map (
      N => 16)
    port map (
      In1     => Mux_comp_Y_out,
      In2     => Mux_comp_X_out,
      Sel     => Switch_cmd,
      Mux_out => Mux_Y_out
      );

  Reg_X_out : Buff
    generic map (
      N => 16)
    port map (
      Buff_in  => Mux_X_out,
      Buff_OE  => '1',
      Clk      => Clk,
      Reset    => Reset,
      Buff_Out => X_Out
      );

  Reg_Y_out : Buff
    generic map (
      N => 16)
    port map (
      Buff_in  => Mux_Y_out,
      Buff_OE  => '1',
      Clk      => Clk,
      Reset    => Reset,
      Buff_Out => Y_Out
      );

  Switch_cmd <= cmd(0) xor cmd(1) xor cmd(2) xor cmd(3); -- X and Y switched if xor(cmd) = '1'
  X_sign_cmd <= cmd(2) or not(cmd(0)); -- positive sign if true
  Y_sign_cmd <= not(cmd(1)) or cmd(3); -- positive sign if true

  X_complement <= std_logic_vector(unsigned(not(X))+ ONE);
  Y_complement <= std_logic_vector(unsigned(not(Y))+ ONE);                                 

end architecture;
