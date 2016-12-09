--------------------------------------------------------------------------------
--                        gen_tenhex.vhd
--    Test 10-digit hex sample PMK generator, because the ZTEX comm bus is slow
--    Copyright (C) 2016  Jarrett Rainier
--
--    This program is free software: you can redistribute it and/or modify
--    it under the terms of the GNU General Public License as published by
--    the Free Software Foundation, either version 3 of the License, or
--    (at your option) any later version.
--
--    This program is distributed in the hope that it will be useful,
--    but WITHOUT ANY WARRANTY; without even the implied warranty of
--    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--    GNU General Public License for more details.
--
--    You should have received a copy of the GNU General Public License
--    along with this program.  If not, see <http://www.gnu.org/licenses/>.
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.sha1_pkg.all;


entity gen_tenhex is

port(
    clk_i           : in    std_ulogic;
    rst_i           : in    std_ulogic;
    start_val_i     : in    mk_data;
    end_val_i       : in    mk_data;
    init_load_i     : in    std_ulogic;
    complete_o      : out    std_ulogic := '0';
    dat_mk_o        : out    mk_data
    );
end gen_tenhex;

architecture RTL of gen_tenhex is

    signal w: w_input;
    signal w_temp: w_input;
    
    signal complete: std_ulogic := '0';
    
    signal carry: unsigned(0 to 10) := "00000000001";
    -- synthesis translate_off
    --Testing only - Because GHDL VPI does not yet support arrays :<
    signal start_val: mk_data;
    signal end_val: mk_data;
    signal test_start_val0: unsigned(0 to 7);
    signal test_start_val1: unsigned(0 to 7);
    signal test_start_val2: unsigned(0 to 7);
    signal test_start_val3: unsigned(0 to 7);
    signal test_start_val4: unsigned(0 to 7);
    signal test_start_val5: unsigned(0 to 7);
    signal test_start_val6: unsigned(0 to 7);
    signal test_start_val7: unsigned(0 to 7);
    signal test_start_val8: unsigned(0 to 7);
    signal test_start_val9: unsigned(0 to 7);
    
    signal test_end_val0: unsigned(0 to 7);
    signal test_end_val1: unsigned(0 to 7);
    signal test_end_val2: unsigned(0 to 7);
    signal test_end_val3: unsigned(0 to 7);
    signal test_end_val4: unsigned(0 to 7);
    signal test_end_val5: unsigned(0 to 7);
    signal test_end_val6: unsigned(0 to 7);
    signal test_end_val7: unsigned(0 to 7);
    signal test_end_val8: unsigned(0 to 7);
    signal test_end_val9: unsigned(0 to 7);
    
    signal test_mk_val0: unsigned(0 to 7);
    signal test_mk_val1: unsigned(0 to 7);
    signal test_mk_val2: unsigned(0 to 7);
    signal test_mk_val3: unsigned(0 to 7);
    signal test_mk_val4: unsigned(0 to 7);
    signal test_mk_val5: unsigned(0 to 7);
    signal test_mk_val6: unsigned(0 to 7);
    signal test_mk_val7: unsigned(0 to 7);
    signal test_mk_val8: unsigned(0 to 7);
    signal test_mk_val9: unsigned(0 to 7);
    -- synthesis translate_on
    
    --Ten digit, hex (16^10)
    signal mk :  mk_data := (others => "00000000");
    signal mk_end :  mk_data := (others => "00000000");
    
    signal mk_next :  mk_data := (others => "00000000");
    
begin
    process(clk_i)   
    variable continue_carry: std_ulogic;
    variable complete_v: std_ulogic;
    begin
        if (clk_i'event and clk_i = '1') then
            if init_load_i = '1' then
                for i in 0 to 9 loop
                    --Todo: fix to start_val_i and end_val_i
                    mk(i) <= start_val_i(i);
                    mk_end(i) <= end_val_i(i);
                end loop;
            end if;
            if rst_i = '1' then
                complete <= '0';
            elsif complete = '0' then
                complete_v := '1';
                for i in 9 downto 0 loop
                    if mk(i) /= mk_end(i) then
                        complete_v := '0';
                    end if;
                end loop;
                if complete_v = '0' then
                    for i in 9 downto 0 loop
                        if carry(i + 1) = '1' and continue_carry = '1' then
                            mk(i) <= mk_next(i);
                        else
                            continue_carry := '0';
                        end if;
                    end loop;
                    continue_carry := '1';
                end if;
                complete <= complete_v;
            end if;
        end if;
    end process;
    
    dat_mk_o <= mk;
    complete_o <= complete;
    
    -- synthesis translate_off
    --Todo: remove after testing
    start_val(0) <= test_start_val0;
    start_val(1) <= test_start_val1;
    start_val(2) <= test_start_val2;
    start_val(3) <= test_start_val3;
    start_val(4) <= test_start_val4;
    start_val(5) <= test_start_val5;
    start_val(6) <= test_start_val6;
    start_val(7) <= test_start_val7;
    start_val(8) <= test_start_val8;
    start_val(9) <= test_start_val9;
    
    end_val(0) <= test_end_val0;
    end_val(1) <= test_end_val1;
    end_val(2) <= test_end_val2;
    end_val(3) <= test_end_val3;
    end_val(4) <= test_end_val4;
    end_val(5) <= test_end_val5;
    end_val(6) <= test_end_val6;
    end_val(7) <= test_end_val7;
    end_val(8) <= test_end_val8;
    end_val(9) <= test_end_val9;
    
    test_mk_val0 <= mk(0);
    test_mk_val1 <= mk(1);
    test_mk_val2 <= mk(2);
    test_mk_val3 <= mk(3);
    test_mk_val4 <= mk(4);
    test_mk_val5 <= mk(5);
    test_mk_val6 <= mk(6);
    test_mk_val7 <= mk(7);
    test_mk_val8 <= mk(8);
    test_mk_val9 <= mk(9);
    
    -- synthesis translate_on
    
    
    mk_inc: for i in 9 downto 0 generate
    begin
        with mk(i) select mk_next(i) <=
                     X"61" when X"39",
                     X"30" when X"66",
                     mk(i) + 1 when others;
        with mk(i) select carry(i) <=
                     '1' when X"66",
                     '0' when others;
    end generate mk_inc;

end RTL; 