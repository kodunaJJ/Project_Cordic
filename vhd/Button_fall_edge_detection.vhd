library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Button_fall_edge_detection is
  port(
    Reset      : in  std_logic;
    Button_in  : in  std_logic;
    Button_out : out std_logic
    );
end Button_fall_edge_detection;

architecture a of Button_fall_edge_detection is

  signal Sig_Button_in : std_logic;
begin

  Sig_Button_in <= Button_in;

  process (Sig_Button_in, Reset)
  begin
    if(Reset = '1') then
      Button_out <= '0';
    elsif(Sig_Button_in'event and Sig_Button_in = '0') then
      Button_out <= '1';

    end if;

  end process;

end architecture;
