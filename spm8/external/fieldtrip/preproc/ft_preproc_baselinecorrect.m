function [dat, baseline] = ft_preproc_baselinecorrect(dat, begsample, endsample)

% FT_PREPROC_BASELINECORRECT performs a baseline correction, e.g. using the
% prestimulus interval of the data or using the complete data
%
% Use as
%   [dat] = ft_preproc_baselinecorrect(dat, begin, end)
% where
%   dat        data matrix (Nchans X Ntime)
%   begsample  index of the begin sample for the baseline estimate
%   endsample  index of the end sample for the baseline estimate
%
% If no begin and end sample are specified for the baseline estimate, it
% will be estimated on the complete data.
%
% See also PREPROC

% Copyright (C) 1998-2008, Robert Oostenveld
%
% This file is part of FieldTrip, see http://www.ru.nl/neuroimaging/fieldtrip
% for the documentation and details.
%
%    FieldTrip is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    FieldTrip is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with FieldTrip. If not, see <http://www.gnu.org/licenses/>.
%
% $Id: ft_preproc_baselinecorrect.m 2271 2010-12-03 09:01:26Z jansch $

persistent hasbsxfun
if isempty(hasbsxfun)
  hasbsxfun = exist('bsxfun', 'builtin')==5;
end

% determine the size of the data
[Nchans, Nsamples] = size(dat);

% determine the interval to use for baseline correction
if nargin<2 || isempty(begsample)
  begsample = 1;
end
if nargin<3 || isempty(endsample)
  endsample = Nsamples;
end

% estimate the baseline and subtract it
baseline = mean(dat(:,begsample:endsample), 2);

if hasbsxfun
  % it is even faster to do this
  dat = bsxfun(@minus,dat,baseline);
else
  % it is faster to loop over samples than over channels due to the internal memory representation of Matlab
  % for chan=1:Nchans
  %  dat(chan,:) = dat(chan,:) - baseline(chan);
  % end
  
  for sample=1:Nsamples
    dat(:,sample) = dat(:,sample) - baseline;
  end
end
