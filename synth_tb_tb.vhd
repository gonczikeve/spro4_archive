----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/08/2023 04:32:13 PM
-- Design Name: 
-- Module Name: synth_tb_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;



-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity synth_tb_tb is
--  Port ( );
    generic(din_bitwidth: integer:=24;
    dout_bitwidth: integer := 24;
    coeff_bitwidth: integer := 16
    );
end synth_tb_tb;

architecture Behavioral of synth_tb_tb is
    component sine_signed is
        Port (wave_out: out std_logic_vector(din_bitwidth-1 downto 0);
            clock: in std_logic;
            reset: in std_logic);
    end component;
    
    component synth_tb is

    generic(
        coeff_bitwidth: integer:= 16;
        coeff_count: integer:=201;
        din_bitwidth: integer:=24;
        dout_bitwidth: integer:=24);
    Port ( CLock : in STD_LOGIC;
           Data : in STD_LOGIC_VECTOR (din_bitwidth-1 downto 0);
           data_out : out STD_LOGIC_VECTOR (dout_bitwidth-1 downto 0);
           reset : in STD_LOGIC);
           --coefficients: in signed(coeff_bitwidth * coeff_count-1  downto 0));
    end component;
    
    signal Clock: std_logic :='0';
    signal clockdiv: std_logic :='0';
    signal sin_to_filter: std_logic_vector(din_bitwidth-1 downto 0);
    --signal sin1_out: std_logic_vector(15 downto 0);
    signal sin2_out: STD_LOGIC_VECTOR(dout_bitwidth-1 downto 0);
begin
    sine_gen: sine_signed port map(Clock => clockdiv, wave_out => sin_to_filter, reset => '0');
    filter: synth_tb generic map(coeff_bitwidth => coeff_bitwidth,din_bitwidth =>din_bitwidth, dout_bitwidth => dout_bitwidth)
    port map(Clock => clock, Data => sin_to_filter, data_out => sin2_out, reset => '0');
    Clock_process: process
    begin
        clock <= not clock;
        clockdiv <= not clockdiv;
        wait for 11338 ns;
        clock <= not clock;
        wait for 11338 ns;
        clock <= not clock;
        wait for 11338 ns;
    end process;

end Behavioral;
