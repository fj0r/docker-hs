FROM nnurphy/deb

ENV STACK_ROOT=/opt/stack \
    HOME=/root \
    STACKAGE_VERSION=lts-14.1

RUN set -ex \
  ; apt-get update \
  ; apt-get install -y --no-install-recommends \
        libffi-dev libgmp-dev zlib1g-dev gnupg \
        libtinfo-dev libblas-dev liblapack-dev \
  ; apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

RUN set -ex \
  ; mkdir -p ${STACK_ROOT} && mkdir -p ${HOME}/.cabal \
#  ; scp up:~/pub/Configuration/stack/config.yaml ${STACK_ROOT}/config.yaml \
#  ; scp up:~/pub/Configuration/stack/config ${HOME}/.cabal/config \
  ; curl -sSL https://get.haskellstack.org/ | sh \
  ; stack config set system-ghc --global false && stack config set install-ghc --global true  \
  ; stack update && stack setup \
  ; stack install \
      hlint hindent highlight ghcid clock hashtables dlist binary store parsers megaparsec Earley \
      optparse-applicative shelly boomerang aeson yaml taggy cassava JuicyPixels diagrams \
      persistent mwc-random shake TCache MonadRandom monad-logger monad-journal \
      pipes conduit machines mustache cryptonite http-conduit wreq servant scotty wai \
      websockets warp smallcheck hspec extensible-exceptions criterion weigh deepseq \
      filepath directory hpc pretty process arithmoi hmatrix linear statistics ad integration \
      monad-par async stm classy-prelude reactive-banana uniplate singletons dimensional \
      free extensible-effects freer bound unbound-generics ghc-prim primitive memory array \
      bytestring containers template-haskell time transformers unix alex happy attoparsec fgl mtl \
      network QuickCheck parallel random call-stack regex-base regex-compat regex-posix syb \
      text hashable unordered-containers vector zlib multipart HTTP fixed html xhtml \
      transformers-compat network-uri flow lens \
  ; mkdir -p ${STACK_ROOT}/global-project \
  # 设置全局 stack resolver, 避免运行时重新安装 lts
  #; sed -i "s/^\(resolver:\).*$/\1 ${STACKAGE_VERSION}/g" ${STACK_ROOT}/global-project/stack.yaml \
  ; rm -rf ${STACK_ROOT}/programs/x86_64-linux/*.tar.xz \
  ; rm -rf ${STACK_ROOT}/pantry/hackage/* \
  ; stack install flow

COPY .ghci ${HOME}/.ghci
