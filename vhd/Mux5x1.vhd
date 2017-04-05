library ieee;
use ieee.std_logic_1164.all;

entity Mux5x1 is

  generic (
    N : positive);

  port (
    In1     : in  std_logic_vector(N-1 downto 0);
    In2     : in  std_logic_vector(N-1 downto 0);
    In3     : in  std_logic_vector(N-1 downto 0);
    In4     : in  std_logic_vector(N-1 downto 0);
    In5     : in  std_logic_vector(N-1 downto 0);
    Sel     : in  std_logic_vector(2 downto 0);
    Mux_out : out std_logic_vector(N-1 downto 0));

end entity Mux5x1;

architecture A of Mux5x1 is

begin  -- architecture A

  Mux_out <= In1 when Sel = "000" else
             In2 when Sel = "001" else
             In3 when Sel = "010" else
             In4 when Sel = "011" else
             In5 when Sel = "100" else
             In1;

end architecture A;
