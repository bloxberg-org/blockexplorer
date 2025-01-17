FROM docker.io/bitwalker/alpine-elixir-phoenix:1.13

RUN apk --no-cache --update add alpine-sdk gmp-dev automake libtool inotify-tools autoconf python3 file qemu-x86_64

ENV GLIBC_REPO=https://github.com/sgerrand/alpine-pkg-glibc
ENV GLIBC_VERSION=2.30-r0

RUN set -ex && \
    apk --update add libstdc++ curl ca-certificates && \
    for pkg in glibc-${GLIBC_VERSION} glibc-bin-${GLIBC_VERSION}; \
        do curl -sSL ${GLIBC_REPO}/releases/download/${GLIBC_VERSION}/${pkg}.apk -o /tmp/${pkg}.apk; done && \
    apk add --allow-untrusted /tmp/*.apk && \
    rm -v /tmp/*.apk && \
    /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib

# Get Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

ENV PATH="$HOME/.cargo/bin:${PATH}"
ENV RUSTFLAGS="-C target-feature=-crt-static"

EXPOSE 4000

ENV PORT=4000 \
    MIX_ENV="prod" \
    SECRET_KEY_BASE="RMgI4C1HSkxsEjdhtGMfwAHfyT6CKWXOgzCboJflfSm4jeAlic52io05KB6mqzc5"

# Copies from env-file ###################################################################################################################
#DOCKER_TAG=
ENV MICROSERVICE_SC_VERIFIER_ENABLED=true
ENV MICROSERVICE_SC_VERIFIER_URL=http://blockexplorer-production-verify-auto-deploy:8050
ENV ETHEREUM_JSONRPC_VARIANT="parity"
#ETHEREUM_JSONRPC_HTTP_URL=http://host.docker.internal:8545/
ENV DATABASE_URL=postgresql://postgres:Awolpertingergoesaround45@blockexplorer-production-db-auto-deploy:5432/blockscout?ssl=false
#ETHEREUM_JSONRPC_TRACE_URL=http://host.docker.internal:8545/
ENV ETHEREUM_JSONRPC_HTTP_URL=https://core.bloxberg.org
# ENV ETHEREUM_JSONRPC_WS_URL=ws://core.bloxberg.org
ENV ETHEREUM_JSONRPC_TRACE_URL=https://core.bloxberg.org
ENV NETWORK=
ENV SUBNETWORK="bloxberg"
ENV LOGO=/images/bloxberg-logo_neue-Farben.png
ENV LOGO_FOOTER=/images/bloxberg-logo_neue-Farben.png
# ETHEREUM_JSONRPC_WS_URL=
ENV ETHEREUM_JSONRPC_TRANSPORT=http
ENV IPC_PATH=
ENV NETWORK_PATH=/
ENV API_PATH=/api/
ENV SOCKET_ROOT=/
ENV BLOCKSCOUT_HOST=blockexplorer.bloxberg.org
ENV BLOCKSCOUT_PROTOCOL=
# SECRET_KEY_BASE=
# CHECK_ORIGIN=
ENV PORT=4000
ENV NETWORK_IDLE_TIMEOUT=300000
ENV COIN=Berg
ENV COIN_NAME="Berg"
# COINGECKO_COIN_ID=
ENV METADATA_CONTRACT=0xf2cde379d6818db4a8992ed132345e18e99689e9
ENV VALIDATORS_CONTRACT=0x9850711951A84Ef8a2A31a7868d0dCa34B0661cA
# KEYS_MANAGER_CONTRACT=
# REWARDS_CONTRACT=
# TOKEN_BRIDGE_CONTRACT=
ENV EMISSION_FORMAT=DEFAULT
# CHAIN_SPEC_PATH=
# SUPPLY_MODULE=
# SOURCE_MODULE=
ENV POOL_SIZE=50
ENV POOL_SIZE_API=15
ENV ECTO_USE_SSL=false
# DATADOG_HOST=
# DATADOG_PORT=
# SPANDEX_BATCH_SIZE=
# SPANDEX_SYNC_THRESHOLD=
ENV HEART_BEAT_TIMEOUT=30
# HEART_COMMAND=
ENV BLOCKSCOUT_VERSION=
ENV RELEASE_LINK=0.1.1-4.1.3
ENV BLOCK_TRANSFORMER=base
# GRAPHIQL_TRANSACTION=
# FIRST_BLOCK=
# LAST_BLOCK=
# TRACE_FIRST_BLOCK=
# TRACE_LAST_BLOCK=
ENV LINK_TO_OTHER_EXPLORERS=false
ENV OTHER_EXPLORERS={}
ENV SUPPORTED_CHAINS='[ { "title": "bloxberg Mainnet", "url": "https://blockexplorer.bloxberg.org/" } ]'
ENV CACHE_BLOCK_COUNT_PERIOD=7200
ENV CACHE_TXS_COUNT_PERIOD=7200
ENV CACHE_ADDRESS_COUNT_PERIOD=7200
ENV CACHE_ADDRESS_SUM_PERIOD=3600
ENV CACHE_TOTAL_GAS_USAGE_PERIOD=3600
ENV CACHE_ADDRESS_TRANSACTIONS_GAS_USAGE_COUNTER_PERIOD=1800
ENV CACHE_TOKEN_HOLDERS_COUNTER_PERIOD=3600
ENV CACHE_TOKEN_TRANSFERS_COUNTER_PERIOD=3600
ENV CACHE_ADDRESS_WITH_BALANCES_UPDATE_INTERVAL=1800
ENV CACHE_AVERAGE_BLOCK_PERIOD=1800
ENV CACHE_MARKET_HISTORY_PERIOD=21600
ENV CACHE_ADDRESS_TRANSACTIONS_PERIOD=1800
ENV CACHE_ADDRESS_TOKENS_USD_SUM_PERIOD=1800
ENV CACHE_ADDRESS_TOKEN_TRANSFERS_COUNTER_PERIOD=1800
ENV CACHE_BRIDGE_MARKET_CAP_UPDATE_INTERVAL=1800
ENV CACHE_TOKEN_EXCHANGE_RATE_PERIOD=1800
ENV TOKEN_METADATA_UPDATE_INTERVAL=172800
ENV CONTRACT_VERIFICATION_ALLOWED_SOLIDITY_EVM_VERSIONS=homestead,tangerineWhistle,spuriousDragon,byzantium,constantinople,petersburg,istanbul,berlin,london,paris,shanghai,default
ENV CONTRACT_VERIFICATION_ALLOWED_VYPER_EVM_VERSIONS=byzantium,constantinople,petersburg,istanbul,berlin,paris,shanghai,default
ENV UNCLES_IN_AVERAGE_BLOCK_TIME=false
ENV DISABLE_WEBAPP=false
ENV DISABLE_READ_API=false
ENV DISABLE_WRITE_API=false
ENV DISABLE_INDEXER=false
ENV INDEXER_DISABLE_PENDING_TRANSACTIONS_FETCHER=false
ENV INDEXER_DISABLE_INTERNAL_TRANSACTIONS_FETCHER=false
ENV INDEXER_MEMORY_LIMIT=20
# ENV INDEXER_INTERNAL_TRANSACTIONS_BATCH_SIZE=50
# ENV INDEXER_INTERNAL_TRANSACTIONS_CONCURRENCY=5
# ENV INDEXER_CATCHUP_BLOCKS_BATCH_SIZE=100
# ENV INDEXER_CATCHUP_BLOCKS_CONCURRENCY=5
# ENV INDEXER_EMPTY_BLOCKS_SANITIZER_BATCH_SIZE=100
# ENV ETHEREUM_JSONRPC_HTTP_TIMEOUT=100
# ENV INDEXER_CATCHUP_BLOCK_INTERVAL = 6s
ENV WEBAPP_URL="https://bloxberg.org/"
# API_URL=
ENV WOBSERVER_ENABLED=false
ENV SHOW_ADDRESS_MARKETCAP_PERCENTAGE=true
ENV CHECKSUM_ADDRESS_HASHES=true
ENV CHECKSUM_FUNCTION=eth
ENV DISABLE_EXCHANGE_RATES=true
ENV DISABLE_KNOWN_TOKENS=false
ENV ENABLE_TXS_STATS=true
ENV SHOW_PRICE_CHART=false
ENV SHOW_TXS_CHART=true
ENV HISTORY_FETCH_INTERVAL=30
ENV TXS_HISTORIAN_INIT_LAG=0
ENV TXS_STATS_DAYS_TO_COMPILE_AT_INIT=10
ENV COIN_BALANCE_HISTORY_DAYS=90
ENV APPS_MENU=false
# ENV EXTERNAL_APPS='[ {"title": "Test_App", "url": "https://bloxberg.org/"} ]'
# ETH_OMNI_BRIDGE_MEDIATOR=
# BSC_OMNI_BRIDGE_MEDIATOR=
# AMB_BRIDGE_MEDIATORS=
# GAS_PRICE=
# FOREIGN_JSON_RPC=
# RESTRICTED_LIST=
# RESTRICTED_LIST_KEY=
ENV DISABLE_BRIDGE_MARKET_CAP_UPDATER=true
# POS_STAKING_CONTRACT=
ENV ENABLE_POS_STAKING_IN_MENU=false
ENV SHOW_MAINTENANCE_ALERT=false
ENV MAINTENANCE_ALERT_MESSAGE=
ENV SHOW_STAKING_WARNING=false
ENV STAKING_WARNING_MESSAGE=
ENV CUSTOM_CONTRACT_ADDRESSES_TEST_TOKEN=
ENV ENABLE_SOURCIFY_INTEGRATION=false
ENV SOURCIFY_SERVER_URL=
ENV SOURCIFY_REPO_URL=
# CHAIN_ID=
ENV MAX_SIZE_UNLESS_HIDE_ARRAY=50
ENV HIDE_BLOCK_MINER=false
ENV DISPLAY_TOKEN_ICONS=false
ENV SHOW_TENDERLY_LINK=false
ENV TENDERLY_CHAIN_PATH=
ENV MAX_STRING_LENGTH_WITHOUT_TRIMMING=2040
ENV RE_CAPTCHA_SECRET_KEY=
ENV RE_CAPTCHA_CLIENT_KEY=
# JSON_RPC=
ENV API_RATE_LIMIT=50
ENV API_RATE_LIMIT_BY_KEY=50
ENV API_RATE_LIMIT_BY_IP=5000
ENV API_RATE_LIMIT_WHITELISTED_IPS=["130.183.206.234","134.76.28.238","134.76.28.72","130.183.206.240","141.5.98.231"]
ENV API_RATE_LIMIT_STATIC_API_KEY=

####################################################################################################################################################

# Cache elixir deps
ADD mix.exs mix.lock ./
ADD apps/block_scout_web/mix.exs ./apps/block_scout_web/
ADD apps/explorer/mix.exs ./apps/explorer/
ADD apps/ethereum_jsonrpc/mix.exs ./apps/ethereum_jsonrpc/
ADD apps/indexer/mix.exs ./apps/indexer/

RUN mix do deps.get, local.rebar --force, deps.compile

ADD . .

RUN mix deps.get

ARG COIN
RUN if [ "$COIN" != "" ]; then \
        sed -i s/"POA"/"${COIN}"/g apps/block_scout_web/priv/gettext/en/LC_MESSAGES/default.po; \
        sed -i "/msgid \"Ether\"/{n;s/msgstr \"\"/msgstr \"${COIN}\"/g}" apps/block_scout_web/priv/gettext/default.pot; \
        sed -i "/msgid \"Ether\"/{n;s/msgstr \"\"/msgstr \"${COIN}\"/g}" apps/block_scout_web/priv/gettext/en/LC_MESSAGES/default.po; \
        sed -i "/msgid \"ETH\"/{n;s/msgstr \"\"/msgstr \"${COIN}\"/g}" apps/block_scout_web/priv/gettext/default.pot; \
        sed -i "/msgid \"ETH\"/{n;s/msgstr \"\"/msgstr \"${COIN}\"/g}" apps/block_scout_web/priv/gettext/en/LC_MESSAGES/default.po; \
    fi

# Run forderground build and phoenix digest
RUN mix compile

RUN npm install npm@latest

# Add blockscout npm deps
RUN cd apps/block_scout_web/assets/ && \
    npm install && \
    npm run deploy && \
    cd -

RUN cd apps/explorer/ && \
    npm install && \
    apk update && apk del --force-broken-world alpine-sdk gmp-dev automake libtool inotify-tools autoconf python3

RUN mix phx.digest

# CMD bash -c "bin/blockscout eval \"Elixir.Explorer.ReleaseTasks.create_and_migrate()\" && bin/blockscout start"
CMD mix do ecto.create, ecto.migrate, phx.server
