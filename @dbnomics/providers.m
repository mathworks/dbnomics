function [data,response] = providers(c,providerCode,varargin)
%PROVIDERS DBnomics list of providers.
%   [DATA,RESPONSE] = PROVIDERS(C) returns a list of providers given the 
%   dbnomics connection handle, C.
%
%   [DATA,RESPONSE] = PROVIDERS(C,PROVIDERCODE) returns a provider with its
%   category tree given the dbnomics connection handle, C, and, the
%   PROVIDERCODE input as character vector or string scalar.
%
%   For example, 
%
%   [data,response] = providers(c)
%   [data,response] = providers(c,"ECB") 
%
%   DATA is returned as a table and RESPONSE is a ResponseMessage.

%   See also dbnomics.

%   Copyright 2023 The MathWorks, Inc. 

arguments
  c (1,1) dbnomics 
  providerCode {mustBeTextScalar} = ""
end

arguments (Repeating)
  varargin
end

% Create URL string given provider code
urlPath = strcat("/providers/",providerCode);

% Create URL string for optional API flags
apiString = createApiStringFromApiFlags(c,varargin);

% Make request
response = dbnomicsApiEngine(c,"get",strcat(urlPath,apiString));

% Convert output to table
try
  data = struct2table(response.Body.Data,"AsArray",true);
  data.x_meta = struct2table(data.x_meta,"AsArray",true);
  if any(strcmp("providers",data.Properties.VariableNames))
    data.providers = struct2table(data.providers,"AsArray",true);
  else
    data.category_tree{1} = struct2table(data.category_tree{:},"AsArray",true);
    data.provider = struct2table(data.provider,"AsArray",true);
  end
catch
  data = response;
end