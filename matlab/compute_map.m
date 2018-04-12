function [map, aps, pr, prs] = compute_map (ranks, gnd, kappas)
% COMPUTE_MAP  This function computes the mAP for a given set of returned results.
%
% Usage: 
%   map = compute_map (ranks, gnd) 
%         computes mean average precsion (map) only
%
%   [map, aps, pr, prs] = compute_map (ranks, gnd, kappas) 
%         computes mean average precision (map), average precision (aps) for each query
%         computes mean precision at kappas (pr), precision at kappas (prs) for each query
%
% Notes:
% 1) ranks starts from 1, size(ranks) = db_size X #queries
% 2) The junk results (e.g., the query itself) should be declared in the gnd stuct array
% 3) If there are no positive images for some query, that query is excluded from the evaluation

  if ~exist('kappas'), kappas = 0; end

  nq = numel (gnd);   % number of queries
  % init map and pr
  map = 0;
  aps = zeros (nq, 1);
  pr = zeros(1, numel(kappas));
  prs = zeros (nq, numel(kappas));
  nempty = 0;

  for i = 1:nq
    qgnd = gnd(i).ok; 

    if isempty(qgnd) % no positive at all, skip from the average
      aps (i) = nan;
      prs (i, :) = nan;
      nempty = nempty + 1;
      continue;
    end

    if isfield (gnd(i), 'junk')
      qgndj = gnd(i).junk; 
    else 
      qgndj = []; 
    end
    
  	% positions of positive and junk images
    [~, pos] = intersect (ranks (:,i), qgnd);
    [~, junk] = intersect (ranks (:,i), qgndj);

  	pos = sort(pos);
  	junk = sort(junk);

  	k = 0;  
  	ij = 1;

  	if length (junk)
  		% decrease positions of positives based on the number of junk images appearing before them
  		ip = 1;
  		while ip <= numel (pos)

  			while ( ij <= length (junk) & pos (ip) > junk (ij) )
  				k = k + 1;
  				ij = ij + 1;
  			end

  			pos (ip) = pos (ip) - k;
  			ip = ip + 1;
  		end
  	end

    % compute ap
    ap = score_ap_from_ranks1 (pos, length (qgnd));
    map = map + ap;
  	aps (i) = ap;

    % compute precision@k
    for j = 1:numel(kappas)
      kq = min(max(pos), kappas(j)); 
      prs(i, j) = numel(find(pos <= kq)) ./ kq;  
    end
    pr = pr + prs(i, :);

  end

  map = map / (nq-nempty);
  pr = pr / (nq-nempty);

end


% This function computes the AP for a query
function ap = score_ap_from_ranks1 (ranks, nres)

% number of images ranked by the system
nimgranks = length (ranks);  
ranks = ranks - 1;	
  
% accumulate trapezoids in PR-plot
ap = 0;

recall_step = 1 / nres;

for j = 1:nimgranks
  rank = ranks(j);
  
  if rank == 0
    precision_0 = 1.0;
  else
    precision_0 = (j - 1) / rank;
  end
  
  precision_1 = j / (rank + 1);
  ap = ap + (precision_0 + precision_1) * recall_step / 2;
end

end
