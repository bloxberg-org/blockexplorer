# Boxberg Changes

## Configuration

### Dockerfile (large changes)

A dockerfile can be found in the root directory. This file configures all the important environment variables for the blockexplorer.  
There is also a directory: _/docker_ containing a dockerfile. This can be ignored.  
Most large-scale configurations can be made here.

### Style (smaller changes)

The style of the blockexplorer can be configured in the individual scss files in _apps/block_scout_web/assets/css_.  
The most important variables can be configured in
_apps/block_scout_web/assets/css/theme/\_updated_theme_variables_.scss".  
Smaller changes have to be made in the corresponding files of the components in _apps/block_scout_web/assets/css/components_.

## Running Locally

The run the blockexplorer locally:

1. Clone the repository
2. Navigate to /docker-compose
3. Replace _/location/of/your/db_ with the location where the DB is located/should be created in _docker-compose/docker-compose.yml_
4. Run (sudo) docker-compose up

## URL Endpoint Added

{BaseURL}/api?module is now {BaseURL}/api/api?module for the URL Endpoint.
The modified code is found in the valid api request path function of the new-blockscout-client/apps/block scout web/lib/block scout web/controllers/api/rpc/rpc translator.ex file. There is now a new condition added: conn.request path == "/api/api".

## Logos of each university are added

To add the logo of the university first add the logo.png image to ( /new-blockscout-client/apps/block_scout_web/assets/static/images) folder.Then copy the node address, remove the leading 0x, and type it in all capital letters in the miner_logo function. location of the page (new-blockscout-client/apps/block_scout_web/lib/block_scout_web/views/block_view.ex)
