function BgDataAll = ReadTecanFiles(directorio, appendTecanFiles, fluorescencias, BgDataAll)
% BgDataAll = ReadTecanFiles(directorio, appendTecanFiles, fluorescencias, BgDataAllIncompleto)
% si no pones directorio, entonces toma la carpeta en la que estás
% appendTecanFiles=0 es cuando es nuevo experimento, =1 es para solo poner
% los que falten y en ese caso debes poner el 4to parámetro con la
% estructura que tiene los datos previamente cargados
% fluorescencias = 0 es solo la OD.
% Los nombres de los archivos deben ser "PL1-YYMMDDHHMMSS" 
% tienen que empezar con PL seguidos del nùmero de plato, luego un guión y
% finalmente la fecha con dos dìgitos de año, mes, dìa, minuto y segundo
% %contiene la función strsplit

if nargin<1
    directorio=pwd;
end
if nargin<2
    appendTecanFiles=0;
end
if nargin<3
    fluorescencias=0;
%    return
end

cd(directorio)
archivos=dir('*.xls*');
length(archivos)
    preplato=0; %esto sirve para borrar todo y volver a cargar desde el principio 
for i=1:length(archivos)
    y=tic;
    nombre=strsplit(archivos(i).name, '-');
    temp=cell2mat(nombre(1));
    plato=str2num(temp(3:end));
    x=cell2mat(nombre(2));
    diahora=datenum(strcat(x(1:2),'/',x(3:4),'/',x(5:6),'-',x(7:8),':',x(9:10),':',x(11:12) ));
    
    if appendTecanFiles == 0;
   	if preplato~=plato %como entran en orden alfabetico, esto hace que vaya creando nuevos espacios para cada plato solo se descomenta cuando va empezando el experimento
            BgDataAll(plato).OD=[];
            if fluorescencias
                BgDataAll(plato).YFP=[];
                BgDataAll(plato).RFP=[];
            end
            BgDataAll(plato).t=[];
    end   
    end

  if find(BgDataAll(plato).t==diahora)
	continue  
  else
	i/length(archivos)
    [NUM , ~, RAW]=xlsread( archivos(i).name);
    
    if ~strcmp(RAW(18,1), 'Bandwidth') %si no dice Bandwidth quiere decir que se leyò fuera de Evoware y se tiene que recorrer una posicion
        sumar=1;
    else
        sumar=0;
    end
    
    od=(NUM(9-sumar:16-sumar,:));
    toc(y)
    
    if fluorescencias
    
        if length(NUM)>80 %quiere decir que el archivo tiene más filas de 80 solo cuando midió los 3 parámetros
            clear rfp CFP
            rfp=(NUM(42-sumar:49-sumar,:));
            CFP=(NUM(75-sumar:82-sumar,:));
        else
            clear rfp YFP
            rfp(1:96,1)=0;
            CFP(1:96,1)=0;
        end
        BgDataAll(plato).CFP=[BgDataAll(plato).CFP; CFP(:)'];
        BgDataAll(plato).RFP=[BgDataAll(plato).RFP; rfp(:)'];
    end

	BgDataAll(plato).OD=[BgDataAll(plato).OD; od(:)'];
	BgDataAll(plato).t=[BgDataAll(plato).t diahora];
    preplato=plato;
  end

end
if length(archivos)
    cd ..
else
    warning('No se encontraron archivos en tu carpeta')
end

end
%%
function terms = strsplit(s, delimiter)
%STRSPLIT Splits a string into multiple terms
%
%   terms = strsplit(s)
%       splits the string s into multiple terms that are separated by
%       white spaces (white spaces also include tab and newline).
%
%       The extracted terms are returned in form of a cell array of
%       strings.
%
%   terms = strsplit(s, delimiter)
%       splits the string s into multiple terms that are separated by
%       the specified delimiter. 
%   
%   Remarks
%   -------
%       - Note that the spaces surrounding the delimiter are considered
%         part of the delimiter, and thus removed from the extracted
%         terms.
%
%       - If there are two consecutive non-whitespace delimiters, it is
%         regarded that there is an empty-string term between them.         
%
%   Examples
%   --------
%       % extract the words delimited by white spaces
%       ts = strsplit('I am using MATLAB');
%       ts <- {'I', 'am', 'using', 'MATLAB'}
%
%       % split operands delimited by '+'
%       ts = strsplit('1+2+3+4', '+');
%       ts <- {'1', '2', '3', '4'}
%
%       % It still works if there are spaces surrounding the delimiter
%       ts = strsplit('1 + 2 + 3 + 4', '+');
%       ts <- {'1', '2', '3', '4'}
%
%       % Consecutive delimiters results in empty terms
%       ts = strsplit('C,Java, C++ ,, Python, MATLAB', ',');
%       ts <- {'C', 'Java', 'C++', '', 'Python', 'MATLAB'}
%
%       % When no delimiter is presented, the entire string is considered
%       % as a single term
%       ts = strsplit('YouAndMe');
%       ts <- {'YouAndMe'}
%

%   History
%   -------
%       - Created by Dahua Lin, on Oct 9, 2008
%

%% parse and verify input arguments

assert(ischar(s) && ndims(s) == 2 && size(s,1) <= 1, ...
    'strsplit:invalidarg', ...
    'The first input argument should be a char string.');

if nargin < 2
    by_space = true;
else
    d = delimiter;
    assert(ischar(d) && ndims(d) == 2 && size(d,1) == 1 && ~isempty(d), ...
        'strsplit:invalidarg', ...
        'The delimiter should be a non-empty char string.');
    
    d = strtrim(d);
    by_space = isempty(d);
end
    
%% main

s = strtrim(s);

if by_space
    w = isspace(s);            
    if any(w)
        % decide the positions of terms        
        dw = diff(w);
        sp = [1, find(dw == -1) + 1];     % start positions of terms
        ep = [find(dw == 1), length(s)];  % end positions of terms
        
        % extract the terms        
        nt = numel(sp);
        terms = cell(1, nt);
        for i = 1 : nt
            terms{i} = s(sp(i):ep(i));
        end                
    else
        terms = {s};
    end
    
else    
    p = strfind(s, d);
    if ~isempty(p)        
        % extract the terms        
        nt = numel(p) + 1;
        terms = cell(1, nt);
        sp = 1;
        dl = length(delimiter);
        for i = 1 : nt-1
            terms{i} = strtrim(s(sp:p(i)-1));
            sp = p(i) + dl;
        end         
        terms{nt} = strtrim(s(sp:end));
    else
        terms = {s};
    end        
end

end
