Program Theme17_Final_Project;
uses crt;
const max = 100;
type zapis = record
     town: string;
     latitude: real;
     longitude: real;
     end;
     mas_num = array[1..max] of integer;
     mas_zap = array[1..max] of zapis;
     sort_type = (fromNtoS, fromStoN, fromNStoSN, random_shuf);
var TownData, Data_for_Sort: mas_zap;
    dlina, n_exp: mas_num;
    mas_param: array[1..2, 1..5] of integer;
    i, j, n: integer;
    prog_mode, count_compare_bin, count_compare_quick, count_assigment_bin, count_assigment_quick: integer;
    mean_comp, mean_assig: integer;

{Procedure of reading data from file and putting it in array of record}
procedure fileRead(var output_data: mas_zap; fileAdr: string; size_r: integer);
var file_r: text;
    i_r, j_r, count, str_start, err: integer;
    buf_str, buf_substr: string;

begin
    assign(file_r, fileAdr);
    reset(file_r);
    for i_r := 1 to size_r do begin
        readln(file_r, buf_str);
        count := 1;
        str_start := 1;
        for j_r := 1 to length(buf_str) do
            if buf_str[j_r] = ';' then begin
                if count = 1 then begin
                    buf_substr := copy(buf_str, str_start, j_r - str_start);
                    output_data[i_r].town := buf_substr;
                end;
                if count = 3 then begin
                    buf_substr := copy(buf_str, str_start, j_r - str_start - 2);
                    val(buf_substr, output_data[i_r].latitude, err);
                end;
                count := count + 1;
                str_start := j_r + 1
            end;
        buf_substr := copy(buf_str, str_start, length(buf_str) - str_start - 1);
        val(buf_substr, output_data[i_r].longitude, err);
    end
end;


{Procedure of writing data on file}
procedure fileWrite(var write_mas: mas_zap; fileAdr: string; size_w: integer; sortKey: sort_type);
var ft_w: text;
    i_w: integer;

begin
    case sortKey of
    fromNtoS: begin
            assign(ft_w, fileAdr);
            rewrite(ft_w);
            for i_w := size_w downto 1 do begin
                write(ft_w, write_mas[i_w].town);
                if write_mas[i_w].latitude > 0 then
                    write(ft_w,';сш;')
                else
                    write(ft_w,';юш;');
                write(ft_w, write_mas[i_w].latitude:5:2, '°');
                if write_mas[i_w].longitude > 0 then
                    write(ft_w,';вд;')
                else
                    write(ft_w,';зд;');
                writeln(ft_w, write_mas[i_w].longitude:5:2, '°');
            end;
            close(ft_w);
        end;
    fromStoN, random_shuf: begin
            assign(ft_w, fileAdr);
            rewrite(ft_w);
            for i_w := 1 to size_w do begin
                write(ft_w, write_mas[i_w].town);
                if write_mas[i_w].latitude > 0 then
                    write(ft_w,';сш;')
                else
                    write(ft_w,';юш;');
                write(ft_w, write_mas[i_w].latitude:5:2, '°');
                if write_mas[i_w].longitude > 0 then
                    write(ft_w,';вд;')
                else
                    write(ft_w,';зд;');
                writeln(ft_w, write_mas[i_w].longitude:5:2, '°');
            end;
            close(ft_w);
           end;
    fromNStoSN: begin
                assign(ft_w, fileAdr);
                rewrite(ft_w);
                for i_w := size_w downto 1 do
                        if i_w mod 2 = 0 then begin
                            write(ft_w, write_mas[i_w].town);
                            if write_mas[i_w].latitude > 0 then
                                write(ft_w,';сш;')
                            else
                                write(ft_w,';юш;');
                            write(ft_w, write_mas[i_w].latitude:5:2, '°');
                            if write_mas[i_w].longitude > 0 then
                                write(ft_w,';вд;')
                            else
                                write(ft_w,';зд;');
                            writeln(ft_w, write_mas[i_w].longitude:5:2, '°');
                            end
                        else begin
                            write(ft_w, write_mas[size_w - i_w + 1].town);
                            if write_mas[size_w - i_w + 1].latitude > 0 then
                                write(ft_w,';сш;')
                            else
                                write(ft_w,';юш;');
                            write(ft_w, write_mas[size_w - i_w + 1].latitude:5:2, '°');
                            if write_mas[size_w - i_w + 1].longitude > 0 then
                                write(ft_w,';вд;')
                            else
                                write(ft_w,';зд;');
                            writeln(ft_w, write_mas[size_w - i_w + 1].longitude:5:2, '°');
                        end;
                close(ft_w);
            end;
        end;
