function [data,response] = datasets(c,providerCode,datasetCode,varargin)
%DATASETS DBnomics datasets by provider.
%   [DATA,RESPONSE] = DATASETS(C,PROVIDERCODE) returns datasets of a
%   provider given the dbnomics connection handle, C, and, the
%   PROVIDERCODE input as character vector or string scalar.
%
%   [DATA,RESPONSE] = DATASETS(C,PROVIDERCODE) returns dataset information  
%   of a provider given the dbnomics connection handle, C, the
%   PROVIDERCODE input as character vector or string scalar, and the 
%   DATASETCODE input as a character vector or string scalar.
%
%   For example, 
%
%   [data,response] = datasets(c,"ECB") 
%   [data,response] = datasets(c,"ECB","AME")
%
%   DATA is returned as a table and RESPONSE is a ResponseMessage.

%   See also dbnomics.

%   Copyright 2023 The MathWorks, Inc. 

arguments
  c (1,1) dbnomics 
  providerCode {mustBeTextScalar}
  datasetCode {mustBeTextScalar} = ""
end

arguments (Repeating)
  varargin
end

% Create URL string given provider code and dataset code
if nargin < 3
  urlPath = strcat("/datasets/",providerCode);
else
  urlPath = strcat("/datasets/",providerCode,"/",datasetCode);
end

% Create URL string for optional API flags
apiString = createApiStringFromApiFlags(c,varargin);

response = dbnomicsApiEngine(c,"get",strcat(urlPath,apiString));

try
  if ~isempty(response.Body.Data.datasets.docs)
    data = struct2table(response.Body.Data.datasets.docs,"AsArray",true);
  else
    data = struct2table(response.Body.Data.datasets,"AsArray",true);
  end
catch
  data = response;
end