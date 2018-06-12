function cfg  = configdataset (dataset, dir_main)

switch lower(dataset)

  case 'roxford5k'
    params.ext = '.jpg';
    params.qext = '.jpg';
    params.dir_data = [dir_main 'roxford5k/'];
    cfg = config_roxford (params);

  case 'rparis6k'
    params.ext = '.jpg';
    params.qext = '.jpg';    
    params.dir_data = [dir_main 'rparis6k/'];
    cfg = config_rparis (params);

  case 'revisitop1m'
    params.ext = '.jpg';
    params.dir_data = [dir_main 'revisitop1m/'];
    cfg = config_revisitop1m (params);

  otherwise, error ('Unkown dataset %s\n', dataset);
end

% some filename overwriting
cfg.dir_images = sprintf ('%s/jpg/', cfg.dir_data);

cfg.im_fname = @config_imname;
cfg.qim_fname = @config_qimname;

cfg.dataset = dataset;

%----------------------------------------------------
%----------------------------------------------------
function cfg = config_roxford (cfg)
  % Load groundtruth
  cfg.gnd_fname = [cfg.dir_data 'gnd_roxford5k.mat'];
  load (cfg.gnd_fname); % Retrieve list of image names, ground truth and query numbers
  cfg.imlist = imlist;
  cfg.qimlist = qimlist;  
  cfg.gnd = gnd;
  cfg.n = length (cfg.imlist);   % number of database images
  cfg.nq = length (cfg.qimlist);    % number of query images

%----------------------------------------------------
%----------------------------------------------------
function cfg = config_rparis (cfg)
  % Load groundtruth
  cfg.gnd_fname = [cfg.dir_data 'gnd_rparis6k.mat'];
  load (cfg.gnd_fname); % Retrieve list of image names, ground truth and query numbers
  cfg.imlist = imlist;
  cfg.qimlist = qimlist;  
  cfg.gnd = gnd;
  cfg.n = length (cfg.imlist);   % number of database images
  cfg.nq = length (cfg.qimlist);    % number of query images

%----------------------------------------------------
%----------------------------------------------------
function cfg = config_revisitop1m (cfg)
  % load image list
  cfg.imlist_fname = [cfg.dir_data 'revisitop1m.txt'];
  cfg.imlist = textread(cfg.imlist_fname, '%s');
  cfg.n = length (cfg.imlist);   % number of images

%----------------------------------------------------
%----------------------------------------------------
function fname = config_imname (cfg, i)
  [~, ~, ext] = fileparts(cfg.imlist{i});
  if isempty(ext)
    fname = sprintf ('%s/jpg/%s%s', cfg.dir_data, cfg.imlist{i}, cfg.ext);
  else
    fname = sprintf ('%s/jpg/%s', cfg.dir_data, cfg.imlist{i});
  end

%----------------------------------------------------
%----------------------------------------------------
function fname = config_qimname (cfg, i)
  [~, ~, ext] = fileparts(cfg.qimlist{i});
  if isempty(ext)
    fname = sprintf ('%s/jpg/%s%s', cfg.dir_data, cfg.qimlist{i}, cfg.qext);
  else
    fname = sprintf ('%s/jpg/%s', cfg.dir_data, cfg.qimlist{i});
  end
