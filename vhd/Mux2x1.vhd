library ieee;
use ieee.std_logic_1164.all;

entity Mux2x1 is

  generic (
    N : positive);

  port (
    In1     : in  std_logic_vector(N-1 downto 0);
    In2     : in  std_logic_vector(N-1 downto 0);
    Sel     : in  std_logic;
    Mux_out : out std_logic_vector(N-1 downto 0));

end entity Mux2x1;

architecture A of Mux2x1 is

begin  -- architecture A

  Mux_out <= In2 when (Sel = '1') else In1;

end architecture A;
