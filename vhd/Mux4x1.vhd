library ieee;
use ieee.std_logic_1164.all;

entity Mux4x1 is

  generic (
    N : positive);

  port (
    In1     : in  std_logic_vector(N-1 downto 0);
    In2     : in  std_logic_vector(N-1 downto 0);
    In3     : in  std_logic_vector(N-1 downto 0);
    In4     : in  std_logic_vector(N-1 downto 0);
    Sel     : in  std_logic_vector(1 downto 0);
    Mux_out : out std_logic_vector(N-1 downto 0));

end entity Mux4x1;

architecture A of Mux4x1 is

begin  -- architecture A

  case Sel is
    when "00" =>
      Mux_out <= In1;
    when "01" =>
      Mux_out <= In2;
    when "10" =>
      Mux_out <= In3;
    when "11" =>
      Mux_out <= In4;

  end architecture A;
