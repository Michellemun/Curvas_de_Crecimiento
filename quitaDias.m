function bgdata=quitaDias(bgdata,dias,platos)
%   bgdata=quitaDias(bgdata,dias,platos)
%
%   Elimina los datos completos de los días de medición que se quieran
%   quitar. 
%   dias=[2 8];
%   bgdata=bgdataAll;
    for i=platos
        
        intervals=intervalCriteriaAJG(bgdata(i).od);
        todelete=[];
        
        for day=dias
            if day < length(intervals) %< day
                todelete=[ todelete intervals(day)+1:intervals(day+1) ];
            else
                %warning 
            end
        end
        tokeep=setdiff(1:length(bgdata(i).t), todelete);
        tam=length( bgdata(i).t );
        for j=1:length(fieldnames(bgdata)) %tiene que eliminar todos los campos
            temp=fieldnames(bgdata);
            field=temp(j);
            if size(bgdata(i).(cell2mat(field)),1)==tam ||  size(bgdata(i).(cell2mat(field)),2)==tam  %~strcmp(field,'id')%menos el del id
                temp=bgdata(i).(cell2mat(field));
                temp=temp(tokeep,:);
                bgdata(i).(cell2mat(field))=temp;
            end
        end
    end
end


