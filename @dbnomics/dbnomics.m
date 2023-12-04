classdef dbnomics < handle
%DBNOMICS DBnomics connection.
%   C = DBNOMICS creates a 
%   DBnomics connection object. 
%
%   C = DBNOMICS(TIMEOUT) creates a 
%   DBnomics connection object.  TIMEOUT is the 
%   request value in seconds and input as a numeric value. The default 
%   value is 200 seconds. C is a dbnomics object.
%
%   For example,
%   
%   c = dbnomics
%
%   returns
%
%   c = 
%   
%     dbnomics with properties:
%   
%       TimeOut: 200.00
%
%   See also datasets, lastupdates, providers, search, series.

%   Copyright 2023 The MathWorks, Inc. 

  properties
    TimeOut {mustBeNumeric, mustBePositive} = 200
  end
  
  properties (Hidden = true)
    DebugModeValue {mustBeNumeric} = 0
    MediaType {mustBeText}         = "application/json"
    URL {mustBeText}               = matlab.net.URI("https://api.db.nomics.world/v22").EncodedURI
    Version 
  end
  
  
  methods (Access = 'public')
  
      function c = dbnomics(timeout,url,mediatype,debugmodevalue)
         
        arguments
          timeout (1,1) {mustBeNumeric} = 200
          url {mustBeTextScalar} = "https://api.db.nomics.world/v22"
          mediatype {mustBeTextScalar} = "application/json"
          debugmodevalue (1,1) {mustBeNumeric} = 0
        end

        % Set request timeout value
        c.TimeOut = timeout;
        
        % Create HTTP URL object
        c.URL = matlab.net.URI(url).EncodedURI;
        
        % Specify HTTP media type i.e. application content to deal with
        c.MediaType = string(matlab.net.http.MediaType(mediatype).MediaInfo);
        
        % Set http request debug value
        c.DebugModeValue = debugmodevalue;
        
        % Generate token
        method = "GET";
        eapPath = "";
        
        % Send request data
        response = dbnomicsApiEngine(c,method,eapPath);

        % Check for response error
        if isfield(response.Body.Data,"errors") 
          responseError = response.Body.Data.errors;
          error(message("datafeed:dbnomics:responseError",strcat(responseError.title," ",responseError.errorCode," ",string(responseError.status)," ",responseError.detail)))
        end

        % Get API version
        c.Version = string(response.Body.Data.x_meta.version);

      end 
  end

  methods (Access = protected)

      function response = dbnomicsApiEngine(c,httpMethod, eapPath)
      % DBNOMICSAPIENGINE Core request function used by all methods.

        HttpURI = matlab.net.URI(strcat(c.URL,eapPath));
        HttpHeader = matlab.net.http.HeaderField("Content-Type",c.MediaType);
        RequestMethod = matlab.net.http.RequestMethod(httpMethod);

        % Create the request message
        switch lower(httpMethod)

          case 'get'
            
            Request = matlab.net.http.RequestMessage(RequestMethod,HttpHeader);
            
          case 'post'
            
            HttpBody = matlab.net.http.MessageBody();
            HttpBody.Payload = jsonPayloadBytes;
            Request = matlab.net.http.RequestMessage(RequestMethod,HttpHeader,HttpBody);

        end

        % Set options
        options = matlab.net.http.HTTPOptions('ConnectTimeout',c.TimeOut,'Debug',c.DebugModeValue);

        % Send Request
        response = send(Request,HttpURI,options);

      end


      function apiString = createApiStringFromApiFlags(~,v)
      %CREATEAPISTRINGFROMAPIFLAGS Parse API flags in URL string for
      %request.

        % Initialize string
        apiString = "";

        % Add flags to string
        for i = 1:2:length(v)
    
          if i == 1
            % First flag follows ?
            apiString = strcat(apiString,"?",string(v{i}),"=",string(v{i+1}));
          else
            % Subsequent flags follow &
            apiString = strcat(apiString,"&",string(v{i}),"=",string(v{i+1}));
          end

        end

      end


  end



end