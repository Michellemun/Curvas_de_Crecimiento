function BgDataAll = ReadTecanFiles(directorio, appendTecanFiles, fluorescencias, BgDataAll)
% BgDataAll = ReadTecanFiles(directorio, appendTecanFiles, fluorescencias)
% appendTecanFiles=0 es cuando es nuevo experimento, =1 es para solo poner
% los que falten
% fluorescencias = 0 es solo la OD.
%error(nargchk(0,10,nargin))
if nargin==0
    directorio=pwd;
    appendTecanFiles=0;
    fluorescencias=0;
    return
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
    od=(NUM(9:16,:));
    toc(y)
    
    if fluorescencias
    
        if length(NUM)>80
            clear rfp YFP
            rfp=(NUM(42:49,:));
            YFP=(NUM(75:82,:));
        else
            clear rfp YFP
            rfp(1:96,1)=0;
            YFP(1:96,1)=0;
        end
        BgDataAll(plato).YFP=[BgDataAll(plato).YFP; YFP(:)'];
        BgDataAll(plato).RFP=[BgDataAll(plato).RFP; rfp(:)'];
    end

	BgDataAll(plato).OD=[BgDataAll(plato).OD; od(:)'];
	BgDataAll(plato).t=[BgDataAll(plato).t diahora];
    preplato=plato;
  end

end
cd ..


end