function [pks, loc] = findpeaks2d(matrix)
    pks = [];
    loc_x = [];
    loc_y = [];
    for row = 1:size(matrix,1)
        [pks_temp,loc_temp] = findpeaks(matrix(row,:));
        if ~ isempty(loc_temp)
            pks = [pks pks_temp];
            loc_x = [loc_x loc_temp];
            loc_y = [loc_y row*ones(1, size(pks_temp,2))];
        end
    end
    loc = [loc_x' loc_y'];
end
