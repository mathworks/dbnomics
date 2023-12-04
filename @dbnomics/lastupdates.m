function [data,response] = lastupdates(c,varargin)
%LASTUPDATES DBnomics list of providers and datasets by creation/conversion date.
%   [DATA,RESPONSE] = LASTUPDATES(C) returns a list of providers and
%   datasets sorted by creation or conversion date given the dbnomics 
%   connection handle, C.
%
%   For example, 
%
%   [data,response] = lastupdates(c) 
%
%   DATA is returned as a table and RESPONSE is a ResponseMessage.
%   See also dbnomics.

%   Copyright 2023 The MathWorks, Inc. 

arguments
  c (1,1) dbnomics 
end

arguments (Repeating)
  varargin
end

% Create URL string for optional API flags
urlPath = "/last-updates";
apiString = createApiStringFromApiFlags(c,varargin);

response = dbnomicsApiEngine(c,"get",strcat(urlPath,apiString));

try
  data = struct2table(response.Body.Data,"AsArray",true);
  data.x_meta = struct2table(data.x_meta,"AsArray",true);
  data.datasets = struct2table(data.datasets,"AsArray",true);
  data.providers = struct2table(data.providers,"AsArray",true);
catch
  data = response;
end