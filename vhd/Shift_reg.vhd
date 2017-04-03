library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Shift_reg is
  generic (
    N : positive);
  port (Clk           : in  std_logic;
        Reset         : in  std_logic;
        Shift_enable  : in  std_logic;
        Shift_reg_in  : in  std_logic;
        Shift_reg_out : out std_logic_vector(N-1 downto 0));
end Shift_reg;

architecture A of Shift_reg is

  signal Reg_value : unsigned(N-1 downto 0);

begin

  Shift_reg_out <= std_logic_vector(Reg_value);
  P_Shift : process (Clk)
  begin  -- process P_buff
    if(Clk = '1' and Clk'event) then
      if Reset = '1' then
        Shift_reg_out <= (others => '0');
      elsif Shift_enable = '1' then
        Reg_value      <= Reg_value srl 1;
        Reg_value(N-1) <= Shift_reg_in;
      end if;
    end if;
  end process P_Shift;

end architecture;
