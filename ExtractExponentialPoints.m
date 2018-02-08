function ExpBgDataAll = ExtractExponentialPoints(BgDataAll, platos, fig)
% ExpBgDataAll = ExtractExponentialPoints(BgDataAll, platos)
    
    
    for pl=platos
        PuntosExponencial = EncuentraExponencial(BgDataAll(pl).OD, BgDataAll(pl).t, 0);
        ExpBgDataAll(pl).OD = BgDataAll(pl).OD(PuntosExponencial,:) ;
        ExpBgDataAll(pl).CFP = BgDataAll(pl).CFP(PuntosExponencial,:) ;
        ExpBgDataAll(pl).RFP = BgDataAll(pl).RFP(PuntosExponencial,:) ;
        ExpBgDataAll(pl).t = BgDataAll(pl).t(PuntosExponencial) ;
        
        figure(1000+pl)
        if fig
            plot( BgDataAll(pl).OD, 'b' )
            hold on
            plot(PuntosExponencial, BgDataAll(pl).OD(PuntosExponencial,:), 'o-r' )
        end
    end
    
    
end