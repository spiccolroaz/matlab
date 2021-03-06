inpath = '/ltraid3/ashao/uw-apl/projects/saf_altimetry/longterm/curvefit/processed/';
trackpath = '/ltraid4/aviso/alongtrack/sla/vxxc_matlab/';

files = dir([inpath 't*.mat']);
nfiles = length(files);

temp.lon = zeros(nfiles,1);
temp.lat = zeros(nfiles,1);
temp.width = zeros(nfiles,1);

acc.north = temp;
acc.south = temp;
acc.mean = temp;
%%
for tidx =1:nfiles
   
    load([inpath files(tidx).name])
    goodidx = cell2mat(opt_track.R2)<0.1;
    data = structfun(@(x) (x(goodidx)),opt_track.processed,'UniformOutput',false);
    if ~isempty(data.lat)
        [acc.north.lat(tidx) maxidx] = max(data.lat);
        acc.north.lon(tidx) = data.lon(maxidx);
        acc.north.width(tidx) = data.width(maxidx);
    
        [acc.south.lat(tidx) minidx] = min(data.lat);
        acc.south.lon(tidx) = data.lon(minidx);
        acc.south.width(tidx) = data.width(minidx);
    
        [acc.mean.lat(tidx) acc.mean.lon(tidx)] = meanm(data.lat,data.lon);        
        acc.mean.width(tidx) = mean(data.width);
    end
    
end

%%
coast = load ('coast.mat');

worldmap([-90 -30],[0 360])
symbolm(acc.mean.lat,acc.mean.lon,acc.mean.width)
plotm(coast.lat,coast.long)