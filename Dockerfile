FROM openresty/openresty:focal-amd64

WORKDIR /app

RUN apt update -y && apt upgrade -y
RUN apt install libssl-dev wget zip unzip git jq build-essential libcpuid-dev -y

# In case if we need to build Lua modules with rust:
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

RUN wget -O /usr/local/openresty/lualib/dkjson.lua http://dkolf.de/src/dkjson-lua.fsl/raw/dkjson.lua?name=6c6486a4a589ed9ae70654a2821e956650299228

RUN opm get bungle/lua-resty-jq

RUN wget https://luarocks.org/releases/luarocks-3.9.2.tar.gz  \
    && tar zxpf luarocks-3.9.2.tar.gz  \
    && cd luarocks-3.9.2 \
    && ./configure && make && make install

RUN luarocks install lapis && luarocks install markdown && luarocks install luafilesystem && luarocks install template

ENV PATH="$PATH:/root/.cargo/bin"

EXPOSE 80