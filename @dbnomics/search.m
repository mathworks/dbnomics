function [data,response] = search(c,varargin)
%SEARCH DBnomics list of datasets from text search.
%   [DATA,RESPONSE] = SEARCH(C) returns the list of DBnomics datasets given 
%   the dbnomics connection handle, C.
%
%   [DATA,RESPONSE] = SEARCH(C,VARARGIN) returns a list of DBnomics
%   datasets given API search parameters.
%
%   For example, 
%
%   [data,response] = search(c)
%   [data,response] = search(c,q="Food and Agriculture")

%   See also dbnomics.

%   Copyright 2023 The MathWorks, Inc. 

arguments
  c (1,1) dbnomics 
end

arguments (Repeating)
  varargin
end

% Create URL string for optional API flags, replace spaces with %20
urlPath = "/search";
apiString = replace(createApiStringFromApiFlags(c,varargin)," ","%20");

response = dbnomicsApiEngine(c,"get",strcat(urlPath,apiString));

try
  data = struct2table(response.Body.Data.results,"AsArray",true);
catch
  data = response;
end