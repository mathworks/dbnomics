# Getting Started with DBnomics data in MATLAB&reg;

## Description

This interface allows users to access DBnomics data directly from MATLAB.  DBnomics is a free platform to aggregate publicly-available economic data provided by national and international statistical institutions, but also by researchers and private companies.

[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=mathworks/dbnomics)
## System Requirements

- MATLAB R2022a or later

## Features

Users can retrieve DBnomics data directly from MATLAB.   DBnomics documentation for Datasets, Last Updates, Providers, Search, and Series requests can be found here: 

https://https://api.db.nomics.world/v22/apidocs#/

A valid DBnomics connection is required for all requests.  Users can retrieve information required to make subsequent data requests.

## Create a DBnomics connection.

```MATLAB
c = dbnomics;
```

## Retrieve providers and datasets information

### Get all available datasets information for a provider or information for a specific dataset
```MATLAB
d = datasets(c,"ECB");
d = datasets(c,"ECB","AME");
```

### Get last update date information for providers and datasets
```MATLAB
d = lastupdates(c);
```

### Get providers information
```MATLAB
d = providers(c);
d = providers(c,"ECB");
```

### Search for datasets information with optional query text
```MATLAB
d = search(c);
d = search(c,q="Food and Agriculture");
```

### Get a list of series for providers and datasets
```MATLAB
d = series(c);
d = series(c,"ECB");
d = series(c,"ECB","AME");
d = series(c,"ECB","AME","A.AUT.1.0.0.0.OVGD");
```
### Use API flags to filter requested data.  For example,
```MATLAB
d = datasets(c,"ECB","",limit=50)
d = lastupdates(c,"datasets.limit",10,"providers.limit",5)
d = providers(c,"",limit=100,offset=50)
d = search(c,q="Food and Agriculture",limit=50,offset=10)
d = series(c,"","","",limit=100)
```

## License

The license is available in the LICENSE.TXT file in this GitHub repository.

Community Support

MATLAB Central

Copyright 2023 The MathWorks, Inc.
