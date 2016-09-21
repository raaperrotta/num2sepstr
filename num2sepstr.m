function out = num2sepstr(numin,format,sep)
% NUM2SEPSTR Convert to string with comma separation at thousands.
%
% out = NUM2SEPSTR(numin,[format]) formats numin to a string
%   according to the specified format ('%f' by default) and adds thousands
%   seperators (commas by default).
%
% For non-scalar numin, num2sepstr outpts a cell array of the same shape
%   as numin where numin is called with the optional format on each value
%   in the n-D array, numin.
%
% String length from format, when specified, is applied before commas are
%   added; Instead of...
%
%   >> num2sepstr(1e6,'% 20.2f')
%   ...try...
%   >> sprintf('% 20s\n',num2sepstr(1e6,'%.2f'))
%
% See also SPRINTF, NUM2STR
%
% Created by:
%   Robert Perrotta

% Thanks to MathWorks community members Stephen Cobeldick and Andreas J.
% for suggesting a faster, cleaner implementation using regexp and
% regexprep.

if nargin < 2
    format = ''; % we choose a format below when we know numin is scalar and real
end
if nargin < 3
    sep = ',';
end

if numel(numin)>1
    out = cell(size(numin));
    for ii = 1:numel(numin)
        out{ii} = num2sepstr(numin(ii),format,sep);
    end
    return
end

if ~isreal(numin)
    out = sprintf('%s+%si',...
        num2sepstr(real(numin),format,sep),...
        num2sepstr(imag(numin),format,sep));
    return
end

if isempty(format)
    autoformat = true;
    if ~isinteger(numin) && mod(round(numin,4),1)
        format = '%.4f'; % 4 digits is the num2str default
    else
        format = '%.0f';
    end
else
    autoformat = false;
end

str = sprintf(format,numin);

if isempty(str)
    error('num2sepstr:num2str:invalidFormat','Invalid format.')
end

out = regexpi(str,'^(\D*\d{0,3})(\d{3})*(\D\d*)?$','tokens','once');
if numel(out)
    out = [out{1},regexprep(out{2},'(\d{3})',[sep,'$1']),out{3}];
else
    out = str;
end

if autoformat
    % trim trailing zeros after the decimal
    out = regexprep(out,'(\.\d*[1-9])(0*)','$1');
end

end

