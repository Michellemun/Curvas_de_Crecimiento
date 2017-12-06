function NuevosDias = EncuentraDias(bgdata,odTh)
%NuevosDias = EncuentraDias(bgdata,odTh)
%bgdata es de 1 solo plato a la vez
%odTh debe ser positivo, cuanto tiene que haber bajado la OD para que le
%digas que es nuevo dia
diffOD = diff(bgdata.OD,1,1);
dias=find(mean(diffOD')<-odTh);
NuevosDias=[1 dias+1];
end