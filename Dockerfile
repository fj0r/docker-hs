FROM nnurphy/ub

ENV STACKAGE_VERSION=lts-16.0
ENV STACK_ROOT=/opt/stack
ENV PATH=${HOME}/.local/bin:$PATH

RUN set -ex \
  ; apt-get update \
  ; apt-get install -y --no-install-recommends \
        libffi-dev libgmp-dev zlib1g-dev \
        libtinfo-dev libblas-dev liblapack-dev \
  ; apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

RUN set -ex \
  ; mkdir -p ${STACK_ROOT} && mkdir -p ${HOME}/.cabal \
  # ; wget -q https://github.com/commercialhaskell/stack/releases/download/v2.3.1/stack-2.3.1-linux-x86_64-bin \
  #     -O /usr/local/bin/stack \
  # ; chmod +x /usr/local/bin/stack \
  ; curl -sSL https://get.haskellstack.org/ | sh \
  ; stack config set system-ghc --global false && stack config set install-ghc --global true  \
  ; stack update && stack setup \
  # JuicyPixels xhtml criterion weigh alex happy
  # cassava diagrams \
  # hmatrix linear statistics ad integration arithmoi \
  # regex-base regex-posix regex-compat \
  ; stack install --no-interleaved-output \
      ghcid hlint highlight \
      haskell-dap ghci-dap haskell-debug-adapter \
      optparse-applicative shelly process unix \
      time clock hpc pretty filepath directory zlib \
      array hashtables dlist binary bytestring text \
      containers hashable unordered-containers vector \
      deepseq call-stack primitive ghc-prim \
      template-haskell aeson yaml taggy mustache \
      flow lens recursion-schemes fixed mtl fgl \
      parsers megaparsec Earley boomerang \
      free extensible-effects extensible-exceptions freer \
      bound unbound-generics \
      transformers transformers-compat \
      syb uniplate singletons dimensional \
  ; stack install --no-interleaved-output \
      monad-par parallel async stm classy-prelude \
      persistent memory cryptonite \
      mwc-random MonadRandom random \
      monad-logger monad-journal \
      pipes conduit machines \
      http-conduit wreq HTTP html websockets multipart\
      servant scotty wai network network-uri warp \
      QuickCheck smallcheck hspec \
  ; mkdir -p ${STACK_ROOT}/global-project \
  # 设置全局 stack resolver, 避免运行时重新安装 lts
  #; sed -i "s/^\(resolver:\).*$/\1 ${STACKAGE_VERSION}/g" ${STACK_ROOT}/global-project/stack.yaml \
  ; rm -rf ${STACK_ROOT}/programs/x86_64-linux/*.tar.xz \
  ; rm -rf ${STACK_ROOT}/pantry/hackage/* \
  ; stack install flow \
  ; stack new hello && rm -rf hello

COPY .ghci $HOME
COPY config.tuna.yaml /opt/stack/config.yaml
