----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/29/2023 10:25:44 PM
-- Design Name: 
-- Module Name: filter2 - Behavioral
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
use IEEE.math_real."log2";
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity filter2 is
    generic(
    coeff_bitwidth: integer:= 16;
    coeff_count: integer:=201;
    din_bitwidth: integer:=24;
    dout_bitwidth: integer:=24);
    
    Port ( CLock : in STD_LOGIC;
           Data : in STD_LOGIC_VECTOR (din_bitwidth-1 downto 0);
           data_out : out STD_LOGIC_VECTOR (dout_bitwidth-1 downto 0) := (others => '0');
           reset : in STD_LOGIC;
           coefficients: in signed(coeff_bitwidth * coeff_count-1  downto 0));
           
end filter2;

architecture Behavioral of filter2 is
signal temp_data: std_logic_vector(dout_bitwidth-1 downto 0):= (others => '0');
signal clockdiv_debug: integer := 0;
signal delay_regs_debug: signed((coeff_bitwidth+din_bitwidth) * coeff_count-1  downto 0):= (others => '0');

signal delay_regs: signed((coeff_bitwidth+din_bitwidth) * coeff_count-1  downto 0):= (others => '0');---integer(log2(real(coeff_count)))
signal delay_regs2: signed((coeff_bitwidth+din_bitwidth)* coeff_count-1  downto 0):=(others => '0');
signal buffer_debug:signed(din_bitwidth * coeff_count-1 downto 0) := (others => '0');

begin
    --data_out <= (others => '1');
    data_out <=std_logic_vector(delay_regs2(delay_regs2'left downto delay_regs2'left - 23));--take most significant part
    process(clock)
    --for any kind of filters it is important to ensure a bitwidth that allows for a combination of the result of a convolution with max values
    --variable sum: signed(din_bitwidth + coeff_bitwidth + integer(log2(real(coeff_count))) downto 0) := (others => '0');
    -- if the filter is porperly scaled (passband is one dB) then:
    variable sum: signed(din_bitwidth + coeff_bitwidth downto 0) := (others => '0');
    variable counter: integer :=0;
    --variable incoming_buffer: signed(din_bitwidth * coeff_count-1 downto 0) := (others => '0');

    variable clockdiv: integer;
        begin
            if(reset = '1')then
                clockdiv_debug <= 0;
            else
                if(rising_edge(clock)) then
                  if(clockdiv_debug = 0) then
                    
                    --incoming_buffer := incoming_buffer sll din_bitwidth;
                    --buffer_debug <= incoming_buffer;
                    --incoming_buffer(din_bitwidth-1 downto 0) := signed(data);
                    --delay_regs(delay_regs'right+ din_bitwidth  downto 0)<= signed(data);
                    for i in 0 to coeff_count-1 loop
                        delay_regs((din_bitwidth+coeff_bitwidth)*(i+1)-1 downto (din_bitwidth + coeff_bitwidth)*i) <= signed(data)  * signed(coefficients(coeff_bitwidth*(i+1)-1 downto coeff_bitwidth*i));
                    end loop;
                    clockdiv_debug <= 1;
                 elsif(clockdiv_debug = 1) then 
                    for i in  coeff_count-2 downto 0 loop
                        delay_regs2((din_bitwidth+coeff_bitwidth)*(i+2)-1 downto (din_bitwidth+coeff_bitwidth)*(i+1)) <= (delay_regs((din_bitwidth+coeff_bitwidth)*(i+1)-1 downto (din_bitwidth+coeff_bitwidth)*i) + delay_regs2((din_bitwidth + coeff_bitwidth)*(i+1)-1 downto (din_bitwidth + coeff_bitwidth)*(i)));
                    end loop;
                    --delay_regs2(din_bitwidth+coeff_bitwidth-1 downto 0) <= delay_regs(din_bitwidth+coeff_bitwidth-1 downto 0);
                    clockdiv_debug <= 2;
                 elsif(clockdiv_debug = 2) then
                    --delay_regs <= delay_regs2;
                    --data_out <=std_logic_vector(delay_regs2(delay_regs2'left downto delay_regs2'left - 23));--take most significant part
                    clockdiv_debug <= 0;
                end if;
                --clockdiv_debug <= clockdiv;
              end if;
            end if;  
    end process;
    
--    process(clock)
--    begin
--        if(reset = '1') then
--            data_out <=(others => '0');
--        elsif(rising_edge(clock))then
--            data_out<= temp_data;
--        end if;
--    end process;

end Behavioral;
