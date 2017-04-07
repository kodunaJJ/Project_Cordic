-----------------------------Dmux1x3.vhd-------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Dmux1x3 is
  generic (
    N : positive
    );
  port(
    Input : in  std_logic_vector(N-1 downto 0);
    Sel   : in  std_logic_vector(2 downto 0);
    Out1  : out std_logic_vector(N-1 downto 0);
    Out2  : out std_logic_vector(N-1 downto 0);
    Out3  : out std_logic_vector(N-1 downto 0)
    );
end entity Dmux1x3;

architecture A of Dmux1x3 is

begin

  process(Input, Sel)
  begin

    Out1 <= (others => '0');
    Out2 <= (others => '0');
    Out3 <= (others => '0');
    case Sel is
      when "000" =>
        Out1 <= Input;
      when "001" =>
        Out2 <= Input;
      when "010" =>
        Out3 <= Input;
      when others => null;
                     
    end case;
  end process;

end architecture;