end;

{Procedure of output array on screen}
procedure Print(var input_mass: mas_zap; size_pr: integer; key: sort_type);
var i_pr : integer;
begin
    case key of
    fromStoN: begin
            for i_pr := 1 to size_pr do begin
                write(input_mass[i_pr].town);
                if input_mass[i_pr].latitude > 0 then
                    write(';сш;')
                else
                    write(';юш;');
                write(input_mass[i_pr].latitude:5:2, '°');
                if input_mass[i_pr].longitude > 0 then
                    write(';вд;')
                else
                    write(';зд;');
                write(input_mass[i_pr].longitude:5:2, '°');
                writeln;
            end;
            writeln;
        end;
    fromNtoS: begin
            for i_pr := size_pr downto 1 do begin
                write(input_mass[i_pr].town);
                if input_mass[i_pr].latitude > 0 then
                    write(';сш;')
                else
                    write(';юш;');
                write(input_mass[i_pr].latitude:5:2, '°');
                if input_mass[i_pr].longitude > 0 then
                    write(';вд;')
                else
                    write(';зд;');
                write(input_mass[i_pr].longitude:5:2, '°');
                writeln;
            end;
            writeln;
        end;
    end;
end;
    
{Function of binary search}
function binSearch(inp_seq: mas_zap; item: real; size_f: integer; var count_cmp_f: integer): integer;
var low, high, mid: integer;
begin
    low := 1;
    high := size_f;
    while low <= high do begin
        mid := (low + high) div 2;
    
        count_cmp_f := count_cmp_f + 1; {schetchik sravneniy}
        if item = inp_seq[mid].latitude then begin
            binSearch := mid + 1;
            exit;
        end;
        
        count_cmp_f := count_cmp_f + 1;
        if item < inp_seq[mid].latitude then 
            high := mid - 1
        else 
            low := mid + 1;
    end;
    
    count_cmp_f := count_cmp_f + 1;
    if item > inp_seq[low].latitude then
        binSearch := low + 1
    else
        binSearch := low
end;

{Binary insertion procedure}
procedure binSort(var inp_seq: mas_zap; size_p: integer; demo: integer; var count_cmp, count_assig: integer);
var i_p, j_p, k_p,  ind: integer;
    buf: zapis;
begin
    for i_p := 2 to size_p do begin
        buf := inp_seq[i_p];
        ind := binSearch(inp_seq, inp_seq[i_p].latitude, i_p - 1, count_cmp);
        if i_p <> ind then begin
                for j_p := i_p downto ind + 1 do begin
                    inp_seq[j_p] := inp_seq[j_p - 1];
                    count_assig := count_assig + 1;
                end;
                inp_seq[ind] := buf;
                count_assig := count_assig + 1;
            end;
        
        if demo = 1 then begin
            writeln('binSort iterations: ');
            Print(inp_seq, size_p, fromStoN);
        end;
    end;
end;

{Quick sort procedure}
procedure quickSort(var inp_seq: mas_zap; size_p: integer; left, right: integer; demo: integer; var count_cmp, count_assig: integer);
var i_p, j_p, k_p, q: integer;
    buf: zapis;
    p: real;
