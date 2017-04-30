------------------------------Cadran_finder--------------------------------------

-- USED TO FIND THE CADRAN WHERE THE INPUT ANGLE IS

---------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity Cadran_finder is
  generic (
    N : positive -- data_size
    );
  port (Z_in_mod   : in  std_logic_vector(N-1 downto 0);
        Data_sel   : out std_logic_vector(3 downto 0); -- cmd signal for
                                                       -- Zo_VALUE_CALCULATION
        XY_out_cmd : out std_logic_vector (3 downto 0) -- cmd signal for
                                                       -- SIN_COS_ATTRIBUTION
        );
end Cadran_finder;

architecture A of Cadran_finder is

  component Comparator_G
    generic (
      N : positive);

    port (A, B : in  std_logic_vector(N-1 downto 0);
          S    : out std_logic
          );
  end component;

  signal Comparator_B         : std_logic_vector(N-1 downto 0);  -- mux4x1 out
  signal Comparator_pi_4_out  : std_logic;
  signal Comparator_3pi_4_out : std_logic;
  signal Comparator_5pi_4_out : std_logic;
  signal Comparator_7pi_4_out : std_logic;
  signal Sig_XY_cmd           : std_logic_vector(3 downto 0);

begin

  Comparator_pi_4 : Comparator_G
    generic map (
      N => 19)
    port map (
      A => Z_in_mod,
      B => "0000110010010000110",
      S => Comparator_pi_4_out
      );

  Comparator_3pi_4 : Comparator_G
    generic map (
      N => 19)
    port map (
      A => Z_in_mod,
      B => "0010010110110010110",
      S => Comparator_3pi_4_out
      );

  Comparator_5pi_4 : Comparator_G
    generic map (
      N => 19)
    port map (
      A => Z_in_mod,
      B => "0011111011010100110",
      S => Comparator_5pi_4_out
      );

  Comparator_7pi_4 : Comparator_G
    generic map (
      N => 19)
    port map (
      A => Z_in_mod,
      B => "0101011111110110110",
      S => Comparator_7pi_4_out
      );

-- cmd signals for Z0_VALUE_CALCULATION AND
-- SIN_COS_ATTRIBUTION

  Sig_XY_cmd(0) <= Comparator_pi_4_out;
  Sig_XY_cmd(1) <= Comparator_3pi_4_out;
  Sig_XY_cmd(2) <= Comparator_5pi_4_out;
  Sig_XY_cmd(3) <= Comparator_7pi_4_out;
  Data_sel      <= Sig_XY_cmd;
  XY_out_cmd    <= Sig_XY_cmd;

end architecture;


