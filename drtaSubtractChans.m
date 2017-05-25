function handles=drtaSubtractChans(handles)

% drtaPlotFeatures(handles)
%
% Plots preview for spike trains
%
%




if (handles.p.doSubtract==1)
    
    szsnips=size(handles.draq_d.snips);
    snips=zeros(szsnips(1),szsnips(2),szsnips(3));
    snips=handles.draq_d.snips;
    
   
    for tetr=1:4
        for jj=1:4
            if handles.p.subtractCh(4*(tetr-1)+jj)<=18
                if handles.p.subtractCh(4*(tetr-1)+jj)<=16
                    %Subtract one of the channels
                    handles.draq_d.snips((tetr-1)*4+jj,:,:)=snips((tetr-1)*4+jj,:,:)-snips(handles.p.subtractCh((tetr-1)*4+jj),:,:);
                    %data1(:,(tetr-1)*4+jj)=data2(:,(tetr-1)*4+jj)-data2(:,handles.p.subtractCh((tetr-1)*4+jj));
                else
                    if handles.p.subtractCh(4*(tetr-1)+jj)==17
                        %Subtract tetrode mean
                        handles.draq_d.snips((tetr-1)*4+jj,:,:)=snips((tetr-1)*4+jj,:,:)-mean(snips((tetr-1)*4+1:(tetr-1)*4+4,:,:),1);
                        %data1(:,(tetr-1)*4+jj)=data2(:,(tetr-1)*4+jj)-mean(data2(:,(tetr-1)*4+1:(tetr-1)*4+4),2);
                    else
                        %Subtract average of all electrodes
                        handles.draq_d.snips((tetr-1)*4+jj,:,:)=snips((tetr-1)*4+jj,:,:)-mean(snips,1);
                        %data1(:,(tetr-1)*4+jj)=data2(:,(tetr-1)*4+jj)-mean(data2,2);
                    end
                end
            end
        end
    end
end