begin
    
    if right - left = 1 then begin
        count_cmp := count_cmp + 1;
        if inp_seq[left].latitude > inp_seq[right].latitude then begin
            count_assig := count_assig + 1;
            buf := inp_seq[left];
            inp_seq[left] := inp_seq[right];
            inp_seq[right] := buf;
            
            if demo = 1 then begin
                writeln('quickSort last iteration:');
                Print(inp_seq, size_p, fromStoN);
            end;
        end;
        
        right := left;
    end;

    q := random(right - left) + left;
    p := inp_seq[q].latitude;

    i_p := left;
    j_p := right;

    while i_p < j_p do begin
        while inp_seq[i_p].latitude < p do begin
            count_cmp := count_cmp + 1;
            i_p := i_p + 1;
        end;
        count_cmp := count_cmp + 1;

        while inp_seq[j_p].latitude > p do begin
            count_cmp := count_cmp + 1;
            j_p := j_p - 1;
        end;
        count_cmp := count_cmp + 1;
        
        if inp_seq[i_p].latitude = inp_seq[j_p].latitude then begin
            i_p := i_p + 1;
            j_p := j_p - 1;
        end
        
        else            
            if (i_p < j_p) then begin
                count_assig := count_assig + 1;
                buf := inp_seq[i_p];
                inp_seq[i_p] := inp_seq[j_p];
                inp_seq[j_p] := buf;
        
                if demo = 1 then begin
                    writeln('quickSort iterations:');
                    Print(inp_seq, size_p, fromStoN);
                end;
        
                i_p := i_p + 1;
                j_p := j_p - 1;
            end;
   end;
    
   if left < j_p then quickSort(inp_seq, size_p, left, j_p , demo, count_cmp, count_assig);
   if i_p < right then quickSort(inp_seq, size_p, i_p, right, demo, count_cmp, count_assig);

end;

{Array mixing procedure}
Procedure Shuffle(var shuf_data: mas_zap; size_s: integer);
var ind: mas_num;
    buff_data: zapis;
    i_s, j_s: integer;
begin
    for i_s := size_s downto 2 do begin
        j_s := random(i_s) + 1;
        buff_data := shuf_data[i_s];
        shuf_data[i_s] := shuf_data[j_s];
        shuf_data[j_s] := buff_data;
    end;
end;

{Procedure of Sorting Experiments}
Procedure SortExp(n_e: mas_num; s_key: string);
var inp_seq: mas_zap;
    i_e, j_e: integer;
    count_compare_exp, count_assigment_exp, total_comp, total_assig: integer;
    ft: text;
        
