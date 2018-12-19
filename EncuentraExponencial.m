function PuntosExponencial = EncuentraExponencial(OD, t, plots)
% si plots=1 hace dibujos
% plots=0, no se detiene a hacer plots.
if plots
    figure(1)
    clf
    plot(t,OD,'o')
    hold on
end
  for i=1:size(OD,1)-3
        [m]=robustfit(t(i:i+2), OD(i:i+2));
        pendientes(i)=m(2);
        if plots
            plot([t(i) t(i+2)], [t(i)*m(2)+m(1) m(2)*t(i+2)+m(1)],'*-r')
            hold on
        end

  end
        Pexponencial=find(pendientes>(max(pendientes)/2));
        if plots
            plot([t(Pexponencial+1)], OD(Pexponencial+1),'*-b')
        end
        PuntosExponencial=Pexponencial+1;
end

