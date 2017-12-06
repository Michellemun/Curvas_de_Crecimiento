function h = DelayInOD(bgdata, pl, pozo, dias, mapacolor)
% DelayInOD(bgdata, pl, mapacolor)
% 
    clf
    NuevosDias=EncuentraDias(bgdata(pl),.3);
    if nargin<5
        mapacolor=jet;
    end
	if nargin<4
        dias=1:length(NuevosDias)-1 ;
    end
    
    saltos=floor(length(mapacolor)/length(NuevosDias));
    %con=0;
   for i=dias
        %con=con+1;
        %subplot(length(dias),1,con)
        estedia=NuevosDias(i):NuevosDias(i+1)-1;
        plot( (bgdata(pl).t(estedia)-bgdata(pl).t(estedia(1)))*24,  bgdata(pl).OD(estedia, pozo),'.-', 'color', mapacolor(i*saltos,:))
        hold on
        xlim([0 22])
   end
    

end