begin
    writeln;
    writeln('LETS TAKE OTHER DATA AS DIFFERENT EXAMPLES:');
    writeln;
    writeln('f_n_initial.txt - sequence N 1');
    writeln('f_n_up.txt - sequence N 2');
    writeln('f_n_down.txt - sequence N 3');
    writeln('f_n_up_and_down.txt - sequence N 4');
    writeln('f_n_random.txt - sequence N 5');
    
    
    writeln;
    if s_key = 'binsort' then
        writeln('               Results of BinSort Experiments:                ');
    if s_key = 'quicksort' then
        writeln('               Results of QuickSort Experiments:              ');
    writeln('--------------------------------------------------------------');
    writeln('|  n  |   paramert    |     sequence number           |  mean |');
    writeln('|     |               |    1     2    3    4    5     |       |');
    writeln('--------------------------------------------------------------');
        
    assign(ft, 'results.txt'); 
    append(ft);
    
    if s_key = 'binsort' then
        writeln(ft,'               Results of BinSort Experiments:                ');
    if s_key = 'quicksort' then
        writeln(ft,'               Results of QuickSort Experiments:              ');
    writeln(ft,'--------------------------------------------------------------');
    writeln(ft,'|  n  |   paramert    |     sequence number           |  mean |');
    writeln(ft,'|     |               |    1     2    3    4    5     |       |');
    writeln(ft,'--------------------------------------------------------------');
    close(ft);
    
    i_e := 1;
    repeat begin
        fileRead(inp_seq, 'f_n_initial.txt', n_e[i_e]);
        count_compare_exp := 0;
        count_assigment_exp := 0;
        if s_key = 'binsort' then
            binsort(inp_seq, n_e[i_e], 0, count_compare_exp, count_assigment_exp);
        if s_key = 'quicksort' then  
            quicksort(inp_seq, n_e[i_e], 1, n_e[i_e], 0, count_compare_exp, count_assigment_exp);
        mas_param[1,1] := count_compare_exp;
        mas_param[2,1] := count_assigment_exp;
        
        fileRead(inp_seq, 'f_n_up.txt', n_e[i_e]);
        count_compare_exp := 0;
        count_assigment_exp := 0;
        if s_key = 'binsort' then
            binsort(inp_seq, n_e[i_e], 0, count_compare_exp, count_assigment_exp);
        if s_key = 'quicksort' then  
            quicksort(inp_seq, n_e[i_e], 1, n_e[i_e], 0, count_compare_exp, count_assigment_exp);
        mas_param[1,2] := count_compare_exp;
        mas_param[2,2] := count_assigment_exp;
    
        fileRead(inp_seq, 'f_n_down.txt', n_e[i_e]);
        count_compare_exp := 0;
        count_assigment_exp := 0;
        if s_key = 'binsort' then
            binsort(inp_seq, n_e[i_e], 0, count_compare_exp, count_assigment_exp);
        if s_key = 'quicksort' then  
            quicksort(inp_seq, n_e[i_e], 1, n_e[i_e], 0, count_compare_exp, count_assigment_exp);
        mas_param[1,3] := count_compare_exp;
        mas_param[2,3] := count_assigment_exp;

        fileRead(inp_seq, 'f_n_up_and_down.txt', n_e[i_e]);
        count_compare_exp := 0;
        count_assigment_exp := 0;
        if s_key = 'binsort' then
            binsort(inp_seq, n_e[i_e], 0, count_compare_exp, count_assigment_exp);
        if s_key = 'quicksort' then  
            quicksort(inp_seq, n_e[i_e], 1, n_e[i_e], 0, count_compare_exp, count_assigment_exp);
        mas_param[1,4] := count_compare_exp;
        mas_param[2,4] := count_assigment_exp;
    
        fileRead(inp_seq, 'f_n_random.txt', n_e[i_e]);
        count_compare_exp := 0;
        count_assigment_exp := 0;
        if s_key = 'binsort' then
            binsort(inp_seq, n_e[i_e], 0, count_compare_exp, count_assigment_exp);
        if s_key = 'quicksort' then  
            quicksort(inp_seq, n_e[i_e], 1, n_e[i_e], 0, count_compare_exp, count_assigment_exp);
        mas_param[1,5] := count_compare_exp;
        mas_param[2,5] := count_assigment_exp;

        total_comp := 0;
        total_assig := 0;
        for j_e := 1 to 5 do begin
            total_comp := (total_comp + mas_param[1,j_e]);
            total_assig := (total_assig + mas_param[2,j_e]);
            end;
        mean_comp := total_comp div 5;
        mean_assig := total_assig div 5;
    
        writeln('| ', n_e[i_e]:3, ' |   sravneniya  |   ',mas_param[1,1]:4, ' ', mas_param[1,2]:4, ' ', mas_param[1,3]:4, ' ', mas_param[1,4]:4, ' ', mas_param[1,5]:4, '    |', mean_comp:5, '  |');
        writeln('| ', n_e[i_e]:3, ' | peremesheniya |   ', mas_param[2,1]:4, ' ', mas_param[2,2]:4, ' ', mas_param[2,3]:4, ' ', mas_param[2,4]:4, ' ', mas_param[2,5]:4, '    |', mean_assig:5,'  |');
        writeln('--------------------------------------------------------------');
        
        append(ft);
        write(ft,'| ');
        write(ft, n_e[i_e]:3);
        write(ft,' |   sravneniya  |   ');
        write(ft, mas_param[1,1]:4);
        write(ft,' ');
        write(ft, mas_param[1,2]:4);
        write(ft,' ');
        write(ft, mas_param[1,3]:4);
        write(ft, ' ');
        write(ft, mas_param[1,4]:4);
        write(ft, ' ');
        write(ft, mas_param[1,5]:4);
        write(ft, '    |');
        write(ft, mean_comp:5);
        write(ft, '  |');
        writeln(ft);
        
        write(ft,'| ');
        write(ft, n_e[i_e]:3);
        write(ft,' | peremesheniya |   ');
        write(ft, mas_param[2,1]:4);
        write(ft,' ');
        write(ft, mas_param[2,2]:4);
        write(ft,' ');
        write(ft, mas_param[2,3]:4);
        write(ft, ' ');
        write(ft, mas_param[2,4]:4);
        write(ft, ' ');
        write(ft, mas_param[2,5]:4);
        write(ft, '    |');
        write(ft, mean_assig:5);
        write(ft, '  |');
        writeln(ft,'--------------------------------------------------------------');
        close(ft);
        i_e := i_e + 1;
    end
    until n_e[i_e] = 0;
    writeln;
