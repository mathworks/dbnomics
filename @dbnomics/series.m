function [data,response] = series(c,providerCode,datasetCode,seriesCode,varargin)
%DATASETS DBnomics series request.
%   [DATA,RESPONSE] = SERIES(C) returns a list of DBnomics series by ID
%   from different providers and datasets given the dbnomics connection 
%   handle, C.
%
%   [DATA,RESPONSE] = SERIES(C,PROVIDERCODE,DATASETCODE) returns a list of
%   series belonging to the same dataset.   PROVIDERCODE input as character 
%   vector or string scalar and the DATASETCODE input as a character vector 
%   or string scalar.
%
%   [DATA,RESPONSE] = SERIES(C,PROVIDERCODE,DATASETCODE,SERIESCODE) returns 
%   information for the given SERIESCODE input as a character vector or
%   string scalar.
%
%   For example,
%
%   [data,response] = series(c)
%   [data,response] = series(c,"ECB","AME")
%   [data,response] = series(c,"ECB","AME","A.AUT.1.0.0.0.OVGD")
%
%   See also dbnomics.

%   Copyright 2023 The MathWorks, Inc. 

arguments
  c (1,1) dbnomics 
  providerCode {mustBeTextScalar} = ""
  datasetCode {mustBeTextScalar} = ""
  seriesCode {mustBeTextScalar} = ""
end

arguments (Repeating)
  varargin
end

% Create URL string given provider code and dataset code
if nargin < 4
  urlPath = strcat("/series/",providerCode,"/",datasetCode);
else
  urlPath = strcat("/series/",providerCode,"/",datasetCode,"/",seriesCode);
end

% Create URL string for optional API flags
apiString = createApiStringFromApiFlags(c,varargin);

response = dbnomicsApiEngine(c,"get",strcat(urlPath,apiString));

try
  data = struct2table(response.Body.Data,"AsArray",true);
catch
  data = response;
end