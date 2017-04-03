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

  Mux_out <= In1 when Sel = "00" else
             In2 when Sel = "01" else
             In3 when Sel = "10" else
             In4 when Sel = "11" else
             In1;

end architecture A;