end;
    
{Main program block}
begin
    randomize;
    
    {definition of program mode}
    writeln('program mode will be: standart or demonstration? (0/1)');
    readln(prog_mode);

    if (prog_mode <> 0) and (prog_mode <> 1) then begin
        writeln('program mode incorrectly specified');
        readln;
        exit;
    end;
    
    if prog_mode = 0 then begin
        
        {definition of values of N for experiments}
        for i := 1 to 10 do
            n_exp[i] := i * 10;
        
        fileRead(TownData, 'f_n_initial.txt', max);
        
        Data_for_Sort := TownData;
        
        count_compare_bin := 0;
        count_assigment_bin := 0;
        binsort(Data_for_Sort, max, prog_mode, count_compare_bin, count_assigment_bin);
        
        writeln('SORTED BY BIN-SEARCH:');
        Print(Data_for_Sort, max, fromNtoS);
        
        fileWrite(Data_for_Sort, 'f_n_up.txt', max, fromNtoS);
        fileWrite(Data_for_Sort, 'f_n_down.txt', max, fromStoN);    
        fileWrite(Data_for_Sort, 'f_n_up_and_down.txt', max, fromNStoSN);
     
        Shuffle(Data_for_Sort, max);
        fileWrite(Data_for_Sort, 'f_n_random.txt', max, random_shuf);
        
        SortExp(n_exp, 'binsort');

        Data_for_Sort := TownData;
        count_compare_quick:= 0;
        count_assigment_quick := 0;
        quicksort(Data_for_Sort, max, 1, max, prog_mode, count_compare_quick, count_assigment_quick);
        
        writeln;
        writeln('SORTED BY QUICK SORT:');
        Print(Data_for_Sort, max, fromNtoS);

        SortExp(n_exp, 'quicksort');
        
    end
        
    else begin 
        
        writeln('input sequence length N (from 1 to 100)');
        readln(n);

        if n > max then begin
            writeln('n is out of range');
            readln;
            exit;
        end;
    
        {definition of values of N for experiments}
        n_exp[1] := n; 
            
        fileRead(TownData, 'f_n_initial.txt', n);

        writeln;
        writeln('INITIAL TEXT:');
        Print(TownData, n, fromStoN);
    
        Data_for_Sort := TownData;

        count_compare_bin := 0;
        count_assigment_bin := 0;
        binsort(Data_for_Sort, n, prog_mode, count_compare_bin, count_assigment_bin);
    
        writeln('SORTED BY BIN-SEARCH:');
        Print(Data_for_Sort, n, fromNtoS);

        fileWrite(Data_for_Sort, 'f_n_up.txt', n, fromNtoS);
        fileWrite(Data_for_Sort, 'f_n_down.txt', n, fromStoN);    
        fileWrite(Data_for_Sort, 'f_n_up_and_down.txt', n, fromNStoSN);
      
        Shuffle(Data_for_Sort, n);
        fileWrite(Data_for_Sort, 'f_n_random.txt', n, random_shuf);
    
        SortExp(n_exp, 'binsort');

        writeln;
        writeln('INITIAL TEXT:');
        Print(TownData, n, fromStoN);
        
        Data_for_Sort := TownData;
        count_compare_quick:= 0;
        count_assigment_quick := 0;
        quicksort(Data_for_Sort, n, 1, n, prog_mode, count_compare_quick, count_assigment_quick);
    
        writeln;
        writeln('SORTED BY QUICK SORT:');
        Print(Data_for_Sort, n, fromNtoS);

        SortExp(n_exp, 'quicksort');
    end;
             
end.