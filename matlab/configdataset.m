function cfg  = configdataset (dataset, dir_main)

switch lower(dataset)

  case 'oxford5k'
    params.ext = '.jpg';
    params.qext = '.jpg';
    params.dir_data= [dir_main 'oxford5k/'];
    cfg = config_oxford (params);

  case 'roxford5k'
    params.ext = '.jpg';
    params.qext = '.jpg';
    params.dir_data= [dir_main 'roxford5k/'];
    cfg = config_roxford (params);
    
  case 'paris6k'
    params.ext = '.jpg';
    params.qext = '.jpg';
    params.dir_data= [dir_main 'paris6k/'];
    cfg = config_paris (params);

  case 'rparis6k'
    params.ext = '.jpg';
    params.qext = '.jpg';    
    params.dir_data= [dir_main 'rparis6k/'];
    cfg = config_rparis (params);

  otherwise, error ('Unkown dataset %s\n', dataset);
end

% some filename overwriting
cfg.dir_images = sprintf ('%s/jpg/', cfg.dir_data);

cfg.im_fname = @config_imname;
cfg.qim_fname = @config_qimname;

cfg.dataset = dataset;

%----------------------------------------------------
%----------------------------------------------------
function cfg = config_oxford (cfg)
  % Load groundtruth
  cfg.gnd_fname = [cfg.dir_data 'gnd_oxford5k.mat'];
  load (cfg.gnd_fname); % Retrieve list of image names, ground truth and query numbers
  cfg.imlist = imlist;
  cfg.qimlist = {imlist{qidx}};  
  cfg.gnd = gnd;
  cfg.qidx = qidx;
  cfg.n = length (cfg.imlist);   % number of database images
  cfg.nq = length (cfg.qidx);    % number of query images

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
function cfg = config_paris (cfg)
  % Load groundtruth
  cfg.gnd_fname = [cfg.dir_data 'gnd_paris6k.mat'];
  load (cfg.gnd_fname); % Retrieve list of image names, ground truth and query numbers
  % Specific variables to handle paris's groundtruth
  cfg.imlist = imlist;
  cfg.qimlist = {imlist{qidx}};  
  cfg.gnd = gnd;
  cfg.qidx = qidx;
  cfg.n = length (cfg.imlist);   % number of database images
  cfg.nq = length (cfg.qidx);    % number of query images

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
